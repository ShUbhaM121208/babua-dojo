-- Ranks and Titles System Migration
-- Implements gamification ranks and special achievement titles

-- ============================================
-- ADD XP COLUMN TO USER PROFILES
-- ============================================

-- Add total_xp column if it doesn't exist
ALTER TABLE user_profiles ADD COLUMN IF NOT EXISTS total_xp INTEGER DEFAULT 0;

-- Create index for faster XP lookups
CREATE INDEX IF NOT EXISTS idx_user_profiles_total_xp ON user_profiles(total_xp DESC);

-- ============================================
-- RANK CONFIGURATION
-- ============================================

-- User Ranks (stores current rank for each user)
CREATE TABLE IF NOT EXISTS user_ranks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  
  -- Current Rank
  current_rank TEXT NOT NULL DEFAULT 'newbie',
  rank_xp INTEGER NOT NULL DEFAULT 0, -- Total XP earned
  
  -- Progress to Next Rank
  next_rank TEXT,
  xp_to_next_rank INTEGER,
  progress_percentage INTEGER DEFAULT 0,
  
  -- Rank History
  rank_ups INTEGER DEFAULT 0, -- Total times ranked up
  last_rank_up TIMESTAMPTZ,
  highest_rank TEXT DEFAULT 'newbie',
  
  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  
  UNIQUE(user_id)
);

-- Special Titles (achievements that grant titles)
CREATE TABLE IF NOT EXISTS special_titles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Title Details
  title TEXT NOT NULL UNIQUE,
  description TEXT NOT NULL,
  icon TEXT, -- Emoji or icon identifier
  color TEXT DEFAULT '#8b5cf6', -- Hex color for title
  
  -- Unlock Criteria
  criteria_type TEXT NOT NULL, -- 'speed', 'time_based', 'streak', 'accuracy', 'custom'
  criteria_value JSONB NOT NULL, -- Flexible criteria definition
  
  -- Rarity
  rarity TEXT DEFAULT 'common', -- 'common', 'rare', 'epic', 'legendary'
  
  -- Stats
  total_awarded INTEGER DEFAULT 0,
  
  -- Status
  is_active BOOLEAN DEFAULT true,
  
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- User Earned Titles (junction table)
CREATE TABLE IF NOT EXISTS user_titles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title_id UUID NOT NULL REFERENCES special_titles(id) ON DELETE CASCADE,
  
  -- Award Details
  earned_at TIMESTAMPTZ DEFAULT NOW(),
  progress_when_earned JSONB, -- Store context of achievement
  
  -- Display
  is_equipped BOOLEAN DEFAULT false, -- Currently showing on profile
  
  UNIQUE(user_id, title_id)
);

-- Rank Change History (audit log)
CREATE TABLE IF NOT EXISTS rank_history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  
  -- Change Details
  old_rank TEXT NOT NULL,
  new_rank TEXT NOT NULL,
  xp_at_rankup INTEGER NOT NULL,
  
  -- Context
  trigger_action TEXT, -- 'problem_solved', 'battle_won', 'streak_bonus'
  
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- INDEXES
-- ============================================

CREATE INDEX IF NOT EXISTS idx_user_ranks_user ON user_ranks(user_id);
CREATE INDEX IF NOT EXISTS idx_user_ranks_rank ON user_ranks(current_rank);
CREATE INDEX IF NOT EXISTS idx_user_ranks_xp ON user_ranks(rank_xp DESC);

CREATE INDEX IF NOT EXISTS idx_special_titles_active ON special_titles(is_active);
CREATE INDEX IF NOT EXISTS idx_special_titles_rarity ON special_titles(rarity);

CREATE INDEX IF NOT EXISTS idx_user_titles_user ON user_titles(user_id);
CREATE INDEX IF NOT EXISTS idx_user_titles_equipped ON user_titles(is_equipped);

CREATE INDEX IF NOT EXISTS idx_rank_history_user ON rank_history(user_id);
CREATE INDEX IF NOT EXISTS idx_rank_history_date ON rank_history(created_at DESC);

-- ============================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================

ALTER TABLE user_ranks ENABLE ROW LEVEL SECURITY;
ALTER TABLE special_titles ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_titles ENABLE ROW LEVEL SECURITY;
ALTER TABLE rank_history ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Users can view all ranks" ON user_ranks;
DROP POLICY IF EXISTS "Users can update their own rank" ON user_ranks;

DROP POLICY IF EXISTS "Anyone can view active titles" ON special_titles;

