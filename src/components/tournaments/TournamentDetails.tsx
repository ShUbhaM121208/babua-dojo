import { useEffect, useState, useCallback } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Alert, AlertDescription } from "@/components/ui/alert";
import {
  Calendar,
  Clock,
  Trophy,
  Users,
  Award,
  FileText,
  ArrowLeft,
  AlertCircle,
  CheckCircle2,
} from "lucide-react";
import { Tournament, tournamentService } from "@/services/tournamentService";
import { TournamentLeaderboard } from "./TournamentLeaderboard";
import { RegistrationModal } from "./RegistrationModal";
import { useAuth } from "@/contexts/AuthContext";
import { format, formatDistanceToNow } from "date-fns";
import { Skeleton } from "@/components/ui/skeleton";

export function TournamentDetails() {
  const { tournamentId } = useParams<{ tournamentId: string }>();
  const navigate = useNavigate();
  const { user } = useAuth();

  const [tournament, setTournament] = useState<Tournament | null>(null);
  const [loading, setLoading] = useState(true);
  const [isRegistered, setIsRegistered] = useState(false);
  const [participantCount, setParticipantCount] = useState(0);
  const [showRegisterModal, setShowRegisterModal] = useState(false);
  const [timeUntilStart, setTimeUntilStart] = useState<string>("");
  const [timeUntilEnd, setTimeUntilEnd] = useState<string>("");

  const loadTournamentData = useCallback(async () => {
    if (!tournamentId) return;

    try {
      setLoading(true);
      const data = await tournamentService.getTournament(tournamentId);
      setTournament(data);

      const count = await tournamentService.getParticipantCount(tournamentId);
      setParticipantCount(count);

      if (user) {
        const registered = await tournamentService.isRegistered(tournamentId);
        setIsRegistered(registered);
      }
    } catch (error) {
      console.error('Failed to load tournament:', error);
    } finally {
      setLoading(false);
    }
  }, [tournamentId, user]);

  useEffect(() => {
    if (tournamentId) {
      loadTournamentData();
    }
  }, [tournamentId, loadTournamentData]);

  const handleRegisterSuccess = () => {
    setIsRegistered(true);
    setParticipantCount(prev => prev + 1);
  };

  const handleWithdraw = async () => {
    if (!tournamentId) return;

    try {
      const success = await tournamentService.withdrawFromTournament(tournamentId);
      if (success) {
        setIsRegistered(false);
        setParticipantCount(prev => Math.max(0, prev - 1));
      } else {
        alert('Failed to withdraw from tournament');
      }
    } catch (error) {
      console.error('Failed to withdraw:', error);
      alert('Failed to withdraw from tournament');
    }
  };

  const handleEnterTournament = () => {
    navigate(`/tournaments/${tournamentId}/live`);
  };

  if (loading) {
    return (
      <div className="container mx-auto px-4 py-8 space-y-6">
        <Skeleton className="h-12 w-48" />
        <Skeleton className="h-64 w-full" />
        <Skeleton className="h-96 w-full" />
      </div>
    );
  }

  if (!tournament) {
    return (
      <div className="container mx-auto px-4 py-8">
        <Alert variant="destructive">
          <AlertCircle className="h-4 w-4" />
          <AlertDescription>Tournament not found</AlertDescription>
        </Alert>
      </div>
    );
  }

  const formatDateTime = (date: string) => {
    return format(new Date(date), "MMMM dd, yyyy 'at' hh:mm a");
  };

  const getDuration = () => {
    const start = new Date(tournament.start_time);
    const end = new Date(tournament.end_time);
    const hours = Math.floor((end.getTime() - start.getTime()) / (1000 * 60 * 60));
    return `${hours} hour${hours !== 1 ? 's' : ''}`;
  };

  const getStatusBadge = () => {
    switch (tournament.status) {
      case 'upcoming':
        return <Badge className="bg-blue-500">Upcoming</Badge>;
      case 'live':
        return <Badge className="bg-green-500 animate-pulse">Live Now</Badge>;
      case 'completed':
        return <Badge className="bg-gray-500">Completed</Badge>;
    }
  };

  const canRegister = tournament.status === 'upcoming' && 
    (!tournament.max_participants || participantCount < tournament.max_participants);

  const canWithdraw = tournament.status === 'upcoming' && isRegistered;

  return (
    <div className="container mx-auto px-4 py-8 space-y-6">
      {/* Header */}
      <div className="flex items-center gap-4">
        <Button variant="ghost" size="icon" onClick={() => navigate('/tournaments')}>
          <ArrowLeft className="h-5 w-5" />
        </Button>
        <div className="flex-1">
          <div className="flex items-center gap-3 mb-2">
            <h1 className="text-3xl font-bold">{tournament.title}</h1>
            {getStatusBadge()}
            {tournament.is_rated && <Award className="h-6 w-6 text-yellow-500" />}
          </div>
          <p className="text-muted-foreground">{tournament.description}</p>
        </div>
      </div>

      {/* Status Alert */}
      {tournament.status === 'upcoming' && timeUntilStart && (
        <Alert className="border-blue-500 bg-blue-500/10">
          <Clock className="h-4 w-4 text-blue-500" />
          <AlertDescription>
            Tournament starts <strong>{timeUntilStart}</strong>
          </AlertDescription>
        </Alert>
      )}

      {tournament.status === 'live' && timeUntilEnd && (
        <Alert className="border-green-500 bg-green-500/10">
          <Trophy className="h-4 w-4 text-green-500" />
          <AlertDescription>
            Tournament is live! Ends <strong>{timeUntilEnd}</strong>
          </AlertDescription>
        </Alert>
      )}

      {isRegistered && tournament.status === 'upcoming' && (
        <Alert className="border-green-500 bg-green-500/10">
          <CheckCircle2 className="h-4 w-4 text-green-500" />
          <AlertDescription>
            You are registered for this tournament. We'll notify you when it starts!
          </AlertDescription>
        </Alert>
      )}

      {/* Main Content */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Left Column - Details */}
        <div className="lg:col-span-2 space-y-6">
          <Card>
            <CardHeader>
              <CardTitle>Tournament Details</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="grid grid-cols-2 gap-4">
                <div className="flex items-start gap-3">
                  <Calendar className="h-5 w-5 text-primary mt-0.5" />
                  <div>
                    <p className="text-sm font-medium">Start Time</p>
                    <p className="text-sm text-muted-foreground">{formatDateTime(tournament.start_time)}</p>
                  </div>
                </div>

                <div className="flex items-start gap-3">
                  <Clock className="h-5 w-5 text-primary mt-0.5" />
                  <div>
                    <p className="text-sm font-medium">Duration</p>
                    <p className="text-sm text-muted-foreground">{getDuration()}</p>
                  </div>
                </div>

                <div className="flex items-start gap-3">
                  <Users className="h-5 w-5 text-primary mt-0.5" />
                  <div>
                    <p className="text-sm font-medium">Participants</p>
                    <p className="text-sm text-muted-foreground">
                      {participantCount}
                      {tournament.max_participants && ` / ${tournament.max_participants}`}
                    </p>
                  </div>
                </div>

                <div className="flex items-start gap-3">
                  <FileText className="h-5 w-5 text-primary mt-0.5" />
                  <div>
                    <p className="text-sm font-medium">Difficulty</p>
                    <p className="text-sm text-muted-foreground capitalize">{tournament.difficulty}</p>
                  </div>
                </div>
              </div>

              {tournament.prize_pool && tournament.prize_pool > 0 && (
                <div className="p-4 bg-gradient-to-r from-yellow-500/10 to-orange-500/10 rounded-lg border-2 border-yellow-500/30">
                  <div className="flex items-center gap-3">
                    <Trophy className="h-8 w-8 text-yellow-500" />
                    <div>
                      <p className="text-sm text-muted-foreground">Prize Pool</p>
                      <p className="text-2xl font-bold text-yellow-500">
                        {new Intl.NumberFormat('en-IN', {
                          style: 'currency',
                          currency: 'INR',
                          maximumFractionDigits: 0
                        }).format(tournament.prize_pool)}
                      </p>
                    </div>
                  </div>
                </div>
              )}

              {tournament.rules && (
                <div>
                  <h4 className="font-semibold mb-2">Rules</h4>
                  <p className="text-sm text-muted-foreground whitespace-pre-line">{tournament.rules}</p>
                </div>
              )}
            </CardContent>
          </Card>

          {/* Leaderboard Tab */}
          <Tabs defaultValue="leaderboard" className="w-full">
            <TabsList className="grid w-full grid-cols-2">
              <TabsTrigger value="leaderboard">Leaderboard</TabsTrigger>
              <TabsTrigger value="problems">Problems</TabsTrigger>
            </TabsList>

            <TabsContent value="leaderboard" className="mt-6">
              <TournamentLeaderboard
                tournamentId={tournament.id}
                isLive={tournament.status === 'live'}
              />
            </TabsContent>

            <TabsContent value="problems" className="mt-6">
              <Card>
                <CardHeader>
                  <CardTitle>Problems</CardTitle>
                  <CardDescription>
                    {tournament.problem_ids?.length || 0} problems to solve
                  </CardDescription>
                </CardHeader>
                <CardContent>
                  {tournament.problem_ids && tournament.problem_ids.length > 0 ? (
                    <div className="text-sm text-muted-foreground">
                      Problems will be revealed when the tournament starts.
                    </div>
                  ) : (
                    <div className="text-sm text-muted-foreground">
                      No problems configured yet.
                    </div>
                  )}
                </CardContent>
              </Card>
            </TabsContent>
          </Tabs>
        </div>

        {/* Right Column - Actions */}
        <div className="space-y-4">
          {tournament.status === 'live' && isRegistered && (
            <Card>
              <CardContent className="pt-6">
                <Button className="w-full" size="lg" onClick={handleEnterTournament}>
                  Enter Tournament
                </Button>
              </CardContent>
            </Card>
          )}

          {tournament.status === 'upcoming' && (
            <Card>
              <CardHeader>
                <CardTitle className="text-lg">Registration</CardTitle>
              </CardHeader>
              <CardContent className="space-y-3">
                {!user ? (
                  <Button className="w-full" onClick={() => navigate('/auth')}>
                    Login to Register
                  </Button>
                ) : isRegistered ? (
                  <>
                    <Alert className="border-green-500 bg-green-500/10">
                      <CheckCircle2 className="h-4 w-4 text-green-500" />
                      <AlertDescription className="text-sm">You're registered!</AlertDescription>
                    </Alert>
                    {canWithdraw && (
                      <Button variant="outline" className="w-full" onClick={handleWithdraw}>
                        Withdraw Registration
                      </Button>
                    )}
                  </>
                ) : canRegister ? (
                  <Button className="w-full" onClick={() => setShowRegisterModal(true)}>
                    Register Now
                  </Button>
                ) : (
                  <Alert>
                    <AlertCircle className="h-4 w-4" />
                    <AlertDescription className="text-sm">
                      Registration is full
                    </AlertDescription>
                  </Alert>
                )}
              </CardContent>
            </Card>
          )}
        </div>
      </div>

      {/* Registration Modal */}
      {tournament && (
        <RegistrationModal
          tournament={tournament}
          isOpen={showRegisterModal}
          onClose={() => setShowRegisterModal(false)}
          onSuccess={handleRegisterSuccess}
        />
      )}
    </div>
  );
}
