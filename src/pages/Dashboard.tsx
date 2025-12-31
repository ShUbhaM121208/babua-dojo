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
  Trophy,
  Medal,
  Crown,
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
import { DailyTaskList } from "@/components/study-plans/DailyTaskList";
import { RankBadge, RankProgressCard } from "@/components/profile/RankBadge";
import { RankUpNotification } from "@/components/profile/RankUpNotification";
import { useRankSystem } from "@/hooks/useRankSystem";
import { RecommendedForYou } from "@/components/learning/RecommendedForYou";
import { LearningInsights } from "@/components/learning/LearningInsights";
import { getGlobalRankLeaderboard } from "@/lib/rankService";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";

export default function Dashboard() {
  const { sendMessage } = useBabuaAI();
  const { user } = useAuth();
  const {
    userRank,
    showRankUpModal,
    rankUpData,
    dismissRankUp,
  } = useRankSystem();
  const [userProfile, setUserProfile] = useState<UserProfile | null>(null);
  const [trackProgress, setTrackProgress] = useState<UserTrackProgress[]>([]);
  const [loading, setLoading] = useState(true);
  const [difficultyStats, setDifficultyStats] = useState({ easy: 0, medium: 0, hard: 0 });
  const [topUsers, setTopUsers] = useState<any[]>([]);

  const loadUserData = async () => {
    if (!user) return;
    
    setLoading(true);
    try {
      // First, recalculate all track progress to fix any existing incorrect data
      await recalculateAllTrackProgress(user.id, tracks);
      
      const [profile, progress, problems, leaderboard] = await Promise.all([
        getUserProfile(user.id),
        getUserTrackProgress(user.id),
        getUserProblemProgress(user.id),
        getGlobalRankLeaderboard(5),
      ]);

      setUserProfile(profile);
      setTrackProgress(progress);
      setTopUsers(leaderboard as any[]);
      
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

            {/* Rank Card */}
            {userRank && (
              <div className="surface-card p-4 flex items-center gap-4">
                <RankBadge
                  rank={userRank.current_rank}
                  xp={userRank.rank_xp}
                  xpToNext={userRank.xp_to_next_rank}
                  progressPercentage={userRank.progress_percentage}
                  size="large"
                  showTooltip={false}
                />
                <div>
                  <div className="text-sm text-muted-foreground">Your Rank</div>
                  <div className="text-xs text-muted-foreground font-mono mt-1">
                    {userRank.rank_xp.toLocaleString()} XP
                  </div>
                  {userRank.xp_to_next_rank > 0 && (
                    <div className="text-xs text-muted-foreground font-mono">
                      {userRank.xp_to_next_rank.toLocaleString()} to next
                    </div>
                  )}
                </div>
              </div>
            )}
          </div>

          <div className="grid lg:grid-cols-3 gap-6">
            {/* Main Content */}
            <div className="lg:col-span-2 space-y-6">
              {/* Rank Progress Card */}
              {userRank && (
                <RankProgressCard
                  currentRank={userRank.current_rank}
                  xp={userRank.rank_xp}
                  xpToNext={userRank.xp_to_next_rank}
                  progressPercentage={userRank.progress_percentage}
                  nextRank={userRank.next_rank}
                />
              )}

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

              {/* Daily Study Tasks */}
              <DailyTaskList />

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

              {/* AI-Powered Learning Section */}
              <RecommendedForYou />

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
              {/* Learning Insights */}
              <LearningInsights />

              {/* Top 5 Leaderboard */}
              <div className="surface-card p-4">
                <div className="flex items-center justify-between mb-4">
                  <h3 className="font-mono text-sm font-semibold flex items-center gap-2">
                    <Trophy className="h-4 w-4 text-amber-400" />
                    Top Performers
                  </h3>
                  <Link to="/leaderboards">
                    <Button variant="ghost" size="sm" className="h-7 text-xs">
                      View All
                      <ArrowRight className="h-3 w-3 ml-1" />
                    </Button>
                  </Link>
                </div>
                <div className="space-y-3">
                  {topUsers.length > 0 ? (
                    topUsers.slice(0, 5).map((entry: any, index: number) => {
                      const getRankIcon = () => {
                        switch (index + 1) {
                          case 1:
                            return <Crown className="w-4 h-4 text-yellow-500" />;
                          case 2:
                            return <Medal className="w-4 h-4 text-gray-400" />;
                          case 3:
                            return <Medal className="w-4 h-4 text-amber-600" />;
                          default:
                            return <span className="text-xs font-mono text-muted-foreground w-4 text-center">{index + 1}</span>;
                        }
                      };

                      const getInitials = () => {
                        if (entry.full_name) {
                          return entry.full_name
                            .split(' ')
                            .map((n: string) => n[0])
                            .join('')
                            .toUpperCase()
                            .slice(0, 2);
                        }
                        return entry.email?.[0].toUpperCase() || 'U';
                      };

                      return (
                        <div key={entry.user_id} className="flex items-center gap-3">
                          <div className="w-6 flex items-center justify-center">
                            {getRankIcon()}
                          </div>
                          <Avatar className="h-8 w-8">
                            <AvatarImage src={entry.avatar_url || undefined} />
                            <AvatarFallback className="text-xs">{getInitials()}</AvatarFallback>
                          </Avatar>
                          <div className="flex-1 min-w-0">
                            <p className="text-xs font-medium truncate">
                              {entry.full_name || entry.username || 'Anonymous'}
                            </p>
                            <p className="text-xs text-muted-foreground font-mono">
                              {entry.rank_xp?.toLocaleString() || 0} XP
                            </p>
                          </div>
                          <RankBadge
                            rank={entry.current_rank}
                            size="small"
                            showTooltip={false}
                          />
                        </div>
                      );
                    })
                  ) : (
                    <p className="text-xs text-muted-foreground text-center py-4">
                      No leaderboard data available
                    </p>
                  )}
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

      {/* Rank Up Notification */}
      {showRankUpModal && rankUpData && (
        <RankUpNotification
          oldRank={rankUpData.oldRank}
          newRank={rankUpData.newRank}
          newXP={rankUpData.newXP}
          onClose={dismissRankUp}
        />
      )}
    </Layout>
  );
}
