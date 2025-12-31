-- Code Battle Royale Tables
-- Tables for real-time competitive coding battles with matchmaking

-- Table: battle_rooms
CREATE TABLE IF NOT EXISTS public.battle_rooms (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    room_code TEXT NOT NULL UNIQUE,
    problem_id TEXT NOT NULL,
    difficulty TEXT NOT NULL CHECK (difficulty IN ('easy', 'medium', 'hard', 'mixed')),
    max_participants INTEGER DEFAULT 4 CHECK (max_participants >= 2 AND max_participants <= 10),
    current_participants INTEGER DEFAULT 0,
    status TEXT DEFAULT 'waiting' CHECK (status IN ('waiting', 'starting', 'active', 'finished', 'cancelled')),
    battle_mode TEXT NOT NULL CHECK (battle_mode IN ('speed_race', 'accuracy_challenge', 'optimization_battle', 'elimination')),
    time_limit_seconds INTEGER DEFAULT 1800,
    started_at TIMESTAMP WITH TIME ZONE,
    ended_at TIMESTAMP WITH TIME ZONE,
    winner_id UUID REFERENCES auth.users(id),
    leaderboard JSONB DEFAULT '[]',
    battle_config JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Table: battle_participants
CREATE TABLE IF NOT EXISTS public.battle_participants (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    battle_room_id UUID NOT NULL REFERENCES public.battle_rooms(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    username TEXT NOT NULL,
    avatar_url TEXT,
    rating INTEGER DEFAULT 1200,
    join_position INTEGER NOT NULL,
    current_code TEXT DEFAULT '',
    language TEXT DEFAULT 'javascript',
    tests_passed INTEGER DEFAULT 0,
    tests_total INTEGER DEFAULT 0,
    submission_time TIMESTAMP WITH TIME ZONE,
    time_taken_seconds INTEGER,
    final_rank INTEGER,
    points_earned INTEGER DEFAULT 0,
    rating_change INTEGER DEFAULT 0,
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'eliminated', 'completed', 'disconnected')),
    performance_metrics JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    UNIQUE(battle_room_id, user_id)
);

-- Table: matchmaking_queue
CREATE TABLE IF NOT EXISTS public.matchmaking_queue (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    username TEXT NOT NULL,
    rating INTEGER DEFAULT 1200,
    preferred_difficulty TEXT CHECK (preferred_difficulty IN ('easy', 'medium', 'hard', 'mixed')),
    preferred_mode TEXT CHECK (preferred_mode IN ('speed_race', 'accuracy_challenge', 'optimization_battle', 'elimination')),
    preferred_languages TEXT[] DEFAULT '{}',
    joined_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    match_found BOOLEAN DEFAULT FALSE,
    matched_room_id UUID REFERENCES public.battle_rooms(id),
    expires_at TIMESTAMP WITH TIME ZONE DEFAULT (timezone('utc'::text, now()) + interval '5 minutes') NOT NULL,
    UNIQUE(user_id)
);

-- Table: battle_ratings
CREATE TABLE IF NOT EXISTS public.battle_ratings (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    current_rating INTEGER DEFAULT 1200,
    peak_rating INTEGER DEFAULT 1200,
    total_battles INTEGER DEFAULT 0,
    wins INTEGER DEFAULT 0,
    losses INTEGER DEFAULT 0,
    draws INTEGER DEFAULT 0,
    win_streak INTEGER DEFAULT 0,
    longest_win_streak INTEGER DEFAULT 0,
    favorite_mode TEXT,
    favorite_difficulty TEXT,
    rating_history JSONB DEFAULT '[]',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    UNIQUE(user_id)
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_battle_rooms_status ON public.battle_rooms(status);
CREATE INDEX IF NOT EXISTS idx_battle_rooms_room_code ON public.battle_rooms(room_code);
CREATE INDEX IF NOT EXISTS idx_battle_participants_room_id ON public.battle_participants(battle_room_id);
CREATE INDEX IF NOT EXISTS idx_battle_participants_user_id ON public.battle_participants(user_id);
CREATE INDEX IF NOT EXISTS idx_matchmaking_queue_rating ON public.matchmaking_queue(rating);
CREATE INDEX IF NOT EXISTS idx_matchmaking_queue_expires_at ON public.matchmaking_queue(expires_at);
CREATE INDEX IF NOT EXISTS idx_battle_ratings_user_id ON public.battle_ratings(user_id);
CREATE INDEX IF NOT EXISTS idx_battle_ratings_current_rating ON public.battle_ratings(current_rating DESC);

-- Enable Row Level Security
ALTER TABLE public.battle_rooms ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.battle_participants ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.matchmaking_queue ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.battle_ratings ENABLE ROW LEVEL SECURITY;

-- RLS Policies for battle_rooms (all authenticated users can view active rooms)
CREATE POLICY "Anyone can view active battle rooms" ON public.battle_rooms
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Users can create battle rooms" ON public.battle_rooms
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Participants can update their battle rooms" ON public.battle_rooms
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM public.battle_participants
            WHERE battle_room_id = id AND user_id = auth.uid()
        )
    );

