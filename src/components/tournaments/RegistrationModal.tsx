import { useState } from "react";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Checkbox } from "@/components/ui/checkbox";
import { Label } from "@/components/ui/label";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { AlertCircle, CheckCircle2, Trophy, Clock, Award, Users } from "lucide-react";
import { Tournament, tournamentService } from "@/services/tournamentService";
import { useAuth } from "@/contexts/AuthContext";
import { format } from "date-fns";

interface RegistrationModalProps {
  tournament: Tournament;
  isOpen: boolean;
  onClose: () => void;
  onSuccess: () => void;
}

export function RegistrationModal({
  tournament,
  isOpen,
  onClose,
  onSuccess,
}: RegistrationModalProps) {
  const { user } = useAuth();
  const [acceptTerms, setAcceptTerms] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState(false);

  const handleRegister = async () => {
    if (!user) {
      setError("You must be logged in to register");
      return;
    }

    if (!acceptTerms) {
      setError("Please accept the terms and conditions");
      return;
    }

    setLoading(true);
    setError(null);

    try {
      const result = await tournamentService.registerForTournament(tournament.id);
      if (!result.success) {
        setError(result.message);
        return;
      }
      setSuccess(true);
      setTimeout(() => {
        onSuccess();
        handleClose();
      }, 2000);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Failed to register for tournament");
    } finally {
      setLoading(false);
    }
  };

  const handleClose = () => {
    setAcceptTerms(false);
    setError(null);
    setSuccess(false);
    onClose();
  };

  const formatDateTime = (date: string) => {
    return format(new Date(date), "MMMM dd, yyyy 'at' hh:mm a");
  };

  return (
    <Dialog open={isOpen} onOpenChange={handleClose}>
      <DialogContent className="max-w-2xl">
        <DialogHeader>
          <DialogTitle className="text-2xl flex items-center gap-2">
            <Trophy className="h-6 w-6 text-yellow-500" />
            Register for Tournament
          </DialogTitle>
          <DialogDescription>
            {tournament.title}
          </DialogDescription>
        </DialogHeader>

        {success ? (
          <div className="py-8">
            <Alert className="border-green-500 bg-green-500/10">
              <CheckCircle2 className="h-5 w-5 text-green-500" />
              <AlertDescription className="text-base">
                Successfully registered! You'll receive notifications about the tournament.
              </AlertDescription>
            </Alert>
          </div>
        ) : (
          <>
            {/* Tournament Info */}
            <div className="space-y-4 py-4">
              <div className="grid grid-cols-2 gap-4">
                <div className="flex items-start gap-3 p-3 bg-accent rounded-lg">
                  <Clock className="h-5 w-5 text-primary mt-0.5" />
                  <div>
                    <p className="text-sm font-medium">Start Time</p>
                    <p className="text-xs text-muted-foreground mt-1">
                      {formatDateTime(tournament.start_time)}
                    </p>
                  </div>
                </div>

                <div className="flex items-start gap-3 p-3 bg-accent rounded-lg">
                  <Users className="h-5 w-5 text-primary mt-0.5" />
                  <div>
                    <p className="text-sm font-medium">Participants</p>
                    <p className="text-xs text-muted-foreground mt-1">
                      {tournament.max_participants 
                        ? `Limited to ${tournament.max_participants} users`
                        : 'Unlimited'}
                    </p>
                  </div>
                </div>
              </div>

              {tournament.is_rated && (
                <Alert className="border-yellow-500 bg-yellow-500/10">
                  <Award className="h-4 w-4 text-yellow-500" />
                  <AlertDescription>
                    This is a <strong>rated tournament</strong>. Your performance will affect your rating.
                  </AlertDescription>
                </Alert>
              )}

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

              {/* Rules and Terms */}
              <div className="space-y-3">
                <h4 className="font-semibold">Tournament Rules</h4>
                <ul className="space-y-2 text-sm text-muted-foreground list-disc list-inside">
                  <li>Solve problems within the tournament duration</li>
                  <li>Each wrong submission adds a 20-minute penalty</li>
                  <li>Ranking based on: problems solved (more is better), then total time + penalties (less is better)</li>
                  <li>No plagiarism or unfair practices allowed</li>
                  <li>You can view your submissions but not others' during the contest</li>
                  {tournament.is_rated && (
                    <li>Rating changes will be applied after the tournament ends</li>
                  )}
                </ul>
              </div>

              {/* Accept Terms */}
              <div className="flex items-start space-x-3 p-4 border rounded-lg">
                <Checkbox
                  id="terms"
                  checked={acceptTerms}
                  onCheckedChange={(checked) => setAcceptTerms(checked as boolean)}
                />
                <Label
                  htmlFor="terms"
                  className="text-sm leading-relaxed cursor-pointer"
                >
                  I have read and agree to follow the tournament rules and code of conduct. 
                  I understand that violating these rules may result in disqualification and 
                  potential ban from future tournaments.
                </Label>
              </div>

              {error && (
                <Alert variant="destructive">
                  <AlertCircle className="h-4 w-4" />
                  <AlertDescription>{error}</AlertDescription>
                </Alert>
              )}
            </div>

            <DialogFooter>
              <Button variant="outline" onClick={handleClose} disabled={loading}>
                Cancel
              </Button>
              <Button
                onClick={handleRegister}
                disabled={!acceptTerms || loading}
              >
                {loading ? "Registering..." : "Register Now"}
              </Button>
            </DialogFooter>
          </>
        )}
      </DialogContent>
    </Dialog>
  );
}
