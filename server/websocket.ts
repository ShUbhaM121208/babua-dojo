import { createServer } from 'http';
import { Server } from 'socket.io';
import { createClient } from '@supabase/supabase-js';
import * as dotenv from 'dotenv';

// Load environment variables from .env.local
dotenv.config({ path: '.env.local' });
dotenv.config({ path: '.env' });

const supabaseUrl = process.env.VITE_SUPABASE_URL;
const supabaseKey = process.env.VITE_SUPABASE_ANON_KEY || process.env.VITE_SUPABASE_PUBLISHABLE_KEY;

if (!supabaseUrl || !supabaseKey) {
  console.error('❌ Missing environment variables!');
  console.error('Required: VITE_SUPABASE_URL and VITE_SUPABASE_ANON_KEY (or VITE_SUPABASE_PUBLISHABLE_KEY)');
  console.error('Make sure .env or .env.local exists with these values');
  process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseKey);

const httpServer = createServer();
const io = new Server(httpServer, {
  cors: {
    origin: [
      'http://localhost:5173',
      'http://localhost:8000',
      'http://localhost:3000',
      process.env.VITE_APP_URL || ''
    ].filter(Boolean),
    methods: ['GET', 'POST'],
    credentials: true,
  },
});

// Room state management
const rooms = new Map<string, RoomState>();

interface RoomState {
  id: string;
  hostId: string;
  participants: Map<string, ParticipantState>;
  status: 'waiting' | 'starting' | 'active' | 'finished';
  problemId: string;
  startTime?: Date;
  endTime?: Date;
  durationMinutes: number;
}

interface ParticipantState {
  userId: string;
  username: string;
  socketId: string;
  joinedAt: Date;
  status: 'connected' | 'disconnected' | 'submitted';
  testsPassed?: number;
  totalTests?: number;
  timeTaken?: number;
  submissionTime?: Date;
  code?: string;
  language?: string;
}

// Authentication middleware
io.use(async (socket, next) => {
  const { userId, token } = socket.handshake.auth;

  if (!userId || !token) {
    return next(new Error('Authentication required'));
  }

  // Verify token with Supabase
  const { data: { user }, error } = await supabase.auth.getUser(token);

  if (error || !user || user.id !== userId) {
    return next(new Error('Invalid authentication'));
  }

  socket.data.userId = userId;
  socket.data.user = user;
  next();
});

