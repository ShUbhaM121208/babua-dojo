// Weakness Elimination Types

export type WeaknessCategory = 
  | 'data_structures' 
  | 'algorithms' 
  | 'problem_solving' 
  | 'coding_patterns' 
  | 'complexity_analysis';

export type ImprovementTrend = 'improving' | 'stable' | 'declining';

export type DifficultyProgression = 'gradual' | 'aggressive' | 'adaptive';

export type PracticePlanStatus = 'active' | 'paused' | 'completed' | 'abandoned';

export interface WeaknessAnalysis {
  id: string;
  user_id: string;
  category: WeaknessCategory;
  subcategory: string;
  weakness_score: number; // 0-100, higher = weaker
  problem_ids: string[];
  failed_attempts: number;
  successful_attempts: number;
  avg_time_to_solve?: number; // seconds
  last_analyzed_at: string;
  ai_insights: Record<string, any>;
  recommended_resources: string[];
  improvement_trend: ImprovementTrend;
  created_at: string;
  updated_at: string;
}

export interface PracticePlan {
  id: string;
  user_id: string;
  plan_name: string;
  target_weaknesses: string[]; // WeaknessAnalysis IDs
  difficulty_progression: DifficultyProgression;
  daily_problem_count: number;
  estimated_duration_days: number;
  current_day: number;
  status: PracticePlanStatus;
  completion_percentage: number;
  problems_queue: PracticeProblem[];
  problems_completed: CompletedProblem[];
  milestones: PracticeMilestone[];
  performance_metrics: PerformanceMetrics;
  created_at: string;
  updated_at: string;
  started_at?: string;
  completed_at?: string;
}

export interface PracticeProblem {
  problem_id: string;
  problem_title: string;
  difficulty: 'easy' | 'medium' | 'hard';
  target_weakness_id: string;
  scheduled_for_day: number;
  estimated_time_minutes: number;
  is_revision: boolean;
}

export interface CompletedProblem {
  problem_id: string;
  completed_on_day: number;
  time_spent_seconds: number;
  attempts: number;
  rating: number; // 0-5
  notes?: string;
}

export interface PracticeMilestone {
  day: number;
  title: string;
  description: string;
  target_weaknesses: string[];
  target_mastery_improvement: number;
  achieved: boolean;
  achieved_at?: string;
}

export interface PerformanceMetrics {
  total_problems_attempted: number;
  total_problems_solved: number;
  success_rate: number;
  average_time_per_problem: number;
  average_attempts_per_problem: number;
  weakness_score_improvements: Record<string, number>;
  streak_days: number;
  longest_streak: number;
}

export interface SpacedRepetitionItem {
  id: string;
  user_id: string;
  problem_id: string;
  weakness_id: string;
  practice_plan_id?: string;
  repetition_number: number;
  ease_factor: number; // SM-2 algorithm parameter
  interval_days: number;
  next_review_date: string; // Date string
  last_reviewed_at?: string;
  performance_rating?: number; // 0-5 (0=total failure, 5=perfect recall)
  time_spent_seconds: number;
  attempts_count: number;
  mastery_level: number; // 0-100
  notes?: string;
  created_at: string;
  updated_at: string;
}

export interface WeaknessInsight {
  weakness_id: string;
  category: WeaknessCategory;
  subcategory: string;
  weakness_score: number;
  key_issues: string[];
  common_mistakes: string[];
  recommended_approach: string;
  similar_concepts: string[];
  practice_suggestions: PracticeSuggestion[];
}

export interface PracticeSuggestion {
  problem_id: string;
  problem_title: string;
  difficulty: string;
  relevance_score: number;
  specific_concepts: string[];
  estimated_time_minutes: number;
}

export interface DailyPracticeQueue {
  date: string;
  problems: QueuedProblem[];
  total_estimated_time: number;
  focus_areas: string[];
  priority_weaknesses: WeaknessAnalysis[];
}

export interface QueuedProblem {
  problem_id: string;
  problem_title: string;
  difficulty: string;
  weakness_category: string;
  weakness_subcategory: string;
  repetition_number: number;
  mastery_level: number;
  priority_score: number;
  is_overdue: boolean;
  days_overdue?: number;
}

export interface WeaknessAnalysisReport {
  user_id: string;
  generated_at: string;
  overall_weakness_score: number;
  top_weaknesses: WeaknessAnalysis[];
  improvement_areas: ImprovementArea[];
  recommended_plan: PlanRecommendation;
  historical_trends: TrendData[];
}

export interface ImprovementArea {
  category: WeaknessCategory;
  subcategory: string;
  current_level: number;
  target_level: number;
  estimated_weeks: number;
  key_focus_points: string[];
}

export interface PlanRecommendation {
  plan_name: string;
  duration_days: number;
  daily_time_minutes: number;
  difficulty_progression: DifficultyProgression;
  target_improvements: Record<string, number>;
  milestones: PracticeMilestone[];
}

export interface TrendData {
  date: string;
  weakness_score: number;
  problems_solved: number;
  average_time: number;
}

// SuperMemo-2 algorithm parameters
export interface SM2Params {
  easeFactor: number;
  interval: number;
  repetition: number;
}

export interface SM2Result {
  newEaseFactor: number;
  newInterval: number;
  newRepetition: number;
  nextReviewDate: Date;
}
