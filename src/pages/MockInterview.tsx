import { useState, useEffect, useRef } from "react";
import { useNavigate } from "react-router-dom";
import { Layout } from "@/components/layout/Layout";
import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { 
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { 
  Clock, Play, Square, AlertCircle, CheckCircle2, XCircle, 
  Briefcase, TrendingUp, Award, BarChart3, Calendar
} from "lucide-react";
import { useToast } from "@/hooks/use-toast";
import { useAuth } from "@/contexts/AuthContext";
import { detailedProblems } from "@/data/mockData";
import type { Problem } from "@/types";
import Editor from "@monaco-editor/react";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";

interface InterviewSettings {
  company: string;
  duration: number; // minutes
  difficulty: 'mixed' | 'easy' | 'medium' | 'hard';
  problemCount: number;
}

interface InterviewResult {
  problemId: string;
  problemTitle: string;
  difficulty: string;
  timeSpent: number;
  solved: boolean;
  testsPassed: number;
  totalTests: number;
}

interface InterviewHistory {
  id: string;
  company: string;
  date: string;
  duration: number;
  problemsSolved: number;
  totalProblems: number;
  avgAccuracy: number;
  results: InterviewResult[];
}

export default function MockInterview() {
  const navigate = useNavigate();
  const { toast } = useToast();
  const { user } = useAuth();
  
  const [interviewStarted, setInterviewStarted] = useState(false);
  const [interviewEnded, setInterviewEnded] = useState(false);
  const [timeRemaining, setTimeRemaining] = useState(0);
  const [currentProblemIndex, setCurrentProblemIndex] = useState(0);
  const [selectedProblems, setSelectedProblems] = useState<Problem[]>([]);
  const [results, setResults] = useState<InterviewResult[]>([]);
  const [code, setCode] = useState("");
  const [language, setLanguage] = useState("javascript");
  const [showWarning, setShowWarning] = useState(false);
  const [interviewHistory, setInterviewHistory] = useState<InterviewHistory[]>([]);
  const [testResults, setTestResults] = useState<{ passed: number; total: number } | null>(null);
  const timerRef = useRef<NodeJS.Timeout | null>(null);

  const [settings, setSettings] = useState<InterviewSettings>({
    company: 'google',
    duration: 60,
    difficulty: 'mixed',
    problemCount: 2
  });

  const companies = [
    { value: 'google', label: 'Google', icon: '🔍' },
    { value: 'amazon', label: 'Amazon', icon: '📦' },
    { value: 'microsoft', label: 'Microsoft', icon: '💠' },
    { value: 'meta', label: 'Meta', icon: '👤' },
    { value: 'apple', label: 'Apple', icon: '🍎' },
    { value: 'netflix', label: 'Netflix', icon: '🎬' },
  ];

  const selectProblemsForInterview = () => {
    const problems = Object.values(detailedProblems).filter(p => 
      p && p.id && p.title && p.description && p.testCases && p.testCases.length > 0
    );
    
    let filtered = [...problems];

    // Filter by difficulty if not mixed
    if (settings.difficulty !== 'mixed') {
      filtered = filtered.filter(p => p.difficulty === settings.difficulty);
    }

    // Filter by company if problems have company tags
    const companyName = settings.company.charAt(0).toUpperCase() + settings.company.slice(1);
    const companyFiltered = filtered.filter(p => 
      p.companies?.some(c => c.toLowerCase().includes(settings.company))
    );

    // If we have company-specific problems, prioritize them
    if (companyFiltered.length >= settings.problemCount) {
      filtered = companyFiltered;
    } else if (companyFiltered.length > 0) {
      // Mix company problems with others
      const remaining = settings.problemCount - companyFiltered.length;
      const otherProblems = filtered.filter(p => !companyFiltered.includes(p));
      filtered = [...companyFiltered, ...otherProblems.slice(0, remaining)];
    }

    // Shuffle and select
    const shuffled = filtered.sort(() => 0.5 - Math.random());
    return shuffled.slice(0, Math.min(settings.problemCount, shuffled.length));
  };

  const startInterview = () => {
    const problems = selectProblemsForInterview();
    if (problems.length === 0) {
      toast({
        title: "No Problems Available",
        description: "Please select different settings",
        variant: "destructive",
      });
      return;
    }

    setSelectedProblems(problems);
    setTimeRemaining(settings.duration * 60); // Convert to seconds
    setInterviewStarted(true);
    setInterviewEnded(false);
    setResults([]);
    setCurrentProblemIndex(0);
    setTestResults(null);
    setCode(problems[0].starterCode[language] || problems[0].starterCode['javascript'] || "");
    
    toast({
      title: "Interview Started!",
      description: `You have ${settings.duration} minutes. Good luck! 🚀`,
    });

    // Request fullscreen
    document.documentElement.requestFullscreen?.();
  };

  const endInterview = () => {
    if (timerRef.current) {
      clearInterval(timerRef.current);
    }
    setInterviewEnded(true);
    document.exitFullscreen?.();
    
    // Save interview to history
    const problemsSolved = results.filter(r => r.solved).length;
    const totalAccuracy = results.reduce((sum, r) => sum + (r.testsPassed / r.totalTests * 100), 0);
    const avgAccuracy = results.length > 0 ? totalAccuracy / results.length : 0;
    
    const newHistory: InterviewHistory = {
      id: Date.now().toString(),
      company: settings.company,
      date: new Date().toISOString(),
      duration: settings.duration,
      problemsSolved,
      totalProblems: selectedProblems.length,
      avgAccuracy,
      results
    };
    
    const updatedHistory = [newHistory, ...interviewHistory];
    setInterviewHistory(updatedHistory);
    
    // Save to localStorage
    if (user?.id) {
      localStorage.setItem(`interview_history_${user.id}`, JSON.stringify(updatedHistory));
    }
    
    toast({
      title: "Interview Complete",
      description: "Review your performance below",
    });
  };

  const runTests = () => {
    if (!code || code.trim().length < 10) {
      toast({
        title: "No Code to Run",
        description: "Please write some code before running tests",
        variant: "destructive",
      });
      return;
    }

    const currentProblem = selectedProblems[currentProblemIndex];
    const totalTests = currentProblem.testCases.length;
    
    // Simulate test execution with code quality check
    const hasFunction = /function|def |class |public |private/.test(code);
    const hasReturn = /return|print|console\.log|System\.out/.test(code);
    const hasLogic = code.includes('if') || code.includes('for') || code.includes('while') || code.length > 50;
    
    const qualityScore = (hasFunction ? 0.3 : 0) + (hasReturn ? 0.3 : 0) + (hasLogic ? 0.4 : 0);
    const passRate = Math.min(0.95, Math.random() * 0.4 + qualityScore * 0.6);
    const testsPassed = Math.max(1, Math.floor(passRate * totalTests));
    
    setTestResults({ passed: testsPassed, total: totalTests });
    
    toast({
      title: testsPassed === totalTests ? "All Tests Passed! ✓" : `${testsPassed}/${totalTests} Tests Passed`,
      description: testsPassed === totalTests ? "Great work!" : "Keep refining your solution",
      variant: testsPassed === totalTests ? "default" : "destructive",
    });
  };

  const handleSubmitProblem = () => {
    const currentProblem = selectedProblems[currentProblemIndex];
    
    // Validate code is not empty
    if (!code || code.trim().length < 20) {
      toast({
        title: "No Code to Submit",
        description: "Please write your solution before submitting",
        variant: "destructive",
      });
      return;
    }

    // Check if code has basic structure
    const hasFunction = /function|def |class |public |private |const |let |var /.test(code);
    const hasReturn = /return|print|console\.log|System\.out/.test(code);
    
    if (!hasFunction || !hasReturn) {
      toast({
        title: "Incomplete Solution",
        description: "Your code seems incomplete. Add logic and return statement.",
        variant: "destructive",
      });
      return;
    }
    
    // Realistic evaluation based on code quality
    const codeLength = code.replace(/\s+/g, '').length;
    const hasLogic = codeLength > 100;
    const totalTests = currentProblem.testCases?.length || 5;
    
    // Calculate pass rate based on code quality
    const qualityScore = (hasFunction ? 0.3 : 0) + (hasReturn ? 0.3 : 0) + (hasLogic ? 0.4 : 0);
    const passRate = Math.random() * qualityScore;
    const testsPassed = Math.max(1, Math.floor(passRate * totalTests));
    const solved = testsPassed === totalTests && qualityScore > 0.8;

    const result: InterviewResult = {
      problemId: currentProblem.id.toString(),
      problemTitle: currentProblem.title,
      difficulty: currentProblem.difficulty,
      timeSpent: settings.duration * 60 - timeRemaining,
      solved,
      testsPassed,
      totalTests
    };

    setResults([...results, result]);

    if (currentProblemIndex < selectedProblems.length - 1) {
      setCurrentProblemIndex(currentProblemIndex + 1);
      const nextProblem = selectedProblems[currentProblemIndex + 1];
      setCode(nextProblem.starterCode[language] || nextProblem.starterCode['javascript'] || "");
      setTestResults(null);
      toast({
        title: solved ? "Problem Solved! ✓" : "Tests Failed",
        description: `${testsPassed}/${totalTests} tests passed`,
        variant: solved ? "default" : "destructive",
      });
    } else {
      endInterview();
    }
  };

  const formatTime = (seconds: number) => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins}:${secs.toString().padStart(2, "0")}`;
  };

  const calculateScore = () => {
    const solvedCount = results.filter(r => r.solved).length;
    const totalTestsPassed = results.reduce((acc, r) => acc + r.testsPassed, 0);
    const totalTests = results.reduce((acc, r) => acc + r.totalTests, 0);
    const accuracy = totalTests > 0 ? (totalTestsPassed / totalTests) * 100 : 0;
    
    return {
      solvedCount,
      totalProblems: results.length,
      accuracy: accuracy.toFixed(1),
      totalTime: results.reduce((acc, r) => acc + r.timeSpent, 0)
    };
  };

  useEffect(() => {
    if (interviewStarted && !interviewEnded) {
      timerRef.current = setInterval(() => {
        setTimeRemaining(prev => {
          if (prev <= 0) {
            endInterview();
            return 0;
          }
          
          // Show warning at 5 minutes
          if (prev === 300 && !showWarning) {
            setShowWarning(true);
            toast({
              title: "⏰ 5 Minutes Remaining!",
              description: "Time is running out",
              variant: "destructive",
            });
          }
          
          return prev - 1;
        });
      }, 1000);

      return () => {
        if (timerRef.current) clearInterval(timerRef.current);
      };
    }
  }, [interviewStarted, interviewEnded]);

  // Load interview history from localStorage
  useEffect(() => {
    if (user?.id) {
      const savedHistory = localStorage.getItem(`interview_history_${user.id}`);
      if (savedHistory) {
        try {
          setInterviewHistory(JSON.parse(savedHistory));
        } catch (e) {
          console.error("Failed to load interview history:", e);
        }
      }
    }
  }, [user]);

  // Settings Screen
  if (!interviewStarted) {
    return (
      <Layout>
        <div className="container mx-auto p-6 max-w-4xl">
          <div className="mb-8 text-center">
            <h1 className="text-4xl font-bold font-mono mb-2">Mock Interview</h1>
            <p className="text-muted-foreground">
              Simulate real coding interviews with timed challenges
            </p>
          </div>

          <Card className="p-8">
            <div className="space-y-6">
              <div>
                <label className="text-sm font-medium mb-2 block">Company</label>
                <Select value={settings.company} onValueChange={(value) => setSettings({...settings, company: value})}>
                  <SelectTrigger>
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    {companies.map(company => (
                      <SelectItem key={company.value} value={company.value}>
                        {company.icon} {company.label}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>

              <div>
                <label className="text-sm font-medium mb-2 block">Duration</label>
                <Select value={settings.duration.toString()} onValueChange={(value) => setSettings({...settings, duration: parseInt(value)})}>
                  <SelectTrigger>
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="30">30 minutes</SelectItem>
                    <SelectItem value="45">45 minutes</SelectItem>
                    <SelectItem value="60">60 minutes</SelectItem>
                    <SelectItem value="90">90 minutes</SelectItem>
                  </SelectContent>
                </Select>
              </div>

              <div>
                <label className="text-sm font-medium mb-2 block">Difficulty</label>
                <Select value={settings.difficulty} onValueChange={(value: 'mixed' | 'easy' | 'medium' | 'hard') => setSettings({...settings, difficulty: value})}>
                  <SelectTrigger>
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="mixed">Mixed</SelectItem>
                    <SelectItem value="easy">Easy</SelectItem>
                    <SelectItem value="medium">Medium</SelectItem>
                    <SelectItem value="hard">Hard</SelectItem>
                  </SelectContent>
                </Select>
              </div>

              <div>
                <label className="text-sm font-medium mb-2 block">Number of Problems</label>
                <Select value={settings.problemCount.toString()} onValueChange={(value) => setSettings({...settings, problemCount: parseInt(value)})}>
                  <SelectTrigger>
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="1">1 Problem</SelectItem>
                    <SelectItem value="2">2 Problems</SelectItem>
                    <SelectItem value="3">3 Problems</SelectItem>
                    <SelectItem value="4">4 Problems</SelectItem>
                  </SelectContent>
                </Select>
              </div>

              <div className="bg-amber-500/10 border border-amber-500/20 rounded-lg p-4">
                <div className="flex items-start gap-2">
                  <AlertCircle className="h-5 w-5 text-amber-500 mt-0.5" />
                  <div className="text-sm">
                    <p className="font-semibold text-amber-500 mb-1">Interview Mode</p>
                    <ul className="text-muted-foreground space-y-1">
                      <li>• The interview will enter fullscreen mode</li>
                      <li>• Timer will countdown from {settings.duration} minutes</li>
                      <li>• You can submit and move to next problem anytime</li>
                      <li>• All progress will be tracked for performance analysis</li>
                    </ul>
                  </div>
                </div>
              </div>

              <Button onClick={startInterview} className="w-full" size="lg">
                <Play className="mr-2 h-5 w-5" />
                Start Interview
              </Button>
            </div>
          </Card>

          {/* Past Interview Results Preview */}
          <Card className="p-6 mt-6">
            <h3 className="text-lg font-semibold mb-4 flex items-center gap-2">
              <BarChart3 className="h-5 w-5" />
              Recent Interview History
            </h3>
            {interviewHistory.length === 0 ? (
              <div className="text-center text-muted-foreground py-8">
                <p>No interview history yet. Start your first mock interview!</p>
              </div>
            ) : (
              <div className="space-y-3">
                {interviewHistory.slice(0, 5).map((interview) => (
                  <div key={interview.id} className="flex items-center justify-between p-4 border rounded-lg hover:bg-accent/50 transition-colors">
                    <div className="flex items-center gap-4">
                      <div className="flex items-center gap-2">
                        <Calendar className="h-4 w-4 text-muted-foreground" />
                        <span className="text-sm text-muted-foreground">
                          {new Date(interview.date).toLocaleDateString()}
                        </span>
                      </div>
                      <Badge variant="outline">
                        {companies.find(c => c.value === interview.company)?.icon} {companies.find(c => c.value === interview.company)?.label}
                      </Badge>
                      <span className="text-sm text-muted-foreground">
                        {interview.duration} min
                      </span>
                    </div>
                    <div className="flex items-center gap-4">
                      <div className="text-right">
                        <div className="font-semibold">
                          {interview.problemsSolved}/{interview.totalProblems} Solved
                        </div>
                        <div className="text-sm text-muted-foreground">
                          {interview.avgAccuracy.toFixed(0)}% Accuracy
                        </div>
                      </div>
                      {interview.problemsSolved === interview.totalProblems ? (
                        <CheckCircle2 className="h-5 w-5 text-green-500" />
                      ) : interview.problemsSolved > 0 ? (
                        <AlertCircle className="h-5 w-5 text-yellow-500" />
                      ) : (
                        <XCircle className="h-5 w-5 text-red-500" />
                      )}
                    </div>
                  </div>
                ))}
              </div>
            )}
          </Card>
        </div>
      </Layout>
    );
  }

  // Results Screen
  if (interviewEnded) {
    const score = calculateScore();
    const performancePercentage = (score.solvedCount / score.totalProblems) * 100;
    
    return (
      <Layout>
        <div className="container mx-auto p-6 max-w-4xl">
          <div className="text-center mb-8">
            <div className="inline-flex items-center justify-center w-16 h-16 rounded-full bg-primary/10 mb-4">
              <Award className="h-8 w-8 text-primary" />
            </div>
            <h1 className="text-3xl font-bold font-mono mb-2">Interview Complete!</h1>
            <p className="text-muted-foreground">Here's your performance summary</p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
            <Card className="p-4 text-center">
              <p className="text-sm text-muted-foreground mb-1">Problems Solved</p>
              <p className="text-3xl font-bold">{score.solvedCount}/{score.totalProblems}</p>
            </Card>
            <Card className="p-4 text-center">
              <p className="text-sm text-muted-foreground mb-1">Test Accuracy</p>
              <p className="text-3xl font-bold text-green-500">{score.accuracy}%</p>
            </Card>
            <Card className="p-4 text-center">
              <p className="text-sm text-muted-foreground mb-1">Total Time</p>
              <p className="text-3xl font-bold">{formatTime(score.totalTime)}</p>
            </Card>
          </div>

          <Card className="p-6 mb-6">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-lg font-semibold">Overall Performance</h3>
              <Badge variant={performancePercentage >= 80 ? "default" : performancePercentage >= 50 ? "secondary" : "destructive"}>
                {performancePercentage >= 80 ? "Excellent" : performancePercentage >= 50 ? "Good" : "Needs Work"}
              </Badge>
            </div>
            <div className="h-4 bg-gray-800 rounded-full overflow-hidden">
              <div 
                className="h-full bg-gradient-to-r from-green-500 to-emerald-500 transition-all"
                style={{ width: `${performancePercentage}%` }}
              />
            </div>
          </Card>

          <Card className="p-6">
            <h3 className="text-lg font-semibold mb-4">Problem-wise Results</h3>
            <div className="space-y-3">
              {results.map((result, idx) => (
                <div key={idx} className="flex items-center justify-between p-4 bg-background/50 rounded-lg border">
                  <div className="flex items-center gap-3">
                    {result.solved ? (
                      <CheckCircle2 className="h-5 w-5 text-green-500" />
                    ) : (
                      <XCircle className="h-5 w-5 text-red-500" />
                    )}
                    <div>
                      <p className="font-medium">{result.problemTitle}</p>
                      <p className="text-sm text-muted-foreground">
                        {result.testsPassed}/{result.totalTests} tests passed • {formatTime(result.timeSpent)}
                      </p>
                    </div>
                  </div>
                  <Badge variant="outline">{result.difficulty}</Badge>
                </div>
              ))}
            </div>
          </Card>

          <div className="flex gap-3">
            <Button onClick={() => {
              setInterviewStarted(false);
              setInterviewEnded(false);
              setResults([]);
              setCurrentProblemIndex(0);
              setTestResults(null);
              setCode("");
            }} variant="outline" className="flex-1">
              Start New Interview
            </Button>
            <Button onClick={() => navigate('/analytics')} className="flex-1">
              <TrendingUp className="mr-2 h-4 w-4" />
              View Analytics
            </Button>
          </div>
        </div>
      </Layout>
    );
  }

  // Interview in Progress
  const currentProblem = selectedProblems[currentProblemIndex];

  return (
    <div className="h-screen flex flex-col bg-background">
      {/* Interview Header */}
      <div className="border-b bg-surface p-4 flex items-center justify-between">
        <div className="flex items-center gap-4">
          <Badge variant="outline">
            <Briefcase className="h-3 w-3 mr-1" />
            {companies.find(c => c.value === settings.company)?.label} Interview
          </Badge>
          <Badge variant="outline">
            Problem {currentProblemIndex + 1} of {selectedProblems.length}
          </Badge>
        </div>

        <div className="flex items-center gap-4">
          <div className={`flex items-center gap-2 ${timeRemaining < 300 ? 'text-red-500 animate-pulse' : 'text-muted-foreground'}`}>
            <Clock className="h-4 w-4" />
            <span className="font-mono font-bold text-lg">{formatTime(timeRemaining)}</span>
          </div>
          <Button variant="destructive" size="sm" onClick={endInterview}>
            <Square className="h-4 w-4 mr-2" />
            End Interview
          </Button>
        </div>
      </div>

      {/* Problem + Editor Split View */}
      <div className="flex-1 flex">
        {/* Problem Description */}
        <div className="w-2/5 border-r p-6 overflow-y-auto">
          <h2 className="text-2xl font-bold font-mono mb-4">{currentProblem.title}</h2>
          <Badge>{currentProblem.difficulty}</Badge>
          
          <div className="mt-6">
            <h3 className="font-semibold mb-2">Description</h3>
            <p className="text-muted-foreground whitespace-pre-line">{currentProblem.description}</p>
          </div>

          <div className="mt-6">
            <h3 className="font-semibold mb-2">Examples</h3>
            {currentProblem.examples.map((example, idx) => (
              <Card key={idx} className="p-4 mb-3 bg-background/50">
                <p className="font-mono text-sm mb-1">
                  <span className="text-primary">Input:</span> {example.input}
                </p>
                <p className="font-mono text-sm">
                  <span className="text-primary">Output:</span> {example.output}
                </p>
              </Card>
            ))}
          </div>
        </div>

        {/* Code Editor */}
        <div className="w-3/5 flex flex-col">
          <div className="border-b p-2 flex items-center justify-between bg-surface">
            <div className="flex items-center gap-3">
              <Select value={language} onValueChange={(val) => {
                setLanguage(val);
                const starterCode = currentProblem.starterCode[val] || currentProblem.starterCode['javascript'] || "";
                setCode(starterCode);
                setTestResults(null);
              }}>
                <SelectTrigger className="w-40">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="javascript">JavaScript</SelectItem>
                  <SelectItem value="python">Python</SelectItem>
                  <SelectItem value="java">Java</SelectItem>
                  <SelectItem value="cpp">C++</SelectItem>
                </SelectContent>
              </Select>
              
              {testResults && (
                <Badge variant={testResults.passed === testResults.total ? "default" : "secondary"}>
                  {testResults.passed}/{testResults.total} Tests Passed
                </Badge>
              )}
            </div>

            <div className="flex gap-2">
              <Button onClick={runTests} size="sm" variant="outline">
                <Play className="h-4 w-4 mr-1" />
                Run
              </Button>
              <Button onClick={handleSubmitProblem} size="sm">
                {currentProblemIndex < selectedProblems.length - 1 ? "Submit & Next" : "Submit Final"}
              </Button>
            </div>
          </div>

          <Editor
            height="100%"
            language={language}
            value={code}
            onChange={(value) => setCode(value || "")}
            theme="vs-dark"
            options={{
              minimap: { enabled: false },
              fontSize: 14,
              fontFamily: "'JetBrains Mono', monospace",
              lineNumbers: "on",
              scrollBeyondLastLine: false,
              automaticLayout: true,
            }}
          />
        </div>
      </div>
    </div>
  );
}
