-- AI Code Review System Migration
-- Week 16: AI Code Review
-- Purpose: Store AI-generated code reviews with caching and rate limiting

-- Create code_reviews table
CREATE TABLE IF NOT EXISTS code_reviews (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  submission_id UUID REFERENCES problem_submissions(id) ON DELETE CASCADE,
  problem_id TEXT NOT NULL REFERENCES problems(id) ON DELETE CASCADE,
  
  -- Code and language
  code TEXT NOT NULL,
  code_hash TEXT NOT NULL, -- For caching identical code
  language TEXT NOT NULL,
  
  -- Review data
  time_complexity TEXT,
  space_complexity TEXT,
  code_quality_score INTEGER CHECK (code_quality_score >= 0 AND code_quality_score <= 100),
  
  strengths TEXT[], -- Array of strength points
  improvements TEXT[], -- Array of improvement suggestions
  alternative_approaches TEXT[], -- Array of alternative solutions
  best_practices TEXT[], -- Array of best practice recommendations
  
  -- Full review text
  full_review_markdown TEXT,
  
  -- Metadata
  model_used TEXT DEFAULT 'gemini-pro', -- Track which AI model was used
  tokens_used INTEGER, -- Track API usage
  processing_time_ms INTEGER, -- Track response time

  created_at TIMESTAMPTZ DEFAULT NOW(),  -- Index for cache lookups
  UNIQUE (code_hash, language)
);

-- Create rate_limit_tracking table
CREATE TABLE IF NOT EXISTS review_rate_limits (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  review_date DATE NOT NULL,
  review_count INTEGER DEFAULT 0,
  
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  
  -- One entry per user per day
  UNIQUE (user_id, review_date)
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_code_reviews_user_id ON code_reviews(user_id);
CREATE INDEX IF NOT EXISTS idx_code_reviews_problem_id ON code_reviews(problem_id);
CREATE INDEX IF NOT EXISTS idx_code_reviews_submission_id ON code_reviews(submission_id);
CREATE INDEX IF NOT EXISTS idx_code_reviews_code_hash ON code_reviews(code_hash, language);
CREATE INDEX IF NOT EXISTS idx_code_reviews_created_at ON code_reviews(created_at DESC);

CREATE INDEX IF NOT EXISTS idx_rate_limits_user_date ON review_rate_limits(user_id, review_date);

-- Function to increment rate limit counter
CREATE OR REPLACE FUNCTION increment_review_count(p_user_id UUID)
RETURNS INTEGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_count INTEGER;
BEGIN
  -- Insert or update rate limit entry
  INSERT INTO review_rate_limits (user_id, review_date, review_count)
  VALUES (p_user_id, CURRENT_DATE, 1)
  ON CONFLICT (user_id, review_date)
  DO UPDATE SET 
    review_count = review_rate_limits.review_count + 1,
    updated_at = NOW()
  RETURNING review_count INTO v_count;
  
  RETURN v_count;
END;
$$;

-- Function to check if user can request review
CREATE OR REPLACE FUNCTION can_request_review(p_user_id UUID)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_count INTEGER;
BEGIN
  -- Get today's review count
  SELECT COALESCE(review_count, 0) INTO v_count
  FROM review_rate_limits
  WHERE user_id = p_user_id AND review_date = CURRENT_DATE;
  
  -- Free users get 3 reviews per day
  RETURN v_count < 3;
END;
$$;

-- Function to get cached review
CREATE OR REPLACE FUNCTION get_cached_review(p_code_hash TEXT, p_language TEXT)
RETURNS TABLE (
  id UUID,
  time_complexity TEXT,
  space_complexity TEXT,
  code_quality_score INTEGER,
  strengths TEXT[],
  improvements TEXT[],
  alternative_approaches TEXT[],
  best_practices TEXT[],
  full_review_markdown TEXT,
  created_at TIMESTAMPTZ
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT 
    cr.id,
    cr.time_complexity,
    cr.space_complexity,
    cr.code_quality_score,
    cr.strengths,
    cr.improvements,
    cr.alternative_approaches,
    cr.best_practices,
    cr.full_review_markdown,
    cr.created_at
  FROM code_reviews cr
  WHERE cr.code_hash = p_code_hash 
    AND cr.language = p_language
  ORDER BY cr.created_at DESC
  LIMIT 1;
END;
$$;

-- RLS Policies
ALTER TABLE code_reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE review_rate_limits ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Users can view their own reviews" ON code_reviews;
DROP POLICY IF EXISTS "Users can insert their own reviews" ON code_reviews;
DROP POLICY IF EXISTS "Users can view their rate limits" ON review_rate_limits;
DROP POLICY IF EXISTS "Users can update their rate limits" ON review_rate_limits;

-- Code reviews policies
CREATE POLICY "Users can view their own reviews"
  ON code_reviews FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own reviews"
  ON code_reviews FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Rate limits policies
CREATE POLICY "Users can view their rate limits"
  ON review_rate_limits FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can update their rate limits"
  ON review_rate_limits FOR ALL
  USING (auth.uid() = user_id);

-- Grant permissions
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT ALL ON code_reviews TO authenticated;
GRANT ALL ON review_rate_limits TO authenticated;
GRANT EXECUTE ON FUNCTION increment_review_count(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION can_request_review(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION get_cached_review(TEXT, TEXT) TO authenticated;

-- Comments
COMMENT ON TABLE code_reviews IS 'Stores AI-generated code reviews with caching support';
COMMENT ON TABLE review_rate_limits IS 'Tracks daily review requests for rate limiting';
COMMENT ON FUNCTION increment_review_count IS 'Increments review count for rate limiting';
COMMENT ON FUNCTION can_request_review IS 'Checks if user can request a new review (3/day for free, unlimited for pro)';
COMMENT ON FUNCTION get_cached_review IS 'Retrieves cached review for identical code';
