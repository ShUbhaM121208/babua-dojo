import { supabase } from '@/integrations/supabase/client';

// ============================================
// TYPES
// ============================================

export interface UserPreferences {
  user_id: string;
  theme: 'light' | 'dark' | 'system';
  color_scheme: 'blue' | 'green' | 'purple' | 'orange' | 'red';
  font_size: 'small' | 'medium' | 'large';
  compact_mode: boolean;
  profile_visibility: 'public' | 'friends' | 'private';
  show_activity_status: boolean;
  show_problem_history: boolean;
  show_learning_path: boolean;
  allow_friend_requests: boolean;
  show_achievements: boolean;
  email_notifications: boolean;
  push_notifications: boolean;
  daily_challenge_reminder: boolean;
  streak_reminder: boolean;
  achievement_notifications: boolean;
  community_notifications: boolean;
  difficulty_preference: 'easy' | 'medium' | 'hard' | 'mixed';
  preferred_topics: string[];
  practice_goal_daily: number;
  study_time_goal_minutes: number;
  language: string;
  timezone: string;
}

export interface ProfileViewStats {
  user_id: string;
  total_views: number;
  unique_viewers: number;
  last_viewed_at: string;
  views_last_7_days: number;
  views_last_30_days: number;
}

export interface UserBadge {
  id: string;
  user_id: string;
  badge_type: string;
  badge_name: string;
  badge_description: string;
  badge_icon: string;
  badge_color: string;
  earned_at: string;
  display_on_profile: boolean;
  display_order: number;
}

// ============================================
// USER PREFERENCES
// ============================================

export async function getUserPreferences(userId: string): Promise<UserPreferences | null> {
  try {
    const { data, error } = await supabase
      .from('user_preferences')
      .select('*')
      .eq('user_id', userId)
      .single();

    if (error) throw error;
    return data as UserPreferences;
  } catch (error) {
    console.error('Error fetching user preferences:', error);
    return null;
  }
}

export async function updateUserPreferences(
  userId: string,
  preferences: Partial<UserPreferences>
): Promise<boolean> {
  try {
    const { error } = await supabase
      .from('user_preferences')
      .upsert({
        user_id: userId,
        ...preferences,
        updated_at: new Date().toISOString(),
      });

    if (error) throw error;
    return true;
  } catch (error) {
    console.error('Error updating user preferences:', error);
    return false;
  }
}

// ============================================
// AVATAR MANAGEMENT
// ============================================

export async function uploadAvatar(
  userId: string,
  file: File
): Promise<{ url: string | null; error: string | null }> {
  try {
    // Delete old avatar if exists
    const { data: existingFiles } = await supabase.storage
      .from('avatars')
      .list(userId);

    if (existingFiles && existingFiles.length > 0) {
      const filesToDelete = existingFiles.map(f => `${userId}/${f.name}`);
      await supabase.storage.from('avatars').remove(filesToDelete);
    }

    // Upload new avatar
    const fileExt = file.name.split('.').pop();
    const fileName = `${userId}/avatar-${Date.now()}.${fileExt}`;

    const { error: uploadError } = await supabase.storage
      .from('avatars')
      .upload(fileName, file, {
        cacheControl: '3600',
        upsert: true,
      });

    if (uploadError) throw uploadError;

    // Get public URL
    const { data: urlData } = supabase.storage
      .from('avatars')
      .getPublicUrl(fileName);

    // Update user profile with new avatar URL
    await supabase
      .from('user_profiles')
      .update({ avatar_url: urlData.publicUrl })
      .eq('id', userId);

    return { url: urlData.publicUrl, error: null };
  } catch (error: any) {
    console.error('Error uploading avatar:', error);
    return { url: null, error: error.message };
  }
}

export async function deleteAvatar(userId: string): Promise<boolean> {
  try {
    const { data: files } = await supabase.storage
      .from('avatars')
      .list(userId);

    if (files && files.length > 0) {
      const filesToDelete = files.map(f => `${userId}/${f.name}`);
      await supabase.storage.from('avatars').remove(filesToDelete);
    }

    // Update user profile to remove avatar URL
    await supabase
      .from('user_profiles')
      .update({ avatar_url: null })
      .eq('id', userId);

    return true;
  } catch (error) {
    console.error('Error deleting avatar:', error);
    return false;
  }
}

// ============================================
// PROFILE VIEWS
// ============================================

export async function recordProfileView(
  profileUserId: string,
  viewerUserId: string | null
): Promise<boolean> {
  try {
    if (!viewerUserId || profileUserId === viewerUserId) {
      return false;
    }

    const { error } = await supabase.rpc('record_profile_view', {
      p_profile_user_id: profileUserId,
      p_viewer_user_id: viewerUserId,
    });

    if (error) throw error;
    return true;
  } catch (error) {
    console.error('Error recording profile view:', error);
    return false;
  }
}

export async function getProfileViewStats(userId: string): Promise<ProfileViewStats | null> {
  try {
    const { data, error } = await supabase
      .from('profile_view_stats')
      .select('*')
      .eq('user_id', userId)
      .single();

    if (error) throw error;
    return data as ProfileViewStats;
  } catch (error) {
    console.error('Error fetching profile view stats:', error);
    return null;
  }
}

// ============================================
// USER BADGES
// ============================================

export async function getUserBadges(userId: string): Promise<UserBadge[]> {
  try {
    const { data, error } = await supabase
      .from('user_badges')
      .select('*')
      .eq('user_id', userId)
      .order('display_order', { ascending: true })
      .order('earned_at', { ascending: false });

    if (error) throw error;
    return data as UserBadge[];
  } catch (error) {
    console.error('Error fetching user badges:', error);
    return [];
  }
}

export async function updateBadgeDisplay(
  badgeId: string,
  displayOnProfile: boolean,
  displayOrder?: number
): Promise<boolean> {
  try {
    const updateData: any = { display_on_profile: displayOnProfile };
    if (displayOrder !== undefined) {
      updateData.display_order = displayOrder;
    }

    const { error } = await supabase
      .from('user_badges')
      .update(updateData)
      .eq('id', badgeId);

    if (error) throw error;
    return true;
  } catch (error) {
    console.error('Error updating badge display:', error);
    return false;
  }
}

// ============================================
// PRIVACY CHECKS
// ============================================

export async function canViewProfile(
  profileUserId: string,
  viewerUserId: string | null
): Promise<boolean> {
  try {
    if (!viewerUserId) {
      // Check if profile is public
      const { data } = await supabase
        .from('user_preferences')
        .select('profile_visibility')
        .eq('user_id', profileUserId)
        .single();

      return data?.profile_visibility === 'public';
    }

    const { data, error } = await supabase.rpc('can_view_profile', {
      p_profile_user_id: profileUserId,
      p_viewer_user_id: viewerUserId,
    });

    if (error) throw error;
    return data as boolean;
  } catch (error) {
    console.error('Error checking profile visibility:', error);
    return false;
  }
}

// ============================================
// THEME MANAGEMENT
// ============================================

export function applyTheme(theme: 'light' | 'dark' | 'system') {
  const root = document.documentElement;
  
  if (theme === 'system') {
    const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
    root.classList.toggle('dark', prefersDark);
  } else {
    root.classList.toggle('dark', theme === 'dark');
  }
}

export function applyColorScheme(colorScheme: string) {
  const root = document.documentElement;
  root.setAttribute('data-color-scheme', colorScheme);
}

export function applyFontSize(fontSize: 'small' | 'medium' | 'large') {
  const root = document.documentElement;
  const sizes = { small: '14px', medium: '16px', large: '18px' };
  root.style.fontSize = sizes[fontSize];
}
