import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Calendar, Clock, Trophy, Users, Award } from "lucide-react";
import { Tournament } from "@/services/tournamentService";
import { format } from "date-fns";
import { Link } from "react-router-dom";

interface TournamentCardProps {
  tournament: Tournament;
  participantCount?: number;
  isRegistered?: boolean;
  userRank?: number;
}

export function TournamentCard({ 
  tournament, 
  participantCount = 0,
  isRegistered = false,
  userRank
}: TournamentCardProps) {
  const getStatusBadge = () => {
    switch (tournament.status) {
      case 'upcoming':
        return <Badge variant="outline" className="bg-blue-500/10 text-blue-500 border-blue-500/30">Upcoming</Badge>;
      case 'live':
        return <Badge variant="outline" className="bg-green-500/10 text-green-500 border-green-500/30 animate-pulse">Live</Badge>;
      case 'completed':
        return <Badge variant="outline" className="bg-gray-500/10 text-gray-500 border-gray-500/30">Completed</Badge>;
      default:
        return null;
    }
  };

  const getDifficultyBadge = () => {
    if (!tournament.difficulty) return null;
    
    const colors = {
      easy: 'bg-green-500/10 text-green-500 border-green-500/30',
      medium: 'bg-yellow-500/10 text-yellow-500 border-yellow-500/30',
      hard: 'bg-orange-500/10 text-orange-500 border-orange-500/30',
      expert: 'bg-red-500/10 text-red-500 border-red-500/30'
    };
    return (
      <Badge variant="outline" className={colors[tournament.difficulty]}>
        {tournament.difficulty.charAt(0).toUpperCase() + tournament.difficulty.slice(1)}
      </Badge>
    );
  };

  const formatDateTime = (date: string) => {
    return format(new Date(date), "MMM dd, yyyy 'at' hh:mm a");
  };

  const getDuration = () => {
    const start = new Date(tournament.start_time);
    const end = new Date(tournament.end_time);
    const hours = Math.floor((end.getTime() - start.getTime()) / (1000 * 60 * 60));
    return `${hours} hour${hours !== 1 ? 's' : ''}`;
  };

  const getPrizePool = () => {
    if (!tournament.prize_pool || tournament.prize_pool === 0) return null;
    return new Intl.NumberFormat('en-IN', {
      style: 'currency',
      currency: 'INR',
      maximumFractionDigits: 0
    }).format(tournament.prize_pool);
  };

  return (
    <Card className="hover:shadow-lg transition-shadow duration-200 border-2 hover:border-primary/50">
      <CardHeader>
        <div className="flex justify-between items-start mb-2">
          <div className="flex gap-2">
            {getStatusBadge()}
            {getDifficultyBadge()}
            {isRegistered && (
              <Badge variant="outline" className="bg-purple-500/10 text-purple-500 border-purple-500/30">
                Registered
              </Badge>
            )}
          </div>
          {tournament.is_rated && (
            <Award className="h-5 w-5 text-yellow-500" />
          )}
        </div>
        
        <CardTitle className="text-2xl">{tournament.name}</CardTitle>
        <CardDescription className="text-base mt-2">
          {tournament.description}
        </CardDescription>
      </CardHeader>

      <CardContent className="space-y-4">
        {/* Tournament Details */}
        <div className="grid grid-cols-2 gap-3 text-sm">
          <div className="flex items-center gap-2">
            <Calendar className="h-4 w-4 text-muted-foreground" />
            <span>{formatDateTime(tournament.start_time)}</span>
          </div>
          
          <div className="flex items-center gap-2">
            <Clock className="h-4 w-4 text-muted-foreground" />
            <span>{getDuration()}</span>
          </div>
          
          <div className="flex items-center gap-2">
            <Users className="h-4 w-4 text-muted-foreground" />
            <span>
              {participantCount} participant{participantCount !== 1 ? 's' : ''}
              {tournament.max_participants && ` / ${tournament.max_participants}`}
            </span>
          </div>
          
          {getPrizePool() && (
            <div className="flex items-center gap-2">
              <Trophy className="h-4 w-4 text-yellow-500" />
              <span className="font-semibold text-yellow-500">{getPrizePool()}</span>
            </div>
          )}
        </div>

        {/* User Rank (if completed and participated) */}
        {tournament.status === 'completed' && userRank && (
          <div className="p-3 bg-primary/5 rounded-lg border border-primary/20">
            <p className="text-sm font-medium">
              Your Rank: <span className="text-lg font-bold text-primary">#{userRank}</span>
            </p>
          </div>
        )}

        {/* Action Button */}
        <Link to={`/tournaments/${tournament.id}`}>
          <Button className="w-full" variant={tournament.status === 'live' ? 'default' : 'outline'}>
            {tournament.status === 'live' ? 'Join Now' : 
             tournament.status === 'upcoming' ? 'View Details' : 
             'View Results'}
          </Button>
        </Link>
      </CardContent>
    </Card>
  );
}
