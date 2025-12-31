-- Week 3: Real-time Battle Royale Database Schema
-- This migration adds tables for WebSocket-powered real-time battles

-- Create battle_submissions table for tracking code submissions
CREATE TABLE IF NOT EXISTS battle_submissions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  room_id UUID NOT NULL REFERENCES battle_rooms(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  code TEXT NOT NULL,
  language TEXT NOT NULL,
  tests_passed INTEGER NOT NULL,
  total_tests INTEGER NOT NULL,
  time_taken INTEGER NOT NULL, -- milliseconds
  rank INTEGER,
  submitted_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Add indices for performance
CREATE INDEX IF NOT EXISTS idx_battle_submissions_room ON battle_submissions(room_id, submitted_at DESC);
CREATE INDEX IF NOT EXISTS idx_battle_submissions_user ON battle_submissions(user_id, submitted_at DESC);
CREATE INDEX IF NOT EXISTS idx_battle_submissions_rank ON battle_submissions(room_id, rank);

-- Enable RLS
ALTER TABLE battle_submissions ENABLE ROW LEVEL SECURITY;

-- RLS Policies for battle_submissions
CREATE POLICY "Users can view submissions in their rooms"
  ON battle_submissions FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM battle_participants
      WHERE battle_participants.battle_room_id = battle_submissions.room_id
      AND battle_participants.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can insert own submissions"
  ON battle_submissions FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Update battle_rooms table with WebSocket fields
ALTER TABLE battle_rooms 
  ADD COLUMN IF NOT EXISTS current_participants INTEGER DEFAULT 0,
  ADD COLUMN IF NOT EXISTS winner_id UUID REFERENCES auth.users(id),
  ADD COLUMN IF NOT EXISTS winner_username TEXT,
  ADD COLUMN IF NOT EXISTS winner_score INTEGER;

-- Update battle_participants with more status tracking
ALTER TABLE battle_participants
  ADD COLUMN IF NOT EXISTS last_seen TIMESTAMPTZ DEFAULT NOW(),
  ADD COLUMN IF NOT EXISTS connection_status TEXT DEFAULT 'connected' CHECK (connection_status IN ('connected', 'disconnected')),
  ADD COLUMN IF NOT EXISTS tests_passed INTEGER DEFAULT 0,
  ADD COLUMN IF NOT EXISTS total_tests INTEGER DEFAULT 0,
  ADD COLUMN IF NOT EXISTS time_taken INTEGER, -- milliseconds
  ADD COLUMN IF NOT EXISTS submission_time TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS final_rank INTEGER;

-- Create index for active participants
CREATE INDEX IF NOT EXISTS idx_battle_participants_active 
  ON battle_participants(battle_room_id, status, connection_status);

-- Function to update current_participants count
CREATE OR REPLACE FUNCTION update_room_participant_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
    UPDATE battle_rooms
    SET current_participants = (
      SELECT COUNT(*)
      FROM battle_participants
      WHERE battle_room_id = NEW.battle_room_id
      AND status = 'active'
      AND connection_status = 'connected'
    )
    WHERE id = NEW.battle_room_id;
  END IF;
  
  IF TG_OP = 'DELETE' THEN
    UPDATE battle_rooms
    SET current_participants = (
      SELECT COUNT(*)
      FROM battle_participants
      WHERE battle_room_id = OLD.battle_room_id
      AND status = 'active'
      AND connection_status = 'connected'
    )
    WHERE id = OLD.battle_room_id;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for participant count
DROP TRIGGER IF EXISTS trigger_update_participant_count ON battle_participants;
CREATE TRIGGER trigger_update_participant_count
AFTER INSERT OR UPDATE OR DELETE ON battle_participants
FOR EACH ROW
EXECUTE FUNCTION update_room_participant_count();

-- Function to calculate battle winner
CREATE OR REPLACE FUNCTION calculate_battle_winner(p_room_id UUID)
RETURNS TABLE (
  user_id UUID,
  username TEXT,
  score INTEGER,
  tests_passed INTEGER,
  time_taken INTEGER
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    bp.user_id,
    u.raw_user_meta_data->>'full_name' AS username,
    (bp.tests_passed * 1000 - bp.time_taken) AS score,
    bp.tests_passed,
    bp.time_taken
  FROM battle_participants bp
  JOIN auth.users u ON u.id = bp.user_id
  WHERE bp.battle_room_id = p_room_id
  AND bp.status = 'active'
  AND bp.tests_passed IS NOT NULL
  ORDER BY bp.tests_passed DESC, bp.time_taken ASC
  LIMIT 1;
END;
$$ LANGUAGE plpgsql;

-- Function to update battle room status and winner
CREATE OR REPLACE FUNCTION finish_battle_room(p_room_id UUID)
RETURNS VOID AS $$
DECLARE
  v_winner RECORD;
BEGIN
  -- Get winner
  SELECT * INTO v_winner
  FROM calculate_battle_winner(p_room_id);
  
  -- Update room
  UPDATE battle_rooms
  SET 
    status = 'finished',
    end_time = NOW(),
    winner_id = v_winner.user_id,
    winner_username = v_winner.username,
    winner_score = v_winner.score
  WHERE id = p_room_id;
  
  -- Update final ranks
  WITH ranked_participants AS (
    SELECT 
      user_id,
      ROW_NUMBER() OVER (ORDER BY tests_passed DESC, time_taken ASC) as rank
    FROM battle_participants
    WHERE battle_room_id = p_room_id
    AND status = 'active'
    AND tests_passed IS NOT NULL
  )
  UPDATE battle_participants bp
  SET final_rank = rp.rank
  FROM ranked_participants rp
  WHERE bp.battle_room_id = p_room_id
  AND bp.user_id = rp.user_id;
END;
$$ LANGUAGE plpgsql;

-- Create view for live leaderboard
CREATE OR REPLACE VIEW battle_leaderboard AS
SELECT 
  bp.battle_room_id,
  bp.user_id,
  u.raw_user_meta_data->>'full_name' AS username,
  u.email,
  bp.tests_passed,
  bp.total_tests,
  bp.time_taken,
  bp.submission_time,
  bp.connection_status,
  ROW_NUMBER() OVER (
    PARTITION BY bp.battle_room_id 
    ORDER BY bp.tests_passed DESC, bp.time_taken ASC NULLS LAST
  ) as current_rank
FROM battle_participants bp
JOIN auth.users u ON u.id = bp.user_id
WHERE bp.status = 'active'
AND bp.tests_passed IS NOT NULL
ORDER BY bp.battle_room_id, current_rank;

-- Grant permissions
GRANT SELECT ON battle_leaderboard TO authenticated;
GRANT SELECT, INSERT ON battle_submissions TO authenticated;

-- Comments
COMMENT ON TABLE battle_submissions IS 'Stores code submissions during battle royale matches';
COMMENT ON COLUMN battle_rooms.current_participants IS 'Real-time count of active connected participants';
COMMENT ON COLUMN battle_participants.connection_status IS 'WebSocket connection status for real-time tracking';
COMMENT ON FUNCTION finish_battle_room IS 'Finalizes battle, calculates winner and ranks';

-- Summary
SELECT 
  'battle_submissions' as table_name,
  COUNT(*) as row_count
FROM battle_submissions
UNION ALL
SELECT 
  'battle_rooms_with_realtime',
  COUNT(*)
FROM battle_rooms
WHERE current_participants IS NOT NULL;
