import { supabase } from '@/integrations/supabase/client';
import { 
  getUserProfile, 
  getUserProblemProgress, 
  getDailyActivity,
  type UserProblemProgress,
  type UserDailyActivity 
} from './userDataService';
import { achievements, calculateLevel, checkAchievementUnlock } from '@/data/achievements';

export interface UserStats {
  totalSolved: number;
  easySolved: number;
  mediumSolved: number;
  hardSolved: number;
  currentStreak: number;
  longestStreak: number;
  totalTimeSpent: number;
  topicCounts: Record<string, number>;
  xp: number;
  level: number;
  levelTitle: string;
  unlockedAchievements: string[];
}

export interface TopicStrength {
  topic: string;
  solved: number;
  total: number;
  percentage: number;
}

export interface ActivityData {
  date: string;
  problems: number;
  timeSpent: number;
}

// Calculate comprehensive user statistics
export async function getUserStats(userId: string): Promise<UserStats | null> {
  try {
    const [profile, problemProgress] = await Promise.all([
      getUserProfile(userId),
      getUserProblemProgress(userId)
    ]);

    if (!profile) return null;

    // Count by difficulty
    const solvedProblems = problemProgress.filter(p => p.solved);
    const easySolved = solvedProblems.filter(p => p.difficulty === 'easy').length;
    const mediumSolved = solvedProblems.filter(p => p.difficulty === 'medium').length;
    const hardSolved = solvedProblems.filter(p => p.difficulty === 'hard').length;

    // Count by topic (you'll need to fetch problem details to get topics)
    const topicCounts: Record<string, number> = {};
    // This would require joining with problems table - for now use empty object

    // Calculate XP based on solved problems
    const xp = calculateXP(solvedProblems);
    const level = calculateLevel(xp);

    // Check unlocked achievements
    const userStatsForAchievements = {
      totalSolved: profile.total_problems_solved,
      currentStreak: profile.current_streak,
      easySolved,
      mediumSolved,
      hardSolved,
      topicCounts
    };

    const unlockedAchievements = achievements
      .filter(achievement => checkAchievementUnlock(achievement, userStatsForAchievements))
      .map(a => a.id);

    return {
      totalSolved: profile.total_problems_solved,
      easySolved,
      mediumSolved,
      hardSolved,
      currentStreak: profile.current_streak,
      longestStreak: profile.longest_streak,
      totalTimeSpent: profile.total_time_spent,
      topicCounts,
      xp,
      level: level.level,
      levelTitle: level.title,
      unlockedAchievements
    };
  } catch (error) {
    console.error('Error calculating user stats:', error);
    return null;
  }
}

// Calculate XP from solved problems
function calculateXP(solvedProblems: UserProblemProgress[]): number {
  let totalXP = 0;
  
  for (const problem of solvedProblems) {
    const baseXP = {
      'easy': 10,
      'medium': 25,
      'hard': 50
    }[problem.difficulty as 'easy' | 'medium' | 'hard'] || 0;

    // Time bonus: under 10 min = +5 XP, under 30 min = +2 XP
    const timeInMinutes = problem.time_spent / 60;
    const timeBonus = timeInMinutes < 10 ? 5 : timeInMinutes < 30 ? 2 : 0;

    totalXP += baseXP + timeBonus;
  }

  return totalXP;
}

// Get topic strength data
export async function getTopicStrengths(userId: string): Promise<TopicStrength[]> {
  try {
    const problemProgress = await getUserProblemProgress(userId);
    
    // For now, return hardcoded topics - would need problems table join for real data
    const topics = ['Arrays', 'Strings', 'LinkedList', 'Trees', 'Graphs', 'DP'];
    
    return topics.map(topic => ({
      topic,
      solved: Math.floor(Math.random() * 20), // Placeholder
      total: 30,
      percentage: Math.floor(Math.random() * 100)
    }));
  } catch (error) {
    console.error('Error fetching topic strengths:', error);
    return [];
  }
}

// Get monthly progress data (last 6 months)
export async function getMonthlyProgress(userId: string): Promise<{ month: string; solved: number }[]> {
  try {
    const sixMonthsAgo = new Date();
    sixMonthsAgo.setMonth(sixMonthsAgo.getMonth() - 6);
    
    const problemProgress = await getUserProblemProgress(userId);
    const solvedProblems = problemProgress.filter(p => p.solved && p.solved_at);

    // Group by month
    const monthlyData: Record<string, number> = {};
    
    for (const problem of solvedProblems) {
      if (!problem.solved_at) continue;
      
      const date = new Date(problem.solved_at);
      if (date >= sixMonthsAgo) {
        const monthKey = date.toLocaleDateString('en-US', { month: 'short', year: '2-digit' });
        monthlyData[monthKey] = (monthlyData[monthKey] || 0) + 1;
      }
    }

    // Create array for last 6 months
    const result = [];
    for (let i = 5; i >= 0; i--) {
      const date = new Date();
      date.setMonth(date.getMonth() - i);
      const monthKey = date.toLocaleDateString('en-US', { month: 'short', year: '2-digit' });
      result.push({
        month: monthKey,
        solved: monthlyData[monthKey] || 0
      });
    }

    return result;
  } catch (error) {
    console.error('Error fetching monthly progress:', error);
    return [];
  }
}

// Get activity heatmap data (last 90 days)
export async function getActivityHeatmap(userId: string): Promise<ActivityData[]> {
  try {
    const ninetyDaysAgo = new Date();
    ninetyDaysAgo.setDate(ninetyDaysAgo.getDate() - 90);
    const today = new Date();

    const startDate = ninetyDaysAgo.toISOString().split('T')[0];
    const endDate = today.toISOString().split('T')[0];

    const activities = await getDailyActivity(userId, startDate, endDate);

    // Create map of date -> activity
    const activityMap: Record<string, UserDailyActivity> = {};
    activities.forEach(activity => {
      activityMap[activity.activity_date] = activity;
    });

    // Generate array for all 90 days
    const result: ActivityData[] = [];
    for (let i = 90; i >= 0; i--) {
      const date = new Date();
      date.setDate(date.getDate() - i);
      const dateStr = date.toISOString().split('T')[0];
      
      const activity = activityMap[dateStr];
      result.push({
        date: dateStr,
        problems: activity?.problems_solved || 0,
        timeSpent: activity?.time_spent || 0
      });
    }

    return result;
  } catch (error) {
    console.error('Error fetching activity heatmap:', error);
    return [];
  }
}

// Calculate achievement progress percentage
export function getAchievementProgress(): number {
  // This would calculate based on unlocked vs total achievements
  return 0; // Placeholder
}

// Store user achievements in localStorage (until we add achievements table)
export function saveUnlockedAchievements(userId: string, achievementIds: string[]) {
  localStorage.setItem(`achievements_${userId}`, JSON.stringify(achievementIds));
}

export function getUnlockedAchievements(userId: string): string[] {
  const stored = localStorage.getItem(`achievements_${userId}`);
  return stored ? JSON.parse(stored) : [];
}

export function unlockAchievement(userId: string, achievementId: string) {
  const unlocked = getUnlockedAchievements(userId);
  if (!unlocked.includes(achievementId)) {
    unlocked.push(achievementId);
    saveUnlockedAchievements(userId, unlocked);
  }
}
