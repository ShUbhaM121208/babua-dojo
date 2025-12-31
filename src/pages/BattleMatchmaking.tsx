import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { Layout } from '@/components/layout/Layout';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Badge } from '@/components/ui/badge';
import { Input } from '@/components/ui/input';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { DifficultyBadge } from '@/components/ui/DifficultyBadge';
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle, DialogTrigger } from '@/components/ui/dialog';
import { Loader2, Swords, Users, Trophy, Plus, Clock, Timer, Share2, Copy, Check, Target, Zap } from 'lucide-react';
import { useAuth } from '@/contexts/AuthContext';
import { useToast } from '@/hooks/use-toast';
import { joinMatchmakingQueue, leaveMatchmakingQueue, getUserBattleRating, createBattleRoom, joinBattleRoom } from '@/lib/battleService';
import { supabase } from '@/integrations/supabase/client';

export default function BattleMatchmaking() {
  const navigate = useNavigate();
  const { user } = useAuth();
  const { toast } = useToast();
  
  const [activeTab, setActiveTab] = useState('live');
  const [difficulty, setDifficulty] = useState('medium');
  const [mode, setMode] = useState('speed_race');
  const [inQueue, setInQueue] = useState(false);
  const [rating, setRating] = useState(1200);
  const [roomCode, setRoomCode] = useState('');
  const [createDialogOpen, setCreateDialogOpen] = useState(false);
  const [copiedRoomId, setCopiedRoomId] = useState<string | null>(null);

  // Mock data for live battles
  const liveBattles = [
    {
      id: '1',
      problem: 'Array Merger',
      slug: 'array-merger',
      difficulty: 'easy',
      players: 3,
      maxPlayers: 4,
      timeLeft: 12,
      prize: '100 XP',
      status: 'starting-soon' as const,
      roomCode: 'ABC123'
    },
    {
      id: '2',
      problem: 'Interval Merger',
      slug: 'interval-merger',
      difficulty: 'medium',
      players: 4,
      maxPlayers: 4,
      timeLeft: 5,
      prize: '250 XP',
      status: 'in-progress' as const,
      roomCode: 'XYZ789'
    },
    {
      id: '3',
      problem: 'Triplet Sum Finder',
      slug: 'triplet-sum-finder',
      difficulty: 'hard',
      players: 2,
      maxPlayers: 4,
      timeLeft: 28,
      prize: '500 XP',
      status: 'starting-soon' as const,
      roomCode: 'DEF456'
    },
  ];

  const leaderboard = [
    { rank: 1, name: 'code_ninja_42', wins: 127, rating: 2450, streak: 12 },
    { rank: 2, name: 'algo_master', wins: 119, rating: 2380, streak: 8 },
    { rank: 3, name: 'debug_queen', wins: 98, rating: 2210, streak: 15 },
    { rank: 4, name: 'you', wins: 34, rating: rating, streak: 3, isCurrentUser: true },
  ];

  const myHistory = [
    { problem: 'Valid Parentheses', slug: 'valid-parentheses', difficulty: 'easy', result: 'won' as const, time: '8:45', xp: '+100', rank: 1 },
    { problem: 'Triplet Sum Finder', slug: 'triplet-sum-finder', difficulty: 'medium', result: 'lost' as const, time: '15:23', xp: '+50', rank: 3 },
    { problem: 'Unique Char Substring', slug: 'unique-char-substring', difficulty: 'medium', result: 'won' as const, time: '12:10', xp: '+250', rank: 1 },
  ];

  useEffect(() => {
    if (user) {
      getUserBattleRating(user.id).then(data => setRating(data.current_rating));
    }
  }, [user]);

  useEffect(() => {
    if (!inQueue) return;
    
    const channel = supabase
      .channel(`queue-${user?.id}`)
      .on('postgres_changes', {
        event: 'UPDATE',
        schema: 'public',
        table: 'matchmaking_queue',
        filter: `user_id=eq.${user?.id}`
      }, (payload: any) => {
        if (payload.new.match_found && payload.new.matched_room_id) {
          toast({ title: 'Match found!', description: 'Joining battle...' });
          navigate(`/battle/${payload.new.matched_room_id}`);
        }
      })
      .subscribe();
      
    return () => {
      channel.unsubscribe();
    };
  }, [inQueue, user]);

  const handleJoinQueue = async () => {
    if (!user) return;
    
    try {
      setInQueue(true);
      await joinMatchmakingQueue(user.id, user.user_metadata?.full_name || 'Player', rating, {
        difficulty,
        mode,
        languages: ['javascript']
      });
      
      toast({
        title: 'Joined matchmaking',
        description: 'Searching for opponents...'
      });
    } catch (error: any) {
      toast({
        title: 'Error',
        description: error.message,
        variant: 'destructive'
      });
      setInQueue(false);
    }
  };

  const handleLeaveQueue = async () => {
    if (!user) return;
    
    try {
      await leaveMatchmakingQueue(user.id);
      setInQueue(false);
      toast({ title: 'Left queue' });
    } catch (error: any) {
      toast({ title: 'Error', description: error.message, variant: 'destructive' });
    }
  };

  const handleShareBattle = async (roomId: string, roomCode: string, problem: string) => {
    const battleLink = `${window.location.origin}/battle-matchmaking?join=${roomCode}`;
    
    try {
      await navigator.clipboard.writeText(battleLink);
      setCopiedRoomId(roomId);
      toast({
        title: 'Link Copied!',
        description: `Share this link with others to join the ${problem} battle`
      });
      
      setTimeout(() => setCopiedRoomId(null), 2000);
    } catch (err) {
      toast({
        title: 'Failed to copy',
        description: 'Please copy the link manually',
        variant: 'destructive'
      });
    }
  };

  const formatTimeLeft = (minutes: number) => {
    return `Starts in ${minutes} min`;
  };

  const handleCreateRoom = async () => {
    if (!user) return;
    
    try {
      const room = await createBattleRoom('1', difficulty, mode, 4, 1800, user.id);
      
      // Automatically join the room as the creator
      const username = user.user_metadata?.full_name || user.email?.split('@')[0] || 'Player';
      const userRating = await getUserBattleRating(user.id);
      
      await joinBattleRoom(room.id, user.id, username, userRating.current_rating);
      
      toast({ title: 'Room created!', description: `Room code: ${room.room_code}` });
      navigate(`/battle/${room.id}`);
    } catch (error: any) {
      toast({ title: 'Error', description: error.message, variant: 'destructive' });
    }
  };

  const handleJoinWithCode = async () => {
    if (!roomCode.trim()) return;
    
    const { data } = await supabase
      .from('battle_rooms')
      .select('id')
      .eq('room_code', roomCode.toUpperCase())
      .single();
      
    if (data) {
      navigate(`/battle/${data.id}`);
    } else {
      toast({ title: 'Error', description: 'Room not found', variant: 'destructive' });
    }
  };

  return (
    <Layout>
      <div className="container mx-auto px-4 py-12">
        <div className="max-w-6xl mx-auto">
          {/* Header */}
          <div className="text-center mb-8">
            <Swords className="h-16 w-16 mx-auto mb-4 text-primary" />
            <h1 className="text-4xl font-bold mb-2">Code Battle Royale</h1>
            <p className="text-muted-foreground">
              Compete in real-time coding battles. Test your skills against other developers.
            </p>
          </div>

          {/* Stats Cards */}
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
            <Card>
              <CardContent className="pt-6">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-muted-foreground">Your Rating</p>
                    <p className="text-3xl font-bold text-primary">{rating}</p>
                  </div>
                  <Trophy className="h-10 w-10 text-primary/20" />
                </div>
              </CardContent>
            </Card>

            <Card>
              <CardContent className="pt-6">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-muted-foreground">Total Wins</p>
                    <p className="text-3xl font-bold">34</p>
                  </div>
                  <Target className="h-10 w-10 text-primary/20" />
                </div>
              </CardContent>
            </Card>

            <Card>
              <CardContent className="pt-6">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-muted-foreground">Win Streak</p>
                    <p className="text-3xl font-bold text-primary">3</p>
                  </div>
                  <Zap className="h-10 w-10 text-primary/20" />
                </div>
              </CardContent>
            </Card>
          </div>

          {/* Tabs */}
          <Tabs value={activeTab} onValueChange={setActiveTab} className="mb-8">
            <TabsList className="grid w-full grid-cols-3">
              <TabsTrigger value="live" className="flex items-center gap-2">
                <Target className="h-4 w-4" />
                Live Battles
              </TabsTrigger>
              <TabsTrigger value="leaderboard" className="flex items-center gap-2">
                <Trophy className="h-4 w-4" />
                Leaderboard
              </TabsTrigger>
              <TabsTrigger value="history" className="flex items-center gap-2">
                <Clock className="h-4 w-4" />
                My History
              </TabsTrigger>
            </TabsList>

            {/* Live Battles Tab */}
            <TabsContent value="live" className="space-y-4">
              <div className="grid gap-4">
                {liveBattles.map((battle) => (
                  <Card key={battle.id} className="relative overflow-hidden">
                    {battle.status === 'in-progress' && (
                      <div className="absolute top-0 left-0 right-0 h-1 bg-gradient-to-r from-primary to-primary/50 animate-pulse" />
                    )}
                    <CardContent className="p-6">
                      <div className="flex items-center justify-between">
                        <div className="flex-1">
                          <div className="flex items-center gap-3 mb-2">
                            <h3 className="text-xl font-bold">{battle.problem}</h3>
                            <DifficultyBadge difficulty={battle.difficulty} />
                            <Badge variant={battle.status === 'in-progress' ? 'default' : 'secondary'}>
                              {battle.status === 'in-progress' ? 'In Progress' : 'Starting Soon'}
                            </Badge>
                          </div>
                          
                          <div className="flex items-center gap-6 text-sm text-muted-foreground">
                            <div className="flex items-center gap-2">
                              <Users className="h-4 w-4" />
                              <span>{battle.players}/{battle.maxPlayers} players</span>
                            </div>
                            <div className="flex items-center gap-2">
                              <Timer className="h-4 w-4" />
                              <span>{formatTimeLeft(battle.timeLeft)}</span>
                            </div>
                            <div className="flex items-center gap-2">
                              <Trophy className="h-4 w-4" />
                              <span>{battle.prize}</span>
                            </div>
                          </div>
                          
                          <p className="text-xs text-muted-foreground mt-2 font-mono">
                            Room Code: {battle.roomCode}
                          </p>
                        </div>
                        
                        <div className="flex items-center gap-2">
                          <Button
                            variant="outline"
                            size="icon"
                            onClick={() => handleShareBattle(battle.id, battle.roomCode, battle.problem)}
                          >
                            {copiedRoomId === battle.id ? (
                              <Check className="h-4 w-4" />
                            ) : (
                              <Share2 className="h-4 w-4" />
                            )}
                          </Button>
                          <Button
                            onClick={() => {
                              if (battle.status === 'in-progress') {
                                toast({ title: 'Battle already started', variant: 'destructive' });
                              } else {
                                navigate(`/battle/${battle.id}`);
                              }
                            }}
                            disabled={battle.players >= battle.maxPlayers}
                          >
                            <Swords className="mr-2 h-4 w-4" />
                            {battle.players >= battle.maxPlayers ? 'Full' : 'Join Battle'}
                          </Button>
                        </div>
                      </div>
                    </CardContent>
                  </Card>
                ))}
              </div>
            </TabsContent>

            {/* Leaderboard Tab */}
            <TabsContent value="leaderboard">
              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <Trophy className="h-5 w-5 text-primary" />
                    Top Battlers
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="space-y-3">
                    {leaderboard.map((player) => (
                      <div
                        key={player.rank}
                        className={`flex items-center justify-between p-4 rounded-lg ${
                          player.isCurrentUser ? 'bg-primary/10 border-2 border-primary' : 'bg-secondary/50'
                        }`}
                      >
                        <div className="flex items-center gap-4">
                          <div
                            className={`font-bold text-lg w-8 ${
                              player.rank === 1
                                ? 'text-amber-400'
                                : player.rank === 2
                                ? 'text-zinc-400'
                                : player.rank === 3
                                ? 'text-amber-600'
                                : 'text-muted-foreground'
                            }`}
                          >
                            #{player.rank}
                          </div>
                          <div>
                            <p className="font-semibold">{player.name}</p>
                            <p className="text-sm text-muted-foreground">
                              {player.wins} wins • {player.streak} streak
                            </p>
                          </div>
                        </div>
                        <div className="text-right">
                          <p className="text-2xl font-bold text-primary">{player.rating}</p>
                          <p className="text-xs text-muted-foreground">rating</p>
                        </div>
                      </div>
                    ))}
                  </div>
                </CardContent>
              </Card>
            </TabsContent>

            {/* History Tab */}
            <TabsContent value="history">
              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <Clock className="h-5 w-5 text-primary" />
                    Battle History
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="space-y-3">
                    {myHistory.map((battle, index) => (
                      <div
                        key={index}
                        className="flex items-center justify-between p-4 rounded-lg bg-secondary/50"
                      >
                        <div className="flex items-center gap-4">
                          <div
                            className={`w-3 h-3 rounded-full ${
                              battle.result === 'won' ? 'bg-primary' : 'bg-destructive'
                            }`}
                          />
                          <div>
                            <div className="flex items-center gap-2">
                              <p className="font-semibold">{battle.problem}</p>
                              <DifficultyBadge difficulty={battle.difficulty} />
                            </div>
                            <p className="text-sm text-muted-foreground">
                              {battle.result === 'won' ? '🏆 Victory' : '💀 Defeated'} • Rank #{battle.rank} • {battle.time}
                            </p>
                          </div>
                        </div>
                        <div className="text-right">
                          <p className={`text-lg font-bold ${battle.result === 'won' ? 'text-primary' : 'text-muted-foreground'}`}>
                            {battle.xp} XP
                          </p>
                          <Button
                            variant="ghost"
                            size="sm"
                            onClick={() => navigate(`/problems/${battle.slug}`)}
                          >
                            View Problem
                          </Button>
                        </div>
                      </div>
                    ))}
                  </div>
                </CardContent>
              </Card>
            </TabsContent>
          </Tabs>

          {/* Original Matchmaking Section */}
          <div className="grid md:grid-cols-2 gap-6">
            <Card>
              <CardHeader>
                <CardTitle>Your Rating</CardTitle>
                <CardDescription>Competitive ELO rating</CardDescription>
              </CardHeader>
              <CardContent>
                <div className="flex items-center justify-between">
                  <Trophy className="h-8 w-8 text-yellow-500" />
                  <span className="text-3xl font-bold">{rating}</span>
                </div>
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <CardTitle>Quick Join</CardTitle>
                <CardDescription>Enter room code</CardDescription>
              </CardHeader>
              <CardContent>
                <div className="flex gap-2">
                  <Input
                    placeholder="ROOM CODE"
                    value={roomCode}
                    onChange={(e) => setRoomCode(e.target.value.toUpperCase())}
                    maxLength={6}
                  />
                  <Button onClick={handleJoinWithCode}>Join</Button>
                </div>
              </CardContent>
            </Card>
          </div>

          <Card>
            <CardHeader>
              <CardTitle>Matchmaking</CardTitle>
              <CardDescription>Find opponents and start battling</CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="grid md:grid-cols-2 gap-4">
                <div>
                  <label className="text-sm font-medium mb-2 block">Difficulty</label>
                  <Select value={difficulty} onValueChange={setDifficulty} disabled={inQueue}>
                    <SelectTrigger>
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="easy">Easy</SelectItem>
                      <SelectItem value="medium">Medium</SelectItem>
                      <SelectItem value="hard">Hard</SelectItem>
                      <SelectItem value="mixed">Mixed</SelectItem>
                    </SelectContent>
                  </Select>
                </div>

                <div>
                  <label className="text-sm font-medium mb-2 block">Battle Mode</label>
                  <Select value={mode} onValueChange={setMode} disabled={inQueue}>
                    <SelectTrigger>
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="speed_race">Speed Race</SelectItem>
                      <SelectItem value="accuracy_challenge">Accuracy Challenge</SelectItem>
                      <SelectItem value="optimization_battle">Optimization Battle</SelectItem>
                      <SelectItem value="elimination">Elimination</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
              </div>

              <div className="flex gap-2">
                {!inQueue ? (
                  <>
                    <Button onClick={handleJoinQueue} className="flex-1">
                      <Users className="mr-2 h-4 w-4" />
                      Find Match
                    </Button>
                    <Dialog open={createDialogOpen} onOpenChange={setCreateDialogOpen}>
                      <DialogTrigger asChild>
                        <Button variant="outline">
                          <Plus className="mr-2 h-4 w-4" />
                          Create Room
                        </Button>
                      </DialogTrigger>
                      <DialogContent>
                        <DialogHeader>
                          <DialogTitle>Create Private Room</DialogTitle>
                          <DialogDescription>
                            Create a private battle room and share the code with friends
                          </DialogDescription>
                        </DialogHeader>
                        <Button onClick={handleCreateRoom}>Create Room</Button>
                      </DialogContent>
                    </Dialog>
                  </>
                ) : (
                  <Button onClick={handleLeaveQueue} variant="destructive" className="flex-1">
                    <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                    Searching... (Click to cancel)
                  </Button>
                )}
              </div>

              {inQueue && (
                <div className="text-center py-4">
                  <p className="text-sm text-muted-foreground">
                    Looking for opponents with similar rating...
                  </p>
                </div>
              )}
            </CardContent>
          </Card>
        </div>
      </div>
    </Layout>
  );
}
