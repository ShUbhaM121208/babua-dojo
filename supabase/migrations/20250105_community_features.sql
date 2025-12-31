-- Community Features Tables
-- Tables for social features, posts, rooms, and leaderboards

-- Table: community_posts
CREATE TABLE IF NOT EXISTS public.community_posts (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    username TEXT NOT NULL,
    avatar_url TEXT,
    content TEXT NOT NULL,
    likes_count INTEGER DEFAULT 0,
    replies_count INTEGER DEFAULT 0,
    tags TEXT[] DEFAULT '{}',
    is_pinned BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Table: community_post_likes
CREATE TABLE IF NOT EXISTS public.community_post_likes (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    post_id UUID NOT NULL REFERENCES public.community_posts(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    UNIQUE(post_id, user_id)
);

-- Table: community_post_replies
CREATE TABLE IF NOT EXISTS public.community_post_replies (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    post_id UUID NOT NULL REFERENCES public.community_posts(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    username TEXT NOT NULL,
    content TEXT NOT NULL,
    likes_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Table: accountability_rooms
CREATE TABLE IF NOT EXISTS public.accountability_rooms (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    created_by UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    max_members INTEGER DEFAULT 5,
    current_members INTEGER DEFAULT 1,
    room_streak INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    room_code TEXT UNIQUE,
    tags TEXT[] DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Table: accountability_room_members
CREATE TABLE IF NOT EXISTS public.accountability_room_members (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    room_id UUID NOT NULL REFERENCES public.accountability_rooms(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    username TEXT NOT NULL,
    joined_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    personal_streak INTEGER DEFAULT 0,
    last_activity_date DATE,
    is_active BOOLEAN DEFAULT TRUE,
    UNIQUE(room_id, user_id)
);

-- Table: weekly_leaderboard
CREATE TABLE IF NOT EXISTS public.weekly_leaderboard (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    username TEXT NOT NULL,
    week_start DATE NOT NULL,
    week_end DATE NOT NULL,
    problems_solved INTEGER DEFAULT 0,
    points_earned INTEGER DEFAULT 0,
    rank INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    UNIQUE(user_id, week_start)
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_community_posts_user_id ON public.community_posts(user_id);
CREATE INDEX IF NOT EXISTS idx_community_posts_created_at ON public.community_posts(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_post_likes_post_id ON public.community_post_likes(post_id);
CREATE INDEX IF NOT EXISTS idx_post_replies_post_id ON public.community_post_replies(post_id);
CREATE INDEX IF NOT EXISTS idx_accountability_rooms_active ON public.accountability_rooms(is_active) WHERE is_active = TRUE;
CREATE INDEX IF NOT EXISTS idx_room_members_room_id ON public.accountability_room_members(room_id);
CREATE INDEX IF NOT EXISTS idx_weekly_leaderboard_week ON public.weekly_leaderboard(week_start, rank);

-- Enable RLS
ALTER TABLE public.community_posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.community_post_likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.community_post_replies ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.accountability_rooms ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.accountability_room_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.weekly_leaderboard ENABLE ROW LEVEL SECURITY;

-- RLS Policies for community_posts
DROP POLICY IF EXISTS "Anyone can view posts" ON public.community_posts;
CREATE POLICY "Anyone can view posts" ON public.community_posts
    FOR SELECT USING (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "Users can create posts" ON public.community_posts;
CREATE POLICY "Users can create posts" ON public.community_posts
    FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can update own posts" ON public.community_posts;
CREATE POLICY "Users can update own posts" ON public.community_posts
    FOR UPDATE USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can delete own posts" ON public.community_posts;
CREATE POLICY "Users can delete own posts" ON public.community_posts
    FOR DELETE USING (auth.uid() = user_id);

-- RLS Policies for community_post_likes
DROP POLICY IF EXISTS "Anyone can view likes" ON public.community_post_likes;
CREATE POLICY "Anyone can view likes" ON public.community_post_likes
    FOR SELECT USING (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "Users can like posts" ON public.community_post_likes;
CREATE POLICY "Users can like posts" ON public.community_post_likes
    FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can unlike posts" ON public.community_post_likes;
CREATE POLICY "Users can unlike posts" ON public.community_post_likes
    FOR DELETE USING (auth.uid() = user_id);

-- RLS Policies for community_post_replies
DROP POLICY IF EXISTS "Anyone can view replies" ON public.community_post_replies;
CREATE POLICY "Anyone can view replies" ON public.community_post_replies
    FOR SELECT USING (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "Users can create replies" ON public.community_post_replies;
CREATE POLICY "Users can create replies" ON public.community_post_replies
    FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can update own replies" ON public.community_post_replies;
CREATE POLICY "Users can update own replies" ON public.community_post_replies
    FOR UPDATE USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can delete own replies" ON public.community_post_replies;
CREATE POLICY "Users can delete own replies" ON public.community_post_replies
    FOR DELETE USING (auth.uid() = user_id);

-- RLS Policies for accountability_rooms
DROP POLICY IF EXISTS "Anyone can view rooms" ON public.accountability_rooms;
CREATE POLICY "Anyone can view rooms" ON public.accountability_rooms
    FOR SELECT USING (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "Users can create rooms" ON public.accountability_rooms;
CREATE POLICY "Users can create rooms" ON public.accountability_rooms
    FOR INSERT WITH CHECK (auth.uid() = created_by);

DROP POLICY IF EXISTS "Creator can update room" ON public.accountability_rooms;
CREATE POLICY "Creator can update room" ON public.accountability_rooms
    FOR UPDATE USING (auth.uid() = created_by);

DROP POLICY IF EXISTS "Creator can delete room" ON public.accountability_rooms;
CREATE POLICY "Creator can delete room" ON public.accountability_rooms
    FOR DELETE USING (auth.uid() = created_by);

-- RLS Policies for accountability_room_members
DROP POLICY IF EXISTS "Members can view room members" ON public.accountability_room_members;
CREATE POLICY "Members can view room members" ON public.accountability_room_members
    FOR SELECT USING (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "Users can join rooms" ON public.accountability_room_members;
CREATE POLICY "Users can join rooms" ON public.accountability_room_members
    FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can leave rooms" ON public.accountability_room_members;
CREATE POLICY "Users can leave rooms" ON public.accountability_room_members
    FOR DELETE USING (auth.uid() = user_id);

-- RLS Policies for weekly_leaderboard
DROP POLICY IF EXISTS "Anyone can view leaderboard" ON public.weekly_leaderboard;
CREATE POLICY "Anyone can view leaderboard" ON public.weekly_leaderboard
    FOR SELECT USING (auth.role() = 'authenticated');

-- Triggers
DROP TRIGGER IF EXISTS update_community_posts_updated_at ON public.community_posts;
CREATE TRIGGER update_community_posts_updated_at BEFORE UPDATE ON public.community_posts
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

DROP TRIGGER IF EXISTS update_accountability_rooms_updated_at ON public.accountability_rooms;
CREATE TRIGGER update_accountability_rooms_updated_at BEFORE UPDATE ON public.accountability_rooms
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- Function to update post likes count
CREATE OR REPLACE FUNCTION update_post_likes_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE public.community_posts 
        SET likes_count = likes_count + 1 
        WHERE id = NEW.post_id;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE public.community_posts 
        SET likes_count = GREATEST(likes_count - 1, 0) 
        WHERE id = OLD.post_id;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS after_post_like_change ON public.community_post_likes;
CREATE TRIGGER after_post_like_change
    AFTER INSERT OR DELETE ON public.community_post_likes
    FOR EACH ROW EXECUTE FUNCTION update_post_likes_count();

-- Function to update room member count
CREATE OR REPLACE FUNCTION update_room_member_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE public.accountability_rooms 
        SET current_members = current_members + 1 
        WHERE id = NEW.room_id;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE public.accountability_rooms 
        SET current_members = GREATEST(current_members - 1, 0) 
        WHERE id = OLD.room_id;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS after_room_member_change ON public.accountability_room_members;
CREATE TRIGGER after_room_member_change
    AFTER INSERT OR DELETE ON public.accountability_room_members
    FOR EACH ROW EXECUTE FUNCTION update_room_member_count();

-- Enable realtime
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_publication_tables 
        WHERE pubname = 'supabase_realtime' 
        AND tablename = 'community_posts'
    ) THEN
        ALTER PUBLICATION supabase_realtime ADD TABLE public.community_posts;
    END IF;
    
    IF NOT EXISTS (
        SELECT 1 FROM pg_publication_tables 
        WHERE pubname = 'supabase_realtime' 
        AND tablename = 'accountability_rooms'
    ) THEN
        ALTER PUBLICATION supabase_realtime ADD TABLE public.accountability_rooms;
    END IF;
END $$;
