import { useState, useEffect } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { DifficultyBadge } from "@/components/ui/DifficultyBadge";
import { Link } from "react-router-dom";
import { useAuth } from "@/contexts/AuthContext";
import { 
  Calendar, 
  Clock, 
  Flame, 
  Trophy, 
  CheckCircle2, 
  Sparkles,
  Users,
  ArrowRight
} from "lucide-react";
import { supabase } from "@/integrations/supabase/client";

interface DailyChallenge {
  id: string;
  problem_id: string;
  challenge_date: string;
  difficulty: "easy" | "medium" | "hard";
  featured_reason: string;
  xp_bonus: number;
  problem?: {
    id: string;
    title: string;
    slug: string;
    description: string;
    acceptance_rate: number;
  };
}

interface UserStreak {
  current_streak: number;
  longest_streak: number;
  total_challenges_completed: number;
  last_completed_date: string | null;
}

interface DailyChallengeCardProps {
  className?: string;
}

export function DailyChallengeCard({ className = "" }: DailyChallengeCardProps) {
  const { user } = useAuth();
  const [challenge, setChallenge] = useState<DailyChallenge | null>(null);
  const [streak, setStreak] = useState<UserStreak | null>(null);
  const [completed, setCompleted] = useState(false);
  const [loading, setLoading] = useState(true);
  const [timeRemaining, setTimeRemaining] = useState("");
  const [participantCount, setParticipantCount] = useState(0);

  useEffect(() => {
    if (user) {
      loadDailyChallenge();
      loadUserStreak();
    }
    
    // Update countdown every minute
    const interval = setInterval(updateCountdown, 60000);
    updateCountdown();

    return () => clearInterval(interval);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [user]);

  const loadDailyChallenge = async () => {
    try {
      setLoading(true);
      const today = new Date().toISOString().split('T')[0];

      // Get today's challenge with problem details
      const { data: challengeData, error: challengeError } = await supabase
        .from('daily_challenges' as any)
        .select(`
          id,
          problem_id,
          challenge_date,
          difficulty,
          featured_reason,
          xp_bonus,
          problems:problem_id (
            id,
            title,
            slug,
            description,
            acceptance_rate
          )
        `)
        .eq('challenge_date', today)
        .single();

      if (challengeError) {
        console.error('Error loading daily challenge:', challengeError);
        return;
      }

      if (!challengeData) {
        return;
      }

      setChallenge(challengeData);

      // Check if user completed today's challenge
      if (user) {
        const { data: completionData } = await supabase
          .from('user_daily_challenge_completions' as any)
          .select('id')
          .eq('user_id', user.id)
          .eq('challenge_id', challengeData.id)
          .single();

        setCompleted(!!completionData);
      }

      // Get participant count
      const { count } = await supabase
        .from('user_daily_challenge_completions' as any)
        .select('id', { count: 'exact', head: true })
        .eq('challenge_id', challengeData.id);

      setParticipantCount(count || 0);

    } catch (error) {
      console.error('Error loading daily challenge:', error);
    } finally {
      setLoading(false);
    }
  };

  const loadUserStreak = async () => {
    if (!user) return;

    try {
      const { data: streakData } = await supabase
        .from('user_daily_streaks' as any)
        .select('*')
        .eq('user_id', user.id)
        .single();

      if (streakData) {
        setStreak(streakData);
      }
    } catch (error) {
      console.error('Error loading user streak:', error);
    }
  };

  const updateCountdown = () => {
    const now = new Date();
    const tomorrow = new Date(now);
    tomorrow.setDate(tomorrow.getDate() + 1);
    tomorrow.setHours(0, 0, 0, 0);

    const diff = tomorrow.getTime() - now.getTime();
    const hours = Math.floor(diff / (1000 * 60 * 60));
    const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));

    setTimeRemaining(`${hours}h ${minutes}m`);
  };

  if (loading) {
    return (
      <Card className={`${className} border-primary/20 bg-gradient-to-br from-primary/5 to-secondary/50`}>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <Calendar className="h-5 w-5" />
            Daily Challenge
          </CardTitle>
        </CardHeader>
        <CardContent>
          <div className="flex items-center justify-center h-32">
            <div className="animate-pulse text-muted-foreground">Loading...</div>
          </div>
        </CardContent>
      </Card>
    );
  }

  if (!challenge) {
    return (
      <Card className={`${className} border-primary/20`}>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <Calendar className="h-5 w-5" />
            Daily Challenge
          </CardTitle>
        </CardHeader>
        <CardContent>
          <p className="text-muted-foreground text-sm">
            No challenge available today. Check back tomorrow!
          </p>
        </CardContent>
      </Card>
    );
  }

  const problemData = Array.isArray((challenge as any).problems) 
    ? (challenge as any).problems[0] 
    : (challenge as any).problems || challenge.problem;

  return (
    <Card className={`${className} border-primary/20 bg-gradient-to-br from-primary/5 to-secondary/50 hover:border-primary/40 transition-all duration-300`}>
      <CardHeader className="pb-3">
        <div className="flex items-start justify-between">
          <CardTitle className="flex items-center gap-2">
            <Calendar className="h-5 w-5 text-primary" />
            Daily Challenge
            <Sparkles className="h-4 w-4 text-amber-400" />
          </CardTitle>
          <Badge variant="outline" className="font-mono text-xs">
            <Clock className="h-3 w-3 mr-1" />
            {timeRemaining}
          </Badge>
        </div>
      </CardHeader>

      <CardContent className="space-y-4">
        {/* Challenge Problem */}
        <div className="space-y-2">
          <div className="flex items-center gap-2">
            <DifficultyBadge difficulty={challenge.difficulty} />
            <Badge variant="secondary" className="font-mono text-xs">
              +{challenge.xp_bonus} XP
            </Badge>
          </div>

          <h3 className="font-semibold text-lg leading-tight">
            {problemData?.title || "Loading..."}
          </h3>
          
          <p className="text-sm text-muted-foreground line-clamp-2">
            {challenge.featured_reason}
          </p>
        </div>

        {/* Stats Row */}
        <div className="flex items-center gap-4 text-sm">
          <div className="flex items-center gap-1 text-muted-foreground">
            <Users className="h-4 w-4" />
            <span className="font-mono">{participantCount}</span>
          </div>
          
          {streak && (
            <div className="flex items-center gap-1">
              <Flame className="h-4 w-4 text-orange-500" />
              <span className="font-mono font-bold">{streak.current_streak}</span>
              <span className="text-muted-foreground text-xs">day streak</span>
            </div>
          )}

          {streak && streak.longest_streak > 0 && (
            <div className="flex items-center gap-1 text-muted-foreground">
              <Trophy className="h-4 w-4" />
              <span className="font-mono text-xs">Best: {streak.longest_streak}</span>
            </div>
          )}
        </div>

        {/* Action Button */}
        {completed ? (
          <div className="flex items-center gap-2 p-3 rounded-lg bg-primary/10 border border-primary/20">
            <CheckCircle2 className="h-5 w-5 text-primary" />
            <div className="flex-1">
              <p className="text-sm font-medium text-primary">Challenge Complete!</p>
              <p className="text-xs text-muted-foreground">Come back tomorrow for a new challenge</p>
            </div>
          </div>
        ) : (
          <Link to={`/problems/${problemData?.slug || challenge.problem_id}`}>
            <Button className="w-full font-mono group" size="lg">
              Start Challenge
              <ArrowRight className="h-4 w-4 ml-2 group-hover:translate-x-1 transition-transform" />
            </Button>
          </Link>
        )}

        {/* Bonus XP Callout */}
        {!completed && (
          <div className="text-center text-xs text-muted-foreground">
            Complete today's challenge to earn{" "}
            <span className="text-primary font-bold">2x XP</span> bonus!
          </div>
        )}
      </CardContent>
    </Card>
  );
}
