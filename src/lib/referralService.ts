import { supabase } from "@/integrations/supabase/client";

export interface ReferralStats {
  user_id: string;
  referral_code: string;
  total_referrals: number;
  successful_referrals: number;
  total_xp_earned: number;
  badges_unlocked: string[];
  pending_referrals: number;
  completed_referrals: number;
  last_referral_at: string | null;
}

export interface Referral {
  id: string;
  referrer_id: string;
  referral_code: string;
  referred_user_id: string | null;
  status: 'pending' | 'active' | 'completed';
  reward_earned: boolean;
  created_at: string;
  completed_at: string | null;
}

export interface ReferralReward {
  id: string;
  user_id: string;
  referral_id: string | null;
  reward_type: 'xp_boost' | 'badge' | 'feature_unlock' | 'premium_trial';
  reward_value: number;
  reward_description: string;
  claimed: boolean;
  expires_at: string | null;
  created_at: string;
}

/**
 * Get user's referral stats
 */
export async function getUserReferralStats(userId: string): Promise<ReferralStats | null> {
  try {
    const { data, error } = await supabase
      .from('user_referral_stats' as any)
      .select('*')
      .eq('user_id', userId)
      .single();

    if (error) {
      console.error('Error fetching referral stats:', error);
      return null;
    }

    return data as ReferralStats;
  } catch (error) {
    console.error('Error in getUserReferralStats:', error);
    return null;
  }
}

/**
 * Get user's referral code
 */
export async function getUserReferralCode(userId: string): Promise<string | null> {
  try {
    const { data, error } = await supabase
      .from('referrals' as any)
      .select('referral_code')
      .eq('referrer_id', userId)
      .eq('referred_user_id', null)
      .single();

    if (error) {
      console.error('Error fetching referral code:', error);
      return null;
    }

    return data?.referral_code || null;
  } catch (error) {
    console.error('Error in getUserReferralCode:', error);
    return null;
  }
}

/**
 * Get all referrals made by a user
 */
export async function getUserReferrals(userId: string): Promise<Referral[]> {
  try {
    const { data, error } = await supabase
      .from('referrals' as any)
      .select('*')
      .eq('referrer_id', userId)
      .order('created_at', { ascending: false });

    if (error) {
      console.error('Error fetching referrals:', error);
      return [];
    }

    return data || [];
  } catch (error) {
    console.error('Error in getUserReferrals:', error);
    return [];
  }
}

/**
 * Get user's referral rewards
 */
export async function getUserReferralRewards(userId: string): Promise<ReferralReward[]> {
  try {
    const { data, error } = await supabase
      .from('referral_rewards' as any)
      .select('*')
      .eq('user_id', userId)
      .order('created_at', { ascending: false });

    if (error) {
      console.error('Error fetching referral rewards:', error);
      return [];
    }

    return data || [];
  } catch (error) {
    console.error('Error in getUserReferralRewards:', error);
    return [];
  }
}

/**
 * Process a referral signup (called during registration)
 */
export async function processReferralSignup(
  referralCode: string,
  newUserId: string
): Promise<boolean> {
  try {
    const { data, error } = await supabase.rpc('process_referral_signup', {
      p_referral_code: referralCode,
      p_new_user_id: newUserId
    });

    if (error) {
      console.error('Error processing referral signup:', error);
      return false;
    }

    return data === true;
  } catch (error) {
    console.error('Error in processReferralSignup:', error);
    return false;
  }
}

/**
 * Get referral leaderboard
 */
export async function getReferralLeaderboard(limit: number = 10) {
  try {
    const { data, error } = await supabase
      .from('referral_leaderboard' as any)
      .select('*')
      .limit(limit);

    if (error) {
      console.error('Error fetching referral leaderboard:', error);
      return [];
    }

    return data || [];
  } catch (error) {
    console.error('Error in getReferralLeaderboard:', error);
    return [];
  }
}

/**
 * Generate shareable referral link
 */
export function generateReferralLink(referralCode: string): string {
  const baseUrl = window.location.origin;
  return `${baseUrl}/auth?ref=${referralCode}`;
}

/**
 * Share referral link via different platforms
 */
export function shareReferralLink(referralCode: string, platform: 'whatsapp' | 'twitter' | 'email'): void {
  const link = generateReferralLink(referralCode);
  const message = encodeURIComponent(
    `Join me on Babua Dojo - the ultimate coding practice platform! Use my referral code: ${referralCode}\n\n${link}`
  );

  const urls = {
    whatsapp: `https://wa.me/?text=${message}`,
    twitter: `https://twitter.com/intent/tweet?text=${message}`,
    email: `mailto:?subject=${encodeURIComponent('Join Babua Dojo!')}&body=${message}`
  };

  window.open(urls[platform], '_blank');
}

/**
 * Copy referral link to clipboard
 */
export async function copyReferralLink(referralCode: string): Promise<boolean> {
  try {
    const link = generateReferralLink(referralCode);
    await navigator.clipboard.writeText(link);
    return true;
  } catch (error) {
    console.error('Error copying to clipboard:', error);
    return false;
  }
}
