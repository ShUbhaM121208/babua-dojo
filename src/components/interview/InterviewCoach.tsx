import { useState, useEffect, useRef } from "react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card";
import { Textarea } from "@/components/ui/textarea";
import { Badge } from "@/components/ui/badge";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Separator } from "@/components/ui/separator";
import { useToast } from "@/hooks/use-toast";
import {
  startInterviewSession,
  sendInterviewMessage,
  getInterviewerGreeting,
  submitCodeForInterview,
  endInterviewSession,
  ConversationMessage,
  InterviewEvaluation,
  InterviewSession
} from "@/services/interviewCoachService";
import { 
  MessageSquare, 
  Send, 
  Lightbulb, 
  CheckCircle2, 
  XCircle, 
  Star,
  Trophy,
  TrendingUp,
  AlertCircle,
  Clock,
  Code
} from "lucide-react";
import ReactMarkdown from "react-markdown";

interface InterviewCoachProps {
  problemId: string;
  problemTitle: string;
  problemDescription: string;
  language: string;
  code: string;
  testsPassed: boolean;
  onClose: () => void;
}

export function InterviewCoach({
  problemId,
  problemTitle,
  problemDescription,
  language,
  code,
  testsPassed,
  onClose
}: InterviewCoachProps) {
  const [session, setSession] = useState<InterviewSession | null>(null);
  const [messages, setMessages] = useState<ConversationMessage[]>([]);
  const [currentMessage, setCurrentMessage] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const [isStarting, setIsStarting] = useState(true);
  const [evaluation, setEvaluation] = useState<InterviewEvaluation | null>(null);
  const [showEvaluation, setShowEvaluation] = useState(false);
  const [elapsedTime, setElapsedTime] = useState(0);
  const { toast } = useToast();
  const messagesEndRef = useRef<HTMLDivElement>(null);
  const timerRef = useRef<NodeJS.Timeout>();

  // Auto-scroll to bottom when new messages arrive
  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  };

  useEffect(() => {
    scrollToBottom();
  }, [messages]);

  // Timer for elapsed time
  useEffect(() => {
    if (session && session.status === 'active') {
      timerRef.current = setInterval(() => {
        setElapsedTime(prev => prev + 1);
      }, 1000);
    }

    return () => {
      if (timerRef.current) {
        clearInterval(timerRef.current);
      }
    };
  }, [session]);

  // Start interview session
  useEffect(() => {
    const initInterview = async () => {
      try {
        setIsStarting(true);
        const newSession = await startInterviewSession(problemId, language);
        setSession(newSession);

        // Get initial greeting
        const greeting = await getInterviewerGreeting(
          newSession.id,
          problemTitle,
          problemDescription
        );
        setMessages([greeting]);
      } catch (error) {
        console.error("Failed to start interview:", error);
        toast({
          title: "Failed to start interview",
          description: "Please try again later",
          variant: "destructive"
        });
        onClose();
      } finally {
        setIsStarting(false);
      }
    };

    initInterview();
  }, [problemId, problemTitle, problemDescription, language, toast, onClose]);

  // Send message
  const handleSendMessage = async () => {
    if (!currentMessage.trim() || !session || isLoading) return;

    const userMessage: ConversationMessage = {
      role: 'candidate',
      message: currentMessage,
      timestamp: new Date().toISOString()
    };

    setMessages(prev => [...prev, userMessage]);
    setCurrentMessage("");
    setIsLoading(true);

    try {
      const response = await sendInterviewMessage(
        session.id,
        currentMessage,
        problemTitle,
        problemDescription
      );
      setMessages(prev => [...prev, response]);
    } catch (error) {
      console.error("Failed to send message:", error);
      toast({
        title: "Failed to send message",
        description: "Please try again",
        variant: "destructive"
      });
    } finally {
      setIsLoading(false);
    }
  };

  // Submit code
  const handleSubmitCode = async () => {
    if (!session || isLoading) return;

    setIsLoading(true);
    try {
      const response = await submitCodeForInterview(
        session.id,
        code,
        problemTitle,
        problemDescription,
        testsPassed
      );
      setMessages(prev => [...prev, response]);
      
      toast({
        title: "Code submitted",
        description: "The interviewer is reviewing your solution"
      });
    } catch (error) {
      console.error("Failed to submit code:", error);
      toast({
        title: "Failed to submit code",
        description: "Please try again",
        variant: "destructive"
      });
    } finally {
      setIsLoading(false);
    }
  };

  // End interview
  const handleEndInterview = async () => {
    if (!session) return;

    setIsLoading(true);
    try {
      const evalResult = await endInterviewSession(
        session.id,
        problemTitle,
        problemDescription
      );
      setEvaluation(evalResult);
      setShowEvaluation(true);
    } catch (error) {
      console.error("Failed to end interview:", error);
      toast({
        title: "Failed to get evaluation",
        description: "Please try again",
        variant: "destructive"
      });
    } finally {
      setIsLoading(false);
    }
  };

  // Format elapsed time
  const formatTime = (seconds: number) => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins}:${secs.toString().padStart(2, '0')}`;
  };

  // Score color
  const getScoreColor = (score: number) => {
    if (score >= 4) return "text-green-600";
    if (score >= 3) return "text-yellow-600";
    return "text-red-600";
  };

  // Loading state
  if (isStarting) {
    return (
      <Card className="h-full flex items-center justify-center">
        <CardContent>
          <div className="text-center space-y-4">
            <MessageSquare className="w-12 h-12 animate-pulse mx-auto text-primary" />
            <p className="text-lg font-medium">Starting your interview session...</p>
            <p className="text-sm text-muted-foreground">The interviewer will be with you shortly</p>
          </div>
        </CardContent>
      </Card>
    );
  }

  // Evaluation view
  if (showEvaluation && evaluation) {
    return (
      <Card className="h-full">
        <CardHeader>
          <div className="flex items-center justify-between">
            <div>
              <CardTitle className="flex items-center gap-2">
                <Trophy className="w-6 h-6 text-yellow-500" />
                Interview Complete
              </CardTitle>
              <CardDescription>Here's your performance evaluation</CardDescription>
            </div>
            <Badge variant="outline" className="text-lg">
              Overall: {evaluation.overallScore.toFixed(1)}/5.0
            </Badge>
          </div>
        </CardHeader>

        <CardContent>
          <ScrollArea className="h-[500px] pr-4">
            <div className="space-y-6">
              {/* Scores */}
              <div className="grid grid-cols-3 gap-4">
                <Card>
                  <CardHeader className="pb-3">
                    <CardTitle className="text-sm font-medium">Communication</CardTitle>
                  </CardHeader>
                  <CardContent>
                    <div className={`text-3xl font-bold ${getScoreColor(evaluation.communicationScore)}`}>
                      {evaluation.communicationScore}/5
                    </div>
                  </CardContent>
                </Card>

                <Card>
                  <CardHeader className="pb-3">
                    <CardTitle className="text-sm font-medium">Problem Solving</CardTitle>
                  </CardHeader>
                  <CardContent>
                    <div className={`text-3xl font-bold ${getScoreColor(evaluation.problemSolvingScore)}`}>
                      {evaluation.problemSolvingScore}/5
                    </div>
                  </CardContent>
                </Card>

                <Card>
                  <CardHeader className="pb-3">
                    <CardTitle className="text-sm font-medium">Code Quality</CardTitle>
                  </CardHeader>
                  <CardContent>
                    <div className={`text-3xl font-bold ${getScoreColor(evaluation.codeQualityScore)}`}>
                      {evaluation.codeQualityScore}/5
                    </div>
                  </CardContent>
                </Card>
              </div>

              {/* Strengths */}
              <div>
                <h3 className="font-semibold text-lg mb-3 flex items-center gap-2">
                  <Star className="w-5 h-5 text-yellow-500" />
                  Strengths
                </h3>
                <ul className="space-y-2">
                  {evaluation.strengths.map((strength, index) => (
                    <li key={index} className="flex items-start gap-2">
                      <CheckCircle2 className="w-5 h-5 text-green-600 mt-0.5" />
                      <span>{strength}</span>
                    </li>
                  ))}
                </ul>
              </div>

              {/* Areas for Improvement */}
              <div>
                <h3 className="font-semibold text-lg mb-3 flex items-center gap-2">
                  <TrendingUp className="w-5 h-5 text-blue-500" />
                  Areas for Improvement
                </h3>
                <ul className="space-y-2">
                  {evaluation.areasForImprovement.map((area, index) => (
                    <li key={index} className="flex items-start gap-2">
                      <AlertCircle className="w-5 h-5 text-yellow-600 mt-0.5" />
                      <span>{area}</span>
                    </li>
                  ))}
                </ul>
              </div>

              {/* Detailed Feedback */}
              <div>
                <h3 className="font-semibold text-lg mb-3">Detailed Feedback</h3>
                <div className="prose prose-sm max-w-none">
                  <ReactMarkdown>{evaluation.detailedFeedback}</ReactMarkdown>
                </div>
              </div>
            </div>
          </ScrollArea>
        </CardContent>

        <CardFooter>
          <Button onClick={onClose} className="w-full">
            Close Interview
          </Button>
        </CardFooter>
      </Card>
    );
  }

  // Interview chat view
  return (
    <Card className="h-full flex flex-col">
      <CardHeader>
        <div className="flex items-center justify-between">
          <div>
            <CardTitle className="flex items-center gap-2">
              <MessageSquare className="w-5 h-5" />
              AI Interview Coach
            </CardTitle>
            <CardDescription>Practice your technical interview skills</CardDescription>
          </div>
          <div className="flex items-center gap-4">
            <Badge variant="outline" className="flex items-center gap-1">
              <Clock className="w-3 h-3" />
              {formatTime(elapsedTime)}
            </Badge>
            {testsPassed ? (
              <Badge variant="default" className="flex items-center gap-1">
                <CheckCircle2 className="w-3 h-3" />
                Tests Passed
              </Badge>
            ) : (
              <Badge variant="secondary" className="flex items-center gap-1">
                <XCircle className="w-3 h-3" />
                Tests Failed
              </Badge>
            )}
          </div>
        </div>
      </CardHeader>

      <Separator />

      {/* Messages */}
      <CardContent className="flex-1 overflow-hidden p-0">
        <ScrollArea className="h-[400px] p-4">
          <div className="space-y-4">
            {messages.map((msg, index) => (
              <div
                key={index}
                className={`flex ${msg.role === 'candidate' ? 'justify-end' : 'justify-start'}`}
              >
                <div
                  className={`max-w-[80%] rounded-lg p-3 ${
                    msg.role === 'candidate'
                      ? 'bg-primary text-primary-foreground'
                      : 'bg-muted'
                  }`}
                >
                  <div className="flex items-center gap-2 mb-1">
                    <span className="text-xs font-semibold">
                      {msg.role === 'candidate' ? 'You' : 'Interviewer'}
                    </span>
                    {msg.messageType && (
                      <Badge variant="outline" className="text-xs">
                        {msg.messageType}
                      </Badge>
                    )}
                  </div>
                  <div className="prose prose-sm max-w-none dark:prose-invert">
                    <ReactMarkdown>{msg.message}</ReactMarkdown>
                  </div>
                  {msg.code_snapshot && (
                    <div className="mt-2 p-2 bg-black/10 rounded text-xs font-mono">
                      <Code className="w-3 h-3 inline mr-1" />
                      Code snapshot attached
                    </div>
                  )}
                </div>
              </div>
            ))}
            {isLoading && (
              <div className="flex justify-start">
                <div className="bg-muted rounded-lg p-3">
                  <div className="flex items-center gap-2">
                    <div className="w-2 h-2 bg-gray-400 rounded-full animate-bounce" />
                    <div className="w-2 h-2 bg-gray-400 rounded-full animate-bounce delay-100" />
                    <div className="w-2 h-2 bg-gray-400 rounded-full animate-bounce delay-200" />
                  </div>
                </div>
              </div>
            )}
            <div ref={messagesEndRef} />
          </div>
        </ScrollArea>
      </CardContent>

      <Separator />

      {/* Input area */}
      <CardFooter className="flex-col gap-3 p-4">
        <div className="flex gap-2 w-full">
          <Textarea
            value={currentMessage}
            onChange={(e) => setCurrentMessage(e.target.value)}
            onKeyDown={(e) => {
              if (e.key === "Enter" && !e.shiftKey) {
                e.preventDefault();
                handleSendMessage();
              }
            }}
            placeholder="Type your response... (Shift+Enter for new line)"
            className="min-h-[60px] resize-none"
            disabled={isLoading}
          />
          <Button
            onClick={handleSendMessage}
            disabled={!currentMessage.trim() || isLoading}
            size="icon"
            className="h-[60px] w-[60px]"
          >
            <Send className="w-4 h-4" />
          </Button>
        </div>

        <div className="flex gap-2 w-full">
          <Button
            onClick={handleSubmitCode}
            disabled={isLoading || !code.trim()}
            variant="outline"
            className="flex-1"
          >
            <Code className="w-4 h-4 mr-2" />
            Submit Code
          </Button>
          <Button
            onClick={handleEndInterview}
            disabled={isLoading}
            variant="default"
            className="flex-1"
          >
            <Trophy className="w-4 h-4 mr-2" />
            End Interview
          </Button>
        </div>

        <p className="text-xs text-muted-foreground text-center">
          Powered by Google Gemini • Be professional and communicate clearly
        </p>
      </CardFooter>
    </Card>
  );
}
