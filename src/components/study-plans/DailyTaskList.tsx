import { useState, useEffect } from 'react';
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Checkbox } from '@/components/ui/checkbox';
import { Badge } from '@/components/ui/badge';
import { CheckCircle2, Clock, TrendingUp, Calendar } from 'lucide-react';
import { useAuth } from '@/contexts/AuthContext';
import { useNavigate } from 'react-router-dom';
import { getTodayTasks, completeStudyItem, type StudyPlanItem } from '@/lib/studyPlanService';
import { useToast } from '@/hooks/use-toast';

export function DailyTaskList() {
  const { user } = useAuth();
  const { toast } = useToast();
  const navigate = useNavigate();
  const [tasks, setTasks] = useState<StudyPlanItem[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (user) {
      loadTodayTasks();
    }
  }, [user]);

  const loadTodayTasks = async () => {
    if (!user) return;
    
    setLoading(true);
    const todayTasks = await getTodayTasks(user.id); // No planId needed - gets all active plans
    setTasks(todayTasks || []);
    setLoading(false);
  };

  const handleToggleComplete = async (item: StudyPlanItem) => {
    if (!user) return;

    const success = await completeStudyItem(item.id, !item.is_completed);
    
    if (success) {
      toast({
        title: item.is_completed ? 'Task unchecked' : 'Task completed!',
        description: item.is_completed 
          ? 'Keep going!' 
          : `Great job completing "${item.title}"`,
      });
      loadTodayTasks();
    } else {
      toast({
        title: 'Error',
        description: 'Failed to update task',
        variant: 'destructive',
      });
    }
  };

  const handleClickTask = (item: StudyPlanItem) => {
    if (item.item_type === 'problem' && item.item_id) {
      navigate(`/practice/${item.item_id}`);
    }
  };

  const completedCount = tasks.filter(t => t.is_completed).length;
  const totalCount = tasks.length;
  const progressPercent = totalCount > 0 ? Math.round((completedCount / totalCount) * 100) : 0;

  const getDifficultyColor = (difficulty?: string) => {
    switch (difficulty) {
      case 'easy': return 'bg-green-500/10 text-green-500 border-green-500/20';
      case 'medium': return 'bg-yellow-500/10 text-yellow-500 border-yellow-500/20';
      case 'hard': return 'bg-red-500/10 text-red-500 border-red-500/20';
      default: return 'bg-muted text-muted-foreground';
    }
  };

  if (loading) {
    return (
      <Card>
        <CardHeader>
          <CardTitle className="text-xl flex items-center gap-2">
            <Calendar className="w-5 h-5" />
            Today's Study Tasks
          </CardTitle>
        </CardHeader>
        <CardContent>
          <div className="space-y-3">
            {[1, 2, 3].map(i => (
              <div key={i} className="h-16 bg-muted animate-pulse rounded-lg" />
            ))}
          </div>
        </CardContent>
      </Card>
    );
  }

  if (tasks.length === 0) {
    return (
      <Card>
        <CardHeader>
          <CardTitle className="text-xl flex items-center gap-2">
            <Calendar className="w-5 h-5" />
            Today's Study Tasks
          </CardTitle>
        </CardHeader>
        <CardContent>
          <div className="text-center py-8">
            <CheckCircle2 className="w-12 h-12 text-muted-foreground mx-auto mb-3" />
            <p className="text-muted-foreground">
              No tasks scheduled for today. Enjoy your rest or explore new problems!
            </p>
            <Button 
              variant="outline" 
              className="mt-4"
              onClick={() => navigate('/study-plans')}
            >
              View Study Plans
            </Button>
          </div>
        </CardContent>
      </Card>
    );
  }

  return (
    <Card>
      <CardHeader>
        <div className="flex items-center justify-between">
          <CardTitle className="text-xl flex items-center gap-2">
            <Calendar className="w-5 h-5" />
            Today's Study Tasks
          </CardTitle>
          <div className="flex items-center gap-2">
            <span className="text-sm text-muted-foreground">
              {completedCount}/{totalCount}
            </span>
            <Badge variant={progressPercent === 100 ? 'default' : 'secondary'}>
              {progressPercent}%
            </Badge>
          </div>
        </div>
      </CardHeader>
      <CardContent>
        <div className="space-y-3">
          {tasks.map((task) => (
            <div
              key={task.id}
              className={`flex items-start gap-3 p-3 rounded-lg border transition-colors ${
                task.is_completed 
                  ? 'bg-muted/50 border-muted' 
                  : 'bg-card hover:bg-accent/50 border-border'
              }`}
            >
              <Checkbox
                checked={task.is_completed}
                onCheckedChange={() => handleToggleComplete(task)}
                className="mt-1"
              />
              
              <div className="flex-1 min-w-0">
                <div className="flex items-center gap-2 mb-1">
                  <h4
                    className={`font-medium cursor-pointer hover:underline ${
                      task.is_completed ? 'line-through text-muted-foreground' : ''
                    }`}
                    onClick={() => handleClickTask(task)}
                  >
                    {task.title}
                  </h4>
                  {task.problem_difficulty && (
                    <Badge 
                      variant="outline" 
                      className={getDifficultyColor(task.problem_difficulty)}
                    >
                      {task.problem_difficulty}
                    </Badge>
                  )}
                  {task.ai_recommended && (
                    <Badge variant="outline" className="bg-purple-500/10 text-purple-500">
                      AI
                    </Badge>
                  )}
                </div>
                
                {task.description && (
                  <p className="text-sm text-muted-foreground line-clamp-2">
                    {task.description}
                  </p>
                )}
                
                <div className="flex items-center gap-4 mt-2 text-xs text-muted-foreground">
                  {task.estimated_time_minutes && (
                    <span className="flex items-center gap-1">
                      <Clock className="w-3 h-3" />
                      {task.estimated_time_minutes} min
                    </span>
                  )}
                  {task.problem_tags && task.problem_tags.length > 0 && (
                    <span className="flex items-center gap-1">
                      <TrendingUp className="w-3 h-3" />
                      {task.problem_tags.slice(0, 2).join(', ')}
                    </span>
                  )}
                </div>
              </div>
            </div>
          ))}
        </div>

        {totalCount > 0 && completedCount === totalCount && (
          <div className="mt-4 p-4 bg-primary/10 border border-primary/20 rounded-lg text-center">
            <CheckCircle2 className="w-8 h-8 text-primary mx-auto mb-2" />
            <p className="font-medium text-primary">
              🎉 All tasks completed for today!
            </p>
            <p className="text-sm text-muted-foreground mt-1">
              Keep up the amazing work!
            </p>
          </div>
        )}
      </CardContent>
    </Card>
  );
}
