-- Create user_profiles table
CREATE TABLE IF NOT EXISTS user_profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name TEXT,
  email TEXT,
  current_streak INTEGER DEFAULT 0,
  longest_streak INTEGER DEFAULT 0,
  last_activity_date DATE,
  total_problems_solved INTEGER DEFAULT 0,
  total_time_spent INTEGER DEFAULT 0, -- in minutes
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create user_problem_progress table
CREATE TABLE IF NOT EXISTS user_problem_progress (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  problem_id TEXT NOT NULL,
  track_slug TEXT NOT NULL,
  difficulty TEXT NOT NULL,
  solved BOOLEAN DEFAULT false,
  attempts INTEGER DEFAULT 0,
  time_spent INTEGER DEFAULT 0, -- in minutes
  last_attempted_at TIMESTAMP WITH TIME ZONE,
  solved_at TIMESTAMP WITH TIME ZONE,
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, problem_id)
);

-- Create user_track_progress table
CREATE TABLE IF NOT EXISTS user_track_progress (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  track_slug TEXT NOT NULL,
  problems_solved INTEGER DEFAULT 0,
  total_problems INTEGER NOT NULL,
  progress_percentage INTEGER DEFAULT 0,
  last_activity_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, track_slug)
);

-- Create user_daily_activity table (for streak tracking)
CREATE TABLE IF NOT EXISTS user_daily_activity (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  activity_date DATE NOT NULL,
  problems_solved INTEGER DEFAULT 0,
  time_spent INTEGER DEFAULT 0, -- in minutes
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, activity_date)
);

-- Create daily_tasks table (for daily planner)
CREATE TABLE IF NOT EXISTS daily_tasks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  date DATE NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('ongoing', 'completed', 'missed')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_user_problem_progress_user_id ON user_problem_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_user_problem_progress_problem_id ON user_problem_progress(problem_id);
CREATE INDEX IF NOT EXISTS idx_user_problem_progress_solved ON user_problem_progress(user_id, solved);
CREATE INDEX IF NOT EXISTS idx_user_track_progress_user_id ON user_track_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_user_daily_activity_user_id ON user_daily_activity(user_id);
CREATE INDEX IF NOT EXISTS idx_user_daily_activity_date ON user_daily_activity(user_id, activity_date);
CREATE INDEX IF NOT EXISTS idx_daily_tasks_user_id ON daily_tasks(user_id);
CREATE INDEX IF NOT EXISTS idx_daily_tasks_date ON daily_tasks(user_id, date);

-- Enable Row Level Security
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_problem_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_track_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_daily_activity ENABLE ROW LEVEL SECURITY;
ALTER TABLE daily_tasks ENABLE ROW LEVEL SECURITY;

-- Create RLS policies for user_profiles
CREATE POLICY "Users can view own profile" ON user_profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON user_profiles
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON user_profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

-- Create RLS policies for user_problem_progress
CREATE POLICY "Users can view own problem progress" ON user_problem_progress
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own problem progress" ON user_problem_progress
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own problem progress" ON user_problem_progress
  FOR UPDATE USING (auth.uid() = user_id);

-- Create RLS policies for user_track_progress
CREATE POLICY "Users can view own track progress" ON user_track_progress
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own track progress" ON user_track_progress
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own track progress" ON user_track_progress
  FOR UPDATE USING (auth.uid() = user_id);

-- Create RLS policies for user_daily_activity
CREATE POLICY "Users can view own daily activity" ON user_daily_activity
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own daily activity" ON user_daily_activity
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own daily activity" ON user_daily_activity
  FOR UPDATE USING (auth.uid() = user_id);

-- Create RLS policies for daily_tasks
CREATE POLICY "Users can view own tasks" ON daily_tasks
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own tasks" ON daily_tasks
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own tasks" ON daily_tasks
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own tasks" ON daily_tasks
  FOR DELETE USING (auth.uid() = user_id);

-- Function to automatically create user profile on signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.user_profiles (id, full_name, email)
  VALUES (
    NEW.id,
    NEW.raw_user_meta_data->>'full_name',
    NEW.email
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to create profile on user signup
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Function to update streak
CREATE OR REPLACE FUNCTION update_user_streak(p_user_id UUID)
RETURNS void AS $$
DECLARE
  v_last_activity DATE;
  v_current_streak INTEGER;
  v_today DATE := CURRENT_DATE;
BEGIN
  -- Get last activity date and current streak
  SELECT last_activity_date, current_streak
  INTO v_last_activity, v_current_streak
  FROM user_profiles
  WHERE id = p_user_id;

  -- If no last activity or last activity was not yesterday or today
  IF v_last_activity IS NULL THEN
    -- First activity
    UPDATE user_profiles
    SET current_streak = 1,
        longest_streak = GREATEST(longest_streak, 1),
        last_activity_date = v_today
    WHERE id = p_user_id;
  ELSIF v_last_activity = v_today THEN
    -- Already active today, do nothing
    RETURN;
  ELSIF v_last_activity = v_today - INTERVAL '1 day' THEN
    -- Continuing streak
    UPDATE user_profiles
    SET current_streak = current_streak + 1,
        longest_streak = GREATEST(longest_streak, current_streak + 1),
        last_activity_date = v_today
    WHERE id = p_user_id;
  ELSE
    -- Streak broken, start new
    UPDATE user_profiles
    SET current_streak = 1,
        last_activity_date = v_today
    WHERE id = p_user_id;
  END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
