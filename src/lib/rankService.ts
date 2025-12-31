import { supabase } from '@/integrations/supabase/client';

// ============================================
// TYPES
// ============================================

export interface RankConfig {
  title: string;
  minXP: number;
  color: string;
  icon?: string;
}

export interface UserRank {
  id: string;
  user_id: string;
  current_rank: string;
  rank_xp: number;
  next_rank: string | null;
  xp_to_next_rank: number;
  progress_percentage: number;
  rank_ups: number;
  last_rank_up: string | null;
  highest_rank: string;
  created_at: string;
  updated_at: string;
}

export interface SpecialTitle {
  id: string;
  title: string;
  description: string;
  icon: string;
  color: string;
  criteria_type: string;
  criteria_value: Record<string, any>;
  rarity: 'common' | 'rare' | 'epic' | 'legendary';
  total_awarded: number;
  is_active: boolean;
  created_at: string;
}

export interface UserTitle {
  id: string;
  user_id: string;
  title_id: string;
  earned_at: string;
  progress_when_earned: Record<string, any>;
  is_equipped: boolean;
  // Joined fields
  title?: string;
  description?: string;
  icon?: string;
  color?: string;
  rarity?: string;
}

export interface RankHistory {
  id: string;
  user_id: string;
  old_rank: string;
  new_rank: string;
  xp_at_rankup: number;
  trigger_action: string;
  created_at: string;
}

// ============================================
// RANK CONFIGURATION
// ============================================

export const RANKS: RankConfig[] = [
  { title: 'newbie', minXP: 0, color: '#9ca3af', icon: '🌱' },
  { title: 'apprentice', minXP: 100, color: '#22c55e', icon: '📚' },
  { title: 'adept', minXP: 500, color: '#3b82f6', icon: '⚔️' },
  { title: 'expert', minXP: 1000, color: '#8b5cf6', icon: '🎯' },
  { title: 'master', minXP: 2500, color: '#f97316', icon: '👑' },
  { title: 'grandmaster', minXP: 5000, color: '#ef4444', icon: '💫' },
  { title: 'legend', minXP: 10000, color: '#fbbf24', icon: '🏆' },
];

export function getRankConfig(rankName: string): RankConfig | undefined {
  return RANKS.find(r => r.title.toLowerCase() === rankName.toLowerCase());
}

export function getRankByXP(xp: number): RankConfig {
  for (let i = RANKS.length - 1; i >= 0; i--) {
    if (xp >= RANKS[i].minXP) {
      return RANKS[i];
    }
  }
  return RANKS[0]; // Default to newbie
}

export function getNextRank(currentRank: string): RankConfig | null {
  const currentIndex = RANKS.findIndex(r => r.title === currentRank);
  if (currentIndex === -1 || currentIndex === RANKS.length - 1) {
    return null; // Max rank reached
  }
  return RANKS[currentIndex + 1];
}

export function calculateRankProgress(xp: number): {
  currentRank: RankConfig;
  nextRank: RankConfig | null;
  xpToNext: number;
  progressPercentage: number;
} {
  const currentRank = getRankByXP(xp);
  const nextRank = getNextRank(currentRank.title);

  if (!nextRank) {
    return {
      currentRank,
      nextRank: null,
      xpToNext: 0,
      progressPercentage: 100,
    };
  }

  const xpInCurrentRank = xp - currentRank.minXP;
  const xpNeededForNextRank = nextRank.minXP - currentRank.minXP;
  const progressPercentage = Math.floor((xpInCurrentRank / xpNeededForNextRank) * 100);

  return {
    currentRank,
    nextRank,
    xpToNext: nextRank.minXP - xp,
    progressPercentage,
  };
}

// ============================================
// USER RANKS
// ============================================

export async function getUserRank(userId: string): Promise<UserRank | null> {
  try {
    const { data, error } = await supabase
      .from('user_ranks')
      .select('*')
      .eq('user_id', userId)
      .single();

    if (error) {
      if (error.code === 'PGRST116') return null; // Not found
      throw error;
    }

    return data as UserRank;
  } catch (error) {
    console.error('Error fetching user rank:', error);
    return null;
  }
}

export async function initializeUserRank(userId: string, initialXP: number = 0): Promise<boolean> {
  try {
    const progress = calculateRankProgress(initialXP);

    const { error } = await supabase
      .from('user_ranks')
      .insert({
        user_id: userId,
        current_rank: progress.currentRank.title,
        rank_xp: initialXP,
        next_rank: progress.nextRank?.title || null,
        xp_to_next_rank: progress.xpToNext,
        progress_percentage: progress.progressPercentage,
        highest_rank: progress.currentRank.title,
      });

    if (error) throw error;
    return true;
  } catch (error) {
    console.error('Error initializing user rank:', error);
    return false;
  }
}

