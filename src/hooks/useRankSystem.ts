import { useState, useEffect, useCallback } from 'react';
import { useAuth } from '@/contexts/AuthContext';
import { supabase } from '@/integrations/supabase/client';
import {
  getUserRank,
  updateUserRankFromXP,
  getUserTitles,
  equipTitle,
  getEquippedTitle,
  getRankHistory,
  UserRank,
  UserTitle,
  RankHistory,
} from '@/lib/rankService';
import { useToast } from '@/hooks/use-toast';
import { RankUpToast } from '@/components/profile/RankUpNotification';

interface UseRankSystemReturn {
  userRank: UserRank | null;
  userTitles: UserTitle[];
  equippedTitle: UserTitle | null;
  rankHistory: RankHistory[];
  loading: boolean;
  refreshRank: () => Promise<void>;
  handleEquipTitle: (titleId: string) => Promise<boolean>;
  showRankUpModal: boolean;
  rankUpData: { oldRank: string; newRank: string; newXP: number } | null;
  dismissRankUp: () => void;
}

export function useRankSystem(): UseRankSystemReturn {
  const { user } = useAuth();
  const { toast } = useToast();
  
  const [userRank, setUserRank] = useState<UserRank | null>(null);
  const [userTitles, setUserTitles] = useState<UserTitle[]>([]);
  const [equippedTitle, setEquippedTitle] = useState<UserTitle | null>(null);
  const [rankHistory, setRankHistory] = useState<RankHistory[]>([]);
  const [loading, setLoading] = useState(true);
  const [showRankUpModal, setShowRankUpModal] = useState(false);
  const [rankUpData, setRankUpData] = useState<{ oldRank: string; newRank: string; newXP: number } | null>(null);

  const fetchRankData = useCallback(async () => {
    if (!user) {
      setLoading(false);
      return;
    }

    try {
      setLoading(true);
      
      const [rank, titles, equipped, history] = await Promise.all([
        getUserRank(user.id),
        getUserTitles(user.id),
        getEquippedTitle(user.id),
        getRankHistory(user.id, 10),
      ]);

      // Initialize rank if it doesn't exist
      if (!rank) {
        const { data: profile } = await supabase
          .from('user_profiles')
          .select('total_xp')
          .eq('id', user.id)
          .single();
        
        const xp = profile?.total_xp || 0;
        await updateUserRankFromXP(user.id, xp);
        
        // Refetch after initialization
        const newRank = await getUserRank(user.id);
        setUserRank(newRank);
      } else {
        setUserRank(rank);
      }

      setUserTitles(titles);
      setEquippedTitle(equipped);
      setRankHistory(history);
    } catch (error) {
      console.error('Error fetching rank data:', error);
    } finally {
      setLoading(false);
    }
  }, [user]);

  useEffect(() => {
    fetchRankData();
  }, [fetchRankData]);

  const refreshRank = useCallback(async () => {
    await fetchRankData();
  }, [fetchRankData]);

  const handleEquipTitle = useCallback(async (titleId: string): Promise<boolean> => {
    if (!user) return false;

    const success = await equipTitle(user.id, titleId);
    
    if (success) {
      await fetchRankData();
      toast({
        title: 'Title Equipped',
        description: 'Your new title is now displayed on your profile.',
      });
    } else {
      toast({
        title: 'Error',
        description: 'Failed to equip title. Please try again.',
        variant: 'destructive',
      });
    }

    return success;
  }, [user, fetchRankData, toast]);

  // Listen for XP changes and check for rank ups
  useEffect(() => {
    if (!user || !userRank) return;

    const checkForRankUp = async (newXP: number) => {
      const oldRank = userRank.current_rank;
      const result = await updateUserRankFromXP(user.id, newXP);

      if (result.rankedUp && result.newRank) {
        setRankUpData({
          oldRank,
          newRank: result.newRank,
          newXP,
        });
        setShowRankUpModal(true);

        // Also show a toast
        toast({
          title: 'Rank Up!',
          description: `You're now ${result.newRank}`,
          duration: 5000,
        });

        // Refresh rank data
        await fetchRankData();
      }
    };

    // Subscribe to user_profiles changes
    const channel = supabase
      .channel('rank-updates')
      .on(
        'postgres_changes',
        {
          event: 'UPDATE',
          schema: 'public',
          table: 'user_profiles',
          filter: `id=eq.${user.id}`,
        },
        (payload: any) => {
          const newXP = payload.new?.total_xp;
          if (newXP !== undefined && newXP !== userRank.rank_xp) {
            checkForRankUp(newXP);
          }
        }
      )
      .subscribe();

    return () => {
      channel?.unsubscribe();
    };
  }, [user, userRank, toast, fetchRankData]);

  const dismissRankUp = useCallback(() => {
    setShowRankUpModal(false);
    setRankUpData(null);
  }, []);

  return {
    userRank,
    userTitles,
    equippedTitle,
    rankHistory,
    loading,
    refreshRank,
    handleEquipTitle,
    showRankUpModal,
    rankUpData,
    dismissRankUp,
  };
}
