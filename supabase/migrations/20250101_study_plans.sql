-- Study Plans Migration
-- Implements personalized learning roadmaps with AI recommendations

-- ============================================
-- TABLES
-- ============================================

-- Study Plans (Templates and User Plans)
CREATE TABLE IF NOT EXISTS study_plans (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  
  -- Plan Details
  title TEXT NOT NULL,
  description TEXT,
  difficulty TEXT CHECK (difficulty IN ('beginner', 'intermediate', 'advanced', 'mixed')),
  estimated_days INTEGER NOT NULL,
  
  -- Plan Type
  is_template BOOLEAN DEFAULT false, -- Template plans are public
  template_id UUID REFERENCES study_plans(id) ON DELETE SET NULL,
  created_by TEXT DEFAULT 'user', -- 'user', 'ai', 'admin'
  
  -- Goals
  target_topics TEXT[] DEFAULT '{}',
  target_companies TEXT[] DEFAULT '{}',
  problems_per_day INTEGER DEFAULT 3,
  
  -- Status
  status TEXT DEFAULT 'draft' CHECK (status IN ('draft', 'active', 'paused', 'completed', 'archived')),
  is_public BOOLEAN DEFAULT false,
  
  -- Metrics
  total_items INTEGER DEFAULT 0,
  completed_items INTEGER DEFAULT 0,
  progress_percentage INTEGER DEFAULT 0,
  
  -- Timestamps
  start_date DATE,
  target_end_date DATE,
  actual_end_date DATE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Study Plan Items (Problems, Topics, Resources)
CREATE TABLE IF NOT EXISTS study_plan_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  plan_id UUID NOT NULL REFERENCES study_plans(id) ON DELETE CASCADE,
  
  -- Item Details
  item_type TEXT NOT NULL CHECK (item_type IN ('problem', 'topic', 'resource', 'milestone')),
  item_id TEXT, -- problem_id, topic_name, etc.
  title TEXT NOT NULL,
  description TEXT,
  
  -- Ordering
  day_number INTEGER NOT NULL,
  order_in_day INTEGER DEFAULT 0,
  
  -- Problem-specific
  problem_difficulty TEXT CHECK (problem_difficulty IN ('easy', 'medium', 'hard')),
  problem_tags TEXT[] DEFAULT '{}',
  
  -- Resource-specific
  resource_url TEXT,
  resource_type TEXT, -- 'video', 'article', 'documentation'
  estimated_time_minutes INTEGER,
  
  -- Status
  is_optional BOOLEAN DEFAULT false,
  is_completed BOOLEAN DEFAULT false,
  completed_at TIMESTAMPTZ,
  
  -- AI Recommendation
  ai_recommended BOOLEAN DEFAULT false,
  recommendation_reason TEXT,
  
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- User Study Progress (Daily tracking)
CREATE TABLE IF NOT EXISTS user_study_progress (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  plan_id UUID NOT NULL REFERENCES study_plans(id) ON DELETE CASCADE,
  
  date DATE NOT NULL,
  
  -- Daily Stats
  items_completed INTEGER DEFAULT 0,
  time_spent_minutes INTEGER DEFAULT 0,
  problems_solved INTEGER DEFAULT 0,
  
  -- Streak Tracking
  is_rest_day BOOLEAN DEFAULT false,
  streak_maintained BOOLEAN DEFAULT true,
  
  -- Notes
  daily_notes TEXT,
  mood TEXT, -- 'productive', 'struggling', 'confident'
  
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, plan_id, date)
);

