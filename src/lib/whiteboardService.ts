import { supabase } from '@/integrations/supabase/client';
import { RealtimeChannel } from '@supabase/supabase-js';

// Types
export interface WhiteboardRoom {
  id: string;
  room_code: string;
  solver_id: string;
  title: string;
  status: 'active' | 'closed';
  created_at: string;
  closed_at: string | null;
  max_participants: number;
}

export interface WhiteboardParticipant {
  id: string;
  room_id: string;
  user_id: string;
  username: string;
  is_solver: boolean;
  joined_at: string;
  left_at: string | null;
  is_active: boolean;
}

export interface DrawingEvent {
  id?: string;
  room_id: string;
  user_id: string;
  event_type: 'draw' | 'erase' | 'text' | 'shape' | 'clear' | 'undo';
  event_data: {
    tool?: string;
    color?: string;
    strokeWidth?: number;
    points?: Array<{ x: number; y: number }>;
    text?: string;
    shape?: string;
    x?: number;
    y?: number;
    width?: number;
    height?: number;
    [key: string]: any;
  };
  created_at?: string;
  sequence_number?: number;
}

// Generate a random 6-character room code
export function generateRoomCode(): string {
  const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; // Exclude confusing chars like I, O, 0, 1
  let code = '';
  for (let i = 0; i < 6; i++) {
    code += chars.charAt(Math.floor(Math.random() * chars.length));
  }
  return code;
}

// Create a new whiteboard room
export async function createWhiteboardRoom(
  title: string,
  userId: string,
  maxParticipants: number = 10
): Promise<WhiteboardRoom> {
  const roomCode = generateRoomCode();
  
  const { data: room, error } = await supabase
    .from('whiteboard_rooms')
    .insert({
      room_code: roomCode,
      solver_id: userId,
      title,
      max_participants: maxParticipants,
    })
    .select()
    .single();

  if (error || !room) {
    console.error('Error creating whiteboard room:', error);
    throw new Error(error?.message || 'Failed to create room');
  }

  // Auto-join the creator as the solver
  const { error: joinError } = await supabase
    .from('whiteboard_participants')
    .insert({
      room_id: room.id,
      user_id: userId,
      username: await getUserDisplayName(userId),
      is_solver: true,
    });

  if (joinError) {
    console.error('Error joining room as solver:', joinError);
  }

  return room;
}

// Join an existing whiteboard room by code
export async function joinWhiteboardRoom(
  roomCode: string,
  userId: string
): Promise<WhiteboardRoom> {
  // Find the room by code
  const { data: room, error: roomError } = await supabase
    .from('whiteboard_rooms')
    .select('*')
    .eq('room_code', roomCode.toUpperCase())
    .eq('status', 'active')
    .single();

  if (roomError || !room) {
    throw new Error(roomError?.message || 'Room not found');
  }

  // Check if room is full
  const { data: participants } = await supabase
    .from('whiteboard_participants')
    .select('id')
    .eq('room_id', room.id)
    .eq('is_active', true);

  if (participants && participants.length >= room.max_participants) {
    throw new Error('Room is full');
  }

  // Check if user is already in room
  const { data: existingParticipant } = await supabase
    .from('whiteboard_participants')
    .select('id, is_active')
    .eq('room_id', room.id)
    .eq('user_id', userId)
    .single();

  if (existingParticipant) {
    // Rejoin if previously left
    if (!existingParticipant.is_active) {
      await supabase
        .from('whiteboard_participants')
        .update({ is_active: true, left_at: null })
        .eq('id', existingParticipant.id);
    }
    return room;
  }

  // Join as new participant
  const { error: joinError } = await supabase
    .from('whiteboard_participants')
    .insert({
      room_id: room.id,
      user_id: userId,
      username: await getUserDisplayName(userId),
      is_solver: false,
    });

  if (joinError) {
    console.error('Error joining room:', joinError);
    throw new Error(joinError.message || 'Failed to join room');
  }

  return room;
}

// Get room participants
export async function getRoomParticipants(
  roomId: string
): Promise<WhiteboardParticipant[]> {
  try {
    const { data, error } = await supabase
      .from('whiteboard_participants')
      .select('*')
      .eq('room_id', roomId)
      .eq('is_active', true)
      .order('joined_at', { ascending: true });

    if (error) {
      console.error('Error fetching participants:', error);
      return [];
    }

    return data || [];
  } catch (err) {
    console.error('Unexpected error fetching participants:', err);
    return [];
  }
}

