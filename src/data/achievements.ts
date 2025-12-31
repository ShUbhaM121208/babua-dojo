export interface Achievement {
  id: string;
  title: string;
  description: string;
  icon: string;
  category: 'problem_solving' | 'consistency' | 'speed' | 'mastery' | 'social' | 'special';
  requirement: {
    type: 'problems_solved' | 'streak_days' | 'time_under' | 'difficulty' | 'topic_mastery' | 'special';
    value: number;
    difficulty?: 'easy' | 'medium' | 'hard';
    topic?: string;
  };
  xpReward: number;
  rarity: 'common' | 'rare' | 'epic' | 'legendary';
}

export const achievements: Achievement[] = [
  // Problem Solving Achievements
  {
    id: 'first_blood',
    title: 'First Blood',
    description: 'Solve your first problem',
    icon: '🎯',
    category: 'problem_solving',
    requirement: { type: 'problems_solved', value: 1 },
    xpReward: 50,
    rarity: 'common'
  },
  {
    id: 'getting_started',
    title: 'Getting Started',
    description: 'Solve 10 problems',
    icon: '🚀',
    category: 'problem_solving',
    requirement: { type: 'problems_solved', value: 10 },
    xpReward: 100,
    rarity: 'common'
  },
  {
    id: 'problem_crusher',
    title: 'Problem Crusher',
    description: 'Solve 50 problems',
    icon: '💪',
    category: 'problem_solving',
    requirement: { type: 'problems_solved', value: 50 },
    xpReward: 250,
    rarity: 'rare'
  },
  {
    id: 'centurion',
    title: 'Centurion',
    description: 'Solve 100 problems',
    icon: '💯',
    category: 'problem_solving',
    requirement: { type: 'problems_solved', value: 100 },
    xpReward: 500,
    rarity: 'epic'
  },
  {
    id: 'problem_master',
    title: 'Problem Master',
    description: 'Solve 250 problems',
    icon: '👑',
    category: 'problem_solving',
    requirement: { type: 'problems_solved', value: 250 },
    xpReward: 1000,
    rarity: 'legendary'
  },

  // Consistency Achievements
  {
    id: 'consistent_coder',
    title: 'Consistent Coder',
    description: 'Maintain a 7-day streak',
    icon: '🔥',
    category: 'consistency',
    requirement: { type: 'streak_days', value: 7 },
    xpReward: 150,
    rarity: 'common'
  },
  {
    id: 'dedicated_learner',
    title: 'Dedicated Learner',
    description: 'Maintain a 30-day streak',
    icon: '⚡',
    category: 'consistency',
    requirement: { type: 'streak_days', value: 30 },
    xpReward: 500,
    rarity: 'rare'
  },
  {
    id: 'unstoppable',
    title: 'Unstoppable',
    description: 'Maintain a 100-day streak',
    icon: '🌟',
    category: 'consistency',
    requirement: { type: 'streak_days', value: 100 },
    xpReward: 1500,
    rarity: 'epic'
  },
  {
    id: 'legendary_streak',
    title: 'Legendary Streak',
    description: 'Maintain a 365-day streak',
    icon: '🏆',
    category: 'consistency',
    requirement: { type: 'streak_days', value: 365 },
    xpReward: 5000,
    rarity: 'legendary'
  },

  // Speed Achievements
  {
    id: 'speed_demon',
    title: 'Speed Demon',
    description: 'Solve an easy problem in under 5 minutes',
    icon: '⚡',
    category: 'speed',
    requirement: { type: 'time_under', value: 5, difficulty: 'easy' },
    xpReward: 75,
    rarity: 'common'
  },
  {
    id: 'rapid_solver',
    title: 'Rapid Solver',
    description: 'Solve a medium problem in under 15 minutes',
    icon: '💨',
    category: 'speed',
    requirement: { type: 'time_under', value: 15, difficulty: 'medium' },
    xpReward: 200,
    rarity: 'rare'
  },
  {
    id: 'lightning_fast',
    title: 'Lightning Fast',
    description: 'Solve a hard problem in under 30 minutes',
    icon: '⚡',
    category: 'speed',
    requirement: { type: 'time_under', value: 30, difficulty: 'hard' },
    xpReward: 400,
    rarity: 'epic'
  },

  // Difficulty Mastery
  {
    id: 'easy_master',
    title: 'Easy Master',
    description: 'Solve 50 easy problems',
    icon: '🟢',
    category: 'mastery',
    requirement: { type: 'difficulty', value: 50, difficulty: 'easy' },
    xpReward: 200,
    rarity: 'common'
  },
  {
    id: 'medium_master',
    title: 'Medium Master',
    description: 'Solve 50 medium problems',
    icon: '🟡',
    category: 'mastery',
    requirement: { type: 'difficulty', value: 50, difficulty: 'medium' },
    xpReward: 400,
    rarity: 'rare'
  },
  {
    id: 'hard_master',
    title: 'Hard Master',
    description: 'Solve 50 hard problems',
    icon: '🔴',
    category: 'mastery',
    requirement: { type: 'difficulty', value: 50, difficulty: 'hard' },
    xpReward: 800,
    rarity: 'epic'
  },

  // Topic Mastery
  {
    id: 'array_expert',
    title: 'Array Expert',
    description: 'Solve 20 array problems',
    icon: '📊',
    category: 'mastery',
    requirement: { type: 'topic_mastery', value: 20, topic: 'Arrays' },
    xpReward: 300,
    rarity: 'rare'
  },
  {
    id: 'tree_specialist',
    title: 'Tree Specialist',
    description: 'Solve 20 tree problems',
    icon: '🌳',
    category: 'mastery',
    requirement: { type: 'topic_mastery', value: 20, topic: 'Trees' },
    xpReward: 300,
    rarity: 'rare'
  },
  {
    id: 'graph_guru',
    title: 'Graph Guru',
    description: 'Solve 20 graph problems',
    icon: '🕸️',
    category: 'mastery',
    requirement: { type: 'topic_mastery', value: 20, topic: 'Graphs' },
    xpReward: 300,
    rarity: 'rare'
  },
  {
    id: 'dp_master',
    title: 'DP Master',
    description: 'Solve 20 dynamic programming problems',
    icon: '🧠',
    category: 'mastery',
    requirement: { type: 'topic_mastery', value: 20, topic: 'Dynamic Programming' },
    xpReward: 400,
    rarity: 'epic'
  },

  // Special Achievements
  {
    id: 'night_owl',
    title: 'Night Owl',
    description: 'Solve a problem between 12 AM - 4 AM',
    icon: '🦉',
    category: 'special',
    requirement: { type: 'special', value: 1 },
    xpReward: 100,
    rarity: 'rare'
  },
  {
    id: 'early_bird',
    title: 'Early Bird',
    description: 'Solve a problem between 5 AM - 7 AM',
    icon: '🐦',
    category: 'special',
    requirement: { type: 'special', value: 1 },
    xpReward: 100,
    rarity: 'rare'
  },
  {
    id: 'weekend_warrior',
    title: 'Weekend Warrior',
    description: 'Solve 10 problems on weekends',
    icon: '⚔️',
    category: 'special',
    requirement: { type: 'special', value: 10 },
    xpReward: 150,
    rarity: 'rare'
  },
  {
    id: 'bug_crusher',
    title: 'Bug Crusher',
    description: 'Fix and solve a problem on first submission after debugging',
    icon: '🐛',
    category: 'special',
    requirement: { type: 'special', value: 1 },
    xpReward: 200,
    rarity: 'epic'
  },
];