DROP POLICY IF EXISTS "Users can view their own titles" ON user_titles;
DROP POLICY IF EXISTS "Users can equip their own titles" ON user_titles;

DROP POLICY IF EXISTS "Users can view their own rank history" ON rank_history;

-- User Ranks Policies
CREATE POLICY "Users can view all ranks"
  ON user_ranks FOR SELECT
  USING (true); -- Public leaderboard visibility

CREATE POLICY "Users can update their own rank"
  ON user_ranks FOR ALL
  USING (auth.uid() = user_id);

-- Special Titles Policies
CREATE POLICY "Anyone can view active titles"
  ON special_titles FOR SELECT
  USING (is_active = true);

-- User Titles Policies
CREATE POLICY "Users can view their own titles"
  ON user_titles FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can equip their own titles"
  ON user_titles FOR UPDATE
  USING (auth.uid() = user_id);

-- Rank History Policies
CREATE POLICY "Users can view their own rank history"
  ON rank_history FOR SELECT
  USING (auth.uid() = user_id);

-- ============================================
-- FUNCTIONS
-- ============================================

-- Function to calculate rank from XP
CREATE OR REPLACE FUNCTION calculate_rank_from_xp(xp INTEGER)
RETURNS TABLE(
  rank TEXT,
  next_rank TEXT,
  xp_to_next INTEGER,
  progress_pct INTEGER
) AS $$
DECLARE
  ranks JSONB := '[
    {"title": "newbie", "minXP": 0, "color": "#9ca3af"},
    {"title": "apprentice", "minXP": 100, "color": "#22c55e"},
    {"title": "adept", "minXP": 500, "color": "#3b82f6"},
    {"title": "expert", "minXP": 1000, "color": "#8b5cf6"},
    {"title": "master", "minXP": 2500, "color": "#f97316"},
    {"title": "grandmaster", "minXP": 5000, "color": "#ef4444"},
    {"title": "legend", "minXP": 10000, "color": "#fbbf24"}
  ]'::JSONB;
  current_rank_obj JSONB;
  next_rank_obj JSONB;
  i INTEGER;
BEGIN
  -- Find current rank
  FOR i IN 0..jsonb_array_length(ranks) - 1 LOOP
    IF xp >= (ranks->i->>'minXP')::INTEGER THEN
      current_rank_obj := ranks->i;
    ELSE
      next_rank_obj := ranks->i;
      EXIT;
    END IF;
  END LOOP;
  
  -- If at max rank
  IF next_rank_obj IS NULL THEN
    RETURN QUERY SELECT 
      current_rank_obj->>'title',
      'max'::TEXT,
      0,
      100;
  ELSE
    RETURN QUERY SELECT 
      current_rank_obj->>'title',
      next_rank_obj->>'title',
      (next_rank_obj->>'minXP')::INTEGER - xp,
      CASE 
        WHEN (next_rank_obj->>'minXP')::INTEGER - (current_rank_obj->>'minXP')::INTEGER = 0 THEN 100
        ELSE ((xp - (current_rank_obj->>'minXP')::INTEGER) * 100 / 
              ((next_rank_obj->>'minXP')::INTEGER - (current_rank_obj->>'minXP')::INTEGER))
      END;
  END IF;
END;
$$ LANGUAGE plpgsql;

-- Function to update user rank based on XP
CREATE OR REPLACE FUNCTION update_user_rank()
RETURNS TRIGGER AS $$
DECLARE
  rank_info RECORD;
  old_rank TEXT;
