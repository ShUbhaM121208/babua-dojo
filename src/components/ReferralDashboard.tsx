import { useState, useEffect } from "react";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import { useAuth } from "@/contexts/AuthContext";
import { useToast } from "@/hooks/use-toast";
import {
  getUserReferralStats,
  getUserReferralCode,
  getUserReferralRewards,
  shareReferralLink,
  copyReferralLink,
  getReferralLeaderboard,
  type ReferralStats,
  type ReferralReward
} from "@/lib/referralService";
import {
  Users,
  Gift,
  Trophy,
  Copy,
  Share2,
  Mail,
  MessageCircle,
  Twitter,
  Sparkles,
  TrendingUp,
  Award,
  Check
} from "lucide-react";

interface ReferralDashboardProps {
  className?: string;
}

export function ReferralDashboard({ className = "" }: ReferralDashboardProps) {
  const { user } = useAuth();
  const { toast } = useToast();
  const [stats, setStats] = useState<ReferralStats | null>(null);
  const [referralCode, setReferralCode] = useState<string>("");
  const [rewards, setRewards] = useState<ReferralReward[]>([]);
  const [leaderboard, setLeaderboard] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [copied, setCopied] = useState(false);

  useEffect(() => {
    if (user) {
      loadReferralData();
    }
  }, [user]);

  const loadReferralData = async () => {
    if (!user) return;

    try {
      setLoading(true);
      const [statsData, code, rewardsData, leaderboardData] = await Promise.all([
        getUserReferralStats(user.id),
        getUserReferralCode(user.id),
        getUserReferralRewards(user.id),
        getReferralLeaderboard(10)
      ]);

      setStats(statsData);
      setReferralCode(code || "");
      setRewards(rewardsData);
      setLeaderboard(leaderboardData);
    } catch (error) {
      console.error("Error loading referral data:", error);
    } finally {
      setLoading(false);
    }
  };

  const handleCopyLink = async () => {
    if (!referralCode) return;

    const success = await copyReferralLink(referralCode);
    if (success) {
      setCopied(true);
      toast({
        title: "Link copied!",
        description: "Referral link copied to clipboard"
      });
      setTimeout(() => setCopied(false), 2000);
    } else {
      toast({
        title: "Failed to copy",
        description: "Please try again",
        variant: "destructive"
      });
    }
  };

  const handleShare = (platform: 'whatsapp' | 'twitter' | 'email') => {
    if (!referralCode) return;
    shareReferralLink(referralCode, platform);
  };

  const getNextMilestone = () => {
    const successful = stats?.successful_referrals || 0;
    if (successful < 5) return { count: 5, reward: "Recruiter Badge" };
    if (successful < 10) return { count: 10, reward: "Influencer Badge" };
    if (successful < 25) return { count: 25, reward: "Ambassador Badge + 7-day Premium" };
    return { count: 50, reward: "Legend Status" };
  };

  const milestone = getNextMilestone();
  const progress = stats ? (stats.successful_referrals / milestone.count) * 100 : 0;

  if (loading) {
    return (
      <div className={`space-y-6 ${className}`}>
        <Card>
          <CardHeader>
            <CardTitle>Loading referral data...</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="flex items-center justify-center h-32">
              <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
            </div>
          </CardContent>
        </Card>
      </div>
    );
  }

  return (
    <div className={`space-y-6 ${className}`}>
      {/* Referral Code Card */}
      <Card className="border-primary/20 bg-gradient-to-br from-primary/5 to-secondary/50">
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <Share2 className="h-5 w-5 text-primary" />
            Your Referral Code
          </CardTitle>
          <CardDescription>
            Share your code and earn rewards when friends join!
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          {/* Code Display */}
          <div className="flex items-center gap-2">
            <Input
              value={referralCode}
              readOnly
              className="font-mono text-lg font-bold text-primary text-center"
            />
            <Button
              size="icon"
              variant="outline"
              onClick={handleCopyLink}
              className="shrink-0"
            >
              {copied ? <Check className="h-4 w-4" /> : <Copy className="h-4 w-4" />}
            </Button>
          </div>

          {/* Share Buttons */}
          <div className="grid grid-cols-3 gap-2">
            <Button
              variant="outline"
              size="sm"
              onClick={() => handleShare('whatsapp')}
              className="gap-2"
            >
              <MessageCircle className="h-4 w-4" />
              WhatsApp
            </Button>
            <Button
              variant="outline"
              size="sm"
              onClick={() => handleShare('twitter')}
              className="gap-2"
            >
              <Twitter className="h-4 w-4" />
              Twitter
            </Button>
            <Button
              variant="outline"
              size="sm"
              onClick={() => handleShare('email')}
              className="gap-2"
            >
              <Mail className="h-4 w-4" />
              Email
            </Button>
          </div>

          {/* Referral Link */}
          <div className="text-xs text-muted-foreground text-center">
            Share link: {window.location.origin}/auth?ref={referralCode}
          </div>
        </CardContent>
      </Card>

      {/* Stats Grid */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <Card>
          <CardContent className="pt-6">
            <div className="flex flex-col items-center text-center">
              <Users className="h-8 w-8 text-blue-400 mb-2" />
              <div className="text-2xl font-mono font-bold">
                {stats?.total_referrals || 0}
              </div>
              <div className="text-xs text-muted-foreground">Total Referrals</div>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="pt-6">
            <div className="flex flex-col items-center text-center">
              <TrendingUp className="h-8 w-8 text-green-400 mb-2" />
              <div className="text-2xl font-mono font-bold text-primary">
                {stats?.successful_referrals || 0}
              </div>
              <div className="text-xs text-muted-foreground">Successful</div>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="pt-6">
            <div className="flex flex-col items-center text-center">
              <Sparkles className="h-8 w-8 text-amber-400 mb-2" />
              <div className="text-2xl font-mono font-bold">
                {stats?.total_xp_earned || 0}
              </div>
              <div className="text-xs text-muted-foreground">XP Earned</div>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="pt-6">
            <div className="flex flex-col items-center text-center">
              <Award className="h-8 w-8 text-purple-400 mb-2" />
              <div className="text-2xl font-mono font-bold">
                {stats?.badges_unlocked?.length || 0}
              </div>
              <div className="text-xs text-muted-foreground">Badges</div>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Next Milestone */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2 text-lg">
            <Trophy className="h-5 w-5 text-amber-400" />
            Next Milestone
          </CardTitle>
        </CardHeader>
        <CardContent className="space-y-3">
          <div className="flex items-center justify-between text-sm">
            <span className="text-muted-foreground">
              {stats?.successful_referrals || 0} / {milestone.count} successful referrals
            </span>
            <Badge variant="secondary" className="font-mono">
              {milestone.reward}
            </Badge>
          </div>
          <div className="h-2 bg-secondary rounded-full overflow-hidden">
            <div
              className="h-full bg-gradient-to-r from-primary to-amber-400 transition-all duration-500"
              style={{ width: `${Math.min(progress, 100)}%` }}
            />
          </div>
        </CardContent>
      </Card>

      {/* Recent Rewards */}
      {rewards.length > 0 && (
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2 text-lg">
              <Gift className="h-5 w-5 text-primary" />
              Recent Rewards
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-3">
              {rewards.slice(0, 5).map((reward) => (
                <div
                  key={reward.id}
                  className="flex items-center justify-between p-3 rounded-lg bg-secondary/50"
                >
                  <div className="flex-1">
                    <p className="text-sm font-medium">{reward.reward_description}</p>
                    <p className="text-xs text-muted-foreground">
                      {new Date(reward.created_at).toLocaleDateString()}
                    </p>
                  </div>
                  {reward.reward_value > 0 && (
                    <Badge variant="outline" className="font-mono">
                      +{reward.reward_value} XP
                    </Badge>
                  )}
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      )}

      {/* How It Works */}
      <Card>
        <CardHeader>
          <CardTitle className="text-lg">How It Works</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="space-y-3 text-sm">
            <div className="flex items-start gap-3">
              <div className="w-6 h-6 rounded-full bg-primary/20 flex items-center justify-center shrink-0 mt-0.5">
                <span className="text-xs font-bold text-primary">1</span>
              </div>
              <div>
                <p className="font-medium">Share your code</p>
                <p className="text-muted-foreground text-xs">
                  Invite friends using your unique referral code
                </p>
              </div>
            </div>

            <div className="flex items-start gap-3">
              <div className="w-6 h-6 rounded-full bg-primary/20 flex items-center justify-center shrink-0 mt-0.5">
                <span className="text-xs font-bold text-primary">2</span>
              </div>
              <div>
                <p className="font-medium">They get 200 XP bonus</p>
                <p className="text-muted-foreground text-xs">
                  Your friend receives instant XP on signup
                </p>
              </div>
            </div>

            <div className="flex items-start gap-3">
              <div className="w-6 h-6 rounded-full bg-primary/20 flex items-center justify-center shrink-0 mt-0.5">
                <span className="text-xs font-bold text-primary">3</span>
              </div>
              <div>
                <p className="font-medium">You earn 500 XP</p>
                <p className="text-muted-foreground text-xs">
                  Get rewarded when they solve 10 problems
                </p>
              </div>
            </div>

            <div className="flex items-start gap-3">
              <div className="w-6 h-6 rounded-full bg-primary/20 flex items-center justify-center shrink-0 mt-0.5">
                <span className="text-xs font-bold text-primary">4</span>
              </div>
              <div>
                <p className="font-medium">Unlock exclusive badges</p>
                <p className="text-muted-foreground text-xs">
                  Earn special badges at 5, 10, and 25 successful referrals
                </p>
              </div>
            </div>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
