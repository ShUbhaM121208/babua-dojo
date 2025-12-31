import { Layout } from "@/components/layout/Layout";
import { Button } from "@/components/ui/button";
import { userDashboard, tracks } from "@/data/mockData";
import {
  Flame,
  Target,
  BookOpen,
  Calendar,
  ArrowRight,
  Clock,
  CheckCircle2,
  Bot,
} from "lucide-react";
import { Link } from "react-router-dom";
import { useBabuaAI } from "@/hooks/useBabuaAI";
import { enhancedUserProgress } from "@/data/mockData";
import { useAuth } from "@/contexts/AuthContext";
import { useEffect, useState } from "react";
import { getUserProfile, getUserTrackProgress, getSolvedProblems, recalculateAllTrackProgress, getUserProblemProgress } from "@/lib/userDataService";
import type { UserProfile, UserTrackProgress } from "@/lib/userDataService";
import { DailyPlanner } from "@/components/ui/DailyPlanner";
import { DailyChallengeCard } from "@/components/ui/DailyChallengeCard";

export default function Dashboard() {
  const { sendMessage } = useBabuaAI();
  const { user } = useAuth();
  const [userProfile, setUserProfile] = useState<UserProfile | null>(null);
  const [trackProgress, setTrackProgress] = useState<UserTrackProgress[]>([]);
  const [loading, setLoading] = useState(true);
  const [difficultyStats, setDifficultyStats] = useState({ easy: 0, medium: 0, hard: 0 });

  const loadUserData = async () => {
    if (!user) return;
    
    setLoading(true);
    try {
      // First, recalculate all track progress to fix any existing incorrect data
      await recalculateAllTrackProgress(user.id, tracks);
      
      const [profile, progress, problems] = await Promise.all([
        getUserProfile(user.id),
        getUserTrackProgress(user.id),
        getUserProblemProgress(user.id),
      ]);

      setUserProfile(profile);
      setTrackProgress(progress);
      
      // Calculate difficulty breakdown
      const solvedProblems = problems.filter(p => p.solved);
      const stats = {
        easy: solvedProblems.filter(p => p.difficulty === 'easy').length,
        medium: solvedProblems.filter(p => p.difficulty === 'medium').length,
        hard: solvedProblems.filter(p => p.difficulty === 'hard').length,
      };
      setDifficultyStats(stats);
    } catch (error) {
      console.error('Error loading user data:', error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (user) {
      loadUserData();
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [user]);

  // Refresh data when returning to tab (but not on interval)
  useEffect(() => {
    if (!user) return;

    const handleVisibilityChange = () => {
      if (!document.hidden) {
        // Silently reload data in background without showing loading state
        getUserProfile(user.id).then(profile => {
          if (profile) setUserProfile(profile);
        });
        getUserTrackProgress(user.id).then(progress => {
          setTrackProgress(progress);
        });
      }
    };

    document.addEventListener('visibilitychange', handleVisibilityChange);

    return () => {
      document.removeEventListener('visibilitychange', handleVisibilityChange);
    };
  }, [user]);

  const handleAskAI = (context: string) => {
    sendMessage(context, { userProgress: enhancedUserProgress });
  };

  if (loading) {
    return (
      <Layout>
        <div className="py-12">
          <div className="container mx-auto px-4 flex items-center justify-center min-h-[400px]">
            <div className="text-center">
              <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto mb-4"></div>
              <p className="text-muted-foreground font-mono">Loading dashboard...</p>
            </div>
          </div>
        </div>
      </Layout>
    );
  }

  const currentStreak = userProfile?.current_streak || 0;
  const longestStreak = userProfile?.longest_streak || 0;
  const totalSolved = userProfile?.total_problems_solved || 0;

  return (
    <Layout>
      <div className="py-12">
        <div className="container mx-auto px-4">
          {/* Header */}
          <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-8">
            <div>
              <h1 className="text-3xl md:text-4xl font-bold mb-2">Dashboard</h1>
              <p className="text-muted-foreground font-mono">
                Keep grinding. Consistency beats talent.
              </p>
            </div>

            {/* Streak Card */}
            <div className="surface-card p-4 flex items-center gap-4">
              <div className="w-16 h-16 rounded-full bg-primary/20 flex items-center justify-center">
                <Flame className="h-8 w-8 text-primary" />
              </div>
              <div>
                <div className="text-3xl font-mono font-bold text-primary">
                  {currentStreak}
                </div>
                <div className="text-sm text-muted-foreground">Day Streak</div>
                <div className="text-xs text-muted-foreground font-mono">
                  Best: {longestStreak} days
                </div>
              </div>
            </div>
          </div>

          <div className="grid lg:grid-cols-3 gap-6">
            {/* Main Content */}
            <div className="lg:col-span-2 space-y-6">
              {/* Quick Stats */}
              <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                {[
                  { icon: Target, label: "Total Solved", value: totalSolved, color: "text-primary" },
                  { icon: Clock, label: "Time Spent", value: `${userProfile?.total_time_spent || 0}m`, color: "text-emerald-400" },
                  { icon: BookOpen, label: "Tracks", value: trackProgress.length, color: "text-amber-400" },
                  { icon: Calendar, label: "Sessions", value: userDashboard.upcomingSessions.length, color: "text-blue-400" },
                ].map((stat, index) => (
                  <div key={index} className="surface-card p-4">
                    <stat.icon className={`h-5 w-5 ${stat.color} mb-2`} />
                    <div className="text-2xl font-mono font-bold">{stat.value}</div>
                    <div className="text-xs text-muted-foreground">{stat.label}</div>
                  </div>
                ))}
              </div>

              {/* Daily Challenge */}
              <DailyChallengeCard />

              {/* Track Progress */}
              <div className="surface-card p-6">
                <div className="flex items-center justify-between mb-6">
                  <h2 className="font-mono text-lg font-semibold flex items-center gap-2">
                    <BookOpen className="h-5 w-5 text-primary" />
                    Track Progress
                  </h2>
                  <Link to="/tracks">
                    <Button variant="ghost" size="sm" className="font-mono">
                      View All
                      <ArrowRight className="ml-1 h-4 w-4" />
                    </Button>
                  </Link>
                </div>

                <div className="space-y-4">
                  {tracks.slice(0, 4).map((track) => {
                    const progress = trackProgress.find(p => p.track_slug === track.slug);
                    const progressPercent = progress?.progress_percentage || 0;
                    
                    return (
                      <Link
                        key={track.id}
                        to={`/tracks/${track.slug}`}
                        className="block p-4 rounded-lg bg-secondary/50 hover:bg-secondary transition-colors"
                      >
                        <div className="flex items-center justify-between mb-2">
                          <div className="flex items-center gap-3">
                            <span className="text-xl">{track.icon}</span>
                            <span className="font-medium">{track.shortTitle}</span>
                          </div>
                          <span className="font-mono text-sm text-primary">
                            {progressPercent}%
                          </span>
                        </div>
                        <div className="h-1.5 bg-background rounded-full overflow-hidden">
                          <div
                            className="h-full bg-primary rounded-full transition-all"
                            style={{ width: `${progressPercent}%` }}
                          />
                        </div>
                        {progress && (
                          <div className="text-xs text-muted-foreground mt-1">
                            {progress.problems_solved} / {progress.total_problems} problems
                          </div>
                        )}
                      </Link>
                    );
                  })}
                </div>
              </div>

              {/* Recent Activity */}
              <div className="surface-card p-6">
                <h2 className="font-mono text-lg font-semibold mb-4">Recent Activity</h2>
                <div className="space-y-3">
                  {userDashboard.recentActivity.map((activity, index) => (
                    <div
                      key={index}
                      className="flex items-center justify-between p-3 rounded bg-secondary/50"
                    >
                      <div className="flex items-center gap-3">
                        <CheckCircle2 className="h-4 w-4 text-primary" />
                        <div>
                          <span className="text-muted-foreground text-sm">
                            {activity.action}
                          </span>
                          <span className="text-foreground ml-1 font-medium">
                            {activity.item}
                          </span>
                        </div>
                      </div>
                      <span className="text-xs text-muted-foreground">{activity.time}</span>
                    </div>
                  ))}
                </div>
              </div>
            </div>

            {/* Sidebar */}
            <div className="space-y-6">
              {/* Rank Display */}
              <div className="surface-card p-4">
                <div className="flex items-center justify-around">
                  <div className="text-center">
                    <div className="w-16 h-16 rounded-full bg-amber-400/20 border-2 border-amber-400 flex items-center justify-center mb-2 mx-auto">
                      <span className="text-2xl">👤</span>
                    </div>
                    <div className="text-xs font-mono font-bold">Rank 1</div>
                  </div>
                  <div className="text-center">
                    <div className="w-16 h-16 rounded-full bg-gray-400/20 border-2 border-gray-400 flex items-center justify-center mb-2 mx-auto">
                      <span className="text-2xl">👤</span>
                    </div>
                    <div className="text-xs font-mono font-bold">Rank 2</div>
                  </div>
                  <div className="text-center">
                    <div className="w-16 h-16 rounded-full bg-orange-400/20 border-2 border-orange-400 flex items-center justify-center mb-2 mx-auto">
                      <span className="text-2xl">👤</span>
                    </div>
                    <div className="text-xs font-mono font-bold">Rank 3</div>
                  </div>
                  <div className="text-center">
                    <div className="w-16 h-16 rounded-full bg-secondary border-2 border-border flex items-center justify-center mb-2 mx-auto">
                      <span className="text-sm">****</span>
                    </div>
                  </div>
                </div>
              </div>

              {/* Weakness Analysis */}
              <div className="surface-card p-4 bg-amber-500/10 border-amber-500/20">
                <h3 className="font-mono text-sm font-semibold mb-2 flex items-center gap-2">
                  <Bot className="h-4 w-4 text-amber-400" />
                  AI Weakness Analysis
                </h3>
                <p className="text-xs text-muted-foreground mb-3">
                  Get personalized insights on your weak areas with AI-powered recommendations
                </p>
                <Button 
                  variant="outline" 
                  size="sm" 
                  className="w-full"
                  onClick={() => handleAskAI("Can you analyze my weaknesses and create a study plan?")}
                >
                  <Bot className="h-4 w-4 mr-2" />
                  Get AI Analysis
                </Button>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Daily Planner */}
      <DailyPlanner />
    </Layout>
  );
}
