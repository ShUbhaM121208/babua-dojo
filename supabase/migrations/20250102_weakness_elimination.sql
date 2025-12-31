-- Weakness Elimination Plan Tables
-- Tables for analyzing weaknesses and generating personalized practice plans

-- Table: weakness_analysis
CREATE TABLE IF NOT EXISTS public.weakness_analysis (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    category TEXT NOT NULL CHECK (category IN ('data_structures', 'algorithms', 'problem_solving', 'coding_patterns', 'complexity_analysis')),
    subcategory TEXT NOT NULL,
    weakness_score REAL DEFAULT 0.0 CHECK (weakness_score >= 0 AND weakness_score <= 100),
    problem_ids TEXT[] DEFAULT '{}',
    failed_attempts INTEGER DEFAULT 0,
    successful_attempts INTEGER DEFAULT 0,
    avg_time_to_solve INTEGER, -- in seconds
    last_analyzed_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    ai_insights JSONB DEFAULT '{}',
    recommended_resources TEXT[] DEFAULT '{}',
    improvement_trend TEXT DEFAULT 'stable' CHECK (improvement_trend IN ('improving', 'stable', 'declining')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    UNIQUE(user_id, category, subcategory)
);

-- Table: practice_plans
CREATE TABLE IF NOT EXISTS public.practice_plans (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    plan_name TEXT NOT NULL,
    target_weaknesses UUID[] DEFAULT '{}', -- References to weakness_analysis IDs
    difficulty_progression TEXT NOT NULL CHECK (difficulty_progression IN ('gradual', 'aggressive', 'adaptive')),
    daily_problem_count INTEGER DEFAULT 3 CHECK (daily_problem_count >= 1 AND daily_problem_count <= 10),
    estimated_duration_days INTEGER NOT NULL,
    current_day INTEGER DEFAULT 0,
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'paused', 'completed', 'abandoned')),
    completion_percentage REAL DEFAULT 0.0 CHECK (completion_percentage >= 0 AND completion_percentage <= 100),
    problems_queue JSONB DEFAULT '[]',
    problems_completed JSONB DEFAULT '[]',
    milestones JSONB DEFAULT '[]',
    performance_metrics JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    started_at TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE
);