export interface Level {
  level: number;
  minXP: number;
  maxXP: number;
  title: string;
  badge: string;
}

export const levels: Level[] = [
  { level: 1, minXP: 0, maxXP: 100, title: 'Newbie', badge: '🌱' },
  { level: 2, minXP: 100, maxXP: 250, title: 'Beginner', badge: '🌿' },
  { level: 3, minXP: 250, maxXP: 500, title: 'Learner', badge: '📚' },
  { level: 4, minXP: 500, maxXP: 1000, title: 'Practitioner', badge: '💻' },
  { level: 5, minXP: 1000, maxXP: 2000, title: 'Skilled', badge: '⚡' },
  { level: 6, minXP: 2000, maxXP: 3500, title: 'Proficient', badge: '🎯' },
  { level: 7, minXP: 3500, maxXP: 5500, title: 'Advanced', badge: '🚀' },
  { level: 8, minXP: 5500, maxXP: 8000, title: 'Expert', badge: '💎' },
  { level: 9, minXP: 8000, maxXP: 12000, title: 'Master', badge: '👑' },
  { level: 10, minXP: 12000, maxXP: 20000, title: 'Grandmaster', badge: '🏆' },
  { level: 11, minXP: 20000, maxXP: 30000, title: 'Legend', badge: '⭐' },
  { level: 12, minXP: 30000, maxXP: Infinity, title: 'Mythic', badge: '🌟' },
];

export function calculateLevel(xp: number): Level {
  for (let i = levels.length - 1; i >= 0; i--) {
    if (xp >= levels[i].minXP) {
      return levels[i];
    }
  }
  return levels[0];
}

export function calculateXPForProblem(difficulty: 'easy' | 'medium' | 'hard', timeSpent: number): number {
  const baseXP = {
    easy: 10,
    medium: 25,
    hard: 50
  };

  // Bonus XP for solving quickly
  const timeBonus = timeSpent < 10 ? 5 : timeSpent < 30 ? 2 : 0;
  
  return baseXP[difficulty] + timeBonus;
}

export function checkAchievementUnlock(
  achievement: Achievement, 
  userStats: {
    totalSolved: number;
    currentStreak: number;
    easySolved: number;
    mediumSolved: number;
    hardSolved: number;
    topicCounts: Record<string, number>;
  }
): boolean {
  const { requirement } = achievement;

  switch (requirement.type) {
    case 'problems_solved':
      return userStats.totalSolved >= requirement.value;
    
    case 'streak_days':
      return userStats.currentStreak >= requirement.value;
    
    case 'difficulty':
      if (requirement.difficulty === 'easy') return userStats.easySolved >= requirement.value;
      if (requirement.difficulty === 'medium') return userStats.mediumSolved >= requirement.value;
      if (requirement.difficulty === 'hard') return userStats.hardSolved >= requirement.value;
      return false;
    
    case 'topic_mastery':
      return (userStats.topicCounts[requirement.topic || ''] || 0) >= requirement.value;
    
    default:
      return false;
  }
}
