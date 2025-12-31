-- Discussion Forums Migration
-- Implements threaded discussions, voting, and community engagement

-- ============================================
-- TABLES
-- ============================================

-- Forum Categories
CREATE TABLE IF NOT EXISTS forum_categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL UNIQUE,
  slug TEXT NOT NULL UNIQUE,
  description TEXT,
  icon TEXT, -- Emoji or icon name
  color TEXT DEFAULT '#3b82f6',
  display_order INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Discussion Threads
CREATE TABLE IF NOT EXISTS discussion_threads (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  author_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  category_id UUID REFERENCES forum_categories(id) ON DELETE SET NULL,
  
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  tags TEXT[] DEFAULT '{}',
  
  -- Engagement Metrics
  view_count INTEGER DEFAULT 0,
  reply_count INTEGER DEFAULT 0,
  upvote_count INTEGER DEFAULT 0,
  downvote_count INTEGER DEFAULT 0,
  
  -- Status
  is_pinned BOOLEAN DEFAULT false,
  is_locked BOOLEAN DEFAULT false,
  is_solved BOOLEAN DEFAULT false,
  is_deleted BOOLEAN DEFAULT false,
  
  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  last_activity_at TIMESTAMPTZ DEFAULT NOW(),
  
  -- Search
  search_vector tsvector
);

-- Discussion Replies
CREATE TABLE IF NOT EXISTS discussion_replies (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  thread_id UUID NOT NULL REFERENCES discussion_threads(id) ON DELETE CASCADE,
  author_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  parent_reply_id UUID REFERENCES discussion_replies(id) ON DELETE CASCADE,
  
  content TEXT NOT NULL,
  
  -- Engagement Metrics
  upvote_count INTEGER DEFAULT 0,
  downvote_count INTEGER DEFAULT 0,
  
  -- Status
  is_accepted_answer BOOLEAN DEFAULT false,
  is_deleted BOOLEAN DEFAULT false,
  is_edited BOOLEAN DEFAULT false,
  
  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  edited_at TIMESTAMPTZ
);

