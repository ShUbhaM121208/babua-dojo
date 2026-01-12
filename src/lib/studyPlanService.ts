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

// ============================================
// STUDY PLAN PROGRESS TRACKING
// ============================================

/**
 * Update study plan progress when a problem is solved
 * This checks all active study plans and marks matching items as completed
 */
export async function updateStudyPlanProgress(
  userId: string,
  problemId: string,
  problemSlug?: string
): Promise<void> {
  try {
    // Get all active study plans for the user
    const { data: activePlans } = await supabase
      .from('study_plans')
      .select('id')
      .eq('user_id', userId)
      .eq('status', 'active');

    if (!activePlans || activePlans.length === 0) {
      console.log('No active study plans found');
      return;
    }

    const planIds = activePlans.map(p => p.id);

    // Build a flexible query to match by ID, slug, or title
    // Get all problem items from active plans
    const { data: allItems } = await supabase
      .from('study_plan_items')
      .select('*')
      .in('plan_id', planIds)
      .eq('item_type', 'problem')
      .eq('is_completed', false);

    if (!allItems || allItems.length === 0) {
      console.log('No incomplete problem items in active plans');
      return;
    }

    // Match items by comparing item_id with problemId, slug, or checking if title matches
    const matchingItems = allItems.filter(item => {
      if (!item.item_id) return false;
      
      const itemIdLower = item.item_id.toLowerCase().trim();
      const problemIdStr = String(problemId).toLowerCase().trim();
      const slugLower = problemSlug?.toLowerCase().trim();
      
      // Direct ID match
      if (itemIdLower === problemIdStr) return true;
      
      // Slug match
      if (slugLower && itemIdLower === slugLower) return true;
      
      // Title-to-slug conversion match (e.g., "Two Sum" -> "two-sum")
      const titleSlug = item.title?.toLowerCase().replace(/\s+/g, '-').replace(/[^\w-]/g, '');
      if (titleSlug && (titleSlug === problemIdStr || titleSlug === slugLower)) return true;
      
      return false;
    });

    if (matchingItems.length === 0) {
      console.log(`No matching items found for problem ${problemId} (slug: ${problemSlug})`);
      return;
    }

    // Mark items as completed
    const itemIds = matchingItems.map(item => item.id);
    await supabase
      .from('study_plan_items')
      .update({
        is_completed: true,
        completed_at: new Date().toISOString()
      })
      .in('id', itemIds);

    // Update each affected plan's progress
    for (const item of matchingItems) {
      await recalculatePlanProgress(item.plan_id);
    }

    console.log(`✓ Updated ${matchingItems.length} study plan items for problem ${problemId}`);
  } catch (error) {
    console.error('Error updating study plan progress:', error);
  }
}

/**
 * Recalculate and update a study plan's progress percentage
 */
async function recalculatePlanProgress(planId: string): Promise<void> {
  try {
    // Get all items and count completed
    const { data: items } = await supabase
      .from('study_plan_items')
      .select('id, is_completed')
      .eq('plan_id', planId);

    if (!items || items.length === 0) return;

    const totalItems = items.length;
    const completedItems = items.filter(item => item.is_completed).length;
    const progressPercentage = Math.round((completedItems / totalItems) * 100);

    // Update the plan
    await supabase
      .from('study_plans')
      .update({
        total_items: totalItems,
        completed_items: completedItems,
        progress_percentage: progressPercentage,
        updated_at: new Date().toISOString()
      })
      .eq('id', planId);

  } catch (error) {
    console.error('Error recalculating plan progress:', error);
  }
}

/**
 * Populate a study plan with problems based on its target topics
 */
