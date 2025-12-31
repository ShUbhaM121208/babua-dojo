import { supabase } from '@/integrations/supabase/client';

// ============================================
// TYPES
// ============================================

export interface StudyPlan {
  id: string;
  user_id: string;
  title: string;
  description: string;
  difficulty: 'beginner' | 'intermediate' | 'advanced' | 'mixed';
  estimated_days: number;
  is_template: boolean;
  template_id: string | null;
  created_by: 'user' | 'ai' | 'admin';
  target_topics: string[];
  target_companies: string[];
  problems_per_day: number;
  status: 'draft' | 'active' | 'paused' | 'completed' | 'archived';
  is_public: boolean;
  total_items: number;
  completed_items: number;
  progress_percentage: number;
  start_date: string | null;
  target_end_date: string | null;
  actual_end_date: string | null;
  created_at: string;
  updated_at: string;
  days_active?: number;
  days_remaining?: number;
}

export interface StudyPlanItem {
  id: string;
  plan_id: string;
  item_type: 'problem' | 'topic' | 'resource' | 'milestone';
  item_id: string;
  title: string;
  description: string;
  day_number: number;
  order_in_day: number;
  problem_difficulty?: 'easy' | 'medium' | 'hard';
  problem_tags?: string[];
  resource_url?: string;
  resource_type?: 'video' | 'article' | 'documentation';
  estimated_time_minutes?: number;
  is_optional: boolean;
  is_completed: boolean;
  completed_at: string | null;
  ai_recommended: boolean;
  recommendation_reason?: string;
  created_at: string;
}

export interface DailyProgress {
  id: string;
  user_id: string;
  plan_id: string;
  date: string;
  items_completed: number;
  time_spent_minutes: number;
  problems_solved: number;
  is_rest_day: boolean;
  streak_maintained: boolean;
  daily_notes: string;
  mood: 'productive' | 'struggling' | 'confident' | null;
  created_at: string;
}

export interface StudyRecommendation {
  id: string;
  user_id: string;
  recommendation_type: 'problem' | 'topic' | 'plan' | 'resource';
  item_id: string;
  title: string;
  description: string;
  reason: string;
  relevance_score: number;
  based_on: string[];
  is_dismissed: boolean;
  is_accepted: boolean;
  created_at: string;
  expires_at: string;
}

// ============================================
// STUDY PLANS
// ============================================

export async function getUserStudyPlans(userId: string): Promise<StudyPlan[]> {
  try {
    const { data, error } = await supabase
      .from('study_plans')
      .select('*')
      .eq('user_id', userId)
      .order('updated_at', { ascending: false });

    if (error) throw error;
    return data as StudyPlan[];
  } catch (error) {
    console.error('Error fetching study plans:', error);
    return [];
  }
}

export async function getActiveStudyPlans(userId: string): Promise<StudyPlan[]> {
  try {
    const { data, error } = await supabase
      .from('user_active_plans')
      .select('*')
      .eq('user_id', userId);

    if (error) throw error;
    return data as StudyPlan[];
  } catch (error) {
    console.error('Error fetching active plans:', error);
    return [];
  }
}

export async function getStudyPlan(planId: string): Promise<StudyPlan | null> {
  try {
    const { data, error } = await supabase
      .from('study_plans')
      .select('*')
      .eq('id', planId)
      .single();

    if (error) throw error;
    return data as StudyPlan;
  } catch (error) {
    console.error('Error fetching study plan:', error);
    return null;
  }
}

export async function createStudyPlan(
  userId: string,
  plan: Partial<StudyPlan>
): Promise<{ id: string | null; error: string | null }> {
  try {
    const { data, error } = await supabase
      .from('study_plans')
      .insert({
        user_id: userId,
        title: plan.title,
        description: plan.description,
        difficulty: plan.difficulty || 'mixed',
        estimated_days: plan.estimated_days || 30,
        target_topics: plan.target_topics || [],
        target_companies: plan.target_companies || [],
        problems_per_day: plan.problems_per_day || 3,
        status: plan.status || 'draft',
        start_date: plan.start_date,
        target_end_date: plan.target_end_date,
      })
      .select('id')
      .single();

    if (error) throw error;
    return { id: data.id, error: null };
  } catch (error: any) {
    console.error('Error creating study plan:', error);
    return { id: null, error: error.message };
  }
}

export async function updateStudyPlan(
  planId: string,
  updates: Partial<StudyPlan>
): Promise<boolean> {
  try {
    const { error } = await supabase
      .from('study_plans')
      .update({ ...updates, updated_at: new Date().toISOString() })
      .eq('id', planId);

    if (error) throw error;
    return true;
  } catch (error) {
    console.error('Error updating study plan:', error);
    return false;
  }
}

