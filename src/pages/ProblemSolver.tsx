import { useState, useEffect, useRef, useCallback } from "react";
import { useParams, useNavigate, useSearchParams } from "react-router-dom";
import { Layout } from "@/components/layout/Layout";
import { Button } from "@/components/ui/button";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { ResizableHandle, ResizablePanel, ResizablePanelGroup } from "@/components/ui/resizable";
import { Card } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Separator } from "@/components/ui/separator";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { BabuaAIChat } from "@/components/ai/BabuaAIChat";
import { DifficultyBadge } from "@/components/ui/DifficultyBadge";
import Editor, { type Monaco } from "@monaco-editor/react";
import { 
  Play, RotateCcw, Lightbulb, CheckCircle2, XCircle, AlertCircle, Bot, Timer, 
  Copy, Check, Swords, Users, Download, Maximize2, Minimize2, Settings2,
  Moon, Sun, ZoomIn, ZoomOut, WrapText, Code2, Save, Sparkles
} from "lucide-react";
import { detailedProblems, enhancedUserProgress, dsaTopics, tracks } from "@/data/mockData";
import { problemService } from "@/services/problemService";
import type { Problem, TestResult } from "@/types";
import { useBabuaAI } from "@/hooks/useBabuaAI";
import { useAuth } from "@/contexts/AuthContext";
import { markProblemSolved, getProblemProgress } from "@/lib/userDataService";
import { updateStudyPlanProgress } from "@/lib/studyPlanService";
import { emitProblemSolved } from "@/lib/progressEvents";
import { getUserStats, unlockAchievement, getUnlockedAchievements } from "@/lib/userStatsService";
import { achievements, calculateXPForProblem, checkAchievementUnlock } from "@/data/achievements";
import { useToast } from "@/hooks/use-toast";
import { codeExecutionService, type SupportedLanguage } from "@/services/codeExecutionService";
import { parallelCodeRunner } from "@/services/parallelCodeRunner";
import { submissionService } from "@/services/submissionService";
import { SubmissionHistory } from "@/components/profile/SubmissionHistory";
import { CodeDiffViewer } from "@/components/profile/CodeDiffViewer";
import CodeReviewPanel from "@/components/ai/CodeReviewPanel";
import { requestCodeReview, checkRateLimit, type CodeReview, type RateLimitStatus } from "@/services/codeReviewService";
import { InterviewCoach } from "@/components/interview/InterviewCoach";
import { updateTopicPerformance } from "@/services/learningPathService";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";

