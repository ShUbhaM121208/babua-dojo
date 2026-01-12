import { useState, useEffect, useCallback } from 'react';
import { Layout } from '@/components/layout/Layout';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { useToast } from '@/hooks/use-toast';
import { useAuth } from '@/contexts/AuthContext';
import { useNavigate, useSearchParams } from 'react-router-dom';
import {
  createWhiteboardRoom,
  joinWhiteboardRoom,
  getRoomParticipants,
  leaveWhiteboardRoom,
  closeWhiteboardRoom,
  subscribeToRoom,
  saveDrawingEvent,
  getDrawingHistory,
  broadcastDrawingEvent,
  WhiteboardRoom,
  WhiteboardParticipant,
  DrawingEvent,
} from '@/lib/whiteboardService';
import WhiteboardCanvas, { DrawingTool } from '@/components/whiteboard/WhiteboardCanvas';
import RoomControls from '@/components/whiteboard/RoomControls';
import {
  Pen,
  Eraser,
  Type,
  Square,
  Circle,
  Minus,
  Undo,
  Trash2,
  Plus,
  Users,
  Share2,
  Crown,
} from 'lucide-react';
import { RealtimeChannel } from '@supabase/supabase-js';

type View = 'lobby' | 'whiteboard';

export default function Whiteboard() {
  const { user } = useAuth();
  const { toast } = useToast();
  const navigate = useNavigate();
  const [searchParams, setSearchParams] = useSearchParams();
  
  // View state
  const [currentView, setCurrentView] = useState<View>('lobby');
  
  // Room state
  const [room, setRoom] = useState<WhiteboardRoom | null>(null);
  const [participants, setParticipants] = useState<WhiteboardParticipant[]>([]);
  const [channel, setChannel] = useState<RealtimeChannel | null>(null);
  
  // Lobby state
  const [roomTitle, setRoomTitle] = useState('');
  const [joinCode, setJoinCode] = useState('');
  const [loading, setLoading] = useState(false);
  
  // Drawing state
  const [tool, setTool] = useState<DrawingTool>('pen');
  const [color, setColor] = useState('#000000');
  const [strokeWidth, setStrokeWidth] = useState(2);
  const [remoteEvents, setRemoteEvents] = useState<DrawingEvent[]>([]);

  // Check for join code in URL
  useEffect(() => {
    const code = searchParams.get('join');
    if (code && !room) {
      setJoinCode(code);
      handleJoinRoom(code);
    }
  }, [searchParams]);

  // Subscribe to room updates
  useEffect(() => {
    if (!room || !user) return;

    const loadParticipants = async () => {
      try {
        const data = await getRoomParticipants(room.id);
        setParticipants(data);
      } catch (error) {
        console.error('Failed to load participants:', error);
      }
    };

    const loadDrawingHistory = async () => {
      try {
        const events = await getDrawingHistory(room.id);
        setRemoteEvents(events);
      } catch (error) {
        console.error('Failed to load drawing history:', error);
      }
    };

    loadParticipants();
    loadDrawingHistory();

    const realtimeChannel = subscribeToRoom(
      room.id,
      (participant) => {
        setParticipants(prev => {
          const existing = prev.find(p => p.id === participant.id);
          if (existing) {
            return prev.map(p => p.id === participant.id ? participant : p);
          }
          return [...prev, participant];
        });
      },
      (event) => {
        setRemoteEvents(prev => [...prev, event]);
      }
    );

    setChannel(realtimeChannel);

    return () => {
      realtimeChannel.unsubscribe();
    };
  }, [room, user]);

  // Cleanup on unmount
  useEffect(() => {
    return () => {
      if (room && user) {
        leaveWhiteboardRoom(room.id, user.id);
      }
    };
  }, [room, user]);

  const handleCreateRoom = async () => {
    if (!user || !roomTitle.trim()) {
      toast({
        title: 'Error',
        description: 'Please enter a room title',
        variant: 'destructive',
      });
      return;
    }

    setLoading(true);
    try {
      const newRoom = await createWhiteboardRoom(roomTitle, user.id);
      setRoom(newRoom);
      setCurrentView('whiteboard');
      
      toast({
        title: 'Room Created!',
        description: `Room code: ${newRoom.room_code}`,
      });
    } catch (error: any) {
      toast({
        title: 'Failed to create room',
        description: error.message,
        variant: 'destructive',
      });
    } finally {
      setLoading(false);
    }
  };

  const handleJoinRoom = async (code?: string) => {
    const roomCode = code || joinCode;
    if (!user || !roomCode.trim()) {
      toast({
        title: 'Error',
        description: 'Please enter a room code',
        variant: 'destructive',
      });
      return;
    }

    setLoading(true);
    try {
      const joinedRoom = await joinWhiteboardRoom(roomCode, user.id);
      setRoom(joinedRoom);
      setCurrentView('whiteboard');
      setSearchParams({});
      
      toast({
        title: 'Joined Room!',
        description: `Welcome to ${joinedRoom.title}`,
      });
    } catch (error: any) {
      toast({
        title: 'Failed to join room',
        description: error.message,
        variant: 'destructive',
      });
    } finally {
      setLoading(false);
    }
  };

  const handleLeaveRoom = async () => {
    if (!room || !user) return;

    try {
      await leaveWhiteboardRoom(room.id, user.id);
      setRoom(null);
      setParticipants([]);
      setRemoteEvents([]);
      setCurrentView('lobby');
      setSearchParams({});
      
      toast({
        title: 'Left Room',
        description: 'You have left the whiteboard session',
      });
    } catch (error: any) {
      toast({
        title: 'Error',
        description: error.message,
        variant: 'destructive',
      });
    }
  };

  const handleCloseRoom = async () => {
    if (!room || !user) return;

    try {
      await closeWhiteboardRoom(room.id, user.id);
      setRoom(null);
      setParticipants([]);
      setRemoteEvents([]);
      setCurrentView('lobby');
      setSearchParams({});
      
      toast({
        title: 'Room Closed',
        description: 'The whiteboard session has been closed',
      });
    } catch (error: any) {
      toast({
        title: 'Error',
        description: error.message,
        variant: 'destructive',
      });
    }
  };

  const handleDraw = useCallback(async (event: DrawingEvent) => {
    if (!room || !user) return;

    try {
      // Save to database
      await saveDrawingEvent(event);
      
      // Broadcast to other participants
      if (channel) {
        await broadcastDrawingEvent(channel, event);
      }
    } catch (error) {
      console.error('Failed to save drawing event:', error);
    }
  }, [room, user, channel]);

  const isSolver = room?.solver_id === user?.id;

  const colors = [
    '#000000', '#EF4444', '#F59E0B', '#10B981', 
    '#3B82F6', '#8B5CF6', '#EC4899', '#FFFFFF'
  ];

  if (currentView === 'lobby') {
    return (
      <Layout>
        <div className="min-h-screen bg-gradient-to-br from-gray-900 via-purple-900 to-gray-900 py-12 px-4">
          <div className="max-w-4xl mx-auto">
            {/* Header */}
            <div className="text-center mb-12">
              <div className="inline-block p-3 bg-purple-500/20 rounded-full mb-4">
                <Users className="h-12 w-12 text-purple-400" />
              </div>
              <h1 className="text-4xl font-bold text-white mb-4">
                Collaborative Whiteboard
              </h1>
              <p className="text-gray-300 text-lg">
                Create or join a room to start drawing together
              </p>
            </div>

            <div className="grid md:grid-cols-2 gap-8">
              {/* Create Room Card */}
              <div className="bg-gray-800/50 backdrop-blur border border-gray-700 rounded-xl p-8">
                <div className="flex items-center gap-3 mb-6">
                  <div className="p-2 bg-green-500/20 rounded-lg">
                    <Plus className="h-6 w-6 text-green-400" />
                  </div>
                  <h2 className="text-2xl font-bold text-white">Create Room</h2>
                </div>

                <div className="space-y-4">
                  <div>
                    <Label htmlFor="title" className="text-gray-300">
                      Room Title
                    </Label>
                    <Input
                      id="title"
                      placeholder="e.g., Algorithm Study Session"
                      value={roomTitle}
                      onChange={(e) => setRoomTitle(e.target.value)}
                      onKeyPress={(e) => e.key === 'Enter' && handleCreateRoom()}
                      className="mt-2 bg-gray-900 border-gray-700 text-white"
                    />
                  </div>

                  <Button
                    onClick={handleCreateRoom}
                    disabled={loading || !roomTitle.trim()}
                    className="w-full bg-green-600 hover:bg-green-700"
                  >
                    {loading ? 'Creating...' : 'Create Room'}
                  </Button>

                  <p className="text-sm text-gray-400 text-center">
                    You'll get a 6-character code to share
                  </p>
                </div>
              </div>

              {/* Join Room Card */}
              <div className="bg-gray-800/50 backdrop-blur border border-gray-700 rounded-xl p-8">
                <div className="flex items-center gap-3 mb-6">
                  <div className="p-2 bg-blue-500/20 rounded-lg">
                    <Share2 className="h-6 w-6 text-blue-400" />
                  </div>
                  <h2 className="text-2xl font-bold text-white">Join Room</h2>
                </div>

                <div className="space-y-4">
                  <div>
                    <Label htmlFor="code" className="text-gray-300">
                      Room Code
                    </Label>
                    <Input
                      id="code"
                      placeholder="Enter 6-character code"
                      value={joinCode}
                      onChange={(e) => setJoinCode(e.target.value.toUpperCase())}
                      onKeyPress={(e) => e.key === 'Enter' && handleJoinRoom()}
                      maxLength={6}
                      className="mt-2 bg-gray-900 border-gray-700 text-white uppercase"
                    />
                  </div>

                  <Button
                    onClick={() => handleJoinRoom()}
                    disabled={loading || !joinCode.trim()}
                    className="w-full bg-blue-600 hover:bg-blue-700"
                  >
                    {loading ? 'Joining...' : 'Join Room'}
                  </Button>

                  <p className="text-sm text-gray-400 text-center">
                    Get the code from your friend
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </Layout>
    );
  }

  // Whiteboard View
  return (
    <Layout>
      <div className="h-screen flex flex-col bg-gray-900">
        {/* Top Toolbar */}
        <div className="bg-gray-800 border-b border-gray-700 p-4">
          <div className="flex items-center justify-between max-w-7xl mx-auto">
            <div className="flex items-center gap-4">
              <h1 className="text-xl font-bold text-white flex items-center gap-2">
                {isSolver && <Crown className="h-5 w-5 text-yellow-500" />}
                {room?.title}
              </h1>
              <span className="px-3 py-1 bg-purple-600 rounded-full text-sm font-mono">
                {room?.room_code}
              </span>
            </div>

            <div className="flex items-center gap-2">
              <Button
                variant="outline"
                size="sm"
                onClick={handleLeaveRoom}
                className="bg-gray-700 border-gray-600"
              >
                Leave
              </Button>
              {isSolver && (
                <Button
                  variant="destructive"
                  size="sm"
                  onClick={handleCloseRoom}
                >
                  Close Room
                </Button>
              )}
            </div>
          </div>
        </div>

        <div className="flex-1 flex overflow-hidden">
          {/* Main Canvas Area */}
          <div className="flex-1 flex flex-col bg-gray-900">
            {/* Drawing Toolbar */}
            <div className="bg-gray-800 border-b border-gray-700 p-4">
              <div className="flex items-center gap-4 flex-wrap">
                {/* Tools */}
                <div className="flex gap-1 border-r border-gray-700 pr-4">
                  <Button
                    variant={tool === 'pen' ? 'default' : 'outline'}
                    size="sm"
                    onClick={() => setTool('pen')}
                    title="Pen"
                  >
                    <Pen className="h-4 w-4" />
                  </Button>
                  <Button
                    variant={tool === 'eraser' ? 'default' : 'outline'}
                    size="sm"
                    onClick={() => setTool('eraser')}
                    title="Eraser"
                  >
                    <Eraser className="h-4 w-4" />
                  </Button>
                  <Button
                    variant={tool === 'line' ? 'default' : 'outline'}
                    size="sm"
                    onClick={() => setTool('line')}
                    title="Line"
                  >
                    <Minus className="h-4 w-4" />
                  </Button>
                  <Button
                    variant={tool === 'rectangle' ? 'default' : 'outline'}
                    size="sm"
                    onClick={() => setTool('rectangle')}
                    title="Rectangle"
                  >
                    <Square className="h-4 w-4" />
                  </Button>
                  <Button
                    variant={tool === 'circle' ? 'default' : 'outline'}
                    size="sm"
                    onClick={() => setTool('circle')}
                    title="Circle"
                  >
                    <Circle className="h-4 w-4" />
                  </Button>
                </div>

                {/* Colors */}
                <div className="flex gap-1 border-r border-gray-700 pr-4">
                  {colors.map((c) => (
                    <button
                      key={c}
                      onClick={() => setColor(c)}
                      className={`h-9 w-9 rounded-lg border-2 transition-all ${
                        color === c ? 'border-white scale-110' : 'border-gray-600'
                      }`}
                      style={{ backgroundColor: c }}
                      title={c}
                    />
                  ))}
                </div>

                {/* Stroke Width */}
                <div className="flex items-center gap-2">
                  <Label className="text-gray-300 text-sm">Width:</Label>
                  <select
                    value={strokeWidth}
                    onChange={(e) => setStrokeWidth(Number(e.target.value))}
                    className="bg-gray-700 text-white border-gray-600 rounded px-2 py-1 text-sm"
                  >
                    <option value="1">1px</option>
                    <option value="2">2px</option>
                    <option value="4">4px</option>
                    <option value="6">6px</option>
                    <option value="8">8px</option>
                  </select>
                </div>
              </div>
            </div>

            {/* Canvas */}
            <div className="flex-1 bg-white">
              <WhiteboardCanvas
                tool={tool}
                color={color}
                strokeWidth={strokeWidth}
                onDraw={handleDraw}
                remoteEvents={remoteEvents}
                roomId={room?.id || ''}
                userId={user?.id || ''}
              />
            </div>
          </div>

          {/* Right Sidebar */}
          {room && (
            <RoomControls
              room={room}
              participants={participants}
              isSolver={isSolver}
              onLeave={handleLeaveRoom}
              onClose={handleCloseRoom}
            />
          )}
        </div>
      </div>
    </Layout>
  );
}
