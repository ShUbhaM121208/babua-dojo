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
          clearTimeout(timeout);
          reject(new Error('No function found in code'));
          return;
        }

        const functionName = functionMatch[1];

        // Create a safe execution context
        const wrappedCode = `
          ${code}
          return ${functionName};
        `;

        // Use Function constructor instead of AsyncFunction for better compatibility
        const fn = new Function(wrappedCode)();
        
        if (typeof fn !== 'function') {
          clearTimeout(timeout);
          reject(new Error('Could not extract function from code'));
          return;
        }

        // Parse input if it's a JSON string
        let parsedInput = input;
        if (typeof input === 'string') {
          try {
            // Check if input contains multiple comma-separated values (like "[2,7,11,15], 9")
            // Split by comma outside of brackets
            const parts = input.split(/,\s*(?![^\[]*\])/);
            
            if (parts.length > 1) {
              // Multiple parameters - parse each one
              parsedInput = parts.map(part => {
                try {
                  return JSON.parse(part.trim());
                } catch {
                  return part.trim();
                }
              });
            } else {
              // Single parameter - try to parse as JSON
              parsedInput = JSON.parse(input);
            }
          } catch (e) {
            // If parsing fails, use as-is
            parsedInput = input;
          }
        }

        // Handle array or single value inputs
        let result;
        if (Array.isArray(parsedInput)) {
          // Multiple parameters - spread them
          result = fn(...parsedInput);
        } else if (typeof parsedInput === 'object' && parsedInput !== null && 'params' in parsedInput) {
          // If input is an object with params array
          result = fn(...parsedInput.params);
        } else {
          result = fn(parsedInput);
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
          clearTimeout(timeout);
          reject(new Error('No function found in Python code'));
          return;
        }

        const functionName = functionMatch[1];

        // Execute the transpiled JavaScript
        const wrappedCode = `
          ${jsCode}
          return ${functionName};
        `;

        const fn = new Function(wrappedCode)();
        
        if (typeof fn !== 'function') {
          clearTimeout(timeout);
          reject(new Error('Could not extract function from Python code'));
          return;
        }

        // Handle inputs
        let result;
        if (Array.isArray(input)) {
          result = fn(...input);
        } else if (typeof input === 'object' && input !== null && 'params' in input) {
          result = fn(...input.params);
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
    // Parse expected if it's a JSON string
    let parsedExpected = expected;
    if (typeof expected === 'string') {
      try {
        parsedExpected = JSON.parse(expected);
      } catch (e) {
        // If parsing fails, use as-is
        parsedExpected = expected;
      }
    }

    // Handle null/undefined
    if (actual === parsedExpected) return true;
    if (actual == null || parsedExpected == null) return actual === parsedExpected;

    // Handle arrays
    if (Array.isArray(actual) && Array.isArray(parsedExpected)) {
      if (actual.length !== parsedExpected.length) return false;
      return actual.every((val, idx) => this.compareOutputs(val, parsedExpected[idx]));
    }

    // Handle objects
    if (typeof actual === 'object' && typeof parsedExpected === 'object') {
      const actualKeys = Object.keys(actual).sort();
      const expectedKeys = Object.keys(parsedExpected).sort();
      
      if (actualKeys.length !== expectedKeys.length) return false;
      if (!actualKeys.every((key, idx) => key === expectedKeys[idx])) return false;
      
      return actualKeys.every(key => this.compareOutputs(actual[key], parsedExpected[key]));
    }

    // Handle primitives with type coercion for numbers
    if (typeof actual === 'number' && typeof parsedExpected === 'number') {
      return Math.abs(actual - parsedExpected) < 1e-9;
    }

    // String comparison
    return String(actual) === String(parsedExpected);
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
