-- Babua AI Tutor Mode Tables
-- Create tables for tracking tutor sessions, concept mastery, and learning paths

-- Table: tutor_sessions
CREATE TABLE IF NOT EXISTS public.tutor_sessions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    problem_id TEXT NOT NULL,
    session_type TEXT NOT NULL CHECK (session_type IN ('guided', 'hint_based', 'concept_deep_dive')),
    concepts_covered TEXT[] DEFAULT '{}',
    hints_requested INTEGER DEFAULT 0,
    time_spent_seconds INTEGER DEFAULT 0,
    completed BOOLEAN DEFAULT FALSE,
    final_solution TEXT,
    mastery_improvement JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Table: concept_mastery
CREATE TABLE IF NOT EXISTS public.concept_mastery (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    concept_name TEXT NOT NULL,
    category TEXT NOT NULL CHECK (category IN ('data_structures', 'algorithms', 'complexity', 'design_patterns', 'best_practices')),
    mastery_level REAL DEFAULT 0.0 CHECK (mastery_level >= 0 AND mastery_level <= 100),
    practice_count INTEGER DEFAULT 0,
    last_practiced_at TIMESTAMP WITH TIME ZONE,
    weak_areas TEXT[] DEFAULT '{}',
    strong_areas TEXT[] DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    UNIQUE(user_id, concept_name)
);

-- Table: learning_paths
CREATE TABLE IF NOT EXISTS public.learning_paths (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    path_name TEXT NOT NULL,
    target_concepts TEXT[] DEFAULT '{}',
    current_step INTEGER DEFAULT 0,
    total_steps INTEGER NOT NULL,
    difficulty_level TEXT NOT NULL CHECK (difficulty_level IN ('beginner', 'intermediate', 'advanced', 'expert')),
    estimated_hours INTEGER,
    completion_percentage REAL DEFAULT 0.0 CHECK (completion_percentage >= 0 AND completion_percentage <= 100),
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'paused', 'completed')),
    milestones JSONB DEFAULT '[]',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_tutor_sessions_user_id ON public.tutor_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_tutor_sessions_created_at ON public.tutor_sessions(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_concept_mastery_user_id ON public.concept_mastery(user_id);
CREATE INDEX IF NOT EXISTS idx_concept_mastery_category ON public.concept_mastery(category);
CREATE INDEX IF NOT EXISTS idx_learning_paths_user_id ON public.learning_paths(user_id);
CREATE INDEX IF NOT EXISTS idx_learning_paths_status ON public.learning_paths(status);

-- Enable Row Level Security
ALTER TABLE public.tutor_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.concept_mastery ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.learning_paths ENABLE ROW LEVEL SECURITY;

-- RLS Policies for tutor_sessions
CREATE POLICY "Users can view their own tutor sessions" ON public.tutor_sessions
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own tutor sessions" ON public.tutor_sessions
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own tutor sessions" ON public.tutor_sessions
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own tutor sessions" ON public.tutor_sessions
    FOR DELETE USING (auth.uid() = user_id);

-- RLS Policies for concept_mastery
CREATE POLICY "Users can view their own concept mastery" ON public.concept_mastery
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own concept mastery" ON public.concept_mastery
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own concept mastery" ON public.concept_mastery
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own concept mastery" ON public.concept_mastery
    FOR DELETE USING (auth.uid() = user_id);

-- RLS Policies for learning_paths
CREATE POLICY "Users can view their own learning paths" ON public.learning_paths
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own learning paths" ON public.learning_paths
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own learning paths" ON public.learning_paths
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own learning paths" ON public.learning_paths
    FOR DELETE USING (auth.uid() = user_id);

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = timezone('utc'::text, now());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers for updated_at
CREATE TRIGGER update_tutor_sessions_updated_at BEFORE UPDATE ON public.tutor_sessions
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_concept_mastery_updated_at BEFORE UPDATE ON public.concept_mastery
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_learning_paths_updated_at BEFORE UPDATE ON public.learning_paths
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
