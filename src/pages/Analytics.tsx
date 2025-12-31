import { useState, useEffect } from "react";
import { Layout } from "@/components/layout/Layout";
import { Card } from "@/components/ui/card";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { LevelProgressBar } from "@/components/ui/LevelProgressBar";
import { AchievementBadge } from "@/components/ui/AchievementBadge";
import { achievements, calculateLevel } from "@/data/achievements";
import { 
  TrendingUp, Award, Target, Zap, Calendar, Clock, Code2, 
  Trophy, Flame, Download, Share2, Loader2
} from "lucide-react";
import { useAuth } from "@/contexts/AuthContext";
import { useToast } from "@/hooks/use-toast";
import {
  getUserStats,
  getMonthlyProgress,
  getActivityHeatmap,
  getUnlockedAchievements,
  type UserStats,
  type ActivityData
} from "@/lib/userStatsService";
import {
  BarChart, Bar, LineChart, Line, PieChart, Pie, Cell,
  RadarChart, PolarGrid, PolarAngleAxis, PolarRadiusAxis, Radar,
  XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer
} from 'recharts';

export default function Analytics() {
  const { user } = useAuth();
  const { toast } = useToast();
  const [selectedTab, setSelectedTab] = useState("overview");
  const [loading, setLoading] = useState(true);
  const [userStats, setUserStats] = useState<UserStats | null>(null);
  const [monthlyData, setMonthlyData] = useState<{ month: string; solved: number }[]>([]);
  const [heatmapData, setHeatmapData] = useState<ActivityData[]>([]);
  const [unlockedAchievementIds, setUnlockedAchievementIds] = useState<string[]>([]);

  useEffect(() => {
    if (user?.id) {
      loadUserData();
    }
  }, [user]);

  const loadUserData = async () => {
    if (!user?.id) return;
    
    setLoading(true);
    try {
      const [stats, monthly, heatmap, unlockedIds] = await Promise.all([
        getUserStats(user.id),
        getMonthlyProgress(user.id),
        getActivityHeatmap(user.id),
        Promise.resolve(getUnlockedAchievements(user.id))
      ]);

      setUserStats(stats);
      setMonthlyData(monthly);
      setHeatmapData(heatmap);
      setUnlockedAchievementIds(unlockedIds);
    } catch (error) {
      console.error('Error loading analytics data:', error);
      toast({
        title: "Error Loading Analytics",
        description: "Could not fetch your statistics. Please try again.",
        variant: "destructive"
      });
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return (
      <Layout>
        <div className="container mx-auto p-6 flex items-center justify-center min-h-[60vh]">
          <div className="text-center">
            <Loader2 className="h-12 w-12 animate-spin mx-auto mb-4 text-primary" />
            <p className="text-muted-foreground">Loading your analytics...</p>
          </div>
        </div>
      </Layout>
    );
  }

  if (!userStats) {
    return (
      <Layout>
        <div className="container mx-auto p-6">
          <Card className="p-8 text-center">
            <p className="text-muted-foreground mb-4">No analytics data available yet.</p>
            <p className="text-sm">Start solving problems to see your progress!</p>
          </Card>
        </div>
      </Layout>
    );
  }
  
  // Calculate current level info
  const currentLevel = calculateLevel(userStats.xp);
  const nextLevel = calculateLevel(userStats.xp + 1);
  const xpForNextLevel = nextLevel.level > currentLevel.level ? nextLevel.minXP - userStats.xp : 0;

  // Calculate topic strength data for radar chart
  const topicStrengthData = Object.entries(userStats.topicCounts).map(([topic, count]) => ({
    topic: topic.length > 15 ? topic.substring(0, 12) + '...' : topic,
    strength: Math.min(count * 5, 100), // Scale to 100
    fullName: topic
  }));

  // Difficulty distribution
  const difficultyData = [
    { name: 'Easy', value: userStats.easySolved, color: '#22c55e' },
    { name: 'Medium', value: userStats.mediumSolved, color: '#eab308' },
    { name: 'Hard', value: userStats.hardSolved, color: '#ef4444' },
  ];

  // Format time display
  const formatTimeSpent = (minutes: number) => {
    const hours = Math.floor(minutes / 60);
    return `${hours}h ${minutes % 60}m`;
  };

  // Calculate stats for unlocked achievements
  const unlockedAchievementsList = achievements.filter(a => 
    unlockedAchievementIds.includes(a.id)
  );

  const lockedAchievements = achievements.filter(a =>
    !unlockedAchievementIds.includes(a.id)
  );

  const getHeatmapColor = (count: number) => {
    if (count === 0) return '#1e293b';
    if (count === 1) return '#22c55e20';
    if (count === 2) return '#22c55e40';
    if (count === 3) return '#22c55e60';
    if (count === 4) return '#22c55e80';
    return '#22c55e';
  };

  return (
    <Layout>
      <div className="container mx-auto p-6 space-y-6">
        {/* Header */}
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-3xl font-bold font-mono">Analytics Dashboard</h1>
            <p className="text-muted-foreground">Track your progress and achievements</p>
          </div>
          <div className="flex gap-2">
            <Button variant="outline" size="sm">
              <Share2 className="h-4 w-4 mr-2" />
              Share
            </Button>
            <Button variant="outline" size="sm">
              <Download className="h-4 w-4 mr-2" />
              Export PDF
            </Button>
          </div>
        </div>

        {/* Level Progress Card */}
        <Card className="p-6">
          <LevelProgressBar 
            currentXP={userStats.xp}
            level={currentLevel.level}
            levelTitle={currentLevel.title}
            nextLevelXP={xpForNextLevel}
          />
        </Card>

        {/* Quick Stats */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
          <Card className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-muted-foreground">Total Solved</p>
                <p className="text-3xl font-bold mt-1">{userStats.totalSolved}</p>
              </div>
              <div className="p-3 bg-primary/10 rounded-full">
                <Code2 className="h-6 w-6 text-primary" />
              </div>
            </div>
            <div className="mt-4 flex gap-2 text-xs">
              <Badge variant="outline" className="bg-green-500/10">
                {userStats.easySolved} Easy
              </Badge>
              <Badge variant="outline" className="bg-yellow-500/10">
                {userStats.mediumSolved} Med
              </Badge>
              <Badge variant="outline" className="bg-red-500/10">
                {userStats.hardSolved} Hard
              </Badge>
            </div>
          </Card>

          <Card className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-muted-foreground">Current Streak</p>
                <p className="text-3xl font-bold mt-1 flex items-center gap-2">
                  {userStats.currentStreak}
                  <Flame className="h-6 w-6 text-orange-500" />
                </p>
              </div>
              <div className="p-3 bg-orange-500/10 rounded-full">
                <Calendar className="h-6 w-6 text-orange-500" />
              </div>
            </div>
            <p className="text-xs text-muted-foreground mt-4">
              Longest: {userStats.longestStreak} days
            </p>
          </Card>

          <Card className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-muted-foreground">Time Spent</p>
                <p className="text-3xl font-bold mt-1">
                  {Math.floor(userStats.totalTimeSpent / 60)}h
                </p>
              </div>
              <div className="p-3 bg-blue-500/10 rounded-full">
                <Clock className="h-6 w-6 text-blue-500" />
              </div>
            </div>
            <p className="text-xs text-muted-foreground mt-4">
              {userStats.totalSolved > 0 ? `Avg: ${Math.floor(userStats.totalTimeSpent / userStats.totalSolved)} min/problem` : 'No problems solved yet'}
            </p>
          </Card>

          <Card className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-muted-foreground">Achievements</p>
                <p className="text-3xl font-bold mt-1">
                  {unlockedAchievementsList.length}/{achievements.length}
                </p>
              </div>
              <div className="p-3 bg-amber-500/10 rounded-full">
                <Trophy className="h-6 w-6 text-amber-500" />
              </div>
            </div>
            <p className="text-xs text-muted-foreground mt-4">
              {Math.floor((unlockedAchievementsList.length / achievements.length) * 100)}% unlocked
            </p>
          </Card>
        </div>

        {/* Main Content Tabs */}
        <Tabs value={selectedTab} onValueChange={setSelectedTab} className="space-y-4">
          <TabsList className="grid w-full grid-cols-4">
            <TabsTrigger value="overview">Overview</TabsTrigger>
            <TabsTrigger value="achievements">Achievements</TabsTrigger>
            <TabsTrigger value="topics">Topics</TabsTrigger>
            <TabsTrigger value="activity">Activity</TabsTrigger>
          </TabsList>

          {/* Overview Tab */}
          <TabsContent value="overview" className="space-y-4">
            <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
              {/* Monthly Progress */}
              <Card className="p-6">
                <h3 className="text-lg font-semibold mb-4 flex items-center gap-2">
                  <TrendingUp className="h-5 w-5" />
                  Monthly Progress
                </h3>
                <ResponsiveContainer width="100%" height={250}>
                  <LineChart data={monthlyData}>
                    <CartesianGrid strokeDasharray="3 3" stroke="#333" />
                    <XAxis dataKey="month" stroke="#888" />
                    <YAxis stroke="#888" />
                    <Tooltip 
                      contentStyle={{ backgroundColor: '#1e293b', border: '1px solid #334155' }}
                    />
                    <Line 
                      type="monotone" 
                      dataKey="solved" 
                      stroke="#22c55e" 
                      strokeWidth={2}
                      dot={{ fill: '#22c55e', r: 4 }}
                    />
                  </LineChart>
                </ResponsiveContainer>
              </Card>

              {/* Difficulty Distribution */}
              <Card className="p-6">
                <h3 className="text-lg font-semibold mb-4 flex items-center gap-2">
                  <Target className="h-5 w-5" />
                  Difficulty Distribution
                </h3>
                <ResponsiveContainer width="100%" height={250}>
                  <PieChart>
                    <Pie
                      data={difficultyData}
                      cx="50%"
                      cy="50%"
                      labelLine={false}
                      label={({ name, percent }) => `${name}: ${(percent * 100).toFixed(0)}%`}
                      outerRadius={80}
                      fill="#8884d8"
                      dataKey="value"
                    >
                      {difficultyData.map((entry, index) => (
                        <Cell key={`cell-${index}`} fill={entry.color} />
                      ))}
                    </Pie>
                    <Tooltip contentStyle={{ backgroundColor: '#1e293b', border: '1px solid #334155' }} />
                  </PieChart>
                </ResponsiveContainer>
              </Card>
            </div>

            {/* Topic Strength Radar */}
            <Card className="p-6">
              <h3 className="text-lg font-semibold mb-4 flex items-center gap-2">
                <Zap className="h-5 w-5" />
                Topic Strength Analysis
              </h3>
              <ResponsiveContainer width="100%" height={350}>
                <RadarChart data={topicStrengthData}>
                  <PolarGrid stroke="#333" />
                  <PolarAngleAxis dataKey="topic" stroke="#888" />
                  <PolarRadiusAxis stroke="#888" />
                  <Radar 
                    name="Strength" 
                    dataKey="strength" 
                    stroke="#22c55e" 
                    fill="#22c55e" 
                    fillOpacity={0.6} 
                  />
                  <Tooltip 
                    contentStyle={{ backgroundColor: '#1e293b', border: '1px solid #334155' }}
                    formatter={(value: number, name: string, props: unknown) => {
                      const item = props as { payload?: { fullName?: string } };
                      return [`${value}%`, item.payload?.fullName || name];
                    }}
                  />
                </RadarChart>
              </ResponsiveContainer>
            </Card>
          </TabsContent>

          {/* Achievements Tab */}
          <TabsContent value="achievements" className="space-y-4">
            <Card className="p-6">
              <h3 className="text-lg font-semibold mb-4 flex items-center gap-2">
                <Trophy className="h-5 w-5 text-amber-500" />
                Unlocked Achievements ({unlockedAchievementsList.length})
              </h3>
              <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-4">
                {unlockedAchievementsList.map(achievement => (
                  <AchievementBadge
                    key={achievement.id}
                    achievement={achievement}
                    unlocked={true}
                  />
                ))}
              </div>
            </Card>

            <Card className="p-6">
              <h3 className="text-lg font-semibold mb-4 flex items-center gap-2">
                <Award className="h-5 w-5 text-gray-500" />
                Locked Achievements ({lockedAchievements.length})
              </h3>
              <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-4">
                {lockedAchievements.map(achievement => {
                  // Calculate current progress
                  let currentProgress = 0;
                  if (achievement.requirement.type === 'problems_solved') {
                    currentProgress = userStats.totalSolved;
                  } else if (achievement.requirement.type === 'streak_days') {
                    currentProgress = userStats.currentStreak;
                  } else if (achievement.requirement.type === 'difficulty') {
                    if (achievement.requirement.difficulty === 'easy') currentProgress = userStats.easySolved;
                    if (achievement.requirement.difficulty === 'medium') currentProgress = userStats.mediumSolved;
                    if (achievement.requirement.difficulty === 'hard') currentProgress = userStats.hardSolved;
                  } else if (achievement.requirement.type === 'topic_mastery') {
                    currentProgress = userStats.topicCounts[achievement.requirement.topic || ''] || 0;
                  }

                  return (
                    <AchievementBadge
                      key={achievement.id}
                      achievement={achievement}
                      unlocked={false}
                      showProgress={true}
                      currentProgress={currentProgress}
                    />
                  );
                })}
              </div>
            </Card>
          </TabsContent>

          {/* Topics Tab */}
          <TabsContent value="topics" className="space-y-4">
            <Card className="p-6">
              <h3 className="text-lg font-semibold mb-4">Topic Mastery</h3>
              <div className="space-y-4">
                {Object.entries(userStats.topicCounts)
                  .sort(([, a], [, b]) => b - a)
                  .map(([topic, count]) => {
                    const maxCount = Math.max(...Object.values(userStats.topicCounts));
                    const percentage = (count / maxCount) * 100;
                    return (
                      <div key={topic}>
                        <div className="flex items-center justify-between mb-2">
                          <span className="text-sm font-medium">{topic}</span>
                          <Badge variant="outline">{count} problems</Badge>
                        </div>
                        <div className="h-2 bg-gray-800 rounded-full overflow-hidden">
                          <div 
                            className="h-full bg-gradient-to-r from-green-500 to-emerald-500"
                            style={{ width: `${percentage}%` }}
                          />
                        </div>
                      </div>
                    );
                  })}
              </div>
            </Card>
          </TabsContent>

          {/* Activity Tab */}
          <TabsContent value="activity" className="space-y-4">
            <Card className="p-6">
              <h3 className="text-lg font-semibold mb-4 flex items-center gap-2">
                <Calendar className="h-5 w-5" />
                Activity Heatmap (Last 90 Days)
              </h3>
              <div className="overflow-x-auto">
                <div className="inline-grid grid-cols-[repeat(13,_minmax(0,_1fr))] gap-1">
                  {heatmapData.map((day, idx) => (
                    <div
                      key={idx}
                      className="w-3 h-3 rounded-sm cursor-pointer hover:ring-2 hover:ring-primary transition-all"
                      style={{ backgroundColor: getHeatmapColor(day.problems) }}
                      title={`${day.date}: ${day.problems} problems solved`}
                    />
                  ))}
                </div>
                <div className="flex items-center gap-2 mt-4 text-xs text-muted-foreground">
                  <span>Less</span>
                  <div className="flex gap-1">
                    <div className="w-3 h-3 rounded-sm" style={{ backgroundColor: '#1e293b' }} />
                    <div className="w-3 h-3 rounded-sm" style={{ backgroundColor: '#22c55e20' }} />
                    <div className="w-3 h-3 rounded-sm" style={{ backgroundColor: '#22c55e60' }} />
                    <div className="w-3 h-3 rounded-sm" style={{ backgroundColor: '#22c55e' }} />
                  </div>
                  <span>More</span>
                </div>
              </div>
            </Card>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <Card className="p-4">
                <h4 className="text-sm font-semibold mb-2">Best Streak</h4>
                <div className="text-center py-4">
                  <p className="text-4xl font-bold text-orange-500">{userStats.longestStreak}</p>
                  <p className="text-xs text-muted-foreground mt-1">consecutive days</p>
                </div>
              </Card>

              <Card className="p-4">
                <h4 className="text-sm font-semibold mb-2">Total XP Earned</h4>
                <div className="text-center py-4">
                  <p className="text-4xl font-bold text-amber-500">{userStats.xp}</p>
                  <p className="text-xs text-muted-foreground mt-1">experience points</p>
                </div>
              </Card>
            </div>
          </TabsContent>
        </Tabs>
      </div>
    </Layout>
  );
}
