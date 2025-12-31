import { supabase } from '@/integrations/supabase/client';

// ============================================================================
// Types
// ============================================================================

export interface TopicPerformance {
  topic: string;
  success_rate: number;
  problems_attempted: number;
  problems_solved: number;
  average_time: number;
  difficulty_recommendation: 'easy' | 'medium' | 'hard';
}

export interface Recommendation {
  recommendation_id: string;
  problem_id: string;
  problem_title: string;
  problem_difficulty: 'easy' | 'medium' | 'hard';
  topic: string;
  reason: string;
  priority: number;
  estimated_time_minutes: number;
  score: number;
}

export interface RecommendationPreferences {
  user_id?: string;
  preferred_difficulty: 'easy' | 'medium' | 'hard' | 'mixed';
  avoid_topics: string[];
  focus_topics: string[];
  prefer_new_topics: boolean;
  challenge_level: number; // 1-5
  problems_per_day: number;
  max_time_per_problem: number; // minutes
  study_time_of_day?: 'morning' | 'afternoon' | 'evening' | 'night';
}

// ============================================================================
// Topic Performance Tracking
// ============================================================================

/**
 * Updates topic performance when a user attempts/solves a problem
 * This should be called after every problem submission
 */
export async function updateTopicPerformance(
  userId: string,
  problemId: string,
  solved: boolean,
  timeSpent: number, // in seconds
  difficulty: 'easy' | 'medium' | 'hard'
): Promise<{ success: boolean; error?: string }> {
  try {
    const { error } = await supabase.rpc('update_topic_performance', {
      p_user_id: userId,
      p_problem_id: problemId,
      p_solved: solved,
      p_time_spent: timeSpent,
      p_difficulty: difficulty,
    });

    if (error) throw error;

    return { success: true };
  } catch (error) {
    console.error('Error updating topic performance:', error);
    return {
      success: false,
      error: error instanceof Error ? error.message : 'Unknown error',
    };
  }
}

/**
 * Gets user's weak topics that need improvement
 */
export async function getWeakTopics(
  userId: string,
  limit: number = 5
): Promise<{ data: TopicPerformance[] | null; error?: string }> {
  try {
    const { data, error } = await supabase.rpc('get_weak_topics', {
      p_user_id: userId,
      p_limit: limit,
    });

    if (error) throw error;

    return { data: data || [] };
  } catch (error) {
    console.error('Error fetching weak topics:', error);
    return {
      data: null,
      error: error instanceof Error ? error.message : 'Unknown error',
    };
  }
}

/**
 * Gets all topic performance data for a user
 */
export async function getAllTopicPerformance(
  userId: string
): Promise<{ data: any[] | null; error?: string }> {
  try {
    const { data, error } = await supabase
      .from('user_topic_performance')
      .select('*')
      .eq('user_id', userId)
      .order('success_rate', { ascending: true });

    if (error) throw error;

    return { data: data || [] };
  } catch (error) {
    console.error('Error fetching all topic performance:', error);
    return {
      data: null,
      error: error instanceof Error ? error.message : 'Unknown error',
    };
  }
}

// ============================================================================
// Recommendations
// ============================================================================

/**
 * Gets personalized problem recommendations for a user
 */
export async function getUserRecommendations(
  userId: string,
  refresh: boolean = false
): Promise<{ data: Recommendation[] | null; error?: string }> {
  try {
    const { data, error } = await supabase.rpc('get_user_recommendations', {
      p_user_id: userId,
      p_refresh: refresh,
    });

    if (error) throw error;

    return { data: data || [] };
  } catch (error) {
    console.error('Error fetching recommendations:', error);
    return {
      data: null,
      error: error instanceof Error ? error.message : 'Unknown error',
    };
  }
}

/**
 * Manually generates new recommendations
 */
export async function generateRecommendations(
  userId: string,
  count: number = 5
): Promise<{ success: boolean; error?: string }> {
  try {
    const { error } = await supabase.rpc('generate_recommendations', {
      p_user_id: userId,
      p_count: count,
    });

    if (error) throw error;

    return { success: true };
  } catch (error) {
    console.error('Error generating recommendations:', error);
    return {
      success: false,
      error: error instanceof Error ? error.message : 'Unknown error',
    };
  }
}

/**
 * Tracks user interaction with a recommendation
 */
export async function trackRecommendationInteraction(
  recommendationId: string,
  action: 'shown' | 'clicked' | 'dismissed' | 'completed'
): Promise<{ success: boolean; error?: string }> {
  try {
    const { error } = await supabase.rpc('track_recommendation_interaction', {
      p_recommendation_id: recommendationId,
      p_action: action,
    });

    if (error) throw error;

    return { success: true };
  } catch (error) {
    console.error('Error tracking recommendation interaction:', error);
    return {
      success: false,
      error: error instanceof Error ? error.message : 'Unknown error',
    };
  }
}

// ============================================================================
// User Preferences
// ============================================================================

/**
 * Gets user's recommendation preferences
 */
export async function getRecommendationPreferences(
  userId: string
): Promise<{ data: RecommendationPreferences | null; error?: string }> {
  try {
    const { data, error } = await supabase
      .from('recommendation_preferences')
      .select('*')
      .eq('user_id', userId)
      .single();

    if (error && error.code !== 'PGRST116') throw error; // PGRST116 = no rows

    return { data: data || null };
  } catch (error) {
    console.error('Error fetching recommendation preferences:', error);
    return {
      data: null,
      error: error instanceof Error ? error.message : 'Unknown error',
    };
  }
}

