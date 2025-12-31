import { useState, useEffect } from 'react';
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Badge } from '@/components/ui/badge';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import { 
  Users, 
  UserPlus, 
  Check, 
  X, 
  Search,
  MessageCircle,
  TrendingUp
} from 'lucide-react';
import { useAuth } from '@/contexts/AuthContext';
import { useToast } from '@/hooks/use-toast';
import {
  getStudyBuddies,
  sendBuddyRequest,
  acceptBuddyRequest,
  rejectBuddyRequest,
  type StudyBuddy
} from '@/lib/studyPlanService';
import { RankBadge } from '@/components/profile/RankBadge';
import { getUserRank } from '@/lib/rankService';

export function StudyBuddies() {
  const { user } = useAuth();
  const { toast } = useToast();
  const [buddies, setBuddies] = useState<StudyBuddy[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchEmail, setSearchEmail] = useState('');
  const [sendingRequest, setSendingRequest] = useState(false);
  const [buddyRanks, setBuddyRanks] = useState<Record<string, any>>({});

  useEffect(() => {
    if (user) {
      loadBuddies();
    }
  }, [user]);

  const loadBuddies = async () => {
    if (!user) return;
    
    setLoading(true);
    const buddiesData = await getStudyBuddies(user.id);
    setBuddies(buddiesData || []);
    
    // Fetch ranks for all buddies
    if (buddiesData) {
      const ranks: Record<string, any> = {};
      for (const buddy of buddiesData) {
        const rank = await getUserRank(buddy.buddy_id);
        if (rank) {
          ranks[buddy.buddy_id] = rank;
        }
      }
      setBuddyRanks(ranks);
    }
    
    setLoading(false);
  };

  const handleSendRequest = async () => {
    if (!user || !searchEmail.trim()) {
      toast({
        title: 'Error',
        description: 'Please enter an email address',
        variant: 'destructive',
      });
      return;
    }

    setSendingRequest(true);
    const success = await sendBuddyRequest(user.id, searchEmail.trim());
    setSendingRequest(false);

    if (success) {
      toast({
        title: 'Request sent!',
        description: 'Your study buddy request has been sent',
      });
      setSearchEmail('');
      loadBuddies();
    } else {
      toast({
        title: 'Error',
        description: 'Failed to send buddy request. User may not exist.',
        variant: 'destructive',
      });
    }
  };

  const handleAccept = async (buddyId: string) => {
    const success = await acceptBuddyRequest(buddyId);
    
    if (success) {
      toast({
        title: 'Buddy request accepted!',
        description: 'You are now study buddies',
      });
      loadBuddies();
    } else {
      toast({
        title: 'Error',
        description: 'Failed to accept request',
        variant: 'destructive',
      });
    }
  };

  const handleReject = async (buddyId: string) => {
    const success = await rejectBuddyRequest(buddyId);
    
    if (success) {
      toast({
        title: 'Request rejected',
      });
      loadBuddies();
    } else {
      toast({
        title: 'Error',
        description: 'Failed to reject request',
        variant: 'destructive',
      });
    }
  };

  const getInitials = (name?: string) => {
    if (!name) return '?';
    return name
      .split(' ')
      .map(n => n[0])
      .join('')
      .toUpperCase()
      .slice(0, 2);
  };

  const pendingRequests = buddies.filter(b => b.status === 'pending');
  const activeBuddies = buddies.filter(b => b.status === 'active');

  if (loading) {
    return (
      <Card>
        <CardHeader>
          <CardTitle className="text-xl flex items-center gap-2">
            <Users className="w-5 h-5" />
            Study Buddies
          </CardTitle>
        </CardHeader>
        <CardContent>
          <div className="space-y-3">
            {[1, 2, 3].map(i => (
              <div key={i} className="h-16 bg-muted animate-pulse rounded-lg" />
            ))}
          </div>
        </CardContent>
      </Card>
    );
  }

  return (
    <Card>
      <CardHeader>
        <CardTitle className="text-xl flex items-center gap-2">
          <Users className="w-5 h-5" />
          Study Buddies
        </CardTitle>
      </CardHeader>
      <CardContent className="space-y-6">
        {/* Send Request */}
        <div className="space-y-2">
          <label className="text-sm font-medium">Invite a Study Buddy</label>
          <div className="flex gap-2">
            <Input
              placeholder="Enter email address..."
              value={searchEmail}
              onChange={(e) => setSearchEmail(e.target.value)}
              onKeyPress={(e) => e.key === 'Enter' && handleSendRequest()}
            />
            <Button 
              onClick={handleSendRequest} 
              disabled={sendingRequest || !searchEmail.trim()}
            >
              <UserPlus className="w-4 h-4 mr-2" />
              {sendingRequest ? 'Sending...' : 'Send'}
            </Button>
          </div>
        </div>

        {/* Pending Requests */}
        {pendingRequests.length > 0 && (
          <div className="space-y-3">
            <h3 className="font-semibold text-sm text-muted-foreground">
              Pending Requests ({pendingRequests.length})
            </h3>
            {pendingRequests.map((buddy) => (
              <div
                key={buddy.id}
                className="flex items-center justify-between p-3 rounded-lg border bg-yellow-500/5 border-yellow-500/20"
              >
                <div className="flex items-center gap-3">
                  <Avatar>
                    <AvatarImage src={buddy.buddy_avatar} />
                    <AvatarFallback>{getInitials(buddy.buddy_name)}</AvatarFallback>
                  </Avatar>
                  <div>
                    <div className="font-medium">{buddy.buddy_name || 'Unknown User'}</div>
                    <div className="text-sm text-muted-foreground">
                      {buddy.buddy_email}
                    </div>
                  </div>
                </div>
                <div className="flex gap-2">
                  <Button
                    size="sm"
                    variant="outline"
                    onClick={() => handleAccept(buddy.id)}
                  >
                    <Check className="w-4 h-4" />
                  </Button>
                  <Button
                    size="sm"
                    variant="outline"
                    onClick={() => handleReject(buddy.id)}
                  >
                    <X className="w-4 h-4" />
                  </Button>
                </div>
              </div>
            ))}
          </div>
        )}

        {/* Active Buddies */}
        <div className="space-y-3">
          <h3 className="font-semibold text-sm text-muted-foreground">
            Active Buddies ({activeBuddies.length})
          </h3>
          
          {activeBuddies.length === 0 ? (
            <div className="text-center py-8 text-muted-foreground">
              <Users className="w-12 h-12 mx-auto mb-3 opacity-50" />
              <p>No study buddies yet</p>
              <p className="text-sm mt-2">
                Invite friends to keep each other accountable!
              </p>
            </div>
          ) : (
            activeBuddies.map((buddy) => (
              <div
                key={buddy.id}
                className="flex items-center justify-between p-4 rounded-lg border hover:border-primary/50 transition-colors"
              >
                <div className="flex items-center gap-3">
                  <Avatar>
                    <AvatarImage src={buddy.buddy_avatar} />
                    <AvatarFallback>{getInitials(buddy.buddy_name)}</AvatarFallback>
                  </Avatar>
                  <div className="flex-1">
                    <div className="flex items-center gap-2">
                      <span className="font-medium">{buddy.buddy_name || 'Unknown User'}</span>
                      {buddyRanks[buddy.buddy_id] && (
                        <RankBadge
                          rank={buddyRanks[buddy.buddy_id].current_rank}
                          size="small"
                          showTooltip={false}
                          animated={false}
                        />
                      )}
                    </div>
                    <div className="text-sm text-muted-foreground flex items-center gap-2">
                      {buddy.buddy_email}
                      {buddy.shared_plan_id && (
                        <Badge variant="outline" className="text-xs">
                          Shared Plan
                        </Badge>
                      )}
                    </div>
                  </div>
                </div>
                
                <div className="flex items-center gap-2">
                  {buddy.buddy_progress && (
                    <div className="text-right mr-2">
                      <div className="text-sm font-semibold text-primary">
                        {buddy.buddy_progress.items_completed || 0}
                      </div>
                      <div className="text-xs text-muted-foreground">
                        items done
                      </div>
                    </div>
                  )}
                  
                  <Button size="sm" variant="outline">
                    <MessageCircle className="w-4 h-4" />
                  </Button>
                </div>
              </div>
            ))
          )}
        </div>

        {/* Check-in Stats */}
        {activeBuddies.length > 0 && (
          <div className="pt-4 border-t">
            <div className="flex items-center justify-between text-sm">
              <span className="text-muted-foreground">Group Progress</span>
              <div className="flex items-center gap-2">
                <TrendingUp className="w-4 h-4 text-green-500" />
                <span className="font-semibold">
                  {activeBuddies.reduce((acc, b) => 
                    acc + (b.buddy_progress?.items_completed || 0), 0
                  )}
                </span>
                <span className="text-muted-foreground">total items</span>
              </div>
            </div>
          </div>
        )}
      </CardContent>
    </Card>
  );
}
