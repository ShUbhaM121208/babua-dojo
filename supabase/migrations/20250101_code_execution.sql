-- Migration: Add test cases and execution constraints to problems
-- This enables real code execution and validation

-- Create problems table if it doesn't exist
CREATE TABLE IF NOT EXISTS problems (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  difficulty TEXT NOT NULL CHECK (difficulty IN ('easy', 'medium', 'hard')),
  description TEXT,
  examples JSONB DEFAULT '[]'::jsonb,
  constraints JSONB DEFAULT '[]'::jsonb,
  tags JSONB DEFAULT '[]'::jsonb,
  track_slug TEXT,
  starter_code JSONB DEFAULT '{}'::jsonb,
  hints JSONB DEFAULT '[]'::jsonb,
  companies JSONB DEFAULT '[]'::jsonb,
  order_index INTEGER,
  acceptance_rate DECIMAL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add columns for test cases and execution limits
ALTER TABLE problems 
ADD COLUMN IF NOT EXISTS test_cases JSONB DEFAULT '[]',
ADD COLUMN IF NOT EXISTS hidden_test_cases JSONB DEFAULT '[]',
ADD COLUMN IF NOT EXISTS time_limit INTEGER DEFAULT 2000, -- milliseconds
ADD COLUMN IF NOT EXISTS memory_limit INTEGER DEFAULT 256000; -- KB

-- Add indices for better query performance
CREATE INDEX IF NOT EXISTS idx_problems_test_cases ON problems USING GIN (test_cases);

-- Update existing problems with sample test cases
-- This is just a template - you'll need to populate with real test cases

-- Example: Two Sum problem
UPDATE problems 
SET 
  test_cases = '[
    {"input": "[2,7,11,15]\n9", "expected_output": "[0,1]"},
    {"input": "[3,2,4]\n6", "expected_output": "[1,2]"},
    {"input": "[3,3]\n6", "expected_output": "[0,1]"}
  ]'::jsonb,
  hidden_test_cases = '[
    {"input": "[1,2,3,4,5]\n9", "expected_output": "[3,4]"},
    {"input": "[-1,0]\n-1", "expected_output": "[0,1]"}
  ]'::jsonb,
  constraints = '["1 <= nums.length <= 10^4", "-10^9 <= nums[i] <= 10^9", "-10^9 <= target <= 10^9", "Only one valid answer exists"]'::jsonb,
  time_limit = 2000,
  memory_limit = 256000
WHERE title = 'Two Sum';

-- Add comment for documentation
COMMENT ON COLUMN problems.test_cases IS 'Visible test cases shown to users. Format: [{"input": "stdin", "expected_output": "stdout"}]';
COMMENT ON COLUMN problems.hidden_test_cases IS 'Hidden test cases for validation. Same format as test_cases.';
COMMENT ON COLUMN problems.constraints IS 'Problem constraints and limits';
COMMENT ON COLUMN problems.time_limit IS 'CPU time limit in milliseconds';
COMMENT ON COLUMN problems.memory_limit IS 'Memory limit in KB';

-- Create table for storing execution results
CREATE TABLE IF NOT EXISTS problem_executions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  problem_id TEXT NOT NULL REFERENCES problems(id) ON DELETE CASCADE,
  language TEXT NOT NULL,
  code TEXT NOT NULL,
  test_results JSONB NOT NULL, -- Array of test case results
  passed_count INTEGER NOT NULL,
  failed_count INTEGER NOT NULL,
  total_time DECIMAL,
  all_passed BOOLEAN NOT NULL,
  executed_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Add index for user's execution history
CREATE INDEX IF NOT EXISTS idx_problem_executions_user_problem 
ON problem_executions(user_id, problem_id, executed_at DESC);

-- RLS policies for problem_executions
ALTER TABLE problem_executions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own executions"
  ON problem_executions FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own executions"
  ON problem_executions FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Grant permissions
GRANT SELECT ON problem_executions TO authenticated;
GRANT INSERT ON problem_executions TO authenticated;
