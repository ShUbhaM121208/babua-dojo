import { useState, useEffect } from 'react';
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Checkbox } from '@/components/ui/checkbox';
import { 
  Calendar, 
  CheckCircle2, 
  Circle, 
  Clock, 
  GripVertical,
  Video,
  BookOpen,
  Trophy
} from 'lucide-react';
import { useAuth } from '@/contexts/AuthContext';
import { useNavigate } from 'react-router-dom';
import { 
  getStudyPlanItems, 
  completeStudyItem,
  type StudyPlanItem 
} from '@/lib/studyPlanService';
import { useToast } from '@/hooks/use-toast';

interface PlanTimelineProps {
  planId: string;
}

export function PlanTimeline({ planId }: PlanTimelineProps) {
  const { user } = useAuth();
  const { toast } = useToast();
  const navigate = useNavigate();
  const [items, setItems] = useState<StudyPlanItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [expandedDays, setExpandedDays] = useState<Set<number>>(new Set([1]));

  useEffect(() => {
    if (user && planId) {
      loadItems();
    }
  }, [user, planId]);

  const loadItems = async () => {
    setLoading(true);
    const planItems = await getStudyPlanItems(planId);
    setItems(planItems || []);
    setLoading(false);
  };

  const handleToggleComplete = async (item: StudyPlanItem) => {
    const success = await completeStudyItem(item.id, !item.is_completed);
    
    if (success) {
      toast({
        title: item.is_completed ? 'Item unchecked' : 'Item completed!',
        description: item.is_completed ? '' : `Great job! "${item.title}" is done`,
      });
      loadItems();
    } else {
      toast({
        title: 'Error',
        description: 'Failed to update item',
        variant: 'destructive',
      });
    }
  };

  const handleClickItem = (item: StudyPlanItem) => {
    if (item.item_type === 'problem' && item.item_id) {
      navigate(`/practice/${item.item_id}`);
    } else if (item.item_type === 'resource' && item.resource_url) {
      window.open(item.resource_url, '_blank');
    }
  };

  const toggleDay = (dayNumber: number) => {
    const newExpanded = new Set(expandedDays);
    if (newExpanded.has(dayNumber)) {
      newExpanded.delete(dayNumber);
    } else {
      newExpanded.add(dayNumber);
    }
    setExpandedDays(newExpanded);
  };

  // Group items by day
  const itemsByDay = items.reduce((acc, item) => {
    if (!acc[item.day_number]) {
      acc[item.day_number] = [];
    }
    acc[item.day_number].push(item);
    return acc;
  }, {} as Record<number, StudyPlanItem[]>);

  const sortedDays = Object.keys(itemsByDay)
    .map(Number)
    .sort((a, b) => a - b);

  const getItemIcon = (type: string) => {
    switch (type) {
      case 'problem': return Circle;
      case 'topic': return BookOpen;
      case 'resource': return Video;
      case 'milestone': return Trophy;
      default: return Circle;
    }
  };

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
            Study Timeline
          </CardTitle>
        </CardHeader>
        <CardContent>
          <div className="space-y-4">
            {[1, 2, 3].map(i => (
              <div key={i} className="h-24 bg-muted animate-pulse rounded-lg" />
            ))}
          </div>
        </CardContent>
      </Card>
    );
  }

  if (items.length === 0) {
    return (
      <Card>
        <CardHeader>
          <CardTitle className="text-xl flex items-center gap-2">
            <Calendar className="w-5 h-5" />
            Study Timeline
          </CardTitle>
        </CardHeader>
        <CardContent>
          <div className="text-center py-8 text-muted-foreground">
            <Calendar className="w-12 h-12 mx-auto mb-3 opacity-50" />
            <p>No items in this study plan yet</p>
            <p className="text-sm mt-2">Add problems, topics, and resources to get started</p>
          </div>
        </CardContent>
      </Card>
    );
  }

  return (
    <Card>
      <CardHeader>
        <CardTitle className="text-xl flex items-center gap-2">
          <Calendar className="w-5 h-5" />
          Study Timeline
        </CardTitle>
      </CardHeader>
      <CardContent>
        <div className="space-y-2">
          {sortedDays.map((dayNumber) => {
            const dayItems = itemsByDay[dayNumber];
            const completedCount = dayItems.filter(i => i.is_completed).length;
            const totalCount = dayItems.length;
            const isExpanded = expandedDays.has(dayNumber);
            const progressPercent = (completedCount / totalCount) * 100;

            return (
              <div key={dayNumber} className="border rounded-lg overflow-hidden">
                {/* Day Header */}
                <button
                  onClick={() => toggleDay(dayNumber)}
                  className="w-full p-4 flex items-center justify-between hover:bg-accent/50 transition-colors"
                >
                  <div className="flex items-center gap-3">
                    <div className="flex items-center justify-center w-10 h-10 rounded-full bg-primary/10 text-primary font-bold">
                      {dayNumber}
                    </div>
                    <div className="text-left">
                      <div className="font-semibold">Day {dayNumber}</div>
                      <div className="text-sm text-muted-foreground">
                        {completedCount}/{totalCount} items completed
                      </div>
                    </div>
                  </div>
                  <div className="flex items-center gap-3">
                    {progressPercent === 100 && (
                      <Badge variant="outline" className="bg-green-500/10 text-green-500">
                        <CheckCircle2 className="w-3 h-3 mr-1" />
                        Done
                      </Badge>
                    )}
                    <div className="w-24 h-2 bg-muted rounded-full overflow-hidden">
                      <div 
                        className="h-full bg-primary transition-all"
                        style={{ width: `${progressPercent}%` }}
                      />
                    </div>
                  </div>
                </button>

                {/* Day Items */}
                {isExpanded && (
                  <div className="border-t bg-muted/30 p-4 space-y-2">
                    {dayItems
                      .sort((a, b) => a.order_in_day - b.order_in_day)
                      .map((item) => {
                        const ItemIcon = getItemIcon(item.item_type);
                        
                        return (
                          <div
                            key={item.id}
                            className={`flex items-start gap-3 p-3 rounded-lg border bg-card transition-all ${
                              item.is_completed 
                                ? 'opacity-60 border-muted' 
                                : 'hover:border-primary/50'
                            }`}
                          >
                            <GripVertical className="w-4 h-4 text-muted-foreground mt-1 cursor-grab" />
                            
                            <Checkbox
                              checked={item.is_completed}
                              onCheckedChange={() => handleToggleComplete(item)}
                              className="mt-1"
                            />
                            
                            <ItemIcon className="w-5 h-5 text-muted-foreground mt-0.5" />
                            
                            <div className="flex-1 min-w-0">
                              <div className="flex items-center gap-2 mb-1 flex-wrap">
                                <h4
                                  className={`font-medium cursor-pointer hover:underline ${
                                    item.is_completed ? 'line-through text-muted-foreground' : ''
                                  }`}
                                  onClick={() => handleClickItem(item)}
                                >
                                  {item.title}
                                </h4>
                                
                                {item.problem_difficulty && (
                                  <Badge 
                                    variant="outline" 
                                    className={getDifficultyColor(item.problem_difficulty)}
                                  >
                                    {item.problem_difficulty}
                                  </Badge>
                                )}
                                
                                {item.is_optional && (
                                  <Badge variant="outline" className="text-xs">
                                    Optional
                                  </Badge>
                                )}
                                
                                {item.ai_recommended && (
                                  <Badge variant="outline" className="bg-purple-500/10 text-purple-500 text-xs">
                                    AI Recommended
                                  </Badge>
                                )}
                              </div>
                              
                              {item.description && (
                                <p className="text-sm text-muted-foreground mb-2">
                                  {item.description}
                                </p>
                              )}
                              
                              {item.recommendation_reason && (
                                <p className="text-xs text-purple-500 mb-2">
                                  💡 {item.recommendation_reason}
                                </p>
                              )}
                              
                              <div className="flex items-center gap-3 text-xs text-muted-foreground">
                                {item.estimated_time_minutes && (
                                  <span className="flex items-center gap-1">
                                    <Clock className="w-3 h-3" />
                                    {item.estimated_time_minutes} min
                                  </span>
                                )}
                                
                                {item.problem_tags && item.problem_tags.length > 0 && (
                                  <span>
                                    {item.problem_tags.slice(0, 3).map(tag => (
                                      <Badge key={tag} variant="outline" className="mr-1 text-xs">
                                        {tag}
                                      </Badge>
                                    ))}
                                  </span>
                                )}
                              </div>
                            </div>
                          </div>
                        );
                      })}
                  </div>
                )}
              </div>
            );
          })}
        </div>

        {/* Expand/Collapse All */}
        <div className="mt-4 flex justify-center gap-2">
          <Button
            variant="outline"
            size="sm"
            onClick={() => setExpandedDays(new Set(sortedDays))}
          >
            Expand All
          </Button>
          <Button
            variant="outline"
            size="sm"
            onClick={() => setExpandedDays(new Set())}
          >
            Collapse All
          </Button>
        </div>
      </CardContent>
    </Card>
  );
}
