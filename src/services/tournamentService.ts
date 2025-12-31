import { supabase } from '@/integrations/supabase/client';

export interface Tournament {
  id: string;
  name: string;
  description: string | null;
  start_time: string;
  end_time: string;
  problem_ids: string[] | null;
  max_participants: number | null;
  prize_pool: number | null;
  entry_fee: number;
  min_rank_required: string | null;
  difficulty?: 'easy' | 'medium' | 'hard' | 'expert';
  is_rated?: boolean;
  status: 'upcoming' | 'live' | 'completed' | 'cancelled';
  banner_url: string | null;
  rules: string | null;
  created_by: string | null;
  created_at: string;
  updated_at: string;
}

export interface TournamentRegistration {
  id: string;
  tournament_id: string;
  user_id: string;
  registered_at: string;
  status: 'registered' | 'checked_in' | 'disqualified' | 'withdrawn';
}

export interface TournamentSubmission {
  id: string;
  tournament_id: string;
  user_id: string;
  problem_id: string;
  submission_id: string | null;
  language: string;
  code: string;
  status: 'accepted' | 'wrong_answer' | 'runtime_error' | 'compile_error' | 'time_limit_exceeded' | 'memory_limit_exceeded';
  test_results: any[];
  passed_count: number;
  failed_count: number;
  total_test_cases: number;
  total_time: number;
  penalty_time: number;
  submitted_at: string;
}

export interface LeaderboardEntry {
  id: string;
  tournament_id: string;
  user_id: string;
  rank: number;
  score: number;
  total_time: number;
  penalty_time: number;
  last_submission_at: string | null;
  problems_solved: string[];
  updated_at: string;
  username?: string;
  avatar_url?: string;
}

export interface TournamentPrize {
  id: string;
  tournament_id: string;
  rank_from: number;
  rank_to: number;
  prize_type: 'xp' | 'badge' | 'title' | 'certificate' | 'cash';
  prize_value: string;
  prize_description: string | null;
}

export interface TournamentEditorial {
  id: string;
  tournament_id: string;
  problem_id: string;
  author_id: string | null;
  title: string;
  content: string;
  video_url: string | null;
  code_examples: any[];
  published_at: string;
}

class TournamentService {
  /**
   * Get all tournaments with optional status filter
   */
  async getTournaments(status?: Tournament['status']): Promise<Tournament[]> {
    try {
      let query = supabase
        .from('tournaments')
        .select('*')
        .order('start_time', { ascending: false });

      if (status) {
        query = query.eq('status', status);
      }

      const { data, error } = await query;
      
      // If Supabase fails, use localStorage
      if (error) {
        console.log("Supabase error, loading from localStorage:", error);
        const localTournaments = JSON.parse(localStorage.getItem('tournaments') || '[]');
        console.log("Tournaments from localStorage:", localTournaments);
        if (status) {
          const filtered = localTournaments.filter((t: Tournament) => t.status === status);
          console.log(`Filtered tournaments with status '${status}':`, filtered);
          return filtered;
        }
        return localTournaments;
      }
      
      console.log("Tournaments from Supabase:", data);
      return data || [];
    } catch (error) {
      console.error('Error fetching tournaments:', error);
      // Fallback to localStorage
      const localTournaments = JSON.parse(localStorage.getItem('tournaments') || '[]');
      console.log("Fallback: Tournaments from localStorage:", localTournaments);
      if (status) {
        return localTournaments.filter((t: Tournament) => t.status === status);
      }
      return localTournaments;
    }
  }

  /**
   * Get a single tournament by ID
   */
  async getTournament(tournamentId: string): Promise<Tournament | null> {
    try {
      const { data, error } = await supabase
        .from('tournaments')
        .select('*')
        .eq('id', tournamentId)
        .single();

      // If Supabase fails, use localStorage
      if (error) {
        const localTournaments = JSON.parse(localStorage.getItem('tournaments') || '[]');
        return localTournaments.find((t: Tournament) => t.id === tournamentId) || null;
      }
      
      return data;
    } catch (error) {
      console.error('Error fetching tournament:', error);
      // Fallback to localStorage
      const localTournaments = JSON.parse(localStorage.getItem('tournaments') || '[]');
      return localTournaments.find((t: Tournament) => t.id === tournamentId) || null;
    }
  }

