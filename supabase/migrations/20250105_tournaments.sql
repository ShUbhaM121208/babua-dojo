-- Migration: Tournament System - Competitive coding tournaments
-- This enables users to participate in scheduled tournaments with prizes

-- Create tournaments table
CREATE TABLE IF NOT EXISTS tournaments (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  start_time TIMESTAMPTZ NOT NULL,
  end_time TIMESTAMPTZ NOT NULL,
  problem_ids TEXT[] NOT NULL, -- Array of problem IDs
  max_participants INTEGER,
  prize_pool TEXT,
  entry_fee INTEGER DEFAULT 0, -- XP required to enter
  min_rank_required TEXT, -- Minimum rank to participate
  status TEXT NOT NULL CHECK (status IN ('upcoming', 'live', 'completed', 'cancelled')) DEFAULT 'upcoming',
  banner_url TEXT,
  rules TEXT,
  created_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()) NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()) NOT NULL,
  
  -- Ensure end time is after start time
  CONSTRAINT valid_time_range CHECK (end_time > start_time)
);

-- Create tournament registrations table
CREATE TABLE IF NOT EXISTS tournament_registrations (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  tournament_id UUID NOT NULL REFERENCES tournaments(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  registered_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()) NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('registered', 'checked_in', 'disqualified', 'withdrawn')) DEFAULT 'registered',
  
  -- One registration per user per tournament
  UNIQUE(tournament_id, user_id)
);

-- Create tournament submissions table
CREATE TABLE IF NOT EXISTS tournament_submissions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  tournament_id UUID NOT NULL REFERENCES tournaments(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  problem_id TEXT NOT NULL,
  submission_id UUID REFERENCES problem_submissions(id),
  language TEXT NOT NULL,
  code TEXT NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('accepted', 'wrong_answer', 'runtime_error', 'compile_error', 'time_limit_exceeded', 'memory_limit_exceeded')),
  test_results JSONB NOT NULL DEFAULT '[]'::jsonb,
  passed_count INTEGER NOT NULL DEFAULT 0,
  failed_count INTEGER NOT NULL DEFAULT 0,
  total_time DECIMAL DEFAULT 0,
  penalty_time INTEGER DEFAULT 0, -- Penalty in minutes for wrong submissions
  submitted_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Create index for leaderboard queries on tournament_submissions
CREATE INDEX IF NOT EXISTS idx_tournament_submissions_leaderboard 
  ON tournament_submissions(tournament_id, user_id, status, submitted_at);

-- Create tournament leaderboard table (cached for performance)
CREATE TABLE IF NOT EXISTS tournament_leaderboard (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  tournament_id UUID NOT NULL REFERENCES tournaments(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  rank INTEGER NOT NULL,
  score INTEGER NOT NULL DEFAULT 0, -- Problems solved
  total_time DECIMAL NOT NULL DEFAULT 0, -- Time taken (seconds)
  penalty_time INTEGER NOT NULL DEFAULT 0, -- Penalty minutes
  last_submission_at TIMESTAMPTZ,
  problems_solved TEXT[] DEFAULT '{}', -- Array of solved problem IDs
  updated_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()) NOT NULL,
  
  -- One entry per user per tournament
  UNIQUE(tournament_id, user_id)
);

-- Create tournament prizes table
CREATE TABLE IF NOT EXISTS tournament_prizes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  tournament_id UUID NOT NULL REFERENCES tournaments(id) ON DELETE CASCADE,
  rank_from INTEGER NOT NULL,
  rank_to INTEGER NOT NULL,
  prize_type TEXT NOT NULL CHECK (prize_type IN ('xp', 'badge', 'title', 'certificate', 'cash')),
  prize_value TEXT NOT NULL,
  prize_description TEXT,
  
  -- Ensure valid rank range
  CONSTRAINT valid_rank_range CHECK (rank_to >= rank_from)
);

-- Create tournament editorials table
CREATE TABLE IF NOT EXISTS tournament_editorials (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  tournament_id UUID NOT NULL REFERENCES tournaments(id) ON DELETE CASCADE,
  problem_id TEXT NOT NULL,
  author_id UUID REFERENCES auth.users(id),
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  video_url TEXT,
  code_examples JSONB DEFAULT '[]'::jsonb,
  published_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()) NOT NULL,
  
  UNIQUE(tournament_id, problem_id)
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_tournaments_status ON tournaments(status, start_time);
CREATE INDEX IF NOT EXISTS idx_tournaments_dates ON tournaments(start_time, end_time);
CREATE INDEX IF NOT EXISTS idx_registrations_tournament ON tournament_registrations(tournament_id, status);
CREATE INDEX IF NOT EXISTS idx_registrations_user ON tournament_registrations(user_id, status);
CREATE INDEX IF NOT EXISTS idx_leaderboard_tournament_rank ON tournament_leaderboard(tournament_id, rank);

