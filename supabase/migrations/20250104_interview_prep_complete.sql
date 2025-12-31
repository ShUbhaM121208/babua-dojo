-- Interview Prep Buddy Complete Migration
-- Run this SQL in Supabase SQL Editor

-- First, create the update_updated_at_column function if it doesn't exist
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = timezone('utc'::text, now());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

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

-- Indexes
CREATE INDEX IF NOT EXISTS idx_interview_profiles_user_id ON public.interview_profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_interview_profiles_experience ON public.interview_profiles(experience_level);
CREATE INDEX IF NOT EXISTS idx_interview_profiles_available ON public.interview_profiles(is_available) WHERE is_available = TRUE;
CREATE INDEX IF NOT EXISTS idx_interview_sessions_interviewer ON public.interview_sessions(interviewer_id);
CREATE INDEX IF NOT EXISTS idx_interview_sessions_interviewee ON public.interview_sessions(interviewee_id);
CREATE INDEX IF NOT EXISTS idx_interview_sessions_status ON public.interview_sessions(status);
CREATE INDEX IF NOT EXISTS idx_interview_feedback_session ON public.interview_feedback(interview_session_id);
CREATE INDEX IF NOT EXISTS idx_interview_matching_queue_expires ON public.interview_matching_queue(expires_at);

-- Enable RLS
ALTER TABLE public.interview_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.interview_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.interview_feedback ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.interview_matching_queue ENABLE ROW LEVEL SECURITY;

-- RLS Policies for interview_profiles
DROP POLICY IF EXISTS "Anyone can view interview profiles" ON public.interview_profiles;
CREATE POLICY "Anyone can view interview profiles" ON public.interview_profiles
    FOR SELECT USING (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "Users can manage their own profile" ON public.interview_profiles;
CREATE POLICY "Users can manage their own profile" ON public.interview_profiles
    FOR ALL USING (auth.uid() = user_id);

-- RLS Policies for interview_sessions
DROP POLICY IF EXISTS "Participants can view their sessions" ON public.interview_sessions;
CREATE POLICY "Participants can view their sessions" ON public.interview_sessions
    FOR SELECT USING (auth.uid() = interviewer_id OR auth.uid() = interviewee_id);

DROP POLICY IF EXISTS "Users can create interview sessions" ON public.interview_sessions;
CREATE POLICY "Users can create interview sessions" ON public.interview_sessions
    FOR INSERT WITH CHECK (auth.uid() = interviewer_id OR auth.uid() = interviewee_id);

DROP POLICY IF EXISTS "Participants can update their sessions" ON public.interview_sessions;
CREATE POLICY "Participants can update their sessions" ON public.interview_sessions
    FOR UPDATE USING (auth.uid() = interviewer_id OR auth.uid() = interviewee_id);

-- RLS Policies for interview_feedback
DROP POLICY IF EXISTS "Participants can view feedback" ON public.interview_feedback;
CREATE POLICY "Participants can view feedback" ON public.interview_feedback
    FOR SELECT USING (auth.uid() = feedback_from_id OR auth.uid() = feedback_to_id);

DROP POLICY IF EXISTS "Users can submit feedback" ON public.interview_feedback;
CREATE POLICY "Users can submit feedback" ON public.interview_feedback
    FOR INSERT WITH CHECK (auth.uid() = feedback_from_id);

DROP POLICY IF EXISTS "Users can update feedback" ON public.interview_feedback;
CREATE POLICY "Users can update feedback" ON public.interview_feedback
    FOR UPDATE USING (auth.uid() = feedback_from_id);

-- RLS Policies for interview_matching_queue
DROP POLICY IF EXISTS "Users can view matching queue" ON public.interview_matching_queue;
CREATE POLICY "Users can view matching queue" ON public.interview_matching_queue
    FOR SELECT USING (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "Users can join matching queue" ON public.interview_matching_queue;
CREATE POLICY "Users can join matching queue" ON public.interview_matching_queue
    FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can update queue entry" ON public.interview_matching_queue;
CREATE POLICY "Users can update queue entry" ON public.interview_matching_queue
    FOR UPDATE USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can leave matching queue" ON public.interview_matching_queue;
CREATE POLICY "Users can leave matching queue" ON public.interview_matching_queue
    FOR DELETE USING (auth.uid() = user_id);

-- Triggers
DROP TRIGGER IF EXISTS update_interview_profiles_updated_at ON public.interview_profiles;
CREATE TRIGGER update_interview_profiles_updated_at BEFORE UPDATE ON public.interview_profiles
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

DROP TRIGGER IF EXISTS update_interview_sessions_updated_at ON public.interview_sessions;
CREATE TRIGGER update_interview_sessions_updated_at BEFORE UPDATE ON public.interview_sessions
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

DROP TRIGGER IF EXISTS update_interview_feedback_updated_at ON public.interview_feedback;
CREATE TRIGGER update_interview_feedback_updated_at BEFORE UPDATE ON public.interview_feedback
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- Enable realtime
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_publication_tables 
        WHERE pubname = 'supabase_realtime' 
        AND tablename = 'interview_sessions'
    ) THEN
        ALTER PUBLICATION supabase_realtime ADD TABLE public.interview_sessions;
    END IF;
    
    IF NOT EXISTS (
        SELECT 1 FROM pg_publication_tables 
        WHERE pubname = 'supabase_realtime' 
        AND tablename = 'interview_matching_queue'
    ) THEN
        ALTER PUBLICATION supabase_realtime ADD TABLE public.interview_matching_queue;
    END IF;
    
    IF NOT EXISTS (
        SELECT 1 FROM pg_publication_tables 
        WHERE pubname = 'supabase_realtime' 
        AND tablename = 'interview_feedback'
    ) THEN
        ALTER PUBLICATION supabase_realtime ADD TABLE public.interview_feedback;
    END IF;
END $$;
