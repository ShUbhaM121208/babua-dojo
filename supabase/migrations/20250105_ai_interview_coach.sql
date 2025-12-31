-- AI Interview Coach System Migration
-- Week 17: AI Interview Coach
-- Purpose: Store interview sessions, conversations, and performance evaluations

-- Create ai_interview_sessions table
CREATE TABLE IF NOT EXISTS ai_interview_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  problem_id TEXT NOT NULL REFERENCES problems(id) ON DELETE CASCADE,
  
  -- Session metadata
  started_at TIMESTAMPTZ DEFAULT NOW(),
  ended_at TIMESTAMPTZ,
  duration_seconds INTEGER,
  status TEXT DEFAULT 'active' CHECK (status IN ('active', 'completed', 'abandoned')),
  
  -- Problem solving data
  user_code TEXT,
  language TEXT,
  code_submitted BOOLEAN DEFAULT false,
  tests_passed BOOLEAN DEFAULT false,
  
  -- Evaluation scores (1-5)
  communication_score INTEGER CHECK (communication_score >= 1 AND communication_score <= 5),
  problem_solving_score INTEGER CHECK (problem_solving_score >= 1 AND problem_solving_score <= 5),
  code_quality_score INTEGER CHECK (code_quality_score >= 1 AND code_quality_score <= 5),
  overall_score DECIMAL(3,2), -- Average of above scores
  
  -- AI feedback
  strengths TEXT[],
  areas_for_improvement TEXT[],
  detailed_feedback TEXT,
  interviewer_notes TEXT,
  
  -- Session recording
  conversation_history JSONB DEFAULT '[]'::jsonb,
  key_moments JSONB DEFAULT '[]'::jsonb, -- Timestamps of important moments
  
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create ai_interview_messages table for conversation history
CREATE TABLE IF NOT EXISTS ai_interview_messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id UUID NOT NULL REFERENCES ai_interview_sessions(id) ON DELETE CASCADE,
  
  role TEXT NOT NULL CHECK (role IN ('interviewer', 'candidate', 'system')),
  message TEXT NOT NULL,
  message_type TEXT CHECK (message_type IN ('question', 'answer', 'hint', 'feedback', 'clarification')),
  
  -- Code context at this moment
  code_snapshot TEXT,
  
  -- Metadata
  timestamp TIMESTAMPTZ DEFAULT NOW(),
  tokens_used INTEGER,
  
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_ai_interview_sessions_user_id ON ai_interview_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_ai_interview_sessions_problem_id ON ai_interview_sessions(problem_id);
CREATE INDEX IF NOT EXISTS idx_ai_interview_sessions_status ON ai_interview_sessions(status);
CREATE INDEX IF NOT EXISTS idx_ai_interview_sessions_created_at ON ai_interview_sessions(created_at DESC);

CREATE INDEX IF NOT EXISTS idx_ai_interview_messages_session_id ON ai_interview_messages(session_id);
CREATE INDEX IF NOT EXISTS idx_ai_interview_messages_timestamp ON ai_interview_messages(timestamp);

-- Function to calculate overall score
CREATE OR REPLACE FUNCTION calculate_overall_score(
  p_communication INTEGER,
  p_problem_solving INTEGER,
  p_code_quality INTEGER
)
RETURNS DECIMAL(3,2)
LANGUAGE plpgsql
AS $$
BEGIN
  IF p_communication IS NULL OR p_problem_solving IS NULL OR p_code_quality IS NULL THEN
    RETURN NULL;
  END IF;
  
  RETURN ROUND((p_communication + p_problem_solving + p_code_quality) / 3.0, 2);
END;
$$;

-- Function to end interview session
CREATE OR REPLACE FUNCTION end_interview_session(
  p_session_id UUID,
  p_communication INTEGER,
  p_problem_solving INTEGER,
  p_code_quality INTEGER,
  p_strengths TEXT[],
  p_improvements TEXT[],
  p_feedback TEXT
)
RETURNS ai_interview_sessions
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_session ai_interview_sessions;
  v_duration INTEGER;
BEGIN
  -- Calculate duration
  SELECT EXTRACT(EPOCH FROM (NOW() - started_at))::INTEGER
  INTO v_duration
  FROM ai_interview_sessions
  WHERE id = p_session_id;
  
  -- Update session with evaluation
  UPDATE ai_interview_sessions
  SET 
    ended_at = NOW(),
    duration_seconds = v_duration,
    status = 'completed',
    communication_score = p_communication,
    problem_solving_score = p_problem_solving,
    code_quality_score = p_code_quality,
    overall_score = calculate_overall_score(p_communication, p_problem_solving, p_code_quality),
    strengths = p_strengths,
    areas_for_improvement = p_improvements,
    detailed_feedback = p_feedback,
    updated_at = NOW()
  WHERE id = p_session_id
  RETURNING * INTO v_session;
  
  RETURN v_session;
