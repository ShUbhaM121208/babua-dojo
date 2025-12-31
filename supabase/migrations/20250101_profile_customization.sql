-- Profile Customization Migration
-- Implements avatar upload, theme preferences, and privacy settings

-- ============================================
-- STORAGE BUCKET FOR AVATARS
-- ============================================

-- Create storage bucket for user avatars
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'avatars',
  'avatars',
  true,
  5242880, -- 5MB limit
  ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/gif']
)
ON CONFLICT (id) DO NOTHING;

-- Storage policies for avatars
CREATE POLICY "Users can upload their own avatar"
  ON storage.objects FOR INSERT
  WITH CHECK (
    bucket_id = 'avatars' AND
    auth.uid()::text = (storage.foldername(name))[1]
  );

CREATE POLICY "Users can update their own avatar"
  ON storage.objects FOR UPDATE
  USING (
    bucket_id = 'avatars' AND
    auth.uid()::text = (storage.foldername(name))[1]
  );

CREATE POLICY "Users can delete their own avatar"
  ON storage.objects FOR DELETE
  USING (
    bucket_id = 'avatars' AND
    auth.uid()::text = (storage.foldername(name))[1]
  );

CREATE POLICY "Anyone can view avatars"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'avatars');

-- ============================================
-- USER PREFERENCES TABLE
-- ============================================

