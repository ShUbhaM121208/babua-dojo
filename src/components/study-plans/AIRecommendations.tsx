import { useState } from "react";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { useToast } from "@/hooks/use-toast";
import { Sparkles, Check, X, Lightbulb, TrendingUp } from "lucide-react";
import { 
  type StudyRecommendation, 
  acceptRecommendation, 
  dismissRecommendation 
} from "@/lib/studyPlanService";

interface AIRecommendationsProps {
  recommendations: StudyRecommendation[];
  onUpdate: () => void;
}

export function AIRecommendations({ recommendations, onUpdate }: AIRecommendationsProps) {
  const { toast } = useToast();
  const [actioningId, setActioningId] = useState<string | null>(null);

  const handleAccept = async (recommendationId: string) => {
    setActioningId(recommendationId);
    const success = await acceptRecommendation(recommendationId);
    setActioningId(null);

    if (success) {
      toast({
        title: 'Recommendation accepted',
        description: 'This recommendation has been added to your plans',
      });
      onUpdate();
    } else {
      toast({
        title: 'Error',
        description: 'Failed to accept recommendation',
        variant: 'destructive',
      });
    }
  };

  const handleDismiss = async (recommendationId: string) => {
    setActioningId(recommendationId);
    const success = await dismissRecommendation(recommendationId);
    setActioningId(null);

    if (success) {
      toast({
        title: 'Recommendation dismissed',
        description: 'This recommendation has been hidden',
      });
      onUpdate();
    } else {
      toast({
        title: 'Error',
        description: 'Failed to dismiss recommendation',
        variant: 'destructive',
      });
    }
  };

  const getTypeIcon = (type: string) => {
    switch (type) {
      case 'problem': return <Lightbulb className="w-5 h-5" />;
      case 'topic': return <TrendingUp className="w-5 h-5" />;
      case 'plan': return <Sparkles className="w-5 h-5" />;
      case 'resource': return <Lightbulb className="w-5 h-5" />;
      default: return <Sparkles className="w-5 h-5" />;
    }
  };

  const getTypeColor = (type: string) => {
    switch (type) {
      case 'problem': return 'bg-blue-500/10 text-blue-500 border-blue-500/20';
      case 'topic': return 'bg-green-500/10 text-green-500 border-green-500/20';
      case 'plan': return 'bg-purple-500/10 text-purple-500 border-purple-500/20';
      case 'resource': return 'bg-yellow-500/10 text-yellow-500 border-yellow-500/20';
      default: return 'bg-muted text-muted-foreground';
    }
  };

  const getRelevanceColor = (score: number) => {
    if (score >= 0.8) return 'text-green-500';
    if (score >= 0.6) return 'text-yellow-500';
    return 'text-muted-foreground';
  };

  if (recommendations.length === 0) {
    return (
      <Card className="p-12 text-center">
        <Sparkles className="w-12 h-12 text-muted-foreground mx-auto mb-4" />
        <h3 className="text-xl font-semibold mb-2">No recommendations yet</h3>
        <p className="text-muted-foreground">
          Complete more problems and the AI will suggest personalized learning paths
        </p>
      </Card>
    );
  }

  return (
    <div className="space-y-4">
      {recommendations.map((rec) => (
        <Card key={rec.id} className="p-6">
          <div className="flex gap-4">
            {/* Icon */}
            <div className={`p-3 rounded-lg ${getTypeColor(rec.type)} flex-shrink-0`}>
              {getTypeIcon(rec.type)}
            </div>

            {/* Content */}
            <div className="flex-1 space-y-3">
              {/* Header */}
              <div className="flex items-start justify-between gap-4">
                <div className="flex-1">
                  <div className="flex items-center gap-2 mb-1">
                    <Badge variant="outline" className={getTypeColor(rec.type)}>
                      {rec.type}
                    </Badge>
                    <span className={`text-sm font-medium ${getRelevanceColor(rec.relevance_score || 0)}`}>
                      {Math.round((rec.relevance_score || 0) * 100)}% match
                    </span>
                  </div>
                  <h3 className="text-lg font-semibold">{rec.title}</h3>
                </div>
              </div>

              {/* Description */}
              {rec.description && (
                <p className="text-sm text-muted-foreground">
                  {rec.description}
                </p>
              )}

              {/* Reason */}
              {rec.reason && (
                <div className="flex gap-2 p-3 bg-muted/50 rounded-lg">
                  <Sparkles className="w-4 h-4 text-primary flex-shrink-0 mt-0.5" />
                  <p className="text-sm text-muted-foreground">
                    <span className="font-medium text-foreground">Why this matters: </span>
                    {rec.reason}
                  </p>
                </div>
              )}

              {/* Based On */}
              {rec.based_on && rec.based_on.length > 0 && (
                <div className="flex flex-wrap gap-2">
                  <span className="text-xs text-muted-foreground">Based on:</span>
                  {rec.based_on.map((item, index) => (
                    <Badge key={index} variant="secondary" className="text-xs">
                      {item}
                    </Badge>
                  ))}
                </div>
              )}

              {/* Actions */}
              <div className="flex gap-2 pt-2">
                <Button
                  size="sm"
                  onClick={() => handleAccept(rec.id)}
                  disabled={actioningId === rec.id}
                >
                  <Check className="w-4 h-4 mr-2" />
                  Accept
                </Button>
                <Button
                  size="sm"
                  variant="outline"
                  onClick={() => handleDismiss(rec.id)}
                  disabled={actioningId === rec.id}
                >
                  <X className="w-4 h-4 mr-2" />
                  Dismiss
                </Button>
              </div>
            </div>
          </div>
        </Card>
      ))}
    </div>
  );
}
