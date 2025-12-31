// Code Battle Royale Types

export type BattleStatus = 'waiting' | 'starting' | 'active' | 'finished' | 'cancelled';

export type BattleMode = 'speed_race' | 'accuracy_challenge' | 'optimization_battle' | 'elimination';

export type ParticipantStatus = 'active' | 'eliminated' | 'completed' | 'disconnected';

export type BattleDifficulty = 'easy' | 'medium' | 'hard' | 'mixed';

export interface BattleRoom {
  id: string;
  room_code: string;
  problem_id: string;
  difficulty: BattleDifficulty;
  max_participants: number;
  current_participants: number;
  status: BattleStatus;
  battle_mode: BattleMode;
  time_limit_seconds: number;
  started_at?: string;
  ended_at?: string;
  winner_id?: string;
  leaderboard: LeaderboardEntry[];
  battle_config: BattleConfig;
  created_at: string;
  updated_at: string;
}

export interface BattleParticipant {
  id: string;
  battle_room_id: string;
  user_id: string;
  username: string;
  avatar_url?: string;
  rating: number;
  join_position: number;
  current_code: string;
  language: string;
  tests_passed: number;
  tests_total: number;
  submission_time?: string;
  time_taken_seconds?: number;
  final_rank?: number;
  points_earned: number;
  rating_change: number;
  status: ParticipantStatus;
  performance_metrics: PerformanceMetrics;
  created_at: string;
  updated_at: string;
}

export interface MatchmakingQueue {
  id: string;
  user_id: string;
  username: string;
  rating: number;
  preferred_difficulty?: BattleDifficulty;
  preferred_mode?: BattleMode;
  preferred_languages: string[];
  joined_at: string;
  match_found: boolean;
  matched_room_id?: string;
  expires_at: string;
}

export interface BattleRating {
  id: string;
  user_id: string;
  current_rating: number;
  peak_rating: number;
  total_battles: number;
  wins: number;
  losses: number;
  draws: number;
  win_streak: number;
  longest_win_streak: number;
  favorite_mode?: string;
  favorite_difficulty?: string;
  rating_history: RatingHistoryEntry[];
  created_at: string;
  updated_at: string;
}

export interface LeaderboardEntry {
  user_id: string;
  username: string;
  avatar_url?: string;
  rank: number;
  tests_passed: number;
  tests_total: number;
  time_taken_seconds: number;
  points: number;
  rating_change: number;
  status: ParticipantStatus;
}

export interface BattleConfig {
  allow_hints: boolean;
  allow_ai_assistance: boolean;
  show_live_rankings: boolean;
  elimination_threshold?: number; // For elimination mode
  bonus_points_speed: number;
  bonus_points_accuracy: number;
  penalty_wrong_submission: number;
}

export interface PerformanceMetrics {
  code_submissions: number;
  test_runs: number;
  lines_of_code: number;
  characters_typed: number;
  time_to_first_test: number; // seconds
  time_to_first_pass: number; // seconds
  average_test_time: number;
  language_switches: number;
}

export interface RatingHistoryEntry {
  date: string;
  rating: number;
  change: number;
  battle_id: string;
  result: 'win' | 'loss' | 'draw';
}

export interface BattleInvite {
  room_code: string;
  inviter_username: string;
  difficulty: BattleDifficulty;
  mode: BattleMode;
  expires_at: string;
}

export interface LiveBattleUpdate {
  type: 'participant_joined' | 'participant_left' | 'code_update' | 'test_result' | 'submission' | 'elimination' | 'battle_end';
  participant_id?: string;
  username?: string;
  data?: any;
  timestamp: string;
}

export interface MatchmakingPreferences {
  difficulty: BattleDifficulty;
  mode: BattleMode;
  rating_range: number; // How far from your rating to search
  languages: string[];
  allow_mixed_ratings: boolean;
}

export interface BattleStats {
  total_battles: number;
  wins: number;
  losses: number;
  draws: number;
  win_rate: number;
  average_rank: number;
  average_time: number;
  fastest_win: number;
  current_rating: number;
  peak_rating: number;
  rating_change_30d: number;
  favorite_mode: BattleMode;
  mode_stats: Record<BattleMode, ModeStats>;
}

export interface ModeStats {
  battles: number;
  wins: number;
  losses: number;
  win_rate: number;
  average_rank: number;
}

export interface GlobalLeaderboard {
  rank: number;
  user_id: string;
  username: string;
  avatar_url?: string;
  rating: number;
  total_battles: number;
  wins: number;
  win_rate: number;
  peak_rating: number;
  win_streak: number;
  badge?: string;
}

export interface BattleReplay {
  battle_id: string;
  problem_id: string;
  participants: BattleParticipant[];
  timeline: BattleTimelineEvent[];
  final_leaderboard: LeaderboardEntry[];
  duration_seconds: number;
}

export interface BattleTimelineEvent {
  timestamp: number; // Seconds from start
  participant_id: string;
  event_type: 'test_run' | 'test_pass' | 'test_fail' | 'submission' | 'elimination';
  details: any;
}
