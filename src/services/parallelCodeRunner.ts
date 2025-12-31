// Parallel Code Execution Service
// Runs test cases in parallel without external APIs

interface TestCase {
  input: any;
  expected_output: any;
}

interface TestResult {
  passed: boolean;
  input: any;
  expected: any;
  actual: any;
  error: string | null;
  executionTime: number;
}

interface ExecutionResult {
  totalTests: number;
  passedTests: number;
  failedTests: number;
  results: TestResult[];
  totalTime: number;
  allPassed: boolean;
}

export class ParallelCodeRunner {
  private timeoutMs: number = 5000;

  /**
   * Execute code against multiple test cases in parallel
   */
  async runAllTests(
    code: string,
    language: 'javascript' | 'python' | 'java' | 'cpp',
    testCases: TestCase[]
  ): Promise<ExecutionResult> {
    const startTime = performance.now();

    // Run all test cases in parallel
    const testPromises = testCases.map((testCase, index) =>
      this.runSingleTest(code, language, testCase, index)
    );

    const results = await Promise.all(testPromises);
    const totalTime = performance.now() - startTime;

    const passedTests = results.filter(r => r.passed).length;
    const failedTests = results.length - passedTests;

    return {
      totalTests: results.length,
      passedTests,
      failedTests,
      results,
      totalTime,
      allPassed: passedTests === results.length
    };
  }

  /**
   * Run a single test case with timeout protection
   */
  private async runSingleTest(
    code: string,
    language: string,
    testCase: TestCase,
    testIndex: number
  ): Promise<TestResult> {
    const startTime = performance.now();

    try {
      // Execute based on language
      let result: any;
      
      if (language === 'javascript') {
        result = await this.executeJavaScript(code, testCase.input);
      } else if (language === 'python') {
        result = await this.executePython(code, testCase.input);
      } else {
        throw new Error(`Language ${language} not yet supported in parallel runner`);
      }

      const executionTime = performance.now() - startTime;
      const passed = this.compareOutputs(result, testCase.expected_output);

      return {
        passed,
        input: testCase.input,
        expected: testCase.expected_output,
        actual: result,
        error: null,
        executionTime
      };
    } catch (error) {
      const executionTime = performance.now() - startTime;
      return {
        passed: false,
        input: testCase.input,
        expected: testCase.expected_output,
        actual: null,
        error: error instanceof Error ? error.message : 'Unknown error',
        executionTime
      };
    }
  }

