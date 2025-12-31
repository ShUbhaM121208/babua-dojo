import { useState, useEffect, useRef } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { Button } from '@/components/ui/button';
import { Card, CardContent } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Textarea } from '@/components/ui/textarea';
import { useAuth } from '@/contexts/AuthContext';
import { useToast } from '@/hooks/use-toast';
import { Mic, MicOff, Video, VideoOff, PhoneOff, Timer } from 'lucide-react';
import { startInterview, endInterview, updateCodeSnapshot } from '@/lib/interviewService';
import { supabase } from '@/integrations/supabase/client';
import type { InterviewSession } from '@/types/interview';
import Editor from '@monaco-editor/react';

// Note: Daily.co integration requires VITE_DAILY_API_KEY in .env
// For now, this is a simplified version without video

export default function InterviewRoom() {
  const { sessionId } = useParams();
  const { user } = useAuth();
  const { toast } = useToast();
  const navigate = useNavigate();
  
  const [session, setSession] = useState<InterviewSession | null>(null);
  const [code, setCode] = useState('// Write your code here\n');
  const [notes, setNotes] = useState('');
  const [isMuted, setIsMuted] = useState(false);
  const [isVideoOff, setIsVideoOff] = useState(false);
  const [timeElapsed, setTimeElapsed] = useState(0);
  const codeUpdateTimeoutRef = useRef<NodeJS.Timeout>();

  useEffect(() => {
    if (!sessionId) return;
    
    loadSession();
    initializeInterview();
    
    const channel = supabase
      .channel(`interview-${sessionId}`)
      .on('postgres_changes', {
        event: 'UPDATE',
        schema: 'public',
        table: 'interview_sessions',
        filter: `id=eq.${sessionId}`
      }, () => {
        loadSession();
      })
      .subscribe();
      
    return () => {
      channel.unsubscribe();
    };
  }, [sessionId]);

  useEffect(() => {
    if (session?.status === 'active' && session.started_at) {
      const interval = setInterval(() => {
        const elapsed = Math.floor((Date.now() - new Date(session.started_at!).getTime()) / 1000);
        setTimeElapsed(elapsed);
      }, 1000);
      
      return () => clearInterval(interval);
    }
  }, [session]);

  const loadSession = async () => {
    if (!sessionId) return;
    
    const { data } = await supabase
      .from('interview_sessions')
      .select('*')
      .eq('id', sessionId)
      .single();
      
    if (data) {
      setSession(data);
      if (data.code_snapshot) {
        setCode(data.code_snapshot);
      }
    }
  };

  const initializeInterview = async () => {
    if (!sessionId || !user) return;
    
    try {
      await startInterview(sessionId);
    } catch (error) {
      console.error('Failed to start interview:', error);
    }
  };

  const handleCodeChange = (value: string | undefined) => {
    const newCode = value || '';
    setCode(newCode);
    
    if (codeUpdateTimeoutRef.current) {
      clearTimeout(codeUpdateTimeoutRef.current);
    }
    
    codeUpdateTimeoutRef.current = setTimeout(() => {
      if (sessionId) {
        updateCodeSnapshot(sessionId, newCode);
      }
    }, 500);
  };

  const handleEndInterview = async () => {
    if (!sessionId) return;
    
    try {
      await endInterview(sessionId);
      toast({ title: 'Interview ended', description: 'Redirecting to feedback...' });
      setTimeout(() => navigate('/interview-prep'), 2000);
    } catch (error: any) {
      toast({ title: 'Error', description: error.message, variant: 'destructive' });
    }
  };

  const formatTime = (seconds: number) => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins}:${secs.toString().padStart(2, '0')}`;
  };

  if (!session) {
    return (
      <div className="flex items-center justify-center h-screen">
        <p>Loading interview room...</p>
      </div>
    );
  }

  const isInterviewer = session.interviewer_id === user?.id;

  return (
    <div className="h-screen flex flex-col">
      <div className="border-b p-4 flex items-center justify-between bg-background">
        <div className="flex items-center gap-4">
          <h1 className="text-xl font-bold">Interview Session</h1>
          <Badge variant={isInterviewer ? "default" : "secondary"}>
            {isInterviewer ? "Interviewer" : "Interviewee"}
          </Badge>
          <Badge variant="outline">{session.session_code}</Badge>
        </div>
        
        <div className="flex items-center gap-4">
          {session.status === 'active' && (
            <div className="flex items-center gap-2">
              <Timer className="h-4 w-4" />
              <span className="font-mono font-bold">{formatTime(timeElapsed)}</span>
            </div>
          )}
          
          <div className="flex items-center gap-2">
            <Button
              variant={isMuted ? "destructive" : "outline"}
              size="icon"
              onClick={() => setIsMuted(!isMuted)}
            >
              {isMuted ? <MicOff className="h-4 w-4" /> : <Mic className="h-4 w-4" />}
            </Button>
            
            <Button
              variant={isVideoOff ? "destructive" : "outline"}
              size="icon"
              onClick={() => setIsVideoOff(!isVideoOff)}
            >
              {isVideoOff ? <VideoOff className="h-4 w-4" /> : <Video className="h-4 w-4" />}
            </Button>
            
            <Button variant="destructive" onClick={handleEndInterview}>
              <PhoneOff className="mr-2 h-4 w-4" />
              End Interview
            </Button>
          </div>
        </div>
      </div>

      <div className="flex-1 flex overflow-hidden">
        <div className="flex-1 flex flex-col">
          <div className="h-48 bg-muted border-b flex items-center justify-center">
            <p className="text-muted-foreground">
              Video call placeholder - Daily.co SDK required (add VITE_DAILY_API_KEY to .env)
            </p>
          </div>
          
          <div className="flex-1 grid grid-cols-2 gap-4 p-4">
            <Card>
              <CardContent className="p-4 h-full flex flex-col">
                <h3 className="font-semibold mb-2">Code Editor</h3>
                <div className="flex-1 border rounded">
                  <Editor
                    height="100%"
                    defaultLanguage="javascript"
                    value={code}
                    onChange={handleCodeChange}
                    theme="vs-dark"
                    options={{
                      minimap: { enabled: false },
                      fontSize: 13,
                      wordWrap: 'on'
                    }}
                  />
                </div>
              </CardContent>
            </Card>
            
            <Card>
              <CardContent className="p-4 h-full flex flex-col">
                <h3 className="font-semibold mb-2">Problem & Notes</h3>
                <div className="flex-1 space-y-4">
                  <div>
                    <h4 className="text-sm font-medium mb-2">Problem Description</h4>
                    <p className="text-sm text-muted-foreground">
                      Sample problem will be displayed here
                    </p>
                  </div>
                  
                  <div className="flex-1">
                    <h4 className="text-sm font-medium mb-2">Notes</h4>
                    <Textarea
                      placeholder="Take notes during the interview..."
                      value={notes}
                      onChange={(e) => setNotes(e.target.value)}
                      className="h-32"
                    />
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>
        </div>
      </div>
    </div>
  );
}