-- Study Plan Milestones
CREATE TABLE IF NOT EXISTS study_plan_milestones (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  plan_id UUID NOT NULL REFERENCES study_plans(id) ON DELETE CASCADE,
  
  title TEXT NOT NULL,
  description TEXT,
  target_date DATE,
  
  -- Completion Criteria
  required_items_completed INTEGER,
  required_topics TEXT[] DEFAULT '{}',
  
  -- Status
  is_completed BOOLEAN DEFAULT false,
  completed_at TIMESTAMPTZ,
  
  -- Rewards
  reward_xp INTEGER DEFAULT 0,
  reward_badge TEXT,
  
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- AI Study Recommendations (Personalized suggestions)
CREATE TABLE IF NOT EXISTS study_recommendations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  
  recommendation_type TEXT NOT NULL CHECK (recommendation_type IN ('problem', 'topic', 'plan', 'resource')),
  item_id TEXT,
  title TEXT NOT NULL,
  description TEXT,
  reason TEXT, -- Why this is recommended
  
  -- Relevance
  relevance_score DECIMAL(3,2) DEFAULT 0.5, -- 0.0 to 1.0
  based_on TEXT[] DEFAULT '{}', -- ['weak_in_graphs', 'target_company_google']
  
  -- Status
  is_dismissed BOOLEAN DEFAULT false,
  is_accepted BOOLEAN DEFAULT false,
  
  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  expires_at TIMESTAMPTZ DEFAULT (NOW() + INTERVAL '7 days')
);

-- Study Buddies (For accountability)
CREATE TABLE IF NOT EXISTS study_buddies (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  buddy_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'active', 'inactive')),
  
  -- Shared Goals
  shared_plan_id UUID REFERENCES study_plans(id) ON DELETE SET NULL,
  check_in_frequency TEXT DEFAULT 'daily', -- 'daily', 'weekly', 'custom'
  
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, buddy_user_id)
);

-- ============================================
-- INDEXES
-- ============================================

CREATE INDEX IF NOT EXISTS idx_study_plans_user ON study_plans(user_id);
CREATE INDEX IF NOT EXISTS idx_study_plans_status ON study_plans(status);
CREATE INDEX IF NOT EXISTS idx_study_plans_template ON study_plans(is_template, is_public);
CREATE INDEX IF NOT EXISTS idx_study_plan_items_plan ON study_plan_items(plan_id);
CREATE INDEX IF NOT EXISTS idx_study_plan_items_day ON study_plan_items(day_number);
CREATE INDEX IF NOT EXISTS idx_study_progress_user_plan ON user_study_progress(user_id, plan_id);
CREATE INDEX IF NOT EXISTS idx_study_progress_date ON user_study_progress(date DESC);
CREATE INDEX IF NOT EXISTS idx_study_recommendations_user ON study_recommendations(user_id);
-- Index for active recommendations (without WHERE clause to avoid NOW() immutability issue)
CREATE INDEX IF NOT EXISTS idx_study_recommendations_status ON study_recommendations(user_id, is_dismissed, expires_at);

-- ============================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================

ALTER TABLE study_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE study_plan_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_study_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE study_plan_milestones ENABLE ROW LEVEL SECURITY;
ALTER TABLE study_recommendations ENABLE ROW LEVEL SECURITY;
ALTER TABLE study_buddies ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist (makes migration idempotent)
DROP POLICY IF EXISTS "Users can view their own plans" ON study_plans;
DROP POLICY IF EXISTS "Users can create their own plans" ON study_plans;
DROP POLICY IF EXISTS "Users can update their own plans" ON study_plans;
DROP POLICY IF EXISTS "Users can delete their own plans" ON study_plans;

DROP POLICY IF EXISTS "Users can view items from accessible plans" ON study_plan_items;
DROP POLICY IF EXISTS "Users can manage items in their own plans" ON study_plan_items;

DROP POLICY IF EXISTS "Users can view their own progress" ON user_study_progress;
DROP POLICY IF EXISTS "Users can insert their own progress" ON user_study_progress;
DROP POLICY IF EXISTS "Users can update their own progress" ON user_study_progress;

DROP POLICY IF EXISTS "Users can view their own recommendations" ON study_recommendations;
DROP POLICY IF EXISTS "Users can update their own recommendations" ON study_recommendations;

