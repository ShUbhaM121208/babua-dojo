import { supabase } from '@/integrations/supabase/client';

export interface Submission {
  id: string;
  user_id: string;
  problem_id: string;
  version: number;
  language: string;
  code: string;
  status: 'accepted' | 'wrong_answer' | 'runtime_error' | 'compile_error' | 'time_limit_exceeded' | 'memory_limit_exceeded';
  test_results: Array<{
    input: string;
    expected_output: string;
    actual_output: string | null;
    passed: boolean;
    error: string | null;
    time: string | null;
    memory: number | null;
  }>;
  passed_count: number;
  failed_count: number;
  total_time: number;
  memory_used: number;
  all_passed: boolean;
  error_message: string | null;
  submitted_at: string;
}

export interface SubmissionStats {
  user_id: string;
  problem_id: string;
  total_attempts: number;
  latest_version: number;
  first_attempt_at: string;
  latest_attempt_at: string;
  successful_attempts: number;
  success_rate: number;
  avg_time_between_attempts_minutes: number | null;
  first_success_version: number | null;
  best_time: number | null;
  best_memory: number | null;
}

export interface SubmitCodeParams {
  problemId: string;
  language: string;
  code: string;
  status: Submission['status'];
  testResults: Submission['test_results'];
  passedCount: number;
  failedCount: number;
  totalTime: number;
  memoryUsed: number;
  allPassed: boolean;
  errorMessage?: string | null;
}

