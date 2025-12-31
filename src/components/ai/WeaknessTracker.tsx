import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Progress } from "@/components/ui/progress";
import { Badge } from "@/components/ui/badge";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Separator } from "@/components/ui/separator";
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, Cell } from "recharts";
import { AlertTriangle, TrendingDown, Lightbulb, Target, Bot } from "lucide-react";
import { enhancedUserProgress } from "@/data/mockData";
import type { UserWeakness } from "@/types";
import { useBabuaAI } from "@/hooks/useBabuaAI";

export function WeaknessTracker() {
  const { sendMessage } = useBabuaAI();
  const weaknesses = enhancedUserProgress.weaknesses;

  const chartData = weaknesses.map((w) => ({
    name: w.topic,
    failureRate: Math.round(w.failureRate * 100),
    attempted: w.problemsAttempted,
    solved: w.problemsSolved,
  }));

  const getFailureColor = (rate: number) => {
    if (rate > 0.6) return "#ef4444"; // red
    if (rate > 0.4) return "#f59e0b"; // amber
    return "#10b981"; // green
  };

  const handleFocusArea = (weakness: UserWeakness) => {
    sendMessage(
      `I'm struggling with ${weakness.topic}. My failure rate is ${Math.round(weakness.failureRate * 100)}%. ${weakness.aiInsight}. Can you create a personalized study plan to improve this area?`,
      { userProgress: enhancedUserProgress }
    );
  };

  const handleGeneralAnalysis = () => {
    sendMessage(
      `Based on my learning data, what are my biggest weaknesses and what should I focus on next? Please analyze my progress patterns and suggest a concrete action plan.`,
      { userProgress: enhancedUserProgress }
    );
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-2xl font-bold font-mono flex items-center gap-2">
            <AlertTriangle className="h-6 w-6 text-amber-400" />
            Weakness Analysis
          </h2>
          <p className="text-muted-foreground text-sm mt-1">
            AI-powered insights into areas that need attention
          </p>
        </div>
        <Button onClick={handleGeneralAnalysis}>
          <Bot className="mr-2 h-4 w-4" />
          Get AI Analysis
        </Button>
      </div>

      {/* Chart */}
      <Card className="p-6 bg-surface">
        <h3 className="font-mono text-sm font-semibold mb-4 flex items-center gap-2">
          <TrendingDown className="h-4 w-4 text-primary" />
          FAILURE RATE BY TOPIC
        </h3>
        <ResponsiveContainer width="100%" height={250}>
          <BarChart data={chartData}>
            <CartesianGrid strokeDasharray="3 3" stroke="#333" />
            <XAxis 
              dataKey="name" 
              stroke="#666"
              fontSize={12}
              angle={-45}
              textAnchor="end"
              height={80}
            />
            <YAxis 
              stroke="#666"
              fontSize={12}
              label={{ value: 'Failure %', angle: -90, position: 'insideLeft' }}
            />
            <Tooltip 
              contentStyle={{ 
                backgroundColor: '#1a1a1a', 
                border: '1px solid #333',
                borderRadius: '8px',
                fontFamily: 'monospace'
              }}
              formatter={(value: number | string, name: string) => {
                if (name === 'failureRate') return [`${value}%`, 'Failure Rate'];
                return [value, name];
              }}
            />
            <Bar dataKey="failureRate" radius={[8, 8, 0, 0]}>
              {chartData.map((entry, index) => (
                <Cell key={`cell-${index}`} fill={getFailureColor(entry.failureRate / 100)} />
              ))}
            </Bar>
          </BarChart>
        </ResponsiveContainer>
      </Card>

      {/* Detailed Weakness Cards */}
      <div className="space-y-4">
        <h3 className="font-mono text-sm font-semibold text-muted-foreground flex items-center gap-2">
          <Target className="h-4 w-4 text-primary" />
          DETAILED BREAKDOWN
        </h3>
        {weaknesses.map((weakness, index) => (
          <Card key={index} className="p-5 bg-surface border-l-4" style={{ 
            borderLeftColor: getFailureColor(weakness.failureRate) 
          }}>
            <div className="flex items-start justify-between mb-4">
              <div>
                <h4 className="font-bold text-lg mb-1">{weakness.topic}</h4>
                <div className="flex gap-2 flex-wrap">
                  {weakness.subtopics.map((sub) => (
                    <Badge key={sub} variant="outline" className="text-xs">
                      {sub}
                    </Badge>
                  ))}
                </div>
              </div>
              <div className="text-right">
                <div className="text-2xl font-mono font-bold" style={{ 
                  color: getFailureColor(weakness.failureRate) 
                }}>
                  {Math.round(weakness.failureRate * 100)}%
                </div>
                <div className="text-xs text-muted-foreground">Failure Rate</div>
              </div>
            </div>

            <Separator className="my-4" />

            <div className="grid grid-cols-3 gap-4 mb-4">
              <div>
                <div className="text-sm text-muted-foreground">Attempted</div>
                <div className="text-xl font-mono font-bold">{weakness.problemsAttempted}</div>
              </div>
              <div>
                <div className="text-sm text-muted-foreground">Solved</div>
                <div className="text-xl font-mono font-bold text-green-400">{weakness.problemsSolved}</div>
              </div>
              <div>
                <div className="text-sm text-muted-foreground">Avg Attempts</div>
                <div className="text-xl font-mono font-bold">{weakness.averageAttempts.toFixed(1)}</div>
              </div>
            </div>

            <div className="mb-4">
              <div className="flex items-center justify-between text-sm mb-2">
                <span className="text-muted-foreground">Success Rate</span>
                <span className="font-mono">
                  {Math.round((1 - weakness.failureRate) * 100)}%
                </span>
              </div>
              <Progress 
                value={(1 - weakness.failureRate) * 100} 
                className="h-2"
              />
            </div>

            <Alert className="bg-primary/10 border-primary/20 mb-4">
              <Lightbulb className="h-4 w-4 text-primary" />
              <AlertDescription className="text-sm">
                <span className="font-semibold">AI Insight:</span> {weakness.aiInsight}
              </AlertDescription>
            </Alert>

            <div className="flex gap-2">
              <Button 
                variant="outline" 
                size="sm" 
                className="flex-1"
                onClick={() => handleFocusArea(weakness)}
              >
                <Bot className="mr-2 h-4 w-4" />
                Get Study Plan
              </Button>
              <Button size="sm" className="flex-1">
                <Target className="mr-2 h-4 w-4" />
                Practice Now
              </Button>
            </div>

            <div className="text-xs text-muted-foreground mt-3 font-mono">
              Last practiced: {new Date(weakness.lastPracticed).toLocaleDateString()}
            </div>
          </Card>
        ))}
      </div>

      {/* Strengths Section */}
      <Card className="p-6 bg-surface border-green-500/20">
        <h3 className="font-mono text-sm font-semibold mb-4 flex items-center gap-2 text-green-400">
          <Target className="h-4 w-4" />
          YOUR STRENGTHS
        </h3>
        <div className="flex gap-2 flex-wrap">
          {enhancedUserProgress.strengths.map((strength) => (
            <Badge key={strength} className="bg-green-500/20 text-green-400 border-green-500/30">
              {strength}
            </Badge>
          ))}
        </div>
        <p className="text-sm text-muted-foreground mt-4">
          Keep reinforcing these topics while you work on weak areas. Your strong foundation here
          will help you tackle harder problems.
        </p>
      </Card>

      {/* Action Plan */}
      <Alert>
        <AlertTriangle className="h-4 w-4" />
        <AlertDescription>
          <strong>Recommended Focus:</strong> Start with {weaknesses[0]?.topic} - it has the highest
          failure rate. Break down problems into smaller chunks and practice fundamentals before
          tackling complex variations.
        </AlertDescription>
      </Alert>
    </div>
  );
}
