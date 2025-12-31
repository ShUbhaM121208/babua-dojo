import { useEffect, useState, useCallback } from "react";
import { Layout } from "@/components/layout/Layout";
import { useAuth } from "@/contexts/AuthContext";
import { getUserProfile, getUserTrackProgress, getUserProblemProgress, getDailyActivity, type UserProfile } from "@/lib/userDataService";
import { supabase } from "@/integrations/supabase/client";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Card } from "@/components/ui/card";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Instagram, Linkedin, Twitter, Github, Edit2, Share2, ChevronDown, Settings } from "lucide-react";
import { tracks } from "@/data/mockData";
import { useToast } from "@/hooks/use-toast";
import { ReferralDashboard } from "@/components/ReferralDashboard";
import { ProfileSettingsModal } from "@/components/profile/ProfileSettingsModal";

interface TrackProgress {
  trackId?: string;
  track_slug?: string;
  completed?: number;
  problems_solved?: number;
  total?: number;
  total_problems?: number;
  percentage?: number;
  progress_percentage?: number;
}

interface SheetProgress {
  name: string;
  solved: number;
  total: number;
  percentage: number;
}

interface DifficultyStats {
  easy: { solved: number; total: number };
  medium: { solved: number; total: number };
  hard: { solved: number; total: number };
  totalSolved: number;
  totalProblems: number;
}

interface HeatmapDay {
  date: string;
  count: number;
}

