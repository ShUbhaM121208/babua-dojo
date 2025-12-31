-- Interview Prep Buddy Tables
-- Tables for peer-to-peer mock interviews with video integration

-- Table: interview_profiles
CREATE TABLE IF NOT EXISTS public.interview_profiles (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    username TEXT NOT NULL,
    avatar_url TEXT,
    experience_level TEXT NOT NULL CHECK (experience_level IN ('student', 'entry_level', 'mid_level', 'senior', 'expert')),
    target_roles TEXT[] DEFAULT '{}',
    companies_interested TEXT[] DEFAULT '{}',
    strong_topics TEXT[] DEFAULT '{}',
    topics_to_practice TEXT[] DEFAULT '{}',
    preferred_languages TEXT[] DEFAULT '{}',
    availability JSONB DEFAULT '{}',
    timezone TEXT DEFAULT 'UTC',
    total_interviews_given INTEGER DEFAULT 0,
    total_interviews_taken INTEGER DEFAULT 0,
    average_rating REAL DEFAULT 0.0 CHECK (average_rating >= 0 AND average_rating <= 5),
    interviewer_rating REAL DEFAULT 0.0 CHECK (interviewer_rating >= 0 AND interviewer_rating <= 5),
    interviewee_rating REAL DEFAULT 0.0 CHECK (interviewee_rating >= 0 AND interviewee_rating <= 5),
    badges JSONB DEFAULT '[]',
    bio TEXT,
    linkedin_url TEXT,
    github_url TEXT,
    is_available BOOLEAN DEFAULT TRUE,
    last_active_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    UNIQUE(user_id)
);

-- Table: interview_sessions
CREATE TABLE IF NOT EXISTS public.interview_sessions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    session_code TEXT NOT NULL UNIQUE,
    interviewer_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    interviewee_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    problem_id TEXT NOT NULL,
    problem_difficulty TEXT NOT NULL CHECK (problem_difficulty IN ('easy', 'medium', 'hard')),
    interview_type TEXT NOT NULL CHECK (interview_type IN ('technical', 'behavioral', 'system_design', 'live_coding', 'pair_programming')),
    status TEXT DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'waiting', 'active', 'completed', 'cancelled', 'no_show')),
    scheduled_at TIMESTAMP WITH TIME ZONE,
    started_at TIMESTAMP WITH TIME ZONE,
    ended_at TIMESTAMP WITH TIME ZONE,
    duration_seconds INTEGER,
    video_room_url TEXT,
    daily_room_name TEXT,
    recording_url TEXT,
    interview_notes TEXT,
    code_snapshot TEXT,
    language_used TEXT DEFAULT 'javascript',
    problem_solved BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Table: interview_feedback
CREATE TABLE IF NOT EXISTS public.interview_feedback (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    interview_session_id UUID NOT NULL REFERENCES public.interview_sessions(id) ON DELETE CASCADE,
    feedback_from_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    feedback_to_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    role TEXT NOT NULL CHECK (role IN ('interviewer', 'interviewee')),
    overall_rating REAL NOT NULL CHECK (overall_rating >= 0 AND overall_rating <= 5),
    communication_rating REAL CHECK (communication_rating >= 0 AND communication_rating <= 5),
    technical_skills_rating REAL CHECK (technical_skills_rating >= 0 AND technical_skills_rating <= 5),
    problem_solving_rating REAL CHECK (problem_solving_rating >= 0 AND problem_solving_rating <= 5),
    code_quality_rating REAL CHECK (code_quality_rating >= 0 AND code_quality_rating <= 5),
    strengths TEXT[] DEFAULT '{}',
    areas_for_improvement TEXT[] DEFAULT '{}',
    detailed_feedback TEXT,
    would_interview_again BOOLEAN DEFAULT TRUE,
    tags TEXT[] DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    UNIQUE(interview_session_id, feedback_from_id, feedback_to_id)
);

