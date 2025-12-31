-- Week 18: Personalized Learning Path
-- Tracks user performance by topic and generates intelligent recommendations

-- ============================================================================
-- Topic Performance Tracking
-- ============================================================================

CREATE TABLE IF NOT EXISTS user_topic_performance (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  topic TEXT NOT NULL, -- Matches problem.tags array values
  
  -- Performance Metrics
  problems_attempted INTEGER DEFAULT 0,
  problems_solved INTEGER DEFAULT 0,
  success_rate NUMERIC(5, 2) DEFAULT 0.0, -- Percentage: 0.00 to 100.00
  
  -- Time Metrics (in seconds)
  total_time_spent INTEGER DEFAULT 0,
  average_time_per_problem INTEGER DEFAULT 0,
  fastest_solve_time INTEGER,
  
  -- Difficulty Distribution
  easy_attempted INTEGER DEFAULT 0,
  easy_solved INTEGER DEFAULT 0,
  medium_attempted INTEGER DEFAULT 0,
  medium_solved INTEGER DEFAULT 0,
  hard_attempted INTEGER DEFAULT 0,
  hard_solved INTEGER DEFAULT 0,
  
  -- Trend Analysis
  recent_success_rate NUMERIC(5, 2) DEFAULT 0.0, -- Last 10 problems
  improvement_trend NUMERIC(5, 2) DEFAULT 0.0, -- Positive = improving, negative = declining
  
  -- Timestamps
  first_attempted_at TIMESTAMP WITH TIME ZONE,
  last_attempted_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  UNIQUE(user_id, topic)
);

-- ============================================================================
-- Learning Recommendations
-- ============================================================================

CREATE TABLE IF NOT EXISTS learning_recommendations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  
  -- Recommendation Details
  problem_id TEXT NOT NULL,
  topic TEXT NOT NULL,
  recommended_reason TEXT NOT NULL, -- e.g., "You struggle with Dynamic Programming"
  priority INTEGER DEFAULT 1, -- 1 = highest, 5 = lowest
  
  -- Contextual Info
  based_on_weak_topics TEXT[] DEFAULT '{}', -- Topics user struggles with
  difficulty_level TEXT NOT NULL, -- easy, medium, hard
  estimated_time_minutes INTEGER, -- Based on user's average
  
  -- User Feedback
  shown BOOLEAN DEFAULT false,
  shown_at TIMESTAMP WITH TIME ZONE,
  clicked BOOLEAN DEFAULT false,
  clicked_at TIMESTAMP WITH TIME ZONE,
  dismissed BOOLEAN DEFAULT false,
  dismissed_at TIMESTAMP WITH TIME ZONE,
  completed BOOLEAN DEFAULT false,
  completed_at TIMESTAMP WITH TIME ZONE,
  
  -- ML Scoring
  recommendation_score NUMERIC(5, 2), -- 0-100, higher = better match
  
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  expires_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() + INTERVAL '7 days'
);

-- ============================================================================
-- User Preferences for Recommendations
-- ============================================================================

CREATE TABLE IF NOT EXISTS recommendation_preferences (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  
  -- Difficulty Preference
  preferred_difficulty TEXT DEFAULT 'medium', -- easy, medium, hard, mixed
  avoid_topics TEXT[] DEFAULT '{}', -- Topics user wants to skip
  focus_topics TEXT[] DEFAULT '{}', -- Topics user wants to focus on
  
  -- Learning Style
  prefer_new_topics BOOLEAN DEFAULT true, -- vs. reinforcing weak topics
  challenge_level INTEGER DEFAULT 3, -- 1-5, how much challenge user wants
  problems_per_day INTEGER DEFAULT 3,
  
  -- Time Preferences
  max_time_per_problem INTEGER DEFAULT 30, -- minutes
  study_time_of_day TEXT, -- morning, afternoon, evening, night
  
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  UNIQUE(user_id)
);

-- ============================================================================
-- Indexes for Performance
-- ============================================================================

CREATE INDEX idx_user_topic_perf_user ON user_topic_performance(user_id);
CREATE INDEX idx_user_topic_perf_topic ON user_topic_performance(topic);
CREATE INDEX idx_user_topic_perf_success ON user_topic_performance(user_id, success_rate);
CREATE INDEX idx_recommendations_user ON learning_recommendations(user_id);
CREATE INDEX idx_recommendations_active ON learning_recommendations(user_id, shown, dismissed, completed);
CREATE INDEX idx_recommendations_expires ON learning_recommendations(expires_at);
CREATE INDEX idx_recommendation_prefs_user ON recommendation_preferences(user_id);

-- ============================================================================
-- Functions to Update Topic Performance
-- ============================================================================

