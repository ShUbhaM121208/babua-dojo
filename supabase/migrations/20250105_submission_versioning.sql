-- Migration: Time Travel Submissions - Versioned submission history
-- This enables tracking all code attempts with diff viewing and analytics

-- Create submissions table with versioning
CREATE TABLE IF NOT EXISTS problem_submissions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  problem_id TEXT NOT NULL REFERENCES problems(id) ON DELETE CASCADE,
  version INTEGER NOT NULL DEFAULT 1,
  language TEXT NOT NULL,
  code TEXT NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('accepted', 'wrong_answer', 'runtime_error', 'compile_error', 'time_limit_exceeded', 'memory_limit_exceeded')),
  test_results JSONB NOT NULL DEFAULT '[]'::jsonb, -- Array of test case results
  passed_count INTEGER NOT NULL DEFAULT 0,
  failed_count INTEGER NOT NULL DEFAULT 0,
  total_time DECIMAL DEFAULT 0,
  memory_used INTEGER DEFAULT 0, -- KB
  all_passed BOOLEAN NOT NULL DEFAULT false,
  error_message TEXT,
  submitted_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()) NOT NULL,
  
  -- Ensure version uniqueness per user/problem combination
  UNIQUE(user_id, problem_id, version)
);

-- Add indexes for performance
CREATE INDEX idx_submissions_user_problem ON problem_submissions(user_id, problem_id, submitted_at DESC);
CREATE INDEX idx_submissions_status ON problem_submissions(user_id, status);
CREATE INDEX idx_submissions_latest ON problem_submissions(user_id, problem_id, version DESC);

-- Create view for latest submissions per problem
CREATE OR REPLACE VIEW latest_submissions AS
SELECT DISTINCT ON (user_id, problem_id)
  id,
  user_id,
  problem_id,
  version,
  language,
  code,
  status,
  test_results,
  passed_count,
  failed_count,
  total_time,
  memory_used,
  all_passed,
  error_message,
  submitted_at
FROM problem_submissions
ORDER BY user_id, problem_id, version DESC;

-- Create view for submission statistics per problem
CREATE OR REPLACE VIEW submission_stats AS
WITH time_diffs AS (
  SELECT
    user_id,
    problem_id,
    version,
    all_passed,
    total_time,
    memory_used,
    submitted_at,
    CASE 
      WHEN version > 1 THEN 
        EXTRACT(EPOCH FROM (submitted_at - LAG(submitted_at) OVER (PARTITION BY user_id, problem_id ORDER BY version))) / 60
      ELSE NULL
    END as time_since_last_minutes
  FROM problem_submissions
)
SELECT
  user_id,
  problem_id,
  COUNT(*) as total_attempts,
  MAX(version) as latest_version,
  MIN(submitted_at) as first_attempt_at,
  MAX(submitted_at) as latest_attempt_at,
  COUNT(CASE WHEN all_passed THEN 1 END) as successful_attempts,
  COUNT(CASE WHEN all_passed THEN 1 END)::DECIMAL / NULLIF(COUNT(*)::DECIMAL, 0) * 100 as success_rate,
  AVG(time_since_last_minutes) as avg_time_between_attempts_minutes,
  MIN(CASE WHEN all_passed THEN version END) as first_success_version,
  MIN(CASE WHEN all_passed THEN total_time END) as best_time,
  MIN(CASE WHEN all_passed THEN memory_used END) as best_memory
FROM time_diffs
GROUP BY user_id, problem_id;

-- Function to get next version number for a submission
CREATE OR REPLACE FUNCTION get_next_submission_version(
  p_user_id UUID,
  p_problem_id TEXT
)
RETURNS INTEGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_next_version INTEGER;
BEGIN
  SELECT COALESCE(MAX(version), 0) + 1
  INTO v_next_version
  FROM problem_submissions
  WHERE user_id = p_user_id AND problem_id = p_problem_id;
  
  RETURN v_next_version;
END;
$$;

-- Function to auto-increment version on insert
CREATE OR REPLACE FUNCTION set_submission_version()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  IF NEW.version IS NULL OR NEW.version = 1 THEN
    NEW.version := get_next_submission_version(NEW.user_id, NEW.problem_id);
  END IF;
  RETURN NEW;
END;
$$;

-- Trigger to auto-set version
CREATE TRIGGER trigger_set_submission_version
  BEFORE INSERT ON problem_submissions
  FOR EACH ROW
  EXECUTE FUNCTION set_submission_version();