-- Function to update tournament status based on time
CREATE OR REPLACE FUNCTION update_tournament_status()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Mark tournaments as live
  UPDATE tournaments
  SET status = 'live', updated_at = NOW()
  WHERE status = 'upcoming'
    AND start_time <= NOW()
    AND end_time > NOW();
  
  -- Mark tournaments as completed
  UPDATE tournaments
  SET status = 'completed', updated_at = NOW()
  WHERE status = 'live'
    AND end_time <= NOW();
END;
$$;

-- Function to calculate tournament leaderboard
CREATE OR REPLACE FUNCTION calculate_tournament_leaderboard(p_tournament_id UUID)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Delete existing leaderboard entries for this tournament
  DELETE FROM tournament_leaderboard WHERE tournament_id = p_tournament_id;
  
  -- Calculate and insert new leaderboard
  INSERT INTO tournament_leaderboard (
    tournament_id,
    user_id,
    rank,
    score,
    total_time,
    penalty_time,
    last_submission_at,
    problems_solved
  )
  SELECT 
    p_tournament_id,
    user_id,
    ROW_NUMBER() OVER (
      ORDER BY 
        problems_solved_count DESC,
        (total_time_seconds + (penalty_minutes * 60)) ASC,
        last_submission ASC
    ) as rank,
    problems_solved_count as score,
    total_time_seconds as total_time,
    penalty_minutes as penalty_time,
    last_submission as last_submission_at,
    solved_problems as problems_solved
  FROM (
    SELECT
      ts.user_id,
      COUNT(DISTINCT CASE WHEN ts.status = 'accepted' THEN ts.problem_id END) as problems_solved_count,
      SUM(CASE WHEN ts.status = 'accepted' THEN ts.total_time ELSE 0 END) as total_time_seconds,
      SUM(CASE WHEN ts.status != 'accepted' THEN 20 ELSE 0 END) as penalty_minutes,
      MAX(ts.submitted_at) as last_submission,
      ARRAY_AGG(DISTINCT ts.problem_id) FILTER (WHERE ts.status = 'accepted') as solved_problems
    FROM tournament_submissions ts
    WHERE ts.tournament_id = p_tournament_id
    GROUP BY ts.user_id
  ) subquery;
END;
$$;

-- Function to update leaderboard on submission
CREATE OR REPLACE FUNCTION update_leaderboard_on_submission()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  -- Recalculate leaderboard for the tournament
  PERFORM calculate_tournament_leaderboard(NEW.tournament_id);
  RETURN NEW;
END;
$$;

-- Trigger to update leaderboard when submission is made
DROP TRIGGER IF EXISTS trigger_update_leaderboard ON tournament_submissions;
CREATE TRIGGER trigger_update_leaderboard
  AFTER INSERT OR UPDATE ON tournament_submissions
  FOR EACH ROW
  EXECUTE FUNCTION update_leaderboard_on_submission();

-- Function to auto-register user's submission to tournament
CREATE OR REPLACE FUNCTION link_submission_to_tournament()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
  v_tournament_id UUID;
  v_is_registered BOOLEAN;
BEGIN
  -- Find active tournament containing this problem
  SELECT t.id INTO v_tournament_id
  FROM tournaments t
  WHERE t.status = 'live'
    AND NEW.problem_id = ANY(t.problem_ids)
    AND NOW() BETWEEN t.start_time AND t.end_time
  LIMIT 1;
  
  IF v_tournament_id IS NOT NULL THEN
    -- Check if user is registered
    SELECT EXISTS(
      SELECT 1 FROM tournament_registrations
      WHERE tournament_id = v_tournament_id
        AND user_id = NEW.user_id
        AND status = 'registered'
    ) INTO v_is_registered;
    
    IF v_is_registered THEN
      -- Create tournament submission record
      INSERT INTO tournament_submissions (
        tournament_id,
        user_id,
        problem_id,
        submission_id,
        language,
        code,
        status,
        test_results,
        passed_count,
        failed_count,
        total_time,
        submitted_at
      ) VALUES (
        v_tournament_id,
        NEW.user_id,
        NEW.problem_id,
        NEW.id,
        NEW.language,
        NEW.code,
        NEW.status,
        NEW.test_results,
        NEW.passed_count,
        NEW.failed_count,
        NEW.total_time,
        NEW.submitted_at
      );
    END IF;
  END IF;
  
  RETURN NEW;
END;
$$;

-- Trigger to link problem submissions to tournaments
DROP TRIGGER IF EXISTS trigger_link_submission_to_tournament ON problem_submissions;
CREATE TRIGGER trigger_link_submission_to_tournament
  AFTER INSERT ON problem_submissions
  FOR EACH ROW
  EXECUTE FUNCTION link_submission_to_tournament();

