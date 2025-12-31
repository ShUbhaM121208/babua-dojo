import React, { useEffect, useState } from 'react';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Skeleton } from '@/components/ui/skeleton';
import { Alert, AlertDescription } from '@/components/ui/alert';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '@/contexts/AuthContext';
import {
  getUserRecommendations,
  trackRecommendationInteraction,
  generateRecommendations,
  type Recommendation,
} from '@/services/learningPathService';
import {
  Brain,
  TrendingUp,
  Clock,
  Target,
  RefreshCw,
  X,
  CheckCircle2,
  Sparkles,
} from 'lucide-react';

export function RecommendedForYou() {
  const { user } = useAuth();
  const navigate = useNavigate();
  const [recommendations, setRecommendations] = useState<Recommendation[]>([]);
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (user) {
      loadRecommendations();
    }
  }, [user]);

  const loadRecommendations = async () => {
    if (!user) return;

    setLoading(true);
    setError(null);

    try {
      const { data, error: fetchError } = await getUserRecommendations(user.id);

      if (fetchError) {
        setError(fetchError);
      } else {
        setRecommendations(data || []);

        // Track that recommendations were shown
        data?.forEach((rec) => {
          trackRecommendationInteraction(rec.recommendation_id, 'shown');
        });
      }
    } catch (err) {
      setError('Failed to load recommendations');
      console.error('Error loading recommendations:', err);
    } finally {
      setLoading(false);
    }
  };

  const handleRefresh = async () => {
    if (!user) return;

    setRefreshing(true);
    setError(null);

    try {
      await generateRecommendations(user.id, 5);
      await loadRecommendations();
    } catch (err) {
      setError('Failed to refresh recommendations');
      console.error('Error refreshing recommendations:', err);
    } finally {
      setRefreshing(false);
    }
  };

  const handleProblemClick = async (recommendation: Recommendation) => {
    // Track the click
    await trackRecommendationInteraction(recommendation.recommendation_id, 'clicked');

    // Navigate to problem
    navigate(`/practice/${recommendation.problem_id}`);
  };

  const handleDismiss = async (recommendation: Recommendation) => {
    // Track dismissal
    await trackRecommendationInteraction(recommendation.recommendation_id, 'dismissed');

    // Remove from UI
    setRecommendations((prev) =>
      prev.filter((r) => r.recommendation_id !== recommendation.recommendation_id)
    );
  };

  const getDifficultyColor = (difficulty: string) => {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return 'bg-green-500/10 text-green-700 border-green-500/20';
      case 'medium':
        return 'bg-yellow-500/10 text-yellow-700 border-yellow-500/20';
      case 'hard':
        return 'bg-red-500/10 text-red-700 border-red-500/20';
      default:
        return 'bg-gray-500/10 text-gray-700 border-gray-500/20';
    }
  };

  const getPriorityIcon = (priority: number) => {
    if (priority === 1) return <Target className="w-4 h-4 text-red-500" />;
    if (priority === 2) return <TrendingUp className="w-4 h-4 text-orange-500" />;
    return <Sparkles className="w-4 h-4 text-blue-500" />;
  };

  if (loading) {
    return (
      <Card className="w-full">
        <CardHeader>
          <div className="flex items-center justify-between">
            <div>
              <CardTitle className="flex items-center gap-2">
                <Brain className="w-5 h-5" />
                Recommended for You
              </CardTitle>
              <CardDescription>Personalized problems based on your learning journey</CardDescription>
            </div>
          </div>
        </CardHeader>
        <CardContent className="space-y-4">
          {[1, 2, 3].map((i) => (
            <div key={i} className="space-y-2">
              <Skeleton className="h-6 w-3/4" />
              <Skeleton className="h-4 w-full" />
              <div className="flex gap-2">
                <Skeleton className="h-6 w-16" />
                <Skeleton className="h-6 w-20" />
              </div>
            </div>
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
            <Brain className="w-5 h-5" />
            Recommended for You
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

  if (recommendations.length === 0) {
    return (
      <Card className="w-full">
        <CardHeader>
          <div className="flex items-center justify-between">
            <div>
              <CardTitle className="flex items-center gap-2">
                <Brain className="w-5 h-5" />
                Recommended for You
              </CardTitle>
              <CardDescription>Personalized problems based on your learning journey</CardDescription>
            </div>
            <Button
              variant="outline"
              size="sm"
              onClick={handleRefresh}
              disabled={refreshing}
            >
              <RefreshCw className={`w-4 h-4 mr-2 ${refreshing ? 'animate-spin' : ''}`} />
              Refresh
            </Button>
          </div>
        </CardHeader>
        <CardContent>
          <div className="text-center py-8 text-muted-foreground">
            <Brain className="w-12 h-12 mx-auto mb-4 opacity-50" />
            <p className="text-sm">No recommendations yet.</p>
            <p className="text-xs mt-2">Solve a few problems to get personalized suggestions!</p>
          </div>
        </CardContent>
      </Card>
    );
  }

  return (
    <Card className="w-full">
      <CardHeader>
        <div className="flex items-center justify-between">
          <div>
            <CardTitle className="flex items-center gap-2">
              <Brain className="w-5 h-5" />
              Recommended for You
            </CardTitle>
            <CardDescription>
              {recommendations.length} personalized {recommendations.length === 1 ? 'problem' : 'problems'} to
              help you improve
            </CardDescription>
          </div>
          <Button
            variant="outline"
            size="sm"
            onClick={handleRefresh}
            disabled={refreshing}
          >
            <RefreshCw className={`w-4 h-4 mr-2 ${refreshing ? 'animate-spin' : ''}`} />
            Refresh
          </Button>
        </div>
      </CardHeader>
      <CardContent className="space-y-4">
        {recommendations.map((rec) => (
          <div
            key={rec.recommendation_id}
            className="group relative rounded-lg border bg-card p-4 hover:bg-accent/50 transition-all duration-200"
          >
            {/* Dismiss Button */}
            <Button
              variant="ghost"
              size="sm"
              className="absolute top-2 right-2 opacity-0 group-hover:opacity-100 transition-opacity"
              onClick={() => handleDismiss(rec)}
            >
              <X className="w-4 h-4" />
            </Button>

            {/* Priority Indicator */}
            <div className="flex items-start gap-3 mb-3">
              <div className="mt-1">{getPriorityIcon(rec.priority)}</div>
              <div className="flex-1">
                <h3
                  className="font-semibold text-lg cursor-pointer hover:text-primary transition-colors"
                  onClick={() => handleProblemClick(rec)}
                >
                  {rec.problem_title}
                </h3>
                <p className="text-sm text-muted-foreground mt-1">{rec.reason}</p>
              </div>
            </div>

            {/* Metadata */}
            <div className="flex flex-wrap gap-2 mb-3">
              <Badge
                variant="outline"
                className={getDifficultyColor(rec.problem_difficulty)}
              >
                {rec.problem_difficulty}
              </Badge>
              <Badge variant="outline" className="border-blue-500/20 bg-blue-500/10 text-blue-700">
                {rec.topic}
              </Badge>
              {rec.estimated_time_minutes && (
                <Badge variant="outline" className="border-purple-500/20 bg-purple-500/10 text-purple-700">
                  <Clock className="w-3 h-3 mr-1" />
                  ~{rec.estimated_time_minutes} min
                </Badge>
              )}
              <Badge variant="outline" className="border-gray-500/20 bg-gray-500/10 text-gray-700">
                Match: {Math.round(rec.score)}%
              </Badge>
            </div>

            {/* Action Button */}
            <Button
              onClick={() => handleProblemClick(rec)}
              className="w-full"
              size="sm"
            >
              Start Problem
              <CheckCircle2 className="w-4 h-4 ml-2" />
            </Button>
          </div>
        ))}

        {/* Footer Message */}
        <div className="text-center pt-4 border-t">
          <p className="text-xs text-muted-foreground">
            💡 These recommendations are based on your performance across{' '}
            {recommendations.length > 0 ? recommendations[0].topic : 'various'} topics
          </p>
        </div>
      </CardContent>
    </Card>
  );
}
