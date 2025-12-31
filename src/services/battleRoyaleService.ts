import { io, Socket } from 'socket.io-client';

// Match database schema with snake_case fields
export interface BattleRoom {
  id: string;
  room_code: string;
  host_id: string;
  problem_id: string | null;
  difficulty: 'easy' | 'medium' | 'hard';
  battle_mode: 'speed_race' | 'accuracy_challenge' | 'optimization_battle' | 'elimination';
  status: 'waiting' | 'starting' | 'active' | 'finished';
  max_participants: number;
  current_participants: number;
  time_limit_seconds: number;
  started_at?: string;
  ended_at?: string;
  winner_id?: string;
  winner_username?: string;
  winner_score?: number;
  created_at: string;
  updated_at: string;
}

export interface BattleParticipant {
  id: string;
  battle_room_id: string;
  user_id: string;
  username: string;
  avatar_url?: string | null;
  rating: number;
  joined_at: string;
  last_seen?: string | null;
  connection_status: 'connected' | 'disconnected';
  tests_passed?: number | null;
  total_tests?: number | null;
  time_taken?: number | null;
  submission_time?: string | null;
  final_rank?: number | null;
}

export interface SubmissionBroadcast {
  user_id: string;
  username: string;
  tests_passed: number;
  total_tests: number;
  time_taken: number;
  rank: number;
  all_passed: boolean;
}

export interface RoomUpdate {
  type: 'player_joined' | 'player_left' | 'room_started' | 'room_finished' | 'submission' | 'leaderboard_update';
  room: BattleRoom;
  data?: any;
}

class BattleRoyaleService {
  private socket: Socket | null = null;
  private connected: boolean = false;
  private currentRoomId: string | null = null;

  /**
   * Initialize WebSocket connection
   */
  connect(userId: string, token: string): Promise<void> {
    return new Promise((resolve, reject) => {
      if (this.socket?.connected) {
        resolve();
        return;
      }

      // Connect to WebSocket server
      this.socket = io(import.meta.env.VITE_WEBSOCKET_URL || 'http://localhost:3001', {
        auth: {
          userId,
          token,
        },
        reconnection: true,
        reconnectionDelay: 1000,
        reconnectionAttempts: 5,
      });

      this.socket.on('connect', () => {
        this.connected = true;
        console.log('✅ WebSocket connected');
        resolve();
      });

      this.socket.on('connect_error', (error) => {
        console.error('❌ WebSocket connection error:', error);
        reject(error);
      });

      this.socket.on('disconnect', (reason) => {
        this.connected = false;
        console.log('🔌 WebSocket disconnected:', reason);
      });
    });
  }

  /**
   * Disconnect from WebSocket
   */
  disconnect(): void {
    if (this.socket) {
      this.socket.disconnect();
      this.socket = null;
      this.connected = false;
      this.currentRoomId = null;
    }
  }

  /**
   * Check if connected
   */
  isConnected(): boolean {
    return this.connected && this.socket?.connected === true;
  }

  /**
   * Join a battle room
   */
  async joinRoom(roomId: string, userId: string, username: string): Promise<BattleRoom> {
    if (!this.socket) throw new Error('WebSocket not connected');

    return new Promise((resolve, reject) => {
      this.socket!.emit('join_room', { roomId, userId, username }, (response: any) => {
        if (response.success) {
          this.currentRoomId = roomId;
          resolve(response.room);
        } else {
          reject(new Error(response.error || 'Failed to join room'));
        }
      });
    });
  }

  /**
   * Leave current room
   */
  async leaveRoom(): Promise<void> {
    if (!this.socket || !this.currentRoomId) return;

    return new Promise((resolve) => {
      this.socket!.emit('leave_room', { roomId: this.currentRoomId }, () => {
        this.currentRoomId = null;
        resolve();
      });
    });
  }

  /**
   * Start a battle (host only)
   */
  async startBattle(roomId: string): Promise<void> {
    if (!this.socket) throw new Error('WebSocket not connected');

    return new Promise((resolve, reject) => {
      this.socket!.emit('start_battle', { roomId }, (response: any) => {
        if (response.success) {
          resolve();
        } else {
          reject(new Error(response.error || 'Failed to start battle'));
        }
      });
    });
  }

  /**
   * Submit code during battle
   */
  async submitCode(
    roomId: string,
    userId: string,
    code: string,
    language: string,
    testsPassed: number,
    totalTests: number,
    timeTaken: number
  ): Promise<void> {
    if (!this.socket) throw new Error('WebSocket not connected');

    return new Promise((resolve, reject) => {
      this.socket!.emit(
        'submit_code',
        {
          roomId,
          userId,
          code,
          language,
          testsPassed,
          totalTests,
          timeTaken,
        },
        (response: any) => {
          if (response.success) {
            resolve();
          } else {
            reject(new Error(response.error || 'Failed to submit code'));
          }
        }
      );
    });
  }

  /**
   * Listen for room updates
   */
  onRoomUpdate(callback: (update: RoomUpdate) => void): () => void {
    if (!this.socket) return () => {};

    this.socket.on('room_update', callback);

    // Return cleanup function
    return () => {
      this.socket?.off('room_update', callback);
    };
  }

  /**
   * Listen for player joined events
   */
  onPlayerJoined(callback: (data: { userId: string; username: string }) => void): () => void {
    if (!this.socket) return () => {};

    this.socket.on('player_joined', callback);

    return () => {
      this.socket?.off('player_joined', callback);
    };
  }

  /**
   * Listen for player left events
   */
  onPlayerLeft(callback: (data: { userId: string; username: string }) => void): () => void {
    if (!this.socket) return () => {};

    this.socket.on('player_left', callback);

    return () => {
      this.socket?.off('player_left', callback);
    };
  }

  /**
   * Listen for battle started events
   */
  onBattleStarted(callback: (data: { roomId: string; startTime: string }) => void): () => void {
    if (!this.socket) return () => {};

    this.socket.on('battle_started', callback);

    return () => {
      this.socket?.off('battle_started', callback);
    };
  }

  /**
   * Listen for submission broadcasts
   */
  onSubmission(callback: (data: SubmissionBroadcast) => void): () => void {
    if (!this.socket) return () => {};

    this.socket.on('submission_broadcast', callback);

    return () => {
      this.socket?.off('submission_broadcast', callback);
    };
  }

  /**
   * Listen for leaderboard updates
   */
  onLeaderboardUpdate(callback: (participants: BattleParticipant[]) => void): () => void {
    if (!this.socket) return () => {};

    this.socket.on('leaderboard_update', callback);

    return () => {
      this.socket?.off('leaderboard_update', callback);
    };
  }

  /**
   * Listen for battle finished events
   */
  onBattleFinished(callback: (data: { roomId: string; winner: BattleParticipant }) => void): () => void {
    if (!this.socket) return () => {};

    this.socket.on('battle_finished', callback);

    return () => {
      this.socket?.off('battle_finished', callback);
    };
  }

  /**
   * Get current room ID
   */
  getCurrentRoomId(): string | null {
    return this.currentRoomId;
  }
}

export const battleRoyaleService = new BattleRoyaleService();