-- RLS Policies
ALTER TABLE tournaments ENABLE ROW LEVEL SECURITY;
ALTER TABLE tournament_registrations ENABLE ROW LEVEL SECURITY;
ALTER TABLE tournament_submissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE tournament_leaderboard ENABLE ROW LEVEL SECURITY;
ALTER TABLE tournament_prizes ENABLE ROW LEVEL SECURITY;
ALTER TABLE tournament_editorials ENABLE ROW LEVEL SECURITY;

-- Tournaments: Everyone can view, only admins can create/edit
DROP POLICY IF EXISTS "Anyone can view tournaments" ON tournaments;
CREATE POLICY "Anyone can view tournaments"
  ON tournaments FOR SELECT
  TO authenticated
  USING (true);

DROP POLICY IF EXISTS "Admins can insert tournaments" ON tournaments;
CREATE POLICY "Admins can insert tournaments"
  ON tournaments FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() IN (SELECT id FROM auth.users WHERE email LIKE '%admin%'));

DROP POLICY IF EXISTS "Admins can update tournaments" ON tournaments;
CREATE POLICY "Admins can update tournaments"
  ON tournaments FOR UPDATE
  TO authenticated
  USING (auth.uid() IN (SELECT id FROM auth.users WHERE email LIKE '%admin%'));

-- Registrations: Users can view own and insert own
DROP POLICY IF EXISTS "Users can view own registrations" ON tournament_registrations;
CREATE POLICY "Users can view own registrations"
  ON tournament_registrations FOR SELECT
  TO authenticated
  USING (user_id = auth.uid() OR true); -- Allow viewing all for leaderboard

DROP POLICY IF EXISTS "Users can register for tournaments" ON tournament_registrations;
CREATE POLICY "Users can register for tournaments"
  ON tournament_registrations FOR INSERT
  TO authenticated
  WITH CHECK (user_id = auth.uid());

DROP POLICY IF EXISTS "Users can update own registrations" ON tournament_registrations;
CREATE POLICY "Users can update own registrations"
  ON tournament_registrations FOR UPDATE
  TO authenticated
  USING (user_id = auth.uid());

-- Submissions: Users can view own and insert own
DROP POLICY IF EXISTS "Users can view tournament submissions" ON tournament_submissions;
CREATE POLICY "Users can view tournament submissions"
  ON tournament_submissions FOR SELECT
  TO authenticated
  USING (user_id = auth.uid() OR true); -- Allow viewing for leaderboard

DROP POLICY IF EXISTS "Users can insert own submissions" ON tournament_submissions;
CREATE POLICY "Users can insert own submissions"
  ON tournament_submissions FOR INSERT
  TO authenticated
  WITH CHECK (user_id = auth.uid());

-- Leaderboard: Everyone can view
DROP POLICY IF EXISTS "Anyone can view leaderboard" ON tournament_leaderboard;
CREATE POLICY "Anyone can view leaderboard"
  ON tournament_leaderboard FOR SELECT
  TO authenticated
  USING (true);

-- Prizes: Everyone can view
DROP POLICY IF EXISTS "Anyone can view prizes" ON tournament_prizes;
CREATE POLICY "Anyone can view prizes"
  ON tournament_prizes FOR SELECT
  TO authenticated
  USING (true);

-- Editorials: Everyone can view
DROP POLICY IF EXISTS "Anyone can view editorials" ON tournament_editorials;
CREATE POLICY "Anyone can view editorials"
  ON tournament_editorials FOR SELECT
  TO authenticated
  USING (true);

-- Grant permissions
GRANT SELECT ON tournaments TO authenticated;
GRANT INSERT, UPDATE ON tournaments TO authenticated;
GRANT SELECT, INSERT, UPDATE ON tournament_registrations TO authenticated;
GRANT SELECT, INSERT ON tournament_submissions TO authenticated;
GRANT SELECT ON tournament_leaderboard TO authenticated;
GRANT SELECT ON tournament_prizes TO authenticated;
GRANT SELECT ON tournament_editorials TO authenticated;

-- Add helpful comments
COMMENT ON TABLE tournaments IS 'Competitive coding tournaments with scheduled start/end times';
COMMENT ON TABLE tournament_registrations IS 'User registrations for tournaments';
COMMENT ON TABLE tournament_submissions IS 'Code submissions made during tournaments';
COMMENT ON TABLE tournament_leaderboard IS 'Real-time leaderboard rankings for tournaments';
COMMENT ON TABLE tournament_prizes IS 'Prize distribution for tournament winners';
COMMENT ON TABLE tournament_editorials IS 'Editorial solutions and explanations published after tournaments';
COMMENT ON FUNCTION calculate_tournament_leaderboard IS 'Recalculates tournament leaderboard based on submissions';
COMMENT ON FUNCTION update_tournament_status IS 'Auto-updates tournament status based on current time';
