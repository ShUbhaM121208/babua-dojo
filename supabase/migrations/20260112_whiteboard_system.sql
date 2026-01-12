-- Collaborative Whiteboard System for Doubt Arena
-- Migration: 20260112_whiteboard_system.sql

-- Table: whiteboard_rooms
-- Stores whiteboard session/room information
CREATE TABLE IF NOT EXISTS public.whiteboard_rooms (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  room_code TEXT UNIQUE NOT NULL,
  solver_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'closed')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  closed_at TIMESTAMPTZ,
  max_participants INTEGER DEFAULT 10,
  CONSTRAINT valid_room_code CHECK (length(room_code) = 6)
);

-- Table: whiteboard_participants
-- Tracks users in each whiteboard room
CREATE TABLE IF NOT EXISTS public.whiteboard_participants (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  room_id UUID NOT NULL REFERENCES public.whiteboard_rooms(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  username TEXT NOT NULL,
  is_solver BOOLEAN NOT NULL DEFAULT false,
  joined_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  left_at TIMESTAMPTZ,
  is_active BOOLEAN NOT NULL DEFAULT true,
  UNIQUE(room_id, user_id)
);

-- Table: whiteboard_events
-- Stores drawing events for persistence and late joiners
CREATE TABLE IF NOT EXISTS public.whiteboard_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  room_id UUID NOT NULL REFERENCES public.whiteboard_rooms(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  event_type TEXT NOT NULL CHECK (event_type IN ('draw', 'erase', 'text', 'shape', 'clear', 'undo')),
  event_data JSONB NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  sequence_number BIGSERIAL
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_whiteboard_rooms_solver ON public.whiteboard_rooms(solver_id);
CREATE INDEX IF NOT EXISTS idx_whiteboard_rooms_status ON public.whiteboard_rooms(status);
CREATE INDEX IF NOT EXISTS idx_whiteboard_rooms_code ON public.whiteboard_rooms(room_code);
CREATE INDEX IF NOT EXISTS idx_whiteboard_participants_room ON public.whiteboard_participants(room_id);
CREATE INDEX IF NOT EXISTS idx_whiteboard_participants_user ON public.whiteboard_participants(user_id);
CREATE INDEX IF NOT EXISTS idx_whiteboard_participants_active ON public.whiteboard_participants(is_active) WHERE is_active = true;
CREATE INDEX IF NOT EXISTS idx_whiteboard_events_room ON public.whiteboard_events(room_id, sequence_number);
CREATE INDEX IF NOT EXISTS idx_whiteboard_events_created ON public.whiteboard_events(created_at);

-- Enable Row Level Security
ALTER TABLE public.whiteboard_rooms ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.whiteboard_participants ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.whiteboard_events ENABLE ROW LEVEL SECURITY;

-- RLS Policies: whiteboard_rooms
-- Solvers can create and manage their own rooms
CREATE POLICY "Users can create rooms"
  ON public.whiteboard_rooms
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = solver_id);

-- Anyone authenticated can view active rooms
CREATE POLICY "Anyone can view active rooms"
  ON public.whiteboard_rooms
  FOR SELECT
  TO authenticated
  USING (status = 'active');

-- Solvers can update their own rooms
CREATE POLICY "Solvers can update own rooms"
  ON public.whiteboard_rooms
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = solver_id);

-- RLS Policies: whiteboard_participants
-- Users can join rooms (insert their own participant record)
CREATE POLICY "Users can join rooms"
  ON public.whiteboard_participants
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Participants can view all participants (simpler, no recursion)
CREATE POLICY "Participants can view room members"
  ON public.whiteboard_participants
  FOR SELECT
  TO authenticated
  USING (true);

-- Participants can update their own records
CREATE POLICY "Participants can update own records"
  ON public.whiteboard_participants
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id);

-- RLS Policies: whiteboard_events
-- Participants can insert drawing events (check against whiteboard_rooms via join)
CREATE POLICY "Participants can create events"
  ON public.whiteboard_events
  FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.whiteboard_rooms
      WHERE id = room_id 
      AND (solver_id = auth.uid() OR status = 'active')
    )
  );

-- Participants can view events from any active room
CREATE POLICY "Participants can view room events"
  ON public.whiteboard_events
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.whiteboard_rooms
      WHERE id = room_id AND status = 'active'
    )
  );

-- Function: Clean up old closed rooms (optional, can be called via cron)
CREATE OR REPLACE FUNCTION cleanup_old_whiteboard_rooms()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  DELETE FROM public.whiteboard_rooms
  WHERE status = 'closed'
    AND closed_at < now() - INTERVAL '7 days';
END;
$$;

-- Function: Get active participant count for a room
CREATE OR REPLACE FUNCTION get_room_participant_count(p_room_id UUID)
RETURNS INTEGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  participant_count INTEGER;
BEGIN
  SELECT COUNT(*)
  INTO participant_count
  FROM public.whiteboard_participants
  WHERE room_id = p_room_id AND is_active = true;
  
  RETURN participant_count;
END;
$$;

-- Enable Realtime for live updates
ALTER PUBLICATION supabase_realtime ADD TABLE public.whiteboard_rooms;
ALTER PUBLICATION supabase_realtime ADD TABLE public.whiteboard_participants;
ALTER PUBLICATION supabase_realtime ADD TABLE public.whiteboard_events;

-- Grant necessary permissions
GRANT ALL ON public.whiteboard_rooms TO authenticated;
GRANT ALL ON public.whiteboard_participants TO authenticated;
GRANT ALL ON public.whiteboard_events TO authenticated;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO authenticated;

COMMENT ON TABLE public.whiteboard_rooms IS 'Stores collaborative whiteboard room sessions';
COMMENT ON TABLE public.whiteboard_participants IS 'Tracks participants in whiteboard rooms';
COMMENT ON TABLE public.whiteboard_events IS 'Stores drawing events for persistence and synchronization';