/**
 * Updates user's recommendation preferences
 */
export async function updateRecommendationPreferences(
  userId: string,
  preferences: Partial<RecommendationPreferences>
): Promise<{ success: boolean; error?: string }> {
  try {
    const { error } = await supabase
      .from('recommendation_preferences')
      .upsert(
        {
          user_id: userId,
          ...preferences,
          updated_at: new Date().toISOString(),
        },
        { onConflict: 'user_id' }
      );

    if (error) throw error;

    return { success: true };
  } catch (error) {
    console.error('Error updating recommendation preferences:', error);
    return {
      success: false,
      error: error instanceof Error ? error.message : 'Unknown error',
    };
  }
}

// ============================================================================
// Analytics & Insights
// ============================================================================

/**
 * Gets learning insights based on topic performance
 */
export async function getLearningInsights(userId: string): Promise<{
  data: {
    strongestTopics: TopicPerformance[];
    weakestTopics: TopicPerformance[];
    improvingTopics: TopicPerformance[];
    decliningTopics: TopicPerformance[];
    totalTopicsLearned: number;
    averageSuccessRate: number;
  } | null;
  error?: string;
}> {
  try {
    const { data: allPerformance, error: perfError } = await supabase
      .from('user_topic_performance')
      .select('*')
      .eq('user_id', userId)
      .gte('problems_attempted', 3); // Minimum for meaningful data

    if (perfError) throw perfError;

    if (!allPerformance || allPerformance.length === 0) {
      return {
        data: {
          strongestTopics: [],
          weakestTopics: [],
          improvingTopics: [],
          decliningTopics: [],
          totalTopicsLearned: 0,
          averageSuccessRate: 0,
        },
      };
    }

    // Sort and categorize topics
    const sortedBySuccess = [...allPerformance].sort(
      (a, b) => b.success_rate - a.success_rate
    );
    const sortedByTrend = [...allPerformance].sort(
      (a, b) => (b.improvement_trend || 0) - (a.improvement_trend || 0)
    );

    const strongestTopics = sortedBySuccess.slice(0, 5).map((t) => ({
      topic: t.topic,
      success_rate: t.success_rate,
      problems_attempted: t.problems_attempted,
      problems_solved: t.problems_solved,
      average_time: t.average_time_per_problem,
      difficulty_recommendation:
        t.success_rate >= 80 ? 'hard' : t.success_rate >= 50 ? 'medium' : 'easy',
    }));

    const weakestTopics = sortedBySuccess
      .slice(-5)
      .reverse()
      .map((t) => ({
        topic: t.topic,
        success_rate: t.success_rate,
        problems_attempted: t.problems_attempted,
        problems_solved: t.problems_solved,
        average_time: t.average_time_per_problem,
        difficulty_recommendation:
          t.success_rate >= 80 ? 'hard' : t.success_rate >= 50 ? 'medium' : 'easy',
      }));

    const improvingTopics = sortedByTrend
      .filter((t) => (t.improvement_trend || 0) > 0)
      .slice(0, 5)
      .map((t) => ({
        topic: t.topic,
        success_rate: t.success_rate,
        problems_attempted: t.problems_attempted,
        problems_solved: t.problems_solved,
        average_time: t.average_time_per_problem,
        difficulty_recommendation:
          t.success_rate >= 80 ? 'hard' : t.success_rate >= 50 ? 'medium' : 'easy',
      }));

    const decliningTopics = sortedByTrend
      .filter((t) => (t.improvement_trend || 0) < 0)
      .slice(-5)
      .reverse()
      .map((t) => ({
        topic: t.topic,
        success_rate: t.success_rate,
        problems_attempted: t.problems_attempted,
        problems_solved: t.problems_solved,
        average_time: t.average_time_per_problem,
        difficulty_recommendation:
          t.success_rate >= 80 ? 'hard' : t.success_rate >= 50 ? 'medium' : 'easy',
      }));

    const averageSuccessRate =
      allPerformance.reduce((sum, t) => sum + t.success_rate, 0) /
      allPerformance.length;

    return {
      data: {
        strongestTopics,
        weakestTopics,
        improvingTopics,
        decliningTopics,
        totalTopicsLearned: allPerformance.length,
        averageSuccessRate: Math.round(averageSuccessRate * 100) / 100,
      },
    };
  } catch (error) {
    console.error('Error fetching learning insights:', error);
    return {
      data: null,
      error: error instanceof Error ? error.message : 'Unknown error',
    };
  }
}

/**
 * Gets recommended difficulty level for a specific topic based on user's performance
 */
export async function getRecommendedDifficulty(
  userId: string,
  topic: string
): Promise<{ difficulty: 'easy' | 'medium' | 'hard'; confidence: number }> {
  try {
    const { data, error } = await supabase
      .from('user_topic_performance')
      .select('success_rate, problems_attempted')
      .eq('user_id', userId)
      .eq('topic', topic)
      .single();

    if (error || !data) {
      // No data, start with easy
      return { difficulty: 'easy', confidence: 0 };
    }

    const { success_rate, problems_attempted } = data;

    // Confidence increases with more attempts
    const confidence = Math.min(problems_attempted / 10, 1);

    let difficulty: 'easy' | 'medium' | 'hard';
    if (success_rate >= 80) {
      difficulty = 'hard';
    } else if (success_rate >= 50) {
      difficulty = 'medium';
    } else {
      difficulty = 'easy';
    }

    return { difficulty, confidence };
  } catch (error) {
    console.error('Error getting recommended difficulty:', error);
    return { difficulty: 'medium', confidence: 0 };
  }
}
