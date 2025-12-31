import { useEffect, useState, useCallback } from "react";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Trophy, Medal, Award } from "lucide-react";
import { LeaderboardEntry, tournamentService } from "@/services/tournamentService";
import { useAuth } from "@/contexts/AuthContext";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Skeleton } from "@/components/ui/skeleton";

interface TournamentLeaderboardProps {
  tournamentId: string;
  isLive?: boolean;
  limit?: number;
}

export function TournamentLeaderboard({ 
  tournamentId, 
  isLive = false,
  limit
}: TournamentLeaderboardProps) {
  const { user } = useAuth();
  const [leaderboard, setLeaderboard] = useState<LeaderboardEntry[]>([]);
  const [loading, setLoading] = useState(true);
  const [userRank, setUserRank] = useState<number | null>(null);

  const loadLeaderboard = useCallback(async () => {
    try {
      const data = await tournamentService.getLeaderboard(tournamentId);
      const limitedData = limit ? data.slice(0, limit) : data;
      setLeaderboard(limitedData);

      // Get user's rank if they're participating
      if (user) {
        const rankEntry = await tournamentService.getUserRank(tournamentId);
        setUserRank(rankEntry ? rankEntry.rank : null);
      }
    } catch (error) {
      console.error('Failed to load leaderboard:', error);
    } finally {
      setLoading(false);
    }
  }, [tournamentId, limit, user]);

  useEffect(() => {
    loadLeaderboard();
    
    // Auto-refresh for live tournaments
    if (isLive) {
      const interval = setInterval(loadLeaderboard, 30000); // Refresh every 30s
      return () => clearInterval(interval);
    }
  }, [loadLeaderboard, isLive]);

  const getRankIcon = (rank: number) => {
    switch (rank) {
      case 1:
        return <Trophy className="h-6 w-6 text-yellow-500" />;
      case 2:
        return <Medal className="h-6 w-6 text-gray-400" />;
      case 3:
        return <Award className="h-6 w-6 text-amber-700" />;
      default:
        return <span className="text-lg font-bold text-muted-foreground">#{rank}</span>;
    }
  };

  const getRankBgColor = (rank: number) => {
    switch (rank) {
      case 1:
        return 'bg-yellow-500/10 border-yellow-500/30';
      case 2:
        return 'bg-gray-400/10 border-gray-400/30';
      case 3:
        return 'bg-amber-700/10 border-amber-700/30';
      default:
        return '';
    }
  };

  const formatTime = (minutes: number) => {
    const hours = Math.floor(minutes / 60);
    const mins = Math.floor(minutes % 60);
    if (hours > 0) {
      return `${hours}h ${mins}m`;
    }
    return `${mins}m`;
  };

  const formatPenalty = (penalty: number) => {
    if (penalty === 0) return null;
    return <span className="text-red-500 text-xs">(+{penalty}m)</span>;
  };

  if (loading) {
    return (
      <Card>
        <CardHeader>
          <CardTitle>Leaderboard</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="space-y-3">
            {[...Array(5)].map((_, i) => (
              <Skeleton key={i} className="h-16 w-full" />
            ))}
          </div>
        </CardContent>
      </Card>
    );
  }

  return (
    <Card>
      <CardHeader>
        <div className="flex justify-between items-center">
          <div>
            <CardTitle className="flex items-center gap-2">
              <Trophy className="h-5 w-5 text-yellow-500" />
              Leaderboard
            </CardTitle>
            {isLive && (
              <CardDescription className="flex items-center gap-2 mt-2">
                <span className="relative flex h-2 w-2">
                  <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-green-400 opacity-75"></span>
                  <span className="relative inline-flex rounded-full h-2 w-2 bg-green-500"></span>
                </span>
                Live - Updates every 30s
              </CardDescription>
            )}
          </div>
          
          {userRank && (
            <Badge variant="outline" className="bg-primary/10 text-primary border-primary/30">
              Your Rank: #{userRank}
            </Badge>
          )}
        </div>
      </CardHeader>

      <CardContent>
        {leaderboard.length === 0 ? (
          <div className="text-center py-8 text-muted-foreground">
            No participants yet. Be the first to register!
          </div>
        ) : (
          <div className="space-y-2">
            {leaderboard.map((entry) => (
              <div
                key={entry.user_id}
                className={`flex items-center gap-4 p-3 rounded-lg border-2 transition-colors ${
                  getRankBgColor(entry.rank)
                } ${
                  entry.user_id === user?.id ? 'border-primary bg-primary/5' : 'border-transparent hover:bg-accent'
                }`}
              >
                {/* Rank */}
                <div className="flex items-center justify-center w-12">
                  {getRankIcon(entry.rank)}
                </div>

                {/* User Info */}
                <div className="flex items-center gap-3 flex-1">
                  <Avatar className="h-10 w-10">
                    <AvatarImage src={entry.avatar_url || undefined} />
                    <AvatarFallback>
                      {entry.username?.slice(0, 2).toUpperCase() || 'U'}
                    </AvatarFallback>
                  </Avatar>
                  <div>
                    <p className="font-semibold">
                      {entry.username || 'Anonymous'}
                      {entry.user_id === user?.id && (
                        <Badge variant="outline" className="ml-2 text-xs">You</Badge>
                      )}
                    </p>
                    <p className="text-xs text-muted-foreground">
                      {entry.problems_solved?.length || 0} problem{entry.problems_solved?.length !== 1 ? 's' : ''} solved
                    </p>
                  </div>
                </div>

                {/* Score/Time */}
                <div className="text-right">
                  <p className="font-bold text-lg">
                    {formatTime(entry.total_time)}
                  </p>
                  {entry.penalty_time > 0 && (
                    <p className="text-xs text-muted-foreground">
                      {formatPenalty(entry.penalty_time)}
                    </p>
                  )}
                </div>
              </div>
            ))}
          </div>
        )}
        
        {limit && leaderboard.length >= limit && (
          <p className="text-center text-sm text-muted-foreground mt-4">
            Showing top {limit} participants
          </p>
        )}
      </CardContent>
    </Card>
  );
}