export async function deleteStudyPlan(planId: string): Promise<boolean> {
  try {
    const { error } = await supabase
      .from('study_plans')
      .delete()
      .eq('id', planId);

    if (error) throw error;
    return true;
  } catch (error) {
    console.error('Error deleting study plan:', error);
    return false;
  }
}

export async function startStudyPlan(planId: string): Promise<boolean> {
  try {
    const { error } = await supabase
      .from('study_plans')
      .update({
        status: 'active',
        start_date: new Date().toISOString().split('T')[0],
        updated_at: new Date().toISOString(),
      })
      .eq('id', planId);

    if (error) throw error;
    return true;
  } catch (error) {
    console.error('Error starting study plan:', error);
    return false;
  }
}

export async function getTemplateStudyPlans(): Promise<StudyPlan[]> {
  try {
    const { data, error } = await supabase
      .from('study_plans')
      .select('*')
      .eq('is_template', true)
      .eq('is_public', true)
      .order('created_at', { ascending: false });

    if (error) throw error;
    return data as StudyPlan[];
  } catch (error) {
    console.error('Error fetching template plans:', error);
    return [];
  }
}

export async function cloneStudyPlan(
  templateId: string,
  userId: string,
  customTitle?: string
): Promise<{ id: string | null; error: string | null }> {
  try {
    // Get template
    const template = await getStudyPlan(templateId);
    if (!template) {
      return { id: null, error: 'Template not found' };
    }

    // Create new plan from template
    const { data: newPlan, error: planError } = await supabase
      .from('study_plans')
      .insert({
        user_id: userId,
        title: customTitle || `${template.title} (My Copy)`,
        description: template.description,
        difficulty: template.difficulty,
        estimated_days: template.estimated_days,
        template_id: templateId,
        created_by: 'user',
        target_topics: template.target_topics,
        target_companies: template.target_companies,
        problems_per_day: template.problems_per_day,
        status: 'draft',
      })
      .select('id')
      .single();

    if (planError) throw planError;

    // Copy items
    const { data: items } = await supabase
      .from('study_plan_items')
      .select('*')
      .eq('plan_id', templateId);

    if (items && items.length > 0) {
      const newItems = items.map(item => ({
        plan_id: newPlan.id,
        item_type: item.item_type,
        item_id: item.item_id,
        title: item.title,
        description: item.description,
        day_number: item.day_number,
        order_in_day: item.order_in_day,
        problem_difficulty: item.problem_difficulty,
        problem_tags: item.problem_tags,
        resource_url: item.resource_url,
        resource_type: item.resource_type,
        estimated_time_minutes: item.estimated_time_minutes,
        is_optional: item.is_optional,
      }));

      await supabase.from('study_plan_items').insert(newItems);
    }

    return { id: newPlan.id, error: null };
  } catch (error: any) {
    console.error('Error cloning study plan:', error);
    return { id: null, error: error.message };
  }
}

// ============================================
// STUDY PLAN ITEMS
// ============================================

export async function getPlanItems(planId: string): Promise<StudyPlanItem[]> {
  try {
    const { data, error } = await supabase
      .from('study_plan_items')
      .select('*')
      .eq('plan_id', planId)
      .order('day_number')
      .order('order_in_day');

    if (error) throw error;
    return data as StudyPlanItem[];
  } catch (error) {
    console.error('Error fetching plan items:', error);
    return [];
  }
}

export async function getTodayTasks(
  userId: string,
  planId: string
): Promise<StudyPlanItem[]> {
  try {
    const { data, error } = await supabase.rpc('get_daily_tasks', {
      p_user_id: userId,
      p_plan_id: planId,
      p_date: new Date().toISOString().split('T')[0],
    });

    if (error) throw error;
    return data as StudyPlanItem[];
  } catch (error) {
    console.error('Error fetching today tasks:', error);
    return [];
  }
}

export async function addPlanItem(item: Partial<StudyPlanItem>): Promise<boolean> {
  try {
    const { error } = await supabase
      .from('study_plan_items')
      .insert(item);

    if (error) throw error;
    return true;
  } catch (error) {
    console.error('Error adding plan item:', error);
    return false;
  }
}

export async function updatePlanItem(
  itemId: string,
  updates: Partial<StudyPlanItem>
): Promise<boolean> {
  try {
    const { error } = await supabase
      .from('study_plan_items')
      .update(updates)
      .eq('id', itemId);

    if (error) throw error;
    return true;
  } catch (error) {
    console.error('Error updating plan item:', error);
    return false;
  }
}