BEGIN
  -- Get current rank
  SELECT current_rank INTO old_rank
  FROM user_ranks
  WHERE user_id = NEW.user_id;
  
  -- Calculate new rank
  SELECT * INTO rank_info
  FROM calculate_rank_from_xp(NEW.total_xp);
  
  -- Update or insert rank
  INSERT INTO user_ranks (
    user_id,
    current_rank,
    rank_xp,
    next_rank,
    xp_to_next_rank,
    progress_percentage,
    highest_rank,
    updated_at
  ) VALUES (
    NEW.user_id,
    rank_info.rank,
    NEW.total_xp,
    rank_info.next_rank,
    rank_info.xp_to_next,
    rank_info.progress_pct,
    rank_info.rank,
    NOW()
  )
  ON CONFLICT (user_id) DO UPDATE SET
    current_rank = rank_info.rank,
    rank_xp = NEW.total_xp,
    next_rank = rank_info.next_rank,
    xp_to_next_rank = rank_info.xp_to_next,
    progress_percentage = rank_info.progress_pct,
    highest_rank = CASE 
      WHEN rank_info.rank > user_ranks.highest_rank THEN rank_info.rank
      ELSE user_ranks.highest_rank
    END,
    rank_ups = CASE
      WHEN rank_info.rank != user_ranks.current_rank THEN user_ranks.rank_ups + 1
      ELSE user_ranks.rank_ups
    END,
    last_rank_up = CASE
      WHEN rank_info.rank != user_ranks.current_rank THEN NOW()
      ELSE user_ranks.last_rank_up
    END,
    updated_at = NOW();
  
  -- Log rank change if rank increased
  IF old_rank IS NOT NULL AND old_rank != rank_info.rank THEN
    INSERT INTO rank_history (user_id, old_rank, new_rank, xp_at_rankup, trigger_action)
    VALUES (NEW.user_id, old_rank, rank_info.rank, NEW.total_xp, 'xp_gained');
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to update rank when user_profiles.total_xp changes
DROP TRIGGER IF EXISTS trigger_update_rank ON user_profiles;
CREATE TRIGGER trigger_update_rank
  AFTER INSERT OR UPDATE OF total_xp ON user_profiles
  FOR EACH ROW
  EXECUTE FUNCTION update_user_rank();

-- ============================================
-- SEED DATA: Special Titles
-- ============================================

INSERT INTO special_titles (title, description, icon, color, criteria_type, criteria_value, rarity) VALUES
  ('Speed Demon', 'Average solve time under 10 minutes', '⚡', '#ef4444', 'speed', '{"avg_time_minutes": 10, "min_problems": 20}'::JSONB, 'rare'),
  ('Night Owl', 'Solved 50+ problems between 12 AM - 6 AM', '🦉', '#8b5cf6', 'time_based', '{"time_range": "00:00-06:00", "min_problems": 50}'::JSONB, 'rare'),
  ('Early Bird', 'Solved 50+ problems between 5 AM - 8 AM', '🌅', '#f59e0b', 'time_based', '{"time_range": "05:00-08:00", "min_problems": 50}'::JSONB, 'rare'),
  ('Comeback King', '30-day streak after 30+ day break', '👑', '#fbbf24', 'streak', '{"streak_days": 30, "after_break_days": 30}'::JSONB, 'epic'),
  ('Perfectionist', '100% first-attempt success rate (min 50 problems)', '💎', '#06b6d4', 'accuracy', '{"success_rate": 100, "min_problems": 50}'::JSONB, 'legendary'),
  ('Weekend Warrior', 'Solved 100+ problems on weekends', '🛡️', '#22c55e', 'time_based', '{"days": ["saturday", "sunday"], "min_problems": 100}'::JSONB, 'rare'),
  ('Marathon Runner', 'Longest streak over 100 days', '🏃', '#f97316', 'streak', '{"streak_days": 100}'::JSONB, 'epic'),
  ('Problem Hoarder', 'Solved 500+ problems total', '🏆', '#fbbf24', 'custom', '{"total_problems": 500}'::JSONB, 'epic'),
  ('Triple Threat', 'Mastered Arrays, DP, and Graphs (50+ each)', '⚔️', '#8b5cf6', 'custom', '{"topics": ["arrays", "dynamic-programming", "graphs"], "min_per_topic": 50}'::JSONB, 'legendary'),
  ('Consistency King', '365-day streak', '🔥', '#ef4444', 'streak', '{"streak_days": 365}'::JSONB, 'legendary')
ON CONFLICT (title) DO NOTHING;

-- ============================================
-- VIEWS
-- ============================================

-- View for global rank leaderboard
CREATE OR REPLACE VIEW global_rank_leaderboard AS
SELECT 
  ur.user_id,
  up.full_name,
  up.email,
  up.avatar_url,
  ur.current_rank,
  ur.rank_xp,
  ur.rank_ups,
  ROW_NUMBER() OVER (ORDER BY ur.rank_xp DESC) as global_rank
FROM user_ranks ur
JOIN user_profiles up ON ur.user_id = up.id
ORDER BY ur.rank_xp DESC;

-- View for user titles display
CREATE OR REPLACE VIEW user_titles_display AS
SELECT 
  ut.user_id,
  st.title,
  st.description,
  st.icon,
  st.color,
  st.rarity,
  ut.earned_at,
  ut.is_equipped
FROM user_titles ut
JOIN special_titles st ON ut.title_id = st.id
ORDER BY ut.earned_at DESC;
