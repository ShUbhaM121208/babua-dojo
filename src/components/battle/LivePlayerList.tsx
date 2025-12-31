import { Users, Wifi, WifiOff, Crown, Trophy } from 'lucide-react';
import { Card } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Avatar, AvatarFallback } from '@/components/ui/avatar';
import { ScrollArea } from '@/components/ui/scroll-area';
import type { BattleParticipant } from '@/services/battleRoyaleService';

interface LivePlayerListProps {
  participants: BattleParticipant[];
  hostId: string;
  currentUserId?: string;
  maxPlayers: number;
}

export function LivePlayerList({ participants, hostId, currentUserId, maxPlayers }: LivePlayerListProps) {
  const sortedParticipants = [...participants].sort((a, b) => {
    // Host first
    if (a.user_id === hostId) return -1;
    if (b.user_id === hostId) return 1;
    
    // Then by rank if available
    if (a.final_rank && b.final_rank) return a.final_rank - b.final_rank;
    
    // Then by joined time
    return new Date(a.joined_at).getTime() - new Date(b.joined_at).getTime();
  });

  return (
    <Card className="p-4">
      <div className="flex items-center justify-between mb-4">
        <div className="flex items-center gap-2">
          <Users className="h-5 w-5" />
          <h3 className="font-semibold">Players</h3>
        </div>
        <Badge variant="secondary">
          {participants.length}/{maxPlayers}
        </Badge>
      </div>

      <ScrollArea className="h-[400px] pr-4">
        <div className="space-y-2">
          {sortedParticipants.map((participant) => {
            const isHost = participant.user_id === hostId;
            const isCurrentUser = participant.user_id === currentUserId;
            const isConnected = participant.connection_status === 'connected';

            return (
              <div
                key={participant.user_id}
                className={`
                  flex items-center justify-between p-3 rounded-lg border
                  ${isCurrentUser ? 'bg-primary/5 border-primary' : 'bg-card'}
                  ${!isConnected ? 'opacity-50' : ''}
                `}
              >
                <div className="flex items-center gap-3 flex-1">
                  <Avatar className="h-10 w-10">
                    <AvatarFallback>
                      {participant.username.slice(0, 2).toUpperCase()}
                    </AvatarFallback>
                  </Avatar>

                  <div className="flex-1 min-w-0">
                    <div className="flex items-center gap-2">
                      <p className="font-medium truncate">
                        {participant.username}
                        {isCurrentUser && (
                          <span className="text-muted-foreground text-sm ml-1">(You)</span>
                        )}
                      </p>
                      {isHost && (
                        <Crown className="h-4 w-4 text-yellow-500" />
                      )}
                    </div>

                    <div className="flex items-center gap-2 mt-1">
                      {isConnected ? (
                        <Wifi className="h-3 w-3 text-green-500" />
                      ) : (
                        <WifiOff className="h-3 w-3 text-gray-400" />
                      )}
                      <span className="text-xs text-muted-foreground">
                        {isConnected ? 'Online' : 'Disconnected'}
                      </span>
                    </div>
                  </div>
                </div>

                <div className="flex flex-col items-end gap-1">
                  {participant.final_rank && (
                    <div className="flex items-center gap-1">
                      <Trophy className={`h-4 w-4 ${
                        participant.final_rank === 1 ? 'text-yellow-500' :
                        participant.final_rank === 2 ? 'text-gray-400' :
                        participant.final_rank === 3 ? 'text-amber-600' :
                        'text-muted-foreground'
                      }`} />
                      <span className="text-sm font-bold">#{participant.final_rank}</span>
                    </div>
                  )}

                  {participant.tests_passed !== undefined && participant.total_tests !== undefined && (
                    <div className="flex items-center gap-1">
                      <Badge 
                        variant={participant.tests_passed === participant.total_tests ? 'default' : 'secondary'}
                        className="text-xs"
                      >
                        {participant.tests_passed}/{participant.total_tests}
                      </Badge>
                    </div>
                  )}

                  {participant.time_taken !== undefined && participant.time_taken !== null && (
                    <span className="text-xs text-muted-foreground">
                      {participant.time_taken}s
                    </span>
                  )}
                </div>
              </div>
            );
          })}

          {/* Empty slots */}
          {Array.from({ length: maxPlayers - participants.length }).map((_, i) => (
            <div
              key={`empty-${i}`}
              className="flex items-center gap-3 p-3 rounded-lg border border-dashed border-muted-foreground/20"
            >
              <div className="h-10 w-10 rounded-full bg-muted" />
              <span className="text-sm text-muted-foreground">Waiting for player...</span>
            </div>
          ))}
        </div>
      </ScrollArea>
    </Card>
  );
}
