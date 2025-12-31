-- Daily Challenges System Migration
-- This adds the daily challenge feature with streak tracking and leaderboards

-- ============================================
-- TABLES
-- ============================================

-- Daily Challenges Table
CREATE TABLE IF NOT EXISTS daily_challenges (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  problem_id TEXT NOT NULL REFERENCES problems(id) ON DELETE CASCADE,
  challenge_date DATE UNIQUE NOT NULL,
  difficulty TEXT NOT NULL CHECK (difficulty IN ('easy', 'medium', 'hard')),
  featured_reason TEXT,
  xp_bonus INTEGER DEFAULT 100, -- Bonus XP for completing daily challenge
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- User Daily Challenge Completions
CREATE TABLE IF NOT EXISTS user_daily_challenge_completions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  challenge_id UUID NOT NULL REFERENCES daily_challenges(id) ON DELETE CASCADE,
  completed_at TIMESTAMPTZ DEFAULT NOW(),
  time_taken INTEGER, -- in seconds
  attempts INTEGER DEFAULT 1,
  UNIQUE(user_id, challenge_id)
);

-- User Streak Tracking
CREATE TABLE IF NOT EXISTS user_daily_streaks (
  user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  current_streak INTEGER DEFAULT 0,
  longest_streak INTEGER DEFAULT 0,
  last_completed_date DATE,
  total_challenges_completed INTEGER DEFAULT 0,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- INDEXES
-- ============================================

CREATE INDEX IF NOT EXISTS idx_daily_challenges_date ON daily_challenges(challenge_date DESC);
CREATE INDEX IF NOT EXISTS idx_daily_challenges_problem ON daily_challenges(problem_id);
CREATE INDEX IF NOT EXISTS idx_user_completions_user ON user_daily_challenge_completions(user_id);
CREATE INDEX IF NOT EXISTS idx_user_completions_challenge ON user_daily_challenge_completions(challenge_id);
CREATE INDEX IF NOT EXISTS idx_user_completions_time ON user_daily_challenge_completions(completed_at DESC);

-- ============================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================

-- Enable RLS
ALTER TABLE daily_challenges ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_daily_challenge_completions ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_daily_streaks ENABLE ROW LEVEL SECURITY;

-- Daily Challenges Policies (Public Read)
CREATE POLICY "Anyone can view daily challenges"
  ON daily_challenges FOR SELECT
  USING (true);

CREATE POLICY "Only authenticated users can create challenges"
  ON daily_challenges FOR INSERT
  WITH CHECK (auth.role() = 'authenticated');

-- User Completions Policies
CREATE POLICY "Users can view their own completions"
  ON user_daily_challenge_completions FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own completions"
  ON user_daily_challenge_completions FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can view all completions for leaderboard"
  ON user_daily_challenge_completions FOR SELECT
  USING (true);

-- User Streaks Policies
CREATE POLICY "Users can view their own streak"
  ON user_daily_streaks FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own streak"
  ON user_daily_streaks FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own streak"
  ON user_daily_streaks FOR UPDATE
  USING (auth.uid() = user_id);

-- ============================================
-- FUNCTIONS
-- ============================================

-- Function to update streak when user completes challenge
CREATE OR REPLACE FUNCTION update_user_streak()
RETURNS TRIGGER AS $$
DECLARE
  v_last_date DATE;
  v_current_streak INTEGER;
  v_longest_streak INTEGER;
  v_total INTEGER;
  v_challenge_date DATE;
BEGIN
  -- Get the challenge date
  SELECT challenge_date INTO v_challenge_date
  FROM daily_challenges
  WHERE id = NEW.challenge_id;

  -- Get or create user streak record
  SELECT last_completed_date, current_streak, longest_streak, total_challenges_completed
  INTO v_last_date, v_current_streak, v_longest_streak, v_total
  FROM user_daily_streaks
  WHERE user_id = NEW.user_id;

  -- If no record exists, create one
  IF NOT FOUND THEN
    INSERT INTO user_daily_streaks (user_id, current_streak, longest_streak, last_completed_date, total_challenges_completed)
    VALUES (NEW.user_id, 1, 1, v_challenge_date, 1);
    RETURN NEW;
  END IF;

  -- Calculate new streak
  IF v_last_date IS NULL THEN
    v_current_streak := 1;
  ELSIF v_challenge_date = v_last_date + INTERVAL '1 day' THEN
    -- Consecutive day
    v_current_streak := v_current_streak + 1;
  ELSIF v_challenge_date = v_last_date THEN
    -- Same day, don't update streak
    RETURN NEW;
  ELSE
    -- Streak broken
    v_current_streak := 1;
  END IF;

  -- Update longest streak
  IF v_current_streak > v_longest_streak THEN
    v_longest_streak := v_current_streak;
  END IF;

  -- Update streak record
  UPDATE user_daily_streaks
  SET 
    current_streak = v_current_streak,
    longest_streak = v_longest_streak,
    last_completed_date = v_challenge_date,
    total_challenges_completed = v_total + 1,
    updated_at = NOW()
  WHERE user_id = NEW.user_id;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to update streak on completion
DROP TRIGGER IF EXISTS trigger_update_streak ON user_daily_challenge_completions;
CREATE TRIGGER trigger_update_streak
  AFTER INSERT ON user_daily_challenge_completions
  FOR EACH ROW
  EXECUTE FUNCTION update_user_streak();

-- ============================================
-- SEED DATA (Create challenges for next 7 days)
-- ============================================

-- Note: This will be handled by Edge Function cron job
-- For initial setup, create today's challenge manually
INSERT INTO daily_challenges (problem_id, challenge_date, difficulty, featured_reason, xp_bonus)
SELECT 
  id,
  CURRENT_DATE,
  difficulty,
  'Featured daily challenge - solve for bonus XP!',
  100
FROM problems
WHERE difficulty = 'medium'
ORDER BY RANDOM()
LIMIT 1
ON CONFLICT (challenge_date) DO NOTHING;

-- ============================================
-- HELPER VIEWS
-- ============================================

-- View for daily challenge leaderboard
CREATE OR REPLACE VIEW daily_challenge_leaderboard AS
SELECT 
  dc.challenge_date,
  dc.problem_id,
  udc.user_id,
  up.username,
  up.avatar_url,
  udc.completed_at,
  udc.time_taken,
  udc.attempts,
  ROW_NUMBER() OVER (PARTITION BY dc.challenge_date ORDER BY udc.completed_at ASC) as rank
FROM daily_challenges dc
JOIN user_daily_challenge_completions udc ON dc.id = udc.challenge_id
LEFT JOIN user_profiles up ON udc.user_id = up.id
ORDER BY dc.challenge_date DESC, udc.completed_at ASC;

-- View for user streak stats
CREATE OR REPLACE VIEW user_streak_stats AS
SELECT 
  uds.user_id,
  up.username,
  up.avatar_url,
  uds.current_streak,
  uds.longest_streak,
  uds.total_challenges_completed,
  uds.last_completed_date
FROM user_daily_streaks uds
LEFT JOIN user_profiles up ON uds.user_id = up.id
ORDER BY uds.current_streak DESC, uds.longest_streak DESC;

COMMENT ON TABLE daily_challenges IS 'Stores daily coding challenges rotated automatically';
COMMENT ON TABLE user_daily_challenge_completions IS 'Tracks which users completed which daily challenges';
COMMENT ON TABLE user_daily_streaks IS 'Tracks user streaks for completing consecutive daily challenges';
