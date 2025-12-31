// Battle Royale Service - Supabase helper functions
import { supabase } from '@/integrations/supabase/client';
import type { 
  BattleRoom, 
  BattleParticipant, 
  BattleRating,
  LeaderboardEntry
} from '@/types/battle';

export async function joinBattleRoom(
  roomId: string, 
  userId: string,
  username: string,
  rating: number = 1200
): Promise<BattleParticipant> {
  const { data: room, error: roomError } = await supabase
    .from('battle_rooms')
    .select('*')
    .eq('id', roomId)
    .single();
    
  if (roomError || !room) throw new Error('Battle room not found');
  if (room.current_participants >= room.max_participants) throw new Error('Battle room is full');
  if (room.status !== 'waiting') throw new Error('Battle has already started');
  
  const { data: participant, error: participantError } = await supabase
    .from('battle_participants')
    .insert({
      battle_room_id: roomId,
      user_id: userId,
      username,
      rating,
      join_position: room.current_participants + 1,
      status: 'active'
    })
    .select()
    .single();
    
  if (participantError) throw new Error(participantError.message);
  
  console.log('Updating participant count from', room.current_participants, 'to', room.current_participants + 1);
  
  const { error: updateError } = await supabase
    .from('battle_rooms')
    .update({ 
      current_participants: room.current_participants + 1,
      updated_at: new Date().toISOString()
    })
    .eq('id', roomId);
  
  if (updateError) {
    console.error('Failed to update participant count:', updateError);
    throw new Error('Failed to update room participant count');
  }
  
  console.log('Successfully updated participant count');
    
  return participant;
}

export async function createBattleRoom(
  problemId: string,
  difficulty: string,
  battleMode: string,
  maxParticipants: number = 4,
  timeLimitSeconds: number = 1800,
  createdBy?: string
): Promise<BattleRoom> {
  const roomCode = Math.random().toString(36).substring(2, 8).toUpperCase();
  
  const { data, error } = await supabase
    .from('battle_rooms')
    .insert({
      room_code: roomCode,
      problem_id: problemId,
      difficulty,
      battle_mode: battleMode,
      max_participants: maxParticipants,
      time_limit_seconds: timeLimitSeconds,
      status: 'waiting',
      current_participants: 0,
      created_by: createdBy,
      battle_config: {
        allow_hints: false,
        allow_ai_assistance: false,
        show_live_rankings: true,
        bonus_points_speed: 100,
        bonus_points_accuracy: 50,
        penalty_wrong_submission: -10
      }
    })
    .select()
    .single();
    
  if (error) throw new Error(error.message);
  return data;
}

export async function updateParticipantProgress(
  battleRoomId: string,
  userId: string,
  code: string,
  testsPassed: number,
  testsTotal: number
): Promise<void> {
  const { error } = await supabase
    .from('battle_participants')
    .update({
      current_code: code,
      tests_passed: testsPassed,
      tests_total: testsTotal
    })
    .eq('battle_room_id', battleRoomId)
    .eq('user_id', userId);
    
  if (error) throw new Error(error.message);
}

export async function submitBattleSolution(
  battleRoomId: string,
  userId: string,
  code: string,
  timeTakenSeconds: number,
  testsPassed: number,
  testsTotal: number
): Promise<void> {
  const { error } = await supabase
    .from('battle_participants')
    .update({
      current_code: code,
      tests_passed: testsPassed,
      tests_total: testsTotal,
      submission_time: new Date().toISOString(),
      time_taken_seconds: timeTakenSeconds,
      status: 'completed'
    })
    .eq('battle_room_id', battleRoomId)
    .eq('user_id', userId);
    
  if (error) throw new Error(error.message);
}

export async function joinMatchmakingQueue(
  userId: string,
  username: string,
  rating: number,
  preferences: {
    difficulty?: string;
    mode?: string;
    languages?: string[];
  }
): Promise<void> {
  const { error } = await supabase
    .from('matchmaking_queue')
    .insert({
      user_id: userId,
      username,
      rating,
      preferred_difficulty: preferences.difficulty || 'medium',
      preferred_mode: preferences.mode || 'speed_race',
      preferred_languages: preferences.languages || ['javascript'],
      expires_at: new Date(Date.now() + 5 * 60 * 1000).toISOString()
    });
    
  if (error) throw new Error(error.message);
}

export async function leaveMatchmakingQueue(userId: string): Promise<void> {
  await supabase.from('matchmaking_queue').delete().eq('user_id', userId);
}

export async function getUserBattleRating(userId: string): Promise<BattleRating> {
  let { data: rating } = await supabase
    .from('battle_ratings')
    .select('*')
    .eq('user_id', userId)
    .single();
    
  if (!rating) {
    const { data: newRating } = await supabase
      .from('battle_ratings')
      .insert({ 
        user_id: userId, 
        current_rating: 1200, 
        peak_rating: 1200,
        total_battles: 0,
        wins: 0,
        losses: 0,
        draws: 0
      })
      .select()
      .single();
    rating = newRating!;
  }
  
  return rating;
}

export async function leaveBattleRoom(
  battleRoomId: string,
  userId: string
): Promise<void> {
  await supabase
    .from('battle_participants')
    .update({ status: 'disconnected' })
    .eq('battle_room_id', battleRoomId)
    .eq('user_id', userId);
    
  const { data: room } = await supabase
    .from('battle_rooms')
    .select('current_participants')
    .eq('id', battleRoomId)
    .single();
    
  if (room) {
    await supabase
      .from('battle_rooms')
      .update({ current_participants: Math.max(0, room.current_participants - 1) })
      .eq('id', battleRoomId);
  }
}

export async function startBattle(battleRoomId: string): Promise<void> {
  const { error } = await supabase
    .from('battle_rooms')
    .update({
      status: 'active',
      started_at: new Date().toISOString()
    })
    .eq('id', battleRoomId);
    
  if (error) throw new Error(error.message);
}
