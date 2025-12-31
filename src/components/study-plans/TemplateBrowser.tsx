import { useState } from "react";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import { useToast } from "@/hooks/use-toast";
import { useAuth } from "@/contexts/AuthContext";
import { Copy, Search, BookOpen } from "lucide-react";
import { type StudyPlan, cloneStudyPlan } from "@/lib/studyPlanService";

interface TemplateBrowserProps {
  templates: StudyPlan[];
  onClone: () => void;
}

export function TemplateBrowser({ templates, onClone }: TemplateBrowserProps) {
  const { user } = useAuth();
  const { toast } = useToast();
  const [searchQuery, setSearchQuery] = useState('');
  const [cloningId, setCloningId] = useState<string | null>(null);

  const filteredTemplates = templates.filter(template => {
    const query = searchQuery.toLowerCase();
    return (
      template.title.toLowerCase().includes(query) ||
      template.description?.toLowerCase().includes(query) ||
      template.topics?.some(topic => topic.toLowerCase().includes(query))
    );
  });

  const handleClone = async (templateId: string) => {
    if (!user) {
      toast({
        title: 'Error',
        description: 'You must be logged in to clone a template',
        variant: 'destructive',
      });
      return;
    }

    setCloningId(templateId);
    const newPlan = await cloneStudyPlan(templateId, user.id);
    setCloningId(null);

    if (newPlan) {
      toast({
        title: 'Template cloned!',
        description: 'The study plan has been added to your plans',
      });
      onClone();
    } else {
      toast({
        title: 'Error',
        description: 'Failed to clone template',
        variant: 'destructive',
      });
    }
  };

  const getDifficultyColor = (difficulty: string) => {
    switch (difficulty) {
      case 'beginner': return 'bg-green-500/10 text-green-500 border-green-500/20';
      case 'intermediate': return 'bg-yellow-500/10 text-yellow-500 border-yellow-500/20';
      case 'advanced': return 'bg-red-500/10 text-red-500 border-red-500/20';
      case 'mixed': return 'bg-blue-500/10 text-blue-500 border-blue-500/20';
      default: return 'bg-muted text-muted-foreground';
    }
  };

  return (
    <div className="space-y-6">
      {/* Search */}
      <div className="relative">
        <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-muted-foreground" />
        <Input
          placeholder="Search templates by title, topic, or description..."
          value={searchQuery}
          onChange={(e) => setSearchQuery(e.target.value)}
          className="pl-10"
        />
      </div>

      {/* Templates Grid */}
      {filteredTemplates.length === 0 ? (
        <Card className="p-12 text-center">
          <BookOpen className="w-12 h-12 text-muted-foreground mx-auto mb-4" />
          <h3 className="text-xl font-semibold mb-2">No templates found</h3>
          <p className="text-muted-foreground">
            {searchQuery ? 'Try a different search query' : 'No public templates available yet'}
          </p>
        </Card>
      ) : (
        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
          {filteredTemplates.map((template) => (
            <Card key={template.id} className="p-6 hover:border-primary/50 transition-colors">
              <div className="space-y-4">
                {/* Header */}
                <div>
                  <div className="flex items-center gap-2 mb-2">
                    <Badge variant="outline" className={getDifficultyColor(template.difficulty || 'mixed')}>
                      {template.difficulty || 'mixed'}
                    </Badge>
                    {template.created_by === 'admin' && (
                      <Badge variant="outline" className="bg-purple-500/10 text-purple-500 border-purple-500/20">
                        Official
                      </Badge>
                    )}
                    {template.created_by === 'ai' && (
                      <Badge variant="outline" className="bg-blue-500/10 text-blue-500 border-blue-500/20">
                        AI Generated
                      </Badge>
                    )}
                  </div>
                  <h3 className="text-lg font-semibold mb-2">{template.title}</h3>
                  {template.description && (
                    <p className="text-sm text-muted-foreground line-clamp-3">
                      {template.description}
                    </p>
                  )}
                </div>

                {/* Stats */}
                <div className="grid grid-cols-2 gap-3 text-sm">
                  <div>
                    <span className="text-muted-foreground">Duration:</span>
                    <span className="ml-2 font-medium">{template.duration_days || 30} days</span>
                  </div>
                  <div>
                    <span className="text-muted-foreground">Items:</span>
                    <span className="ml-2 font-medium">{template.total_items || 0}</span>
                  </div>
                  <div>
                    <span className="text-muted-foreground">Daily:</span>
                    <span className="ml-2 font-medium">{template.daily_target_items || 3} items</span>
                  </div>
                  {template.estimated_hours_per_day && (
                    <div>
                      <span className="text-muted-foreground">Time:</span>
                      <span className="ml-2 font-medium">{template.estimated_hours_per_day}h/day</span>
                    </div>
                  )}
                </div>

                {/* Topics */}
                {template.topics && template.topics.length > 0 && (
                  <div className="flex flex-wrap gap-2">
                    {template.topics.slice(0, 4).map((topic, index) => (
                      <Badge key={index} variant="secondary" className="text-xs">
                        {topic}
                      </Badge>
                    ))}
                    {template.topics.length > 4 && (
                      <Badge variant="secondary" className="text-xs">
                        +{template.topics.length - 4}
                      </Badge>
                    )}
                  </div>
                )}

                {/* Action */}
                <Button
                  className="w-full"
                  onClick={() => handleClone(template.id)}
                  disabled={cloningId === template.id}
                >
                  <Copy className="w-4 h-4 mr-2" />
                  {cloningId === template.id ? 'Cloning...' : 'Use This Template'}
                </Button>
              </div>
            </Card>
          ))}
        </div>
      )}
    </div>
  );
}
