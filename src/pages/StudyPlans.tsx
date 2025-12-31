import { useEffect, useState } from "react";
import { Layout } from "@/components/layout/Layout";
import { useAuth } from "@/contexts/AuthContext";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";
import { Plus, BookOpen, Sparkles, Target } from "lucide-react";
import { useToast } from "@/hooks/use-toast";
import { 
  getActiveStudyPlans,
  getUserStudyPlans,
  getTemplateStudyPlans,
  getStudyRecommendations,
  type StudyPlan,
  type StudyRecommendation
} from "@/lib/studyPlanService";
import { PlanCard } from "@/components/study-plans/PlanCard";
import { CreatePlanDialog } from "@/components/study-plans/CreatePlanDialog";
import { TemplateBrowser } from "@/components/study-plans/TemplateBrowser";
import { AIRecommendations } from "@/components/study-plans/AIRecommendations";

export default function StudyPlans() {
  const { user } = useAuth();
  const { toast } = useToast();
  const [loading, setLoading] = useState(true);
  const [myPlans, setMyPlans] = useState<StudyPlan[]>([]);
  const [templates, setTemplates] = useState<StudyPlan[]>([]);
  const [recommendations, setRecommendations] = useState<StudyRecommendation[]>([]);
  const [showCreateDialog, setShowCreateDialog] = useState(false);
  const [activeTab, setActiveTab] = useState<'my-plans' | 'templates' | 'recommendations'>('my-plans');

  useEffect(() => {
    if (user) {
      loadData();
    }
  }, [user]);

  const loadData = async () => {
    if (!user) return;

    setLoading(true);
    try {
      const [plansData, templatesData, recommendationsData] = await Promise.all([
        getUserStudyPlans(user.id), // Changed from getActiveStudyPlans to get ALL plans including drafts
        getTemplateStudyPlans(),
        getStudyRecommendations(user.id),
      ]);

      setMyPlans(plansData || []);
      setTemplates(templatesData || []);
      setRecommendations(recommendationsData || []);
    } catch (error) {
      console.error('Error loading study plans data:', error);
      toast({
        title: 'Error',
        description: 'Failed to load study plans',
        variant: 'destructive',
      });
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return (
      <Layout title="Study Plans">
        <div className="container mx-auto py-6 px-4">
          <div className="text-center py-12">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto mb-4"></div>
            <p className="text-muted-foreground font-mono">Loading study plans...</p>
          </div>
        </div>
      </Layout>
    );
  }

  return (
    <Layout title="Study Plans">
      <div className="container mx-auto py-6 px-4">
        {/* Header */}
        <div className="flex items-center justify-between mb-8">
          <div>
            <h1 className="text-3xl font-bold font-mono mb-2">Study Plans</h1>
            <p className="text-muted-foreground">
              Create personalized learning roadmaps and track your progress
            </p>
          </div>
          <Button onClick={() => setShowCreateDialog(true)} size="lg">
            <Plus className="w-4 h-4 mr-2" />
            Create Plan
          </Button>
        </div>

        {/* Statistics */}
        <div className="grid md:grid-cols-3 gap-4 mb-8">
          <Card className="p-6">
            <div className="flex items-center gap-4">
              <div className="p-3 rounded-lg bg-primary/10">
                <BookOpen className="w-6 h-6 text-primary" />
              </div>
              <div>
                <div className="text-2xl font-bold">{myPlans.length}</div>
                <p className="text-sm text-muted-foreground">Active Plans</p>
              </div>
            </div>
          </Card>
          <Card className="p-6">
            <div className="flex items-center gap-4">
              <div className="p-3 rounded-lg bg-green-500/10">
                <Target className="w-6 h-6 text-green-500" />
              </div>
              <div>
                <div className="text-2xl font-bold">
                  {myPlans.reduce((acc, plan) => acc + (plan.items_completed || 0), 0)}
                </div>
                <p className="text-sm text-muted-foreground">Items Completed</p>
              </div>
            </div>
          </Card>
          <Card className="p-6">
            <div className="flex items-center gap-4">
              <div className="p-3 rounded-lg bg-blue-500/10">
                <Sparkles className="w-6 h-6 text-blue-500" />
              </div>
              <div>
                <div className="text-2xl font-bold">{recommendations.length}</div>
                <p className="text-sm text-muted-foreground">AI Recommendations</p>
              </div>
            </div>
          </Card>
        </div>

        {/* Tabs */}
        <Tabs value={activeTab} onValueChange={(v) => setActiveTab(v as any)}>
          <TabsList className="grid w-full grid-cols-3 mb-6">
            <TabsTrigger value="my-plans">
              <BookOpen className="w-4 h-4 mr-2" />
              My Plans
            </TabsTrigger>
            <TabsTrigger value="templates">
              <Target className="w-4 h-4 mr-2" />
              Templates
            </TabsTrigger>
            <TabsTrigger value="recommendations">
              <Sparkles className="w-4 h-4 mr-2" />
              AI Recommendations
            </TabsTrigger>
          </TabsList>

          <TabsContent value="my-plans">
            {myPlans.length === 0 ? (
              <Card className="p-12 text-center">
                <BookOpen className="w-12 h-12 text-muted-foreground mx-auto mb-4" />
                <h3 className="text-xl font-semibold mb-2">No study plans yet</h3>
                <p className="text-muted-foreground mb-6">
                  Create your first study plan to start tracking your learning journey
                </p>
                <Button onClick={() => setShowCreateDialog(true)}>
                  <Plus className="w-4 h-4 mr-2" />
                  Create Your First Plan
                </Button>
              </Card>
            ) : (
              <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
                {myPlans.map((plan) => (
                  <PlanCard key={plan.id} plan={plan} onUpdate={loadData} />
                ))}
              </div>
            )}
          </TabsContent>

          <TabsContent value="templates">
            <TemplateBrowser templates={templates} onClone={loadData} />
          </TabsContent>

          <TabsContent value="recommendations">
            <AIRecommendations 
              recommendations={recommendations} 
              onUpdate={loadData}
            />
          </TabsContent>
        </Tabs>

        {/* Create Plan Dialog */}
        <CreatePlanDialog
          open={showCreateDialog}
          onClose={() => setShowCreateDialog(false)}
          onSuccess={loadData}
        />
      </div>
    </Layout>
  );
}
