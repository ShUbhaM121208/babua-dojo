import { useState, useEffect } from 'react';
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Textarea } from '@/components/ui/textarea';
import { Smile, Frown, Meh, ThumbsUp, Save } from 'lucide-react';
import { useAuth } from '@/contexts/AuthContext';
import { useToast } from '@/hooks/use-toast';
import { 
  getTodayProgress, 
  updateDailyProgress, 
  type DailyProgress 
} from '@/lib/studyPlanService';

interface MoodTrackerProps {
  planId: string;
}

export function MoodTracker({ planId }: MoodTrackerProps) {
  const { user } = useAuth();
  const { toast } = useToast();
  const [selectedMood, setSelectedMood] = useState<'productive' | 'struggling' | 'confident' | null>(null);
  const [notes, setNotes] = useState('');
  const [loading, setLoading] = useState(false);
  const [todayProgress, setTodayProgress] = useState<DailyProgress | null>(null);

  useEffect(() => {
    if (user && planId) {
      loadTodayProgress();
    }
  }, [user, planId]);

  const loadTodayProgress = async () => {
    if (!user) return;
    
    const today = new Date().toISOString().split('T')[0];
    const progress = await getTodayProgress(user.id, planId, today);
    
    if (progress) {
      setTodayProgress(progress);
      setSelectedMood(progress.mood as any);
      setNotes(progress.daily_notes || '');
    }
  };

  const handleSave = async () => {
    if (!user || !planId) return;
    
    setLoading(true);
    const today = new Date().toISOString().split('T')[0];
    
    const success = await updateDailyProgress(user.id, planId, today, {
      mood: selectedMood,
      daily_notes: notes,
    });
    
    setLoading(false);
    
    if (success) {
      toast({
        title: 'Progress saved',
        description: 'Your daily progress has been updated',
      });
      loadTodayProgress();
    } else {
      toast({
        title: 'Error',
        description: 'Failed to save progress',
        variant: 'destructive',
      });
    }
  };

  const moods = [
    { 
      value: 'productive' as const, 
      icon: ThumbsUp, 
      label: 'Productive',
      color: 'text-green-500',
      bgColor: 'bg-green-500/10 hover:bg-green-500/20 border-green-500/20'
    },
    { 
      value: 'confident' as const, 
      icon: Smile, 
      label: 'Confident',
      color: 'text-blue-500',
      bgColor: 'bg-blue-500/10 hover:bg-blue-500/20 border-blue-500/20'
    },
    { 
      value: 'struggling' as const, 
      icon: Frown, 
      label: 'Struggling',
      color: 'text-yellow-500',
      bgColor: 'bg-yellow-500/10 hover:bg-yellow-500/20 border-yellow-500/20'
    },
  ];

  return (
    <Card>
      <CardHeader>
        <CardTitle className="text-xl">How are you feeling today?</CardTitle>
      </CardHeader>
      <CardContent className="space-y-4">
        {/* Mood Selector */}
        <div className="grid grid-cols-3 gap-3">
          {moods.map((mood) => {
            const Icon = mood.icon;
            const isSelected = selectedMood === mood.value;
            
            return (
              <button
                key={mood.value}
                onClick={() => setSelectedMood(mood.value)}
                className={`p-4 rounded-lg border-2 transition-all ${
                  isSelected 
                    ? `${mood.bgColor} border-current` 
                    : 'border-border hover:border-muted-foreground/50'
                }`}
              >
                <Icon className={`w-8 h-8 mx-auto mb-2 ${isSelected ? mood.color : 'text-muted-foreground'}`} />
                <div className={`text-sm font-medium ${isSelected ? mood.color : 'text-muted-foreground'}`}>
                  {mood.label}
                </div>
              </button>
            );
          })}
        </div>

        {/* Notes */}
        <div className="space-y-2">
          <label className="text-sm font-medium">Daily Notes (Optional)</label>
          <Textarea
            placeholder="What did you learn today? Any challenges or breakthroughs?"
            value={notes}
            onChange={(e) => setNotes(e.target.value)}
            rows={4}
            className="resize-none"
          />
        </div>

        {/* Save Button */}
        <Button 
          onClick={handleSave} 
          disabled={loading || !selectedMood}
          className="w-full"
        >
          <Save className="w-4 h-4 mr-2" />
          {loading ? 'Saving...' : 'Save Progress'}
        </Button>

        {/* Mood History Preview */}
        {todayProgress && (
          <div className="pt-4 border-t text-sm text-muted-foreground">
            <p>
              Today you completed <span className="font-semibold text-foreground">
                {todayProgress.items_completed} items
              </span> in <span className="font-semibold text-foreground">
                {todayProgress.time_spent_minutes} minutes
              </span>
            </p>
          </div>
        )}
      </CardContent>
    </Card>
  );
}
