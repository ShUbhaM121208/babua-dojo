// Interview Prep Buddy Types

export type ExperienceLevel = 'student' | 'entry_level' | 'mid_level' | 'senior' | 'expert';

export type InterviewType = 'technical' | 'behavioral' | 'system_design' | 'live_coding' | 'pair_programming';

export type InterviewStatus = 'scheduled' | 'waiting' | 'active' | 'completed' | 'cancelled' | 'no_show';

export type RolePreference = 'interviewer' | 'interviewee' | 'either';

export type InterviewDifficulty = 'easy' | 'medium' | 'hard' | 'any';

export interface InterviewProfile {
  id: string;
  user_id: string;
  username: string;
  avatar_url?: string;
  experience_level: ExperienceLevel;
  target_roles: string[];
  companies_interested: string[];
  strong_topics: string[];
  topics_to_practice: string[];
  preferred_languages: string[];
  availability: AvailabilitySchedule;
  timezone: string;
  total_interviews_given: number;
  total_interviews_taken: number;
  average_rating: number;
  interviewer_rating: number;
  interviewee_rating: number;
  badges: InterviewBadge[];
  bio?: string;
  linkedin_url?: string;
  github_url?: string;
  is_available: boolean;
  last_active_at: string;
  created_at: string;
  updated_at: string;
}

export interface InterviewSession {
  id: string;
  session_code: string;
  interviewer_id: string;
  interviewee_id: string;
  problem_id: string;
  problem_difficulty: 'easy' | 'medium' | 'hard';
  interview_type: InterviewType;
  status: InterviewStatus;
  scheduled_at?: string;
  started_at?: string;
  ended_at?: string;
  duration_seconds?: number;
  video_room_url?: string;
  daily_room_name?: string;
  recording_url?: string;
  interview_notes?: string;
  code_snapshot?: string;
  language_used: string;
  problem_solved: boolean;
  created_at: string;
  updated_at: string;
}

export interface InterviewFeedback {
  id: string;
  interview_session_id: string;
  feedback_from_id: string;
  feedback_to_id: string;
  role: 'interviewer' | 'interviewee';
  overall_rating: number;
  communication_rating?: number;
  technical_skills_rating?: number;
  problem_solving_rating?: number;
  code_quality_rating?: number;
  strengths: string[];
  areas_for_improvement: string[];
  detailed_feedback?: string;
  would_interview_again: boolean;
  tags: string[];
  created_at: string;
  updated_at: string;
}

export interface InterviewMatchingQueue {
  id: string;
  user_id: string;
  role_preference: RolePreference;
  experience_level: ExperienceLevel;
  preferred_difficulty: InterviewDifficulty;
  interview_type: InterviewType | 'any';
  topics: string[];
  languages: string[];
  joined_at: string;
  match_found: boolean;
  matched_session_id?: string;
  expires_at: string;
}

export interface AvailabilitySchedule {
  monday: TimeSlot[];
  tuesday: TimeSlot[];
  wednesday: TimeSlot[];
  thursday: TimeSlot[];
  friday: TimeSlot[];
  saturday: TimeSlot[];
  sunday: TimeSlot[];
}

export interface TimeSlot {
  start: string; // HH:MM format
  end: string; // HH:MM format
}

export interface InterviewBadge {
  id: string;
  name: string;
  icon: string;
  description: string;
  earned_at: string;
}

export interface InterviewStats {
  total_interviews: number;
  as_interviewer: number;
  as_interviewee: number;
  average_rating: number;
  interviewer_rating: number;
  interviewee_rating: number;
  completion_rate: number;
  favorite_topics: string[];
  favorite_interview_type: InterviewType;
  total_hours: number;
  this_month_count: number;
  badges_earned: InterviewBadge[];
}

export interface PeerMatch {
  profile: InterviewProfile;
  compatibility_score: number;
  matching_topics: string[];
  matching_languages: string[];
  experience_match: boolean;
  timezone_difference: number; // hours
  availability_overlap: boolean;
}

export interface InterviewRecommendation {
  peer: InterviewProfile;
  reason: string;
  suggested_topics: string[];
  suggested_difficulty: 'easy' | 'medium' | 'hard';
  compatibility_score: number;
}

export interface InterviewInvite {
  session_id: string;
  session_code: string;
  from_user: {
    id: string;
    username: string;
    avatar_url?: string;
  };
  problem_id: string;
  difficulty: string;
  interview_type: InterviewType;
  scheduled_at?: string;
  expires_at: string;
}

export interface VideoRoomConfig {
  roomName: string;
  token: string;
  apiKey: string;
  sessionId: string;
  permissions: {
    canScreenShare: boolean;
    canRecord: boolean;
    canChat: boolean;
  };
}

export interface InterviewGuide {
  interview_type: InterviewType;
  difficulty: string;
  tips_for_interviewer: string[];
  tips_for_interviewee: string[];
  common_questions: string[];
  evaluation_criteria: EvaluationCriteria[];
  time_allocation: TimeAllocation;
}

export interface EvaluationCriteria {
  category: string;
  weight: number;
  description: string;
  tips: string[];
}

export interface TimeAllocation {
  introduction: number; // minutes
  problem_solving: number;
  questions: number;
  feedback: number;
}

export interface InterviewAnalytics {
  user_id: string;
  period: 'week' | 'month' | 'all_time';
  interviews_completed: number;
  average_session_length: number;
  topics_covered: Record<string, number>;
  rating_trend: Array<{ date: string; rating: number }>;
  improvement_areas: string[];
  strengths: string[];
  feedback_summary: {
    communication: number;
    technical_skills: number;
    problem_solving: number;
    code_quality: number;
  };
}

export interface InterviewRecording {
  session_id: string;
  recording_url: string;
  duration_seconds: number;
  thumbnail_url?: string;
  transcription?: string;
  key_moments: RecordingMoment[];
  created_at: string;
}

export interface RecordingMoment {
  timestamp: number; // seconds from start
  type: 'question' | 'solution_start' | 'test_run' | 'insight' | 'completion';
  description: string;
}

export interface FeedbackTemplate {
  role: 'interviewer' | 'interviewee';
  questions: FeedbackQuestion[];
}

export interface FeedbackQuestion {
  id: string;
  question: string;
  type: 'rating' | 'multi_select' | 'text';
  options?: string[];
  required: boolean;
}
