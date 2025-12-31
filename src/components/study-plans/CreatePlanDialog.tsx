import { useState } from "react";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Badge } from "@/components/ui/badge";
import { useToast } from "@/hooks/use-toast";
import { useAuth } from "@/contexts/AuthContext";
import { Loader2, X } from "lucide-react";
import { createStudyPlan } from "@/lib/studyPlanService";

interface CreatePlanDialogProps {
  open: boolean;
  onClose: () => void;
  onSuccess: () => void;
}

export function CreatePlanDialog({ open, onClose, onSuccess }: CreatePlanDialogProps) {
  const { user } = useAuth();
  const { toast } = useToast();
  const [loading, setLoading] = useState(false);
  const [formData, setFormData] = useState({
    title: '',
    description: '',
    difficulty: 'mixed' as 'beginner' | 'intermediate' | 'advanced' | 'mixed',
    duration_days: 30,
    daily_target_items: 3,
    topics: [] as string[],
  });
  const [topicInput, setTopicInput] = useState('');

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!user) {
      toast({
        title: 'Error',
        description: 'You must be logged in to create a study plan',
        variant: 'destructive',
      });
      return;
    }

    if (!formData.title.trim()) {
      toast({
        title: 'Error',
        description: 'Please enter a plan title',
        variant: 'destructive',
      });
      return;
    }

    setLoading(true);
    const planData = {
      user_id: user.id,
      title: formData.title,
      description: formData.description || null,
      difficulty: formData.difficulty,
      duration_days: formData.duration_days,
      daily_target_items: formData.daily_target_items,
      topics: formData.topics.length > 0 ? formData.topics : null,
      status: 'draft' as const,
    };

    const newPlan = await createStudyPlan(planData);
    setLoading(false);

    if (newPlan) {
      toast({
        title: 'Plan created!',
        description: 'Your study plan has been created successfully',
      });
      // Reset form
      setFormData({
        title: '',
        description: '',
        difficulty: 'mixed',
        duration_days: 30,
        daily_target_items: 3,
        topics: [],
      });
      setTopicInput('');
      onSuccess();
      onClose();
    } else {
      toast({
        title: 'Error',
        description: 'Failed to create study plan',
        variant: 'destructive',
      });
    }
  };

  const handleAddTopic = () => {
    const topic = topicInput.trim();
    if (topic && !formData.topics.includes(topic)) {
      setFormData(prev => ({
        ...prev,
        topics: [...prev.topics, topic],
      }));
      setTopicInput('');
    }
  };

  const handleRemoveTopic = (topicToRemove: string) => {
    setFormData(prev => ({
      ...prev,
      topics: prev.topics.filter(t => t !== topicToRemove),
    }));
  };

  const handleKeyDown = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter') {
      e.preventDefault();
      handleAddTopic();
    }
  };

  return (
    <Dialog open={open} onOpenChange={onClose}>
      <DialogContent className="max-w-2xl max-h-[90vh] overflow-y-auto">
        <DialogHeader>
          <DialogTitle>Create Study Plan</DialogTitle>
        </DialogHeader>

        <form onSubmit={handleSubmit} className="space-y-6 mt-4">
          {/* Title */}
          <div className="space-y-2">
            <Label htmlFor="title">Plan Title *</Label>
            <Input
              id="title"
              placeholder="e.g., Master Dynamic Programming"
              value={formData.title}
              onChange={(e) => setFormData(prev => ({ ...prev, title: e.target.value }))}
              disabled={loading}
            />
          </div>

          {/* Description */}
          <div className="space-y-2">
            <Label htmlFor="description">Description</Label>
            <Textarea
              id="description"
              placeholder="Describe your learning goals and what you want to achieve..."
              value={formData.description}
              onChange={(e) => setFormData(prev => ({ ...prev, description: e.target.value }))}
              rows={3}
              disabled={loading}
            />
          </div>

          {/* Difficulty and Duration */}
          <div className="grid grid-cols-2 gap-4">
            <div className="space-y-2">
              <Label htmlFor="difficulty">Difficulty Level</Label>
              <Select
                value={formData.difficulty}
                onValueChange={(value: any) => setFormData(prev => ({ ...prev, difficulty: value }))}
                disabled={loading}
              >
                <SelectTrigger id="difficulty">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="beginner">Beginner</SelectItem>
                  <SelectItem value="intermediate">Intermediate</SelectItem>
                  <SelectItem value="advanced">Advanced</SelectItem>
                  <SelectItem value="mixed">Mixed</SelectItem>
                </SelectContent>
              </Select>
            </div>

            <div className="space-y-2">
              <Label htmlFor="duration">Duration (days)</Label>
              <Input
                id="duration"
                type="number"
                min="1"
                max="365"
                value={formData.duration_days}
                onChange={(e) => setFormData(prev => ({ ...prev, duration_days: parseInt(e.target.value) || 30 }))}
                disabled={loading}
              />
            </div>
          </div>

          {/* Daily Target */}
          <div className="space-y-2">
            <Label htmlFor="daily-target">Daily Target Items</Label>
            <Input
              id="daily-target"
              type="number"
              min="1"
              max="20"
              value={formData.daily_target_items}
              onChange={(e) => setFormData(prev => ({ ...prev, daily_target_items: parseInt(e.target.value) || 3 }))}
              disabled={loading}
            />
            <p className="text-xs text-muted-foreground">
              Number of items you plan to complete each day
            </p>
          </div>

          {/* Topics */}
          <div className="space-y-2">
            <Label htmlFor="topics">Topics (optional)</Label>
            <div className="flex gap-2">
              <Input
                id="topics"
                placeholder="Add a topic (e.g., Arrays, Graphs)"
                value={topicInput}
                onChange={(e) => setTopicInput(e.target.value)}
                onKeyDown={handleKeyDown}
                disabled={loading}
              />
              <Button type="button" onClick={handleAddTopic} disabled={loading || !topicInput.trim()}>
                Add
              </Button>
            </div>
            {formData.topics.length > 0 && (
              <div className="flex flex-wrap gap-2 mt-3">
                {formData.topics.map((topic) => (
                  <Badge key={topic} variant="secondary" className="gap-1">
                    {topic}
                    <button
                      type="button"
                      onClick={() => handleRemoveTopic(topic)}
                      className="ml-1 hover:text-destructive"
                      disabled={loading}
                    >
                      <X className="w-3 h-3" />
                    </button>
                  </Badge>
                ))}
              </div>
            )}
          </div>

          <DialogFooter>
            <Button type="button" variant="outline" onClick={onClose} disabled={loading}>
              Cancel
            </Button>
            <Button type="submit" disabled={loading}>
              {loading && <Loader2 className="w-4 h-4 mr-2 animate-spin" />}
              Create Plan
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
