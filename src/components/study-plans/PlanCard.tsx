import { useState } from "react";
import { Card, CardHeader, CardTitle, CardDescription, CardContent, CardFooter } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Progress } from "@/components/ui/progress";
import { 
  Calendar, 
  Target, 
  Play, 
  Pause, 
  Trash2, 
  MoreVertical,
  CheckCircle2,
  Clock
} from "lucide-react";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { useToast } from "@/hooks/use-toast";
import { useNavigate } from "react-router-dom";
import { type StudyPlan, deleteStudyPlan, startStudyPlan, updateStudyPlan } from "@/lib/studyPlanService";

interface PlanCardProps {
  plan: StudyPlan;
  onUpdate: () => void;
}

export function PlanCard({ plan, onUpdate }: PlanCardProps) {
  const { toast } = useToast();
  const navigate = useNavigate();
  const [loading, setLoading] = useState(false);

  const progressPercent = plan.total_items && plan.total_items > 0 
    ? Math.round((plan.items_completed || 0) / plan.total_items * 100) 
    : 0;

  const getDifficultyColor = (difficulty: string) => {
    switch (difficulty) {
      case 'beginner': return 'bg-green-500/10 text-green-500 border-green-500/20';
      case 'intermediate': return 'bg-yellow-500/10 text-yellow-500 border-yellow-500/20';
      case 'advanced': return 'bg-red-500/10 text-red-500 border-red-500/20';
      case 'mixed': return 'bg-blue-500/10 text-blue-500 border-blue-500/20';
      default: return 'bg-muted text-muted-foreground';
    }
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'active': return 'bg-green-500/10 text-green-500 border-green-500/20';
      case 'paused': return 'bg-yellow-500/10 text-yellow-500 border-yellow-500/20';
      case 'completed': return 'bg-blue-500/10 text-blue-500 border-blue-500/20';
      case 'draft': return 'bg-gray-500/10 text-gray-500 border-gray-500/20';
      default: return 'bg-muted text-muted-foreground';
    }
  };

  const getDaysRemaining = () => {
    if (!plan.start_date || !plan.duration_days) return null;
    const startDate = new Date(plan.start_date);
    const endDate = new Date(startDate);
    endDate.setDate(endDate.getDate() + plan.duration_days);
    const today = new Date();
    const daysLeft = Math.ceil((endDate.getTime() - today.getTime()) / (1000 * 60 * 60 * 24));
    return daysLeft;
  };

  const handleDelete = async () => {
    if (!confirm('Are you sure you want to delete this study plan?')) return;
    
    setLoading(true);
    const success = await deleteStudyPlan(plan.id);
    setLoading(false);

    if (success) {
      toast({
        title: 'Plan deleted',
        description: 'Study plan has been removed',
      });
      onUpdate();
    } else {
      toast({
        title: 'Error',
        description: 'Failed to delete plan',
        variant: 'destructive',
      });
    }
  };

  const handleTogglePause = async () => {
    setLoading(true);
    const newStatus = plan.status === 'active' ? 'paused' : 'active';
    const success = await updateStudyPlan(plan.id, { status: newStatus });
    setLoading(false);

    if (success) {
      toast({
        title: newStatus === 'active' ? 'Plan resumed' : 'Plan paused',
        description: `Study plan is now ${newStatus}`,
      });
      onUpdate();
    } else {
      toast({
        title: 'Error',
        description: 'Failed to update plan status',
        variant: 'destructive',
      });
    }
  };

  const handleStart = async () => {
    setLoading(true);
    const success = await startStudyPlan(plan.id);
    setLoading(false);

    if (success) {
      toast({
        title: 'Plan started',
        description: 'Your study plan is now active',
      });
      onUpdate();
    } else {
      toast({
        title: 'Error',
        description: 'Failed to start plan',
        variant: 'destructive',
      });
    }
  };

  const daysRemaining = getDaysRemaining();

  return (
    <Card className="hover:border-primary/50 transition-colors cursor-pointer group">
      <CardHeader>
        <div className="flex items-start justify-between">
          <div className="flex-1">
            <div className="flex items-center gap-2 mb-2">
              <Badge variant="outline" className={getDifficultyColor(plan.difficulty || 'mixed')}>
                {plan.difficulty || 'mixed'}
              </Badge>
              <Badge variant="outline" className={getStatusColor(plan.status || 'draft')}>
                {plan.status || 'draft'}
              </Badge>
            </div>
            <CardTitle className="group-hover:text-primary transition-colors" onClick={() => navigate(`/study-plans/${plan.id}`)}>
              {plan.title}
            </CardTitle>
            {plan.description && (
              <CardDescription className="mt-2 line-clamp-2">
                {plan.description}
              </CardDescription>
            )}
          </div>
          <DropdownMenu>
            <DropdownMenuTrigger asChild>
              <Button variant="ghost" size="icon" disabled={loading}>
                <MoreVertical className="w-4 h-4" />
              </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent align="end">
              {plan.status === 'draft' && (
                <DropdownMenuItem onClick={handleStart}>
                  <Play className="w-4 h-4 mr-2" />
                  Start Plan
                </DropdownMenuItem>
              )}
              {(plan.status === 'active' || plan.status === 'paused') && (
                <DropdownMenuItem onClick={handleTogglePause}>
                  {plan.status === 'active' ? (
                    <>
                      <Pause className="w-4 h-4 mr-2" />
                      Pause Plan
                    </>
                  ) : (
                    <>
                      <Play className="w-4 h-4 mr-2" />
                      Resume Plan
                    </>
                  )}
                </DropdownMenuItem>
              )}
              <DropdownMenuItem onClick={handleDelete} className="text-destructive">
                <Trash2 className="w-4 h-4 mr-2" />
                Delete Plan
              </DropdownMenuItem>
            </DropdownMenuContent>
          </DropdownMenu>
        </div>
      </CardHeader>

      <CardContent onClick={() => navigate(`/study-plans/${plan.id}`)}>
        <div className="space-y-4">
          {/* Progress */}
          <div>
            <div className="flex items-center justify-between mb-2 text-sm">
              <span className="text-muted-foreground">Progress</span>
              <span className="font-medium">{progressPercent}%</span>
            </div>
            <Progress value={progressPercent} className="h-2" />
            <div className="flex items-center justify-between mt-1 text-xs text-muted-foreground">
              <span>{plan.items_completed || 0} completed</span>
              <span>{plan.total_items || 0} total items</span>
            </div>
          </div>

          {/* Stats */}
          <div className="grid grid-cols-2 gap-3">
            <div className="flex items-center gap-2 text-sm">
              <Calendar className="w-4 h-4 text-muted-foreground" />
              <span className="text-muted-foreground">
                {plan.duration_days || 30} days
              </span>
            </div>
            {daysRemaining !== null && daysRemaining >= 0 && (
              <div className="flex items-center gap-2 text-sm">
                <Clock className="w-4 h-4 text-muted-foreground" />
                <span className="text-muted-foreground">
                  {daysRemaining} days left
                </span>
              </div>
            )}
            {plan.target_completion_date && (
              <div className="flex items-center gap-2 text-sm">
                <Target className="w-4 h-4 text-muted-foreground" />
                <span className="text-muted-foreground">
                  {new Date(plan.target_completion_date).toLocaleDateString()}
                </span>
              </div>
            )}
            {plan.status === 'completed' && (
              <div className="flex items-center gap-2 text-sm">
                <CheckCircle2 className="w-4 h-4 text-green-500" />
                <span className="text-green-500">Completed</span>
              </div>
            )}
          </div>

          {/* Topics */}
          {plan.topics && plan.topics.length > 0 && (
            <div className="flex flex-wrap gap-2">
              {plan.topics.slice(0, 3).map((topic, index) => (
                <Badge key={index} variant="secondary" className="text-xs">
                  {topic}
                </Badge>
              ))}
              {plan.topics.length > 3 && (
                <Badge variant="secondary" className="text-xs">
                  +{plan.topics.length - 3} more
                </Badge>
              )}
            </div>
          )}
        </div>
      </CardContent>

      <CardFooter>
        <Button 
          variant="outline" 
          className="w-full" 
          onClick={() => navigate(`/study-plans/${plan.id}`)}
        >
          View Details
        </Button>
      </CardFooter>
    </Card>
  );
}
