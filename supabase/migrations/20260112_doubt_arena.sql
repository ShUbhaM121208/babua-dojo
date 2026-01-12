-- Doubt Arena - Q&A Forum System
-- Migration: 20260112_doubt_arena.sql

-- Table: doubts
-- Stores questions/doubts posted by users
CREATE TABLE IF NOT EXISTS public.doubts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  username TEXT NOT NULL,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  problem_link TEXT,
  is_resolved BOOLEAN NOT NULL DEFAULT false,
  upvotes INTEGER NOT NULL DEFAULT 0,
  reply_count INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Table: doubt_replies
-- Stores replies to doubts
CREATE TABLE IF NOT EXISTS public.doubt_replies (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  doubt_id UUID NOT NULL REFERENCES public.doubts(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  username TEXT NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_doubts_user ON public.doubts(user_id);
CREATE INDEX IF NOT EXISTS idx_doubts_created ON public.doubts(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_doubts_resolved ON public.doubts(is_resolved);
CREATE INDEX IF NOT EXISTS idx_doubt_replies_doubt ON public.doubt_replies(doubt_id);
CREATE INDEX IF NOT EXISTS idx_doubt_replies_user ON public.doubt_replies(user_id);

-- Enable RLS
ALTER TABLE public.doubts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.doubt_replies ENABLE ROW LEVEL SECURITY;

-- RLS Policies: doubts
CREATE POLICY "Anyone can view doubts"
  ON public.doubts
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Users can create doubts"
  ON public.doubts
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own doubts"
  ON public.doubts
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own doubts"
  ON public.doubts
  FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- RLS Policies: doubt_replies
CREATE POLICY "Anyone can view replies"
  ON public.doubt_replies
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Users can create replies"
  ON public.doubt_replies
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own replies"
  ON public.doubt_replies
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own replies"
  ON public.doubt_replies
  FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- Enable Realtime
ALTER PUBLICATION supabase_realtime ADD TABLE public.doubts;
ALTER PUBLICATION supabase_realtime ADD TABLE public.doubt_replies;

-- Grants
GRANT ALL ON public.doubts TO authenticated;
GRANT ALL ON public.doubt_replies TO authenticated;

COMMENT ON TABLE public.doubts IS 'User questions and doubts for Q&A forum';
COMMENT ON TABLE public.doubt_replies IS 'Replies to doubts';