-- Thread Votes
CREATE TABLE IF NOT EXISTS thread_votes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  thread_id UUID NOT NULL REFERENCES discussion_threads(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  vote_type TEXT NOT NULL CHECK (vote_type IN ('upvote', 'downvote')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(thread_id, user_id)
);

-- Reply Votes
CREATE TABLE IF NOT EXISTS reply_votes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  reply_id UUID NOT NULL REFERENCES discussion_replies(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  vote_type TEXT NOT NULL CHECK (vote_type IN ('upvote', 'downvote')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(reply_id, user_id)
);

-- Thread Bookmarks
CREATE TABLE IF NOT EXISTS thread_bookmarks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  thread_id UUID NOT NULL REFERENCES discussion_threads(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(thread_id, user_id)
);

-- Thread Followers (for notifications)
CREATE TABLE IF NOT EXISTS thread_followers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  thread_id UUID NOT NULL REFERENCES discussion_threads(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(thread_id, user_id)
);

-- ============================================
-- INDEXES
-- ============================================

CREATE INDEX IF NOT EXISTS idx_threads_author ON discussion_threads(author_id);
CREATE INDEX IF NOT EXISTS idx_threads_category ON discussion_threads(category_id);
CREATE INDEX IF NOT EXISTS idx_threads_created ON discussion_threads(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_threads_activity ON discussion_threads(last_activity_at DESC);
CREATE INDEX IF NOT EXISTS idx_threads_tags ON discussion_threads USING GIN(tags);
CREATE INDEX IF NOT EXISTS idx_threads_search ON discussion_threads USING GIN(search_vector);
CREATE INDEX IF NOT EXISTS idx_threads_pinned_activity ON discussion_threads(is_pinned DESC, last_activity_at DESC);

CREATE INDEX IF NOT EXISTS idx_replies_thread ON discussion_replies(thread_id);
CREATE INDEX IF NOT EXISTS idx_replies_author ON discussion_replies(author_id);
CREATE INDEX IF NOT EXISTS idx_replies_parent ON discussion_replies(parent_reply_id);
CREATE INDEX IF NOT EXISTS idx_replies_created ON discussion_replies(created_at);

CREATE INDEX IF NOT EXISTS idx_thread_votes_thread ON thread_votes(thread_id);
CREATE INDEX IF NOT EXISTS idx_thread_votes_user ON thread_votes(user_id);
CREATE INDEX IF NOT EXISTS idx_reply_votes_reply ON reply_votes(reply_id);
CREATE INDEX IF NOT EXISTS idx_reply_votes_user ON reply_votes(user_id);

-- ============================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================

ALTER TABLE forum_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE discussion_threads ENABLE ROW LEVEL SECURITY;
ALTER TABLE discussion_replies ENABLE ROW LEVEL SECURITY;
ALTER TABLE thread_votes ENABLE ROW LEVEL SECURITY;
ALTER TABLE reply_votes ENABLE ROW LEVEL SECURITY;
ALTER TABLE thread_bookmarks ENABLE ROW LEVEL SECURITY;
ALTER TABLE thread_followers ENABLE ROW LEVEL SECURITY;

-- Forum Categories Policies
CREATE POLICY "Anyone can view active categories"
  ON forum_categories FOR SELECT
  USING (is_active = true);

-- Discussion Threads Policies
CREATE POLICY "Anyone can view non-deleted threads"
  ON discussion_threads FOR SELECT
  USING (is_deleted = false);

CREATE POLICY "Authenticated users can create threads"
  ON discussion_threads FOR INSERT
  WITH CHECK (auth.uid() = author_id);

CREATE POLICY "Authors can update their own threads"
  ON discussion_threads FOR UPDATE
  USING (auth.uid() = author_id);

CREATE POLICY "Authors can delete their own threads"
  ON discussion_threads FOR DELETE
  USING (auth.uid() = author_id);

-- Discussion Replies Policies
CREATE POLICY "Anyone can view non-deleted replies"
  ON discussion_replies FOR SELECT
  USING (is_deleted = false);

CREATE POLICY "Authenticated users can create replies"
  ON discussion_replies FOR INSERT
  WITH CHECK (auth.uid() = author_id);

CREATE POLICY "Authors can update their own replies"
  ON discussion_replies FOR UPDATE
  USING (auth.uid() = author_id);

CREATE POLICY "Authors can delete their own replies"
  ON discussion_replies FOR DELETE
  USING (auth.uid() = author_id);

-- Thread Votes Policies
CREATE POLICY "Users can view all votes"
  ON thread_votes FOR SELECT
  USING (true);

CREATE POLICY "Users can vote on threads"
  ON thread_votes FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own votes"
  ON thread_votes FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own votes"
  ON thread_votes FOR DELETE
  USING (auth.uid() = user_id);

-- Reply Votes Policies
CREATE POLICY "Users can view all reply votes"
  ON reply_votes FOR SELECT
  USING (true);

CREATE POLICY "Users can vote on replies"
  ON reply_votes FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own reply votes"
  ON reply_votes FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own reply votes"
  ON reply_votes FOR DELETE
  USING (auth.uid() = user_id);

-- Thread Bookmarks Policies
CREATE POLICY "Users can view their own bookmarks"
  ON thread_bookmarks FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own bookmarks"
  ON thread_bookmarks FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own bookmarks"
  ON thread_bookmarks FOR DELETE
  USING (auth.uid() = user_id);

-- Thread Followers Policies
CREATE POLICY "Users can view their own follows"
  ON thread_followers FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can follow threads"
  ON thread_followers FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can unfollow threads"
  ON thread_followers FOR DELETE
  USING (auth.uid() = user_id);

-- ============================================
-- FUNCTIONS
-- ============================================

-- Function to update thread search vector
CREATE OR REPLACE FUNCTION update_thread_search_vector()
RETURNS TRIGGER AS $$
BEGIN
  NEW.search_vector := 
    setweight(to_tsvector('english', COALESCE(NEW.title, '')), 'A') ||
    setweight(to_tsvector('english', COALESCE(NEW.content, '')), 'B') ||
    setweight(to_tsvector('english', COALESCE(array_to_string(NEW.tags, ' '), '')), 'C');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_update_thread_search ON discussion_threads;
CREATE TRIGGER trigger_update_thread_search
  BEFORE INSERT OR UPDATE ON discussion_threads
  FOR EACH ROW
  EXECUTE FUNCTION update_thread_search_vector();

-- Function to update thread activity timestamp
CREATE OR REPLACE FUNCTION update_thread_activity()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE discussion_threads
  SET last_activity_at = NOW(),
      reply_count = reply_count + 1
  WHERE id = NEW.thread_id;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_update_thread_activity ON discussion_replies;
CREATE TRIGGER trigger_update_thread_activity
  AFTER INSERT ON discussion_replies
  FOR EACH ROW
  EXECUTE FUNCTION update_thread_activity();

-- Function to handle thread voting
CREATE OR REPLACE FUNCTION handle_thread_vote()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    -- Add vote
    IF NEW.vote_type = 'upvote' THEN
      UPDATE discussion_threads SET upvote_count = upvote_count + 1 WHERE id = NEW.thread_id;
    ELSE
      UPDATE discussion_threads SET downvote_count = downvote_count + 1 WHERE id = NEW.thread_id;
    END IF;
  ELSIF TG_OP = 'UPDATE' THEN
    -- Change vote
    IF OLD.vote_type = 'upvote' AND NEW.vote_type = 'downvote' THEN
      UPDATE discussion_threads 
      SET upvote_count = upvote_count - 1, downvote_count = downvote_count + 1 
      WHERE id = NEW.thread_id;
    ELSIF OLD.vote_type = 'downvote' AND NEW.vote_type = 'upvote' THEN
      UPDATE discussion_threads 
      SET upvote_count = upvote_count + 1, downvote_count = downvote_count - 1 
      WHERE id = NEW.thread_id;
    END IF;
  ELSIF TG_OP = 'DELETE' THEN
    -- Remove vote
    IF OLD.vote_type = 'upvote' THEN
      UPDATE discussion_threads SET upvote_count = upvote_count - 1 WHERE id = OLD.thread_id;
    ELSE
      UPDATE discussion_threads SET downvote_count = downvote_count - 1 WHERE id = OLD.thread_id;
    END IF;
  END IF;
  
  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_handle_thread_vote ON thread_votes;
CREATE TRIGGER trigger_handle_thread_vote
  AFTER INSERT OR UPDATE OR DELETE ON thread_votes
  FOR EACH ROW
  EXECUTE FUNCTION handle_thread_vote();

-- Function to handle reply voting
CREATE OR REPLACE FUNCTION handle_reply_vote()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    IF NEW.vote_type = 'upvote' THEN
      UPDATE discussion_replies SET upvote_count = upvote_count + 1 WHERE id = NEW.reply_id;
    ELSE
      UPDATE discussion_replies SET downvote_count = downvote_count + 1 WHERE id = NEW.reply_id;
    END IF;
  ELSIF TG_OP = 'UPDATE' THEN
    IF OLD.vote_type = 'upvote' AND NEW.vote_type = 'downvote' THEN
      UPDATE discussion_replies 
      SET upvote_count = upvote_count - 1, downvote_count = downvote_count + 1 
      WHERE id = NEW.reply_id;
    ELSIF OLD.vote_type = 'downvote' AND NEW.vote_type = 'upvote' THEN
      UPDATE discussion_replies 
      SET upvote_count = upvote_count + 1, downvote_count = downvote_count - 1 
      WHERE id = NEW.reply_id;
    END IF;
  ELSIF TG_OP = 'DELETE' THEN
    IF OLD.vote_type = 'upvote' THEN
      UPDATE discussion_replies SET upvote_count = upvote_count - 1 WHERE id = OLD.reply_id;
    ELSE
      UPDATE discussion_replies SET downvote_count = downvote_count - 1 WHERE id = OLD.reply_id;
    END IF;
  END IF;
  
  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_handle_reply_vote ON reply_votes;
CREATE TRIGGER trigger_handle_reply_vote
  AFTER INSERT OR UPDATE OR DELETE ON reply_votes
  FOR EACH ROW
  EXECUTE FUNCTION handle_reply_vote();

-- Function to auto-follow threads on reply
CREATE OR REPLACE FUNCTION auto_follow_thread()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO thread_followers (thread_id, user_id)
  VALUES (NEW.thread_id, NEW.author_id)
  ON CONFLICT DO NOTHING;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_auto_follow ON discussion_replies;
CREATE TRIGGER trigger_auto_follow
  AFTER INSERT ON discussion_replies
  FOR EACH ROW
  EXECUTE FUNCTION auto_follow_thread();

-- ============================================
-- HELPER VIEWS
-- ============================================

-- View for thread list with author info
CREATE OR REPLACE VIEW thread_list_view AS
SELECT 
  t.id,
  t.title,
  t.content,
  t.tags,
  t.view_count,
  t.reply_count,
  t.upvote_count,
  t.downvote_count,
  t.is_pinned,
  t.is_locked,
  t.is_solved,
  t.created_at,
  t.last_activity_at,
  t.category_id,
  fc.name as category_name,
  fc.slug as category_slug,
  fc.color as category_color,
  t.author_id,
  up.username as author_username,
  up.avatar_url as author_avatar
FROM discussion_threads t
LEFT JOIN forum_categories fc ON t.category_id = fc.id
LEFT JOIN user_profiles up ON t.author_id = up.id
WHERE t.is_deleted = false
ORDER BY t.is_pinned DESC, t.last_activity_at DESC;

-- ============================================
-- SEED DEFAULT CATEGORIES
-- ============================================

INSERT INTO forum_categories (name, slug, description, icon, color, display_order) VALUES
  ('General Discussion', 'general', 'General programming and tech discussions', '💬', '#3b82f6', 1),
  ('DSA Help', 'dsa-help', 'Get help with data structures and algorithms', '🧮', '#10b981', 2),
  ('Problem Solutions', 'solutions', 'Share and discuss problem solutions', '💡', '#f59e0b', 3),
  ('Career Advice', 'career', 'Interview prep, job search, and career guidance', '💼', '#8b5cf6', 4),
  ('Code Review', 'code-review', 'Get feedback on your code', '🔍', '#ef4444', 5),
  ('Resources', 'resources', 'Share learning resources and tutorials', '📚', '#06b6d4', 6)
ON CONFLICT (slug) DO NOTHING;

COMMENT ON TABLE forum_categories IS 'Discussion forum categories';
COMMENT ON TABLE discussion_threads IS 'Discussion thread posts';
COMMENT ON TABLE discussion_replies IS 'Replies to discussion threads';
COMMENT ON TABLE thread_votes IS 'Upvotes and downvotes on threads';
COMMENT ON TABLE reply_votes IS 'Upvotes and downvotes on replies';
