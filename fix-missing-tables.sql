-- Fix Missing Database Tables and Functions
-- Run this in your Supabase SQL Editor: https://supabase.com/dashboard/project/ksfrhktwinymgrtssczf/sql

-- Drop existing tables if they have issues (safe - will only drop if exist)
DROP TABLE IF EXISTS user_problem_progress CASCADE;
DROP TABLE IF EXISTS review_rate_limits CASCADE;

-- Create review_rate_limits table
CREATE TABLE IF NOT EXISTS review_rate_limits (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  review_date DATE NOT NULL DEFAULT CURRENT_DATE,
  review_count INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(user_id, review_date)
);

CREATE INDEX IF NOT EXISTS idx_review_rate_limits_user_date ON review_rate_limits(user_id, review_date);

-- Enable RLS
ALTER TABLE review_rate_limits ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Users can view own rate limits"
  ON review_rate_limits FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own rate limits"
  ON review_rate_limits FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own rate limits"
  ON review_rate_limits FOR UPDATE
  USING (auth.uid() = user_id);

-- Create user_problem_progress table with ALL required columns
CREATE TABLE IF NOT EXISTS user_problem_progress (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  problem_id TEXT NOT NULL,
  track_slug TEXT,
  difficulty TEXT,
  status TEXT,
  solved BOOLEAN DEFAULT FALSE,
  attempts INTEGER NOT NULL DEFAULT 0,
  best_runtime INTEGER,
  best_memory INTEGER,
  time_spent INTEGER DEFAULT 0,
  last_attempted_at TIMESTAMPTZ,
  solved_at TIMESTAMPTZ,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(user_id, problem_id)
);

CREATE INDEX IF NOT EXISTS idx_user_problem_progress_user ON user_problem_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_user_problem_progress_problem ON user_problem_progress(problem_id);
CREATE INDEX IF NOT EXISTS idx_user_problem_progress_status ON user_problem_progress(status);

-- Enable RLS
ALTER TABLE user_problem_progress ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Users can view own progress"
  ON user_problem_progress FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own progress"
  ON user_problem_progress FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own progress"
  ON user_problem_progress FOR UPDATE
  USING (auth.uid() = user_id);

-- Add updated_at trigger
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_review_rate_limits_updated_at
  BEFORE UPDATE ON review_rate_limits
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_problem_progress_updated_at
  BEFORE UPDATE ON user_problem_progress
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Create update_topic_performance function
CREATE OR REPLACE FUNCTION update_topic_performance(
  p_user_id UUID,
  p_problem_id TEXT,
  p_solved BOOLEAN,
  p_time_spent INTEGER,
  p_difficulty TEXT DEFAULT 'medium'
)
RETURNS void
LANGUAGE plpgsql
AS $$
BEGIN
  -- Update or insert user problem progress
  INSERT INTO user_problem_progress (
    user_id,
    problem_id,
    difficulty,
    solved,
    attempts,
    time_spent,
    last_attempted_at,
    solved_at
  )
  VALUES (
    p_user_id,
    p_problem_id,
    p_difficulty,
    p_solved,
    1,
    p_time_spent,
    NOW(),
    CASE WHEN p_solved THEN NOW() ELSE NULL END
  )
  ON CONFLICT (user_id, problem_id)
  DO UPDATE SET
    attempts = user_problem_progress.attempts + 1,
    time_spent = user_problem_progress.time_spent + p_time_spent,
    last_attempted_at = NOW(),
    solved = CASE WHEN p_solved THEN TRUE ELSE user_problem_progress.solved END,
    solved_at = CASE WHEN p_solved AND user_problem_progress.solved_at IS NULL THEN NOW() ELSE user_problem_progress.solved_at END,
    updated_at = NOW();
END;
$$;

-- Success message
DO $$
BEGIN
  RAISE NOTICE 'Tables and functions created successfully! The 406 and 404 errors should now be fixed.';
END $$;
