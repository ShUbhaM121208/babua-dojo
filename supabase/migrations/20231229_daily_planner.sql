-- Add this to your existing migration or run separately after the main migration

-- Create daily_tasks table (for daily planner feature)
CREATE TABLE IF NOT EXISTS daily_tasks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  date DATE NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('ongoing', 'completed', 'missed')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_daily_tasks_user_id ON daily_tasks(user_id);
CREATE INDEX IF NOT EXISTS idx_daily_tasks_date ON daily_tasks(user_id, date);

-- Enable RLS
ALTER TABLE daily_tasks ENABLE ROW LEVEL SECURITY;

-- Create RLS policies
CREATE POLICY "Users can view own tasks" ON daily_tasks
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own tasks" ON daily_tasks
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own tasks" ON daily_tasks
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own tasks" ON daily_tasks
  FOR DELETE USING (auth.uid() = user_id);