class SubmissionService {
  /**
   * Submit code for a problem (creates new versioned submission)
   */
  async submitCode(params: SubmitCodeParams): Promise<Submission | null> {
    try {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) {
        console.warn('User not authenticated - storing submission locally');
        this.storeSubmissionLocally(params, user?.id);
        return null;
      }

      const { data, error } = await supabase
        .from('problem_submissions')
        .insert({
          user_id: user.id,
          problem_id: params.problemId,
          language: params.language,
          code: params.code,
          status: params.status,
          test_results: params.testResults,
          passed_count: params.passedCount,
          failed_count: params.failedCount,
          total_time: params.totalTime,
          memory_used: params.memoryUsed,
          all_passed: params.allPassed,
          error_message: params.errorMessage,
        })
        .select()
        .single();

      if (error) {
        // Handle table doesn't exist or schema mismatch (406, 400, 42703)
        console.warn('Submission table error - using local storage:', error.code);
        this.storeSubmissionLocally(params, user.id);
        return null;
      }
      return data;
    } catch (error) {
      console.error('Error submitting code:', error);
      const { data: { user } } = await supabase.auth.getUser();
      this.storeSubmissionLocally(params, user?.id);
      return null;
    }
  }

  /**
   * Store submission locally when database is unavailable
   */
  private storeSubmissionLocally(params: SubmitCodeParams, userId?: string): void {
    try {
      const storageKey = `local_submissions_${userId || 'anonymous'}`;
      const submissions = JSON.parse(localStorage.getItem(storageKey) || '{}');
      if (!submissions[params.problemId]) {
        submissions[params.problemId] = [];
      }
      
      const version = submissions[params.problemId].length + 1;
      const submission = {
        id: `local_${Date.now()}_${version}`,
        user_id: userId || 'anonymous',
        problem_id: params.problemId,
        version,
        language: params.language,
        code: params.code,
        status: params.status,
        test_results: params.testResults,
        passed_count: params.passedCount,
        failed_count: params.failedCount,
        total_time: params.totalTime,
        memory_used: params.memoryUsed,
        all_passed: params.allPassed,
        error_message: params.errorMessage,
        submitted_at: new Date().toISOString(),
      };
      
      submissions[params.problemId].push(submission);
      localStorage.setItem(storageKey, JSON.stringify(submissions));
      console.log('✓ Submission stored locally (version', version, ')');
    } catch (error) {
      console.error('Failed to store submission locally:', error);
    }
  }

  /**
   * Get all submissions for a problem by the current user
   */
  async getSubmissionHistory(problemId: string): Promise<Submission[]> {
    try {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) return this.getLocalSubmissions(problemId);

      const { data, error } = await supabase
        .from('problem_submissions')
        .select('*')
        .eq('user_id', user.id)
        .eq('problem_id', problemId)
        .order('version', { ascending: false });

      if (error) {
        // Fallback to local storage if table doesn't exist
        console.warn('Submission table error - using local storage');
        return this.getLocalSubmissions(problemId, user.id);
      }
      
      // Merge database submissions with local ones
      const localSubmissions = this.getLocalSubmissions(problemId, user.id);
      return [...(data || []), ...localSubmissions];
    } catch (error) {
      console.error('Error fetching submission history:', error);
      const { data: { user } } = await supabase.auth.getUser();
      return this.getLocalSubmissions(problemId, user?.id);
    }
  }

  /**
   * Get local submissions from localStorage
   */
  private getLocalSubmissions(problemId: string, userId?: string): Submission[] {
    try {
      const storageKey = `local_submissions_${userId || 'anonymous'}`;
      const submissions = JSON.parse(localStorage.getItem(storageKey) || '{}');
      return (submissions[problemId] || []).sort((a: Submission, b: Submission) => 
        b.version - a.version
      );
    } catch (error) {
      console.error('Failed to get local submissions:', error);
      return [];
    }
  }

  /**
   * Get a specific submission by version
   */
  async getSubmissionByVersion(problemId: string, version: number): Promise<Submission | null> {
    try {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) return null;

      const { data, error } = await supabase
        .from('problem_submissions')
        .select('*')
        .eq('user_id', user.id)
        .eq('problem_id', problemId)
        .eq('version', version)
        .single();

      if (error) throw error;
      return data;
    } catch (error) {
      console.error('Error fetching submission:', error);
      return null;
    }
  }

  /**
   * Get latest submission for a problem
   */
  async getLatestSubmission(problemId: string): Promise<Submission | null> {
    try {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) return null;

      const { data, error } = await supabase
        .from('latest_submissions')
        .select('*')
        .eq('user_id', user.id)
        .eq('problem_id', problemId)
        .single();

      if (error) {
        if (error.code === 'PGRST116') return null; // No rows found
        throw error;
      }
      return data;
    } catch (error) {
      console.error('Error fetching latest submission:', error);
      return null;
    }
  }

  /**
   * Get submission statistics for a problem
   */
  async getSubmissionStats(problemId: string): Promise<SubmissionStats | null> {
    try {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) return null;

      const { data, error } = await supabase
        .from('submission_stats')
        .select('*')
        .eq('user_id', user.id)
        .eq('problem_id', problemId)
        .single();

      if (error) {
        if (error.code === 'PGRST116') return null; // No rows found
        throw error;
      }
      return data;
    } catch (error) {
      console.error('Error fetching submission stats:', error);
      return null;
    }
  }

  /**
   * Get all submissions across all problems for current user
   */
  async getAllUserSubmissions(limit: number = 50): Promise<Submission[]> {
    try {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) return [];

      const { data, error } = await supabase
        .from('problem_submissions')
        .select('*')
        .eq('user_id', user.id)
        .order('submitted_at', { ascending: false })
        .limit(limit);

      if (error) throw error;
      return data || [];
    } catch (error) {
      console.error('Error fetching user submissions:', error);
      return [];
    }
  }

  /**
   * Get submission count for a problem
   */
  async getSubmissionCount(problemId: string): Promise<number> {
    try {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) return 0;

      const { count, error } = await supabase
        .from('problem_submissions')
        .select('*', { count: 'exact', head: true })
        .eq('user_id', user.id)
        .eq('problem_id', problemId);

      if (error) throw error;
      return count || 0;
    } catch (error) {
      console.error('Error counting submissions:', error);
      return 0;
    }
  }

  /**
   * Delete a specific submission
   */
  async deleteSubmission(submissionId: string): Promise<boolean> {
    try {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) return false;

      const { error } = await supabase
        .from('problem_submissions')
        .delete()
        .eq('id', submissionId)
        .eq('user_id', user.id);

      if (error) throw error;
      return true;
    } catch (error) {
      console.error('Error deleting submission:', error);
      return false;
    }
  }

  /**
   * Get comparison between two versions
   */
  async compareVersions(
    problemId: string,
    version1: number,
    version2: number
  ): Promise<{ submission1: Submission | null; submission2: Submission | null }> {
    try {
      const [sub1, sub2] = await Promise.all([
        this.getSubmissionByVersion(problemId, version1),
        this.getSubmissionByVersion(problemId, version2),
      ]);

      return { submission1: sub1, submission2: sub2 };
    } catch (error) {
      console.error('Error comparing versions:', error);
      return { submission1: null, submission2: null };
    }
  }

  /**
   * Get improvement trend data for analytics
   */
  async getImprovementTrend(problemId: string): Promise<Array<{
    version: number;
    passed_count: number;
    total_time: number;
    submitted_at: string;
  }>> {
    try {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) return [];

      const { data, error } = await supabase
        .from('problem_submissions')
        .select('version, passed_count, total_time, submitted_at')
        .eq('user_id', user.id)
        .eq('problem_id', problemId)
        .order('version', { ascending: true });

      if (error) throw error;
      return data || [];
    } catch (error) {
      console.error('Error fetching improvement trend:', error);
      return [];
    }
  }
}

export const submissionService = new SubmissionService();