-- Table: spaced_repetition_queue
CREATE TABLE IF NOT EXISTS public.spaced_repetition_queue (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    problem_id TEXT NOT NULL,
    weakness_id UUID REFERENCES public.weakness_analysis(id) ON DELETE CASCADE,
    practice_plan_id UUID REFERENCES public.practice_plans(id) ON DELETE CASCADE,
    repetition_number INTEGER DEFAULT 0,
    ease_factor REAL DEFAULT 2.5 CHECK (ease_factor >= 1.3),
    interval_days INTEGER DEFAULT 1,
    next_review_date DATE NOT NULL,
    last_reviewed_at TIMESTAMP WITH TIME ZONE,
    performance_rating INTEGER CHECK (performance_rating >= 0 AND performance_rating <= 5),
    time_spent_seconds INTEGER DEFAULT 0,
    attempts_count INTEGER DEFAULT 0,
    mastery_level REAL DEFAULT 0.0 CHECK (mastery_level >= 0 AND mastery_level <= 100),
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    UNIQUE(user_id, problem_id)
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_weakness_analysis_user_id ON public.weakness_analysis(user_id);
CREATE INDEX IF NOT EXISTS idx_weakness_analysis_category ON public.weakness_analysis(category);
CREATE INDEX IF NOT EXISTS idx_weakness_analysis_weakness_score ON public.weakness_analysis(weakness_score DESC);
CREATE INDEX IF NOT EXISTS idx_practice_plans_user_id ON public.practice_plans(user_id);
CREATE INDEX IF NOT EXISTS idx_practice_plans_status ON public.practice_plans(status);
CREATE INDEX IF NOT EXISTS idx_spaced_repetition_user_id ON public.spaced_repetition_queue(user_id);
CREATE INDEX IF NOT EXISTS idx_spaced_repetition_next_review ON public.spaced_repetition_queue(next_review_date);
CREATE INDEX IF NOT EXISTS idx_spaced_repetition_problem ON public.spaced_repetition_queue(problem_id);

-- Enable Row Level Security
ALTER TABLE public.weakness_analysis ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.practice_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.spaced_repetition_queue ENABLE ROW LEVEL SECURITY;

-- RLS Policies for weakness_analysis
CREATE POLICY "Users can view their own weakness analysis" ON public.weakness_analysis
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own weakness analysis" ON public.weakness_analysis
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own weakness analysis" ON public.weakness_analysis
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own weakness analysis" ON public.weakness_analysis
    FOR DELETE USING (auth.uid() = user_id);

-- RLS Policies for practice_plans
CREATE POLICY "Users can view their own practice plans" ON public.practice_plans
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own practice plans" ON public.practice_plans
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own practice plans" ON public.practice_plans
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own practice plans" ON public.practice_plans
    FOR DELETE USING (auth.uid() = user_id);

-- RLS Policies for spaced_repetition_queue
CREATE POLICY "Users can view their own spaced repetition queue" ON public.spaced_repetition_queue
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own spaced repetition items" ON public.spaced_repetition_queue
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own spaced repetition items" ON public.spaced_repetition_queue
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own spaced repetition items" ON public.spaced_repetition_queue
    FOR DELETE USING (auth.uid() = user_id);

-- Triggers for updated_at
CREATE TRIGGER update_weakness_analysis_updated_at BEFORE UPDATE ON public.weakness_analysis
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_practice_plans_updated_at BEFORE UPDATE ON public.practice_plans
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_spaced_repetition_updated_at BEFORE UPDATE ON public.spaced_repetition_queue
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- Function to calculate next review date using SuperMemo-2 algorithm
CREATE OR REPLACE FUNCTION calculate_next_review(
    p_ease_factor REAL,
    p_interval_days INTEGER,
    p_performance_rating INTEGER
) RETURNS TABLE(new_ease_factor REAL, new_interval INTEGER) AS $$
DECLARE
    v_ease_factor REAL;
    v_interval INTEGER;
BEGIN
    -- Adjust ease factor based on performance
    v_ease_factor := p_ease_factor + (0.1 - (5 - p_performance_rating) * (0.08 + (5 - p_performance_rating) * 0.02));
    
    -- Ensure ease factor stays within bounds
    v_ease_factor := GREATEST(1.3, v_ease_factor);
    
    -- Calculate new interval
    IF p_performance_rating < 3 THEN
        -- Reset to day 1 for poor performance
        v_interval := 1;
    ELSE
        CASE p_interval_days
            WHEN 0 THEN v_interval := 1;
            WHEN 1 THEN v_interval := 6;
            ELSE v_interval := ROUND(p_interval_days * v_ease_factor);
        END CASE;
    END IF;
    
    RETURN QUERY SELECT v_ease_factor, v_interval;
END;
$$ LANGUAGE plpgsql;

-- Function to get today's practice queue
CREATE OR REPLACE FUNCTION get_todays_practice_queue(p_user_id UUID)
RETURNS TABLE(
    problem_id TEXT,
    weakness_category TEXT,
    weakness_subcategory TEXT,
    repetition_number INTEGER,
    mastery_level REAL,
    priority_score REAL
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        srq.problem_id,
        wa.category,
        wa.subcategory,
        srq.repetition_number,
        srq.mastery_level,
        -- Priority score: higher for overdue, higher weakness score, lower mastery
        (
            EXTRACT(EPOCH FROM (CURRENT_DATE - srq.next_review_date)) / 86400 * 10 +
            wa.weakness_score +
            (100 - srq.mastery_level)
        ) as priority_score
    FROM public.spaced_repetition_queue srq
    JOIN public.weakness_analysis wa ON srq.weakness_id = wa.id
    WHERE srq.user_id = p_user_id
        AND srq.next_review_date <= CURRENT_DATE
    ORDER BY priority_score DESC;
END;
$$ LANGUAGE plpgsql;
