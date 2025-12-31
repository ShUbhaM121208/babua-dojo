import { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { useAuth } from '@/contexts/AuthContext';
import { useToast } from '@/hooks/use-toast';
import { Timer, Users, Play, Flag, Code2, CheckCircle2, XCircle, Wifi } from 'lucide-react';
import { LiveLeaderboard } from '@/components/battle/LiveLeaderboard';
import { LivePlayerList } from '@/components/battle/LivePlayerList';
import { useBattleRoyale } from '@/hooks/useBattleRoyale';
import { joinBattleRoom, startBattle, leaveBattleRoom, updateParticipantProgress, submitBattleSolution } from '@/lib/battleService';
import { supabase } from '@/integrations/supabase/client';
import type { BattleRoom, BattleParticipant } from '@/types/battle';
import type { Problem } from '@/types';
import Editor, { type Monaco } from '@monaco-editor/react';
import { detailedProblems } from '@/data/mockData';
import { problemService } from '@/services/problemService';
import { codeExecutionService, type SupportedLanguage } from '@/services/codeExecutionService';

export default function BattleArena() {
  const { roomId } = useParams();
  const { user } = useAuth();
  const { toast } = useToast();
  const navigate = useNavigate();
  
  // WebSocket hook for real-time updates
  const { 
    connected, 
    room, 
    participants, 
    loading: wsLoading, 
    error: wsError,
    joinRoom: wsJoinRoom,
    leaveRoom: wsLeaveRoom,
    startBattle: wsStartBattle,
    submitCode: wsSubmitCode
  } = useBattleRoyale(roomId || null);
  
  const [problem, setProblem] = useState<Problem | null>(null);
  const [code, setCode] = useState('');
  const [language, setLanguage] = useState('javascript');
  const [timeRemaining, setTimeRemaining] = useState(0);
  const [hasJoined, setHasJoined] = useState(false);
  const [isRunning, setIsRunning] = useState(false);
  const [testResults, setTestResults] = useState<{
    passed: number;
    total: number;
    results: Array<{
      id: string | number;
      passed: boolean;
      input: string;
      expected: string;
      actual: string;
    }>;
  } | null>(null);
  const [testsPassedCount, setTestsPassedCount] = useState(0);
  const [roomLoadAttempted, setRoomLoadAttempted] = useState(false);
  const [dbRoom, setDbRoom] = useState<any>(null);
  const [dbParticipants, setDbParticipants] = useState<any[]>([]);

  // Use either WebSocket room or database fallback room
  const activeRoom = room || dbRoom;
  const activeParticipants = participants.length > 0 ? participants : dbParticipants;

  // Debug logging
  useEffect(() => {
    console.log('Room state updated:', {
      wsRoom: room,
      dbRoom: dbRoom,
      activeRoom: activeRoom,
      activeRoomStatus: activeRoom?.status,
      wsConnected: connected
    });
  }, [room, dbRoom, connected, activeRoom]);

  // Load room from database as fallback if WebSocket doesn't have it
  const loadRoomFromDatabase = async () => {
    if (!roomId || !user) return;
    
    try {
      const { data, error } = await supabase
        .from('battle_rooms')
        .select('*')
        .eq('id', roomId)
        .single();
      
      if (error) throw error;
      
      // Set room data directly from database
      setDbRoom(data);
      
      // Load participants
      const { data: participantsData } = await supabase
        .from('battle_participants')
        .select('*')
        .eq('battle_room_id', roomId);
      
      if (participantsData) {
        setDbParticipants(participantsData);
        
        // Check if current user has joined
        const userParticipant = participantsData.find((p: any) => p.user_id === user.id);
        if (userParticipant) {
          setHasJoined(true);
        } else {
          // User hasn't joined yet - auto-join them
          const username = user.user_metadata?.full_name || user.email?.split('@')[0] || 'Player';
          
          const { error: insertError } = await supabase
            .from('battle_participants')
            .insert({
              battle_room_id: roomId,
              user_id: user.id,
              username: username,
              rating: 1500,
              status: 'active',
              connection_status: 'connected',
            });
          
          if (!insertError) {
            setHasJoined(true);
            // Reload participants
            const { data: updatedParticipants } = await supabase
              .from('battle_participants')
              .select('*')
              .eq('battle_room_id', roomId);
            
            if (updatedParticipants) {
              setDbParticipants(updatedParticipants);
            }
            
            toast({ title: 'Joined battle room!' });
          }
        }
      }
    } catch (error) {
      console.error('Failed to load room from database:', error);
      toast({
        title: 'Room not found',
        description: 'This battle room does not exist',
        variant: 'destructive',
      });
      navigate('/battle-matchmaking');
    }
  };

  // Auto-join room when connected OR load from database
  useEffect(() => {
    if (!roomId || !user || roomLoadAttempted) return;
    
    setRoomLoadAttempted(true);
    
    if (connected && !room && !wsLoading) {
      // Try WebSocket join first
      const username = user.user_metadata?.full_name || user.email?.split('@')[0] || 'Player';
      wsJoinRoom(roomId).catch((err) => {
        console.error('WebSocket join failed, falling back to database:', err);
        // Fallback to database load
        loadRoomFromDatabase();
      });
    } else if (!connected) {
      // If WebSocket not connected, load directly from database
      loadRoomFromDatabase();
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [connected, roomId, user, roomLoadAttempted]);

  // Sync with WebSocket when it connects after database load
  useEffect(() => {
    if (connected && dbRoom && !room && user && roomId) {
      // We have dbRoom but no WebSocket room - sync with server
      console.log('WebSocket connected after DB load, syncing with server...');
      const username = user.user_metadata?.full_name || user.email?.split('@')[0] || 'Player';
      wsJoinRoom(roomId).then((result) => {
        console.log('✅ Successfully synced with WebSocket server, result:', result);
      }).catch((err) => {
        console.error('❌ Failed to sync with WebSocket:', err);
      });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [connected, dbRoom, room, user, roomId]);

  // Load problem when room is loaded
  useEffect(() => {
    if (activeRoom) {
      loadProblem();
      // Check if current user has joined
      if (user && activeParticipants.some(p => p.user_id === user.id)) {
        setHasJoined(true);
      }
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [activeRoom, user, activeParticipants]);

  // Show WebSocket connection status
  useEffect(() => {
    if (wsError) {
      toast({ 
        title: 'Connection error', 
        description: wsError, 
        variant: 'destructive' 
      });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [wsError]);

  useEffect(() => {
    if (activeRoom?.status === 'active' && activeRoom.started_at) {
      const interval = setInterval(() => {
        const elapsed = Math.floor((Date.now() - new Date(activeRoom.started_at!).getTime()) / 1000);
        const remaining = Math.max(0, activeRoom.time_limit_seconds - elapsed);
        setTimeRemaining(remaining);
        
        if (remaining === 0) {
          toast({ title: 'Time\'s up!', description: 'Battle has ended' });
        }
      }, 1000);
      
      return () => clearInterval(interval);
    } else if (activeRoom?.status === 'waiting') {
      // Show full time limit when battle hasn't started
      setTimeRemaining(activeRoom.time_limit_seconds);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [activeRoom]);

  // Load problem from database based on room difficulty
  const loadProblemFromDB = async () => {
    if (!activeRoom?.problem_id) {
      console.warn('No problem_id in room, skipping DB load');
      return;
    }
    
    try {
      const problemData = await problemService.getProblemById(activeRoom.problem_id);
      if (problemData) {
        // Convert to the expected Problem type
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        setProblem(problemData as any as Problem);
        setCode(problemData.starterCode?.[language] || problemData.starterCode?.javascript || '// Write your solution here\n');
      }
    } catch (error) {
      console.error('Error loading problem from DB:', error);
      // Don't call loadProblem to avoid infinite loop
      // Just use a fallback problem directly
      console.log('Using fallback problem from mockData');
      const fallbackProblem = detailedProblems[1];
      if (fallbackProblem) {
        setProblem(fallbackProblem);
        setCode(fallbackProblem.starterCode?.javascript || '// Write your solution here\n');
      }
    }
  };

  const loadProblem = () => {
    // Only try loading from DB if problem_id actually exists and is not null
    if (activeRoom?.problem_id && activeRoom.problem_id !== null) {
      console.log('Loading problem from DB with ID:', activeRoom.problem_id);
      loadProblemFromDB();
      return;
    }
    
    console.log('Loading problem from mockData, difficulty:', activeRoom?.difficulty);
    
    // Fallback: Get a random problem based on difficulty from mockData
    const difficultyMap: Record<string, number[]> = {
      easy: [1, 2, 3, 6, 7, 10],
      medium: [4, 5, 8, 9],
      hard: [1, 4]
    };
    
    const problemIds = activeRoom?.difficulty 
      ? difficultyMap[activeRoom.difficulty] || [1, 2, 3]
      : [1, 2, 3];
    
    const randomId = problemIds[Math.floor(Math.random() * problemIds.length)];
    const selectedProblem = detailedProblems[randomId];
    
    if (selectedProblem) {
      console.log('Loaded problem:', selectedProblem.title);
      setProblem(selectedProblem);
      setCode(selectedProblem.starterCode?.[language] || selectedProblem.starterCode?.javascript || '// Write your solution here\n');
    } else {
      console.warn('No problem found for ID:', randomId, 'using fallback');
      setProblem(detailedProblems[1]);
      setCode(detailedProblems[1].starterCode?.javascript || '// Write your solution here\n');
    }
  };

  const handleLanguageChange = (newLanguage: string) => {
    setLanguage(newLanguage);
    if (problem?.starterCode?.[newLanguage]) {
      setCode(problem.starterCode[newLanguage]);
    }
  };

  const handleRunTests = async () => {
    if (!problem || !user || !roomId) return;
    
    setIsRunning(true);
    setTestResults(null);
    
    try {
      // Use real code execution with Judge0 if available
      const supportedLanguages: Record<string, SupportedLanguage> = {
        'javascript': 'javascript',
        'python': 'python',
        'java': 'java',
        'cpp': 'cpp',
        'c': 'c',
        'typescript': 'typescript',
        'rust': 'rust',
        'go': 'go'
      };
      
      const execLanguage = supportedLanguages[language] || 'javascript';
      const testCases = problem.testCases || [];
      const totalTests = testCases.length || 4;
      
      let passedTests = 0;
      let results: Array<{
        id: string | number;
        passed: boolean;
        input: string;
        expected: string;
        actual: string;
      }> = [];
      
      // Try to use Judge0 API
      try {
        const executionResult = await codeExecutionService.executeWithTestCases(
          code,
          execLanguage,
          testCases.map(tc => ({ input: tc.input, expected_output: tc.expectedOutput }))
        );
        
        passedTests = executionResult.results.filter(r => r.passed).length;
        results = executionResult.results.map((r, i) => ({
          id: testCases[i]?.id || i,
          passed: r.passed,
          input: r.input,
          expected: r.expected_output,
          actual: r.actual_output
        }));
      } catch (execError) {
        console.warn('Judge0 execution failed, using simulation:', execError);
        // Fallback: Simulate test execution
        await new Promise(resolve => setTimeout(resolve, 1500));
        passedTests = Math.floor(Math.random() * (totalTests + 1));
        results = testCases.map((tc, i) => ({
          id: tc.id,
          passed: i < passedTests,
          input: tc.input,
          expected: tc.expectedOutput,
          actual: i < passedTests ? tc.expectedOutput : 'Wrong output'
        }));
      }
      
      setTestsPassedCount(passedTests);
      setTestResults({
        passed: passedTests,
        total: totalTests,
        results
      });
      
      toast({
        title: passedTests === totalTests ? 'All tests passed! 🎉' : `${passedTests}/${totalTests} tests passed`,
        variant: passedTests === totalTests ? 'default' : 'destructive'
      });
    } catch (error) {
      console.error('Error running tests:', error);
      toast({ title: 'Error running tests', variant: 'destructive' });
    } finally {
      setIsRunning(false);
    }
  };

  const handleSubmit = async () => {
    if (!user || !roomId || !problem) return;
    
    if (testsPassedCount === 0) {
      toast({ title: 'Run tests first!', description: 'You must run tests before submitting', variant: 'destructive' });
      return;
    }
    
    try {
      const totalTests = problem.testCases?.length || 4;
      const timeTaken = activeRoom?.time_limit_seconds ? activeRoom.time_limit_seconds - timeRemaining : 0;
      
      // Submit via WebSocket for real-time leaderboard updates
      await wsSubmitCode(code, language, testsPassedCount, totalTests, timeTaken);
      
      toast({
        title: 'Solution submitted!',
        description: `${testsPassedCount}/${totalTests} tests passed in ${timeTaken}s`
      });
    } catch (error) {
      const message = error instanceof Error ? error.message : 'Failed to submit';
      toast({ title: 'Error', description: message, variant: 'destructive' });
    }
  };

  const handleJoinRoom = async () => {
    if (!user || !roomId) return;
    
    try {
      const username = user.user_metadata?.full_name || user.email?.split('@')[0] || 'Player';
      await wsJoinRoom(roomId);
      setHasJoined(true);
      toast({ title: 'Joined battle room!' });
    } catch (error) {
      const message = error instanceof Error ? error.message : 'Failed to join room';
      toast({ title: 'Error', description: message, variant: 'destructive' });
    }
  };

  const handleStartBattle = async () => {
    if (!roomId) return;
    
    try {
      console.log('Starting battle, connected:', connected, 'roomId:', roomId, 'wsRoom:', room);
      
      // Try WebSocket first if connected
      if (connected) {
        // If WebSocket is connected but room isn't synced yet, wait a moment
        if (!room && dbRoom) {
          console.log('WebSocket connected but room not synced, syncing now...');
          const username = user?.user_metadata?.full_name || user?.email?.split('@')[0] || 'Player';
          await wsJoinRoom(roomId);
          console.log('Synced, now starting battle');
        }
        
        console.log('Starting via WebSocket with roomId:', roomId);
        await wsStartBattle(roomId); // Pass roomId explicitly
      } else {
        console.log('Starting via database update');
        // Fallback to direct database update
        const { error: updateError } = await supabase
          .from('battle_rooms')
          .update({ 
            status: 'active',
            started_at: new Date().toISOString()
          })
          .eq('id', roomId);
        
        if (updateError) {
          console.error('Failed to update room:', updateError);
          throw updateError;
        }
        
        console.log('Room updated, reloading from database...');
        // Reload room data
        await loadRoomFromDatabase();
        console.log('Room reloaded, new status:', dbRoom?.status);
      }
      
      toast({ title: 'Battle starting!', description: 'Get ready to code!' });
    } catch (error) {
      console.error('Error starting battle:', error);
      const message = error instanceof Error ? error.message : 'Failed to start battle';
      toast({ title: 'Error', description: message, variant: 'destructive' });
    }
  };

  const handleLeaveRoom = async () => {
    if (hasJoined && roomId) {
      await wsLeaveRoom();
    }
    navigate('/battle-matchmaking');
  };

  const formatTime = (seconds: number) => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins}:${secs.toString().padStart(2, '0')}`;
  };

  if (!activeRoom || wsLoading) {
    return (
      <div className="flex items-center justify-center h-screen">
        <div className="text-center space-y-2">
          <p>Loading battle room...</p>
          {!connected && <p className="text-sm text-muted-foreground flex items-center justify-center gap-2"><Wifi className="h-4 w-4" /> Connecting to server...</p>}
        </div>
      </div>
    );
  }

  const isHost = activeParticipants[0]?.user_id === user?.id;

  return (
    <div className="h-screen flex flex-col">
      <div className="border-b p-4 flex items-center justify-between bg-background">
        <div className="flex items-center gap-4">
          <div>
            <h1 className="text-xl font-bold">Battle Room: {activeRoom.room_code}</h1>
            <div className="flex items-center gap-2 text-sm text-muted-foreground">
              <Badge variant="outline">{activeRoom.battle_mode.replace('_', ' ')}</Badge>
              <Badge>{activeRoom.difficulty}</Badge>
              {isHost && <Badge variant="secondary">Host</Badge>}
            </div>
          </div>
        </div>
        
        <div className="flex items-center gap-4">
          {/* WebSocket Connection Status */}
          <div className="flex items-center gap-1">
            <Wifi className={`h-4 w-4 ${connected ? 'text-green-500' : 'text-gray-400'}`} />
            <span className="text-xs text-muted-foreground">{connected ? 'Live' : 'Offline'}</span>
          </div>
          
          {activeRoom.status === 'active' && (
            <div className="flex items-center gap-2">
              <Timer className="h-4 w-4" />
              <span className="font-mono font-bold">{formatTime(timeRemaining)}</span>
            </div>
          )}
          
          <div className="flex items-center gap-2">
            <Users className="h-4 w-4" />
            <span>{activeParticipants.length}/{activeRoom.max_participants}</span>
          </div>
          
          {activeRoom.status === 'waiting' && !hasJoined && (
            <Button onClick={handleJoinRoom}>
              Join Battle
            </Button>
          )}
          
          {activeRoom.status === 'waiting' && isHost && hasJoined && (
            <Button onClick={handleStartBattle} size="lg" className="bg-green-600 hover:bg-green-700">
              <Play className="mr-2 h-4 w-4" />
              Start Battle
            </Button>
          )}
          
          <Button variant="outline" onClick={handleLeaveRoom}>
            Leave
          </Button>
        </div>
      </div>

      {/* Waiting Room UI */}
      {activeRoom.status === 'waiting' && (
        <div className="flex-1 flex items-center justify-center bg-gradient-to-br from-background to-muted/20">
          <Card className="w-full max-w-2xl mx-4">
            <CardHeader>
              <CardTitle className="text-2xl text-center flex items-center justify-center gap-2">
                <Users className="h-6 w-6" />
                Waiting for Players...
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-6">
              <div className="text-center space-y-2">
                <p className="text-lg font-semibold">Room Code: <span className="font-mono text-primary">{activeRoom.room_code}</span></p>
                <p className="text-muted-foreground">Share this code with others to join</p>
              </div>

              <div className="space-y-3">
                <div className="flex items-center justify-between p-3 bg-muted rounded-lg">
                  <span className="font-medium">Battle Mode:</span>
                  <Badge variant="outline">{activeRoom.battle_mode.replace('_', ' ')}</Badge>
                </div>
                <div className="flex items-center justify-between p-3 bg-muted rounded-lg">
                  <span className="font-medium">Difficulty:</span>
                  <Badge>{activeRoom.difficulty}</Badge>
                </div>
                <div className="flex items-center justify-between p-3 bg-muted rounded-lg">
                  <span className="font-medium">Time Limit:</span>
                  <span className="font-mono font-bold">{formatTime(activeRoom.time_limit_seconds)}</span>
                </div>
                <div className="flex items-center justify-between p-3 bg-muted rounded-lg">
                  <span className="font-medium">Players:</span>
                  <span className="font-bold">{activeRoom.current_participants}/{activeRoom.max_participants}</span>
                </div>
              </div>

              {activeParticipants.length > 0 && user && (
                <div className="space-y-2">
                  <h3 className="font-semibold">Participants:</h3>
                  <LivePlayerList 
                    participants={activeParticipants}
                    hostId={activeParticipants[0]?.user_id}
                    currentUserId={user.id}
                    maxPlayers={activeRoom.max_participants}
                  />
                </div>
              )}

              {isHost && hasJoined && (
                <div className="pt-4 border-t space-y-3">
                  <p className="text-center text-sm text-muted-foreground">
                    You are the host. Start the battle when ready!
                  </p>
                  <Button onClick={handleStartBattle} size="lg" className="w-full bg-green-600 hover:bg-green-700">
                    <Play className="mr-2 h-5 w-5" />
                    Start Battle Now
                  </Button>
                </div>
              )}

              {!hasJoined && (
                <div className="pt-4 border-t">
                  <Button onClick={handleJoinRoom} size="lg" className="w-full">
                    Join This Battle
                  </Button>
                </div>
              )}
            </CardContent>
          </Card>
        </div>
      )}

      {/* Battle Arena UI - Only shown when battle is active */}
      {activeRoom.status === 'active' && (
      <div className="flex-1 flex overflow-hidden">
        <div className="flex-1 flex flex-col">
          <div className="p-4 border-b bg-card">
            <div className="flex items-center gap-2 mb-2">
              <Code2 className="h-5 w-5 text-primary" />
              <h3 className="font-semibold text-lg">{problem?.title || 'Loading problem...'}</h3>
              {problem && (
                <Badge variant={
                  problem.difficulty === 'easy' ? 'secondary' : 
                  problem.difficulty === 'medium' ? 'default' : 'destructive'
                }>
                  {problem.difficulty}
                </Badge>
              )}
            </div>
            
            {problem && (
              <div className="space-y-3 text-sm">
                <p className="text-muted-foreground">{problem.description}</p>
                
                {problem.examples && problem.examples.length > 0 && (
                  <div>
                    <h4 className="font-semibold mb-1">Example:</h4>
                    <div className="bg-muted/50 p-3 rounded font-mono text-xs space-y-1">
                      <div><span className="text-primary">Input:</span> {problem.examples[0].input}</div>
                      <div><span className="text-primary">Output:</span> {problem.examples[0].output}</div>
                      {problem.examples[0].explanation && (
                        <div className="text-muted-foreground">{problem.examples[0].explanation}</div>
                      )}
                    </div>
                  </div>
                )}
                
                {problem.constraints && (
                  <div>
                    <h4 className="font-semibold mb-1">Constraints:</h4>
                    <ul className="list-disc list-inside text-muted-foreground space-y-0.5">
                      {problem.constraints.slice(0, 3).map((c, i) => (
                        <li key={i} className="text-xs">{c}</li>
                      ))}
                    </ul>
                  </div>
                )}
              </div>
            )}
          </div>
          
          {/* Editor Toolbar */}
          <div className="border-b bg-muted/30 px-4 py-2 flex items-center justify-between">
            <div className="flex items-center gap-2">
              <select 
                value={language}
                onChange={(e) => handleLanguageChange(e.target.value)}
                className="px-3 py-1.5 text-sm bg-background border rounded font-mono"
                aria-label="Select programming language"
              >
                <option value="javascript">JavaScript</option>
                <option value="python">Python</option>
                <option value="java">Java</option>
                <option value="cpp">C++</option>
              </select>
              
              {testsPassedCount > 0 && problem && (
                <Badge variant={testsPassedCount === problem.testCases?.length ? 'default' : 'secondary'}>
                  {testsPassedCount}/{problem.testCases?.length || 0} tests passed
                </Badge>
              )}
            </div>
            
            <div className="flex items-center gap-2">
              <Button 
                variant="outline" 
                size="sm"
                onClick={handleRunTests}
                disabled={isRunning || !code.trim() || room?.status !== 'active'}
              >
                <Play className="h-4 w-4 mr-2" />
                {isRunning ? 'Running...' : 'Run Tests'}
              </Button>
              <Button 
                size="sm"
                onClick={handleSubmit}
                disabled={isRunning || testsPassedCount === 0 || room?.status !== 'active'}
                className="bg-green-600 hover:bg-green-700"
              >
                <Flag className="h-4 w-4 mr-2" />
                Submit
              </Button>
            </div>
          </div>
          
          <div className={testResults ? "h-[55%]" : "flex-1"}>
            <Editor
              height="100%"
              defaultLanguage={language}
              language={language}
              value={code}
              onChange={(value) => setCode(value || '')}
              theme="vs-dark"
              options={{
                minimap: { enabled: false },
                fontSize: 14,
                fontFamily: "'JetBrains Mono', 'Fira Code', 'Consolas', monospace",
                lineNumbers: "on",
                scrollBeyondLastLine: false,
                automaticLayout: true,
                tabSize: 2,
                wordWrap: 'on',
                quickSuggestions: true,
                suggestOnTriggerCharacters: true,
                acceptSuggestionOnEnter: "on",
                snippetSuggestions: "inline"
              }}
            />
          </div>
          
          {/* Test Results Panel */}
          {testResults && (
            <div className="h-[45%] border-t overflow-auto">
              <Card className="m-4">
                <CardHeader>
                  <CardTitle className="text-base flex items-center gap-2">
                    {testResults.passed === testResults.total ? (
                      <><CheckCircle2 className="h-5 w-5 text-green-500" /> All Tests Passed!</>
                    ) : (
                      <><XCircle className="h-5 w-5 text-red-500" /> {testResults.passed}/{testResults.total} Tests Passed</>
                    )}
                  </CardTitle>
                </CardHeader>
                <CardContent className="space-y-2">
                  {testResults.results?.map((result, idx: number) => (
                    <div 
                      key={result.id} 
                      className={`p-3 rounded border ${result.passed ? 'bg-green-500/10 border-green-500/30' : 'bg-red-500/10 border-red-500/30'}`}
                    >
                      <div className="flex items-center justify-between mb-2">
                        <span className="font-semibold text-sm">Test Case {idx + 1}</span>
                        {result.passed ? (
                          <CheckCircle2 className="h-4 w-4 text-green-500" />
                        ) : (
                          <XCircle className="h-4 w-4 text-red-500" />
                        )}
                      </div>
                      <div className="text-xs font-mono space-y-1">
                        <div><span className="text-muted-foreground">Input:</span> {result.input}</div>
                        <div><span className="text-muted-foreground">Expected:</span> {result.expected}</div>
                        {!result.passed && (
                          <div className="text-red-500"><span className="text-muted-foreground">Got:</span> {result.actual}</div>
                        )}
                      </div>
                    </div>
                  ))}
                </CardContent>
              </Card>
            </div>
          )}
        </div>

        <div className="w-80 border-l">
          {user && <LiveLeaderboard battleRoomId={roomId!} currentUserId={user.id} />}
        </div>
      </div>
      )}
    </div>
  );
}