CREATE OR REPLACE FUNCTION update_topic_performance(
  p_user_id UUID,
  p_problem_id TEXT,
  p_solved BOOLEAN,
  p_time_spent INTEGER, -- in seconds
  p_difficulty TEXT
) RETURNS void AS $$
DECLARE
  v_tags TEXT[];
  v_tag TEXT;
  v_old_success_rate NUMERIC;
  v_new_success_rate NUMERIC;
BEGIN
  -- Get problem tags
  SELECT tags INTO v_tags
  FROM problems
  WHERE id = p_problem_id;
  
  -- Update performance for each tag/topic
  FOREACH v_tag IN ARRAY v_tags
  LOOP
    -- Store old success rate for trend calculation
    SELECT success_rate INTO v_old_success_rate
    FROM user_topic_performance
    WHERE user_id = p_user_id AND topic = v_tag;
    
    -- Insert or update topic performance
    INSERT INTO user_topic_performance (
      user_id,
      topic,
      problems_attempted,
      problems_solved,
      success_rate,
      total_time_spent,
      average_time_per_problem,
      fastest_solve_time,
      easy_attempted,
      easy_solved,
      medium_attempted,
      medium_solved,
      hard_attempted,
      hard_solved,
      first_attempted_at,
      last_attempted_at
    ) VALUES (
      p_user_id,
      v_tag,
      1,
      CASE WHEN p_solved THEN 1 ELSE 0 END,
      CASE WHEN p_solved THEN 100.0 ELSE 0.0 END,
      p_time_spent,
      p_time_spent,
      CASE WHEN p_solved THEN p_time_spent ELSE NULL END,
      CASE WHEN p_difficulty = 'easy' THEN 1 ELSE 0 END,
      CASE WHEN p_difficulty = 'easy' AND p_solved THEN 1 ELSE 0 END,
      CASE WHEN p_difficulty = 'medium' THEN 1 ELSE 0 END,
      CASE WHEN p_difficulty = 'medium' AND p_solved THEN 1 ELSE 0 END,
      CASE WHEN p_difficulty = 'hard' THEN 1 ELSE 0 END,
      CASE WHEN p_difficulty = 'hard' AND p_solved THEN 1 ELSE 0 END,
      NOW(),
      NOW()
    )
    ON CONFLICT (user_id, topic) DO UPDATE SET
      problems_attempted = user_topic_performance.problems_attempted + 1,
      problems_solved = user_topic_performance.problems_solved + CASE WHEN p_solved THEN 1 ELSE 0 END,
      success_rate = ROUND(
        (user_topic_performance.problems_solved + CASE WHEN p_solved THEN 1 ELSE 0 END) * 100.0 / 
        (user_topic_performance.problems_attempted + 1), 
        2
      ),
      total_time_spent = user_topic_performance.total_time_spent + p_time_spent,
      average_time_per_problem = ROUND(
        (user_topic_performance.total_time_spent + p_time_spent) / 
        (user_topic_performance.problems_attempted + 1)
      ),
      fastest_solve_time = CASE 
        WHEN p_solved THEN LEAST(
          COALESCE(user_topic_performance.fastest_solve_time, p_time_spent), 
          p_time_spent
        )
        ELSE user_topic_performance.fastest_solve_time
      END,
      easy_attempted = user_topic_performance.easy_attempted + CASE WHEN p_difficulty = 'easy' THEN 1 ELSE 0 END,
      easy_solved = user_topic_performance.easy_solved + CASE WHEN p_difficulty = 'easy' AND p_solved THEN 1 ELSE 0 END,
      medium_attempted = user_topic_performance.medium_attempted + CASE WHEN p_difficulty = 'medium' THEN 1 ELSE 0 END,
      medium_solved = user_topic_performance.medium_solved + CASE WHEN p_difficulty = 'medium' AND p_solved THEN 1 ELSE 0 END,
      hard_attempted = user_topic_performance.hard_attempted + CASE WHEN p_difficulty = 'hard' THEN 1 ELSE 0 END,
      hard_solved = user_topic_performance.hard_solved + CASE WHEN p_difficulty = 'hard' AND p_solved THEN 1 ELSE 0 END,
      last_attempted_at = NOW(),
      updated_at = NOW();
    
    -- Calculate improvement trend
    SELECT success_rate INTO v_new_success_rate
    FROM user_topic_performance
    WHERE user_id = p_user_id AND topic = v_tag;
    
    IF v_old_success_rate IS NOT NULL THEN
      UPDATE user_topic_performance
      SET improvement_trend = v_new_success_rate - v_old_success_rate
      WHERE user_id = p_user_id AND topic = v_tag;
    END IF;
  END LOOP;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- Function to Get Weak Topics
-- ============================================================================