END;
$$;

-- Function to save interview message
CREATE OR REPLACE FUNCTION save_interview_message(
  p_session_id UUID,
  p_role TEXT,
  p_message TEXT,
  p_message_type TEXT DEFAULT NULL,
  p_code_snapshot TEXT DEFAULT NULL
)
RETURNS ai_interview_messages
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_message ai_interview_messages;
BEGIN
  INSERT INTO ai_interview_messages (session_id, role, message, message_type, code_snapshot)
  VALUES (p_session_id, p_role, p_message, p_message_type, p_code_snapshot)
  RETURNING * INTO v_message;
  
  -- Update conversation history in session
  UPDATE ai_interview_sessions
  SET 
    conversation_history = conversation_history || 
      jsonb_build_object(
        'role', p_role,
        'message', p_message,
        'timestamp', NOW()
      ),
    updated_at = NOW()
  WHERE id = p_session_id;
  
  RETURN v_message;
END;
$$;

-- Function to get user's interview statistics
CREATE OR REPLACE FUNCTION get_interview_stats(p_user_id UUID)
RETURNS TABLE (
  total_sessions INTEGER,
  completed_sessions INTEGER,
  average_overall_score DECIMAL(3,2),
  average_duration_minutes INTEGER,
  problems_practiced INTEGER
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT 
    COUNT(*)::INTEGER as total_sessions,
    COUNT(*) FILTER (WHERE status = 'completed')::INTEGER as completed_sessions,
    ROUND(AVG(overall_score), 2) as average_overall_score,
    ROUND(AVG(duration_seconds) / 60.0)::INTEGER as average_duration_minutes,
    COUNT(DISTINCT problem_id)::INTEGER as problems_practiced
  FROM ai_interview_sessions
  WHERE ai_interview_sessions.user_id = p_user_id;
END;
$$;

-- RLS Policies
ALTER TABLE ai_interview_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_interview_messages ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Users can view their own AI interview sessions" ON ai_interview_sessions;
DROP POLICY IF EXISTS "Users can create their own AI interview sessions" ON ai_interview_sessions;
DROP POLICY IF EXISTS "Users can update their own AI interview sessions" ON ai_interview_sessions;

DROP POLICY IF EXISTS "Users can view their own AI interview messages" ON ai_interview_messages;
DROP POLICY IF EXISTS "Users can create their own AI interview messages" ON ai_interview_messages;

-- AI Interview sessions policies
CREATE POLICY "Users can view their own AI interview sessions"
  ON ai_interview_sessions FOR SELECT
  USING (auth.uid() = ai_interview_sessions.user_id);

CREATE POLICY "Users can create their own AI interview sessions"
  ON ai_interview_sessions FOR INSERT
  WITH CHECK (auth.uid() = ai_interview_sessions.user_id);

CREATE POLICY "Users can update their own AI interview sessions"
  ON ai_interview_sessions FOR UPDATE
  USING (auth.uid() = ai_interview_sessions.user_id);

-- AI Interview messages policies
CREATE POLICY "Users can view their own AI interview messages"
  ON ai_interview_messages FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM ai_interview_sessions
      WHERE ai_interview_sessions.id = ai_interview_messages.session_id
      AND ai_interview_sessions.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can create their own AI interview messages"
  ON ai_interview_messages FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM ai_interview_sessions
      WHERE ai_interview_sessions.id = ai_interview_messages.session_id
      AND ai_interview_sessions.user_id = auth.uid()
    )
  );

-- Grant permissions
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT ALL ON ai_interview_sessions TO authenticated;
GRANT ALL ON ai_interview_messages TO authenticated;
GRANT EXECUTE ON FUNCTION calculate_overall_score(INTEGER, INTEGER, INTEGER) TO authenticated;
GRANT EXECUTE ON FUNCTION end_interview_session(UUID, INTEGER, INTEGER, INTEGER, TEXT[], TEXT[], TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION save_interview_message(UUID, TEXT, TEXT, TEXT, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION get_interview_stats(UUID) TO authenticated;

-- Comments
COMMENT ON TABLE ai_interview_sessions IS 'Stores AI interview coaching sessions with evaluations';
COMMENT ON TABLE ai_interview_messages IS 'Stores conversation history for AI interview sessions';
COMMENT ON FUNCTION end_interview_session IS 'Completes an interview session with evaluation scores';
COMMENT ON FUNCTION save_interview_message IS 'Saves a message to the interview conversation';
COMMENT ON FUNCTION get_interview_stats IS 'Gets user interview practice statistics';