export async function completePlanItem(itemId: string): Promise<boolean> {
  try {
    const { error } = await supabase
      .from('study_plan_items')
      .update({
        is_completed: true,
        completed_at: new Date().toISOString(),
      })
      .eq('id', itemId);

    if (error) throw error;
    return true;
  } catch (error) {
    console.error('Error completing plan item:', error);
    return false;
  }
}

export async function deletePlanItem(itemId: string): Promise<boolean> {
  try {
    const { error } = await supabase
      .from('study_plan_items')
      .delete()
      .eq('id', itemId);

    if (error) throw error;
    return true;
  } catch (error) {
    console.error('Error deleting plan item:', error);
    return false;
  }
}

// ============================================
// DAILY PROGRESS
// ============================================

export async function getDailyProgress(
  userId: string,
  planId: string,
  date?: string
): Promise<DailyProgress | null> {
  try {
    const targetDate = date || new Date().toISOString().split('T')[0];
    
    const { data, error } = await supabase
      .from('user_study_progress')
      .select('*')
      .eq('user_id', userId)
      .eq('plan_id', planId)
      .eq('date', targetDate)
      .single();

    if (error) {
      // Return null if no progress for this date
      if (error.code === 'PGRST116') return null;
      throw error;
    }
    
    return data as DailyProgress;
  } catch (error) {
    console.error('Error fetching daily progress:', error);
    return null;
  }
}

export async function recordDailyProgress(
  userId: string,
  planId: string,
  progress: Partial<DailyProgress>
): Promise<boolean> {
  try {
    const date = progress.date || new Date().toISOString().split('T')[0];
    
    const { error } = await supabase
      .from('user_study_progress')
      .upsert({
        user_id: userId,
        plan_id: planId,
        date,
        items_completed: progress.items_completed || 0,
        time_spent_minutes: progress.time_spent_minutes || 0,
        problems_solved: progress.problems_solved || 0,
        is_rest_day: progress.is_rest_day || false,
        streak_maintained: progress.streak_maintained !== false,
        daily_notes: progress.daily_notes || '',
        mood: progress.mood || null,
      });

    if (error) throw error;
    return true;
  } catch (error) {
    console.error('Error recording daily progress:', error);
    return false;
  }
}

export async function getProgressHistory(
  userId: string,
  planId: string,
  days: number = 30
): Promise<DailyProgress[]> {
  try {
    const startDate = new Date();
    startDate.setDate(startDate.getDate() - days);

    const { data, error } = await supabase
      .from('user_study_progress')
      .select('*')
      .eq('user_id', userId)
      .eq('plan_id', planId)
      .gte('date', startDate.toISOString().split('T')[0])
      .order('date', { ascending: false });

    if (error) throw error;
    return data as DailyProgress[];
  } catch (error) {
    console.error('Error fetching progress history:', error);
    return [];
  }
}

// ============================================
// AI RECOMMENDATIONS
// ============================================

export async function getStudyRecommendations(userId: string): Promise<StudyRecommendation[]> {
  try {
    const { data, error } = await supabase
      .from('study_recommendations')
      .select('*')
      .eq('user_id', userId)
      .eq('is_dismissed', false)
      .gt('expires_at', new Date().toISOString())
      .order('relevance_score', { ascending: false })
      .limit(10);

    if (error) throw error;
    return data as StudyRecommendation[];
  } catch (error) {
    console.error('Error fetching recommendations:', error);
    return [];
  }
}

export async function dismissRecommendation(recommendationId: string): Promise<boolean> {
  try {
    const { error } = await supabase
      .from('study_recommendations')
      .update({ is_dismissed: true })
      .eq('id', recommendationId);

    if (error) throw error;
    return true;
  } catch (error) {
    console.error('Error dismissing recommendation:', error);
    return false;
  }
}

export async function acceptRecommendation(recommendationId: string): Promise<boolean> {
  try {
    const { error } = await supabase
      .from('study_recommendations')
      .update({ is_accepted: true })
      .eq('id', recommendationId);

    if (error) throw error;
    return true;
  } catch (error) {
    console.error('Error accepting recommendation:', error);
    return false;
  }
}

// ============================================
// AI PLAN GENERATION
// ============================================

export async function generateAIPlan(
  userId: string,
  title: string,
  targetTopics: string[],
  difficulty: string,
  days: number
): Promise<{ id: string | null; error: string | null }> {
  try {
    const { data, error } = await supabase.rpc('generate_ai_study_plan', {
      p_user_id: userId,
      p_title: title,
      p_target_topics: targetTopics,
      p_difficulty: difficulty,
      p_days: days,
    });

    if (error) throw error;
    return { id: data, error: null };
  } catch (error: any) {
    console.error('Error generating AI plan:', error);
    return { id: null, error: error.message };
  }
}