  /**
   * Register for a tournament
   */
  async registerForTournament(tournamentId: string): Promise<{
    success: boolean;
    message: string;
  }> {
    try {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) return { success: false, message: 'User not authenticated' };

      // Check if already registered
      const { data: existing } = await supabase
        .from('tournament_registrations')
        .select('id')
        .eq('tournament_id', tournamentId)
        .eq('user_id', user.id)
        .single();

      if (existing) {
        return { success: false, message: 'Already registered for this tournament' };
      }

      // Register
      const { error } = await supabase
        .from('tournament_registrations')
        .insert({
          tournament_id: tournamentId,
          user_id: user.id,
          status: 'registered',
        });

      if (error) throw error;
      return { success: true, message: 'Successfully registered!' };
    } catch (error) {
      console.error('Error registering for tournament:', error);
      return { success: false, message: 'Failed to register' };
    }
  }

  /**
   * Withdraw from a tournament
   */
  async withdrawFromTournament(tournamentId: string): Promise<boolean> {
    try {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) return false;

      const { error } = await supabase
        .from('tournament_registrations')
        .update({ status: 'withdrawn' })
        .eq('tournament_id', tournamentId)
        .eq('user_id', user.id);

      if (error) throw error;
      return true;
    } catch (error) {
      console.error('Error withdrawing from tournament:', error);
      return false;
    }
  }

  /**
   * Check if user is registered for a tournament
   */
  async isRegistered(tournamentId: string): Promise<boolean> {
    try {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) return false;

      const { data, error } = await supabase
        .from('tournament_registrations')
        .select('id')
        .eq('tournament_id', tournamentId)
        .eq('user_id', user.id)
        .in('status', ['registered', 'checked_in'])
        .single();

      if (error && error.code !== 'PGRST116') throw error;
      return !!data;
    } catch (error) {
      console.error('Error checking registration:', error);
      return false;
    }
  }

  /**
   * Get participant count for a tournament
   */
  async getParticipantCount(tournamentId: string): Promise<number> {
    try {
      const { count, error } = await supabase
        .from('tournament_registrations')
        .select('*', { count: 'exact', head: true })
        .eq('tournament_id', tournamentId)
        .in('status', ['registered', 'checked_in']);

      if (error) throw error;
      return count || 0;
    } catch (error) {
      console.error('Error getting participant count:', error);
      return 0;
    }
  }

  /**
   * Get tournament leaderboard
   */
  async getLeaderboard(tournamentId: string): Promise<LeaderboardEntry[]> {
    try {
      const { data, error } = await supabase
        .from('tournament_leaderboard')
        .select(`
          *,
          user:user_id (
            full_name,
            email
          )
        `)
        .eq('tournament_id', tournamentId)
        .order('rank', { ascending: true });

      if (error) throw error;
      return (data || []).map(entry => ({
        ...entry,
        user: Array.isArray(entry.user) ? entry.user[0] : entry.user
      }));
    } catch (error) {
      console.error('Error fetching leaderboard:', error);
      return [];
    }
  }

  /**
   * Get user's rank in a tournament
   */
  async getUserRank(tournamentId: string): Promise<LeaderboardEntry | null> {
    try {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) return null;

      const { data, error } = await supabase
        .from('tournament_leaderboard')
        .select(`
          *,
          user:user_id (
            full_name,
            email
          )
        `)
        .eq('tournament_id', tournamentId)
        .eq('user_id', user.id)
        .single();

      if (error && error.code !== 'PGRST116') throw error;
      if (!data) return null;

      return {
        ...data,
        user: Array.isArray(data.user) ? data.user[0] : data.user
      };
    } catch (error) {
      console.error('Error fetching user rank:', error);
      return null;
    }
  }

  /**
   * Get user's submissions for a tournament
   */
  async getUserSubmissions(tournamentId: string): Promise<TournamentSubmission[]> {
    try {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) return [];

      const { data, error } = await supabase
        .from('tournament_submissions')
        .select('*')
        .eq('tournament_id', tournamentId)
        .eq('user_id', user.id)
        .order('submitted_at', { ascending: false });

      if (error) throw error;
      return data || [];
    } catch (error) {
      console.error('Error fetching user submissions:', error);
      return [];
    }
  }

  /**
   * Get prizes for a tournament
   */
  async getPrizes(tournamentId: string): Promise<TournamentPrize[]> {
    try {
      const { data, error } = await supabase
        .from('tournament_prizes')
        .select('*')
        .eq('tournament_id', tournamentId)
        .order('rank_from', { ascending: true });

      if (error) throw error;
      return data || [];
    } catch (error) {
      console.error('Error fetching prizes:', error);
      return [];
    }
  }

  /**
   * Get editorials for a tournament
   */
  async getEditorials(tournamentId: string): Promise<TournamentEditorial[]> {
    try {
      const { data, error } = await supabase
        .from('tournament_editorials')
        .select('*')
        .eq('tournament_id', tournamentId)
        .order('published_at', { ascending: false });

      if (error) throw error;
      return data || [];
    } catch (error) {
      console.error('Error fetching editorials:', error);
      return [];
    }
  }

  /**
   * Manually update tournament status (for testing)
   */
  async updateTournamentStatus(): Promise<void> {
    try {
      await supabase.rpc('update_tournament_status');
    } catch (error) {
      console.error('Error updating tournament status:', error);
    }
  }

  /**
   * Get time remaining until tournament starts
   */
  getTimeUntilStart(tournament: Tournament): {
    days: number;
    hours: number;
    minutes: number;
    seconds: number;
    total: number;
  } {
    const now = new Date().getTime();
    const start = new Date(tournament.start_time).getTime();
    const diff = Math.max(0, start - now);

    return {
      total: diff,
      days: Math.floor(diff / (1000 * 60 * 60 * 24)),
      hours: Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60)),
      minutes: Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60)),
      seconds: Math.floor((diff % (1000 * 60)) / 1000),
    };
  }

  /**
   * Get time remaining until tournament ends
   */
  getTimeUntilEnd(tournament: Tournament): {
    days: number;
    hours: number;
    minutes: number;
    seconds: number;
    total: number;
  } {
    const now = new Date().getTime();
    const end = new Date(tournament.end_time).getTime();
    const diff = Math.max(0, end - now);

    return {
      total: diff,
      days: Math.floor(diff / (1000 * 60 * 60 * 24)),
      hours: Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60)),
      minutes: Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60)),
      seconds: Math.floor((diff % (1000 * 60)) / 1000),
    };
  }

  /**
   * Check if tournament is currently active
   */
  isActive(tournament: Tournament): boolean {
    const now = new Date().getTime();
    const start = new Date(tournament.start_time).getTime();
    const end = new Date(tournament.end_time).getTime();
    return now >= start && now <= end;
  }

  /**
   * Get upcoming tournaments (next 30 days)
   */
  async getUpcomingTournaments(): Promise<Tournament[]> {
    try {
      const now = new Date().toISOString();
      const thirtyDaysLater = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString();

      const { data, error } = await supabase
        .from('tournaments')
        .select('*')
        .eq('status', 'upcoming')
        .gte('start_time', now)
        .lte('start_time', thirtyDaysLater)
        .order('start_time', { ascending: true });

      if (error) throw error;
      return data || [];
    } catch (error) {
      console.error('Error fetching upcoming tournaments:', error);
      return [];
    }
  }
}

export const tournamentService = new TournamentService();