DROP POLICY IF EXISTS "Users can view their buddy relationships" ON study_buddies;
DROP POLICY IF EXISTS "Users can create buddy requests" ON study_buddies;
DROP POLICY IF EXISTS "Users can update buddy status" ON study_buddies;

-- Study Plans Policies
CREATE POLICY "Users can view their own plans"
  ON study_plans FOR SELECT
  USING (auth.uid() = user_id OR is_public = true OR is_template = true);

CREATE POLICY "Users can create their own plans"
  ON study_plans FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own plans"
  ON study_plans FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own plans"
  ON study_plans FOR DELETE
  USING (auth.uid() = user_id);

-- Study Plan Items Policies
CREATE POLICY "Users can view items from accessible plans"
  ON study_plan_items FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM study_plans sp
      WHERE sp.id = plan_id
      AND (sp.user_id = auth.uid() OR sp.is_public = true OR sp.is_template = true)
    )
  );

CREATE POLICY "Users can manage items in their own plans"
  ON study_plan_items FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM study_plans sp
      WHERE sp.id = plan_id AND sp.user_id = auth.uid()
    )
  );

-- User Study Progress Policies
CREATE POLICY "Users can view their own progress"
  ON user_study_progress FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own progress"
  ON user_study_progress FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own progress"
  ON user_study_progress FOR UPDATE
  USING (auth.uid() = user_id);

-- Study Recommendations Policies
CREATE POLICY "Users can view their own recommendations"
  ON study_recommendations FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can update their own recommendations"
  ON study_recommendations FOR UPDATE
  USING (auth.uid() = user_id);

-- Study Buddies Policies
CREATE POLICY "Users can view their buddy relationships"
  ON study_buddies FOR SELECT
  USING (auth.uid() = user_id OR auth.uid() = buddy_user_id);

CREATE POLICY "Users can create buddy requests"
  ON study_buddies FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update buddy status"
  ON study_buddies FOR UPDATE
  USING (auth.uid() = user_id OR auth.uid() = buddy_user_id);

-- ============================================
-- FUNCTIONS
-- ============================================

-- Function to update plan progress
CREATE OR REPLACE FUNCTION update_plan_progress()
RETURNS TRIGGER AS $$
DECLARE
  v_total INTEGER;
  v_completed INTEGER;
BEGIN
  -- Count total and completed items
  SELECT COUNT(*), COUNT(*) FILTER (WHERE is_completed = true)
  INTO v_total, v_completed
  FROM study_plan_items
  WHERE plan_id = NEW.plan_id AND is_optional = false;
  
  -- Update plan metrics
  UPDATE study_plans
  SET total_items = v_total,
      completed_items = v_completed,
      progress_percentage = CASE 
        WHEN v_total = 0 THEN 0 
        ELSE (v_completed * 100 / v_total)
      END,
      updated_at = NOW()
  WHERE id = NEW.plan_id;
  
  -- Check if plan is completed
  IF v_completed = v_total AND v_total > 0 THEN
    UPDATE study_plans
    SET status = 'completed',
        actual_end_date = CURRENT_DATE
    WHERE id = NEW.plan_id;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_update_plan_progress ON study_plan_items;
CREATE TRIGGER trigger_update_plan_progress
  AFTER INSERT OR UPDATE OF is_completed ON study_plan_items
  FOR EACH ROW
  EXECUTE FUNCTION update_plan_progress();

-- Function to create daily tasks from plan
CREATE OR REPLACE FUNCTION get_daily_tasks(
  p_user_id UUID,
  p_plan_id UUID,
  p_date DATE DEFAULT CURRENT_DATE
)
RETURNS TABLE (
  id UUID,
  title TEXT,
  description TEXT,
  item_type TEXT,
  is_completed BOOLEAN,
  estimated_time_minutes INTEGER
) AS $$
DECLARE
  v_start_date DATE;
  v_day_number INTEGER;
