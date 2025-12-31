// Core Types for Babua LMS
import type { TutorHintLevel, SessionType, TutorHint } from './tutor';

export interface Example {
  input: string;
  output: string;
  explanation?: string;
}

export interface TestCase {
  id: string;
  input: string;
  expectedOutput: string;
  hidden: boolean;
}

export interface Problem {
  id: number | string;
  title: string;
  slug: string;
  difficulty: "easy" | "medium" | "hard";
  description: string;
  examples: Example[];
  constraints: string[];
  tags: string[];
  track: string;
  starterCode: Record<string, string>;
  testCases: TestCase[];
  hints: string[];
  solved: boolean;
  acceptanceRate: number;
  companies: string[];
  timeLimit?: number;
  memoryLimit?: number;
}

export interface Submission {
  id: string;
  userId: string;
  problemId: number;
  code: string;
  language: string;
  status: "accepted" | "wrong_answer" | "runtime_error" | "time_limit" | "memory_limit";
  timestamp: Date;
  timeSpent: number;
  testsPassed: number;
  testsTotal: number;
  memory?: number;
  runtime?: number;
}

export interface UserWeakness {
  topic: string;
  subtopics: string[];
  failureRate: number;
  lastPracticed: Date;
  problemsAttempted: number;
  problemsSolved: number;
  averageAttempts: number;
  aiInsight: string;
}

export interface Activity {
  action: string;
  item: string;
  time: string;
  details?: Record<string, unknown>;
}

export interface UserProgress {
  userId: string;
  streak: number;
  longestStreak: number;
  totalSolved: number;
  thisWeek: number;
  byDifficulty: {
    easy: { solved: number; total: number };
    medium: { solved: number; total: number };
    hard: { solved: number; total: number };
  };
  byTopic: Record<string, { solved: number; total: number }>;
  weaknesses: UserWeakness[];
  strengths: string[];
  averageTime: Record<string, number>;
  revisionQueue: string[];
  recentActivity: Activity[];
  studyPattern: {
    mostActiveDay: string;
    avgDailyTime: number;
    preferredDifficulty: string;
  };
}

export interface TestResult {
  passed: number;
  total: number;
  failures: Array<{
    testCase: number;
    input: string;
    expected: string;
    got: string;
    error?: string;
  }>;
}

export interface AIContext {
  currentRoute?: string;
  currentTrack?: string;
  currentTopic?: string;
  currentProblem?: {
    id: number;
    title: string;
    difficulty: string;
    description: string;
    tags: string[];
  };
  userCode?: string;
  language?: string;
  testResults?: TestResult;
  userProgress?: UserProgress;
  sessionContext?: {
    problemsAttemptedToday: number;
    timeSpentToday: number;
    lastHintLevel: number;
  };
  tutorMode?: {
    enabled: boolean;
    sessionType: SessionType;
    hintLevel?: TutorHintLevel;
    previousHints: TutorHint[];
  };
}

export interface Message {
  role: "user" | "assistant" | "system";
  content: string;
}

// Track and Topic Types
export interface Subtopic {
  id: string;
  title: string;
  difficulty: "easy" | "medium" | "hard";
  completed: boolean;
}

export interface Topic {
  id: string;
  title: string;
  problems: number;
  completed: number;
  subtopics: Subtopic[];
}

export interface Track {
  id: string;
  title: string;
  slug: string;
  description: string;
  icon: string;
  topics: number;
  problems: number;
  difficulty: "beginner" | "intermediate" | "advanced" | "mixed";
  color: string;
  progress?: number;
}
