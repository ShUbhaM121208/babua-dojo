import { useEffect, useState, useCallback } from "react";
import { useParams, useNavigate, Link } from "react-router-dom";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Progress } from "@/components/ui/progress";
import {
  Trophy,
  Clock,
  ArrowLeft,
  CheckCircle2,
  XCircle,
  AlertCircle,
  Code,
} from "lucide-react";
import { Tournament, tournamentService, TournamentSubmission } from "@/services/tournamentService";
import { TournamentLeaderboard } from "@/components/tournaments/TournamentLeaderboard";
import { useAuth } from "@/contexts/AuthContext";
import { Skeleton } from "@/components/ui/skeleton";

interface Problem {
  id: string;
  title: string;
  difficulty: string;
  solved: boolean;
  attempts: number;
}

export default function TournamentLive() {
  const { tournamentId } = useParams<{ tournamentId: string }>();
  const navigate = useNavigate();
  const { user } = useAuth();

  const [tournament, setTournament] = useState<Tournament | null>(null);
  const [loading, setLoading] = useState(true);
  const [problems, setProblems] = useState<Problem[]>([]);
  const [submissions, setSubmissions] = useState<TournamentSubmission[]>([]);
  const [timeRemaining, setTimeRemaining] = useState("");
  const [progress, setProgress] = useState(0);

  const loadTournamentData = useCallback(async () => {
    if (!tournamentId || !user) return;

    try {
      setLoading(true);
      
      // Load tournament details
      const tournamentData = await tournamentService.getTournament(tournamentId);
      setTournament(tournamentData);

      // Check if user is registered
      const isRegistered = await tournamentService.isRegistered(tournamentId);
      if (!isRegistered) {
        navigate(`/tournaments/${tournamentId}`);
        return;
      }

      // Load user's submissions
      const userSubmissions = await tournamentService.getUserSubmissions(tournamentId);
      setSubmissions(userSubmissions);

      // Mock problems data (in real app, fetch from problems table)
      if (tournamentData && tournamentData.problem_ids) {
        const mockProblems: Problem[] = tournamentData.problem_ids.map((id, index) => ({
          id,
          title: `Problem ${String.fromCharCode(65 + index)}`,
          difficulty: tournamentData.difficulty,
          solved: userSubmissions.some(s => s.problem_id === id && s.status === 'accepted'),
          attempts: userSubmissions.filter(s => s.problem_id === id).length,
        }));
        setProblems(mockProblems);
      }
    } catch (error) {
      console.error('Failed to load tournament data:', error);
    } finally {
      setLoading(false);
    }
  }, [tournamentId, user, navigate]);

  useEffect(() => {
    if (tournamentId) {
      loadTournamentData();
    }
  }, [tournamentId, loadTournamentData]);

  const getStatusIcon = (problem: Problem) => {
    if (problem.solved) {
      return <CheckCircle2 className="h-5 w-5 text-green-500" />;
    }
    if (problem.attempts > 0) {
      return <XCircle className="h-5 w-5 text-red-500" />;
    }
    return <Code className="h-5 w-5 text-muted-foreground" />;
  };

  const getStatusBadge = (problem: Problem) => {
    if (problem.solved) {
      return <Badge className="bg-green-500">Solved</Badge>;
    }
    if (problem.attempts > 0) {
      return <Badge variant="outline" className="border-orange-500 text-orange-500">Attempted ({problem.attempts})</Badge>;
    }
    return <Badge variant="outline">Not Attempted</Badge>;
  };

  const solvedCount = problems.filter(p => p.solved).length;
  const totalProblems = problems.length;

  if (loading) {
    return (
      <div className="container mx-auto px-4 py-8 space-y-6">
        <Skeleton className="h-12 w-full" />
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          <div className="lg:col-span-2">
            <Skeleton className="h-[600px]" />
          </div>
          <Skeleton className="h-[600px]" />
        </div>
      </div>
    );
  }

  if (!tournament) {
    return (
      <div className="container mx-auto px-4 py-8">
        <Alert variant="destructive">
          <AlertCircle className="h-4 w-4" />
          <AlertDescription>Tournament not found or you're not registered</AlertDescription>
        </Alert>
      </div>
    );
  }

  if (tournament.status !== 'live') {
    return (
      <div className="container mx-auto px-4 py-8">
        <Alert>
          <AlertCircle className="h-4 w-4" />
          <AlertDescription>
            This tournament is not currently live. Please wait for it to start.
          </AlertDescription>
        </Alert>
        <Button className="mt-4" onClick={() => navigate(`/tournaments/${tournamentId}`)}>
          Back to Tournament Details
        </Button>
      </div>
    );
  }

  return (
    <div className="container mx-auto px-4 py-8 space-y-6">
      {/* Header with Timer */}
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-4">
          <Button variant="ghost" size="icon" onClick={() => navigate(`/tournaments/${tournamentId}`)}>
            <ArrowLeft className="h-5 w-5" />
          </Button>
          <div>
            <h1 className="text-2xl font-bold flex items-center gap-2">
              <Trophy className="h-6 w-6 text-yellow-500" />
              {tournament.title}
            </h1>
            <p className="text-sm text-muted-foreground">
              Solve {totalProblems} problems to win
            </p>
          </div>
        </div>

        <div className="text-right">
          <div className="flex items-center gap-2 text-2xl font-bold">
            <Clock className="h-6 w-6 text-primary" />
            {timeRemaining}
          </div>
          <p className="text-sm text-muted-foreground">Time Remaining</p>
        </div>
      </div>

      {/* Progress Bar */}
      <Card>
        <CardContent className="pt-6">
          <div className="space-y-2">
            <div className="flex justify-between text-sm">
              <span className="font-medium">Your Progress</span>
              <span className="text-muted-foreground">
                {solvedCount} / {totalProblems} solved
              </span>
            </div>
            <Progress value={(solvedCount / totalProblems) * 100} className="h-3" />
          </div>
        </CardContent>
      </Card>

      {/* Main Content */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Problems List */}
        <div className="lg:col-span-2 space-y-4">
          <Card>
            <CardHeader>
              <CardTitle>Problems</CardTitle>
              <CardDescription>
                Click on a problem to start solving
              </CardDescription>
            </CardHeader>
            <CardContent>
              <div className="space-y-3">
                {problems.map((problem, index) => (
                  <Link
                    key={problem.id}
                    to={`/problem/${problem.id}?tournament=${tournamentId}`}
                  >
                    <Card className="hover:shadow-md transition-shadow cursor-pointer">
                      <CardContent className="p-4">
                        <div className="flex items-center justify-between">
                          <div className="flex items-center gap-4">
                            {getStatusIcon(problem)}
                            <div>
                              <h3 className="font-semibold">
                                {String.fromCharCode(65 + index)}. {problem.title}
                              </h3>
                              <p className="text-sm text-muted-foreground capitalize">
                                {problem.difficulty}
                              </p>
                            </div>
                          </div>
                          <div className="flex items-center gap-3">
                            {problem.attempts > 0 && (
                              <span className="text-sm text-muted-foreground">
                                {problem.attempts} attempt{problem.attempts !== 1 ? 's' : ''}
                              </span>
                            )}
                            {getStatusBadge(problem)}
                          </div>
                        </div>
                      </CardContent>
                    </Card>
                  </Link>
                ))}
              </div>
            </CardContent>
          </Card>

          {/* Submission History */}
          <Card>
            <CardHeader>
              <CardTitle>Recent Submissions</CardTitle>
            </CardHeader>
            <CardContent>
              {submissions.length === 0 ? (
                <p className="text-center text-muted-foreground py-8">
                  No submissions yet. Start solving problems!
                </p>
              ) : (
                <div className="space-y-2">
                  {submissions.slice(0, 5).map((submission) => (
                    <div
                      key={submission.id}
                      className="flex items-center justify-between p-3 border rounded-lg"
                    >
                      <div className="flex items-center gap-3">
                        {submission.status === 'accepted' ? (
                          <CheckCircle2 className="h-4 w-4 text-green-500" />
                        ) : (
                          <XCircle className="h-4 w-4 text-red-500" />
                        )}
                        <span className="text-sm font-medium">
                          Problem {submission.problem_id.slice(0, 8)}
                        </span>
                      </div>
                      <div className="text-sm text-muted-foreground">
                        {submission.passed_count}/{submission.total_test_cases} tests
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </CardContent>
          </Card>
        </div>

        {/* Live Leaderboard */}
        <div className="lg:col-span-1">
          <TournamentLeaderboard tournamentId={tournament.id} isLive={true} limit={10} />
        </div>
      </div>
    </div>
  );
}