-- RLS Policies for battle_participants
CREATE POLICY "Anyone can view battle participants" ON public.battle_participants
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Users can join battles" ON public.battle_participants
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own participation" ON public.battle_participants
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can leave battles" ON public.battle_participants
    FOR DELETE USING (auth.uid() = user_id);

-- RLS Policies for matchmaking_queue
CREATE POLICY "Users can view matchmaking queue" ON public.matchmaking_queue
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Users can join matchmaking queue" ON public.matchmaking_queue
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their queue entry" ON public.matchmaking_queue
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can leave matchmaking queue" ON public.matchmaking_queue
    FOR DELETE USING (auth.uid() = user_id);

-- RLS Policies for battle_ratings
CREATE POLICY "Anyone can view battle ratings" ON public.battle_ratings
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Users can manage their own ratings" ON public.battle_ratings
    FOR ALL USING (auth.uid() = user_id);

-- Triggers for updated_at
CREATE TRIGGER update_battle_rooms_updated_at BEFORE UPDATE ON public.battle_rooms
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_battle_participants_updated_at BEFORE UPDATE ON public.battle_participants
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_battle_ratings_updated_at BEFORE UPDATE ON public.battle_ratings
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- Function to calculate ELO rating change
CREATE OR REPLACE FUNCTION calculate_elo_change(
    winner_rating INTEGER,
    loser_rating INTEGER,
    k_factor INTEGER DEFAULT 32
) RETURNS TABLE(winner_new_rating INTEGER, loser_new_rating INTEGER) AS $$
DECLARE
    expected_winner REAL;
    expected_loser REAL;
    winner_change INTEGER;
    loser_change INTEGER;
BEGIN
    -- Calculate expected scores
    expected_winner := 1.0 / (1.0 + POWER(10.0, (loser_rating - winner_rating) / 400.0));
    expected_loser := 1.0 / (1.0 + POWER(10.0, (winner_rating - loser_rating) / 400.0));
    
    -- Calculate rating changes
    winner_change := ROUND(k_factor * (1 - expected_winner));
    loser_change := ROUND(k_factor * (0 - expected_loser));
    
    RETURN QUERY SELECT 
        winner_rating + winner_change,
        loser_rating + loser_change;
END;
$$ LANGUAGE plpgsql;

-- Function to clean up expired matchmaking entries
CREATE OR REPLACE FUNCTION cleanup_expired_matchmaking()
RETURNS void AS $$
BEGIN
    DELETE FROM public.matchmaking_queue
    WHERE expires_at < timezone('utc'::text, now())
    AND match_found = FALSE;
END;
$$ LANGUAGE plpgsql;

-- Function to find match in queue (ELO-based matching)
CREATE OR REPLACE FUNCTION find_match_in_queue(
    p_user_id UUID,
    p_rating INTEGER,
    p_difficulty TEXT,
    p_mode TEXT,
    rating_range INTEGER DEFAULT 200
) RETURNS UUID AS $$
DECLARE
    matched_user_id UUID;
BEGIN
    -- Find a suitable match within rating range
    SELECT user_id INTO matched_user_id
    FROM public.matchmaking_queue
    WHERE user_id != p_user_id
        AND match_found = FALSE
        AND ABS(rating - p_rating) <= rating_range
        AND (preferred_difficulty = p_difficulty OR preferred_difficulty = 'mixed' OR p_difficulty = 'mixed')
        AND (preferred_mode = p_mode OR preferred_mode IS NULL OR p_mode IS NULL)
        AND expires_at > timezone('utc'::text, now())
    ORDER BY ABS(rating - p_rating) ASC
    LIMIT 1;
    
    RETURN matched_user_id;
END;
$$ LANGUAGE plpgsql;

-- Function to generate unique room code
CREATE OR REPLACE FUNCTION generate_room_code()
RETURNS TEXT AS $$
DECLARE
    chars TEXT := 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    result TEXT := '';
    i INTEGER;
BEGIN
    FOR i IN 1..6 LOOP
        result := result || substr(chars, floor(random() * length(chars) + 1)::INTEGER, 1);
    END LOOP;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

-- Enable realtime for battle tables
ALTER PUBLICATION supabase_realtime ADD TABLE public.battle_rooms;
ALTER PUBLICATION supabase_realtime ADD TABLE public.battle_participants;
ALTER PUBLICATION supabase_realtime ADD TABLE public.matchmaking_queue;