CREATE OR REPLACE FUNCTION get_weak_topics(
  p_user_id UUID,
  p_limit INTEGER DEFAULT 5
) RETURNS TABLE (
  topic TEXT,
  success_rate NUMERIC,
  problems_attempted INTEGER,
  problems_solved INTEGER,
  average_time INTEGER,
  difficulty_recommendation TEXT
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    utp.topic,
    utp.success_rate,
    utp.problems_attempted,
    utp.problems_solved,
    utp.average_time_per_problem,
    CASE
      WHEN utp.success_rate >= 80 THEN 'hard' -- Doing well, challenge them
      WHEN utp.success_rate >= 50 THEN 'medium' -- Average, stay at medium
      ELSE 'easy' -- Struggling, recommend easier problems
    END as difficulty_recommendation
  FROM user_topic_performance utp
  WHERE utp.user_id = p_user_id
    AND utp.problems_attempted >= 3 -- Minimum attempts for meaningful data
  ORDER BY 
    utp.success_rate ASC, -- Prioritize lowest success rate
    utp.problems_attempted DESC -- Then most practiced topics
  LIMIT p_limit;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- Function to Generate Recommendations
-- ============================================================================

CREATE OR REPLACE FUNCTION generate_recommendations(
  p_user_id UUID,
  p_count INTEGER DEFAULT 5
) RETURNS TABLE (
  recommendation_id UUID,
  problem_id TEXT,
  problem_title TEXT,
  topic TEXT,
  difficulty TEXT,
  reason TEXT,
  priority INTEGER,
  score NUMERIC
) AS $$
DECLARE
  v_weak_topics TEXT[];
  v_preferences RECORD;
BEGIN
  -- Get user preferences
  SELECT * INTO v_preferences
  FROM recommendation_preferences
  WHERE user_id = p_user_id;
  
  -- If no preferences, use defaults
  IF v_preferences IS NULL THEN
    INSERT INTO recommendation_preferences (user_id)
    VALUES (p_user_id)
    RETURNING * INTO v_preferences;
  END IF;
  
  -- Get weak topics
  SELECT ARRAY_AGG(wt.topic)
  INTO v_weak_topics
  FROM get_weak_topics(p_user_id, 5) wt;
  
  -- Clear old recommendations
  DELETE FROM learning_recommendations
  WHERE user_id = p_user_id 
    AND (completed = true OR dismissed = true OR expires_at < NOW());
  
  -- Generate new recommendations based on weak topics
  RETURN QUERY
  INSERT INTO learning_recommendations (
    user_id,
    problem_id,
    topic,
    recommended_reason,
    priority,
    based_on_weak_topics,
    difficulty_level,
    estimated_time_minutes,
    recommendation_score
  )
  SELECT DISTINCT ON (p.id)
    p_user_id,
    p.id,
    unnest(p.tags), -- Primary weak topic
    CASE 
      WHEN utp.success_rate < 30 THEN 'You need more practice with ' || unnest(p.tags)
      WHEN utp.success_rate < 50 THEN 'Strengthen your ' || unnest(p.tags) || ' skills'
      WHEN utp.success_rate < 70 THEN 'Challenge yourself with ' || unnest(p.tags)
      ELSE 'Master ' || unnest(p.tags) || ' concepts'
    END,
    CASE
      WHEN utp.success_rate < 30 THEN 1 -- Highest priority
      WHEN utp.success_rate < 50 THEN 2
      WHEN utp.success_rate < 70 THEN 3
      ELSE 4
    END,
    v_weak_topics,
    p.difficulty,
    CASE
      WHEN utp.average_time_per_problem > 0 THEN utp.average_time_per_problem / 60
      ELSE 15 -- Default 15 minutes
    END,
    -- Scoring algorithm
    ROUND(
      (100 - COALESCE(utp.success_rate, 50)) * 0.5 + -- Lower success = higher score
      (CASE p.difficulty
        WHEN 'easy' THEN 20
        WHEN 'medium' THEN 15
        WHEN 'hard' THEN 10
      END) +
      (CASE 
        WHEN upp.solved THEN 0 -- Already solved
        ELSE 25
      END),
      2
    )
  FROM problems p
  CROSS JOIN unnest(p.tags) AS topic_name
  LEFT JOIN user_topic_performance utp ON utp.user_id = p_user_id AND utp.topic = topic_name
  LEFT JOIN user_problem_progress upp ON upp.user_id = p_user_id AND upp.problem_id = p.id
  WHERE topic_name = ANY(v_weak_topics)
    AND upp.solved IS NOT TRUE -- Don't recommend already solved problems
    AND p.difficulty = COALESCE(
      (SELECT difficulty_recommendation FROM get_weak_topics(p_user_id, 1) WHERE topic = topic_name LIMIT 1),
      v_preferences.preferred_difficulty
    )
  ORDER BY p.id, recommendation_score DESC
  LIMIT p_count
  RETURNING 
    learning_recommendations.id,
    learning_recommendations.problem_id,
    NULL::TEXT, -- Will be filled by JOIN
    learning_recommendations.topic,
    learning_recommendations.difficulty_level,
    learning_recommendations.recommended_reason,
    learning_recommendations.priority,
    learning_recommendations.recommendation_score;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- Function to Get User Recommendations
-- ============================================================================

CREATE OR REPLACE FUNCTION get_user_recommendations(
  p_user_id UUID,
  p_refresh BOOLEAN DEFAULT false
) RETURNS TABLE (
  recommendation_id UUID,
  problem_id TEXT,
  problem_title TEXT,
  problem_difficulty TEXT,
  topic TEXT,
  reason TEXT,
  priority INTEGER,
  estimated_time_minutes INTEGER,
  score NUMERIC
) AS $$
DECLARE
  v_rec_count INTEGER;
BEGIN
  -- Check if we have active recommendations
  SELECT COUNT(*) INTO v_rec_count
  FROM learning_recommendations
  WHERE user_id = p_user_id
    AND shown = false
    AND dismissed = false
    AND completed = false
    AND expires_at > NOW();
  
  -- Generate new recommendations if needed
  IF v_rec_count < 3 OR p_refresh THEN
    PERFORM generate_recommendations(p_user_id, 5);
  END IF;
  
  -- Return recommendations with problem details
  RETURN QUERY
  SELECT 
    lr.id,
    lr.problem_id,
    p.title,
    p.difficulty,
    lr.topic,
    lr.recommended_reason,
    lr.priority,
    lr.estimated_time_minutes,
    lr.recommendation_score
  FROM learning_recommendations lr
  JOIN problems p ON p.id = lr.problem_id
  WHERE lr.user_id = p_user_id
    AND lr.dismissed = false
    AND lr.completed = false
    AND lr.expires_at > NOW()
  ORDER BY lr.priority ASC, lr.recommendation_score DESC
  LIMIT 5;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- Function to Track Recommendation Interaction
-- ============================================================================

CREATE OR REPLACE FUNCTION track_recommendation_interaction(
  p_recommendation_id UUID,
  p_action TEXT -- 'shown', 'clicked', 'dismissed', 'completed'
) RETURNS void AS $$
BEGIN
  UPDATE learning_recommendations
  SET
    shown = CASE WHEN p_action = 'shown' THEN true ELSE shown END,
    shown_at = CASE WHEN p_action = 'shown' THEN NOW() ELSE shown_at END,
    clicked = CASE WHEN p_action = 'clicked' THEN true ELSE clicked END,
    clicked_at = CASE WHEN p_action = 'clicked' THEN NOW() ELSE clicked_at END,
    dismissed = CASE WHEN p_action = 'dismissed' THEN true ELSE dismissed END,
    dismissed_at = CASE WHEN p_action = 'dismissed' THEN NOW() ELSE dismissed_at END,
    completed = CASE WHEN p_action = 'completed' THEN true ELSE completed END,
    completed_at = CASE WHEN p_action = 'completed' THEN NOW() ELSE completed_at END
  WHERE id = p_recommendation_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- RLS Policies
-- ============================================================================

ALTER TABLE user_topic_performance ENABLE ROW LEVEL SECURITY;
ALTER TABLE learning_recommendations ENABLE ROW LEVEL SECURITY;
ALTER TABLE recommendation_preferences ENABLE ROW LEVEL SECURITY;

-- Users can only see their own topic performance
CREATE POLICY user_topic_performance_policy ON user_topic_performance
  FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Users can only see their own recommendations
CREATE POLICY learning_recommendations_policy ON learning_recommendations
  FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Users can only manage their own preferences
CREATE POLICY recommendation_preferences_policy ON recommendation_preferences
  FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- ============================================================================
-- Comments
-- ============================================================================

COMMENT ON TABLE user_topic_performance IS 'Tracks user performance metrics by topic for intelligent recommendations';
COMMENT ON TABLE learning_recommendations IS 'Stores AI-generated personalized problem recommendations';
COMMENT ON TABLE recommendation_preferences IS 'User preferences for how recommendations should be generated';
COMMENT ON FUNCTION update_topic_performance IS 'Updates topic performance metrics when user attempts/solves a problem';
COMMENT ON FUNCTION get_weak_topics IS 'Returns topics where user needs improvement';
COMMENT ON FUNCTION generate_recommendations IS 'Generates personalized problem recommendations based on weak topics';
COMMENT ON FUNCTION get_user_recommendations IS 'Returns active recommendations for a user';
COMMENT ON FUNCTION track_recommendation_interaction IS 'Tracks user interactions with recommendations for ML improvement';
