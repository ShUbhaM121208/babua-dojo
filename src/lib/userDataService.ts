import { supabase } from '@/integrations/supabase/client';

export interface UserProfile {
  id: string;
  full_name: string | null;
  email: string | null;
  avatar_url?: string | null;
  college?: string | null;
  location?: string | null;
  bio?: string | null;
  instagram_url?: string | null;
  linkedin_url?: string | null;
  twitter_url?: string | null;
  leetcode_username?: string | null;
  github_username?: string | null;
  codeforces_username?: string | null;
  codechef_username?: string | null;
  current_streak: number;
  longest_streak: number;
  last_activity_date: string | null;
  total_problems_solved: number;
  total_time_spent: number;
  created_at: string;
  updated_at: string;
}

export interface UserProblemProgress {
  id: string;
  user_id: string;
  problem_id: string;
  track_slug: string;
  difficulty: string;
  solved: boolean;
  attempts: number;
  time_spent: number;
  last_attempted_at: string | null;
  solved_at: string | null;
  notes: string | null;
  created_at: string;
  updated_at: string;
}

export interface UserTrackProgress {
  id: string;
  user_id: string;
  track_slug: string;
  problems_solved: number;
  total_problems: number;
  progress_percentage: number;
  last_activity_at: string | null;
  created_at: string;
  updated_at: string;
}

export interface UserDailyActivity {
  id: string;
  user_id: string;
  activity_date: string;
  problems_solved: number;
  time_spent: number;
  created_at: string;
}

// Get user profile
export async function getUserProfile(userId: string): Promise<UserProfile | null> {
  const { data, error } = await supabase
    .from('user_profiles')
    .select('*')
    .eq('id', userId)
    .maybeSingle();

  if (error) {
    console.error('Error fetching user profile:', error);
    return null;
  }

  return data;
}

// Update user profile
export async function updateUserProfile(userId: string, updates: Partial<UserProfile>) {
  const { data, error } = await supabase
    .from('user_profiles')
    .update({ ...updates, updated_at: new Date().toISOString() })
    .eq('id', userId)
    .select()
    .single();

  if (error) {
    console.error('Error updating user profile:', error);
    return null;
  }

  return data;
}

// Get all problem progress for user
export async function getUserProblemProgress(userId: string): Promise<UserProblemProgress[]> {
  const { data, error } = await supabase
    .from('user_problem_progress')
    .select('*')
    .eq('user_id', userId);

  if (error) {
    console.error('Error fetching problem progress:', error);
    return [];
  }

  return data || [];
}

// Get specific problem progress
export async function getProblemProgress(userId: string, problemId: string): Promise<UserProblemProgress | null> {
  const { data, error } = await supabase
    .from('user_problem_progress')
    .select('*')
    .eq('user_id', userId)
    .eq('problem_id', problemId)
    .single();

  if (error && error.code !== 'PGRST116') { // PGRST116 is "not found" error
    console.error('Error fetching problem progress:', error);
  }

  return data;
}

// Mark problem as solved
export async function markProblemSolved(
  userId: string,
  problemId: string,
  trackSlug: string,
  difficulty: string,
  totalAvailableProblems: number,
  timeSpent: number = 0
) {
  // First, upsert problem progress
  const { data: progressData, error: progressError } = await supabase
    .from('user_problem_progress')
    .upsert({
      user_id: userId,
      problem_id: problemId,
      track_slug: trackSlug,
      difficulty: difficulty,
      solved: true,
      solved_at: new Date().toISOString(),
      last_attempted_at: new Date().toISOString(),
      time_spent: timeSpent,
      updated_at: new Date().toISOString(),
    }, {
      onConflict: 'user_id,problem_id'
    })
    .select()
    .single();

  if (progressError) {
    console.error('Error marking problem as solved:', progressError);
    return null;
  }

  // Update user profile stats
  const { data: profile } = await supabase
    .from('user_profiles')
    .select('total_problems_solved, total_time_spent')
    .eq('id', userId)
    .single();

  await supabase
    .from('user_profiles')
    .update({
      total_problems_solved: (profile?.total_problems_solved || 0) + 1,
      total_time_spent: (profile?.total_time_spent || 0) + timeSpent,
      updated_at: new Date().toISOString(),
    })
    .eq('id', userId);

  // Update track progress
  await updateTrackProgress(userId, trackSlug, totalAvailableProblems);

  // Update daily activity
  await updateDailyActivity(userId, 1, timeSpent);

  // Update streak
  await supabase.rpc('update_user_streak', { p_user_id: userId });

  return progressData;
}

// Update track progress
export async function updateTrackProgress(userId: string, trackSlug: string, totalAvailableProblems: number) {
  // Get all problems for this track
  const { data: allProblems } = await supabase
    .from('user_problem_progress')
    .select('solved')
    .eq('user_id', userId)
    .eq('track_slug', trackSlug);

  const problemsSolved = allProblems?.filter(p => p.solved).length || 0;
  const totalProblems = totalAvailableProblems; // Use total available problems from track definition
  const progressPercentage = totalProblems > 0 ? Math.round((problemsSolved / totalProblems) * 100) : 0;

  const { data, error } = await supabase
    .from('user_track_progress')
    .upsert({
      user_id: userId,
      track_slug: trackSlug,
      problems_solved: problemsSolved,
      total_problems: totalProblems,
      progress_percentage: progressPercentage,
      last_activity_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
    }, {
      onConflict: 'user_id,track_slug'
    })
    .select()
    .single();

  if (error) {
    console.error('Error updating track progress:', error);
    return null;
  }

  return data;
}

// Recalculate track progress for all tracks (useful for fixing existing data)
export async function recalculateAllTrackProgress(userId: string, tracks: Array<{ slug: string; problems: number }>) {
  for (const track of tracks) {
    await updateTrackProgress(userId, track.slug, track.problems);
  }
}

// Get user track progress
export async function getUserTrackProgress(userId: string): Promise<UserTrackProgress[]> {
  const { data, error } = await supabase
    .from('user_track_progress')
    .select('*')
    .eq('user_id', userId);

  if (error) {
    console.error('Error fetching track progress:', error);
    return [];
  }

  return data || [];
}

// Update daily activity
export async function updateDailyActivity(userId: string, problemsSolved: number = 1, timeSpent: number = 0) {
  const today = new Date().toISOString().split('T')[0];

  const { data, error } = await supabase
    .from('user_daily_activity')
    .upsert({
      user_id: userId,
      activity_date: today,
      problems_solved: problemsSolved,
      time_spent: timeSpent,
    }, {
      onConflict: 'user_id,activity_date'
    })
    .select()
    .single();

  if (error) {
    console.error('Error updating daily activity:', error);
    return null;
  }

  return data;
}

// Get daily activity for date range
export async function getDailyActivity(userId: string, startDate: string, endDate: string): Promise<UserDailyActivity[]> {
  const { data, error } = await supabase
    .from('user_daily_activity')
    .select('*')
    .eq('user_id', userId)
    .gte('activity_date', startDate)
    .lte('activity_date', endDate)
    .order('activity_date', { ascending: true });

  if (error) {
    console.error('Error fetching daily activity:', error);
    return [];
  }

  return data || [];
}

// Get solved problems for revision queue
export async function getSolvedProblems(userId: string, limit: number = 10): Promise<UserProblemProgress[]> {
  const { data, error } = await supabase
    .from('user_problem_progress')
    .select('*')
    .eq('user_id', userId)
    .eq('solved', true)
    .order('solved_at', { ascending: false })
    .limit(limit);

  if (error) {
    console.error('Error fetching solved problems:', error);
    return [];
  }

  return data || [];
}
