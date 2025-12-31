import { useState, useMemo, useEffect } from "react";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Badge } from "@/components/ui/badge";
import { useToast } from "@/hooks/use-toast";
import { useAuth } from "@/contexts/AuthContext";
import { Loader2, X, TrendingUp, Target, Calendar } from "lucide-react";
import { createStudyPlan } from "@/lib/studyPlanService";
import { dsaTopics } from "@/data/mockData";

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

  // Use DSA Topics structure (pattern-based organization)
  const availableTopics = useMemo(() => {
    return dsaTopics.map(topic => ({
      id: topic.id,
      title: topic.title,
      problemCount: topic.problems,
      subtopics: topic.subtopics
    }));
  }, []);

  // Analyze selected topics
  const roadmapAnalysis = useMemo(() => {
    if (formData.topics.length === 0) {
      return null;
    }

    // Get selected topic details
    const selectedTopicDetails = formData.topics.map(topicId => {
      return dsaTopics.find(t => t.id === topicId);
    }).filter(Boolean);

    // Calculate totals based on difficulty filter
    let totalProblems = 0;
    let easyCount = 0;
    let mediumCount = 0;
    let hardCount = 0;

    selectedTopicDetails.forEach(topic => {
      if (topic) {
        topic.subtopics.forEach(subtopic => {
          const difficulty = subtopic.difficulty;
          
          // Apply difficulty filter
          if (formData.difficulty === 'mixed' ||
              (formData.difficulty === 'beginner' && difficulty === 'easy') ||
              (formData.difficulty === 'intermediate' && difficulty === 'medium') ||
              (formData.difficulty === 'advanced' && difficulty === 'hard')) {
            totalProblems++;
            if (difficulty === 'easy') easyCount++;
            else if (difficulty === 'medium') mediumCount++;
            else if (difficulty === 'hard') hardCount++;
          }
        });
      }
    });

    const estimatedDays = Math.ceil(totalProblems / formData.daily_target_items);
    const recommendedDuration = Math.max(estimatedDays, Math.ceil(totalProblems / 5)); // Add buffer

    return {
      totalProblems,
      easyCount,
      mediumCount,
      hardCount,
      estimatedDays,
      recommendedDuration,
      topicDistribution: selectedTopicDetails.map(topic => ({
        topic: topic!.title,
        count: formData.difficulty === 'mixed' 
          ? topic!.subtopics.length
          : topic!.subtopics.filter(st => {
              if (formData.difficulty === 'beginner') return st.difficulty === 'easy';
              if (formData.difficulty === 'intermediate') return st.difficulty === 'medium';
              if (formData.difficulty === 'advanced') return st.difficulty === 'hard';
              return true;
            }).length
      }))
    };
  }, [formData.topics, formData.difficulty, formData.daily_target_items]);

  // Auto-update duration only when topics change (not when daily target changes)
  const prevTopicsRef = useState<string[]>([]);
  
  useEffect(() => {
    if (roadmapAnalysis && roadmapAnalysis.estimatedDays > 0) {
      // Only auto-update if topics actually changed (not just daily target)
      const topicsChanged = JSON.stringify(prevTopicsRef[0]) !== JSON.stringify(formData.topics);
      if (topicsChanged) {
        setFormData(prev => ({
          ...prev,
          duration_days: roadmapAnalysis.estimatedDays
        }));
        prevTopicsRef[0] = [...formData.topics];
      }
    }
  }, [formData.topics, roadmapAnalysis?.estimatedDays]);

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
      title: formData.title,
      description: formData.description || null,
      difficulty: formData.difficulty,
      estimated_days: formData.duration_days,
      target_topics: formData.topics.length > 0 ? formData.topics : [],
      problems_per_day: formData.daily_target_items,
      status: 'draft' as const,
    };

    const result = await createStudyPlan(user.id, planData);
    setLoading(false);

    if (result.id) {
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

  const handleSelectTopic = (topicId: string) => {
    if (!formData.topics.includes(topicId)) {
      setFormData(prev => ({
        ...prev,
        topics: [...prev.topics, topicId],
      }));
    }
  };

  const handleRemoveTopic = (topicToRemove: string) => {
    setFormData(prev => ({
      ...prev,
      topics: prev.topics.filter(t => t !== topicToRemove),
    }));
  };

  return (
    <Dialog open={open} onOpenChange={onClose}>
      <DialogContent className="max-w-4xl max-h-[90vh] overflow-y-auto !fixed !left-[50%] !top-[50%] !translate-x-[-50%] !translate-y-[-50%]">
        <DialogHeader>
          <DialogTitle>Create Study Plan</DialogTitle>
        </DialogHeader>

        <form onSubmit={handleSubmit} className="space-y-6 mt-4">
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
            {/* Left Column - Form Inputs */}
            <div className="space-y-6">
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
                    onValueChange={(value: 'beginner' | 'intermediate' | 'advanced' | 'mixed') => setFormData(prev => ({ ...prev, difficulty: value }))}
                    disabled={loading}
                  >
                    <SelectTrigger id="difficulty">
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="beginner">Beginner (Easy)</SelectItem>
                      <SelectItem value="intermediate">Intermediate (Medium)</SelectItem>
                      <SelectItem value="advanced">Advanced (Hard)</SelectItem>
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
                    onChange={(e) => setFormData(prev => ({ ...prev, duration_days: parseInt(e.target.value) || 1 }))}
                    disabled={loading}
                  />
                  {roadmapAnalysis && formData.duration_days < roadmapAnalysis.estimatedDays && (
                    <p className="text-xs text-amber-400">
                      ⚠️ Minimum {roadmapAnalysis.estimatedDays} days needed at {formData.daily_target_items} problems/day
                    </p>
                  )}
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

              {/* Topics Selection */}
              <div className="space-y-2">
                <Label htmlFor="topics">Select DSA Topics (Patterns) *</Label>
                <div className="max-h-48 overflow-y-auto border border-border rounded-md p-3 bg-secondary/20">
                  <div className="space-y-1">
                    {availableTopics.map((topic) => {
                      const isSelected = formData.topics.includes(topic.id);
                      return (
                        <button
                          key={topic.id}
                          type="button"
                          onClick={() => handleSelectTopic(topic.id)}
                          disabled={loading || isSelected}
                          className={`w-full text-xs px-3 py-2 rounded text-left transition-colors flex items-center justify-between ${
                            isSelected
                              ? 'bg-primary text-primary-foreground cursor-not-allowed'
                              : 'bg-background hover:bg-primary/10 border border-border'
                          }`}
                        >
                          <span className="font-medium">{topic.title}</span>
                          <span className={`text-xs ${isSelected ? 'opacity-80' : 'text-muted-foreground'}`}>
                            {topic.problemCount} problems
                          </span>
                        </button>
                      );
                    })}
                  </div>
                </div>
                {formData.topics.length > 0 && (
                  <div className="flex flex-wrap gap-2 mt-3">
                    {formData.topics.map((topicId) => {
                      const topic = availableTopics.find(t => t.id === topicId);
                      return (
                        <Badge key={topicId} variant="secondary" className="gap-1">
                          {topic?.title}
                          <button
                            type="button"
                            onClick={() => handleRemoveTopic(topicId)}
                            className="ml-1 hover:text-destructive"
                            disabled={loading}
                            aria-label={`Remove ${topic?.title}`}
                          >
                            <X className="w-3 h-3" />
                          </button>
                        </Badge>
                      );
                    })}
                  </div>
                )}
              </div>
            </div>

            {/* Right Column - Roadmap Analysis */}
            <div className="space-y-4">
              <div className="bg-muted/50 border border-border rounded-lg p-4">
                <h3 className="text-lg font-semibold mb-4 flex items-center gap-2">
                  <TrendingUp className="w-5 h-5 text-primary" />
                  Roadmap Analysis
                </h3>

                {roadmapAnalysis ? (
                  <div className="space-y-4">
                    {/* Total Problems */}
                    <div className="bg-background rounded-lg p-4 border border-border">
                      <div className="flex items-center justify-between mb-2">
                        <span className="text-sm text-muted-foreground">Total Problems</span>
                        <Target className="w-4 h-4 text-primary" />
                      </div>
                      <div className="text-3xl font-bold text-primary">
                        {roadmapAnalysis.totalProblems}
                      </div>
                      <div className="text-xs text-muted-foreground mt-1">
                        problems matching your criteria
                      </div>
                    </div>

                    {/* Difficulty Distribution */}
                    <div className="bg-background rounded-lg p-4 border border-border">
                      <h4 className="text-sm font-semibold mb-3">Difficulty Distribution</h4>
                      <div className="space-y-2">
                        {roadmapAnalysis.easyCount > 0 && (
                          <div className="flex items-center justify-between">
                            <span className="text-xs text-emerald-400 font-mono">Easy</span>
                            <span className="text-sm font-semibold">{roadmapAnalysis.easyCount}</span>
                          </div>
                        )}
                        {roadmapAnalysis.mediumCount > 0 && (
                          <div className="flex items-center justify-between">
                            <span className="text-xs text-amber-400 font-mono">Medium</span>
                            <span className="text-sm font-semibold">{roadmapAnalysis.mediumCount}</span>
                          </div>
                        )}
                        {roadmapAnalysis.hardCount > 0 && (
                          <div className="flex items-center justify-between">
                            <span className="text-xs text-red-400 font-mono">Hard</span>
                            <span className="text-sm font-semibold">{roadmapAnalysis.hardCount}</span>
                          </div>
                        )}
                      </div>
                    </div>

                    {/* Time Estimation */}
                    <div className="bg-background rounded-lg p-4 border border-border">
                      <div className="flex items-center justify-between mb-2">
                        <span className="text-sm text-muted-foreground">Estimated Duration</span>
                        <Calendar className="w-4 h-4 text-primary" />
                      </div>
                      <div className="text-2xl font-bold">
                        {roadmapAnalysis.estimatedDays} days
                      </div>
                      <div className="text-xs text-muted-foreground mt-1">
                        at {formData.daily_target_items} problems/day
                      </div>
                      {roadmapAnalysis.recommendedDuration > roadmapAnalysis.estimatedDays && (
                        <div className="mt-2 text-xs text-amber-400 bg-amber-400/10 rounded px-2 py-1">
                          💡 Recommended: {roadmapAnalysis.recommendedDuration}+ days for buffer time
                        </div>
                      )}
                      {formData.duration_days > roadmapAnalysis.estimatedDays && (
                        <div className="mt-2 text-xs text-green-400 bg-green-400/10 rounded px-2 py-1">
                          ✓ Your {formData.duration_days} days allows comfortable pace
                        </div>
                      )}
                    </div>

                    {/* Topic Distribution */}
                    <div className="bg-background rounded-lg p-4 border border-border">
                      <h4 className="text-sm font-semibold mb-3">Problems per Topic</h4>
                      <div className="space-y-2 max-h-40 overflow-y-auto">
                        {roadmapAnalysis.topicDistribution
                          .sort((a, b) => b.count - a.count)
                          .map(({ topic, count }) => (
                            <div key={topic} className="flex items-center justify-between">
                              <span className="text-xs font-mono text-muted-foreground truncate">
                                {topic}
                              </span>
                              <Badge variant="outline" className="ml-2">
                                {count}
                              </Badge>
                            </div>
                          ))}
                      </div>
                    </div>

                    {/* Progress Prediction */}
                    <div className="bg-primary/10 rounded-lg p-3 border border-primary/20">
                      <div className="text-xs font-semibold text-primary mb-1">
                        📊 Your Learning Path
                      </div>
                      <div className="text-xs text-muted-foreground space-y-1">
                        <div>• Week 1-2: Foundation building</div>
                        <div>• Week 3-4: Pattern mastery</div>
                        <div>• Week 5+: Advanced problem solving</div>
                      </div>
                    </div>
                  </div>
                ) : (
                  <div className="text-center py-12 text-muted-foreground">
                    <Target className="w-12 h-12 mx-auto mb-3 opacity-20" />
                    <p className="text-sm">Select topics to see your personalized roadmap analysis</p>
                  </div>
                )}
              </div>
            </div>
          </div>

          <DialogFooter>
            <Button type="button" variant="outline" onClick={onClose} disabled={loading}>
              Cancel
            </Button>
            <Button type="submit" disabled={loading || formData.topics.length === 0}>
              {loading && <Loader2 className="w-4 h-4 mr-2 animate-spin" />}
              Create Plan
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