-- RLS policies
ALTER TABLE problem_submissions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own submissions"
  ON problem_submissions FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own submissions"
  ON problem_submissions FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own submissions"
  ON problem_submissions FOR UPDATE
  USING (auth.uid() = user_id);

-- Grant permissions
GRANT SELECT ON problem_submissions TO authenticated;
GRANT INSERT ON problem_submissions TO authenticated;
GRANT UPDATE ON problem_submissions TO authenticated;
GRANT SELECT ON latest_submissions TO authenticated;
GRANT SELECT ON submission_stats TO authenticated;

-- Create user progress table if it doesn't exist (for tracking solved problems)
CREATE TABLE IF NOT EXISTS user_problem_progress (
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  problem_id TEXT NOT NULL REFERENCES problems(id) ON DELETE CASCADE,
  status TEXT NOT NULL CHECK (status IN ('not_started', 'attempted', 'solved')),
  last_attempted_at TIMESTAMPTZ,
  solved_at TIMESTAMPTZ,
  best_time DECIMAL,
  best_memory INTEGER,
  total_attempts INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()) NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()) NOT NULL,
  
  PRIMARY KEY (user_id, problem_id)
);

-- Update user progress when submission is made
CREATE OR REPLACE FUNCTION update_user_progress()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  INSERT INTO user_problem_progress (
    user_id,
    problem_id,
    status,
    last_attempted_at,
    solved_at,
    best_time,
    best_memory,
    total_attempts
  )
  VALUES (
    NEW.user_id,
    NEW.problem_id,
    CASE WHEN NEW.all_passed THEN 'solved' ELSE 'attempted' END,
    NEW.submitted_at,
    CASE WHEN NEW.all_passed THEN NEW.submitted_at ELSE NULL END,
    CASE WHEN NEW.all_passed THEN NEW.total_time ELSE NULL END,
    CASE WHEN NEW.all_passed THEN NEW.memory_used ELSE NULL END,
    1
  )
  ON CONFLICT (user_id, problem_id)
  DO UPDATE SET
    status = CASE 
      WHEN NEW.all_passed THEN 'solved'
      WHEN user_problem_progress.status = 'solved' THEN 'solved'
      ELSE 'attempted'
    END,
    last_attempted_at = NEW.submitted_at,
    solved_at = CASE 
      WHEN NEW.all_passed AND user_problem_progress.solved_at IS NULL THEN NEW.submitted_at
      ELSE user_problem_progress.solved_at
    END,
    best_time = CASE
      WHEN NEW.all_passed THEN 
        CASE 
          WHEN user_problem_progress.best_time IS NULL THEN NEW.total_time
          WHEN NEW.total_time < user_problem_progress.best_time THEN NEW.total_time
          ELSE user_problem_progress.best_time
        END
      ELSE user_problem_progress.best_time
    END,
    best_memory = CASE
      WHEN NEW.all_passed THEN 
        CASE 
          WHEN user_problem_progress.best_memory IS NULL THEN NEW.memory_used
          WHEN NEW.memory_used < user_problem_progress.best_memory THEN NEW.memory_used
          ELSE user_problem_progress.best_memory
        END
      ELSE user_problem_progress.best_memory
    END,
    total_attempts = user_problem_progress.total_attempts + 1,
    updated_at = NEW.submitted_at;
    
  RETURN NEW;
END;
$$;

-- Trigger to update progress on submission
CREATE TRIGGER trigger_update_user_progress
  AFTER INSERT ON problem_submissions
  FOR EACH ROW
  EXECUTE FUNCTION update_user_progress();

-- RLS for user_problem_progress
ALTER TABLE user_problem_progress ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own progress"
  ON user_problem_progress FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can update own progress"
  ON user_problem_progress FOR UPDATE
  USING (auth.uid() = user_id);

GRANT SELECT ON user_problem_progress TO authenticated;
GRANT INSERT ON user_problem_progress TO authenticated;
GRANT UPDATE ON user_problem_progress TO authenticated;

-- Add helpful comments
COMMENT ON TABLE problem_submissions IS 'Stores all code submissions with versioning for time-travel feature';
COMMENT ON COLUMN problem_submissions.version IS 'Auto-incrementing version number per user/problem, starting from 1';
COMMENT ON COLUMN problem_submissions.test_results IS 'JSONB array of individual test case results with pass/fail status';
COMMENT ON VIEW latest_submissions IS 'Shows only the most recent submission version for each user/problem';
COMMENT ON VIEW submission_stats IS 'Aggregated statistics for submission history analytics';
