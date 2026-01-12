import { useState } from "react";
import { Layout } from "@/components/layout/Layout";
import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Textarea } from "@/components/ui/textarea";
import { Input } from "@/components/ui/input";
import { DifficultyBadge } from "@/components/ui/DifficultyBadge";
import { Avatar } from "@/components/ui/avatar";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription } from "@/components/ui/dialog";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Label } from "@/components/ui/label";
import { useToast } from "@/hooks/use-toast";
import { 
  MessageSquare, 
  ThumbsUp, 
  MessageCircle, 
  Search, 
  Filter,
  TrendingUp,
  Clock,
  CheckCircle2,
  Bot,
  Send,
  Code,
  X,
  ThumbsDown
} from "lucide-react";
import { useBabuaAI } from "@/hooks/useBabuaAI";
import { BabuaAIChat } from "@/components/ai/BabuaAIChat";

interface Reply {
  id: number;
  user: string;
  avatar: string;
  content: string;
  code?: string;
  upvotes: number;
  downvotes: number;
  timeAgo: string;
  isAccepted?: boolean;
}

interface Doubt {
  id: number;
  user: string;
  avatar: string;
  title: string;
  description: string;
  problem?: string;
  difficulty?: string;
  tags: string[];
  upvotes: number;
  replies: Reply[];
  timeAgo: string;
  status: "open" | "solved";
  code?: string;
}

