import { useState, useEffect } from 'react';
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card';
import { Calendar as CalendarIcon, TrendingUp } from 'lucide-react';
import { useAuth } from '@/contexts/AuthContext';
import { getDailyProgress, type DailyProgress } from '@/lib/studyPlanService';

interface ProgressChartProps {
  planId?: string;
  view?: 'weekly' | 'monthly';
}

export function ProgressChart({ planId, view = 'weekly' }: ProgressChartProps) {
  const { user } = useAuth();
  const [progress, setProgress] = useState<DailyProgress[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (user) {
      loadProgress();
    }
  }, [user, planId, view]);

  const loadProgress = async () => {
    if (!user) return;
    
    setLoading(true);
    const days = view === 'weekly' ? 7 : 30;
    const startDate = new Date();
    startDate.setDate(startDate.getDate() - days);
    
    const progressData = await getDailyProgress(
      user.id, 
      planId || '', 
      startDate.toISOString().split('T')[0],
      new Date().toISOString().split('T')[0]
    );
    
    // Handle array return type
    const progressArray = Array.isArray(progressData) ? progressData : [];
    setProgress(progressArray);
    setLoading(false);
  };

  const getDayLabel = (date: string) => {
    const d = new Date(date);
    return d.toLocaleDateString('en-US', { weekday: 'short' });
  };

  const getMaxValue = () => {
    return Math.max(...progress.map(p => p.items_completed), 10);
  };

  const getCurrentStreak = () => {
    let streak = 0;
    const sortedProgress = [...progress].sort((a, b) => 
      new Date(b.date).getTime() - new Date(a.date).getTime()
    );
    
    for (const day of sortedProgress) {
      if (day.streak_maintained && day.items_completed > 0) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  };

  const totalItemsCompleted = progress.reduce((acc, p) => acc + p.items_completed, 0);
  const totalTimeSpent = progress.reduce((acc, p) => acc + p.time_spent_minutes, 0);
  const avgItemsPerDay = progress.length > 0 
    ? (totalItemsCompleted / progress.length).toFixed(1) 
    : 0;

  if (loading) {
    return (
      <Card>
        <CardHeader>
          <CardTitle className="text-xl flex items-center gap-2">
            <TrendingUp className="w-5 h-5" />
            Progress Chart
          </CardTitle>
        </CardHeader>
        <CardContent>
          <div className="h-64 bg-muted animate-pulse rounded-lg" />
        </CardContent>
      </Card>
    );
  }

  return (
    <Card>
      <CardHeader>
        <CardTitle className="text-xl flex items-center gap-2">
          <TrendingUp className="w-5 h-5" />
          Progress Chart - {view === 'weekly' ? 'Last 7 Days' : 'Last 30 Days'}
        </CardTitle>
      </CardHeader>
      <CardContent>
        {/* Stats Summary */}
        <div className="grid grid-cols-3 gap-4 mb-6">
          <div className="text-center p-3 bg-muted/50 rounded-lg">
            <div className="text-2xl font-bold text-primary">{getCurrentStreak()}</div>
            <div className="text-xs text-muted-foreground">Day Streak</div>
          </div>
          <div className="text-center p-3 bg-muted/50 rounded-lg">
            <div className="text-2xl font-bold text-primary">{totalItemsCompleted}</div>
            <div className="text-xs text-muted-foreground">Items Done</div>
          </div>
          <div className="text-center p-3 bg-muted/50 rounded-lg">
            <div className="text-2xl font-bold text-primary">{avgItemsPerDay}</div>
            <div className="text-xs text-muted-foreground">Avg/Day</div>
          </div>
        </div>

        {/* Bar Chart */}
        <div className="space-y-2">
          {progress.length === 0 ? (
            <div className="text-center py-8 text-muted-foreground">
              <CalendarIcon className="w-12 h-12 mx-auto mb-2 opacity-50" />
              <p>No progress data yet for this period</p>
            </div>
          ) : (
            <div className="flex items-end justify-between gap-2 h-48">
              {progress.map((day, index) => {
                const heightPercent = (day.items_completed / getMaxValue()) * 100;
                const isToday = new Date(day.date).toDateString() === new Date().toDateString();
                
                return (
                  <div key={index} className="flex-1 flex flex-col items-center gap-2">
                    <div className="relative w-full flex items-end justify-center h-40">
                      <div
                        className={`w-full rounded-t transition-all ${
                          isToday
                            ? 'bg-primary'
                            : day.items_completed > 0
                            ? 'bg-primary/70 hover:bg-primary/90'
                            : 'bg-muted'
                        }`}
                        style={{ height: `${Math.max(heightPercent, 5)}%` }}
                        title={`${day.items_completed} items on ${day.date}`}
                      >
                        {day.items_completed > 0 && (
                          <div className="text-xs text-center text-white font-bold pt-1">
                            {day.items_completed}
                          </div>
                        )}
                      </div>
                    </div>
                    <div className={`text-xs ${isToday ? 'font-bold text-primary' : 'text-muted-foreground'}`}>
                      {getDayLabel(day.date)}
                    </div>
                  </div>
                );
              })}
            </div>
          )}
        </div>

        {/* Time Stats */}
        {totalTimeSpent > 0 && (
          <div className="mt-6 pt-6 border-t text-center text-sm text-muted-foreground">
            Total time spent: <span className="font-semibold text-foreground">
              {Math.floor(totalTimeSpent / 60)}h {totalTimeSpent % 60}m
            </span>
          </div>
        )}
      </CardContent>
    </Card>
  );
}