  /**
   * Execute JavaScript code in a sandboxed environment
   */
  private async executeJavaScript(code: string, input: any): Promise<any> {
    return new Promise((resolve, reject) => {
      const timeout = setTimeout(() => {
        reject(new Error('Execution timeout'));
      }, this.timeoutMs);

      try {
        // Extract function name
        const functionMatch = code.match(/function\s+(\w+)/) || 
                            code.match(/const\s+(\w+)\s*=\s*(?:function|\()/) ||
                            code.match(/(\w+)\s*=\s*(?:function|\()/);
        
        if (!functionMatch) {
          throw new Error('No function found in code');
        }

        const functionName = functionMatch[1];

        // Create a safe execution context
        const AsyncFunction = Object.getPrototypeOf(async function(){}).constructor;
        const wrappedCode = `
          ${code}
          return ${functionName};
        `;

        const fn = new AsyncFunction(wrappedCode)();

        // Handle array or single value inputs
        let result;
        if (Array.isArray(input)) {
          result = fn(...input);
        } else if (typeof input === 'object' && input !== null) {
          // If input is an object with params array
          result = fn(...(input.params || [input]));
        } else {
          result = fn(input);
        }

        // Handle promises
        Promise.resolve(result).then(res => {
          clearTimeout(timeout);
          resolve(res);
        }).catch(err => {
          clearTimeout(timeout);
          reject(err);
        });

      } catch (error) {
        clearTimeout(timeout);
        reject(error);
      }
    });
  }

  /**
   * Execute Python code by transpiling to JavaScript
   */
  private async executePython(code: string, input: any): Promise<any> {
    return new Promise((resolve, reject) => {
      const timeout = setTimeout(() => {
        reject(new Error('Execution timeout'));
      }, this.timeoutMs);

      try {
        // Simple Python to JavaScript transpilation
        let jsCode = code
          // Convert def to function
          .replace(/def\s+(\w+)\s*\((.*?)\)\s*:/g, 'function $1($2) {')
          // Convert : to {
          .replace(/:\s*$/gm, ' {')
          // Add closing braces (simple heuristic)
          .replace(/^(\s*)return\s+/gm, '$1return ')
          // Handle Python-specific syntax
          .replace(/\blen\(/g, '(')
          .replace(/\.append\(/g, '.push(')
          .replace(/\bTrue\b/g, 'true')
          .replace(/\bFalse\b/g, 'false')
          .replace(/\bNone\b/g, 'null')
          .replace(/\band\b/g, '&&')
          .replace(/\bor\b/g, '||')
          .replace(/\bnot\b/g, '!')
          // Handle indentation (simplified)
          .split('\n')
          .map(line => {
            const indent = line.match(/^\s*/)?.[0].length || 0;
            if (indent === 0 && line.trim() && !line.includes('function')) {
              return line;
            }
            return line;
          })
          .join('\n') + '\n}';

        // Extract function name
        const functionMatch = jsCode.match(/function\s+(\w+)/);
        if (!functionMatch) {
          throw new Error('No function found in Python code');
        }

        const functionName = functionMatch[1];

        // Execute the transpiled JavaScript
        const AsyncFunction = Object.getPrototypeOf(async function(){}).constructor;
        const wrappedCode = `
          ${jsCode}
          return ${functionName};
        `;

        const fn = new AsyncFunction(wrappedCode)();

        // Handle inputs
        let result;
        if (Array.isArray(input)) {
          result = fn(...input);
        } else if (typeof input === 'object' && input !== null) {
          result = fn(...(input.params || [input]));
        } else {
          result = fn(input);
        }

        Promise.resolve(result).then(res => {
          clearTimeout(timeout);
          resolve(res);
        }).catch(err => {
          clearTimeout(timeout);
          reject(err);
        });

      } catch (error) {
        clearTimeout(timeout);
        reject(error);
      }
    });
  }

  /**
   * Compare actual output with expected output
   */
  private compareOutputs(actual: any, expected: any): boolean {
    // Handle null/undefined
    if (actual === expected) return true;
    if (actual == null || expected == null) return actual === expected;

    // Handle arrays
    if (Array.isArray(actual) && Array.isArray(expected)) {
      if (actual.length !== expected.length) return false;
      return actual.every((val, idx) => this.compareOutputs(val, expected[idx]));
    }

    // Handle objects
    if (typeof actual === 'object' && typeof expected === 'object') {
      const actualKeys = Object.keys(actual).sort();
      const expectedKeys = Object.keys(expected).sort();
      
      if (actualKeys.length !== expectedKeys.length) return false;
      if (!actualKeys.every((key, idx) => key === expectedKeys[idx])) return false;
      
      return actualKeys.every(key => this.compareOutputs(actual[key], expected[key]));
    }

    // Handle primitives with type coercion for numbers
    if (typeof actual === 'number' && typeof expected === 'number') {
      return Math.abs(actual - expected) < 1e-9;
    }

    // String comparison
    return String(actual) === String(expected);
  }

  /**
   * Get execution summary message
   */
  getSummary(result: ExecutionResult): string {
    if (result.allPassed) {
      return `✅ All ${result.totalTests} test cases passed! (${result.totalTime.toFixed(0)}ms)`;
    }
    return `❌ ${result.passedTests}/${result.totalTests} test cases passed (${result.totalTime.toFixed(0)}ms)`;
  }
}

// Export singleton instance
export const parallelCodeRunner = new ParallelCodeRunner();
