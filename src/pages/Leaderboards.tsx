import { useState, useEffect } from 'react';
import { Layout } from '@/components/layout/Layout';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import { Trophy, Medal, Crown, TrendingUp, Users, Flame } from 'lucide-react';
import { RankBadge } from '@/components/profile/RankBadge';
import { getGlobalRankLeaderboard, getUserGlobalRank } from '@/lib/rankService';
import { useAuth } from '@/contexts/AuthContext';

interface LeaderboardEntry {
  user_id: string;
  username: string | null;
  full_name: string | null;
  email: string | null;
  avatar_url: string | null;
  current_rank: string;
  rank_xp: number;
  rank_ups: number;
  global_rank: number;
}

export default function Leaderboards() {
  const { user } = useAuth();
  const [leaderboard, setLeaderboard] = useState<LeaderboardEntry[]>([]);
  const [myRank, setMyRank] = useState<number | null>(null);
  const [loading, setLoading] = useState(true);
  const [activeTab, setActiveTab] = useState('global');

  useEffect(() => {
    loadLeaderboard();
  }, [user]);

  const loadLeaderboard = async () => {
    setLoading(true);
    try {
      const data = await getGlobalRankLeaderboard(100);
      setLeaderboard(data as LeaderboardEntry[]);

      if (user) {
        const rank = await getUserGlobalRank(user.id);
        setMyRank(rank);
      }
    } catch (error) {
      console.error('Error loading leaderboard:', error);
    } finally {
      setLoading(false);
    }
  };

  const getRankIcon = (position: number) => {
    switch (position) {
      case 1:
        return <Crown className="w-6 h-6 text-yellow-500" />;
      case 2:
        return <Medal className="w-6 h-6 text-gray-400" />;
      case 3:
        return <Medal className="w-6 h-6 text-amber-600" />;
      default:
        return null;
    }
  };

  const getInitials = (name: string | null, email: string | null) => {
    if (name) {
      return name
        .split(' ')
        .map(n => n[0])
        .join('')
        .toUpperCase()
        .slice(0, 2);
    }
    return email?.[0].toUpperCase() || 'U';
  };

  if (loading) {
    return (
      <Layout>
        <div className="container mx-auto px-4 py-12">
          <div className="flex items-center justify-center min-h-[400px]">
            <div className="text-center">
              <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto mb-4"></div>
              <p className="text-muted-foreground">Loading leaderboards...</p>
            </div>
          </div>
        </div>
      </Layout>
    );
  }

  return (
    <Layout>
      <div className="container mx-auto px-4 py-12">
        <div className="max-w-5xl mx-auto">
          {/* Header */}
          <div className="text-center mb-8">
            <Trophy className="h-16 w-16 mx-auto mb-4 text-primary" />
            <h1 className="text-4xl font-bold mb-2">Leaderboards</h1>
            <p className="text-muted-foreground">
              See how you rank against other developers
            </p>
          </div>

          {/* My Rank Card */}
          {myRank && (
            <Card className="mb-8 border-2 border-primary">
              <CardContent className="pt-6">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-4">
                    <div className="text-3xl font-bold text-primary">
                      #{myRank}
                    </div>
                    <div>
                      <div className="font-semibold">Your Global Rank</div>
                      <div className="text-sm text-muted-foreground">
                        {leaderboard.length > 0 && `Out of ${leaderboard.length}+ players`}
                      </div>
                    </div>
                  </div>
                  <TrendingUp className="h-8 w-8 text-primary" />
                </div>
              </CardContent>
            </Card>
          )}

          {/* Leaderboard Tabs */}
          <Tabs value={activeTab} onValueChange={setActiveTab}>
            <TabsList className="grid w-full grid-cols-3 mb-6">
              <TabsTrigger value="global">
                <Trophy className="w-4 h-4 mr-2" />
                Global
              </TabsTrigger>
              <TabsTrigger value="weekly" disabled>
                <Flame className="w-4 h-4 mr-2" />
                Weekly
              </TabsTrigger>
              <TabsTrigger value="friends" disabled>
                <Users className="w-4 h-4 mr-2" />
                Friends
              </TabsTrigger>
            </TabsList>

            <TabsContent value="global">
              <Card>
                <CardHeader>
                  <CardTitle>Global Rankings</CardTitle>
                </CardHeader>
                <CardContent>
                  {/* Top 3 Podium */}
                  {leaderboard.length >= 3 && (
                    <div className="grid grid-cols-3 gap-4 mb-8">
                      {/* 2nd Place */}
                      <div className="text-center pt-8">
                        <div className="relative inline-block">
                          <Avatar className="w-20 h-20 border-4 border-gray-400 mx-auto">
                            <AvatarImage src={leaderboard[1].avatar_url || undefined} />
                            <AvatarFallback className="bg-gray-400/20 text-lg">
                              {getInitials(leaderboard[1].full_name, leaderboard[1].email)}
                            </AvatarFallback>
                          </Avatar>
                          <div className="absolute -top-2 -right-2">
                            {getRankIcon(2)}
                          </div>
                        </div>
                        <div className="mt-3 font-semibold">
                          {leaderboard[1].full_name || leaderboard[1].email?.split('@')[0]}
                        </div>
                        <RankBadge
                          rank={leaderboard[1].current_rank}
                          size="small"
                          showTooltip={false}
                          className="mt-2 mx-auto"
                        />
                        <div className="text-2xl font-bold text-primary mt-2">
                          {leaderboard[1].rank_xp.toLocaleString()} XP
                        </div>
                      </div>

                      {/* 1st Place */}
                      <div className="text-center">
                        <div className="relative inline-block">
                          <Avatar className="w-24 h-24 border-4 border-yellow-500 mx-auto">
                            <AvatarImage src={leaderboard[0].avatar_url || undefined} />
                            <AvatarFallback className="bg-yellow-500/20 text-xl">
                              {getInitials(leaderboard[0].full_name, leaderboard[0].email)}
                            </AvatarFallback>
                          </Avatar>
                          <div className="absolute -top-2 -right-2">
                            {getRankIcon(1)}
                          </div>
                        </div>
                        <div className="mt-3 font-bold text-lg">
                          {leaderboard[0].full_name || leaderboard[0].email?.split('@')[0]}
                        </div>
                        <RankBadge
                          rank={leaderboard[0].current_rank}
                          size="medium"
                          showTooltip={false}
                          className="mt-2 mx-auto"
                        />
                        <div className="text-3xl font-bold text-yellow-500 mt-2">
                          {leaderboard[0].rank_xp.toLocaleString()} XP
                        </div>
                      </div>

                      {/* 3rd Place */}
                      <div className="text-center pt-8">
                        <div className="relative inline-block">
                          <Avatar className="w-20 h-20 border-4 border-amber-600 mx-auto">
                            <AvatarImage src={leaderboard[2].avatar_url || undefined} />
                            <AvatarFallback className="bg-amber-600/20 text-lg">
                              {getInitials(leaderboard[2].full_name, leaderboard[2].email)}
                            </AvatarFallback>
                          </Avatar>
                          <div className="absolute -top-2 -right-2">
                            {getRankIcon(3)}
                          </div>
                        </div>
                        <div className="mt-3 font-semibold">
                          {leaderboard[2].full_name || leaderboard[2].email?.split('@')[0]}
                        </div>
                        <RankBadge
                          rank={leaderboard[2].current_rank}
                          size="small"
                          showTooltip={false}
                          className="mt-2 mx-auto"
                        />
                        <div className="text-2xl font-bold text-primary mt-2">
                          {leaderboard[2].rank_xp.toLocaleString()} XP
                        </div>
                      </div>
                    </div>
                  )}

                  {/* Rest of Leaderboard */}
                  <div className="space-y-2">
                    {leaderboard.slice(3).map((entry) => (
                      <div
                        key={entry.user_id}
                        className={`flex items-center justify-between p-4 rounded-lg transition-colors ${
                          entry.user_id === user?.id
                            ? 'bg-primary/10 border-2 border-primary'
                            : 'bg-secondary/50 hover:bg-secondary'
                        }`}
                      >
                        <div className="flex items-center gap-4 flex-1">
                          <div className="text-lg font-bold text-muted-foreground w-12 text-center">
                            #{entry.global_rank}
                          </div>
                          <Avatar className="w-10 h-10">
                            <AvatarImage src={entry.avatar_url || undefined} />
                            <AvatarFallback>
                              {getInitials(entry.full_name, entry.email)}
                            </AvatarFallback>
                          </Avatar>
                          <div className="flex-1">
                            <div className="font-semibold">
                              {entry.full_name || entry.email?.split('@')[0]}
                              {entry.user_id === user?.id && (
                                <span className="ml-2 text-sm text-primary">(You)</span>
                              )}
                            </div>
                            <div className="text-sm text-muted-foreground">
                              {entry.rank_ups} rank-ups
                            </div>
                          </div>
                          <RankBadge
                            rank={entry.current_rank}
                            size="small"
                            showTooltip={false}
                            animated={false}
                          />
                          <div className="text-right min-w-[100px]">
                            <div className="text-xl font-bold text-primary">
                              {entry.rank_xp.toLocaleString()}
                            </div>
                            <div className="text-xs text-muted-foreground">XP</div>
                          </div>
                        </div>
                      </div>
                    ))}
                  </div>

                  {leaderboard.length === 0 && (
                    <div className="text-center py-12 text-muted-foreground">
                      <Trophy className="w-16 h-16 mx-auto mb-4 opacity-50" />
                      <p>No rankings yet</p>
                      <p className="text-sm mt-2">
                        Start solving problems to appear on the leaderboard!
                      </p>
                    </div>
                  )}
                </CardContent>
              </Card>
            </TabsContent>

            <TabsContent value="weekly">
              <Card>
                <CardContent className="pt-6 text-center py-12">
                  <Flame className="w-16 h-16 mx-auto mb-4 text-muted-foreground opacity-50" />
                  <p className="text-muted-foreground">Weekly leaderboard coming soon!</p>
                </CardContent>
              </Card>
            </TabsContent>

            <TabsContent value="friends">
              <Card>
                <CardContent className="pt-6 text-center py-12">
                  <Users className="w-16 h-16 mx-auto mb-4 text-muted-foreground opacity-50" />
                  <p className="text-muted-foreground">Friends leaderboard coming soon!</p>
                </CardContent>
              </Card>
            </TabsContent>
          </Tabs>
        </div>
      </div>
    </Layout>
  );
}