export default function ProblemSolver() {
  const { id } = useParams<{ id: string }>();
  const [searchParams] = useSearchParams();
  const navigate = useNavigate();
  const { user } = useAuth();
  const { toast } = useToast();
  const editorRef = useRef<unknown>(null);
  const [problem, setProblem] = useState<Problem | null>(null);
  const [code, setCode] = useState("");
  const [language, setLanguage] = useState("javascript");
  const [testResults, setTestResults] = useState<TestResult | null>(null);
  const [isRunning, setIsRunning] = useState(false);
  const [showHints, setShowHints] = useState(false);
  const [hintsRevealed, setHintsRevealed] = useState(0);
  const [timeSpent, setTimeSpent] = useState(0);
  const [showAIPanel, setShowAIPanel] = useState(false);
  const [isSolved, setIsSolved] = useState(false);
  const [linkCopied, setLinkCopied] = useState(false);
  const [activeTab, setActiveTab] = useState("description");
  const [compareVersions, setCompareVersions] = useState<{ v1: number; v2: number } | null>(null);
  
  // AI Code Review state
  const [codeReview, setCodeReview] = useState<CodeReview | null>(null);
  const [isReviewLoading, setIsReviewLoading] = useState(false);
  const [rateLimitStatus, setRateLimitStatus] = useState<RateLimitStatus | null>(null);
  const [lastSubmittedCode, setLastSubmittedCode] = useState("");
  
  // Interview Coach state
  const [showInterviewCoach, setShowInterviewCoach] = useState(false);
  
  // Editor settings
  const [editorTheme, setEditorTheme] = useState<"vs-dark" | "light">("vs-dark");
  const [fontSize, setFontSize] = useState(14);
  const [isFullScreen, setIsFullScreen] = useState(false);
  const [wordWrap, setWordWrap] = useState<"on" | "off">("off");
  const [autoSave, setAutoSave] = useState(true);
  const [lastSaved, setLastSaved] = useState<Date | null>(null);
  
  const { sendMessage } = useBabuaAI();

  // Check if in duel mode
  const isDuelMode = searchParams.get("mode") === "duel";
  const duelId = searchParams.get("id");
  const isCustomDuel = searchParams.get("custom") === "true";

  // Check rate limit on mount
  useEffect(() => {
    const checkLimit = async () => {
      try {
        const status = await checkRateLimit();
        setRateLimitStatus(status);
      } catch (error) {
        console.error('Failed to check rate limit:', error);
      }
    };
    
    if (user) {
      checkLimit();
    }
  }, [user]);

  // Load saved code from localStorage
  const loadSavedCode = useCallback(() => {
    if (!id || !user) return;
    
    const savedCode = localStorage.getItem(`code_${user.id}_${id}_${language}`);
    if (savedCode) {
      setCode(savedCode);
      const savedTime = localStorage.getItem(`code_time_${user.id}_${id}`);
      if (savedTime) {
        setLastSaved(new Date(savedTime));
      }
    }
  }, [id, user, language]);

  // Save code to localStorage
  const saveCodeLocally = useCallback(() => {
    if (!id || !user || !code) return;
    
    localStorage.setItem(`code_${user.id}_${id}_${language}`, code);
    localStorage.setItem(`code_time_${user.id}_${id}`, new Date().toISOString());
    setLastSaved(new Date());
    
    toast({
      title: "Code Saved",
      description: "Your code has been auto-saved",
      duration: 1000,
    });
  }, [id, user, code, language, toast]);

  const loadProblem = useCallback(async () => {
    if (!id) return;

    try {
      let foundProblem = null;
      
      // First, try to find in detailedProblems by ID or slug
      foundProblem = detailedProblems[id];
      
      // If not found, try numeric ID
      if (!foundProblem) {
        const numericId = parseInt(id);
        if (!isNaN(numericId)) {
          foundProblem = detailedProblems[numericId];
        }
      }
      
      // Only try database as fallback if still not found
      if (!foundProblem) {
        try {
          foundProblem = await problemService.getProblemBySlug(id);
        } catch (err) {
          console.warn('Could not fetch from database, using mock data only');
        }
      }
      
      // If still not found, search in dsaTopics subtopics and create generic template
      if (!foundProblem) {
        for (const topic of dsaTopics) {
          const subtopic = topic.subtopics.find(sub => sub.id === id);
          if (subtopic) {
            // Create a generic problem object from the subtopic
            foundProblem = {
              id: id as unknown as number,
              title: subtopic.title,
              slug: id,
              difficulty: subtopic.difficulty as "easy" | "medium" | "hard",
              description: `Solve the ${subtopic.title} problem. This problem is part of the Strivers A2Z DSA Sheet.\n\nFull problem statement coming soon. Use Ask AI for hints and guidance!`,
              examples: [
                {
                  input: "Example input will be shown here",
                  output: "Example output will be shown here",
                  explanation: "Explanation will be provided"
                }
              ],
              constraints: ["Problem constraints will be listed here"],
              tags: [topic.title],
              track: "DSA",
              starterCode: {
                javascript: `// Write your solution here\nfunction solve() {\n  // Your code here\n}`,
                python: `# Write your solution here\ndef solve():\n    # Your code here\n    pass`,
                java: `// Write your solution here\nclass Solution {\n    public void solve() {\n        // Your code here\n    }\n}`,
                cpp: `// Write your solution here\n#include <iostream>\nusing namespace std;\n\nclass Solution {\npublic:\n    void solve() {\n        // Your code here\n    }\n};`,
                c: `// Write your solution here\n#include <stdio.h>\n\nvoid solve() {\n    // Your code here\n}`
              },
              testCases: [
                { id: "1", input: "Test case 1", expectedOutput: "Expected output", hidden: false },
                { id: "2", input: "Test case 2", expectedOutput: "Expected output", hidden: true }
              ],
              hints: [
                "Think about the problem step by step",
                "Consider the time and space complexity",
              "Ask AI for detailed hints and explanations"
            ],
              solved: subtopic.completed || false,
              acceptanceRate: 45.0,
              companies: ["Amazon", "Google", "Microsoft"],
              timeLimit: 2,
              memoryLimit: 256
            } as Problem;
            break;
          }
        }
      }
      
      if (foundProblem) {
        setProblem(foundProblem);
        
        // Check for saved code first
        const savedCode = localStorage.getItem(`code_${user?.id}_${id}_${language}`);
        if (savedCode) {
          setCode(savedCode);
        } else {
          setCode(foundProblem.starterCode?.[language] || foundProblem.starter_code?.[language] || "");
        }
        
        // Check if user has solved this problem
        if (user) {
          try {
            const progress = await getProblemProgress(user.id, id);
            setIsSolved(progress?.solved || false);
          } catch (err) {
            console.warn('Could not fetch problem progress:', err);
            setIsSolved(false);
          }
        }
      } else {
        navigate("/practice");
      }
    } catch (error) {
      console.error('Error loading problem:', error);
      toast({
        title: "Error",
        description: "Failed to load problem. Please try again.",
        variant: "destructive",
      });
      navigate("/practice");
    }
  }, [id, user, navigate, language, toast]);

  useEffect(() => {
    if (!id) {
      navigate("/practice");
      return;
    }

    loadProblem();
    loadSavedCode();
  }, [id, user, navigate, loadProblem, loadSavedCode]);

  // Auto-save functionality
  useEffect(() => {
    if (autoSave && code && problem && id) {
      const timer = setTimeout(() => {
        saveCodeLocally();
      }, 2000); // Save after 2 seconds of inactivity

      return () => clearTimeout(timer);
    }
  }, [code, autoSave, problem, id, saveCodeLocally]);

  useEffect(() => {
    const timer = setInterval(() => {
      setTimeSpent((prev) => prev + 1);
    }, 1000);
    return () => clearInterval(timer);
  }, []);

  // Manual save
  const handleManualSave = () => {
    saveCodeLocally();
    toast({
      title: "✓ Code Saved",
      description: "Your code has been saved successfully",
    });
  };

  const formatTime = (seconds: number) => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins}:${secs.toString().padStart(2, "0")}`;
  };

  const handleRunCode = async () => {
    if (!code.trim()) {
      toast({
        title: "No Code to Run",
        description: "Please write some code before running tests",
        variant: "destructive",
      });
      return;
    }

    setIsRunning(true);
    setTestResults(null);
    
    try {
      if (problem) {
        // Get visible test cases
        const visibleTests = problem.testCases.filter(tc => !tc.hidden);
        
        // Execute all test cases in parallel
        const result = await parallelCodeRunner.runAllTests(
          code,
          language as 'javascript' | 'python',
          visibleTests.map(tc => ({
            input: tc.input,
            expected_output: tc.expectedOutput
          }))
        );

        // Format results for UI
        const mockResults: TestResult = {
          passed: result.passedTests,
          total: result.totalTests,
          failures: result.results
            .map((r, idx) => ({
              testCase: idx + 1,
              input: JSON.stringify(r.input),
              expected: JSON.stringify(r.expected),
              got: r.actual !== null ? JSON.stringify(r.actual) : "No output",
              error: r.error || (r.passed ? null : "Wrong Answer"),
              time: `${r.executionTime.toFixed(2)}ms`,
              memory: null
            }))
            .filter((_, idx) => !result.results[idx].passed)
        };
        
        setTestResults(mockResults);
        
        toast({
          title: result.allPassed ? "All Tests Passed! ✓" : "Some Tests Failed",
          description: parallelCodeRunner.getSummary(result),
          variant: result.allPassed ? "default" : "destructive",
        });
      }
    } catch (error) {
      console.error('Code execution error:', error);
      toast({
        title: "Execution Error",
        description: error instanceof Error ? error.message : "Failed to execute code",
        variant: "destructive",
      });
    } finally {
      setIsRunning(false);
    }
  };

  const handleSubmit = async () => {
    if (!user) {
      toast({
        title: "Please Sign In",
        description: "You need to be signed in to submit solutions",
        variant: "destructive",
      });
      return;
    }

    if (!problem || !id) return;
    
    if (!code.trim()) {
      toast({
        title: "No Code to Submit",
        description: "Please write your solution before submitting",
        variant: "destructive",
      });
      return;
    }
    
    setIsRunning(true);
    setTestResults(null);
    
    // Save code before submission
    saveCodeLocally();
    
    // Execute code with real test cases
    setTimeout(async () => {
      if (problem) {
        try {
          // Execute all test cases in parallel (including hidden ones)
          const result = await parallelCodeRunner.runAllTests(
            code,
            language as 'javascript' | 'python',
            problem.testCases.map(tc => ({
              input: tc.input,
              expected_output: tc.expectedOutput
            }))
          );

          const mockResults: TestResult = {
            passed: result.passedTests,
            total: result.totalTests,
            failures: result.results
              .map((r, idx) => ({
                testCase: idx + 1,
                input: JSON.stringify(r.input),
                expected: JSON.stringify(r.expected),
                got: r.actual !== null ? JSON.stringify(r.actual) : "No output",
                error: r.error || (r.passed ? null : "Wrong Answer"),
                time: `${r.executionTime.toFixed(2)}ms`,
                memory: null
              }))
              .filter((_, idx) => !result.results[idx].passed)
          };

          setTestResults(mockResults);
          
          const allPassed = result.allPassed;
        
          // Save submission to database
          const submissionStatus = allPassed ? 'accepted' : 
            mockResults.failures.length > 0 ? 'wrong_answer' : 'runtime_error';
        
          // Build complete test results from parallel execution
          const allTestResults = result.results.map((r, idx) => ({
            input: JSON.stringify(r.input),
            expected_output: JSON.stringify(r.expected),
            actual_output: r.actual !== null ? JSON.stringify(r.actual) : null,
            passed: r.passed,
            error: r.error,
            time: `${r.executionTime.toFixed(2)}ms`,
            memory: null,
          }));
        
          const submissionResult = await submissionService.submitCode({
            problemId: String(problem.id),
            language,
            code,
            status: submissionStatus,
            testResults: allTestResults,
            passedCount: result.passedTests,
            failedCount: result.failedTests,
            totalTime: result.totalTime,
            memoryUsed: Math.floor(1024 + Math.random() * 2048),
            allPassed,
            errorMessage: allPassed ? null : mockResults.failures[0]?.error || null,
          });
          
          if (submissionResult) {
            console.log('Submission saved:', submissionResult);
          } else {
            console.warn('Submission not saved - database table may not exist');
          }
        
        // Save code for AI review
        if (allPassed) {
          setLastSubmittedCode(code);
        }
        
        // Track topic performance for learning recommendations
        await updateTopicPerformance(
          user.id,
          String(problem.id),
          allPassed,
          timeSpent, // Already in seconds
          problem.difficulty
        );
        
        // If all tests passed, mark as solved
        if (allPassed && !isSolved) {
          const trackSlug = problem.track?.toLowerCase() || "dsa";
          const track = tracks.find(t => t.slug === trackSlug);
          const totalProblems = track?.problems || 0;
          
          const result = await markProblemSolved(
            user.id,
            id,
            trackSlug,
            problem.difficulty,
            totalProblems,
            Math.floor(timeSpent / 60)
          );
          
          if (result) {
            setIsSolved(true);
            
            // Update study plan progress if problem is part of any active plan
            await updateStudyPlanProgress(
              user.id,
              String(problem.id),
              problem.slug
            );
            
            // Emit event to update all pages
            emitProblemSolved({
              problemId: String(problem.id),
              problemSlug: problem.slug,
              trackSlug: trackSlug,
              difficulty: problem.difficulty
            });
            
            // Calculate XP earned
            const xpEarned = calculateXPForProblem(
              problem.difficulty as 'easy' | 'medium' | 'hard',
              timeSpent / 60
            );
            
            // Check for new achievements
            const userStats = await getUserStats(user.id);
            const previouslyUnlocked = getUnlockedAchievements(user.id);
            const newAchievements: string[] = [];
            
            if (userStats) {
              for (const achievement of achievements) {
                if (!previouslyUnlocked.includes(achievement.id) && 
                    checkAchievementUnlock(achievement, userStats)) {
                  unlockAchievement(user.id, achievement.id);
                  newAchievements.push(achievement.title);
                }
              }
            }
            
            // Show success message with XP and achievements
            let description = `+${xpEarned} XP earned!`;
            if (newAchievements.length > 0) {
              description += `\n🏆 Achievement unlocked: ${newAchievements[0]}`;
            }
            
            toast({
              title: "🎉 Accepted!",
              description,
            });
          }
        } else if (!allPassed) {
          toast({
            title: "Wrong Answer",
            description: `${mockResults.passed}/${mockResults.total} test cases passed. Keep trying!`,
            variant: "destructive",
          });
        }
        } catch (error) {
          console.error('Code execution error:', error);
          toast({
            title: "Execution Error",
            description: "Failed to execute code. Please try again.",
            variant: "destructive",
          });
        }
      }
      setIsRunning(false);
    }, 1500);
  };

  const handleCopyDuelLink = async () => {
    const duelLink = window.location.href;
    
    try {
      await navigator.clipboard.writeText(duelLink);
      setLinkCopied(true);
      toast({
        title: "Link Copied!",
        description: "Share this link with others to join the duel",
      });
      
      setTimeout(() => setLinkCopied(false), 2000);
    } catch (err) {
      toast({
        title: "Failed to copy",
        description: "Please copy the link manually",
        variant: "destructive",
      });
    }
  };

  const handleReset = () => {
    if (problem) {
      const starterCode = problem.starterCode[language] || "";
      setCode(starterCode);
      setTestResults(null);
      
      // Clear saved code
      if (user && id) {
        localStorage.removeItem(`code_${user.id}_${id}_${language}`);
      }
      
      toast({
        title: "Code Reset",
        description: "Editor reset to starter code",
      });
    }
  };

  const handleRequestReview = async () => {
    if (!user) {
      toast({
        title: "Please Sign In",
        description: "You need to be signed in to get AI code reviews",
        variant: "destructive",
      });
      return;
    }

    if (!problem || !id) return;
    
    const codeToReview = lastSubmittedCode || code;
    
    if (!codeToReview.trim()) {
      toast({
        title: "No Code to Review",
        description: "Please submit your solution first",
        variant: "destructive",
      });
      return;
    }

    setIsReviewLoading(true);
    setCodeReview(null);

    try {
      // Request AI review
      const review = await requestCodeReview({
        code: codeToReview,
        language,
        problemId: id,
        problemTitle: problem.title,
        problemDescription: problem.description,
      });

      setCodeReview(review);
      
      // Update rate limit status
      const newStatus = await checkRateLimit();
      setRateLimitStatus(newStatus);

      toast({
        title: "Review Complete!",
        description: "Your code has been analyzed by AI",
      });

      // Scroll to review
      setTimeout(() => {
        const reviewElement = document.getElementById('code-review-section');
        if (reviewElement) {
          reviewElement.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
      }, 100);

    } catch (error: unknown) {
      console.error('Failed to get code review:', error);
      
      const errorMessage = error instanceof Error ? error.message : 'Unknown error occurred';
      
      toast({
        title: "Review Failed",
        description: errorMessage,
        variant: "destructive",
      });
    } finally {
      setIsReviewLoading(false);
    }
  };

  const handleDownload = () => {
    if (!code || !problem) return;

    const fileExtensions: Record<string, string> = {
      javascript: 'js',
      python: 'py',
      java: 'java',
      cpp: 'cpp',
    };

    const extension = fileExtensions[language] || 'txt';
    const fileName = `${problem.title.replace(/\s+/g, '_')}.${extension}`;
    
    const blob = new Blob([code], { type: 'text/plain' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = fileName;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
    
    toast({
      title: "Code Downloaded",
      description: `Saved as ${fileName}`,
    });
  };

  const handleFormatCode = () => {
    const editor = editorRef.current as { getAction: (id: string) => { run: () => void } | undefined } | null;
    if (!editor) return;
    
    const formatAction = editor.getAction('editor.action.formatDocument');
    if (formatAction) {
      formatAction.run();
    }
    
    toast({
      title: "Code Formatted",
      description: "Your code has been formatted",
      duration: 1000,
    });
  };

  const toggleFullScreen = () => {
    setIsFullScreen(!isFullScreen);
    toast({
      title: isFullScreen ? "Exit Full Screen" : "Full Screen Mode",
      description: isFullScreen ? "Returned to normal view" : "Press ESC to exit full screen",
      duration: 1000,
    });
  };

  const handleEditorDidMount = (editor: unknown, monaco: unknown) => {
    editorRef.current = editor;
    
    // Add keyboard shortcuts
    const editorInstance = editor as { addCommand: (keybinding: number, callback: () => void) => void };
    const monacoInstance = monaco as { KeyMod: { CtrlCmd: number; Shift: number }; KeyCode: { KeyS: number; Enter: number; KeyF: number } };
    
    editorInstance.addCommand(monacoInstance.KeyMod.CtrlCmd | monacoInstance.KeyCode.KeyS, () => {
      handleManualSave();
    });
    
    editorInstance.addCommand(monacoInstance.KeyMod.CtrlCmd | monacoInstance.KeyCode.Enter, () => {
      handleRunCode();
    });
    
    editorInstance.addCommand(monacoInstance.KeyMod.CtrlCmd | monacoInstance.KeyMod.Shift | monacoInstance.KeyCode.KeyF, () => {
      handleFormatCode();
    });
  };

  // Handle language change
  useEffect(() => {
    if (problem && user && id) {
      const savedCode = localStorage.getItem(`code_${user.id}_${id}_${language}`);
      if (savedCode) {
        setCode(savedCode);
      } else {
        setCode(problem.starterCode[language] || "");
      }
    }
  }, [language, problem, user, id]);

  const handleRevealHint = () => {
    if (problem && hintsRevealed < problem.hints.length) {
      setHintsRevealed(hintsRevealed + 1);
    }
  };

  const handleAskAI = (question: string) => {
    setShowAIPanel(true);
    if (problem) {
      sendMessage(question, {
        problem,
        userCode: code,
        language,
        testResults: testResults || undefined,
        userProgress: enhancedUserProgress
      });
    }
  };

  if (!problem) {
    return (
      <Layout>
        <div className="flex items-center justify-center h-screen">
          <p className="text-muted-foreground">Loading problem...</p>
        </div>
      </Layout>
    );
  }

  return (
    <Layout>
      <div className={`h-[calc(100vh-4rem)] flex flex-col ${isFullScreen ? 'fixed inset-0 z-50 bg-background' : ''}`}>
        {/* Header */}
        <div className="border-b bg-surface p-4 flex items-center justify-between">
          <div className="flex items-center gap-4">
            <Button variant="ghost" onClick={() => navigate("/practice")}>
              ← Back
            </Button>
            <h1 className="text-xl font-mono font-bold">{problem.title}</h1>
            <DifficultyBadge difficulty={problem.difficulty} />
            {isSolved && (
              <Badge variant="default" className="bg-green-500 text-white">
                <CheckCircle2 className="h-3 w-3 mr-1" />
                Solved
              </Badge>
            )}
            {isDuelMode && (
              <Badge variant="default" className="bg-amber-500 text-black">
                <Swords className="h-3 w-3 mr-1" />
                Duel Mode
              </Badge>
            )}
            <div className="flex gap-2">
              {problem.tags.slice(0, 3).map((tag) => (
                <Badge key={tag} variant="outline" className="font-mono text-xs">
                  {tag}
                </Badge>
              ))}
            </div>
          </div>
          <div className="flex items-center gap-4">
            {isDuelMode && (
              <div className="flex items-center gap-2">
                <Users className="h-4 w-4 text-muted-foreground" />
                <span className="text-sm text-muted-foreground font-mono">
                  {Math.floor(Math.random() * 20) + 5} competing
                </span>
              </div>
            )}
            <div className="flex items-center gap-2 text-sm text-muted-foreground font-mono">
              <Timer className="h-4 w-4" />
              {formatTime(timeSpent)}
            </div>
            {lastSaved && (
              <div className="text-xs text-muted-foreground flex items-center gap-1">
                <Save className="h-3 w-3" />
                Saved {Math.floor((new Date().getTime() - lastSaved.getTime()) / 1000)}s ago
              </div>
            )}
            <Button variant="outline" onClick={() => handleAskAI("Can you help me understand this problem?")}>
              <Bot className="mr-2 h-4 w-4" />
              Ask AI
            </Button>
          </div>
        </div>

        {/* Duel Link Banner */}
        {isDuelMode && (
          <div className="bg-amber-500/10 border-b border-amber-500/20 p-3">
            <div className="container mx-auto flex items-center justify-between">
              <div className="flex items-center gap-3">
                <Swords className="h-5 w-5 text-amber-500" />
                <div>
                  <div className="font-semibold text-sm">Competitive Duel Active</div>
                  <div className="text-xs text-muted-foreground">
                    Share this link with others to compete together
                  </div>
                </div>
              </div>
              <div className="flex items-center gap-2">
                <code className="bg-secondary px-3 py-1.5 rounded text-xs font-mono">
                  {window.location.href}
                </code>
                <Button
                  size="sm"
                  variant="outline"
                  onClick={handleCopyDuelLink}
                >
                  {linkCopied ? (
                    <Check className="h-4 w-4 mr-2" />
                  ) : (
                    <Copy className="h-4 w-4 mr-2" />
                  )}
                  {linkCopied ? "Copied!" : "Copy Link"}
                </Button>
              </div>
            </div>
          </div>
        )}

        {/* Main Content */}
        <ResizablePanelGroup direction="horizontal" className="flex-1">
          {/* Problem Description Panel */}
          <ResizablePanel defaultSize={35} minSize={25}>
            <Tabs value={activeTab} onValueChange={setActiveTab} className="h-full flex flex-col">
              <TabsList className="w-full justify-start rounded-none border-b bg-transparent p-0 flex-shrink-0">
                <TabsTrigger value="description" className="rounded-none">
                  Description
                </TabsTrigger>
                <TabsTrigger value="submissions" className="rounded-none">
                  Submissions
                </TabsTrigger>
                {testResults?.passed === testResults?.total && (
                  <Button
                    variant="ghost"
                    size="sm"
                    onClick={() => setShowInterviewCoach(!showInterviewCoach)}
                    className="ml-auto mr-2"
                  >
                    <Users className="h-4 w-4 mr-2" />
                    {showInterviewCoach ? "Exit Interview" : "Practice Interview"}
                  </Button>
                )}
              </TabsList>

              <TabsContent value="description" className="flex-1 m-0 overflow-hidden">
                <ScrollArea className="h-full">
                  <div className="p-6 space-y-6">
                <div>
                  <h2 className="text-lg font-semibold mb-2 font-mono">Description</h2>
                  <p className="text-muted-foreground whitespace-pre-line">{problem.description}</p>
                </div>

                <Separator />

                <div>
                  <h2 className="text-lg font-semibold mb-3 font-mono">Examples</h2>
                  {problem.examples.map((example, idx) => (
                    <Card key={idx} className="p-4 mb-3 bg-background/50">
                      <p className="font-mono text-sm mb-1">
                        <span className="text-primary">Input:</span> {example.input}
                      </p>
                      <p className="font-mono text-sm mb-1">
                        <span className="text-primary">Output:</span> {example.output}
                      </p>
                      {example.explanation && (
                        <p className="text-sm text-muted-foreground mt-2">{example.explanation}</p>
                      )}
                    </Card>
                  ))}
                </div>

                <Separator />

                <div>
                  <h2 className="text-lg font-semibold mb-2 font-mono">Constraints</h2>
                  <ul className="list-disc list-inside space-y-1 text-muted-foreground text-sm">
                    {problem.constraints.map((constraint, idx) => (
                      <li key={idx} className="font-mono">{constraint}</li>
                    ))}
                  </ul>
                </div>

                <Separator />

                <div>
                  <div className="flex items-center justify-between mb-3">
                    <h2 className="text-lg font-semibold font-mono">Hints</h2>
                    <Button 
                      variant="ghost" 
                      size="sm"
                      onClick={() => setShowHints(!showHints)}
                    >
                      <Lightbulb className="h-4 w-4 mr-2" />
                      {showHints ? "Hide" : "Show"} Hints
                    </Button>
                  </div>
                  {showHints && (
                    <div className="space-y-2">
                      {problem.hints.slice(0, hintsRevealed).map((hint, idx) => (
                        <Alert key={idx}>
                          <AlertCircle className="h-4 w-4" />
                          <AlertDescription className="text-sm">{hint}</AlertDescription>
                        </Alert>
                      ))}
                      {hintsRevealed < problem.hints.length && (
                        <Button variant="outline" size="sm" onClick={handleRevealHint} className="w-full">
                          Reveal Next Hint ({hintsRevealed + 1}/{problem.hints.length})
                        </Button>
                      )}
                      {hintsRevealed === problem.hints.length && (
                        <Button 
                          variant="outline" 
                          size="sm" 
                          onClick={() => handleAskAI("I've seen all the hints but still stuck. Can you guide me?")}
                          className="w-full"
                        >
                          <Bot className="mr-2 h-4 w-4" />
                          Still Stuck? Ask AI
                        </Button>
                      )}
                    </div>
                  )}
                </div>

                <div className="text-xs text-muted-foreground space-y-1 font-mono">
                  <p>Acceptance Rate: {problem.acceptanceRate}%</p>
                  <p>Companies: {problem.companies.join(", ")}</p>
                </div>
                  </div>
                </ScrollArea>
              </TabsContent>

              <TabsContent value="submissions" className="flex-1 m-0 overflow-hidden">
                {compareVersions ? (
                  <CodeDiffViewer
                    problemId={String(problem.id)}
                    version1={compareVersions.v1}
                    version2={compareVersions.v2}
                    onBack={() => setCompareVersions(null)}
                    onReplay={(code, lang) => {
                      setCode(code);
                      setLanguage(lang);
                      setCompareVersions(null);
                      setActiveTab("description");
                      toast({
                        title: "Code Loaded",
                        description: `Version code loaded into editor`,
                      });
                    }}
                  />
                ) : (
                  <SubmissionHistory
                    problemId={String(problem.id)}
                    onLoadCode={(code, lang) => {
                      setCode(code);
                      setLanguage(lang);
                      setActiveTab("description");
                      toast({
                        title: "Code Loaded",
                        description: "Submission code loaded into editor",
                      });
                    }}
                    onCompare={(v1, v2) => setCompareVersions({ v1, v2 })}
                  />
                )}
              </TabsContent>
            </Tabs>
          </ResizablePanel>

          <ResizableHandle withHandle />

          {/* Code Editor + Test Results Panel */}
          <ResizablePanel defaultSize={65} minSize={40}>
            <div className="h-full flex flex-col">
              {/* Editor Toolbar */}
              <div className="border-b bg-surface p-2 flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <select 
                    value={language}
                    onChange={(e) => setLanguage(e.target.value)}
                    className="px-3 py-1.5 text-sm bg-background border rounded font-mono"
                    aria-label="Select programming language"
                  >
                    <option value="javascript">JavaScript</option>
                    <option value="python">Python</option>
                    <option value="java">Java</option>
                    <option value="cpp">C++</option>
                    <option value="c">C</option>
                  </select>
                  
                  <Separator orientation="vertical" className="h-6" />
                  
                  <Button variant="ghost" size="sm" onClick={handleReset} title="Reset to starter code">
                    <RotateCcw className="h-4 w-4" />
                  </Button>
                  
                  <Button variant="ghost" size="sm" onClick={handleManualSave} title="Save code (Ctrl+S)">
                    <Save className="h-4 w-4" />
                  </Button>
                  
                  <Button variant="ghost" size="sm" onClick={handleDownload} title="Download code">
                    <Download className="h-4 w-4" />
                  </Button>
                  
                  <Button variant="ghost" size="sm" onClick={handleFormatCode} title="Format code (Ctrl+Shift+F)">
                    <Code2 className="h-4 w-4" />
                  </Button>
                  
                  <Separator orientation="vertical" className="h-6" />
                  
                  <DropdownMenu>
                    <DropdownMenuTrigger asChild>
                      <Button variant="ghost" size="sm" title="Editor settings">
                        <Settings2 className="h-4 w-4" />
                      </Button>
                    </DropdownMenuTrigger>
                    <DropdownMenuContent align="start" className="w-56">
                      <DropdownMenuLabel>Editor Settings</DropdownMenuLabel>
                      <DropdownMenuSeparator />
                      
                      <DropdownMenuItem onClick={() => setEditorTheme(editorTheme === "vs-dark" ? "light" : "vs-dark")}>
                        {editorTheme === "vs-dark" ? <Sun className="mr-2 h-4 w-4" /> : <Moon className="mr-2 h-4 w-4" />}
                        {editorTheme === "vs-dark" ? "Light Theme" : "Dark Theme"}
                      </DropdownMenuItem>
                      
                      <DropdownMenuItem onClick={() => setWordWrap(wordWrap === "on" ? "off" : "on")}>
                        <WrapText className="mr-2 h-4 w-4" />
                        Word Wrap: {wordWrap === "on" ? "On" : "Off"}
                      </DropdownMenuItem>
                      
                      <DropdownMenuSeparator />
                      <DropdownMenuLabel>Font Size</DropdownMenuLabel>
                      
                      <DropdownMenuItem onClick={() => setFontSize(Math.max(10, fontSize - 2))}>
                        <ZoomOut className="mr-2 h-4 w-4" />
                        Decrease ({fontSize}px)
                      </DropdownMenuItem>
                      
                      <DropdownMenuItem onClick={() => setFontSize(Math.min(24, fontSize + 2))}>
                        <ZoomIn className="mr-2 h-4 w-4" />
                        Increase ({fontSize}px)
                      </DropdownMenuItem>
                      
                      <DropdownMenuSeparator />
                      
                      <DropdownMenuItem onClick={() => setAutoSave(!autoSave)}>
                        <Save className="mr-2 h-4 w-4" />
                        Auto-save: {autoSave ? "On" : "Off"}
                      </DropdownMenuItem>
                    </DropdownMenuContent>
                  </DropdownMenu>
                  
                  <Button variant="ghost" size="sm" onClick={toggleFullScreen} title="Toggle fullscreen">
                    {isFullScreen ? <Minimize2 className="h-4 w-4" /> : <Maximize2 className="h-4 w-4" />}
                  </Button>
                </div>
                
                <div className="flex items-center gap-2">
                  <Button variant="outline" onClick={handleRunCode} disabled={isRunning} title="Run tests (Ctrl+Enter)">
                    <Play className="h-4 w-4 mr-2" />
                    {isRunning ? "Running..." : "Run"}
                  </Button>
                  <Button onClick={handleSubmit} disabled={isRunning} className="bg-green-600 hover:bg-green-700">
                    <CheckCircle2 className="h-4 w-4 mr-2" />
                    Submit
                  </Button>
                </div>
              </div>

              {/* Code Editor */}
              <div className={testResults ? "h-[55%]" : "flex-1"}>
                <Editor
                  height="100%"
                  defaultLanguage={language}
                  language={language}
                  value={code}
                  onChange={(value) => setCode(value || "")}
                  theme={editorTheme}
                  onMount={handleEditorDidMount}
                  options={{
                    minimap: { enabled: !isFullScreen },
                    fontSize: fontSize,
                    fontFamily: "'JetBrains Mono', 'Fira Code', 'Consolas', monospace",
                    lineNumbers: "on",
                    scrollBeyondLastLine: false,
                    automaticLayout: true,
                    tabSize: 2,
                    wordWrap: wordWrap,
                    formatOnPaste: true,
                    formatOnType: true,
                    autoClosingBrackets: "always",
                    autoClosingQuotes: "always",
                    suggestOnTriggerCharacters: true,
                    quickSuggestions: true,
                    folding: true,
                    foldingStrategy: "indentation",
                    showFoldingControls: "always",
                    matchBrackets: "always",
                    cursorBlinking: "smooth",
                    cursorSmoothCaretAnimation: "on",
                    smoothScrolling: true,
                    padding: { top: 16, bottom: 16 },
                  }}
                />
              </div>

              {/* Test Cases Panel - Always Visible */}
              <div className={testResults ? "h-[45%] border-t bg-surface" : "h-[200px] border-t bg-surface"}>
                <Tabs defaultValue="testcases" className="w-full h-full flex flex-col">
                  <TabsList className="w-full justify-start rounded-none border-b bg-transparent p-0 flex-shrink-0">
                    <TabsTrigger value="testcases" className="rounded-none">
                      Test Cases
                    </TabsTrigger>
                    {testResults && (
                      <TabsTrigger value="results" className="rounded-none">
                        <span className="flex items-center gap-2">
                          {testResults.passed === testResults.total ? (
                            <CheckCircle2 className="h-4 w-4 text-green-500" />
                          ) : (
                            <XCircle className="h-4 w-4 text-red-500" />
                          )}
                          Results ({testResults.passed}/{testResults.total})
                        </span>
                      </TabsTrigger>
                    )}
                  </TabsList>
                  
                  <TabsContent value="testcases" className="flex-1 overflow-auto p-4 m-0">
                    <div className="space-y-3">
                      {problem.testCases.filter(tc => !tc.hidden).map((testCase, idx) => {
                        const testNumber = idx + 1;
                        const isPassed = testResults && testResults.passed >= testNumber;
                        const isFailed = testResults && testResults.failures.some(f => f.testCase === testNumber);
                        
                        return (
                          <Card 
                            key={testCase.id} 
                            className={`p-4 ${
                              isPassed 
                                ? 'bg-green-500/10 border-green-500/30' 
                                : isFailed 
                                  ? 'bg-red-500/10 border-red-500/30' 
                                  : 'bg-background/50'
                            }`}
                          >
                            <div className="flex items-center justify-between mb-2">
                              <span className="text-sm font-semibold font-mono">Case {testNumber}</span>
                              {isPassed && (
                                <Badge variant="default" className="bg-green-600">
                                  <CheckCircle2 className="h-3 w-3 mr-1" />
                                  Passed
                                </Badge>
                              )}
                              {isFailed && (
                                <Badge variant="destructive">
                                  <XCircle className="h-3 w-3 mr-1" />
                                  Failed
                                </Badge>
                              )}
                            </div>
                            <div className="text-sm font-mono space-y-2">
                              <div>
                                <span className="text-muted-foreground font-semibold">Input:</span>
                                <pre className="mt-1 p-2 bg-background rounded text-xs overflow-x-auto">{testCase.input}</pre>
                              </div>
                              <div>
                                <span className="text-muted-foreground font-semibold">Expected Output:</span>
                                <pre className="mt-1 p-2 bg-background rounded text-xs overflow-x-auto">{testCase.expectedOutput}</pre>
                              </div>
                              {isFailed && testResults && (
                                <div>
                                  <span className="text-red-400 font-semibold">Your Output:</span>
                                  <pre className="mt-1 p-2 bg-background rounded text-xs overflow-x-auto text-red-400">
                                    {testResults.failures.find(f => f.testCase === testNumber)?.got}
                                  </pre>
                                  {testResults.failures.find(f => f.testCase === testNumber)?.error && (
                                    <p className="mt-1 text-xs text-red-400">
                                      {testResults.failures.find(f => f.testCase === testNumber)?.error}
                                    </p>
                                  )}
                                </div>
                              )}
                            </div>
                          </Card>
                        );
                      })}
                    </div>
                  </TabsContent>
                  
                  {testResults && (
                    <TabsContent value="results" className="flex-1 overflow-auto p-4 m-0">
                      <div className="space-y-4">
                        <div className="flex items-center justify-between p-4 rounded-lg bg-background/50 border">
                          <div className="flex items-center gap-3">
                            {testResults.passed === testResults.total ? (
                              <>
                                <div className="p-2 rounded-full bg-green-500/20">
                                  <CheckCircle2 className="h-6 w-6 text-green-500" />
                                </div>
                                <div>
                                  <p className="font-semibold text-green-500">All Tests Passed!</p>
                                  <p className="text-sm text-muted-foreground">
                                    {testResults.total}/{testResults.total} test cases passed
                                  </p>
                                </div>
                              </>
                            ) : (
                              <>
                                <div className="p-2 rounded-full bg-red-500/20">
                                  <XCircle className="h-6 w-6 text-red-500" />
                                </div>
                                <div>
                                  <p className="font-semibold text-red-500">Some Tests Failed</p>
                                  <p className="text-sm text-muted-foreground">
                                    {testResults.passed}/{testResults.total} test cases passed
                                  </p>
                                </div>
                              </>
                            )}
                          </div>
                        </div>
                        
                        {testResults.failures.length > 0 && (
                          <div className="space-y-3">
                            <h3 className="font-semibold text-sm">Failed Test Cases:</h3>
                            {testResults.failures.map((failure, idx) => (
                              <Card key={idx} className="p-4 bg-red-500/10 border-red-500/20">
                                <div className="flex items-center justify-between mb-3">
                                  <span className="text-sm font-semibold font-mono">Test Case #{failure.testCase}</span>
                                  <Badge variant="destructive">Failed</Badge>
                                </div>
                                <div className="text-sm font-mono space-y-2">
                                  <div>
                                    <span className="text-muted-foreground">Input:</span>
                                    <pre className="mt-1 p-2 bg-background rounded text-xs overflow-x-auto">{failure.input}</pre>
                                  </div>
                                  <div>
                                    <span className="text-muted-foreground">Expected:</span>
                                    <pre className="mt-1 p-2 bg-background rounded text-xs overflow-x-auto">{failure.expected}</pre>
                                  </div>
                                  <div>
                                    <span className="text-red-400">Your Output:</span>
                                    <pre className="mt-1 p-2 bg-background rounded text-xs overflow-x-auto text-red-400">{failure.got}</pre>
                                  </div>
                                  {failure.error && (
                                    <div className="mt-2 p-2 bg-red-500/10 rounded">
                                      <p className="text-xs text-red-400">{failure.error}</p>
                                    </div>
                                  )}
                                </div>
                              </Card>
                            ))}
                            <Button 
                              variant="outline" 
                              size="sm" 
                              onClick={() => handleAskAI("My code is failing some test cases. Can you help debug?")}
                              className="w-full"
                            >
                              <Bot className="mr-2 h-4 w-4" />
                              Get AI Help with Failed Tests
                            </Button>
                          </div>
                        )}

                        {/* AI Code Review Section */}
                        {testResults.passed === testResults.total && (
                          <div className="space-y-3">
                            <Separator />
                            <div className="flex items-center justify-between">
                              <div>
                                <h3 className="font-semibold text-sm">Want detailed feedback?</h3>
                                <p className="text-xs text-muted-foreground mt-1">
                                  Get AI-powered analysis of your code
                                </p>
                              </div>
                              <Button
                                onClick={handleRequestReview}
                                disabled={isReviewLoading}
                                className="bg-gradient-to-r from-purple-500 to-blue-500 hover:from-purple-600 hover:to-blue-600"
                              >
                                <Sparkles className="h-4 w-4 mr-2" />
                                {isReviewLoading ? "Analyzing..." : "Get AI Review"}
                              </Button>
                            </div>
                            
                            {rateLimitStatus && !rateLimitStatus.isPro && (
                              <p className="text-xs text-muted-foreground">
                                {rateLimitStatus.remainingReviews} review{rateLimitStatus.remainingReviews !== 1 ? "s" : ""} remaining today
                                {rateLimitStatus.remainingReviews === 0 && (
                                  <> • <a href="/pricing" className="text-purple-500 hover:underline">Upgrade to Pro</a> for unlimited</>
                                )}
                              </p>
                            )}
                          </div>
                        )}
                      </div>
                    </TabsContent>
                  )}
                </Tabs>
              </div>
            </div>
          </ResizablePanel>
        </ResizablePanelGroup>

        {/* AI Code Review Panel */}
        {codeReview && (
          <div id="code-review-section" className="mt-6">
            <CodeReviewPanel
              review={codeReview}
              isLoading={isReviewLoading}
              onClose={() => setCodeReview(null)}
            />
          </div>
        )}

        {/* Interview Coach Panel */}
        {showInterviewCoach && problem && (
          <div className="mt-6">
            <InterviewCoach
              problemId={problem.id}
              problemTitle={problem.title}
              problemDescription={problem.description}
              language={language}
              code={code}
              testsPassed={testResults?.passed === testResults?.total}
              onClose={() => setShowInterviewCoach(false)}
            />
          </div>
        )}

        {/* AI Chat Panel - Always Available with Context */}
        <BabuaAIChat 
          problem={problem || undefined}
          userCode={code}
          language={language}
          testResults={testResults || undefined}
          userProgress={enhancedUserProgress}
        />
      </div>
    </Layout>
  );
}