// Connection handler
io.on('connection', (socket) => {
  const userId = socket.data.userId;
  console.log(`✅ User connected: ${userId}`);

  // Join room
  socket.on('join_room', async ({ roomId, username }, callback) => {
    try {
      // Create authenticated Supabase client using user's token
      const userToken = socket.data.token;
      const authenticatedSupabase = createClient(supabaseUrl!, supabaseKey!, {
        global: {
          headers: {
            Authorization: `Bearer ${userToken}`
          }
        }
      });

      // Fetch room from database with authenticated client
      const { data: room, error } = await authenticatedSupabase
        .from('battle_rooms')
        .select('*')
        .eq('id', roomId)
        .single();

      if (error || !room) {
        console.error('Room not found in database:', roomId, error);
        return callback({ success: false, error: 'Room not found' });
      }

      console.log('Found room in database:', room.room_code, 'status:', room.status);

      // Check if room is full
      const roomState = rooms.get(roomId);
      if (roomState && roomState.participants.size >= room.max_participants) {
        return callback({ success: false, error: 'Room is full' });
      }

      // Check if room is already active
      if (roomState && roomState.status !== 'waiting') {
        return callback({ success: false, error: 'Room has already started' });
      }

      // Initialize room state if not exists
      if (!rooms.has(roomId)) {
        console.log('Creating new room state for:', roomId);
        rooms.set(roomId, {
          id: roomId,
          hostId: room.host_id,
          participants: new Map(),
          status: room.status || 'waiting',
          problemId: room.problem_id,
          durationMinutes: Math.floor(room.time_limit_seconds / 60) || 30,
        });
      }

      const state = rooms.get(roomId)!;

      // Add participant
      state.participants.set(userId, {
        userId,
        username: username || socket.data.user.email?.split('@')[0] || 'Anonymous',
        socketId: socket.id,
        joinedAt: new Date(),
        status: 'connected',
      });

      // Join socket room
      socket.join(roomId);
      socket.data.currentRoomId = roomId;

      // Update database with authenticated client
      await authenticatedSupabase
        .from('battle_participants')
        .upsert({
          battle_room_id: roomId,
          user_id: userId,
          username: username || socket.data.user.email?.split('@')[0] || 'Anonymous',
          joined_at: new Date().toISOString(),
          status: 'active',
          connection_status: 'connected',
        });

      // Broadcast player joined
      io.to(roomId).emit('player_joined', {
        userId,
        username: state.participants.get(userId)!.username,
      });

      // Send room state to all participants
      broadcastRoomUpdate(roomId, 'player_joined');

      // Return full room data from database merged with participants
      const responseRoom = {
        ...room, // All database fields (room_code, difficulty, etc.)
        participants: Array.from(state.participants.values()).map((p) => ({
          user_id: p.userId,
          username: p.username,
          joined_at: p.joinedAt.toISOString(),
          connection_status: p.status,
          tests_passed: p.testsPassed,
          total_tests: p.totalTests,
          time_taken: p.timeTaken,
          submission_time: p.submissionTime?.toISOString(),
        })),
      };

      callback({
        success: true,
        room: responseRoom,
      });

      console.log(`👥 User ${userId} joined room ${roomId}, participants: ${state.participants.size}`);
    } catch (error) {
      console.error('Error joining room:', error);
      callback({ success: false, error: 'Failed to join room' });
    }
  });

  // Leave room
  socket.on('leave_room', async ({ roomId }, callback) => {
    try {
      const state = rooms.get(roomId);
      if (!state) return callback({ success: true });

      // Remove participant
      state.participants.delete(userId);

      // Leave socket room
      socket.leave(roomId);
      socket.data.currentRoomId = null;

      // Update database
      await supabase
        .from('battle_participants')
        .update({ 
          status: 'left',
          connection_status: 'disconnected',
        })
        .eq('battle_room_id', roomId)
        .eq('user_id', userId);

      // Broadcast player left
      io.to(roomId).emit('player_left', { userId });

      // Send room update
      broadcastRoomUpdate(roomId, 'player_left');

      // Clean up empty rooms
      if (state.participants.size === 0) {
        rooms.delete(roomId);
      }

      callback({ success: true });
      console.log(`👋 User ${userId} left room ${roomId}`);
    } catch (error) {
      console.error('Error leaving room:', error);
      callback({ success: false, error: 'Failed to leave room' });
    }
  });

  // Start battle (host only)
  socket.on('start_battle', async ({ roomId }, callback) => {
    try {
      const state = rooms.get(roomId);
      if (!state) {
        console.error('Room state not found in memory:', roomId);
        return callback({ success: false, error: 'Room not found' });
      }

      if (state.hostId !== userId) {
        return callback({ success: false, error: 'Only host can start the battle' });
      }

      if (state.status !== 'waiting') {
        return callback({ success: false, error: 'Battle already started' });
      }

      // Update state
      state.status = 'active'; // Set to active immediately, no countdown
      state.startTime = new Date();
      state.endTime = new Date(Date.now() + state.durationMinutes * 60 * 1000);

      // Create authenticated Supabase client using user's token
      const userToken = socket.data.token;
      const authenticatedSupabase = createClient(supabaseUrl!, supabaseKey!, {
        global: {
          headers: {
            Authorization: `Bearer ${userToken}`
          }
        }
      });

      // Update database with correct column names and authenticated client
      const { error: updateError } = await authenticatedSupabase
        .from('battle_rooms')
        .update({
          status: 'active',
          started_at: state.startTime.toISOString(),
          ended_at: state.endTime.toISOString(),
        })
        .eq('id', roomId);

      if (updateError) {
        console.error('Failed to update room in database:', updateError);
        return callback({ success: false, error: 'Failed to start battle' });
      }

      console.log('Battle started successfully, broadcasting to room...');

      // Broadcast battle started
      io.to(roomId).emit('battle_started', {
        roomId,
        startTime: state.startTime.toISOString(),
        endTime: state.endTime.toISOString(),
      });

      // Send room update immediately with active status
      broadcastRoomUpdate(roomId, 'room_started');

      callback({ success: true });
      console.log(`🚀 Battle started in room ${roomId}`);
    } catch (error) {
      console.error('Error starting battle:', error);
      callback({ success: false, error: 'Failed to start battle' });
    }
  });

  // Submit code
  socket.on('submit_code', async ({ roomId, code, language, testsPassed, totalTests, timeTaken }, callback) => {
    try {
      const state = rooms.get(roomId);
      if (!state) {
        return callback({ success: false, error: 'Room not found' });
      }

      const participant = state.participants.get(userId);
      if (!participant) {
        return callback({ success: false, error: 'Not in room' });
      }

      // Update participant state
      participant.status = 'submitted';
      participant.testsPassed = testsPassed;
      participant.totalTests = totalTests;
      participant.timeTaken = timeTaken;
      participant.submissionTime = new Date();
      participant.code = code;
      participant.language = language;

      // Save to database
      await supabase.from('battle_submissions').insert({
        room_id: roomId,
        user_id: userId,
        code,
        language,
        tests_passed: testsPassed,
        total_tests: totalTests,
        time_taken: timeTaken,
        submitted_at: new Date().toISOString(),
      });

      // Calculate rank
      const sortedParticipants = Array.from(state.participants.values())
        .filter((p) => p.status === 'submitted')
        .sort((a, b) => {
          // First by tests passed (descending)
          if (b.testsPassed! !== a.testsPassed!) {
            return b.testsPassed! - a.testsPassed!;
          }
          // Then by time (ascending)
          return a.timeTaken! - b.timeTaken!;
        });

      const rank = sortedParticipants.findIndex((p) => p.userId === userId) + 1;

      // Broadcast submission
      io.to(roomId).emit('submission_broadcast', {
        userId,
        username: participant.username,
        testsPassed,
        totalTests,
        timeTaken,
        rank,
        allPassed: testsPassed === totalTests,
      });

      // Update leaderboard
      broadcastLeaderboardUpdate(roomId);

      callback({ success: true, rank });
      console.log(`📝 User ${userId} submitted code in room ${roomId} - Rank: ${rank}`);
    } catch (error) {
      console.error('Error submitting code:', error);
      callback({ success: false, error: 'Failed to submit code' });
    }
  });

  // Handle disconnect
  socket.on('disconnect', () => {
    const roomId = socket.data.currentRoomId;
    if (roomId) {
      const state = rooms.get(roomId);
      if (state) {
        const participant = state.participants.get(userId);
        if (participant) {
          participant.status = 'disconnected';
          broadcastRoomUpdate(roomId, 'player_left');
        }
      }
    }
    console.log(`❌ User disconnected: ${userId}`);
  });
});

