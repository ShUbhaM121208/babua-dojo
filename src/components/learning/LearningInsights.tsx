import React, { useEffect, useState } from 'react';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Skeleton } from '@/components/ui/skeleton';
import { Alert, AlertDescription } from '@/components/ui/alert';
import { useAuth } from '@/contexts/AuthContext';
import { getLearningInsights, type TopicPerformance } from '@/services/learningPathService';
import {
  TrendingUp,
  TrendingDown,
  Target,
  Award,
  BarChart3,
  Lightbulb,
} from 'lucide-react';
import { Progress } from '@/components/ui/progress';

export function LearningInsights() {
  const { user } = useAuth();
  const [insights, setInsights] = useState<{
    strongestTopics: TopicPerformance[];
    weakestTopics: TopicPerformance[];
    improvingTopics: TopicPerformance[];
    decliningTopics: TopicPerformance[];
    totalTopicsLearned: number;
    averageSuccessRate: number;
  } | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (user) {
      loadInsights();
    }
  }, [user]);

  const loadInsights = async () => {
    if (!user) return;

    setLoading(true);
    setError(null);

    try {
      const { data, error: fetchError } = await getLearningInsights(user.id);

      if (fetchError) {
        setError(fetchError);
      } else {
        setInsights(data);
      }
    } catch (err) {
      setError('Failed to load learning insights');
      console.error('Error loading insights:', err);
    } finally {
      setLoading(false);
    }
  };

  const getSuccessRateColor = (rate: number) => {
    if (rate >= 80) return 'text-green-600';
    if (rate >= 50) return 'text-yellow-600';
    return 'text-red-600';
  };

  const getSuccessRateBg = (rate: number) => {
    if (rate >= 80) return 'bg-green-500';
    if (rate >= 50) return 'bg-yellow-500';
    return 'bg-red-500';
  };

  const TopicCard = ({ topic, type }: { topic: TopicPerformance; type: 'strong' | 'weak' | 'improving' | 'declining' }) => {
    const icon = {
      strong: <Award className="w-4 h-4 text-green-500" />,
      weak: <Target className="w-4 h-4 text-red-500" />,
      improving: <TrendingUp className="w-4 h-4 text-blue-500" />,
      declining: <TrendingDown className="w-4 h-4 text-orange-500" />,
    }[type];

    return (
      <div className="space-y-2 p-3 rounded-lg bg-accent/50">
        <div className="flex items-start justify-between">
          <div className="flex items-center gap-2">
            {icon}
            <span className="font-medium text-sm">{topic.topic}</span>
          </div>
          <Badge
            variant="outline"
            className={`text-xs ${getSuccessRateColor(topic.success_rate)}`}
          >
            {topic.success_rate.toFixed(0)}%
          </Badge>
        </div>
        <Progress value={topic.success_rate} className="h-1" />
        <div className="flex gap-4 text-xs text-muted-foreground">
          <span>{topic.problems_solved}/{topic.problems_attempted} solved</span>
          <span>~{Math.round(topic.average_time / 60)}m avg</span>
        </div>
      </div>
    );
  };

  if (loading) {
    return (
      <Card className="w-full">
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <BarChart3 className="w-5 h-5" />
            Learning Insights
          </CardTitle>
          <CardDescription>Your progress across different topics</CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          {[1, 2, 3].map((i) => (
            <Skeleton key={i} className="h-20 w-full" />
          ))}
        </CardContent>
      </Card>
    );
  }

  if (error) {
    return (
      <Card className="w-full">
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <BarChart3 className="w-5 h-5" />
            Learning Insights
          </CardTitle>
        </CardHeader>
        <CardContent>
          <Alert variant="destructive">
            <AlertDescription>{error}</AlertDescription>
          </Alert>
        </CardContent>
      </Card>
    );
  }

  if (!insights || insights.totalTopicsLearned === 0) {
    return (
      <Card className="w-full">
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <BarChart3 className="w-5 h-5" />
            Learning Insights
          </CardTitle>
          <CardDescription>Your progress across different topics</CardDescription>
        </CardHeader>
        <CardContent>
          <div className="text-center py-8 text-muted-foreground">
            <Lightbulb className="w-12 h-12 mx-auto mb-4 opacity-50" />
            <p className="text-sm">No insights yet.</p>
            <p className="text-xs mt-2">Complete some problems to see your learning analytics!</p>
          </div>
        </CardContent>
      </Card>
    );
  }

  return (
    <Card className="w-full">
      <CardHeader>
        <CardTitle className="flex items-center gap-2">
          <BarChart3 className="w-5 h-5" />
          Learning Insights
        </CardTitle>
        <CardDescription>Your progress across different topics</CardDescription>
      </CardHeader>
      <CardContent className="space-y-6">
        {/* Overall Stats */}
        <div className="grid grid-cols-2 gap-4">
          <div className="text-center p-4 rounded-lg bg-primary/10">
            <div className="text-3xl font-bold text-primary">
              {insights.totalTopicsLearned}
            </div>
            <div className="text-xs text-muted-foreground mt-1">Topics Learned</div>
          </div>
          <div className="text-center p-4 rounded-lg bg-primary/10">
            <div className={`text-3xl font-bold ${getSuccessRateColor(insights.averageSuccessRate)}`}>
              {insights.averageSuccessRate.toFixed(0)}%
            </div>
            <div className="text-xs text-muted-foreground mt-1">Avg Success Rate</div>
          </div>
        </div>

        {/* Strongest Topics */}
        {insights.strongestTopics.length > 0 && (
          <div className="space-y-3">
            <h3 className="font-semibold text-sm flex items-center gap-2">
              <Award className="w-4 h-4 text-green-500" />
              Your Strongest Topics
            </h3>
            <div className="space-y-2">
              {insights.strongestTopics.slice(0, 3).map((topic, idx) => (
                <TopicCard key={idx} topic={topic} type="strong" />
              ))}
            </div>
          </div>
        )}

        {/* Weakest Topics */}
        {insights.weakestTopics.length > 0 && (
          <div className="space-y-3">
            <h3 className="font-semibold text-sm flex items-center gap-2">
              <Target className="w-4 h-4 text-red-500" />
              Topics That Need Work
            </h3>
            <div className="space-y-2">
              {insights.weakestTopics.slice(0, 3).map((topic, idx) => (
                <TopicCard key={idx} topic={topic} type="weak" />
              ))}
            </div>
          </div>
        )}

        {/* Improving Topics */}
        {insights.improvingTopics.length > 0 && (
          <div className="space-y-3">
            <h3 className="font-semibold text-sm flex items-center gap-2">
              <TrendingUp className="w-4 h-4 text-blue-500" />
              You're Improving!
            </h3>
            <div className="space-y-2">
              {insights.improvingTopics.slice(0, 3).map((topic, idx) => (
                <TopicCard key={idx} topic={topic} type="improving" />
              ))}
            </div>
          </div>
        )}

        {/* Declining Topics */}
        {insights.decliningTopics.length > 0 && (
          <div className="space-y-3">
            <h3 className="font-semibold text-sm flex items-center gap-2">
              <TrendingDown className="w-4 h-4 text-orange-500" />
              Needs Attention
            </h3>
            <div className="space-y-2">
              {insights.decliningTopics.slice(0, 3).map((topic, idx) => (
                <TopicCard key={idx} topic={topic} type="declining" />
              ))}
            </div>
          </div>
        )}
      </CardContent>
    </Card>
  );
}
