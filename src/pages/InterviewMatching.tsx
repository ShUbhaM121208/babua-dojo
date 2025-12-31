import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Badge } from '@/components/ui/badge';
import { Avatar, AvatarFallback } from '@/components/ui/avatar';
import { useAuth } from '@/contexts/AuthContext';
import { useToast } from '@/hooks/use-toast';
import { Users, Video, Clock } from 'lucide-react';
import { getAvailablePeers, joinInterviewQueue, createInterviewSession, getUserInterviewProfile } from '@/lib/interviewService';
import { supabase } from '@/integrations/supabase/client';
import type { InterviewProfile } from '@/types/interview';

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
    const profile = await getUserInterviewProfile(user.id);
    setUserProfile(profile);
  };

  const loadPeers = async () => {
    if (!user) return;
    setLoading(true);
    try {
      const availablePeers = await getAvailablePeers(user.id);
      setPeers(availablePeers);
    } catch (error) {
      console.error('Failed to load peers:', error);
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
      const session = await createInterviewSession(
        user.id,
        peerId,
        role === 'either' ? 'interviewee' : role
      );
      
      if (session) {
        toast({ title: 'Interview created!', description: 'Joining room...' });
        navigate(`/interview/${session.id}`);
      }
    } catch (error: any) {
      toast({ title: 'Error', description: error.message, variant: 'destructive' });
    }
  };

  return (
    <div className="container mx-auto p-6">
      <div className="mb-8">
        <h1 className="text-3xl font-bold mb-2">Interview Prep Matching</h1>
        <p className="text-muted-foreground">
          Find a partner to practice technical interviews
        </p>
      </div>

      <div className="grid gap-6 mb-8">
        <Card>
          <CardHeader>
            <CardTitle>Your Preferences</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="grid grid-cols-3 gap-4">
              <div>
                <label className="text-sm font-medium mb-2 block">Role</label>
                <Select value={role} onValueChange={setRole}>
                  <SelectTrigger>
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="interviewer">Interviewer</SelectItem>
                    <SelectItem value="interviewee">Interviewee</SelectItem>
                    <SelectItem value="either">Either</SelectItem>
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
    </div>
  );
}
