import { useParams, Link } from "react-router-dom";
import { Layout } from "@/components/layout/Layout";
import { Button } from "@/components/ui/button";
import { DifficultyBadge } from "@/components/ui/DifficultyBadge";
import { BabuaAIChat } from "@/components/ai/BabuaAIChat";
import { 
  tracks, 
  dsaTopics, 
  systemDesignTopics,
  lldTopics,
  osTopics,
  networksTopics,
  databaseTopics,
  aimlTopics,
  detailedProblems 
} from "@/data/mockData";
import {
  ChevronRight,
  Check,
  BookmarkPlus,
  MessageSquare,
  ArrowLeft,
  ChevronDown,
  Bot,
  ExternalLink,
  CheckCircle,
} from "lucide-react";
import { useState, useEffect } from "react";
import { useBabuaAI } from "@/hooks/useBabuaAI";
import { useAuth } from "@/contexts/AuthContext";
import { getUserProblemProgress, markProblemSolved } from "@/lib/userDataService";
import { useToast } from "@/hooks/use-toast";

export default function TrackDetail() {
  const { slug } = useParams();
  const { user } = useAuth();
  const { toast } = useToast();
  const track = tracks.find((t) => t.slug === slug);
  const [solvedProblems, setSolvedProblems] = useState<Set<string>>(new Set());
  const [markingComplete, setMarkingComplete] = useState(false);

  useEffect(() => {
    if (user && slug) {
      loadUserProgress();
    }
  }, [user, slug]);

  const loadUserProgress = async () => {
    if (!user || !slug) return;
    
    const progress = await getUserProblemProgress(user.id);
    const solved = new Set(
      progress
        .filter(p => p.solved && p.track_slug === slug)
        .map(p => p.problem_id)
    );
    setSolvedProblems(solved);
  };

  const handleMarkComplete = async () => {
    if (!user || !selectedProblem || !track) return;
    
    setMarkingComplete(true);
    try {
      const result = await markProblemSolved(
        user.id,
        selectedProblem.id,
        track.slug,
        selectedProblem.difficulty,
        track.problems, // total available problems
        0 // time spent
      );
      
      if (result) {
        setSolvedProblems(prev => new Set(prev).add(selectedProblem.id));
        toast({
          title: "✅ Problem Marked as Complete!",
          description: `Great job on ${selectedProblem.title}!`,
        });
      }
    } catch (error) {
      console.error('Error marking problem complete:', error);
      toast({
        title: "Error",
        description: "Failed to mark problem as complete. Please try again.",
        variant: "destructive",
      });
    } finally {
      setMarkingComplete(false);
    }
  };

  // Get the correct topics based on track slug
  const getTopicsForTrack = (trackSlug: string) => {
    switch (trackSlug) {
      case "dsa":
        return dsaTopics;
      case "system-design":
        return systemDesignTopics;
      case "lld":
        return lldTopics;
      case "os":
        return osTopics;
      case "cn":
        return networksTopics;
      case "dbms":
        return databaseTopics;
      case "ai-ml":
        return aimlTopics;
      default:
        return dsaTopics;
    }
  };

  const currentTopics = track ? getTopicsForTrack(track.slug) : dsaTopics;
  const [expandedTopic, setExpandedTopic] = useState<string | null>(currentTopics[0]?.id || null);
  const [selectedProblem, setSelectedProblem] = useState(currentTopics[0]?.subtopics[0] || null);
  const { sendMessage } = useBabuaAI();

  const handleAskAI = (context: string) => {
    sendMessage(context);
  };

  if (!track) {
    return (
      <Layout>
        <div className="py-20 text-center">
          <h1 className="text-2xl font-bold mb-4">Track not found</h1>
          <Link to="/tracks">
            <Button variant="outline">Back to Tracks</Button>
          </Link>
        </div>
      </Layout>
    );
  }

  const totalCompleted = currentTopics.reduce((acc, t) => acc + t.completed, 0);
  const totalProblems = currentTopics.reduce((acc, t) => acc + t.problems, 0);
  const progressPercent = Math.round((totalCompleted / totalProblems) * 100);

  return (
    <Layout>
      <div className="min-h-screen">
        {/* Header */}
        <div className="border-b border-border bg-secondary/30">
          <div className="container mx-auto px-4 py-6">
            <Link
              to="/tracks"
              className="inline-flex items-center text-sm text-muted-foreground hover:text-foreground mb-4 transition-colors"
            >
              <ArrowLeft className="h-4 w-4 mr-1" />
              All Tracks
            </Link>

            <div className="flex items-start justify-between">
              <div>
                <div className="flex items-center gap-3 mb-2">
                  <span className="text-3xl">{track.icon}</span>
                  <h1 className="text-2xl md:text-3xl font-bold">{track.title}</h1>
                </div>
                <p className="text-muted-foreground max-w-xl">{track.description}</p>
              </div>

              <div className="hidden md:flex items-center gap-4">
                <div className="text-right">
                  <div className="text-2xl font-mono font-bold text-primary">
                    {progressPercent}%
                  </div>
                  <div className="text-xs text-muted-foreground">Complete</div>
                </div>
                <div className="w-24 h-2 bg-secondary rounded-full overflow-hidden">
                  <div
                    className="h-full bg-primary rounded-full"
                    style={{ width: `${progressPercent}%` }}
                  />
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Three Column Layout */}
        <div className="container mx-auto px-4 py-6">
          <div className="grid lg:grid-cols-12 gap-6">
            {/* Left - Topic Tree */}
            <div className="lg:col-span-3">
              <div className="surface-card p-4 sticky top-20">
                <h3 className="font-mono text-sm font-semibold text-muted-foreground mb-4">
                  TOPICS
                </h3>
                <div className="space-y-1">
                  {currentTopics.map((topic) => (
                    <div key={topic.id}>
                      <button
                        onClick={() =>
                          setExpandedTopic(
                            expandedTopic === topic.id ? null : topic.id
                          )
                        }
                        className={`w-full flex items-center justify-between p-2 rounded text-left text-sm transition-colors ${
                          expandedTopic === topic.id
                            ? "bg-primary/10 text-primary"
                            : "hover:bg-secondary"
                        }`}
                      >
                        <div className="flex items-center gap-2">
                          <ChevronDown
                            className={`h-4 w-4 transition-transform ${
                              expandedTopic === topic.id ? "" : "-rotate-90"
                            }`}
                          />
                          <span className="font-medium">{topic.title}</span>
                        </div>
                        <span className="text-xs text-muted-foreground font-mono">
                          {topic.completed}/{topic.problems}
                        </span>
                      </button>

                      {expandedTopic === topic.id && topic.subtopics.length > 0 && (
                        <div className="ml-6 mt-1 space-y-0.5">
                          {topic.subtopics.map((sub) => {
                            const isSolved = solvedProblems.has(sub.id);
                            return (
                              <button
                                key={sub.id}
                                onClick={() => setSelectedProblem(sub)}
                                className={`w-full flex items-center gap-2 p-2 rounded text-left text-sm transition-colors ${
                                  selectedProblem?.id === sub.id
                                    ? "bg-primary/10 text-primary"
                                    : "hover:bg-secondary text-muted-foreground"
                                }`}
                              >
                                {isSolved ? (
                                  <Check className="h-3 w-3 text-primary" />
                                ) : (
                                  <div className="h-3 w-3 rounded-full border border-muted-foreground" />
                                )}
                                <span className="truncate">{sub.title}</span>
                              </button>
                            );
                          })}
                        </div>
                      )}
                    </div>
                  ))}
                </div>
              </div>
            </div>

            {/* Center - Content Preview */}
            <div className="lg:col-span-6">
              {selectedProblem ? (
                <div className="surface-card p-6">
                  <div className="flex items-center justify-between mb-4">
                    <div className="flex-1">
                      <h2 className="text-xl font-bold mb-2">{selectedProblem.title}</h2>
                      <div className="flex items-center gap-2">
                        <DifficultyBadge
                          difficulty={selectedProblem.difficulty as "easy" | "medium" | "hard"}
                        />
                        {(selectedProblem as any).leetcodeUrl && (
                          <a 
                            href={(selectedProblem as any).leetcodeUrl}
                            target="_blank"
                            rel="noopener noreferrer"
                            className="inline-flex items-center gap-1.5 px-3 py-1 rounded-md bg-orange-500/10 hover:bg-orange-500/20 border border-orange-500/30 text-orange-400 text-xs font-mono transition-colors"
                          >
                            <svg className="h-3.5 w-3.5" viewBox="0 0 24 24" fill="currentColor">
                              <path d="M13.483 0a1.374 1.374 0 0 0-.961.438L7.116 6.226l-3.854 4.126a5.266 5.266 0 0 0-1.209 2.104 5.35 5.35 0 0 0-.125.513 5.527 5.527 0 0 0 .062 2.362 5.83 5.83 0 0 0 .349 1.017 5.938 5.938 0 0 0 1.271 1.818l4.277 4.193.039.038c2.248 2.165 5.852 2.133 8.063-.074l2.396-2.392c.54-.54.54-1.414.003-1.955a1.378 1.378 0 0 0-1.951-.003l-2.396 2.392a3.021 3.021 0 0 1-4.205.038l-.02-.019-4.276-4.193c-.652-.64-.972-1.469-.948-2.263a2.68 2.68 0 0 1 .066-.523 2.545 2.545 0 0 1 .619-1.164L9.13 8.114c1.058-1.134 3.204-1.27 4.43-.278l3.501 2.831c.593.48 1.461.387 1.94-.207a1.384 1.384 0 0 0-.207-1.943l-3.5-2.831c-.8-.647-1.766-1.045-2.774-1.202l2.015-2.158A1.384 1.384 0 0 0 13.483 0zm-2.866 12.815a1.38 1.38 0 0 0-1.38 1.382 1.38 1.38 0 0 0 1.38 1.382H20.79a1.38 1.38 0 0 0 1.38-1.382 1.38 1.38 0 0 0-1.38-1.382z"/>
                            </svg>
                            LeetCode
                            <ExternalLink className="h-2.5 w-2.5" />
                          </a>
                        )}
                      </div>
                    </div>
                  </div>

                  <div className="prose prose-invert max-w-none">
                    {(() => {
                      // Try to find detailed problem data
                      const problemDetail = detailedProblems[selectedProblem.id] || 
                                          detailedProblems[parseInt(selectedProblem.id) || 0];
                      
                      if (problemDetail) {
                        // Show actual problem preview
                        return (
                          <>
                            <h3 className="font-mono text-lg font-semibold mb-3">Description</h3>
                            <p className="text-sm text-muted-foreground mb-4 whitespace-pre-line">
                              {problemDetail.description.split('\n\n')[0]}
                            </p>

                            {problemDetail.examples && problemDetail.examples.length > 0 && (
                              <div className="surface-elevated rounded-lg p-4 mb-4">
                                <h4 className="font-mono text-sm font-semibold mb-2">Example:</h4>
                                <div className="space-y-1 text-sm">
                                  <p className="text-green-400">Input: <span className="font-mono">{problemDetail.examples[0].input}</span></p>
                                  <p className="text-blue-400">Output: <span className="font-mono">{problemDetail.examples[0].output}</span></p>
                                  {problemDetail.examples[0].explanation && (
                                    <p className="text-muted-foreground text-xs mt-2">
                                      {problemDetail.examples[0].explanation}
                                    </p>
                                  )}
                                </div>
                              </div>
                            )}

                            {problemDetail.constraints && problemDetail.constraints.length > 0 && (
                              <div className="mb-4">
                                <h4 className="font-mono text-sm font-semibold mb-2">Constraints:</h4>
                                <ul className="text-xs text-muted-foreground space-y-1 list-disc list-inside">
                                  {problemDetail.constraints.slice(0, 3).map((constraint, idx) => (
                                    <li key={idx}>{constraint}</li>
                                  ))}
                                </ul>
                              </div>
                            )}
                          </>
                        );
                      } else {
                        // Show generic preview
                        return (
                          <>
                            <h3 className="font-mono text-lg font-semibold mb-3">Problem Preview</h3>
                            <p className="text-muted-foreground mb-6">
                              Click the "Solve Problem" button below to open the full problem with code editor, test cases, and AI assistance.
                            </p>

                            <div className="surface-elevated rounded-lg p-4 mb-6">
                              <h4 className="font-mono text-sm font-semibold mb-2">Problem: {selectedProblem.title}</h4>
                              <p className="text-sm text-muted-foreground mb-3">
                                Difficulty: <span className="inline-block"><DifficultyBadge difficulty={selectedProblem.difficulty as "easy" | "medium" | "hard"} /></span>
                              </p>
                              <p className="text-sm text-muted-foreground">
                                This problem is part of the Strivers A2Z DSA Sheet. Click "Solve Problem" to:
                              </p>
                              <ul className="text-sm text-muted-foreground space-y-1 list-disc list-inside mt-2">
                                <li>View the complete problem statement with examples</li>
                                <li>Access the Monaco code editor</li>
                                <li>Run test cases and get instant feedback</li>
                                <li>Get AI hints and explanations</li>
                                <li>Submit your solution</li>
                              </ul>
                            </div>
                          </>
                        );
                      }
                    })()}

                    <div className="bg-secondary/50 rounded-lg p-4 border border-border">
                      <p className="text-xs text-muted-foreground">
                        💡 <strong>Tip:</strong> Try solving the problem on your own first. Use AI assistance when you're stuck!
                      </p>
                    </div>
                  </div>

                  <div className="flex items-center gap-3 mt-8 pt-6 border-t border-border">
                    {solvedProblems.has(selectedProblem.id) ? (
                      <Button 
                        className="font-mono bg-green-600 hover:bg-green-700" 
                        size="lg"
                        disabled
                      >
                        <CheckCircle className="mr-2 h-4 w-4" />
                        Completed
                      </Button>
                    ) : (
                      <Button 
                        className="font-mono" 
                        size="lg"
                        onClick={handleMarkComplete}
                        disabled={markingComplete}
                      >
                        <CheckCircle className="mr-2 h-4 w-4" />
                        {markingComplete ? "Marking..." : "Mark as Complete"}
                      </Button>
                    )}
                    <Link to={`/problem/${selectedProblem.id}`}>
                      <Button variant="outline" className="font-mono" size="lg">
                        <ChevronRight className="mr-2 h-4 w-4" />
                        Solve Problem
                      </Button>
                    </Link>
                    <Button variant="outline" className="font-mono">
                      <BookmarkPlus className="mr-2 h-4 w-4" />
                      Add to Revision
                    </Button>
                    <Button 
                      variant="outline" 
                      className="font-mono ml-auto"
                      onClick={() => handleAskAI(`Can you explain the ${selectedProblem?.title} problem and give me hints to solve it?`)}
                    >
                      <Bot className="mr-2 h-4 w-4" />
                      Ask AI
                    </Button>
                  </div>
                </div>
              ) : (
                <div className="surface-card p-12 text-center">
                  <p className="text-muted-foreground">
                    Select a topic from the left to view content
                  </p>
                </div>
              )}
            </div>

            {/* Right - Quick Actions */}
            <div className="lg:col-span-3">
              <div className="space-y-4 sticky top-20">
                {/* Quick Actions */}
                <div className="surface-card p-4">
                  <h3 className="font-mono text-sm font-semibold text-muted-foreground mb-4">
                    QUICK ACTIONS
                  </h3>
                  <div className="space-y-2">
                    <Button variant="outline" className="w-full justify-start font-mono text-sm">
                      <MessageSquare className="mr-2 h-4 w-4" />
                      Ask Community
                    </Button>
                    <Button variant="outline" className="w-full justify-start font-mono text-sm">
                      Random Problem
                    </Button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* AI Chat with selected problem context */}
        <BabuaAIChat 
          problem={selectedProblem?.id ? (
            detailedProblems[selectedProblem.id] || 
            detailedProblems[parseInt(selectedProblem.id) || 0] ||
            // If no detailed problem found, create a minimal problem object from subtopic
            {
              id: selectedProblem.id,
              title: selectedProblem.title,
              slug: selectedProblem.id,
              difficulty: selectedProblem.difficulty as "easy" | "medium" | "hard",
              description: `This is the ${selectedProblem.title} problem. Click "Solve Problem" to see the full details.`,
              examples: [],
              constraints: [],
              tags: [],
              track: "DSA",
              starterCode: {},
              testCases: [],
              hints: [],
              solved: false
            }
          ) : undefined}
        />
      </div>
    </Layout>
  );
}