// Leave a whiteboard room
export async function leaveWhiteboardRoom(
  roomId: string,
  userId: string
): Promise<{ success: boolean; error: any }> {
  try {
    const { error } = await supabase
      .from('whiteboard_participants')
      .update({ is_active: false, left_at: new Date().toISOString() })
      .eq('room_id', roomId)
      .eq('user_id', userId);

    if (error) {
      console.error('Error leaving room:', error);
      return { success: false, error };
    }

    return { success: true, error: null };
  } catch (err) {
    console.error('Unexpected error leaving room:', err);
    return { success: false, error: err };
  }
}

// Close a whiteboard room (only solver can do this)
export async function closeWhiteboardRoom(
  roomId: string,
  solverId: string
): Promise<{ success: boolean; error: any }> {
  try {
    // Verify the user is the solver
    const { data: room, error: roomError } = await supabase
      .from('whiteboard_rooms')
      .select('solver_id')
      .eq('id', roomId)
      .single();

    if (roomError || !room || room.solver_id !== solverId) {
      return { success: false, error: new Error('Not authorized to close this room') };
    }

    // Close the room
    const { error } = await supabase
      .from('whiteboard_rooms')
      .update({ status: 'closed', closed_at: new Date().toISOString() })
      .eq('id', roomId);

    if (error) {
      console.error('Error closing room:', error);
      return { success: false, error };
    }

    // Mark all participants as inactive
    await supabase
      .from('whiteboard_participants')
      .update({ is_active: false, left_at: new Date().toISOString() })
      .eq('room_id', roomId)
      .eq('is_active', true);

    return { success: true, error: null };
  } catch (err) {
    console.error('Unexpected error closing room:', err);
    return { success: false, error: err };
  }
}

// Save a drawing event
export async function saveDrawingEvent(
  event: DrawingEvent
): Promise<{ success: boolean; error: any }> {
  try {
    const { error } = await supabase
      .from('whiteboard_events')
      .insert(event);

    if (error) {
      console.error('Error saving drawing event:', error);
      return { success: false, error };
    }

    return { success: true, error: null };
  } catch (err) {
    console.error('Unexpected error saving drawing event:', err);
    return { success: false, error: err };
  }
}

// Get drawing history for a room
export async function getDrawingHistory(
  roomId: string
): Promise<DrawingEvent[]> {
  try {
    const { data, error } = await supabase
      .from('whiteboard_events')
      .select('*')
      .eq('room_id', roomId)
      .order('sequence_number', { ascending: true });

    if (error) {
      console.error('Error fetching drawing history:', error);
      return [];
    }

    return data || [];
  } catch (err) {
    console.error('Unexpected error fetching drawing history:', err);
    return [];
  }
}

// Subscribe to room updates (participants and events)
export function subscribeToRoom(
  roomId: string,
  onParticipantChange: (participant: WhiteboardParticipant) => void,
  onDrawingEvent: (event: DrawingEvent) => void
): RealtimeChannel {
  const channel = supabase
    .channel(`room:${roomId}`)
    .on(
      'postgres_changes',
      {
        event: '*',
        schema: 'public',
        table: 'whiteboard_participants',
        filter: `room_id=eq.${roomId}`,
      },
      (payload) => {
        console.log('Participant change:', payload);
        if (payload.eventType === 'INSERT' || payload.eventType === 'UPDATE') {
          onParticipantChange(payload.new as WhiteboardParticipant);
        }
      }
    )
    .on(
      'postgres_changes',
      {
        event: 'INSERT',
        schema: 'public',
        table: 'whiteboard_events',
        filter: `room_id=eq.${roomId}`,
      },
      (payload) => {
        console.log('Drawing event:', payload);
        onDrawingEvent(payload.new as DrawingEvent);
      }
    )
    .subscribe();

  return channel;
}

// Helper: Get user display name
async function getUserDisplayName(userId: string): Promise<string> {
  try {
    // Try to get user from auth
    const { data: { user } } = await supabase.auth.getUser();
    if (user && user.id === userId) {
      // Use email username as display name
      const emailUsername = user.email?.split('@')[0];
      return emailUsername || user.user_metadata?.username || 'Anonymous';
    }

    // If not current user, try profiles table (if it exists)
    const { data: profile, error } = await supabase
      .from('profiles')
      .select('username, full_name')
      .eq('id', userId)
      .single();

    if (profile && !error) {
      return profile.username || profile.full_name || 'Anonymous';
    }

    return 'Anonymous';
  } catch (err) {
    console.error('Error getting user display name:', err);
    return 'Anonymous';
  }
}

// Broadcast drawing event without persistence (for real-time only)
export function broadcastDrawingEvent(
  channel: RealtimeChannel,
  event: Omit<DrawingEvent, 'id' | 'created_at' | 'sequence_number'>
): void {
  channel.send({
    type: 'broadcast',
    event: 'drawing',
    payload: event,
  });
}
