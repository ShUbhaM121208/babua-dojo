import { supabase } from '@/integrations/supabase/client';

export interface Problem {
  id: string;
  title: string;
  slug: string;
  difficulty: 'easy' | 'medium' | 'hard';
  description: string;
  examples: Array<{
    input: string;
    output: string;
    explanation?: string;
  }>;
  constraints: string[];
  tags: string[];
  track: string;
  track_slug?: string;
  starter_code?: {
    javascript?: string;
    python?: string;
    java?: string;
    cpp?: string;
    c?: string;
    typescript?: string;
    rust?: string;
    go?: string;
  };
  starterCode?: {
    javascript?: string;
    python?: string;
    java?: string;
  };
  test_cases?: Array<{
    id: string;
    input: string;
    expectedOutput: string;
    expected_output?: string;
    hidden: boolean;
  }>;
  testCases?: Array<{
    id: string;
    input: string;
    expectedOutput: string;
    hidden: boolean;
  }>;
  hidden_test_cases?: Array<{
    id: string;
    input: string;
    expectedOutput: string;
    expected_output?: string;
    hidden: boolean;
  }>;
  hints: string[];
  solved?: boolean;
  acceptanceRate?: number;
  acceptance_rate?: number;
  companies: string[];
  timeLimit?: number;
  time_limit?: number;
  memoryLimit?: number;
  memory_limit?: number;
  order_index?: number;
  created_at?: string;
  updated_at?: string;
}

class ProblemService {
  /**
   * Fetch all problems from database
   */
  async getAllProblems(): Promise<Problem[]> {
    const { data, error } = await supabase
      .from('problems')
      .select('*')
      .order('order_index', { ascending: true });

    if (error) {
      console.error('Error fetching problems:', error);
      throw error;
    }

    return this.normalizeProblemArray(data || []);
  }

  /**
   * Fetch a single problem by slug
   */
  async getProblemBySlug(slug: string): Promise<Problem | null> {
    const { data, error } = await supabase
      .from('problems')
      .select('*')
      .eq('slug', slug)
      .single();

    if (error) {
      console.error('Error fetching problem:', error);
      return null;
    }

    return data ? this.normalizeProblem(data) : null;
  }

  /**
   * Fetch a single problem by ID
   */
  async getProblemById(id: string): Promise<Problem | null> {
    const { data, error } = await supabase
      .from('problems')
      .select('*')
      .eq('id', id)
      .single();

    if (error) {
      console.error('Error fetching problem:', error);
      return null;
    }

    return data ? this.normalizeProblem(data) : null;
  }

  /**
   * Fetch problems by track
   */
  async getProblemsByTrack(trackSlug: string): Promise<Problem[]> {
    const { data, error } = await supabase
      .from('problems')
      .select('*')
      .eq('track_slug', trackSlug)
      .order('order_index', { ascending: true });

    if (error) {
      console.error('Error fetching problems by track:', error);
      throw error;
    }

    return this.normalizeProblemArray(data || []);
  }

  /**
   * Fetch problems by difficulty
   */
  async getProblemsByDifficulty(difficulty: 'easy' | 'medium' | 'hard'): Promise<Problem[]> {
    const { data, error } = await supabase
      .from('problems')
      .select('*')
      .eq('difficulty', difficulty)
      .order('acceptance_rate', { ascending: false });

    if (error) {
      console.error('Error fetching problems by difficulty:', error);
      throw error;
    }

    return this.normalizeProblemArray(data || []);
  }

  /**
   * Search problems by title or tags
   */
  async searchProblems(query: string): Promise<Problem[]> {
    const { data, error } = await supabase
      .from('problems')
      .select('*')
      .or(`title.ilike.%${query}%,tags.cs.{${query}}`);

    if (error) {
      console.error('Error searching problems:', error);
      throw error;
    }

    return this.normalizeProblemArray(data || []);
  }

  /**
   * Normalize a single problem from database format
   * Handles snake_case to camelCase conversion and merges test cases
   */
  private normalizeProblem(dbProblem: any): Problem {
    const visibleTests = dbProblem.test_cases || [];
    const hiddenTests = dbProblem.hidden_test_cases || [];

    return {
      id: dbProblem.id,
      title: dbProblem.title,
      slug: dbProblem.slug,
      difficulty: dbProblem.difficulty,
      description: dbProblem.description,
      examples: dbProblem.examples || [],
      constraints: dbProblem.constraints || [],
      tags: dbProblem.tags || [],
      track: dbProblem.track_slug || 'DSA',
      track_slug: dbProblem.track_slug,
      starterCode: dbProblem.starter_code || {},
      starter_code: dbProblem.starter_code || {},
      testCases: [...visibleTests, ...hiddenTests].map((tc: any) => ({
        id: tc.id,
        input: tc.input,
        expectedOutput: tc.expectedOutput || tc.expected_output,
        hidden: tc.hidden || false,
      })),
      test_cases: visibleTests,
      hidden_test_cases: hiddenTests,
      hints: dbProblem.hints || [],
      acceptanceRate: dbProblem.acceptance_rate,
      acceptance_rate: dbProblem.acceptance_rate,
      companies: dbProblem.companies || [],
      timeLimit: dbProblem.time_limit || 2000,
      time_limit: dbProblem.time_limit || 2000,
      memoryLimit: dbProblem.memory_limit || 256000,
      memory_limit: dbProblem.memory_limit || 256000,
      order_index: dbProblem.order_index,
      created_at: dbProblem.created_at,
      updated_at: dbProblem.updated_at,
    };
  }

  /**
   * Normalize array of problems
   */
  private normalizeProblemArray(dbProblems: any[]): Problem[] {
    return dbProblems.map(p => this.normalizeProblem(p));
  }
}

export const problemService = new ProblemService();