export async function populateStudyPlanItems(
  planId: string,
  targetTopics: string[],
  problemsPerDay: number = 3
): Promise<boolean> {
  try {
    // Import problem data
    const { detailedProblems } = await import('@/data/mockData');
    
    // Get problems that match the target topics
    const allProblems = Object.values(detailedProblems).filter(p => p.track === 'DSA');
    const matchingProblems = allProblems.filter(problem => 
      problem.tags?.some(tag => 
        targetTopics.some(topic => 
          tag.toLowerCase().includes(topic.toLowerCase()) ||
          topic.toLowerCase().includes(tag.toLowerCase())
        )
      )
    );

    if (matchingProblems.length === 0) {
      console.warn('No matching problems found for topics:', targetTopics);
      return false;
    }

    // Sort by difficulty (easy -> medium -> hard)
    const difficultyOrder = { easy: 1, medium: 2, hard: 3 };
    matchingProblems.sort((a, b) => 
      (difficultyOrder[a.difficulty] || 2) - (difficultyOrder[b.difficulty] || 2)
    );

    // Create study plan items
    const items = matchingProblems.map((problem, index) => ({
      plan_id: planId,
      item_type: 'problem',
      item_id: problem.slug || String(problem.id),
      title: problem.title,
      description: problem.description?.substring(0, 200) || '',
      day_number: Math.floor(index / problemsPerDay) + 1,
      order_in_day: (index % problemsPerDay) + 1,
      problem_difficulty: problem.difficulty,
      problem_tags: problem.tags || [],
      is_optional: false,
      is_completed: false,
      estimated_time_minutes: problem.difficulty === 'easy' ? 20 : problem.difficulty === 'medium' ? 35 : 50
    }));

    // Insert items
    const { error } = await supabase
      .from('study_plan_items')
      .insert(items);

    if (error) throw error;

    // Update plan totals
    await supabase
      .from('study_plans')
      .update({
        total_items: items.length,
        completed_items: 0,
        progress_percentage: 0,
        updated_at: new Date().toISOString()
      })
      .eq('id', planId);

    console.log(`✓ Created ${items.length} items for study plan`);
    return true;
  } catch (error) {
    console.error('Error populating study plan items:', error);
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
  planId?: string
): Promise<StudyPlanItem[]> {
  try {
    // If planId is provided, get tasks for that specific plan
    if (planId) {
      const { data, error } = await supabase.rpc('get_daily_tasks', {
        p_user_id: userId,
        p_plan_id: planId,
        p_date: new Date().toISOString().split('T')[0],
      });

      if (error) throw error;
      return data as StudyPlanItem[];
    }

    // Otherwise, get tasks from all active plans
    const activePlans = await getActiveStudyPlans(userId);
    
    if (activePlans.length === 0) {
      return [];
    }

    // Get the current day number for each active plan
    const allTasks: StudyPlanItem[] = [];
    
    for (const plan of activePlans) {
      if (!plan.start_date) continue;
      
      const startDate = new Date(plan.start_date);
      const today = new Date();
      const daysDiff = Math.floor((today.getTime() - startDate.getTime()) / (1000 * 60 * 60 * 24));
      const currentDay = daysDiff + 1; // Day 1 is the start date
      
      if (currentDay > 0 && currentDay <= plan.estimated_days) {
        const { data: items } = await supabase
          .from('study_plan_items')
          .select('*')
          .eq('plan_id', plan.id)
          .eq('day_number', currentDay)
          .order('order_in_day');
        
        if (items) {
          allTasks.push(...items);
        }
      }
    }
    
    return allTasks;
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
  startDate?: string,
  endDate?: string
): Promise<DailyProgress | DailyProgress[]> {
  try {
    // If date range provided, return array
    if (startDate && endDate) {
      const { data, error } = await supabase
        .from('user_study_progress')
        .select('*')
        .eq('user_id', userId)
        .eq('plan_id', planId)
        .gte('date', startDate)
        .lte('date', endDate)
        .order('date', { ascending: true });

      if (error) throw error;
      return (data || []) as DailyProgress[];
    }
    
    // Single date query
    const targetDate = startDate || new Date().toISOString().split('T')[0];
    
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
    return startDate && endDate ? [] : null;
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

// ============================================
// ADDITIONAL HELPER FUNCTIONS
// ============================================

export async function getStudyPlanItems(planId: string): Promise<StudyPlanItem[]> {
  return getPlanItems(planId);
}

export async function completeStudyItem(itemId: string, completed: boolean): Promise<boolean> {
  try {
    const { error } = await supabase
      .from('study_plan_items')
      .update({
        is_completed: completed,
        completed_at: completed ? new Date().toISOString() : null,
      })
      .eq('id', itemId);

    if (error) throw error;
    return true;
  } catch (error) {
    console.error('Error updating item completion:', error);
    return false;
  }
}

export async function getTodayProgress(
  userId: string,
  planId: string,
  date: string
): Promise<DailyProgress | null> {
  return getDailyProgress(userId, planId, date);
}

export async function updateDailyProgress(
  userId: string,
  planId: string,
  date: string,
  updates: Partial<DailyProgress>
): Promise<boolean> {
  try {
    const { error } = await supabase
      .from('user_study_progress')
      .upsert({
        user_id: userId,
        plan_id: planId,
        date,
        ...updates,
      });

    if (error) throw error;
    return true;
  } catch (error) {
    console.error('Error updating daily progress:', error);
    return false;
  }
}

// ============================================
// STUDY BUDDIES
// ============================================

export interface StudyBuddy {
  id: string;
  user_id: string;
  buddy_user_id: string;
  status: 'pending' | 'active' | 'inactive';
  shared_plan_id: string | null;
  check_in_frequency: string;
  created_at: string;
  buddy_name?: string;
  buddy_email?: string;
  buddy_avatar?: string;
  buddy_progress?: {
    items_completed: number;
    streak: number;
  };
}

export async function getStudyBuddies(userId: string): Promise<StudyBuddy[]> {
  try {
    const { data, error } = await supabase
      .from('study_buddies')
      .select(`
        *,
        buddy:buddy_user_id (
          id,
          email,
          raw_user_meta_data
        )
      `)
      .eq('user_id', userId)
      .order('created_at', { ascending: false });

    if (error) throw error;
    
    // Transform data to include buddy info
    return (data || []).map((item: any) => ({
      ...item,
      buddy_name: item.buddy?.raw_user_meta_data?.name || 'Unknown User',
      buddy_email: item.buddy?.email,
      buddy_avatar: item.buddy?.raw_user_meta_data?.avatar_url,
    })) as StudyBuddy[];
  } catch (error) {
    console.error('Error fetching study buddies:', error);
    return [];
  }
}

export async function sendBuddyRequest(
  userId: string,
  buddyEmail: string
): Promise<boolean> {
  try {
    // First, find the user by email
    const { data: buddyUser, error: searchError } = await supabase
      .from('profiles')
      .select('user_id')
      .eq('email', buddyEmail)
      .single();

    if (searchError || !buddyUser) {
      console.error('Buddy user not found');
      return false;
    }

    const { error } = await supabase
      .from('study_buddies')
      .insert({
        user_id: userId,
        buddy_user_id: buddyUser.user_id,
        status: 'pending',
      });

    if (error) throw error;
    return true;
  } catch (error) {
    console.error('Error sending buddy request:', error);
    return false;
  }
}

export async function acceptBuddyRequest(buddyId: string): Promise<boolean> {
  try {
    const { error } = await supabase
      .from('study_buddies')
      .update({ status: 'active' })
      .eq('id', buddyId);

    if (error) throw error;
    return true;
  } catch (error) {
    console.error('Error accepting buddy request:', error);
    return false;
  }
}

export async function rejectBuddyRequest(buddyId: string): Promise<boolean> {
  try {
    const { error } = await supabase
      .from('study_buddies')
      .delete()
      .eq('id', buddyId);

    if (error) throw error;
    return true;
  } catch (error) {
    console.error('Error rejecting buddy request:', error);
    return false;
  }
}
