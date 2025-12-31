import { useState, useEffect } from 'react';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { ScrollArea } from '@/components/ui/scroll-area';
import { Separator } from '@/components/ui/separator';
import { Alert, AlertDescription } from '@/components/ui/alert';
import { 
  Lightbulb, 
  BookOpen, 
  Target, 
  TrendingUp,
  CheckCircle2,
  XCircle,
  ChevronRight,
  Code,
  Brain,
  Zap
} from 'lucide-react';
import { TutorMessage, TutorHintLevel, SessionType, TutorHint } from '@/types/tutor';

interface TutorModePanelProps {
  problemId: string;
  userId: string;
  sessionType: SessionType;
  onSessionComplete: (sessionData: any) => void;
}

export function TutorModePanel({ 
  problemId, 
  userId, 
  sessionType,
  onSessionComplete 
}: TutorModePanelProps) {
  const [messages, setMessages] = useState<TutorMessage[]>([]);
  const [currentHintLevel, setCurrentHintLevel] = useState<TutorHintLevel>('conceptual');
  const [hintsUsed, setHintsUsed] = useState(0);
  const [conceptsCovered, setConceptsCovered] = useState<string[]>([]);
  const [isLoading, setIsLoading] = useState(false);
  const [sessionStartTime] = useState(Date.now());

  const hintLevels: TutorHintLevel[] = ['conceptual', 'algorithmic', 'implementation', 'solution'];
  
  const hintLevelInfo = {
    conceptual: { icon: Brain, label: 'Conceptual Hint', color: 'text-blue-500' },
    algorithmic: { icon: Target, label: 'Algorithm Hint', color: 'text-purple-500' },
    implementation: { icon: Code, label: 'Implementation Hint', color: 'text-orange-500' },
    solution: { icon: CheckCircle2, label: 'Full Solution', color: 'text-green-500' }
  };

  const requestHint = async () => {
    if (hintsUsed >= 4) return; // Max 4 hints per problem
    
    setIsLoading(true);
    try {
      // TODO: Replace with actual API call to Gemini
      const response = await fetch('/api/tutor/hint', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          problem_id: problemId,
          user_id: userId,
          hint_level: currentHintLevel,
          session_type: sessionType,
          previous_hints: messages.filter(m => m.hint).map(m => m.hint)
        })
      });
      
      const hintData: TutorHint = await response.json();
      
      const tutorMessage: TutorMessage = {
        role: 'tutor',
        content: hintData.content,
        hint: hintData,
        timestamp: new Date().toISOString(),
        concepts_touched: hintData.concept_explanation ? [hintData.concept_explanation] : []
      };
      
      setMessages(prev => [...prev, tutorMessage]);
      setHintsUsed(prev => prev + 1);
      
      // Update concepts covered
      if (hintData.concept_explanation) {
        setConceptsCovered(prev => 
          Array.from(new Set([...prev, hintData.concept_explanation!]))
        );
      }
      
      // Progress to next hint level
      const currentIndex = hintLevels.indexOf(currentHintLevel);
      if (currentIndex < hintLevels.length - 1) {
        setCurrentHintLevel(hintLevels[currentIndex + 1]);
      }
    } catch (error) {
      console.error('Error requesting hint:', error);
    } finally {
      setIsLoading(false);
    }
  };

  const askConceptQuestion = async (question: string) => {
    setIsLoading(true);
    try {
      // Add user message
      const userMessage: TutorMessage = {
        role: 'user',
        content: question,
        timestamp: new Date().toISOString()
      };
      setMessages(prev => [...prev, userMessage]);
      
      // TODO: Replace with actual API call
      const response = await fetch('/api/tutor/concept', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          question,
          problem_id: problemId,
          user_id: userId,
          context: conceptsCovered
        })
      });
      
      const explanation = await response.json();
      
      const tutorMessage: TutorMessage = {
        role: 'tutor',
        content: explanation.content,
        timestamp: new Date().toISOString(),
        concepts_touched: explanation.concepts
      };
      
      setMessages(prev => [...prev, tutorMessage]);
      
      if (explanation.concepts) {
        setConceptsCovered(prev => 
          Array.from(new Set([...prev, ...explanation.concepts]))
        );
      }
    } catch (error) {
      console.error('Error asking concept question:', error);
    } finally {
      setIsLoading(false);
    }
  };

  const completeSession = () => {
    const sessionData = {
      problem_id: problemId,
      user_id: userId,
      session_type: sessionType,
      hints_requested: hintsUsed,
      concepts_covered: conceptsCovered,
      time_spent_seconds: Math.floor((Date.now() - sessionStartTime) / 1000),
      completed: true
    };
    onSessionComplete(sessionData);
  };

  return (
    <div className="flex flex-col h-full">
      {/* Header */}
      <CardHeader className="pb-3">
        <div className="flex items-center justify-between">
          <CardTitle className="text-lg flex items-center gap-2">
            <Lightbulb className="h-5 w-5 text-yellow-500" />
            Tutor Mode
          </CardTitle>
          <Badge variant="outline">
            {hintsUsed}/4 Hints Used
          </Badge>
        </div>
      </CardHeader>

      <Separator />

      {/* Session Type Info */}
      <div className="px-6 py-3 bg-muted/50">
        <div className="flex items-center gap-2 text-sm">
          <BookOpen className="h-4 w-4" />
          <span className="font-medium">
            {sessionType === 'guided' && 'Guided Learning Session'}
            {sessionType === 'hint_based' && 'Hint-Based Practice'}
            {sessionType === 'concept_deep_dive' && 'Concept Deep Dive'}
          </span>
        </div>
      </div>

      {/* Messages Area */}
      <ScrollArea className="flex-1 px-6 py-4">
        <div className="space-y-4">
          {messages.length === 0 && (
            <Alert>
              <Zap className="h-4 w-4" />
              <AlertDescription>
                Welcome to Tutor Mode! Request hints to get progressive guidance,
                or ask questions about concepts you'd like to understand better.
              </AlertDescription>
            </Alert>
          )}
          
          {messages.map((message, index) => (
            <div
              key={index}
              className={`flex gap-3 ${
                message.role === 'user' ? 'justify-end' : 'justify-start'
              }`}
            >
              {message.role === 'tutor' && (
                <div className="flex-shrink-0 w-8 h-8 rounded-full bg-primary/10 flex items-center justify-center">
                  <Brain className="h-4 w-4 text-primary" />
                </div>
              )}
              
              <div
                className={`max-w-[80%] rounded-lg p-4 ${
                  message.role === 'user'
                    ? 'bg-primary text-primary-foreground'
                    : 'bg-muted'
                }`}
              >
                {message.hint && (
                  <div className="mb-2 flex items-center gap-2">
                    {(() => {
                      const Icon = hintLevelInfo[message.hint.level].icon;
                      return <Icon className={`h-4 w-4 ${hintLevelInfo[message.hint.level].color}`} />;
                    })()}
                    <span className="text-xs font-semibold">
                      {hintLevelInfo[message.hint.level].label}
                    </span>
                  </div>
                )}
                
                <p className="text-sm whitespace-pre-wrap">{message.content}</p>
                
                {message.hint?.code_snippet && (
                  <pre className="mt-3 p-3 bg-black/10 rounded text-xs overflow-x-auto">
                    <code>{message.hint.code_snippet}</code>
                  </pre>
                )}
                
                {message.hint?.follow_up_questions && (
                  <div className="mt-3 space-y-1">
                    <p className="text-xs font-semibold">Follow-up questions:</p>
                    {message.hint.follow_up_questions.map((q, i) => (
                      <button
                        key={i}
                        onClick={() => askConceptQuestion(q)}
                        className="block text-xs text-left hover:underline"
                      >
                        • {q}
                      </button>
                    ))}
                  </div>
                )}
                
                <span className="text-xs opacity-70 mt-2 block">
                  {new Date(message.timestamp).toLocaleTimeString()}
                </span>
              </div>
              
              {message.role === 'user' && (
                <div className="flex-shrink-0 w-8 h-8 rounded-full bg-primary flex items-center justify-center">
                  <span className="text-sm font-semibold text-primary-foreground">
                    {userId.charAt(0).toUpperCase()}
                  </span>
                </div>
              )}
            </div>
          ))}
        </div>
      </ScrollArea>

      <Separator />

      {/* Concepts Covered */}
      {conceptsCovered.length > 0 && (
        <div className="px-6 py-3 bg-muted/30">
          <div className="flex items-center gap-2 mb-2">
            <TrendingUp className="h-4 w-4" />
            <span className="text-sm font-medium">Concepts Covered</span>
          </div>
          <div className="flex flex-wrap gap-2">
            {conceptsCovered.map(concept => (
              <Badge key={concept} variant="secondary" className="text-xs">
                {concept}
              </Badge>
            ))}
          </div>
        </div>
      )}

      {/* Action Buttons */}
      <CardContent className="pt-4 pb-4">
        <div className="flex gap-2">
          <Button
            onClick={requestHint}
            disabled={isLoading || hintsUsed >= 4}
            className="flex-1"
            variant={hintsUsed >= 4 ? 'outline' : 'default'}
          >
            {isLoading ? (
              'Getting hint...'
            ) : (
              <>
                <Lightbulb className="h-4 w-4 mr-2" />
                Request Hint
                <ChevronRight className="h-4 w-4 ml-2" />
              </>
            )}
          </Button>
          
          <Button
            onClick={completeSession}
            variant="outline"
            className="flex-1"
          >
            <CheckCircle2 className="h-4 w-4 mr-2" />
            Complete Session
          </Button>
        </div>
        
        <p className="text-xs text-muted-foreground mt-2 text-center">
          Next hint: {hintLevelInfo[currentHintLevel].label}
        </p>
      </CardContent>
    </div>
  );
}
