// Code Execution Service using Judge0 API
// Handles code compilation and execution with test cases

interface ExecutionResult {
  stdout: string | null;
  stderr: string | null;
  compile_output: string | null;
  status: {
    id: number;
    description: string;
  };
  time: string | null;
  memory: number | null;
}

interface TestCaseResult {
  input: string;
  expected_output: string;
  actual_output: string | null;
  passed: boolean;
  error: string | null;
  time: string | null;
  memory: number | null;
}

// Language ID mapping for Judge0
export const LANGUAGE_IDS = {
  javascript: 63,  // Node.js
  python: 71,      // Python 3
  java: 62,        // Java
  cpp: 54,         // C++ (GCC 9.2.0)
  c: 50,           // C (GCC 9.2.0)
  typescript: 74,  // TypeScript
  rust: 73,        // Rust
  go: 60,          // Go
} as const;

export type SupportedLanguage = keyof typeof LANGUAGE_IDS;

class CodeExecutionService {
  private apiKey: string;
  private apiHost: string;
  private apiUrl: string;

  constructor() {
    this.apiKey = import.meta.env.VITE_JUDGE0_API_KEY || '';
    this.apiHost = import.meta.env.VITE_JUDGE0_API_HOST || 'judge0-ce.p.rapidapi.com';
    this.apiUrl = import.meta.env.VITE_JUDGE0_API_URL || 'https://judge0-ce.p.rapidapi.com';

    if (!this.apiKey) {
      console.warn('Judge0 API key not configured. Code execution will not work.');
    }
  }

  /**
   * Execute code with a single test case
   */
  async executeCode(
    code: string,
    language: SupportedLanguage,
    stdin: string = '',
    timeLimit: number = 2000, // ms
    memoryLimit: number = 256000 // KB
  ): Promise<ExecutionResult> {
    const languageId = LANGUAGE_IDS[language];

    try {
      // Step 1: Create submission
      const submissionResponse = await fetch(`${this.apiUrl}/submissions?base64_encoded=false&wait=true`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-RapidAPI-Key': this.apiKey,
          'X-RapidAPI-Host': this.apiHost,
        },
        body: JSON.stringify({
          source_code: code,
          language_id: languageId,
          stdin: stdin,
          cpu_time_limit: timeLimit / 1000, // Convert to seconds
          memory_limit: memoryLimit,
        }),
      });

      if (!submissionResponse.ok) {
        throw new Error(`Submission failed: ${submissionResponse.statusText}`);
      }

      const result = await submissionResponse.json();
      return result as ExecutionResult;
    } catch (error) {
      console.error('Code execution error:', error);
      throw error;
    }
  }

  /**
   * Execute code against multiple test cases
   */
  async executeWithTestCases(
    code: string,
    language: SupportedLanguage,
    testCases: Array<{ input: string; expected_output: string }>,
    timeLimit: number = 2000,
    memoryLimit: number = 256000
  ): Promise<{
    results: TestCaseResult[];
    passed: number;
    failed: number;
    totalTime: number;
    allPassed: boolean;
  }> {
    const results: TestCaseResult[] = [];
    let totalTime = 0;

    // Execute each test case
    for (const testCase of testCases) {
      try {
        const result = await this.executeCode(
          code,
          language,
          testCase.input,
          timeLimit,
          memoryLimit
        );

        const actualOutput = (result.stdout || '').trim();
        const expectedOutput = testCase.expected_output.trim();
        const passed = actualOutput === expectedOutput && result.status.id === 3; // Status 3 = Accepted

        results.push({
          input: testCase.input,
          expected_output: testCase.expected_output,
          actual_output: result.stdout,
          passed,
          error: result.stderr || result.compile_output || null,
          time: result.time,
          memory: result.memory,
        });

        if (result.time) {
          totalTime += parseFloat(result.time);
        }
      } catch (error) {
        results.push({
          input: testCase.input,
          expected_output: testCase.expected_output,
          actual_output: null,
          passed: false,
          error: error instanceof Error ? error.message : 'Execution failed',
          time: null,
          memory: null,
        });
      }
    }

    const passed = results.filter(r => r.passed).length;
    const failed = results.length - passed;

    return {
      results,
      passed,
      failed,
      totalTime,
      allPassed: failed === 0,
    };
  }

  /**
   * Get supported languages
   */
  getSupportedLanguages(): SupportedLanguage[] {
    return Object.keys(LANGUAGE_IDS) as SupportedLanguage[];
  }

  /**
   * Check if API is configured
   */
  isConfigured(): boolean {
    return !!this.apiKey;
  }
}

// Export singleton instance
export const codeExecutionService = new CodeExecutionService();
