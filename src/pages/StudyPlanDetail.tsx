import { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { Layout } from "@/components/layout/Layout";
import { useAuth } from "@/contexts/AuthContext";
import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Progress } from "@/components/ui/progress";
import { useToast } from "@/hooks/use-toast";
import { 
  ArrowLeft, 
  Play, 
  Pause, 
  Trash2, 
  Calendar,
  Target,
  TrendingUp,
  CheckCircle2,
  Clock
} from "lucide-react";
import { 
  getStudyPlan, 
  deleteStudyPlan, 
  startStudyPlan, 
  updateStudyPlan,
  type StudyPlan 
} from "@/lib/studyPlanService";
import { dsaTopics } from "@/data/mockData";

export default function StudyPlanDetail() {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const { user } = useAuth();
  const { toast } = useToast();
  const [loading, setLoading] = useState(true);
  const [plan, setPlan] = useState<StudyPlan | null>(null);
  const [actionLoading, setActionLoading] = useState(false);

  useEffect(() => {
    if (id) {
      loadPlan();
    }
  }, [id]);

  const loadPlan = async () => {
    if (!id) return;
    
    setLoading(true);
    const data = await getStudyPlan(id);
    setPlan(data);
    setLoading(false);
  };

  const handleDelete = async () => {
    if (!plan || !confirm('Are you sure you want to delete this study plan?')) return;
    
    setActionLoading(true);
    const success = await deleteStudyPlan(plan.id);
    setActionLoading(false);

    if (success) {
      toast({
        title: 'Plan deleted',
        description: 'Study plan has been removed',
      });
      navigate('/study-plans');
    } else {
      toast({
        title: 'Error',
        description: 'Failed to delete plan',
        variant: 'destructive',
      });
    }
  };

  const handleTogglePause = async () => {
    if (!plan) return;
    
    setActionLoading(true);
    const newStatus = plan.status === 'active' ? 'paused' : 'active';
    const success = await updateStudyPlan(plan.id, { status: newStatus });
    setActionLoading(false);

    if (success) {
      toast({
        title: newStatus === 'active' ? 'Plan resumed' : 'Plan paused',
        description: `Study plan is now ${newStatus}`,
      });
      loadPlan();
    } else {
      toast({
        title: 'Error',
        description: 'Failed to update plan status',
        variant: 'destructive',
      });
    }
  };

  const handleStart = async () => {
    if (!plan) return;
    
    setActionLoading(true);
    const success = await startStudyPlan(plan.id);
    setActionLoading(false);

    if (success) {
      toast({
        title: 'Plan started',
        description: 'Your study plan is now active',
      });
      loadPlan();
    } else {
      toast({
        title: 'Error',
        description: 'Failed to start plan',
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

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'active': return 'bg-green-500/10 text-green-500 border-green-500/20';
      case 'paused': return 'bg-yellow-500/10 text-yellow-500 border-yellow-500/20';
      case 'completed': return 'bg-blue-500/10 text-blue-500 border-blue-500/20';
      case 'draft': return 'bg-gray-500/10 text-gray-500 border-gray-500/20';
      default: return 'bg-muted text-muted-foreground';
    }
  };

  const getTopicDetails = () => {
    if (!plan?.target_topics) return [];
    
    return plan.target_topics.map(topicId => {
      const topic = dsaTopics.find(t => t.id === topicId);
      return {
        id: topicId,
        title: topic?.title || topicId,
        problems: topic?.problems || 0,
        subtopics: topic?.subtopics || []
      };
    });
  };

  if (loading) {
    return (
      <Layout title="Study Plan">
        <div className="container mx-auto py-6 px-4">
          <div className="text-center py-12">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto mb-4"></div>
            <p className="text-muted-foreground font-mono">Loading study plan...</p>
          </div>
        </div>
      </Layout>
    );
  }

  if (!plan) {
    return (
      <Layout title="Study Plan">
        <div className="container mx-auto py-6 px-4">
          <Card className="p-12 text-center">
            <h3 className="text-xl font-semibold mb-2">Study plan not found</h3>
            <p className="text-muted-foreground mb-6">
              This study plan doesn't exist or you don't have access to it
            </p>
            <Button onClick={() => navigate('/study-plans')}>
              <ArrowLeft className="w-4 h-4 mr-2" />
              Back to Study Plans
            </Button>
          </Card>
        </div>
      </Layout>
    );
  }

  const progressPercent = plan.total_items && plan.total_items > 0 
    ? Math.round((plan.items_completed || 0) / plan.total_items * 100) 
    : 0;

  const topicDetails = getTopicDetails();

  return (
    <Layout title={plan.title}>
      <div className="container mx-auto py-6 px-4">
        {/* Header */}
        <div className="mb-6">
          <Button 
            variant="ghost" 
            onClick={() => navigate('/study-plans')}
            className="mb-4"
          >
            <ArrowLeft className="w-4 h-4 mr-2" />
            Back to Study Plans
          </Button>

          <div className="flex items-start justify-between gap-4">
            <div className="flex-1">
              <div className="flex items-center gap-2 mb-3">
                <Badge variant="outline" className={getDifficultyColor(plan.difficulty || 'mixed')}>
                  {plan.difficulty || 'mixed'}
                </Badge>
                <Badge variant="outline" className={getStatusColor(plan.status || 'draft')}>
                  {plan.status || 'draft'}
                </Badge>
              </div>
              <h1 className="text-3xl font-bold mb-2">{plan.title}</h1>
              {plan.description && (
                <p className="text-muted-foreground">{plan.description}</p>
              )}
            </div>

            <div className="flex gap-2">
              {plan.status === 'draft' && (
                <Button onClick={handleStart} disabled={actionLoading}>
                  <Play className="w-4 h-4 mr-2" />
                  Start Plan
                </Button>
              )}
              {(plan.status === 'active' || plan.status === 'paused') && (
                <Button onClick={handleTogglePause} disabled={actionLoading}>
                  {plan.status === 'active' ? (
                    <>
                      <Pause className="w-4 h-4 mr-2" />
                      Pause
                    </>
                  ) : (
                    <>
                      <Play className="w-4 h-4 mr-2" />
                      Resume
                    </>
                  )}
                </Button>
              )}
              <Button variant="destructive" onClick={handleDelete} disabled={actionLoading}>
                <Trash2 className="w-4 h-4 mr-2" />
                Delete
              </Button>
            </div>
          </div>
        </div>

        {/* Stats Grid */}
        <div className="grid md:grid-cols-4 gap-4 mb-8">
          <Card className="p-6">
            <div className="flex items-center gap-4">
              <div className="p-3 rounded-lg bg-primary/10">
                <Target className="w-6 h-6 text-primary" />
              </div>
              <div>
                <div className="text-2xl font-bold">{plan.items_completed || 0}/{plan.total_items || 0}</div>
                <p className="text-sm text-muted-foreground">Problems</p>
              </div>
            </div>
          </Card>

          <Card className="p-6">
            <div className="flex items-center gap-4">
              <div className="p-3 rounded-lg bg-blue-500/10">
                <Calendar className="w-6 h-6 text-blue-500" />
              </div>
              <div>
                <div className="text-2xl font-bold">{plan.estimated_days || plan.duration_days || 0}</div>
                <p className="text-sm text-muted-foreground">Days</p>
              </div>
            </div>
          </Card>

          <Card className="p-6">
            <div className="flex items-center gap-4">
              <div className="p-3 rounded-lg bg-green-500/10">
                <TrendingUp className="w-6 h-6 text-green-500" />
              </div>
              <div>
                <div className="text-2xl font-bold">{plan.problems_per_day || 0}</div>
                <p className="text-sm text-muted-foreground">Per Day</p>
              </div>
            </div>
          </Card>

          <Card className="p-6">
            <div className="flex items-center gap-4">
              <div className="p-3 rounded-lg bg-purple-500/10">
                <CheckCircle2 className="w-6 h-6 text-purple-500" />
              </div>
              <div>
                <div className="text-2xl font-bold">{progressPercent}%</div>
                <p className="text-sm text-muted-foreground">Complete</p>
              </div>
            </div>
          </Card>
        </div>

        {/* Progress */}
        <Card className="p-6 mb-8">
          <h2 className="text-lg font-semibold mb-4">Overall Progress</h2>
          <Progress value={progressPercent} className="mb-2" />
          <p className="text-sm text-muted-foreground">
            {plan.items_completed || 0} of {plan.total_items || 0} problems completed
          </p>
        </Card>

        {/* Topics Roadmap */}
        <Card className="p-6">
          <h2 className="text-lg font-semibold mb-4">Learning Roadmap</h2>
          {topicDetails.length > 0 ? (
            <div className="space-y-4">
              {topicDetails.map((topic, index) => (
                <div key={topic.id} className="border border-border rounded-lg p-4">
                  <div className="flex items-center justify-between mb-3">
                    <div className="flex items-center gap-3">
                      <div className="w-8 h-8 rounded-full bg-primary/10 flex items-center justify-center">
                        <span className="text-sm font-semibold">{index + 1}</span>
                      </div>
                      <div>
                        <h3 className="font-semibold">{topic.title}</h3>
                        <p className="text-sm text-muted-foreground">{topic.problems} problems</p>
                      </div>
                    </div>
                    <Badge variant="outline">{topic.subtopics.length} subtopics</Badge>
                  </div>

                  {/* Subtopics */}
                  <div className="grid md:grid-cols-2 gap-2 pl-11">
                    {topic.subtopics.slice(0, 6).map((subtopic, idx) => (
                      <div key={idx} className="text-sm text-muted-foreground flex items-center gap-2">
                        <div className="w-1.5 h-1.5 rounded-full bg-muted-foreground/30"></div>
                        {subtopic.title}
                      </div>
                    ))}
                    {topic.subtopics.length > 6 && (
                      <div className="text-sm text-muted-foreground">
                        +{topic.subtopics.length - 6} more problems
                      </div>
                    )}
                  </div>
                </div>
              ))}
            </div>
          ) : (
            <div className="text-center py-8 text-muted-foreground">
              <Clock className="w-12 h-12 mx-auto mb-3 opacity-20" />
              <p>No topics selected for this plan</p>
            </div>
          )}
        </Card>
      </div>
    </Layout>
  );
}
