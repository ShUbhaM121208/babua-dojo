import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Badge } from '@/components/ui/badge';
import { Avatar, AvatarFallback } from '@/components/ui/avatar';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { useAuth } from '@/contexts/AuthContext';
import { useToast } from '@/hooks/use-toast';
import { Users, Video, Clock, Bot, Sparkles, Target } from 'lucide-react';
import { getAvailablePeers, joinInterviewQueue, createInterviewSession, getUserInterviewProfile } from '@/lib/interviewService';
import { supabase } from '@/integrations/supabase/client';
import type { InterviewProfile } from '@/types/interview';
import { detailedProblems } from '@/data/mockData';

export default function InterviewMatching() {
  const { user } = useAuth();
  const { toast } = useToast();
  const navigate = useNavigate();
  
  const [role, setRole] = useState<string>('either');
  const [experience, setExperience] = useState<string>('intermediate');
  const [peers, setPeers] = useState<InterviewProfile[]>([]);
  const [inQueue, setInQueue] = useState(false);
  const [loading, setLoading] = useState(false);
  const [userProfile, setUserProfile] = useState<InterviewProfile | null>(null);
  const [selectedProblem, setSelectedProblem] = useState<string>('');
  const [aiDifficulty, setAiDifficulty] = useState<string>('medium');

  // Get a random sample of problems for AI practice
  const practiceProblems = Object.values(detailedProblems).slice(0, 20);

  useEffect(() => {
    if (user) {
      loadUserProfile();
      loadPeers();
    }
  }, [user]);

  useEffect(() => {
    if (!user || !inQueue) return;
    
    const channel = supabase
      .channel(`interview-queue-${user.id}`)
      .on('postgres_changes', {
        event: 'UPDATE',
        schema: 'public',
        table: 'interview_matching_queue',
        filter: `user_id=eq.${user.id}`
      }, async (payload: any) => {
        if (payload.new.matched_with) {
          toast({ title: 'Match found!', description: 'Starting interview...' });
          const session = await createInterviewSession(
            user.id,
            payload.new.matched_with,
            role === 'either' ? 'interviewee' : role
          );
          if (session) {
            navigate(`/interview/${session.id}`);
          }
        }
      })
      .subscribe();
      
    return () => {
      channel.unsubscribe();
    };
  }, [inQueue, user, role]);

  const loadUserProfile = async () => {
    if (!user) return;
    try {
      const profile = await getUserInterviewProfile(user.id);
      setUserProfile(profile);
    } catch (error) {
      console.warn('Could not load interview profile:', error);
      // Continue without profile - it's optional
    }
  };

  const loadPeers = async () => {
    if (!user) return;
    setLoading(true);
    try {
      const availablePeers = await getAvailablePeers(user.id);
      setPeers(availablePeers);
    } catch (error) {
      console.warn('Could not load peers:', error);
      setPeers([]);
    } finally {
      setLoading(false);
    }
  };

  const handleJoinQueue = async () => {
    if (!user) return;
    
    try {
      setInQueue(true);
      await joinInterviewQueue(
        user.id,
        role === 'either' ? ['interviewer', 'interviewee'] : [role],
        experience
      );
      toast({ title: 'Joined queue', description: 'Searching for interview partner...' });
    } catch (error: any) {
      toast({ title: 'Error', description: error.message, variant: 'destructive' });
      setInQueue(false);
    }
  };

  const handleRequestInterview = async (peerId: string) => {
    if (!user) return;
    
    try {
      const session = await createInterviewSession(user.id, peerId, role === 'either' ? 'interviewee' : role);
      if (session) {
        toast({ title: 'Interview started', description: 'Joining interview room...' });
        navigate(`/interview/${session.id}`);
      }
    } catch (error: any) {
      toast({ title: 'Error', description: error.message, variant: 'destructive' });
    }
  };

  const handleStartAIPractice = () => {
    if (!selectedProblem) {
      toast({ title: 'Select a problem', description: 'Please choose a problem to practice', variant: 'destructive' });
      return;
    }
    navigate(`/problem/${selectedProblem}`);
  };

  return (
    <div className="container mx-auto px-4 py-8 max-w-7xl">
      <div className="mb-8">
        <h1 className="text-3xl font-bold mb-2">Interview Preparation</h1>
        <p className="text-muted-foreground">Practice interviews with AI or connect with peers for mock interviews</p>
      </div>

      <Tabs defaultValue="ai-practice" className="space-y-6">
        <TabsList className="grid w-full grid-cols-2 max-w-md">
          <TabsTrigger value="ai-practice" className="flex items-center gap-2">
            <Bot className="h-4 w-4" />
            AI Practice
          </TabsTrigger>
          <TabsTrigger value="peer-interview" className="flex items-center gap-2">
            <Users className="h-4 w-4" />
            Peer Interview
          </TabsTrigger>
        </TabsList>

        {/* AI Practice Tab */}
        <TabsContent value="ai-practice" className="space-y-6">
          <div className="grid lg:grid-cols-3 gap-6">
            <Card className="lg:col-span-2">
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Sparkles className="h-5 w-5 text-primary" />
                  Practice with AI Interview Coach
                </CardTitle>
                <CardDescription>
                  Get real-time AI feedback on your problem-solving approach, code quality, and communication
                </CardDescription>
              </CardHeader>
              <CardContent className="space-y-4">
                <div>
                  <label className="text-sm font-medium mb-2 block">Select Problem</label>
                  <Select value={selectedProblem} onValueChange={setSelectedProblem}>
                    <SelectTrigger>
                      <SelectValue placeholder="Choose a problem to practice" />
                    </SelectTrigger>
                    <SelectContent>
                      {practiceProblems.map((problem) => (
                        <SelectItem key={problem.id} value={String(problem.id)}>
                          {problem.title} - {problem.difficulty}
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>

                <div>
                  <label className="text-sm font-medium mb-2 block">Interview Difficulty</label>
                  <Select value={aiDifficulty} onValueChange={setAiDifficulty}>
                    <SelectTrigger>
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="easy">Easy - Friendly feedback</SelectItem>
                      <SelectItem value="medium">Medium - Balanced interview</SelectItem>
                      <SelectItem value="hard">Hard - Challenging questions</SelectItem>
                    </SelectContent>
                  </Select>
                </div>

                <Button 
                  onClick={handleStartAIPractice} 
                  disabled={!selectedProblem}
                  className="w-full"
                  size="lg"
                >
                  <Bot className="mr-2 h-5 w-5" />
                  Start AI Practice Interview
                </Button>
              </CardContent>
            </Card>

            <Card className="bg-primary/5 border-primary/20">
              <CardHeader>
                <CardTitle className="text-lg">Why AI Practice?</CardTitle>
              </CardHeader>
              <CardContent className="space-y-4 text-sm">
                <div className="flex gap-3">
                  <Target className="h-5 w-5 text-primary flex-shrink-0 mt-0.5" />
                  <div>
                    <p className="font-medium mb-1">Real Interview Experience</p>
                    <p className="text-muted-foreground">Practice explaining your thought process just like in real interviews</p>
                  </div>
                </div>
                <div className="flex gap-3">
                  <Sparkles className="h-5 w-5 text-primary flex-shrink-0 mt-0.5" />
                  <div>
                    <p className="font-medium mb-1">Instant Feedback</p>
                    <p className="text-muted-foreground">Get immediate AI evaluation on communication, problem-solving, and code quality</p>
                  </div>
                </div>
                <div className="flex gap-3">
                  <Clock className="h-5 w-5 text-primary flex-shrink-0 mt-0.5" />
                  <div>
                    <p className="font-medium mb-1">Practice Anytime</p>
                    <p className="text-muted-foreground">No scheduling needed - practice whenever you want</p>
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>
        </TabsContent>

        {/* Peer Interview Tab */}
        <TabsContent value="peer-interview" className="space-y-6">
          <div className="grid lg:grid-cols-3 gap-6">
            <Card>
              <CardHeader>
                <CardTitle>Queue Settings</CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <div>
                  <label className="text-sm font-medium mb-2 block">Role</label>
                  <Select value={role} onValueChange={setRole}>
                    <SelectTrigger>
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="either">Either</SelectItem>
                      <SelectItem value="interviewer">Interviewer</SelectItem>
                      <SelectItem value="interviewee">Interviewee</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
                
                <div>
                  <label className="text-sm font-medium mb-2 block">Experience</label>
                  <Select value={experience} onValueChange={setExperience}>
                    <SelectTrigger>
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="beginner">Beginner</SelectItem>
                      <SelectItem value="intermediate">Intermediate</SelectItem>
                      <SelectItem value="advanced">Advanced</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
                
                <div className="flex items-end">
                  <Button 
                    onClick={handleJoinQueue} 
                    disabled={inQueue}
                    className="w-full"
                  >
                    {inQueue ? 'Searching...' : 'Join Queue'}
                  </Button>
                </div>
                
                {userProfile && (
                  <div className="mt-4 flex items-center gap-2">
                    <Badge variant="outline">Rating: {userProfile.overall_rating.toFixed(1)}</Badge>
                    <Badge variant="outline">{userProfile.total_interviews} interviews</Badge>
                  </div>
                )}
              </CardContent>
            </Card>
          </div>

          <div>
            <h2 className="text-xl font-semibold mb-4 flex items-center gap-2">
              <Users className="h-5 w-5" />
              Available Peers ({peers.length})
            </h2>
          
          {loading ? (
            <p className="text-muted-foreground">Loading peers...</p>
          ) : peers.length === 0 ? (
            <Card>
              <CardContent className="p-8 text-center">
                <p className="text-muted-foreground">No peers available right now. Try joining the queue!</p>
              </CardContent>
            </Card>
          ) : (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
              {peers.map((peer) => (
                <Card key={peer.id} className="hover:shadow-lg transition-shadow">
                  <CardContent className="p-6">
                    <div className="flex items-start gap-4 mb-4">
                      <Avatar>
                        <AvatarFallback>
                          {peer.user_id.substring(0, 2).toUpperCase()}
                        </AvatarFallback>
                      </Avatar>
                      <div className="flex-1 min-w-0">
                        <h3 className="font-semibold truncate">User {peer.user_id.substring(0, 8)}</h3>
                        <div className="flex items-center gap-2 text-sm text-muted-foreground">
                          <Clock className="h-3 w-3" />
                          <span>{peer.experience_level}</span>
                        </div>
                      </div>
                    </div>
                    
                    <div className="space-y-2 mb-4">
                      <div className="flex justify-between text-sm">
                        <span className="text-muted-foreground">Rating</span>
                        <span className="font-medium">{peer.overall_rating.toFixed(1)}</span>
                      </div>
                      <div className="flex justify-between text-sm">
                        <span className="text-muted-foreground">Interviews</span>
                        <span className="font-medium">{peer.total_interviews}</span>
                      </div>
                    </div>
                    
                    <div className="flex flex-wrap gap-1 mb-4">
                      {peer.preferred_topics.slice(0, 3).map((topic) => (
                        <Badge key={topic} variant="secondary" className="text-xs">
                          {topic}
                        </Badge>
                      ))}
                    </div>
                    
                    <Button 
                      className="w-full" 
                      size="sm"
                      onClick={() => handleRequestInterview(peer.user_id)}
                    >
                      <Video className="mr-2 h-4 w-4" />
                      Request Interview
                    </Button>
                  </CardContent>
                </Card>
              ))}
            </div>
          )}
        </div>
      </TabsContent>
    </Tabs>
    </div>
  );
}
