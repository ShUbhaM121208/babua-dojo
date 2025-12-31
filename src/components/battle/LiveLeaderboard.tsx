import { useEffect, useState } from 'react';
import { supabase } from '@/integrations/supabase/client';
import { Card } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Avatar, AvatarFallback } from '@/components/ui/avatar';
import { ScrollArea } from '@/components/ui/scroll-area';
import { Progress } from '@/components/ui/progress';
import { TrendingUp, TrendingDown, Minus, Crown, Zap } from 'lucide-react';
import type { LeaderboardEntry } from '@/types/battle';

interface LiveLeaderboardProps {
  battleRoomId: string;
  currentUserId: string;
}

export function LiveLeaderboard({ battleRoomId, currentUserId }: LiveLeaderboardProps) {
  const [leaderboard, setLeaderboard] = useState<LeaderboardEntry[]>([]);
  const [previousRanks, setPreviousRanks] = useState<Map<string, number>>(new Map());

  useEffect(() => {
    loadLeaderboard();
    
    const channel = supabase
      .channel(`leaderboard-${battleRoomId}`)
      .on('postgres_changes', {
        event: 'UPDATE',
        schema: 'public',
        table: 'battle_rooms',
        filter: `id=eq.${battleRoomId}`
      }, (payload: any) => {
        const newLeaderboard = payload.new.leaderboard || [];
        const prevRanks = new Map(previousRanks);
        leaderboard.forEach(entry => {
          prevRanks.set(entry.user_id, entry.rank);
        });
        setPreviousRanks(prevRanks);
        setLeaderboard(newLeaderboard);
      })
      .subscribe();
      
    return () => {
      channel.unsubscribe();
    };
  }, [battleRoomId]);

  const loadLeaderboard = async () => {
    const { data } = await supabase
      .from('battle_rooms')
      .select('leaderboard')
      .eq('id', battleRoomId)
      .single();
      
    if (data?.leaderboard) {
      setLeaderboard(data.leaderboard);
    }
  };

  const getRankChange = (userId: string, currentRank: number) => {
    const prevRank = previousRanks.get(userId);
    if (!prevRank) return null;
    if (prevRank > currentRank) return 'up';
    if (prevRank < currentRank) return 'down';
    return 'same';
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'completed': return 'default';
      case 'active': return 'secondary';
      case 'eliminated': return 'destructive';
      case 'disconnected': return 'outline';
      default: return 'secondary';
    }
  };

  return (
    <Card className="h-full">
      <div className="p-4 border-b">
        <h3 className="font-semibold flex items-center gap-2">
          <Zap className="h-4 w-4 text-yellow-500" />
          Live Rankings
        </h3>
      </div>
      
      <ScrollArea className="h-[calc(100%-60px)]">
        <div className="p-4 space-y-3">
          {leaderboard.length === 0 ? (
            <p className="text-center text-muted-foreground text-sm py-8">
              No participants yet
            </p>
          ) : (
            leaderboard.map((entry) => {
              const rankChange = getRankChange(entry.user_id, entry.rank);
              const isCurrentUser = entry.user_id === currentUserId;
              const accuracy = entry.tests_total > 0 
                ? (entry.tests_passed / entry.tests_total) * 100 
                : 0;

              return (
                <div
                  key={entry.user_id}
                  className={`p-3 rounded-lg border transition-colors ${
                    isCurrentUser ? 'bg-primary/10 border-primary' : 'bg-card'
                  }`}
                >
                  <div className="flex items-start justify-between mb-2">
                    <div className="flex items-center gap-2">
                      <div className="relative">
                        {entry.rank === 1 && (
                          <Crown className="absolute -top-2 -right-2 h-4 w-4 text-yellow-500" />
                        )}
                        <Avatar className="h-8 w-8">
                          <AvatarFallback>
                            {entry.username.charAt(0).toUpperCase()}
                          </AvatarFallback>
                        </Avatar>
                      </div>
                      <div>
                        <p className="font-medium text-sm">{entry.username}</p>
                        <div className="flex items-center gap-1 text-xs text-muted-foreground">
                          <span className="font-bold">#{entry.rank}</span>
                          {rankChange === 'up' && (
                            <TrendingUp className="h-3 w-3 text-green-500" />
                          )}
                          {rankChange === 'down' && (
                            <TrendingDown className="h-3 w-3 text-red-500" />
                          )}
                          {rankChange === 'same' && (
                            <Minus className="h-3 w-3 text-yellow-500" />
                          )}
                        </div>
                      </div>
                    </div>
                    
                    <Badge variant={getStatusColor(entry.status)} className="text-xs">
                      {entry.status}
                    </Badge>
                  </div>
                  
                  <div className="space-y-1">
                    <div className="flex justify-between text-xs">
                      <span className="text-muted-foreground">Tests Passed</span>
                      <span className="font-medium">
                        {entry.tests_passed}/{entry.tests_total}
                      </span>
                    </div>
                    <Progress value={accuracy} className="h-1" />
                    
                    <div className="flex justify-between text-xs pt-1">
                      <span className="text-muted-foreground">Points</span>
                      <span className="font-bold text-primary">{entry.points}</span>
                    </div>
                    
                    {entry.time_taken_seconds > 0 && (
                      <div className="flex justify-between text-xs">
                        <span className="text-muted-foreground">Time</span>
                        <span>{Math.floor(entry.time_taken_seconds / 60)}m {entry.time_taken_seconds % 60}s</span>
                      </div>
                    )}
                  </div>
                </div>
              );
            })
          )}
        </div>
      </ScrollArea>
    </Card>
  );
}
