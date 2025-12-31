import { useEffect, useState, useCallback, useRef } from 'react';
import { battleRoyaleService, type BattleRoom, type BattleParticipant, type SubmissionBroadcast } from '@/services/battleRoyaleService';
import { useAuth } from '@/contexts/AuthContext';
import { useToast } from '@/hooks/use-toast';

export function useBattleRoyale(roomId: string | null) {
  const { user, session } = useAuth();
  const { toast } = useToast();
  const [connected, setConnected] = useState(false);
  const [room, setRoom] = useState<BattleRoom | null>(null);
  const [participants, setParticipants] = useState<BattleParticipant[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const cleanupFunctionsRef = useRef<(() => void)[]>([]);

  // Connect to WebSocket
  useEffect(() => {
    if (!user || !session) return;

    const connect = async () => {
      try {
        await battleRoyaleService.connect(user.id, session.access_token);
        setConnected(true);
      } catch (err) {
        console.error('Failed to connect to WebSocket:', err);
        setError('Failed to connect to server');
        toast({
          title: 'Connection Error',
          description: 'Failed to connect to real-time server',
          variant: 'destructive',
        });
      }
    };

    connect();

    return () => {
      battleRoyaleService.disconnect();
      setConnected(false);
    };
  }, [user, session, toast]);

  // Join room
  const joinRoom = useCallback(async (roomIdToJoin: string) => {
    if (!user || !connected) {
      console.warn('Cannot join room: user or connection missing', { user: !!user, connected });
      return;
    }

    setLoading(true);
    setError(null);

    try {
      console.log('Joining room via WebSocket:', roomIdToJoin);
      const roomData = await battleRoyaleService.joinRoom(
        roomIdToJoin,
        user.id,
        user.user_metadata?.full_name || user.email?.split('@')[0] || 'Anonymous'
      );

      console.log('Join room response:', roomData);
      setRoom(roomData);
      setParticipants(roomData.participants || []);

      toast({
        title: 'Joined Room',
        description: `You've joined ${roomData.room_code || 'battle room'}`,
      });
      
      return roomData;
    } catch (err: any) {
      console.error('Failed to join room:', err);
      setError(err.message);
      toast({
        title: 'Failed to Join',
        description: err.message,
        variant: 'destructive',
      });
      throw err;
    } finally {
      setLoading(false);
    }
  }, [user, connected, toast]);

  // Leave room
  const leaveRoom = useCallback(async () => {
    try {
      await battleRoyaleService.leaveRoom();
      setRoom(null);
      setParticipants([]);
    } catch (err) {
      console.error('Failed to leave room:', err);
    }
  }, []);

  // Start battle
  const startBattle = useCallback(async (battleRoomId?: string) => {
    const roomIdToUse = battleRoomId || room?.id;
    
    if (!roomIdToUse) {
      console.error('No room ID available to start battle');
      return;
    }

    try {
      console.log('Starting battle for room:', roomIdToUse);
      await battleRoyaleService.startBattle(roomIdToUse);
      toast({
        title: 'Battle Starting!',
        description: 'Get ready to code!',
      });
    } catch (err: any) {
      console.error('Failed to start battle:', err);
      toast({
        title: 'Failed to Start',
        description: err.message,
        variant: 'destructive',
      });
    }
  }, [room, toast]);

  // Submit code
  const submitCode = useCallback(async (
    code: string,
    language: string,
    testsPassed: number,
    totalTests: number,
    timeTaken: number
  ) => {
    if (!room || !user) return;

    try {
      await battleRoyaleService.submitCode(
        room.id,
        user.id,
        code,
        language,
        testsPassed,
        totalTests,
        timeTaken
      );

      toast({
        title: 'Code Submitted!',
        description: `${testsPassed}/${totalTests} tests passed`,
      });
    } catch (err: any) {
      toast({
        title: 'Submission Failed',
        description: err.message,
        variant: 'destructive',
      });
    }
  }, [room, user, toast]);

  // Listen to events
  useEffect(() => {
    if (!roomId || !connected) return;

    // Room updates
    const unsubRoomUpdate = battleRoyaleService.onRoomUpdate((update) => {
      setRoom(update.room);
      setParticipants(update.room.participants);
    });

    // Player joined
    const unsubPlayerJoined = battleRoyaleService.onPlayerJoined((data) => {
      toast({
        title: 'Player Joined',
        description: `${data.username} joined the battle`,
      });
    });

    // Player left
    const unsubPlayerLeft = battleRoyaleService.onPlayerLeft((data) => {
      toast({
        title: 'Player Left',
        description: `${data.username} left the battle`,
      });
    });

    // Battle started
    const unsubBattleStarted = battleRoyaleService.onBattleStarted((data) => {
      // Update room status to active
      setRoom(prev => prev ? { ...prev, status: 'active', started_at: data.startTime } : null);
      
      toast({
        title: 'Battle Started!',
        description: 'The coding battle has begun!',
        duration: 5000,
      });
    });

    // Submission broadcast
    const unsubSubmission = battleRoyaleService.onSubmission((data: SubmissionBroadcast) => {
      if (data.user_id !== user?.id) {
        toast({
          title: `${data.username} submitted!`,
          description: `${data.tests_passed}/${data.total_tests} tests passed • Rank #${data.rank}`,
          duration: 3000,
        });
      }
    });

    // Leaderboard update
    const unsubLeaderboard = battleRoyaleService.onLeaderboardUpdate((updatedParticipants) => {
      setParticipants(updatedParticipants);
    });

    // Battle finished
    const unsubBattleFinished = battleRoyaleService.onBattleFinished((data) => {
      toast({
        title: 'Battle Finished!',
        description: `Winner: ${data.winner.username}`,
        duration: 10000,
      });
    });

    // Store cleanup functions
    cleanupFunctionsRef.current = [
      unsubRoomUpdate,
      unsubPlayerJoined,
      unsubPlayerLeft,
      unsubBattleStarted,
      unsubSubmission,
      unsubLeaderboard,
      unsubBattleFinished,
    ];

    return () => {
      cleanupFunctionsRef.current.forEach((cleanup) => cleanup());
      cleanupFunctionsRef.current = [];
    };
  }, [roomId, connected, user, toast]);

  return {
    connected,
    room,
    participants,
    loading,
    error,
    joinRoom,
    leaveRoom,
    startBattle,
    submitCode,
  };
}
