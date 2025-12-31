// Community Service - Supabase helper functions
import { supabase } from '@/integrations/supabase/client';

export interface CommunityPost {
  id: string;
  user_id: string;
  username: string;
  avatar_url?: string;
  content: string;
  likes_count: number;
  replies_count: number;
  tags?: string[];
  is_pinned: boolean;
  created_at: string;
  updated_at: string;
  is_liked?: boolean;
}

export interface AccountabilityRoom {
  id: string;
  name: string;
  description?: string;
  created_by: string;
  max_members: number;
  current_members: number;
  room_streak: number;
  is_active: boolean;
  room_code?: string;
  tags?: string[];
  created_at: string;
}

export interface LeaderboardEntry {
  user_id: string;
  username: string;
  problems_solved: number;
  points_earned: number;
  rank: number;
}

// Post functions
export async function getPosts(limit: number = 20, offset: number = 0): Promise<CommunityPost[]> {
  const { data, error } = await supabase
    .from('community_posts')
    .select('*')
    .order('created_at', { ascending: false })
    .range(offset, offset + limit - 1);
    
  if (error) throw new Error(error.message);
  
  // Check which posts current user has liked
  const { data: { user } } = await supabase.auth.getUser();
  if (user && data) {
    const postIds = data.map(p => p.id);
    const { data: likes } = await supabase
      .from('community_post_likes')
      .select('post_id')
      .eq('user_id', user.id)
      .in('post_id', postIds);
      
    const likedPostIds = new Set(likes?.map(l => l.post_id) || []);
    return data.map(post => ({
      ...post,
      is_liked: likedPostIds.has(post.id)
    }));
  }
  
  return data || [];
}

export async function createPost(content: string, tags?: string[]): Promise<CommunityPost> {
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new Error('User not authenticated');
  
  const username = user.user_metadata?.full_name || user.email?.split('@')[0] || 'Anonymous';
  
  const { data, error } = await supabase
    .from('community_posts')
    .insert({
      user_id: user.id,
      username,
      content,
      tags: tags || []
    })
    .select()
    .single();
    
  if (error) throw new Error(error.message);
  return data;
}

export async function deletePost(postId: string): Promise<void> {
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new Error('User not authenticated');
  
  // Check if user owns the post
  const { data: post } = await supabase
    .from('community_posts')
    .select('user_id')
    .eq('id', postId)
    .single();
    
  if (!post || post.user_id !== user.id) {
    throw new Error('You can only delete your own posts');
  }
  
  const { error } = await supabase
    .from('community_posts')
    .delete()
    .eq('id', postId);
    
  if (error) throw new Error(error.message);
}

export async function likePost(postId: string): Promise<void> {
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new Error('User not authenticated');
  
  const { error } = await supabase
    .from('community_post_likes')
    .insert({
      post_id: postId,
      user_id: user.id
    });
    
  if (error && !error.message.includes('duplicate')) {
    throw new Error(error.message);
  }
}

export async function unlikePost(postId: string): Promise<void> {
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new Error('User not authenticated');
  
  await supabase
    .from('community_post_likes')
    .delete()
    .eq('post_id', postId)
    .eq('user_id', user.id);
}

// Room functions
export async function getAccountabilityRooms(): Promise<AccountabilityRoom[]> {
  const { data, error } = await supabase
    .from('accountability_rooms')
    .select('*')
    .eq('is_active', true)
    .order('created_at', { ascending: false });
    
  if (error) throw new Error(error.message);
  return data || [];
}

export async function createAccountabilityRoom(
  name: string,
  description?: string,
  maxMembers: number = 5
): Promise<AccountabilityRoom> {
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new Error('User not authenticated');
  
  const roomCode = Math.random().toString(36).substring(2, 8).toUpperCase();
  
  const { data: room, error } = await supabase
    .from('accountability_rooms')
    .insert({
      name,
      description,
      created_by: user.id,
      max_members: maxMembers,
      room_code: roomCode
    })
    .select()
    .single();
    
  if (error) throw new Error(error.message);
  
  // Automatically add creator as first member
  const username = user.user_metadata?.full_name || user.email?.split('@')[0] || 'User';
  await supabase
    .from('accountability_room_members')
    .insert({
      room_id: room.id,
      user_id: user.id,
      username
    });
    
  return room;
}

export async function joinAccountabilityRoom(roomId: string): Promise<void> {
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new Error('User not authenticated');
  
  // Check if room is full
  const { data: room } = await supabase
    .from('accountability_rooms')
    .select('current_members, max_members')
    .eq('id', roomId)
    .single();
    
  if (room && room.current_members >= room.max_members) {
    throw new Error('Room is full');
  }
  
  const username = user.user_metadata?.full_name || user.email?.split('@')[0] || 'User';
  
  const { error } = await supabase
    .from('accountability_room_members')
    .insert({
      room_id: roomId,
      user_id: user.id,
      username
    });
    
  if (error && !error.message.includes('duplicate')) {
    throw new Error(error.message);
  }
}

export async function leaveAccountabilityRoom(roomId: string): Promise<void> {
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new Error('User not authenticated');
  
  await supabase
    .from('accountability_room_members')
    .delete()
    .eq('room_id', roomId)
    .eq('user_id', user.id);
}

export async function deleteAccountabilityRoom(roomId: string): Promise<void> {
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new Error('User not authenticated');
  
  // Check if user is the room creator
  const { data: room } = await supabase
    .from('accountability_rooms')
    .select('created_by')
    .eq('id', roomId)
    .single();
    
  if (!room || room.created_by !== user.id) {
    throw new Error('You can only delete rooms you created');
  }
  
  const { error } = await supabase
    .from('accountability_rooms')
    .delete()
    .eq('id', roomId);
    
  if (error) throw new Error(error.message);
}

// Leaderboard functions
export async function getWeeklyLeaderboard(limit: number = 10): Promise<LeaderboardEntry[]> {
  const now = new Date();
  const startOfWeek = new Date(now);
  startOfWeek.setDate(now.getDate() - now.getDay());
  startOfWeek.setHours(0, 0, 0, 0);
  
  const { data, error } = await supabase
    .from('weekly_leaderboard')
    .select('user_id, username, problems_solved, points_earned, rank')
    .eq('week_start', startOfWeek.toISOString().split('T')[0])
    .order('rank', { ascending: true })
    .limit(limit);
    
  if (error) throw new Error(error.message);
  return data || [];
}

export async function updateWeeklyProgress(problemsSolved: number): Promise<void> {
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new Error('User not authenticated');
  
  const now = new Date();
  const startOfWeek = new Date(now);
  startOfWeek.setDate(now.getDate() - now.getDay());
  startOfWeek.setHours(0, 0, 0, 0);
  
  const endOfWeek = new Date(startOfWeek);
  endOfWeek.setDate(startOfWeek.getDate() + 6);
  
  const username = user.user_metadata?.full_name || user.email?.split('@')[0] || 'User';
  
  await supabase
    .from('weekly_leaderboard')
    .upsert({
      user_id: user.id,
      username,
      week_start: startOfWeek.toISOString().split('T')[0],
      week_end: endOfWeek.toISOString().split('T')[0],
      problems_solved: problemsSolved,
      points_earned: problemsSolved * 10
    });
}