-- Table: interview_matching_queue
CREATE TABLE IF NOT EXISTS public.interview_matching_queue (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    role_preference TEXT NOT NULL CHECK (role_preference IN ('interviewer', 'interviewee', 'either')),
    experience_level TEXT NOT NULL,
    preferred_difficulty TEXT NOT NULL CHECK (preferred_difficulty IN ('easy', 'medium', 'hard', 'any')),
    interview_type TEXT NOT NULL CHECK (interview_type IN ('technical', 'behavioral', 'system_design', 'live_coding', 'pair_programming', 'any')),
    topics TEXT[] DEFAULT '{}',
    languages TEXT[] DEFAULT '{}',
    joined_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    match_found BOOLEAN DEFAULT FALSE,
    matched_session_id UUID REFERENCES public.interview_sessions(id),
    expires_at TIMESTAMP WITH TIME ZONE DEFAULT (timezone('utc'::text, now()) + interval '10 minutes') NOT NULL,
    UNIQUE(user_id)
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_interview_profiles_user_id ON public.interview_profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_interview_profiles_experience ON public.interview_profiles(experience_level);
CREATE INDEX IF NOT EXISTS idx_interview_profiles_available ON public.interview_profiles(is_available) WHERE is_available = TRUE;
CREATE INDEX IF NOT EXISTS idx_interview_sessions_interviewer ON public.interview_sessions(interviewer_id);
CREATE INDEX IF NOT EXISTS idx_interview_sessions_interviewee ON public.interview_sessions(interviewee_id);
CREATE INDEX IF NOT EXISTS idx_interview_sessions_status ON public.interview_sessions(status);
CREATE INDEX IF NOT EXISTS idx_interview_sessions_scheduled ON public.interview_sessions(scheduled_at) WHERE scheduled_at IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_interview_feedback_session ON public.interview_feedback(interview_session_id);
CREATE INDEX IF NOT EXISTS idx_interview_matching_queue_expires ON public.interview_matching_queue(expires_at);

-- Enable Row Level Security
ALTER TABLE public.interview_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.interview_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.interview_feedback ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.interview_matching_queue ENABLE ROW LEVEL SECURITY;

-- RLS Policies for interview_profiles (public profiles)
CREATE POLICY "Anyone can view interview profiles" ON public.interview_profiles
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Users can manage their own profile" ON public.interview_profiles
    FOR ALL USING (auth.uid() = user_id);

-- RLS Policies for interview_sessions
CREATE POLICY "Participants can view their sessions" ON public.interview_sessions
    FOR SELECT USING (
        auth.uid() = interviewer_id OR auth.uid() = interviewee_id
    );

CREATE POLICY "Users can create interview sessions" ON public.interview_sessions
    FOR INSERT WITH CHECK (
        auth.uid() = interviewer_id OR auth.uid() = interviewee_id
    );

CREATE POLICY "Participants can update their sessions" ON public.interview_sessions
    FOR UPDATE USING (
        auth.uid() = interviewer_id OR auth.uid() = interviewee_id
    );

-- RLS Policies for interview_feedback
CREATE POLICY "Participants can view feedback for their sessions" ON public.interview_feedback
    FOR SELECT USING (
        auth.uid() = feedback_from_id OR auth.uid() = feedback_to_id
    );

CREATE POLICY "Users can submit feedback" ON public.interview_feedback
    FOR INSERT WITH CHECK (auth.uid() = feedback_from_id);

CREATE POLICY "Users can update their own feedback" ON public.interview_feedback
    FOR UPDATE USING (auth.uid() = feedback_from_id);

-- RLS Policies for interview_matching_queue
CREATE POLICY "Users can view matching queue" ON public.interview_matching_queue
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Users can join matching queue" ON public.interview_matching_queue
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their queue entry" ON public.interview_matching_queue
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can leave matching queue" ON public.interview_matching_queue
    FOR DELETE USING (auth.uid() = user_id);

-- Triggers for updated_at
CREATE TRIGGER update_interview_profiles_updated_at BEFORE UPDATE ON public.interview_profiles
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_interview_sessions_updated_at BEFORE UPDATE ON public.interview_sessions
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_interview_feedback_updated_at BEFORE UPDATE ON public.interview_feedback
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- Function to update profile ratings after feedback
CREATE OR REPLACE FUNCTION update_interview_profile_ratings()
RETURNS TRIGGER AS $$
BEGIN
    -- Update the profile of the person who received feedback
    UPDATE public.interview_profiles
    SET 
        average_rating = (
            SELECT AVG(overall_rating)
            FROM public.interview_feedback
            WHERE feedback_to_id = NEW.feedback_to_id
        ),
        interviewer_rating = CASE 
            WHEN NEW.role = 'interviewee' THEN (
                SELECT AVG(overall_rating)
                FROM public.interview_feedback
                WHERE feedback_to_id = NEW.feedback_to_id AND role = 'interviewee'
            )
            ELSE interviewer_rating
        END,
        interviewee_rating = CASE 
            WHEN NEW.role = 'interviewer' THEN (
                SELECT AVG(overall_rating)
                FROM public.interview_feedback
                WHERE feedback_to_id = NEW.feedback_to_id AND role = 'interviewer'
            )
            ELSE interviewee_rating
        END,
        total_interviews_given = CASE
            WHEN NEW.role = 'interviewee' THEN total_interviews_given + 1
            ELSE total_interviews_given
        END,
        total_interviews_taken = CASE
            WHEN NEW.role = 'interviewer' THEN total_interviews_taken + 1
            ELSE total_interviews_taken
        END
    WHERE user_id = NEW.feedback_to_id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_feedback_insert
    AFTER INSERT ON public.interview_feedback
    FOR EACH ROW
    EXECUTE FUNCTION update_interview_profile_ratings();

-- Function to clean up expired matching entries
CREATE OR REPLACE FUNCTION cleanup_expired_interview_matching()
RETURNS void AS $$
BEGIN
    DELETE FROM public.interview_matching_queue
    WHERE expires_at < timezone('utc'::text, now())
    AND match_found = FALSE;
END;
$$ LANGUAGE plpgsql;

-- Function to find compatible interview match
CREATE OR REPLACE FUNCTION find_interview_match(
    p_user_id UUID,
    p_role_preference TEXT,
    p_experience_level TEXT,
    p_difficulty TEXT,
    p_interview_type TEXT
) RETURNS UUID AS $$
DECLARE
    matched_user_id UUID;
BEGIN
    -- Find a compatible match
    SELECT user_id INTO matched_user_id
    FROM public.interview_matching_queue
    WHERE user_id != p_user_id
        AND match_found = FALSE
        AND (
            (p_role_preference = 'interviewer' AND role_preference IN ('interviewee', 'either'))
            OR (p_role_preference = 'interviewee' AND role_preference IN ('interviewer', 'either'))
            OR (p_role_preference = 'either' AND role_preference IN ('interviewer', 'interviewee', 'either'))
        )
        AND (experience_level = p_experience_level OR experience_level = 'any' OR p_experience_level = 'any')
        AND (preferred_difficulty = p_difficulty OR preferred_difficulty = 'any' OR p_difficulty = 'any')
        AND (interview_type = p_interview_type OR interview_type = 'any' OR p_interview_type = 'any')
        AND expires_at > timezone('utc'::text, now())
    ORDER BY joined_at ASC
    LIMIT 1;
    
    RETURN matched_user_id;
END;
$$ LANGUAGE plpgsql;

-- Function to generate unique session code
CREATE OR REPLACE FUNCTION generate_session_code()
RETURNS TEXT AS $$
DECLARE
    chars TEXT := 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    result TEXT := '';
    i INTEGER;
BEGIN
    FOR i IN 1..8 LOOP
        result := result || substr(chars, floor(random() * length(chars) + 1)::INTEGER, 1);
    END LOOP;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

-- Enable realtime for interview tables
ALTER PUBLICATION supabase_realtime ADD TABLE public.interview_sessions;
ALTER PUBLICATION supabase_realtime ADD TABLE public.interview_matching_queue;
ALTER PUBLICATION supabase_realtime ADD TABLE public.interview_feedback;
