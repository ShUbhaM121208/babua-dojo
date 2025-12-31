-- Add additional profile fields to match TakeUForward UI
ALTER TABLE user_profiles ADD COLUMN IF NOT EXISTS username TEXT;
ALTER TABLE user_profiles ADD COLUMN IF NOT EXISTS avatar_url TEXT;
ALTER TABLE user_profiles ADD COLUMN IF NOT EXISTS bio TEXT;
ALTER TABLE user_profiles ADD COLUMN IF NOT EXISTS college TEXT;
ALTER TABLE user_profiles ADD COLUMN IF NOT EXISTS location TEXT;
ALTER TABLE user_profiles ADD COLUMN IF NOT EXISTS website TEXT;
ALTER TABLE user_profiles ADD COLUMN IF NOT EXISTS instagram_url TEXT;
ALTER TABLE user_profiles ADD COLUMN IF NOT EXISTS linkedin_url TEXT;
ALTER TABLE user_profiles ADD COLUMN IF NOT EXISTS twitter_url TEXT;
ALTER TABLE user_profiles ADD COLUMN IF NOT EXISTS leetcode_username TEXT;
ALTER TABLE user_profiles ADD COLUMN IF NOT EXISTS github_username TEXT;
ALTER TABLE user_profiles ADD COLUMN IF NOT EXISTS codeforces_username TEXT;
ALTER TABLE user_profiles ADD COLUMN IF NOT EXISTS codechef_username TEXT;

-- Add sheet names for progress tracking
CREATE TABLE IF NOT EXISTS sheets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL UNIQUE,
  slug TEXT NOT NULL UNIQUE,
  total_problems INTEGER NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert default sheets
INSERT INTO sheets (name, slug, total_problems) VALUES
  ('DSA Mastery Path', 'dsa-mastery-path', 456),
  ('Interview Prep Track', 'interview-prep-track', 79),
  ('System Design Essentials', 'system-design-essentials', 191),
  ('Core Concepts', 'core-concepts', 75)
ON CONFLICT (slug) DO NOTHING;

-- User sheet progress
CREATE TABLE IF NOT EXISTS user_sheet_progress (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  sheet_slug TEXT NOT NULL,
  problems_solved INTEGER DEFAULT 0,
  total_problems INTEGER NOT NULL,
  progress_percentage INTEGER DEFAULT 0,
  last_activity_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, sheet_slug)
);

-- Enable RLS for new tables
ALTER TABLE user_sheet_progress ENABLE ROW LEVEL SECURITY;

-- RLS policies for user_sheet_progress
CREATE POLICY "Users can view own sheet progress" ON user_sheet_progress
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own sheet progress" ON user_sheet_progress
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own sheet progress" ON user_sheet_progress
  FOR UPDATE USING (auth.uid() = user_id);

-- Create index
CREATE INDEX IF NOT EXISTS idx_user_sheet_progress_user_id ON user_sheet_progress(user_id);