export default function Profile() {
  const { user } = useAuth();
  const { toast } = useToast();
  const [userProfile, setUserProfile] = useState<UserProfile | null>(null);
  const [trackProgress, setTrackProgress] = useState<TrackProgress[]>([]);
  const [sheetProgress, setSheetProgress] = useState<SheetProgress[]>([]);
  const [difficultyStats, setDifficultyStats] = useState<DifficultyStats>({
    easy: { solved: 0, total: 310 },
    medium: { solved: 0, total: 450 },
    hard: { solved: 0, total: 258 },
    totalSolved: 0,
    totalProblems: 1024,
  });
  const [loading, setLoading] = useState(true);
  const [heatmapData, setHeatmapData] = useState<HeatmapDay[]>([]);
  const [activeTab, setActiveTab] = useState<'dsa' | 'babua' | 'leetcode' | 'referrals'>('dsa');
  const [selectedYear] = useState(2025);
  const [activeDays, setActiveDays] = useState(0);
  const [maxStreak, setMaxStreak] = useState(0);
  const [isEditing, setIsEditing] = useState(false);
  const [showSettingsModal, setShowSettingsModal] = useState(false);
  const [editForm, setEditForm] = useState({
    full_name: '',
    college: '',
    location: '',
    bio: '',
    instagram_url: '',
    linkedin_url: '',
    twitter_url: '',
    leetcode_username: '',
    github_username: '',
    codeforces_username: '',
    codechef_username: ''
  });

  const saveProfile = async () => {
    if (!user) return;

    try {
      // Prepare update object, converting empty strings to null
      const updateData = {
        id: user.id,
        email: user.email,
        full_name: editForm.full_name || null,
        college: editForm.college || null,
        location: editForm.location || null,
        bio: editForm.bio || null,
        instagram_url: editForm.instagram_url || null,
        linkedin_url: editForm.linkedin_url || null,
        twitter_url: editForm.twitter_url || null,
        leetcode_username: editForm.leetcode_username || null,
        github_username: editForm.github_username || null,
        codeforces_username: editForm.codeforces_username || null,
        codechef_username: editForm.codechef_username || null,
        updated_at: new Date().toISOString()
      };

      // @ts-ignore - Supabase type generation issue
      const { error, data } = await supabase
        .from('user_profiles')
        .upsert(updateData, { onConflict: 'id' })
        .select();

      if (error) {
        console.error('Supabase error details:', error);
        throw error;
      }

      console.log('Profile updated successfully:', data);

      toast({
        title: "Profile updated!",
        description: "Your profile has been successfully updated.",
      });

      setIsEditing(false);
      loadUserData();
    } catch (error) {
      console.error('Error updating profile:', error);
      toast({
        title: "Error",
        description: "Failed to update profile. Please try again.",
        variant: "destructive",
      });
    }
  };

  const loadUserData = useCallback(async () => {
    if (!user) return;

    try {
      setLoading(true);

      // Fetch user profile
      const profile = await getUserProfile(user.id);
      console.log('Loaded profile data:', profile);
      setUserProfile(profile);

      // Load into edit form
      if (profile) {
        setEditForm({
          full_name: profile.full_name || '',
          college: profile.college || '',
          location: profile.location || '',
          bio: profile.bio || '',
          instagram_url: profile.instagram_url || '',
          linkedin_url: profile.linkedin_url || '',
          twitter_url: profile.twitter_url || '',
          leetcode_username: profile.leetcode_username || '',
          github_username: profile.github_username || '',
          codeforces_username: profile.codeforces_username || '',
          codechef_username: profile.codechef_username || ''
        });
        console.log('Edit form initialized:', profile);
      }

      // Fetch track progress
      const progress = await getUserTrackProgress(user.id);
      const formattedProgress = progress.map(p => ({
        trackId: p.track_slug,
        track_slug: p.track_slug,
        completed: p.problems_solved,
        problems_solved: p.problems_solved,
        total: p.total_problems,
        total_problems: p.total_problems,
        percentage: p.progress_percentage,
        progress_percentage: p.progress_percentage,
      }));
      setTrackProgress(formattedProgress);

      // Generate Sheet Progress from track progress with actual data
      const sheets: SheetProgress[] = progress.map(p => {
        const track = tracks.find(t => t.slug === p.track_slug);
        return {
          name: track?.title || p.track_slug,
          solved: p.problems_solved || 0,
          total: p.total_problems || 0,
          percentage: Math.round(p.progress_percentage || 0)
        };
      }).filter(s => s.total > 0); // Only show tracks with problems
      
      setSheetProgress(sheets);

      // Fetch problem progress for difficulty stats
      const problems = await getUserProblemProgress(user.id);
      
      // Calculate difficulty stats from actual user problem progress
      const stats = {
        easy: { solved: 0, total: 310 },
        medium: { solved: 0, total: 450 },
        hard: { solved: 0, total: 258 },
        totalSolved: 0,
        totalProblems: 1024,
      };

      // Count solved problems by difficulty
      problems.forEach(p => {
        if (p.solved) {
          stats.totalSolved++;
          if (p.difficulty.toLowerCase() === 'easy') {
            stats.easy.solved++;
          } else if (p.difficulty.toLowerCase() === 'medium') {
            stats.medium.solved++;
          } else if (p.difficulty.toLowerCase() === 'hard') {
            stats.hard.solved++;
          }
        }
      });

      setDifficultyStats(stats);

      // Fetch actual heatmap data from user_daily_activity
      const startDate = new Date(selectedYear, 0, 1).toISOString().split('T')[0];
      const endDate = new Date(selectedYear, 11, 31).toISOString().split('T')[0];
      const activity = await getDailyActivity(user.id, startDate, endDate);

      // Create heatmap with all days of the year
      const heatmap: HeatmapDay[] = [];
      const activityMap = new Map(activity.map(a => [a.activity_date, a.problems_solved]));
      
      for (let month = 0; month < 12; month++) {
        const daysInMonth = new Date(selectedYear, month + 1, 0).getDate();
        for (let day = 1; day <= daysInMonth; day++) {
          const date = new Date(selectedYear, month, day);
          const dateStr = date.toISOString().split('T')[0];
          heatmap.push({
            date: dateStr,
            count: activityMap.get(dateStr) || 0,
          });
        }
      }
      
      setHeatmapData(heatmap);

      // Calculate active days and max streak
      let tempStreak = 0;
      let maxStreakLocal = 0;
      let days = 0;
      
      for (let i = heatmap.length - 1; i >= 0; i--) {
        if (heatmap[i].count > 0) {
          days++;
          tempStreak++;
        } else {
          if (tempStreak > maxStreakLocal) {
            maxStreakLocal = tempStreak;
          }
          tempStreak = 0;
        }
      }
      
      setActiveDays(days);
      setMaxStreak(Math.max(maxStreakLocal, tempStreak));

    } catch (error) {
      console.error("Error loading user data:", error);
      toast({
        title: "Error",
        description: "Failed to load profile data",
        variant: "destructive",
      });
    } finally {
      setLoading(false);
    }
  }, [user, toast, selectedYear]);

  useEffect(() => {
    if (user) {
      loadUserData();
    }
  }, [user, loadUserData]);

  if (loading) {
    return (
      <Layout>
        <div className="flex items-center justify-center min-h-screen">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary"></div>
        </div>
      </Layout>
    );
  }

  const renderHeatmapGrid = () => {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    
    // Group days by month and week
    const monthsData: { month: string; weeks: HeatmapDay[][] }[] = [];
    
    heatmapData.forEach((day) => {
      if (!day.date) return;
      
      const date = new Date(day.date);
      const month = date.getMonth();
      const dayOfWeek = date.getDay();
      
      // Find or create month
      let monthData = monthsData.find(m => m.month === months[month]);
      if (!monthData) {
        monthData = { month: months[month], weeks: [] };
        monthsData.push(monthData);
      }
      
      // Get current week or create new one
      let currentWeek = monthData.weeks[monthData.weeks.length - 1];
      
      // Start new week on Sunday or if it's the first day of the month
      if (!currentWeek || (currentWeek.length > 0 && dayOfWeek === 0)) {
        currentWeek = [];
        monthData.weeks.push(currentWeek);
      }
      
      // Fill empty days at the start of the week
      while (currentWeek.length < dayOfWeek) {
        currentWeek.push({ date: '', count: -1 });
      }
      
      currentWeek.push(day);
    });
    
    // Fill incomplete weeks
    monthsData.forEach(monthData => {
      monthData.weeks.forEach(week => {
        while (week.length < 7) {
          week.push({ date: '', count: -1 });
        }
      });
    });

    // Get intensity level based on count
    const getIntensityClass = (count: number) => {
      if (count === 0) return 'bg-gray-200 dark:bg-gray-800';
      if (count <= 2) return 'bg-green-300 dark:bg-green-900';
      if (count <= 4) return 'bg-green-400 dark:bg-green-700';
      if (count <= 6) return 'bg-green-500 dark:bg-green-600';
      return 'bg-green-600 dark:bg-green-500';
    };

    const formatDate = (dateStr: string) => {
      const date = new Date(dateStr);
      return date.toLocaleDateString('en-US', { 
        weekday: 'short',
        month: 'short', 
        day: 'numeric', 
        year: 'numeric' 
      });
    };

    return (
      <div className="overflow-x-auto pb-2">
        <div className="inline-flex gap-3">
          {/* Day labels */}
          <div className="flex flex-col gap-[3px] mr-1">
            <div className="h-4 mb-1"></div>
            {days.map((day, i) => (
              <div 
                key={i} 
                className={`h-[10px] text-[9px] text-muted-foreground flex items-center ${i % 2 === 0 ? 'opacity-0' : ''}`}
                style={{ width: '24px' }}
              >
                {day}
              </div>
            ))}
          </div>

          {/* Months */}
          {monthsData.map((monthData, monthIndex) => (
            <div key={monthIndex} className="flex flex-col">
              {/* Month label */}
              <div className="text-xs text-muted-foreground mb-1 h-4">
                {monthData.month}
              </div>
              
              {/* Weeks in this month */}
              <div className="flex gap-[3px]">
                {monthData.weeks.map((week, weekIndex) => (
                  <div key={weekIndex} className="flex flex-col gap-[3px]">
                    {week.map((day, dayIndex) => {
                      if (day.count === -1 || !day.date) {
                        return <div key={dayIndex} className="w-[10px] h-[10px]" />;
                      }
                      
                      const bgColor = getIntensityClass(day.count);
                      
                      return (
                        <div
                          key={dayIndex}
                          className={`w-[10px] h-[10px] rounded-[2px] ${bgColor} hover:ring-1 ring-primary cursor-pointer transition-all relative group`}
                        >
                          <div className="absolute bottom-full left-1/2 -translate-x-1/2 mb-2 px-3 py-2 bg-gray-900 dark:bg-gray-800 text-white text-xs rounded shadow-lg whitespace-nowrap opacity-0 invisible group-hover:opacity-100 group-hover:visible pointer-events-none transition-all duration-200 z-50 border border-gray-700">
                            <div className="font-semibold">{day.count} submission{day.count !== 1 ? 's' : ''}</div>
                            <div className="text-gray-400 text-[10px] mt-0.5">{formatDate(day.date)}</div>
                            <div className="absolute top-full left-1/2 -translate-x-1/2 -mt-[1px] border-4 border-transparent border-t-gray-900 dark:border-t-gray-800"></div>
                          </div>
                        </div>
                      );
                    })}
                  </div>
                ))}
              </div>
            </div>
          ))}
        </div>
      </div>
    );
  };

  const totalPercentage = difficultyStats.totalProblems > 0 
    ? Math.round((difficultyStats.totalSolved / difficultyStats.totalProblems) * 100) 
    : 0;

  return (
    <Layout>
      <div className="container mx-auto py-6 px-4">
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
          {/* Left Sidebar */}
          <div className="lg:col-span-3 space-y-4">
            {/* Profile Card */}
            <Card className="p-6">
              <div className="flex flex-col items-center text-center space-y-4">
                <Avatar className="w-24 h-24">
                  <AvatarImage src={userProfile?.avatar_url || undefined} />
                  <AvatarFallback className="text-2xl font-bold bg-primary/10 text-primary">
                    {(userProfile?.full_name || userProfile?.email || 'U').charAt(0).toUpperCase()}
                  </AvatarFallback>
                </Avatar>
                
                <div className="w-full">
                  <h2 className="text-xl font-bold">
                    {userProfile?.full_name || 'User'}
                  </h2>
                  <p className="text-sm text-muted-foreground mt-1">{userProfile?.email}</p>
                </div>

                <div className="w-full space-y-2">
                  <Button 
                    variant="default" 
                    className="w-full" 
                    size="sm"
                    onClick={() => setShowSettingsModal(true)}
                  >
                    <Settings className="w-4 h-4 mr-2" />
                    Profile Settings
                  </Button>
                  <Button 
                    variant="outline" 
                    className="w-full" 
                    size="sm"
                    onClick={() => setIsEditing(!isEditing)}
                  >
                    <Edit2 className="w-4 h-4 mr-2" />
                    {isEditing ? 'Cancel' : 'Edit Profile'}
                  </Button>
                  {isEditing && (
                    <Button 
                      variant="default" 
                      className="w-full bg-green-600 hover:bg-green-700" 
                      size="sm"
                      onClick={saveProfile}
                    >
                      Save Changes
                    </Button>
                  )}
                  <Button variant="outline" className="w-full" size="sm">
                    <Share2 className="w-4 h-4 mr-2" />
                    Share Profile
                  </Button>
                </div>
              </div>
            </Card>

            {/* Basic Information */}
            <Card className="p-6">
              <h3 className="font-semibold mb-3">Basic Information</h3>
              <div className="space-y-3 text-sm">
                <div>
                  <span className="text-muted-foreground block mb-1">Full Name</span>
                  {isEditing ? (
                    <Input
                      value={editForm.full_name}
                      onChange={(e) => setEditForm({ ...editForm, full_name: e.target.value })}
                      placeholder="Enter your full name"
                    />
                  ) : (
                    <span className="font-medium">{userProfile?.full_name || 'Not set'}</span>
                  )}
                </div>
                <div>
                  <span className="text-muted-foreground block mb-1">College</span>
                  {isEditing ? (
                    <Input
                      value={editForm.college}
                      onChange={(e) => setEditForm({ ...editForm, college: e.target.value })}
                      placeholder="Enter your college"
                    />
                  ) : (
                    <span className="font-medium">{userProfile?.college || 'Not set'}</span>
                  )}
                </div>
                <div>
                  <span className="text-muted-foreground block mb-1">Bio</span>
                  {isEditing ? (
                    <Textarea
                      value={editForm.bio}
                      onChange={(e) => setEditForm({ ...editForm, bio: e.target.value })}
                      placeholder="Tell us about yourself"
                      rows={3}
                    />
                  ) : (
                    <span className="font-medium">{userProfile?.bio || 'Not set'}</span>
                  )}
                </div>
              </div>
            </Card>

            {/* Social Media */}
            <Card className="p-6">
              <h3 className="font-semibold mb-3">Social Media</h3>
              {isEditing ? (
                <div className="space-y-3">
                  <div>
                    <span className="text-muted-foreground text-sm block mb-1">Instagram</span>
                    <Input
                      value={editForm.instagram_url}
                      onChange={(e) => setEditForm({ ...editForm, instagram_url: e.target.value })}
                      placeholder="https://instagram.com/yourprofile"
                    />
                  </div>
                  <div>
                    <span className="text-muted-foreground text-sm block mb-1">LinkedIn</span>
                    <Input
                      value={editForm.linkedin_url}
                      onChange={(e) => setEditForm({ ...editForm, linkedin_url: e.target.value })}
                      placeholder="https://linkedin.com/in/yourprofile"
                    />
                  </div>
                  <div>
                    <span className="text-muted-foreground text-sm block mb-1">Twitter</span>
                    <Input
                      value={editForm.twitter_url}
                      onChange={(e) => setEditForm({ ...editForm, twitter_url: e.target.value })}
                      placeholder="https://twitter.com/yourprofile"
                    />
                  </div>
                </div>
              ) : (
                <div className="flex gap-3">
                  {userProfile?.instagram_url && (
                    <a 
                      href={userProfile.instagram_url} 
                      target="_blank" 
                      rel="noopener noreferrer"
                      className="w-10 h-10 rounded-full bg-gradient-to-br from-purple-500 to-pink-500 flex items-center justify-center text-white hover:opacity-80 transition"
                    >
                      <Instagram className="w-5 h-5" />
                    </a>
                  )}
                  {userProfile?.linkedin_url && (
                    <a 
                      href={userProfile.linkedin_url} 
                      target="_blank" 
                      rel="noopener noreferrer"
                      className="w-10 h-10 rounded-full bg-blue-600 flex items-center justify-center text-white hover:opacity-80 transition"
                    >
                      <Linkedin className="w-5 h-5" />
                    </a>
                  )}
                  {userProfile?.twitter_url && (
                    <a 
                      href={userProfile.twitter_url} 
                      target="_blank" 
                      rel="noopener noreferrer"
                      className="w-10 h-10 rounded-full bg-sky-500 flex items-center justify-center text-white hover:opacity-80 transition"
                    >
                      <Twitter className="w-5 h-5" />
                    </a>
                  )}
                  {!userProfile?.instagram_url && !userProfile?.linkedin_url && !userProfile?.twitter_url && (
                    <span className="text-sm text-muted-foreground">No social media links added</span>
                  )}
                </div>
              )}
            </Card>

            {/* Track Progress */}
            <Card className="p-6">
              <h3 className="font-semibold mb-4">Track Progress</h3>
              <div className="space-y-3">
                {tracks.slice(0, 4).map((track) => {
                  const progress = trackProgress.find(p => p.trackId === track.slug || p.track_slug === track.slug);
                  const percentage = progress?.percentage || progress?.progress_percentage || 0;
                  
                  return (
                    <div key={track.id}>
                      <div className="flex justify-between text-sm mb-1">
                        <span className="font-medium">{track.shortTitle}</span>
                        <span className="text-muted-foreground">{percentage}%</span>
                      </div>
                      <div className="w-full bg-secondary h-2 rounded-full overflow-hidden">
                        <div 
                          className="bg-primary h-full transition-all duration-300"
                          style={{ width: `${percentage}%` }}
                        />
                      </div>
                    </div>
                  );
                })}
              </div>
            </Card>
          </div>

          {/* Main Content */}
          <div className="lg:col-span-9 space-y-6">
            {/* DSA Progress Tabs */}
            <Card className="p-6">
              <Tabs value={activeTab} onValueChange={(v) => setActiveTab(v as 'dsa' | 'babua' | 'leetcode' | 'referrals')}>
                <TabsList className="mb-6">
                  <TabsTrigger value="dsa">DSA Progress</TabsTrigger>
                  <TabsTrigger value="babua">Babua Dojo</TabsTrigger>
                  <TabsTrigger value="leetcode">LeetCode</TabsTrigger>
                  <TabsTrigger value="referrals">Referrals</TabsTrigger>
                </TabsList>

                <TabsContent value="dsa" className="mt-0">
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
                    {/* Large Circular Progress */}
                    <div className="flex flex-col items-center justify-center">
                      <div className="relative w-48 h-48">
                        {/* Background circle */}
                        <svg className="transform -rotate-90 w-48 h-48">
                          <circle
                            cx="96"
                            cy="96"
                            r="88"
                            stroke="currentColor"
                            strokeWidth="12"
                            fill="transparent"
                            className="text-muted/30"
                          />
                          {/* Hard (red) - innermost */}
                          <circle
                            cx="96"
                            cy="96"
                            r="88"
                            stroke="#ef4444"
                            strokeWidth="12"
                            fill="transparent"
                            strokeDasharray={`${2 * Math.PI * 88}`}
                            strokeDashoffset={`${2 * Math.PI * 88 * (1 - (difficultyStats.hard.solved / difficultyStats.hard.total))}`}
                            className="transition-all duration-500"
                          />
                          {/* Medium (yellow) */}
                          <circle
                            cx="96"
                            cy="96"
                            r="76"
                            stroke="#eab308"
                            strokeWidth="12"
                            fill="transparent"
                            strokeDasharray={`${2 * Math.PI * 76}`}
                            strokeDashoffset={`${2 * Math.PI * 76 * (1 - (difficultyStats.medium.solved / difficultyStats.medium.total))}`}
                            className="transition-all duration-500"
                          />
                          {/* Easy (green) - outermost ring */}
                          <circle
                            cx="96"
                            cy="96"
                            r="64"
                            stroke="#22c55e"
                            strokeWidth="12"
                            fill="transparent"
                            strokeDasharray={`${2 * Math.PI * 64}`}
                            strokeDashoffset={`${2 * Math.PI * 64 * (1 - (difficultyStats.easy.solved / difficultyStats.easy.total))}`}
                            className="transition-all duration-500"
                          />
                        </svg>
                        <div className="absolute inset-0 flex flex-col items-center justify-center">
                          <span className="text-4xl font-bold">{difficultyStats.totalSolved}</span>
                          <span className="text-muted-foreground">/ {difficultyStats.totalProblems}</span>
                          <span className="text-2xl font-semibold mt-1">{totalPercentage}%</span>
                        </div>
                      </div>
                    </div>

                    {/* Stats Grid */}
                    <div className="flex flex-col justify-center space-y-6">
                      <div className="flex items-center justify-between">
                        <div className="flex items-center gap-3">
                          <div className="w-3 h-3 rounded-full bg-green-500"></div>
                          <span className="font-medium">Easy</span>
                        </div>
                        <span className="font-semibold">
                          {difficultyStats.easy.solved} / {difficultyStats.easy.total}
                        </span>
                      </div>
                      
                      <div className="flex items-center justify-between">
                        <div className="flex items-center gap-3">
                          <div className="w-3 h-3 rounded-full bg-yellow-500"></div>
                          <span className="font-medium">Medium</span>
                        </div>
                        <span className="font-semibold">
                          {difficultyStats.medium.solved} / {difficultyStats.medium.total}
                        </span>
                      </div>
                      
                      <div className="flex items-center justify-between">
                        <div className="flex items-center gap-3">
                          <div className="w-3 h-3 rounded-full bg-red-500"></div>
                          <span className="font-medium">Hard</span>
                        </div>
                        <span className="font-semibold">
                          {difficultyStats.hard.solved} / {difficultyStats.hard.total}
                        </span>
                      </div>
                    </div>
                  </div>
                </TabsContent>

                <TabsContent value="babua">
                  <div className="space-y-6">
                    <div className="text-center">
                      <h3 className="text-2xl font-bold mb-2">Babua Dojo Stats</h3>
                      <p className="text-muted-foreground">Your complete learning journey</p>
                    </div>
                    <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                      <Card className="p-4 text-center">
                        <div className="text-3xl font-bold text-green-500">{difficultyStats.easy.solved}</div>
                        <div className="text-sm text-muted-foreground">Easy Solved</div>
                      </Card>
                      <Card className="p-4 text-center">
                        <div className="text-3xl font-bold text-yellow-500">{difficultyStats.medium.solved}</div>
                        <div className="text-sm text-muted-foreground">Medium Solved</div>
                      </Card>
                      <Card className="p-4 text-center">
                        <div className="text-3xl font-bold text-red-500">{difficultyStats.hard.solved}</div>
                        <div className="text-sm text-muted-foreground">Hard Solved</div>
                      </Card>
                      <Card className="p-4 text-center">
                        <div className="text-3xl font-bold text-primary">{difficultyStats.totalSolved}</div>
                        <div className="text-sm text-muted-foreground">Total Solved</div>
                      </Card>
                    </div>
                  </div>
                </TabsContent>

                <TabsContent value="leetcode">
                  <div className="text-center py-12 text-muted-foreground">
                    LeetCode integration coming soon...
                  </div>
                </TabsContent>

                <TabsContent value="referrals" className="mt-0">
                  <ReferralDashboard />
                </TabsContent>
              </Tabs>
            </Card>

            {/* Sheet Progress */}
            <Card className="p-6">
              <h3 className="text-xl font-semibold mb-6">Sheet Progress</h3>
              <div className="space-y-5">
                {sheetProgress.map((sheet) => (
                  <div key={sheet.name}>
                    <div className="flex justify-between items-center mb-2">
                      <span className="font-medium">{sheet.name}</span>
                      <span className="text-sm text-muted-foreground">
                        {sheet.solved}/{sheet.total} ({sheet.percentage}%)
                      </span>
                    </div>
                    <div className="w-full bg-secondary h-2.5 rounded-full overflow-hidden">
                      <div 
                        className="bg-primary h-full transition-all duration-300"
                        style={{ width: `${sheet.percentage}%` }}
                      />
                    </div>
                  </div>
                ))}
              </div>
            </Card>

            {/* Activity Heatmap */}
            <Card className="p-6">
              <div className="flex items-center justify-between mb-2">
                <div className="flex items-center gap-2">
                  <h3 className="text-lg font-semibold">{difficultyStats.totalSolved} submissions in the past one year</h3>
                  <button className="text-muted-foreground hover:text-foreground transition-colors">
                    <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor">
                      <path d="M8 0a8 8 0 1 1 0 16A8 8 0 0 1 8 0ZM1.5 8a6.5 6.5 0 1 0 13 0 6.5 6.5 0 0 0-13 0Zm7-3.25v2.992l2.028.812a.75.75 0 0 1-.557 1.392l-2.5-1A.751.751 0 0 1 7 8.25v-3.5a.75.75 0 0 1 1.5 0Z"></path>
                    </svg>
                  </button>
                </div>
                <div className="flex items-center gap-4 text-sm">
                  <div className="flex items-center gap-2">
                    <span className="text-muted-foreground">Total active days:</span>
                    <span className="font-semibold">{activeDays}</span>
                  </div>
                  <div className="flex items-center gap-2">
                    <span className="text-muted-foreground">Max streak:</span>
                    <span className="font-semibold">{maxStreak}</span>
                  </div>
                  <Button variant="outline" size="sm" className="gap-2">
                    Current
                    <ChevronDown className="w-4 h-4" />
                  </Button>
                </div>
              </div>

              <div className="mt-6">
                {renderHeatmapGrid()}
              </div>

              <div className="flex items-center justify-end gap-2 mt-4 text-xs text-muted-foreground">
                <span>Less</span>
                <div className="flex gap-1">
                  <div className="w-[10px] h-[10px] rounded-[2px] bg-gray-200 dark:bg-gray-800"></div>
                  <div className="w-[10px] h-[10px] rounded-[2px] bg-green-300 dark:bg-green-900"></div>
                  <div className="w-[10px] h-[10px] rounded-[2px] bg-green-400 dark:bg-green-700"></div>
                  <div className="w-[10px] h-[10px] rounded-[2px] bg-green-500 dark:bg-green-600"></div>
                  <div className="w-[10px] h-[10px] rounded-[2px] bg-green-600 dark:bg-green-500"></div>
                </div>
                <span>More</span>
              </div>
            </Card>

            {/* Skills Section */}
            <Card className="p-6">
              <div className="flex items-center justify-between mb-4">
                <h3 className="text-xl font-semibold">Skills</h3>
                <Button variant="ghost" size="sm" className="text-muted-foreground">
                  <Edit2 className="w-4 h-4 mr-2" />
                  Edit Profile to add
                </Button>
              </div>
            </Card>

            {/* Coding Profiles */}
            <Card className="p-6">
              <h3 className="text-xl font-semibold mb-6">Coding Profiles</h3>
              
              {isEditing ? (
                <div className="space-y-4">
                  <div>
                    <span className="text-sm text-muted-foreground block mb-1">LeetCode Username</span>
                    <Input
                      value={editForm.leetcode_username}
                      onChange={(e) => setEditForm({ ...editForm, leetcode_username: e.target.value })}
                      placeholder="Your LeetCode username"
                    />
                  </div>
                  <div>
                    <span className="text-sm text-muted-foreground block mb-1">GitHub Username</span>
                    <Input
                      value={editForm.github_username}
                      onChange={(e) => setEditForm({ ...editForm, github_username: e.target.value })}
                      placeholder="Your GitHub username"
                    />
                  </div>
                  <div>
                    <span className="text-sm text-muted-foreground block mb-1">Codeforces Username</span>
                    <Input
                      value={editForm.codeforces_username}
                      onChange={(e) => setEditForm({ ...editForm, codeforces_username: e.target.value })}
                      placeholder="Your Codeforces username"
                    />
                  </div>
                  <div>
                    <span className="text-sm text-muted-foreground block mb-1">CodeChef Username</span>
                    <Input
                      value={editForm.codechef_username}
                      onChange={(e) => setEditForm({ ...editForm, codechef_username: e.target.value })}
                      placeholder="Your CodeChef username"
                    />
                  </div>
                </div>
              ) : (
                <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                  <a
                    href={userProfile?.leetcode_username ? `https://leetcode.com/${userProfile.leetcode_username}` : '#'}
                    target={userProfile?.leetcode_username ? "_blank" : undefined}
                    rel={userProfile?.leetcode_username ? "noopener noreferrer" : undefined}
                    className={`text-center p-4 rounded-lg border ${userProfile?.leetcode_username ? 'hover:border-yellow-500 transition cursor-pointer' : 'cursor-default'}`}
                  >
                    <div className="w-12 h-12 mx-auto mb-2 rounded-full bg-yellow-500/20 flex items-center justify-center">
                      <span className="text-2xl">💡</span>
                    </div>
                    <p className="font-medium text-sm">LeetCode</p>
                    <p className="text-xs text-muted-foreground mt-1">
                      {userProfile?.leetcode_username || 'Not set'}
                    </p>
                  </a>
                  
                  <a
                    href={userProfile?.github_username ? `https://github.com/${userProfile.github_username}` : '#'}
                    target={userProfile?.github_username ? "_blank" : undefined}
                    rel={userProfile?.github_username ? "noopener noreferrer" : undefined}
                    className={`text-center p-4 rounded-lg border ${userProfile?.github_username ? 'hover:border-gray-500 transition cursor-pointer' : 'cursor-default'}`}
                  >
                    <div className="w-12 h-12 mx-auto mb-2 rounded-full bg-gray-500/20 flex items-center justify-center">
                      <Github className="w-6 h-6" />
                    </div>
                    <p className="font-medium text-sm">GitHub</p>
                    <p className="text-xs text-muted-foreground mt-1">
                      {userProfile?.github_username || 'Not set'}
                    </p>
                  </a>
                  
                  <a
                    href={userProfile?.codeforces_username ? `https://codeforces.com/profile/${userProfile.codeforces_username}` : '#'}
                    target={userProfile?.codeforces_username ? "_blank" : undefined}
                    rel={userProfile?.codeforces_username ? "noopener noreferrer" : undefined}
                    className={`text-center p-4 rounded-lg border ${userProfile?.codeforces_username ? 'hover:border-blue-500 transition cursor-pointer' : 'cursor-default'}`}
                  >
                    <div className="w-12 h-12 mx-auto mb-2 rounded-full bg-blue-500/20 flex items-center justify-center">
                      <span className="text-2xl">🏆</span>
                    </div>
                    <p className="font-medium text-sm">Codeforces</p>
                    <p className="text-xs text-muted-foreground mt-1">
                      {userProfile?.codeforces_username || 'Not set'}
                    </p>
                  </a>
                  
                  <a
                    href={userProfile?.codechef_username ? `https://www.codechef.com/users/${userProfile.codechef_username}` : '#'}
                    target={userProfile?.codechef_username ? "_blank" : undefined}
                    rel={userProfile?.codechef_username ? "noopener noreferrer" : undefined}
                    className={`text-center p-4 rounded-lg border ${userProfile?.codechef_username ? 'hover:border-orange-500 transition cursor-pointer' : 'cursor-default'}`}
                  >
                    <div className="w-12 h-12 mx-auto mb-2 rounded-full bg-orange-500/20 flex items-center justify-center">
                      <span className="text-2xl">👨‍💻</span>
                    </div>
                    <p className="font-medium text-sm">CodeChef</p>
                    <p className="text-xs text-muted-foreground mt-1">
                      {userProfile?.codechef_username || 'Not set'}
                    </p>
                  </a>
                </div>
              )}
            </Card>

            {/* Contests Section */}
            <Card className="p-6">
              <h3 className="text-xl font-semibold mb-4">Contests</h3>
              <p className="text-muted-foreground text-center py-8">
                No contests participated yet
              </p>
            </Card>
          </div>
        </div>
      </div>

      {/* Profile Settings Modal */}
      {user && (
        <ProfileSettingsModal
          userId={user.id}
          isOpen={showSettingsModal}
          onClose={() => setShowSettingsModal(false)}
          onUpdate={() => loadUserData()}
        />
      )}
    </Layout>
  );
}
