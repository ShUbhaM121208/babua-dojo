import { useState, useEffect } from 'react';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Progress } from '@/components/ui/progress';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { 
  TrendingDown, 
  TrendingUp, 
  Minus, 
  Target,
  Brain,
  Zap,
  Calendar,
  CheckCircle2,
  AlertTriangle
} from 'lucide-react';
import { supabase } from '@/integrations/supabase/client';
import type { WeaknessAnalysis, ImprovementTrend } from '@/types/weakness';

interface WeaknessAnalysisDashboardProps {
  userId: string;
}

export function WeaknessAnalysisDashboard({ userId }: WeaknessAnalysisDashboardProps) {
  const [weaknesses, setWeaknesses] = useState<WeaknessAnalysis[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [selectedCategory, setSelectedCategory] = useState<string>('all');

  useEffect(() => {
    loadWeaknessAnalysis();
  }, [userId]);

  const loadWeaknessAnalysis = async () => {
    setIsLoading(true);
    try {
      const { data, error } = await supabase
        .from('weakness_analysis')
        .select('*')
        .eq('user_id', userId)
        .order('weakness_score', { ascending: false });

      if (error) throw error;
      setWeaknesses(data || []);
    } catch (error) {
      console.error('Error loading weakness analysis:', error);
    } finally {
      setIsLoading(false);
    }
  };

  const getTrendIcon = (trend: ImprovementTrend) => {
    switch (trend) {
      case 'improving':
        return <TrendingUp className="h-4 w-4 text-green-500" />;
      case 'declining':
        return <TrendingDown className="h-4 w-4 text-red-500" />;
      default:
        return <Minus className="h-4 w-4 text-yellow-500" />;
    }
  };

  const getWeaknessColor = (score: number) => {
    if (score >= 70) return 'destructive';
    if (score >= 40) return 'warning';
    return 'secondary';
  };

  const getCategoryColor = (category: string) => {
    const colors: Record<string, string> = {
      data_structures: 'bg-blue-500',
      algorithms: 'bg-purple-500',
      problem_solving: 'bg-green-500',
      coding_patterns: 'bg-orange-500',
      complexity_analysis: 'bg-pink-500'
    };
    return colors[category] || 'bg-gray-500';
  };

  const getCategoryLabel = (category: string) => {
    return category.replace(/_/g, ' ').replace(/\b\w/g, l => l.toUpperCase());
  };

  const categories = ['all', ...Array.from(new Set(weaknesses.map(w => w.category)))];
  const filteredWeaknesses = selectedCategory === 'all' 
    ? weaknesses 
    : weaknesses.filter(w => w.category === selectedCategory);

  const overallWeaknessScore = weaknesses.length > 0
    ? Math.round(weaknesses.reduce((sum, w) => sum + w.weakness_score, 0) / weaknesses.length)
    : 0;

  const improvingCount = weaknesses.filter(w => w.improvement_trend === 'improving').length;
  const decliningCount = weaknesses.filter(w => w.improvement_trend === 'declining').length;

  if (isLoading) {
    return (
      <Card>
        <CardContent className="py-8">
          <div className="flex items-center justify-center">
            <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary" />
          </div>
        </CardContent>
      </Card>
    );
  }

  return (
    <div className="space-y-6">
      {/* Overall Stats */}
      <div className="grid gap-4 md:grid-cols-3">
        <Card>
          <CardHeader className="pb-3">
            <CardDescription>Overall Weakness Score</CardDescription>
            <CardTitle className="text-3xl flex items-center gap-2">
              {overallWeaknessScore}
              <span className="text-lg text-muted-foreground">/100</span>
            </CardTitle>
          </CardHeader>
          <CardContent>
            <Progress value={100 - overallWeaknessScore} className="h-2" />
            <p className="text-xs text-muted-foreground mt-2">
              {100 - overallWeaknessScore}% mastery achieved
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="pb-3">
            <CardDescription>Improving Areas</CardDescription>
            <CardTitle className="text-3xl flex items-center gap-2">
              <TrendingUp className="h-6 w-6 text-green-500" />
              {improvingCount}
            </CardTitle>
          </CardHeader>
          <CardContent>
            <p className="text-sm text-muted-foreground">
              {weaknesses.length > 0 
                ? `${Math.round((improvingCount / weaknesses.length) * 100)}% showing progress`
                : 'No data yet'}
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="pb-3">
            <CardDescription>Needs Attention</CardDescription>
            <CardTitle className="text-3xl flex items-center gap-2">
              <AlertTriangle className="h-6 w-6 text-orange-500" />
              {weaknesses.filter(w => w.weakness_score >= 70).length}
            </CardTitle>
          </CardHeader>
          <CardContent>
            <p className="text-sm text-muted-foreground">
              Critical weaknesses requiring focus
            </p>
          </CardContent>
        </Card>
      </div>

      {/* Category Filter */}
      <Card>
        <CardHeader>
          <div className="flex items-center justify-between">
            <div>
              <CardTitle>Weakness Analysis</CardTitle>
              <CardDescription>
                Detailed breakdown of areas needing improvement
              </CardDescription>
            </div>
            <Button onClick={loadWeaknessAnalysis} variant="outline" size="sm">
              Refresh
            </Button>
          </div>
        </CardHeader>
        <CardContent>
          <Tabs value={selectedCategory} onValueChange={setSelectedCategory}>
            <TabsList className="grid grid-cols-6 w-full">
              {categories.map(cat => (
                <TabsTrigger key={cat} value={cat} className="text-xs">
                  {cat === 'all' ? 'All' : getCategoryLabel(cat).split(' ')[0]}
                </TabsTrigger>
              ))}
            </TabsList>

            <div className="mt-6 space-y-4">
              {filteredWeaknesses.length === 0 ? (
                <div className="text-center py-8 text-muted-foreground">
                  <Brain className="h-12 w-12 mx-auto mb-4 opacity-50" />
                  <p>No weaknesses identified yet</p>
                  <p className="text-sm">Keep practicing to get personalized insights!</p>
                </div>
              ) : (
                filteredWeaknesses.map(weakness => (
                  <Card key={weakness.id} className="overflow-hidden">
                    <div className="flex">
                      <div className={`w-1 ${getCategoryColor(weakness.category)}`} />
                      <div className="flex-1 p-4">
                        <div className="flex items-start justify-between mb-3">
                          <div>
                            <div className="flex items-center gap-2 mb-1">
                              <h3 className="font-semibold">
                                {getCategoryLabel(weakness.subcategory)}
                              </h3>
                              {getTrendIcon(weakness.improvement_trend)}
                              <Badge variant="outline" className="text-xs">
                                {getCategoryLabel(weakness.category)}
                              </Badge>
                            </div>
                            <p className="text-sm text-muted-foreground">
                              {weakness.failed_attempts} failed / {weakness.successful_attempts} successful attempts
                            </p>
                          </div>
                          <div className="text-right">
                            <div className="text-2xl font-bold text-destructive">
                              {weakness.weakness_score}
                            </div>
                            <p className="text-xs text-muted-foreground">weakness</p>
                          </div>
                        </div>

                        <Progress 
                          value={100 - weakness.weakness_score} 
                          className="h-2 mb-3"
                        />

                        {weakness.ai_insights && Object.keys(weakness.ai_insights).length > 0 && (
                          <div className="bg-muted/50 rounded-lg p-3 mb-3">
                            <div className="flex items-start gap-2">
                              <Zap className="h-4 w-4 text-primary mt-0.5 flex-shrink-0" />
                              <div className="text-sm">
                                <p className="font-medium mb-1">AI Insight</p>
                                <p className="text-muted-foreground">
                                  {weakness.ai_insights.summary || 'Focus on fundamental concepts and practice regularly'}
                                </p>
                              </div>
                            </div>
                          </div>
                        )}

                        {weakness.recommended_resources.length > 0 && (
                          <div className="flex flex-wrap gap-2">
                            {weakness.recommended_resources.slice(0, 3).map((resource, idx) => (
                              <Badge key={idx} variant="secondary" className="text-xs">
                                {resource}
                              </Badge>
                            ))}
                          </div>
                        )}

                        <div className="flex items-center justify-between mt-3 pt-3 border-t">
                          <div className="flex items-center gap-4 text-xs text-muted-foreground">
                            <div className="flex items-center gap-1">
                              <Target className="h-3 w-3" />
                              <span>{weakness.problem_ids.length} problems</span>
                            </div>
                            {weakness.avg_time_to_solve && (
                              <div className="flex items-center gap-1">
                                <Calendar className="h-3 w-3" />
                                <span>Avg {Math.round(weakness.avg_time_to_solve / 60)}min</span>
                              </div>
                            )}
                          </div>
                          <Badge variant={weakness.improvement_trend === 'improving' ? 'default' : 'secondary'}>
                            {weakness.improvement_trend}
                          </Badge>
                        </div>
                      </div>
                    </div>
                  </Card>
                ))
              )}
            </div>
          </Tabs>
        </CardContent>
      </Card>
    </div>
  );
}