export default function DoubtArena() {
  const [activeTab, setActiveTab] = useState("feed");
  const [searchQuery, setSearchQuery] = useState("");
  const [showAIChat, setShowAIChat] = useState(false);
  const [showPostDialog, setShowPostDialog] = useState(false);
  const [selectedDoubt, setSelectedDoubt] = useState<Doubt | null>(null);
  const [replyingTo, setReplyingTo] = useState<number | null>(null);
  const { sendMessage } = useBabuaAI();
  const { toast } = useToast();

  // New doubt form state
  const [newDoubt, setNewDoubt] = useState({
    title: "",
    description: "",
    code: "",
    problem: "",
    difficulty: "medium" as "easy" | "medium" | "hard",
    tags: [] as string[],
  });

  // Reply form state
  const [replyContent, setReplyContent] = useState("");
  const [replyCode, setReplyCode] = useState("");

  const [doubts, setDoubts] = useState<Doubt[]>([
    {
      id: 1,
      user: "code_seeker",
      avatar: "CS",
      title: "How to optimize dynamic programming space complexity?",
      description: "I understand how to write DP solutions but they always use O(n²) space. How do I reduce it to O(n)?",
      problem: "Longest Common Subsequence",
      difficulty: "medium",
      tags: ["Dynamic Programming", "Space Optimization"],
      upvotes: 24,
      replies: [
        {
          id: 1,
          user: "dp_expert",
          avatar: "DE",
          content: "You can optimize space by using rolling arrays. Instead of storing the entire 2D array, you only need to keep track of the previous row.",
          code: "def lcs(s1, s2):\n  prev = [0] * (len(s2) + 1)\n  curr = [0] * (len(s2) + 1)\n  for i in range(1, len(s1) + 1):\n    for j in range(1, len(s2) + 1):\n      if s1[i-1] == s2[j-1]:\n        curr[j] = prev[j-1] + 1\n      else:\n        curr[j] = max(prev[j], curr[j-1])\n    prev, curr = curr, [0] * (len(s2) + 1)\n  return prev[-1]",
          upvotes: 15,
          downvotes: 0,
          timeAgo: "1 hour ago",
          isAccepted: true
        }
      ],
      timeAgo: "2 hours ago",
      status: "solved",
      code: "def lcs(s1, s2):\n  dp = [[0]*(len(s2)+1) for _ in range(len(s1)+1)]\n  # ..."
    },
    {
      id: 2,
      user: "algo_learner",
      avatar: "AL",
      title: "Stack overflow in recursive tree traversal",
      description: "My inorder traversal works for small trees but crashes on large ones. Is this a recursion depth issue?",
      problem: "Binary Tree Inorder",
      difficulty: "easy",
      tags: ["Trees", "Recursion", "Stack"],
      upvotes: 15,
      replies: [
        {
          id: 2,
          user: "tree_master",
          avatar: "TM",
          content: "Yes, it's a recursion depth issue. Use iterative approach with explicit stack instead.",
          code: "function inorder(root) {\n  const stack = [];\n  let curr = root;\n  while (curr || stack.length) {\n    while (curr) {\n      stack.push(curr);\n      curr = curr.left;\n    }\n    curr = stack.pop();\n    console.log(curr.val);\n    curr = curr.right;\n  }\n}",
          upvotes: 22,
          downvotes: 1,
          timeAgo: "4 hours ago",
          isAccepted: true
        }
      ],
      timeAgo: "5 hours ago",
      status: "solved",
      code: "function inorder(root) {\n  if (!root) return;\n  inorder(root.left);\n  console.log(root.val);\n  inorder(root.right);\n}"
    },
    {
      id: 3,
      user: "debug_master",
      avatar: "DM",
      title: "Why is my sliding window solution giving wrong output?",
      description: "I'm trying to find the longest substring without repeating characters but getting incorrect results for some test cases.",
      problem: "Longest Substring Without Repeating",
      difficulty: "medium",
      tags: ["Sliding Window", "Hash Map", "Debugging"],
      upvotes: 31,
      replies: [],
      timeAgo: "1 day ago",
      status: "open"
    },
  ]);

  const trendingTopics = [
    { topic: "Dynamic Programming", questions: 127 },
    { topic: "Graph Algorithms", questions: 89 },
    { topic: "Binary Search", questions: 76 },
    { topic: "Backtracking", questions: 54 },
  ];

  const handleAskAI = (doubtTitle: string, doubtCode?: string) => {
    const context = doubtCode 
      ? `I have a doubt about: ${doubtTitle}\n\nCode:\n${doubtCode}\n\nCan you help explain what might be wrong?`
      : `Can you help me understand: ${doubtTitle}`;
    setShowAIChat(true);
    setTimeout(() => sendMessage(context), 100);
  };

  const handleQuickAnswer = (doubtId: number) => {
    const doubt = doubts.find(d => d.id === doubtId);
    if (doubt) {
      setShowAIChat(true);
      setTimeout(() => {
        sendMessage(
          `Someone asked: "${doubt.title}"\n\nDescription: ${doubt.description}\n\nCan you provide a clear, concise answer with code examples if needed?`
        );
      }, 100);
    }
  };

  const handlePostDoubt = () => {
    if (!newDoubt.title || !newDoubt.description) {
      toast({
        title: "Missing Information",
        description: "Please fill in title and description",
        variant: "destructive"
      });
      return;
    }

    const doubt: Doubt = {
      id: doubts.length + 1,
      user: "you",
      avatar: "YO",
      title: newDoubt.title,
      description: newDoubt.description,
      code: newDoubt.code,
      problem: newDoubt.problem,
      difficulty: newDoubt.difficulty,
      tags: newDoubt.tags.length > 0 ? newDoubt.tags : ["General"],
      upvotes: 0,
      replies: [],
      timeAgo: "Just now",
      status: "open"
    };

    setDoubts([doubt, ...doubts]);
    setShowPostDialog(false);
    setNewDoubt({
      title: "",
      description: "",
      code: "",
      problem: "",
      difficulty: "medium",
      tags: [],
    });

    toast({
      title: "Question Posted!",
      description: "Your doubt has been posted successfully"
    });
  };

  const handlePostReply = (doubtId: number) => {
    if (!replyContent) {
      toast({
        title: "Empty Reply",
        description: "Please write a reply",
        variant: "destructive"
      });
      return;
    }

    const reply: Reply = {
      id: Date.now(),
      user: "you",
      avatar: "YO",
      content: replyContent,
      code: replyCode,
      upvotes: 0,
      downvotes: 0,
      timeAgo: "Just now"
    };

    setDoubts(doubts.map(doubt => 
      doubt.id === doubtId 
        ? { ...doubt, replies: [...doubt.replies, reply] }
        : doubt
    ));

    setReplyContent("");
    setReplyCode("");
    setReplyingTo(null);

    toast({
      title: "Reply Posted!",
      description: "Your reply has been added"
    });
  };

  const handleVoteDoubt = (doubtId: number, increment: boolean) => {
    setDoubts(doubts.map(doubt => 
      doubt.id === doubtId 
        ? { ...doubt, upvotes: doubt.upvotes + (increment ? 1 : -1) }
        : doubt
    ));
  };

  const handleVoteReply = (doubtId: number, replyId: number, isUpvote: boolean) => {
    setDoubts(doubts.map(doubt => {
      if (doubt.id === doubtId) {
        return {
          ...doubt,
          replies: doubt.replies.map(reply => {
            if (reply.id === replyId) {
              return {
                ...reply,
                upvotes: isUpvote ? reply.upvotes + 1 : reply.upvotes,
                downvotes: !isUpvote ? reply.downvotes + 1 : reply.downvotes
              };
            }
            return reply;
          })
        };
      }
      return doubt;
    }));
  };

  const handleMarkAsSolved = (doubtId: number, replyId: number) => {
    setDoubts(doubts.map(doubt => {
      if (doubt.id === doubtId) {
        return {
          ...doubt,
          status: "solved" as const,
          replies: doubt.replies.map(reply => ({
            ...reply,
            isAccepted: reply.id === replyId
          }))
        };
      }
      return doubt;
    }));

    toast({
      title: "Marked as Solved!",
      description: "The answer has been accepted"
    });
  };

  const filteredDoubts = doubts.filter(doubt => {
    const matchesSearch = doubt.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
                          doubt.description.toLowerCase().includes(searchQuery.toLowerCase());
    const matchesTab = activeTab === "feed" || 
                       (activeTab === "unsolved" && doubt.status === "open") ||
                       (activeTab === "my-doubts" && doubt.user === "you");
    return matchesSearch && matchesTab;
  });

  return (
    <Layout>
      <div className="py-12">
        <div className="container mx-auto px-4">
          {/* Header */}
          <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-8">
            <div>
              <h1 className="text-3xl md:text-4xl font-bold mb-2 flex items-center gap-3">
                <MessageSquare className="h-8 w-8 text-primary" />
                Doubt Arena
              </h1>
              <p className="text-muted-foreground">
                Ask questions. Help others. Learn together.
              </p>
            </div>
            <Button size="lg" onClick={() => setShowPostDialog(true)}>
              <Send className="h-4 w-4 mr-2" />
              Ask a Question
            </Button>
          </div>

          <div className="grid lg:grid-cols-4 gap-6">
            {/* Main Content */}
            <div className="lg:col-span-3">
              {/* Search & Filter */}
              <div className="flex gap-4 mb-6">
                <div className="relative flex-1">
                  <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                  <Input
                    placeholder="Search doubts..."
                    value={searchQuery}
                    onChange={(e) => setSearchQuery(e.target.value)}
                    className="pl-9 bg-secondary border-border"
                  />
                </div>
                <Button variant="outline">
                  <Filter className="h-4 w-4 mr-2" />
                  Filter
                </Button>
              </div>

              <Tabs value={activeTab} onValueChange={setActiveTab} className="mb-6">
                <TabsList>
                  <TabsTrigger value="feed" className="font-mono">All Questions</TabsTrigger>
                  <TabsTrigger value="unsolved" className="font-mono">Unsolved</TabsTrigger>
                  <TabsTrigger value="my-doubts" className="font-mono">My Doubts</TabsTrigger>
                </TabsList>
              </Tabs>

              {/* Doubt Cards */}
              <div className="space-y-4">
                {filteredDoubts.map((doubt) => (
                  <Card key={doubt.id} className="p-6 bg-surface hover:border-primary/50 transition-colors">
                    <div className="flex gap-4">
                      {/* Vote Section */}
                      <div className="flex flex-col items-center gap-2">
                        <Button 
                          variant="ghost" 
                          size="sm" 
                          className="h-8 w-8 p-0"
                          onClick={() => handleVoteDoubt(doubt.id, true)}
                        >
                          <ThumbsUp className="h-4 w-4" />
                        </Button>
                        <span className="font-mono text-sm font-bold">{doubt.upvotes}</span>
                        <Button 
                          variant="ghost" 
                          size="sm" 
                          className="h-8 w-8 p-0"
                          onClick={() => handleVoteDoubt(doubt.id, false)}
                        >
                          <ThumbsDown className="h-4 w-4" />
                        </Button>
                      </div>

                      {/* Content */}
                      <div className="flex-1">
                        <div className="flex items-start justify-between mb-2">
                          <div className="flex-1">
                            <div className="flex items-center gap-2 mb-2">
                              {doubt.status === "solved" && (
                                <CheckCircle2 className="h-5 w-5 text-green-400" />
                              )}
                              <h3 
                                className="text-lg font-bold hover:text-primary cursor-pointer"
                                onClick={() => setSelectedDoubt(doubt)}
                              >
                                {doubt.title}
                              </h3>
                            </div>
                            <p className="text-muted-foreground text-sm mb-3">
                              {doubt.description}
                            </p>
                            {doubt.code && (
                              <Card className="p-3 bg-background/50 mb-3">
                                <pre className="text-xs font-mono overflow-x-auto">
                                  {doubt.code}
                                </pre>
                              </Card>
                            )}
                            <div className="flex items-center gap-2 mb-3 flex-wrap">
                              {doubt.problem && (
                                <Badge variant="outline" className="font-mono text-xs">
                                  {doubt.problem}
                                </Badge>
                              )}
                              {doubt.difficulty && (
                                <DifficultyBadge difficulty={doubt.difficulty as "easy" | "medium" | "hard"} />
                              )}
                              {doubt.tags.map((tag) => (
                                <Badge key={tag} variant="secondary" className="text-xs">
                                  {tag}
                                </Badge>
                              ))}
                            </div>
                            <div className="flex items-center gap-4 text-sm text-muted-foreground">
                              <div className="flex items-center gap-1">
                                <span className="font-mono">{doubt.user}</span>
                              </div>
                              <div className="flex items-center gap-1">
                                <Clock className="h-3 w-3" />
                                {doubt.timeAgo}
                              </div>
                              <div className="flex items-center gap-1">
                                <MessageCircle className="h-3 w-3" />
                                {doubt.replies.length} replies
                              </div>
                            </div>
                          </div>
                        </div>
                        <div className="flex gap-2 mt-4">
                          <Button 
                            variant="outline" 
                            size="sm"
                            onClick={() => setSelectedDoubt(doubt)}
                          >
                            <MessageCircle className="h-4 w-4 mr-2" />
                            View & Reply
                          </Button>
                          <Button 
                            variant="outline" 
                            size="sm"
                            onClick={() => handleAskAI(doubt.title, doubt.code)}
                          >
                            <Bot className="h-4 w-4 mr-2" />
                            Ask AI
                          </Button>
                          {doubt.status === "open" && (
                            <Button 
                              variant="ghost" 
                              size="sm"
                              onClick={() => handleQuickAnswer(doubt.id)}
                            >
                              <Bot className="h-4 w-4 mr-2" />
                              Get AI Answer
                            </Button>
                          )}
                        </div>
                      </div>
                    </div>
                  </Card>
                ))}
              </div>
            </div>

            {/* Sidebar */}
            <div className="space-y-6">
              {/* Trending Topics */}
              <Card className="p-4 bg-surface">
                <h3 className="font-mono text-sm font-semibold text-muted-foreground mb-4 flex items-center gap-2">
                  <TrendingUp className="h-4 w-4 text-primary" />
                  TRENDING TOPICS
                </h3>
                <div className="space-y-2">
                  {trendingTopics.map((topic) => (
                    <button
                      key={topic.topic}
                      className="w-full text-left p-3 rounded bg-secondary/50 hover:bg-secondary transition-colors"
                    >
                      <div className="font-medium text-sm">{topic.topic}</div>
                      <div className="text-xs text-muted-foreground font-mono">
                        {topic.questions} questions
                      </div>
                    </button>
                  ))}
                </div>
              </Card>

              {/* Quick Stats */}
              <Card className="p-4 bg-surface">
                <h3 className="font-mono text-sm font-semibold text-muted-foreground mb-4">
                  YOUR STATS
                </h3>
                <div className="space-y-3">
                  <div className="flex items-center justify-between">
                    <span className="text-sm text-muted-foreground">Questions Asked</span>
                    <span className="font-mono font-bold">8</span>
                  </div>
                  <div className="flex items-center justify-between">
                    <span className="text-sm text-muted-foreground">Answers Given</span>
                    <span className="font-mono font-bold">23</span>
                  </div>
                  <div className="flex items-center justify-between">
                    <span className="text-sm text-muted-foreground">Helpful Votes</span>
                    <span className="font-mono font-bold text-primary">156</span>
                  </div>
                </div>
              </Card>

              {/* AI Help */}
              <Card className="p-4 bg-primary/10 border-primary/20">
                <h3 className="font-mono text-sm font-semibold mb-2 flex items-center gap-2">
                  <Bot className="h-4 w-4 text-primary" />
                  Babua AI
                </h3>
                <p className="text-xs text-muted-foreground mb-3">
                  Can't find your answer? Ask Babua AI for instant help!
                </p>
                <Button 
                  variant="outline" 
                  size="sm" 
                  className="w-full"
                  onClick={() => setShowAIChat(true)}
                >
                  <Bot className="h-4 w-4 mr-2" />
                  Ask AI Now
                </Button>
              </Card>
            </div>
          </div>
        </div>
      </div>

      {/* Post Doubt Dialog */}
      <Dialog open={showPostDialog} onOpenChange={setShowPostDialog}>
        <DialogContent className="max-w-2xl !fixed !left-[50%] !top-[50%] !-translate-x-1/2 !-translate-y-1/2 max-h-[90vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle>Ask a Question</DialogTitle>
            <DialogDescription>
              Describe your doubt clearly. Include code snippets if relevant.
            </DialogDescription>
          </DialogHeader>
          <div className="space-y-4 mt-4">
            <div>
              <Label htmlFor="title">Title *</Label>
              <Input
                id="title"
                placeholder="What's your question?"
                value={newDoubt.title}
                onChange={(e) => setNewDoubt({ ...newDoubt, title: e.target.value })}
                className="mt-1"
              />
            </div>
            <div>
              <Label htmlFor="description">Description *</Label>
              <Textarea
                id="description"
                placeholder="Explain your doubt in detail..."
                value={newDoubt.description}
                onChange={(e) => setNewDoubt({ ...newDoubt, description: e.target.value })}
                rows={4}
                className="mt-1"
              />
            </div>
            <div>
              <Label htmlFor="code">Code (Optional)</Label>
              <Textarea
                id="code"
                placeholder="Paste your code here..."
                value={newDoubt.code}
                onChange={(e) => setNewDoubt({ ...newDoubt, code: e.target.value })}
                rows={6}
                className="mt-1 font-mono text-sm"
              />
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div>
                <Label htmlFor="problem">Related Problem (Optional)</Label>
                <Input
                  id="problem"
                  placeholder="e.g., Two Sum"
                  value={newDoubt.problem}
                  onChange={(e) => setNewDoubt({ ...newDoubt, problem: e.target.value })}
                  className="mt-1"
                />
              </div>
              <div>
                <Label htmlFor="difficulty">Difficulty</Label>
                <Select
                  value={newDoubt.difficulty}
                  onValueChange={(value: "easy" | "medium" | "hard") => 
                    setNewDoubt({ ...newDoubt, difficulty: value })
                  }
                >
                  <SelectTrigger className="mt-1">
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="easy">Easy</SelectItem>
                    <SelectItem value="medium">Medium</SelectItem>
                    <SelectItem value="hard">Hard</SelectItem>
                  </SelectContent>
                </Select>
              </div>
            </div>
            <div>
              <Label htmlFor="tags">Tags (comma-separated)</Label>
              <Input
                id="tags"
                placeholder="e.g., Arrays, Dynamic Programming"
                onChange={(e) => setNewDoubt({ 
                  ...newDoubt, 
                  tags: e.target.value.split(',').map(t => t.trim()).filter(Boolean)
                })}
                className="mt-1"
              />
            </div>
            <div className="flex gap-2 justify-end">
              <Button variant="outline" onClick={() => setShowPostDialog(false)}>
                Cancel
              </Button>
              <Button onClick={handlePostDoubt}>
                <Send className="h-4 w-4 mr-2" />
                Post Question
              </Button>
            </div>
          </div>
        </DialogContent>
      </Dialog>

      {/* View Doubt Dialog */}
      {selectedDoubt && (
        <Dialog open={!!selectedDoubt} onOpenChange={() => setSelectedDoubt(null)}>
          <DialogContent className="max-w-4xl !fixed !left-[50%] !top-[50%] !-translate-x-1/2 !-translate-y-1/2 max-h-[85vh] overflow-hidden">
            <DialogHeader>
              <div className="flex items-start justify-between gap-4">
                <div className="flex-1">
                  <DialogTitle className="text-xl mb-3 pr-8">
                    {selectedDoubt.status === "solved" && (
                      <CheckCircle2 className="h-5 w-5 text-green-400 inline mr-2" />
                    )}
                    {selectedDoubt.title}
                  </DialogTitle>
                  <div className="flex items-center gap-2 flex-wrap">
                    {selectedDoubt.problem && (
                      <Badge variant="outline" className="font-mono text-xs">
                        {selectedDoubt.problem}
                      </Badge>
                    )}
                    {selectedDoubt.difficulty && (
                      <DifficultyBadge difficulty={selectedDoubt.difficulty as "easy" | "medium" | "hard"} />
                    )}
                    {selectedDoubt.tags.map((tag) => (
                      <Badge key={tag} variant="secondary" className="text-xs">
                        {tag}
                      </Badge>
                    ))}
                  </div>
                </div>
                <Button
                  variant="ghost"
                  size="sm"
                  className="flex-shrink-0 -mr-2 -mt-2"
                  onClick={() => setSelectedDoubt(null)}
                >
                  <X className="h-4 w-4" />
                </Button>
              </div>
            </DialogHeader>

            <div className="overflow-y-auto space-y-6 pr-2 -mx-1 px-1" style={{ maxHeight: 'calc(85vh - 120px)' }}>
              {/* Question */}
              <div className="pt-4">
                <div className="flex items-center gap-2 mb-3 text-sm text-muted-foreground">
                  <span className="font-mono font-semibold">{selectedDoubt.user}</span>
                  <span>•</span>
                  <span>{selectedDoubt.timeAgo}</span>
                </div>
                <p className="text-muted-foreground mb-4">{selectedDoubt.description}</p>
                {selectedDoubt.code && (
                  <Card className="p-4 bg-background/50 mb-4">
                    <pre className="text-sm font-mono overflow-x-auto whitespace-pre-wrap">
                      {selectedDoubt.code}
                    </pre>
                  </Card>
                )}
                <div className="flex items-center gap-2">
                  <Button 
                    variant="ghost" 
                    size="sm"
                    onClick={() => handleVoteDoubt(selectedDoubt.id, true)}
                  >
                    <ThumbsUp className="h-4 w-4 mr-1" />
                    {selectedDoubt.upvotes}
                  </Button>
                </div>
              </div>

              {/* Answers Section */}
              <div className="border-t pt-6">
                <h3 className="font-semibold mb-4 text-lg">
                  {selectedDoubt.replies.length} {selectedDoubt.replies.length === 1 ? 'Answer' : 'Answers'}
                </h3>

                {/* Replies List */}
                {selectedDoubt.replies.length > 0 ? (
                  <div className="space-y-4 mb-6">
                    {selectedDoubt.replies.map((reply) => (
                      <Card key={reply.id} className={`p-4 ${reply.isAccepted ? 'border-green-400 bg-green-400/5' : ''}`}>
                        <div className="flex gap-4">
                          <div className="flex flex-col items-center gap-2 flex-shrink-0">
                            <Button 
                              variant="ghost" 
                              size="sm" 
                              className="h-8 w-8 p-0"
                              onClick={() => handleVoteReply(selectedDoubt.id, reply.id, true)}
                            >
                              <ThumbsUp className="h-4 w-4" />
                            </Button>
                            <span className="font-mono text-sm font-semibold">{reply.upvotes}</span>
                            <Button 
                              variant="ghost" 
                              size="sm" 
                              className="h-8 w-8 p-0"
                              onClick={() => handleVoteReply(selectedDoubt.id, reply.id, false)}
                            >
                              <ThumbsDown className="h-4 w-4" />
                            </Button>
                          </div>
                          <div className="flex-1 min-w-0">
                            {reply.isAccepted && (
                              <Badge className="mb-2 bg-green-500 text-white">
                                <CheckCircle2 className="h-3 w-3 mr-1" />
                                Accepted Answer
                              </Badge>
                            )}
                            <div className="flex items-center gap-2 mb-2 text-sm text-muted-foreground">
                              <span className="font-mono font-semibold">{reply.user}</span>
                              <span>•</span>
                              <span>{reply.timeAgo}</span>
                            </div>
                            <p className="text-sm mb-3 leading-relaxed">{reply.content}</p>
                            {reply.code && (
                              <Card className="p-3 bg-background/50 mb-3">
                                <pre className="text-xs font-mono overflow-x-auto whitespace-pre-wrap">
                                  {reply.code}
                                </pre>
                              </Card>
                            )}
                            {!reply.isAccepted && selectedDoubt.user === "you" && selectedDoubt.status === "open" && (
                              <Button 
                                variant="outline" 
                                size="sm"
                                onClick={() => handleMarkAsSolved(selectedDoubt.id, reply.id)}
                              >
                                <CheckCircle2 className="h-4 w-4 mr-2" />
                                Accept Answer
                              </Button>
                            )}
                          </div>
                        </div>
                      </Card>
                    ))}
                  </div>
                ) : (
                  <div className="text-center py-8 text-muted-foreground">
                    <MessageCircle className="h-12 w-12 mx-auto mb-2 opacity-50" />
                    <p>No answers yet. Be the first to answer!</p>
                  </div>
                )}

                {/* Reply Form */}
                <Card className="p-4 bg-surface mt-4">
                  <h4 className="font-semibold mb-3">Your Answer</h4>
                  <Textarea
                    placeholder="Write your answer here..."
                    value={replyContent}
                    onChange={(e) => setReplyContent(e.target.value)}
                    rows={3}
                    className="mb-3"
                  />
                  <details className="mb-3">
                    <summary className="text-sm text-muted-foreground cursor-pointer mb-2">
                      Add code snippet (optional)
                    </summary>
                    <Textarea
                      placeholder="Paste your code here..."
                      value={replyCode}
                      onChange={(e) => setReplyCode(e.target.value)}
                      rows={4}
                      className="font-mono text-sm"
                    />
                  </details>
                  <div className="flex gap-2 justify-end">
                    <Button
                      variant="outline"
                      size="sm"
                      onClick={() => {
                        setReplyContent("");
                        setReplyCode("");
                      }}
                    >
                      Clear
                    </Button>
                    <Button onClick={() => handlePostReply(selectedDoubt.id)}>
                      <Send className="h-4 w-4 mr-2" />
                      Post Answer
                    </Button>
                  </div>
                </Card>
              </div>
            </div>
          </DialogContent>
        </Dialog>
      )}

      {showAIChat && <BabuaAIChat />}
    </Layout>
  );
}