BEGIN
  -- Get plan start date
  SELECT start_date INTO v_start_date
  FROM study_plans
  WHERE id = p_plan_id AND user_id = p_user_id;
  
  -- Calculate day number
  v_day_number := p_date - v_start_date + 1;
  
  -- Return tasks for this day
  RETURN QUERY
  SELECT 
    spi.id,
    spi.title,
    spi.description,
    spi.item_type,
    spi.is_completed,
    spi.estimated_time_minutes
  FROM study_plan_items spi
  WHERE spi.plan_id = p_plan_id
    AND spi.day_number = v_day_number
  ORDER BY spi.order_in_day;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to generate AI study plan
CREATE OR REPLACE FUNCTION generate_ai_study_plan(
  p_user_id UUID,
  p_title TEXT,
  p_target_topics TEXT[],
  p_difficulty TEXT,
  p_days INTEGER
)
RETURNS UUID AS $$
DECLARE
  v_plan_id UUID;
BEGIN
  -- Create the plan
  INSERT INTO study_plans (
    user_id, title, description, difficulty, estimated_days,
    created_by, target_topics, status, start_date, target_end_date
  )
  VALUES (
    p_user_id,
    p_title,
    'AI-generated personalized study plan',
    p_difficulty,
    p_days,
    'ai',
    p_target_topics,
    'draft',
    CURRENT_DATE,
    CURRENT_DATE + p_days
  )
  RETURNING id INTO v_plan_id;
  
  -- TODO: Add AI logic to populate study_plan_items
  -- This would call the Babua AI service to generate optimal problem sequence
  
  RETURN v_plan_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- HELPER VIEWS
-- ============================================

-- View for user's active plans with progress
CREATE OR REPLACE VIEW user_active_plans AS
SELECT 
  sp.*,
  CASE 
    WHEN sp.start_date IS NULL THEN 0
    ELSE CURRENT_DATE - sp.start_date + 1
  END as days_active,
  CASE
    WHEN sp.target_end_date IS NULL THEN 0
    ELSE sp.target_end_date - CURRENT_DATE
  END as days_remaining
FROM study_plans sp
WHERE sp.status IN ('active', 'paused')
ORDER BY sp.updated_at DESC;

-- View for today's tasks across all active plans
CREATE OR REPLACE VIEW today_tasks AS
SELECT 
  spi.id,
  spi.plan_id,
  sp.title as plan_title,
  spi.title,
  spi.description,
  spi.item_type,
  spi.is_completed,
  spi.estimated_time_minutes,
  spi.problem_difficulty
FROM study_plan_items spi
JOIN study_plans sp ON spi.plan_id = sp.id
WHERE sp.status = 'active'
  AND sp.start_date IS NOT NULL
  AND spi.day_number = (CURRENT_DATE - sp.start_date + 1)
ORDER BY sp.user_id, spi.order_in_day;

-- ============================================
-- SEED TEMPLATE PLANS
-- ============================================

-- Insert a sample template plan
INSERT INTO study_plans (
  title, description, difficulty, estimated_days,
  is_template, created_by, target_topics, is_public, status
) VALUES (
  '30-Day DSA Fundamentals',
  'Master the fundamentals of Data Structures and Algorithms in 30 days',
  'beginner',
  30,
  true,
  'admin',
  ARRAY['arrays', 'strings', 'linked-lists', 'stacks', 'queues', 'trees', 'sorting', 'searching'],
  true,
  'active'
) ON CONFLICT DO NOTHING;

COMMENT ON TABLE study_plans IS 'Personalized study plans and learning roadmaps';
COMMENT ON TABLE study_plan_items IS 'Individual items (problems, topics, resources) in study plans';
COMMENT ON TABLE user_study_progress IS 'Daily progress tracking for study plans';
COMMENT ON TABLE study_recommendations IS 'AI-generated personalized study recommendations';
