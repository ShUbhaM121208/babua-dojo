import { useState } from "react";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Progress } from "@/components/ui/progress";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Alert, AlertDescription } from "@/components/ui/alert";
import {
  CheckCircle2,
  XCircle,
  Lightbulb,
  TrendingUp,
  Code2,
  BookOpen,
  Sparkles,
  Clock,
  Zap,
  Crown,
  X,
} from "lucide-react";
import { CodeReview } from "@/services/codeReviewService";
import ReactMarkdown from "react-markdown";

interface CodeReviewPanelProps {
  review: CodeReview;
  onClose?: () => void;
  isLoading?: boolean;
}

export default function CodeReviewPanel({
  review,
  onClose,
  isLoading = false,
}: CodeReviewPanelProps) {
  const [activeTab, setActiveTab] = useState("overview");

  const getScoreColor = (score: number) => {
    if (score >= 90) return "text-green-500";
    if (score >= 75) return "text-blue-500";
    if (score >= 60) return "text-yellow-500";
    return "text-red-500";
  };

  const getScoreLabel = (score: number) => {
    if (score >= 90) return "Excellent";
    if (score >= 75) return "Good";
    if (score >= 60) return "Fair";
    return "Needs Improvement";
  };

  if (isLoading) {
    return (
      <Card className="p-6 border-2 border-purple-500/20 bg-gradient-to-br from-purple-50/50 to-blue-50/50">
        <div className="flex items-center justify-center space-x-3">
          <Sparkles className="h-5 w-5 text-purple-500 animate-pulse" />
          <p className="text-lg font-medium">AI is analyzing your code...</p>
        </div>
        <Progress value={60} className="mt-4" />
        <p className="text-sm text-muted-foreground text-center mt-2">
          This may take 10-20 seconds
        </p>
      </Card>
    );
  }

  return (
    <Card className="border-2 border-purple-500/20 bg-gradient-to-br from-purple-50/30 to-blue-50/30">
      {/* Header */}
      <div className="p-6 border-b bg-gradient-to-r from-purple-500/10 to-blue-500/10">
        <div className="flex items-start justify-between">
          <div className="flex items-center space-x-3">
            <div className="p-2 bg-purple-500/20 rounded-lg">
              <Sparkles className="h-6 w-6 text-purple-500" />
            </div>
            <div>
              <h3 className="text-xl font-bold flex items-center gap-2">
                AI Code Review
                <Badge variant="secondary" className="text-xs">
                  Powered by Gemini
                </Badge>
              </h3>
              <p className="text-sm text-muted-foreground">
                Comprehensive analysis of your solution
              </p>
            </div>
          </div>
          {onClose && (
            <Button variant="ghost" size="icon" onClick={onClose}>
              <X className="h-4 w-4" />
            </Button>
          )}
        </div>

        {/* Quality Score */}
        <div className="mt-6 p-4 bg-white/50 rounded-lg">
          <div className="flex items-center justify-between mb-3">
            <span className="text-sm font-medium">Code Quality Score</span>
            <span className={`text-3xl font-bold ${getScoreColor(review.codeQualityScore)}`}>
              {review.codeQualityScore}/100
            </span>
          </div>
          <Progress value={review.codeQualityScore} className="h-3" />
          <p className="text-xs text-muted-foreground mt-2 text-right">
            {getScoreLabel(review.codeQualityScore)}
          </p>
        </div>

        {/* Complexity Pills */}
        <div className="mt-4 flex gap-3">
          <Badge variant="outline" className="px-4 py-2">
            <Clock className="h-3 w-3 mr-2" />
            Time: {review.timeComplexity}
          </Badge>
          <Badge variant="outline" className="px-4 py-2">
            <Zap className="h-3 w-3 mr-2" />
            Space: {review.spaceComplexity}
          </Badge>
          {review.processingTimeMs && (
            <Badge variant="outline" className="px-4 py-2">
              <Sparkles className="h-3 w-3 mr-2" />
              {review.processingTimeMs}ms
            </Badge>
          )}
        </div>
      </div>

      {/* Tabs */}
      <Tabs value={activeTab} onValueChange={setActiveTab} className="p-6">
        <TabsList className="grid grid-cols-4 w-full">
          <TabsTrigger value="overview">Overview</TabsTrigger>
          <TabsTrigger value="strengths">Strengths</TabsTrigger>
          <TabsTrigger value="improvements">Improvements</TabsTrigger>
          <TabsTrigger value="alternatives">Alternatives</TabsTrigger>
        </TabsList>

        {/* Overview Tab */}
        <TabsContent value="overview" className="space-y-4 mt-4">
          {/* Strengths Preview */}
          <div className="space-y-2">
            <div className="flex items-center gap-2 mb-3">
              <CheckCircle2 className="h-5 w-5 text-green-500" />
              <h4 className="font-semibold">What You Did Well</h4>
              <Badge variant="secondary">{review.strengths.length}</Badge>
            </div>
            <div className="space-y-2">
              {review.strengths.slice(0, 3).map((strength, index) => (
                <div key={index} className="flex items-start gap-2 p-3 bg-green-50 rounded-lg">
                  <CheckCircle2 className="h-4 w-4 text-green-500 mt-0.5 flex-shrink-0" />
                  <p className="text-sm">{strength}</p>
                </div>
              ))}
            </div>
            {review.strengths.length > 3 && (
              <Button
                variant="link"
                size="sm"
                onClick={() => setActiveTab("strengths")}
                className="text-green-600"
              >
                View all {review.strengths.length} strengths →
              </Button>
            )}
          </div>

          {/* Improvements Preview */}
          <div className="space-y-2">
            <div className="flex items-center gap-2 mb-3">
              <TrendingUp className="h-5 w-5 text-blue-500" />
              <h4 className="font-semibold">Areas for Improvement</h4>
              <Badge variant="secondary">{review.improvements.length}</Badge>
            </div>
            <div className="space-y-2">
              {review.improvements.slice(0, 3).map((improvement, index) => (
                <div key={index} className="flex items-start gap-2 p-3 bg-blue-50 rounded-lg">
                  <Lightbulb className="h-4 w-4 text-blue-500 mt-0.5 flex-shrink-0" />
                  <p className="text-sm">{improvement}</p>
                </div>
              ))}
            </div>
            {review.improvements.length > 3 && (
              <Button
                variant="link"
                size="sm"
                onClick={() => setActiveTab("improvements")}
                className="text-blue-600"
              >
                View all {review.improvements.length} improvements →
              </Button>
            )}
          </div>

          {/* Best Practices */}
          {review.bestPractices && review.bestPractices.length > 0 && (
            <div className="space-y-2">
              <div className="flex items-center gap-2 mb-3">
                <BookOpen className="h-5 w-5 text-purple-500" />
                <h4 className="font-semibold">Best Practices</h4>
              </div>
              <div className="space-y-2">
                {review.bestPractices.map((practice, index) => (
                  <div key={index} className="flex items-start gap-2 p-3 bg-purple-50 rounded-lg">
                    <Crown className="h-4 w-4 text-purple-500 mt-0.5 flex-shrink-0" />
                    <p className="text-sm">{practice}</p>
                  </div>
                ))}
              </div>
            </div>
          )}
        </TabsContent>

        {/* Strengths Tab */}
        <TabsContent value="strengths" className="space-y-3 mt-4">
          <Alert className="border-green-500 bg-green-50">
            <CheckCircle2 className="h-5 w-5 text-green-500" />
            <AlertDescription>
              Your code has {review.strengths.length} notable strength{review.strengths.length !== 1 ? "s" : ""}
            </AlertDescription>
          </Alert>
          {review.strengths.map((strength, index) => (
            <div key={index} className="p-4 bg-green-50 rounded-lg border border-green-200">
              <div className="flex items-start gap-3">
                <div className="p-1.5 bg-green-100 rounded-full">
                  <CheckCircle2 className="h-4 w-4 text-green-600" />
                </div>
                <div>
                  <p className="font-medium text-green-900">Strength #{index + 1}</p>
                  <p className="text-sm text-green-800 mt-1">{strength}</p>
                </div>
              </div>
            </div>
          ))}
        </TabsContent>

        {/* Improvements Tab */}
        <TabsContent value="improvements" className="space-y-3 mt-4">
          <Alert className="border-blue-500 bg-blue-50">
            <TrendingUp className="h-5 w-5 text-blue-500" />
            <AlertDescription>
              {review.improvements.length} suggestion{review.improvements.length !== 1 ? "s" : ""} to make your code even better
            </AlertDescription>
          </Alert>
          {review.improvements.map((improvement, index) => (
            <div key={index} className="p-4 bg-blue-50 rounded-lg border border-blue-200">
              <div className="flex items-start gap-3">
                <div className="p-1.5 bg-blue-100 rounded-full">
                  <Lightbulb className="h-4 w-4 text-blue-600" />
                </div>
                <div>
                  <p className="font-medium text-blue-900">Improvement #{index + 1}</p>
                  <p className="text-sm text-blue-800 mt-1">{improvement}</p>
                </div>
              </div>
            </div>
          ))}
        </TabsContent>

        {/* Alternatives Tab */}
        <TabsContent value="alternatives" className="space-y-4 mt-4">
          <Alert className="border-purple-500 bg-purple-50">
            <Code2 className="h-5 w-5 text-purple-500" />
            <AlertDescription>
              {review.alternativeApproaches.length} alternative approach{review.alternativeApproaches.length !== 1 ? "es" : ""} to consider
            </AlertDescription>
          </Alert>
          {review.alternativeApproaches.map((approach, index) => (
            <div key={index} className="p-4 bg-purple-50 rounded-lg border border-purple-200">
              <div className="flex items-start gap-3">
                <div className="p-1.5 bg-purple-100 rounded-full">
                  <Code2 className="h-4 w-4 text-purple-600" />
                </div>
                <div className="flex-1">
                  <p className="font-medium text-purple-900 mb-2">
                    Approach #{index + 1}
                  </p>
                  <div className="text-sm text-purple-800 prose prose-sm max-w-none">
                    <ReactMarkdown>{approach}</ReactMarkdown>
                  </div>
                </div>
              </div>
            </div>
          ))}
        </TabsContent>
      </Tabs>

      {/* Full Review (Collapsible) */}
      {review.fullReviewMarkdown && (
        <div className="px-6 pb-6">
          <details className="group">
            <summary className="cursor-pointer p-4 bg-gray-50 rounded-lg hover:bg-gray-100 transition-colors">
              <div className="flex items-center justify-between">
                <span className="font-semibold flex items-center gap-2">
                  <BookOpen className="h-4 w-4" />
                  View Full Detailed Review
                </span>
                <span className="text-sm text-muted-foreground">Click to expand</span>
              </div>
            </summary>
            <div className="mt-4 p-6 bg-white rounded-lg border prose prose-sm max-w-none">
              <ReactMarkdown>{review.fullReviewMarkdown}</ReactMarkdown>
            </div>
          </details>
        </div>
      )}

      {/* Footer */}
      <div className="px-6 pb-6">
        <div className="flex items-center justify-between text-xs text-muted-foreground">
          <span>Powered by Google Gemini</span>
          {review.createdAt && (
            <span>Generated {new Date(review.createdAt).toLocaleString()}</span>
          )}
        </div>
      </div>
    </Card>
  );
}
