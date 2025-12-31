// Tutor Mode Types

export type SessionType = 'guided' | 'hint_based' | 'concept_deep_dive';

export type TutorHintLevel = 'conceptual' | 'algorithmic' | 'implementation' | 'solution';

export type ConceptCategory = 
  | 'data_structures' 
  | 'algorithms' 
  | 'complexity' 
  | 'design_patterns' 
  | 'best_practices';

export type DifficultyLevel = 'beginner' | 'intermediate' | 'advanced' | 'expert';

export type LearningPathStatus = 'active' | 'paused' | 'completed';

export interface TutorSession {
  id: string;
  user_id: string;
  problem_id: string;
  session_type: SessionType;
  concepts_covered: string[];
  hints_requested: number;
  time_spent_seconds: number;
  completed: boolean;
  final_solution?: string;
  mastery_improvement: Record<string, number>;
  created_at: string;
  updated_at: string;
}

export interface ConceptMastery {
  id: string;
  user_id: string;
  concept_name: string;
  category: ConceptCategory;
  mastery_level: number; // 0-100
  practice_count: number;
  last_practiced_at?: string;
  weak_areas: string[];
  strong_areas: string[];
  created_at: string;
  updated_at: string;
}

export interface LearningPath {
  id: string;
  user_id: string;
  path_name: string;
  target_concepts: string[];
  current_step: number;
  total_steps: number;
  difficulty_level: DifficultyLevel;
  estimated_hours?: number;
  completion_percentage: number;
  status: LearningPathStatus;
  milestones: Milestone[];
  created_at: string;
  updated_at: string;
}

export interface Milestone {
  step: number;
  title: string;
  description: string;
  concepts: string[];
  completed: boolean;
  completed_at?: string;
}

export interface TutorHint {
  level: TutorHintLevel;
  content: string;
  code_snippet?: string;
  concept_explanation?: string;
  follow_up_questions?: string[];
}

export interface TutorMessage {
  role: 'user' | 'tutor';
  content: string;
  hint?: TutorHint;
  timestamp: string;
  concepts_touched?: string[];
}

export interface TutorModeConfig {
  max_hints: number;
  hint_progression: TutorHintLevel[];
  concept_deep_dive_enabled: boolean;
  auto_suggest_concepts: boolean;
  mastery_threshold: number; // 0-100
}

export interface ConceptExplanation {
  concept_name: string;
  category: ConceptCategory;
  difficulty: DifficultyLevel;
  short_description: string;
  detailed_explanation: string;
  code_examples: CodeExample[];
  practice_problems: string[];
  related_concepts: string[];
  visual_aids?: string[]; // URLs to diagrams/animations
}

export interface CodeExample {
  language: string;
  code: string;
  explanation: string;
  time_complexity?: string;
  space_complexity?: string;
}

export interface TutorAnalytics {
  total_sessions: number;
  average_hints_per_session: number;
  average_time_per_session: number; // seconds
  completion_rate: number; // percentage
  concept_mastery_distribution: Record<ConceptCategory, number>;
  most_struggled_concepts: string[];
  mastery_improvements: Record<string, number>;
}