CREATE TABLE IF NOT EXISTS user_preferences (
  user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  
  -- Appearance Settings
  theme TEXT DEFAULT 'system' CHECK (theme IN ('light', 'dark', 'system')),
  color_scheme TEXT DEFAULT 'blue' CHECK (color_scheme IN ('blue', 'green', 'purple', 'orange', 'red')),
  font_size TEXT DEFAULT 'medium' CHECK (font_size IN ('small', 'medium', 'large')),
  compact_mode BOOLEAN DEFAULT false,
  
  -- Privacy Settings
  profile_visibility TEXT DEFAULT 'public' CHECK (profile_visibility IN ('public', 'friends', 'private')),
  show_activity_status BOOLEAN DEFAULT true,
  show_problem_history BOOLEAN DEFAULT true,
  show_learning_path BOOLEAN DEFAULT true,
  allow_friend_requests BOOLEAN DEFAULT true,
  show_achievements BOOLEAN DEFAULT true,
  
  -- Notification Settings
  email_notifications BOOLEAN DEFAULT true,
  push_notifications BOOLEAN DEFAULT false,
  daily_challenge_reminder BOOLEAN DEFAULT true,
  streak_reminder BOOLEAN DEFAULT true,
  achievement_notifications BOOLEAN DEFAULT true,
  community_notifications BOOLEAN DEFAULT true,
  
  -- Learning Preferences
  difficulty_preference TEXT DEFAULT 'mixed' CHECK (difficulty_preference IN ('easy', 'medium', 'hard', 'mixed')),
  preferred_topics TEXT[] DEFAULT '{}',
  practice_goal_daily INTEGER DEFAULT 3, -- problems per day
  study_time_goal_minutes INTEGER DEFAULT 60,
  
  -- Other Settings
  language TEXT DEFAULT 'en',
  timezone TEXT DEFAULT 'UTC',
  
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- PROFILE VIEWS TABLE (Track who viewed profile)
-- ============================================

CREATE TABLE IF NOT EXISTS profile_views (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  viewer_user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  viewed_at TIMESTAMPTZ DEFAULT NOW(),
  viewed_date DATE NOT NULL DEFAULT CURRENT_DATE
);

-- Create unique constraint to enforce one view per day per user
ALTER TABLE profile_views
  ADD CONSTRAINT profile_views_one_per_day UNIQUE (profile_user_id, viewer_user_id, viewed_date);

-- ============================================
-- USER BADGES TABLE (For achievements display)
-- ============================================

CREATE TABLE IF NOT EXISTS user_badges (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  badge_type TEXT NOT NULL,
  badge_name TEXT NOT NULL,
  badge_description TEXT,
  badge_icon TEXT, -- URL or emoji
  badge_color TEXT DEFAULT '#3b82f6',
  earned_at TIMESTAMPTZ DEFAULT NOW(),
  display_on_profile BOOLEAN DEFAULT true,
  display_order INTEGER DEFAULT 0
);

-- ============================================
-- INDEXES
-- ============================================

CREATE INDEX IF NOT EXISTS idx_user_preferences_visibility ON user_preferences(profile_visibility);
CREATE INDEX IF NOT EXISTS idx_profile_views_profile ON profile_views(profile_user_id);
CREATE INDEX IF NOT EXISTS idx_profile_views_viewer ON profile_views(viewer_user_id);
CREATE INDEX IF NOT EXISTS idx_user_badges_user ON user_badges(user_id);
CREATE INDEX IF NOT EXISTS idx_user_badges_type ON user_badges(badge_type);

-- ============================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================

ALTER TABLE user_preferences ENABLE ROW LEVEL SECURITY;
ALTER TABLE profile_views ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_badges ENABLE ROW LEVEL SECURITY;

-- User Preferences Policies
CREATE POLICY "Users can view their own preferences"
  ON user_preferences FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own preferences"
  ON user_preferences FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own preferences"
  ON user_preferences FOR UPDATE
  USING (auth.uid() = user_id);

-- Profile Views Policies
CREATE POLICY "Users can view their own profile views"
  ON profile_views FOR SELECT
  USING (auth.uid() = profile_user_id);

CREATE POLICY "Anyone can record profile views"
  ON profile_views FOR INSERT
  WITH CHECK (true);

-- User Badges Policies
CREATE POLICY "Anyone can view public badges"
  ON user_badges FOR SELECT
  USING (
    display_on_profile = true OR
    auth.uid() = user_id
  );

CREATE POLICY "Users can update their own badge display"
  ON user_badges FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- ============================================
-- FUNCTIONS
-- ============================================

-- Function to initialize user preferences on signup
CREATE OR REPLACE FUNCTION create_user_preferences()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO user_preferences (user_id)
  VALUES (NEW.id)
  ON CONFLICT (user_id) DO NOTHING;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to create preferences on user signup
DROP TRIGGER IF EXISTS trigger_create_user_preferences ON auth.users;
CREATE TRIGGER trigger_create_user_preferences
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION create_user_preferences();

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_preferences_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_update_preferences_timestamp ON user_preferences;
CREATE TRIGGER trigger_update_preferences_timestamp
  BEFORE UPDATE ON user_preferences
  FOR EACH ROW
  EXECUTE FUNCTION update_preferences_timestamp();

-- Function to check profile visibility
CREATE OR REPLACE FUNCTION can_view_profile(
  p_profile_user_id UUID,
  p_viewer_user_id UUID
)
RETURNS BOOLEAN AS $$
DECLARE
  v_visibility TEXT;
BEGIN
  -- Profile owner can always view
  IF p_profile_user_id = p_viewer_user_id THEN
    RETURN true;
  END IF;
  
  -- Get visibility setting
  SELECT profile_visibility INTO v_visibility
  FROM user_preferences
  WHERE user_id = p_profile_user_id;
  
  -- Default to public if no preference set
  IF v_visibility IS NULL THEN
    RETURN true;
  END IF;
  
  -- Check visibility level
  IF v_visibility = 'public' THEN
    RETURN true;
  ELSIF v_visibility = 'private' THEN
    RETURN false;
  ELSIF v_visibility = 'friends' THEN
    -- TODO: Implement friends check when friendship feature is added
    RETURN false;
  END IF;
  
  RETURN false;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to record profile view
CREATE OR REPLACE FUNCTION record_profile_view(
  p_profile_user_id UUID,
  p_viewer_user_id UUID
)
RETURNS BOOLEAN AS $$
BEGIN
  -- Don't record self-views
  IF p_profile_user_id = p_viewer_user_id THEN
    RETURN false;
  END IF;
  
  -- Insert view record (UNIQUE constraint prevents duplicates per day)
  INSERT INTO profile_views (profile_user_id, viewer_user_id)
  VALUES (p_profile_user_id, p_viewer_user_id)
  ON CONFLICT DO NOTHING;
  
  RETURN true;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- HELPER VIEWS
-- ============================================

-- View for profile view stats
CREATE OR REPLACE VIEW profile_view_stats AS
SELECT 
  profile_user_id as user_id,
  COUNT(*) as total_views,
  COUNT(DISTINCT viewer_user_id) as unique_viewers,
  MAX(viewed_at) as last_viewed_at,
  COUNT(CASE WHEN viewed_at >= NOW() - INTERVAL '7 days' THEN 1 END) as views_last_7_days,
  COUNT(CASE WHEN viewed_at >= NOW() - INTERVAL '30 days' THEN 1 END) as views_last_30_days
FROM profile_views
GROUP BY profile_user_id;

COMMENT ON TABLE user_preferences IS 'User customization preferences for theme, privacy, and notifications';
COMMENT ON TABLE profile_views IS 'Tracks profile view analytics';
COMMENT ON TABLE user_badges IS 'User-earned badges and achievements for profile display';