export async function updateUserRankFromXP(userId: string, newXP: number): Promise<{
  success: boolean;
  rankedUp: boolean;
  newRank?: string;
}> {
  try {
    // Get current rank
    const currentRank = await getUserRank(userId);
    const oldRank = currentRank?.current_rank || 'newbie';

    // Calculate new rank
    const progress = calculateRankProgress(newXP);

    // Update rank
    const { error } = await supabase
      .from('user_ranks')
      .upsert({
        user_id: userId,
        current_rank: progress.currentRank.title,
        rank_xp: newXP,
        next_rank: progress.nextRank?.title || null,
        xp_to_next_rank: progress.xpToNext,
        progress_percentage: progress.progressPercentage,
        highest_rank: progress.currentRank.title,
        updated_at: new Date().toISOString(),
      });

    if (error) throw error;

    const rankedUp = oldRank !== progress.currentRank.title;

    return {
      success: true,
      rankedUp,
      newRank: rankedUp ? progress.currentRank.title : undefined,
    };
  } catch (error) {
    console.error('Error updating user rank:', error);
    return { success: false, rankedUp: false };
  }
}

export async function getRankHistory(userId: string, limit: number = 10): Promise<RankHistory[]> {
  try {
    const { data, error } = await supabase
      .from('rank_history')
      .select('*')
      .eq('user_id', userId)
      .order('created_at', { ascending: false })
      .limit(limit);

    if (error) throw error;
    return (data as RankHistory[]) || [];
  } catch (error) {
    console.error('Error fetching rank history:', error);
    return [];
  }
}

// ============================================
// SPECIAL TITLES
// ============================================

export async function getAllTitles(): Promise<SpecialTitle[]> {
  try {
    const { data, error } = await supabase
      .from('special_titles')
      .select('*')
      .eq('is_active', true)
      .order('rarity', { ascending: false });

    if (error) throw error;
    return (data as SpecialTitle[]) || [];
  } catch (error) {
    console.error('Error fetching titles:', error);
    return [];
  }
}

export async function getUserTitles(userId: string): Promise<UserTitle[]> {
  try {
    const { data, error } = await supabase
      .from('user_titles')
      .select(`
        *,
        title:title_id (
          title,
          description,
          icon,
          color,
          rarity
        )
      `)
      .eq('user_id', userId)
      .order('earned_at', { ascending: false });

    if (error) throw error;
    
    // Flatten the data structure
    return (data || []).map((item: any) => ({
      ...item,
      title: item.title?.title,
      description: item.title?.description,
      icon: item.title?.icon,
      color: item.title?.color,
      rarity: item.title?.rarity,
    })) as UserTitle[];
  } catch (error) {
    console.error('Error fetching user titles:', error);
    return [];
  }
}

export async function getEquippedTitle(userId: string): Promise<UserTitle | null> {
  try {
    const { data, error } = await supabase
      .from('user_titles')
      .select(`
        *,
        title:title_id (
          title,
          description,
          icon,
          color,
          rarity
        )
      `)
      .eq('user_id', userId)
      .eq('is_equipped', true)
      .single();

    if (error) {
      if (error.code === 'PGRST116') return null;
      throw error;
    }

    // Flatten structure
    return {
      ...data,
      title: data.title?.title,
      description: data.title?.description,
      icon: data.title?.icon,
      color: data.title?.color,
      rarity: data.title?.rarity,
    } as UserTitle;
  } catch (error) {
    console.error('Error fetching equipped title:', error);
    return null;
  }
}

export async function equipTitle(userId: string, titleId: string): Promise<boolean> {
  try {
    // First, unequip all titles
    await supabase
      .from('user_titles')
      .update({ is_equipped: false })
      .eq('user_id', userId);

    // Then equip the selected title
    const { error } = await supabase
      .from('user_titles')
      .update({ is_equipped: true })
      .eq('user_id', userId)
      .eq('title_id', titleId);

    if (error) throw error;
    return true;
  } catch (error) {
    console.error('Error equipping title:', error);
    return false;
  }
}

export async function awardTitle(
  userId: string,
  titleId: string,
  progressContext?: Record<string, any>
): Promise<boolean> {
  try {
    const { error } = await supabase
      .from('user_titles')
      .insert({
        user_id: userId,
        title_id: titleId,
        progress_when_earned: progressContext || {},
      });

    if (error) throw error;

    // Increment total_awarded count
    await supabase.rpc('increment_title_count', { title_id: titleId });

    return true;
  } catch (error) {
    console.error('Error awarding title:', error);
    return false;
  }
}

// ============================================
// TITLE CHECKING LOGIC
// ============================================

export async function checkAndAwardTitles(userId: string): Promise<string[]> {
  // This would be called after significant user actions
  // Returns array of newly awarded title IDs
  const awardedTitles: string[] = [];

  // TODO: Implement title checking logic based on user stats
  // This is a placeholder for the actual implementation
  // which would check user stats against each title's criteria

  return awardedTitles;
}

// ============================================
// LEADERBOARD
// ============================================

export async function getGlobalRankLeaderboard(limit: number = 100): Promise<any[]> {
  try {
    const { data, error } = await supabase
      .from('global_rank_leaderboard')
      .select('*')
      .limit(limit);

    if (error) throw error;
    return data || [];
  } catch (error) {
    console.error('Error fetching rank leaderboard:', error);
    return [];
  }
}

export async function getUserGlobalRank(userId: string): Promise<number | null> {
  try {
    const { data, error } = await supabase
      .from('global_rank_leaderboard')
      .select('global_rank')
      .eq('user_id', userId)
      .single();

    if (error) throw error;
    return data?.global_rank || null;
  } catch (error) {
    console.error('Error fetching user global rank:', error);
    return null;
  }
}