// Helper functions
function serializeRoomState(state: RoomState) {
  return {
    id: state.id,
    host_id: state.hostId, // Use snake_case to match database schema
    status: state.status,
    problem_id: state.problemId, // Use snake_case to match database schema
    time_limit_seconds: state.durationMinutes * 60, // Convert minutes to seconds
    started_at: state.startTime?.toISOString(),
    ended_at: state.endTime?.toISOString(),
    participants: Array.from(state.participants.values()).map((p) => ({
      user_id: p.userId, // Use snake_case to match database schema
      username: p.username,
      joined_at: p.joinedAt.toISOString(),
      connection_status: p.status, // Map status to connection_status
      tests_passed: p.testsPassed,
      total_tests: p.totalTests,
      time_taken: p.timeTaken,
      submission_time: p.submissionTime?.toISOString(),
    })),
  };
}

function broadcastRoomUpdate(roomId: string, type: string) {
  const state = rooms.get(roomId);
  if (!state) return;

  io.to(roomId).emit('room_update', {
    type,
    room: serializeRoomState(state),
  });
}

function broadcastLeaderboardUpdate(roomId: string) {
  const state = rooms.get(roomId);
  if (!state) return;

  const sortedParticipants = Array.from(state.participants.values())
    .filter((p) => p.status === 'submitted')
    .sort((a, b) => {
      if (b.testsPassed! !== a.testsPassed!) {
        return b.testsPassed! - a.testsPassed!;
      }
      return a.timeTaken! - b.timeTaken!;
    })
    .map((p, index) => ({
      userId: p.userId,
      username: p.username,
      rank: index + 1,
      testsPassed: p.testsPassed!,
      totalTests: p.totalTests!,
      timeTaken: p.timeTaken!,
      status: p.status,
    }));

  io.to(roomId).emit('leaderboard_update', sortedParticipants);
}

const PORT = process.env.WEBSOCKET_PORT || 3001;
httpServer.listen(PORT, () => {
  console.log(`🚀 WebSocket server running on port ${PORT}`);
});
