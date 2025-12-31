// Interview Prep Service - Supabase helper functions
import { supabase } from '@/integrations/supabase/client';
import type { InterviewSession, InterviewProfile, InterviewFeedback } from '@/types/interview';

export async function createInterviewSession(
  interviewerId: string,
  intervieweeId: string,
  problemId: string,
  interviewType: string
): Promise<InterviewSession> {
  const sessionCode = Math.random().toString(36).substring(2, 10).toUpperCase();
  
  const { data, error } = await supabase
    .from('interview_sessions')
    .insert({
      session_code: sessionCode,
      interviewer_id: interviewerId,
      interviewee_id: intervieweeId,
      problem_id: problemId,
      interview_type: interviewType,
      problem_difficulty: 'medium',
      status: 'scheduled'
    })
    .select()
    .single();
    
  if (error) throw new Error(error.message);
  return data;
}

export async function updateCodeSnapshot(sessionId: string, code: string): Promise<void> {
  await supabase
    .from('interview_sessions')
    .update({ code_snapshot: code })
    .eq('id', sessionId);
}

export async function startInterview(sessionId: string): Promise<void> {
  await supabase
    .from('interview_sessions')
    .update({
      status: 'active',
      started_at: new Date().toISOString()
    })
    .eq('id', sessionId);
}

export async function endInterview(sessionId: string): Promise<void> {
  const { data: session } = await supabase
    .from('interview_sessions')
    .select('started_at')
    .eq('id', sessionId)
    .single();
    
  const duration = session?.started_at 
    ? Math.floor((Date.now() - new Date(session.started_at).getTime()) / 1000)
    : 0;
    
  await supabase
    .from('interview_sessions')
    .update({
      status: 'completed',
      ended_at: new Date().toISOString(),
      duration_seconds: duration
    })
    .eq('id', sessionId);
}

export async function submitInterviewFeedback(
  sessionId: string,
  feedbackFromId: string,
  feedbackToId: string,
  role: 'interviewer' | 'interviewee',
  feedbackData: Partial<InterviewFeedback>
): Promise<void> {
  const { error } = await supabase
    .from('interview_feedback')
    .insert({
      interview_session_id: sessionId,
      feedback_from_id: feedbackFromId,
      feedback_to_id: feedbackToId,
      role,
      ...feedbackData
    });
    
  if (error) throw new Error(error.message);
}

export async function joinInterviewQueue(
  userId: string,
  rolePreference: string | string[],
  experienceLevel: string,
  difficulty: string = 'any',
  interviewType: string = 'any',
  topics: string[] = [],
  languages: string[] = []
): Promise<void> {
  // First check if user is already in queue
  const { data: existing } = await supabase
    .from('interview_matching_queue')
    .select('id')
    .eq('user_id', userId)
    .single();
    
  if (existing) {
    // Already in queue, just return success
    return;
  }
  
  const role = Array.isArray(rolePreference) 
    ? (rolePreference.length === 2 ? 'either' : rolePreference[0])
    : rolePreference;
    
  const { error } = await supabase
    .from('interview_matching_queue')
    .insert({
      user_id: userId,
      role_preference: role,
      experience_level: experienceLevel,
      preferred_difficulty: difficulty,
      interview_type: interviewType,
      topics: topics,
      languages: languages,
      expires_at: new Date(Date.now() + 10 * 60 * 1000).toISOString()
    });
    
  if (error && !error.message.includes('duplicate')) {
    throw new Error(error.message);
  }
}

export async function leaveInterviewQueue(userId: string): Promise<void> {
  await supabase
    .from('interview_matching_queue')
    .delete()
    .eq('user_id', userId);
}

export async function getAvailablePeers(userId: string): Promise<InterviewProfile[]> {
  const { data } = await supabase
    .from('interview_profiles')
    .select('*')
    .eq('is_available', true)
    .neq('user_id', userId)
    .limit(20);
    
  return data || [];
}

export async function getUserInterviewProfile(userId: string): Promise<InterviewProfile | null> {
  const { data, error } = await supabase
    .from('interview_profiles')
    .select('*')
    .eq('user_id', userId)
    .single();
    
  // If profile doesn't exist, create a basic one
  if (error && error.code === 'PGRST116') {
    const { data: user } = await supabase.auth.getUser();
    const username = user?.user?.user_metadata?.full_name || user?.user?.email?.split('@')[0] || 'User';
    
    const { data: newProfile } = await supabase
      .from('interview_profiles')
      .insert({
        user_id: userId,
        username: username,
        experience_level: 'intermediate',
        is_available: true
      })
      .select()
      .single();
      
    return newProfile;
  }
    
  return data;
}

export async function createOrUpdateInterviewProfile(
  userId: string,
  profileData: Partial<InterviewProfile>
): Promise<InterviewProfile> {
  const { data, error } = await supabase
    .from('interview_profiles')
    .upsert({
      user_id: userId,
      ...profileData
    })
    .select()
    .single();
    
  if (error) throw new Error(error.message);
  return data;
}
