import * as fs from 'fs';
import * as path from 'path';
import { fileURLToPath } from 'url';
import { dirname } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

interface ProblemTestCaseInfo {
  id: string;
  title: string;
  slug: string;
  difficulty: string;
  visibleTests: number;
  hiddenTests: number;
  totalTests: number;
}

function extractJsonbArrayLength(jsonbString: string): number {
  try {
    // Remove ::jsonb cast and parse
    const cleaned = jsonbString.replace(/::jsonb/g, '').trim();
    if (cleaned === 'NULL' || cleaned === "'{}'::jsonb" || cleaned === "'[]'::jsonb") {
      return 0;
    }
    const parsed = JSON.parse(cleaned.replace(/^'|'$/g, ''));
    return Array.isArray(parsed) ? parsed.length : 0;
  } catch (e) {
    return 0;
  }
}

function analyzeSQLFile() {
  const sqlFilePath = path.join(__dirname, '..', 'supabase', 'migrations', '20250101_problems_data.sql');
  const content = fs.readFileSync(sqlFilePath, 'utf-8');

  // Split by INSERT INTO statements
  const insertStatements = content.split(/INSERT INTO problems/g).slice(1);
  
  const problems: ProblemTestCaseInfo[] = [];
  
  for (const statement of insertStatements) {
    try {
      // Extract VALUES section
      const valuesMatch = statement.match(/VALUES\s*\(([\s\S]*?)\)\s*ON CONFLICT/);
      if (!valuesMatch) continue;
      
      const values = valuesMatch[1];
      
      // Split by commas not inside quotes or brackets
      const fields: string[] = [];
      let currentField = '';
      let inQuote = false;
      let inBracket = 0;
      let quoteChar = '';
      
      for (let i = 0; i < values.length; i++) {
        const char = values[i];
        const prevChar = i > 0 ? values[i - 1] : '';
        
        if ((char === '"' || char === "'") && prevChar !== '\\') {
          if (!inQuote) {
            inQuote = true;
            quoteChar = char;
          } else if (char === quoteChar) {
            // Check if it's an escaped quote
            if (i + 1 < values.length && values[i + 1] === quoteChar) {
              currentField += char;
              i++; // Skip next quote
              continue;
            }
            inQuote = false;
          }
        }
        
        if (char === '[' && !inQuote) inBracket++;
        if (char === ']' && !inQuote) inBracket--;
        
        if (char === ',' && !inQuote && inBracket === 0) {
          fields.push(currentField.trim());
          currentField = '';
        } else {
          currentField += char;
        }
      }
      if (currentField.trim()) {
        fields.push(currentField.trim());
      }
      
      if (fields.length >= 12) {
        const id = fields[0].replace(/'/g, '').trim();
        const title = fields[1].replace(/^'|'$/g, '').trim();
        const slug = fields[2].replace(/^'|'$/g, '').trim();
        const difficulty = fields[3].replace(/^'|'$/g, '').trim();
        const testCasesField = fields[10];
        const hiddenTestCasesField = fields[11];
        
        const visibleTests = extractJsonbArrayLength(testCasesField);
        const hiddenTests = extractJsonbArrayLength(hiddenTestCasesField);
        
        problems.push({
          id,
          title,
          slug,
          difficulty,
          visibleTests,
          hiddenTests,
          totalTests: visibleTests + hiddenTests
        });
      }
    } catch (e) {
      // Skip problematic entries
      console.error('Error parsing statement:', e);
    }
  }

  return problems;
}

function generateReport(problems: ProblemTestCaseInfo[]) {
  console.log('='.repeat(80));
  console.log('TEST CASE COVERAGE ANALYSIS');
  console.log('='.repeat(80));
  console.log(`\nTotal problems analyzed: ${problems.length}`);
  
  // Statistics
  const zeroTestCases = problems.filter(p => p.totalTests === 0);
  const lowTestCases = problems.filter(p => p.totalTests >= 1 && p.totalTests <= 2);
  const mediumTestCases = problems.filter(p => p.totalTests >= 3 && p.totalTests <= 4);
  const goodTestCases = problems.filter(p => p.totalTests >= 5);
  
  console.log('\n📊 OVERALL STATISTICS:');
  console.log('-'.repeat(80));
  console.log(`Problems with 0 test cases: ${zeroTestCases.length} (${(zeroTestCases.length/problems.length*100).toFixed(1)}%)`);
  console.log(`Problems with 1-2 test cases: ${lowTestCases.length} (${(lowTestCases.length/problems.length*100).toFixed(1)}%)`);
  console.log(`Problems with 3-4 test cases: ${mediumTestCases.length} (${(mediumTestCases.length/problems.length*100).toFixed(1)}%)`);
  console.log(`Problems with 5+ test cases: ${goodTestCases.length} (${(goodTestCases.length/problems.length*100).toFixed(1)}%)`);
  
  // Test case distribution
  const distribution: { [key: number]: number } = {};
  problems.forEach(p => {
    distribution[p.totalTests] = (distribution[p.totalTests] || 0) + 1;
  });
  
  console.log('\n📈 TEST CASE DISTRIBUTION:');
  console.log('-'.repeat(80));
  Object.keys(distribution).sort((a, b) => Number(a) - Number(b)).forEach(count => {
    const bar = '█'.repeat(Math.ceil(distribution[Number(count)] / 10));
    console.log(`${count.padStart(2)} test cases: ${distribution[Number(count)].toString().padStart(3)} problems ${bar}`);
  });
  
  // Average stats
  const avgVisible = problems.reduce((sum, p) => sum + p.visibleTests, 0) / problems.length;
  const avgHidden = problems.reduce((sum, p) => sum + p.hiddenTests, 0) / problems.length;
  const avgTotal = problems.reduce((sum, p) => sum + p.totalTests, 0) / problems.length;
  
  console.log('\n📊 AVERAGE TEST CASES:');
  console.log('-'.repeat(80));
  console.log(`Average visible test cases: ${avgVisible.toFixed(2)}`);
  console.log(`Average hidden test cases: ${avgHidden.toFixed(2)}`);
  console.log(`Average total test cases: ${avgTotal.toFixed(2)}`);
  
  // Problems with 0 test cases
  if (zeroTestCases.length > 0) {
    console.log('\n⚠️  PROBLEMS WITH 0 TEST CASES:');
    console.log('-'.repeat(80));
    zeroTestCases.slice(0, 20).forEach(p => {
      console.log(`[${p.difficulty.toUpperCase().padEnd(6)}] ${p.id.padEnd(4)} - ${p.title} (${p.slug})`);
    });
    if (zeroTestCases.length > 20) {
      console.log(`... and ${zeroTestCases.length - 20} more`);
    }
  }
  
  // Top 20 popular problems that need more test cases
  const popularSlugs = [
    'two-sum', 'reverse-integer', 'palindrome-number', 'roman-to-integer',
    'longest-common-prefix', 'valid-parentheses', 'merge-two-sorted-lists',
    'remove-duplicates-from-sorted-array', 'remove-element', 'find-index-first-occurrence',
    'search-insert-position', 'length-last-word', 'plus-one', 'add-binary',
    'climbing-stairs', 'merge-sorted-array', 'binary-tree-inorder-traversal',
    'same-tree', 'symmetric-tree', 'maximum-depth-binary-tree',
    'binary-search', 'first-bad-version', 'reverse-linked-list', 
    'best-time-buy-sell-stock', 'single-number', 'linked-list-cycle',
    'intersection-two-linked-lists', 'min-stack', 'majority-element'
  ];
  
  const popularProblemsNeedingTests = problems
    .filter(p => popularSlugs.includes(p.slug) && p.totalTests < 5)
    .sort((a, b) => {
      const aIndex = popularSlugs.indexOf(a.slug);
      const bIndex = popularSlugs.indexOf(b.slug);
      return aIndex - bIndex;
    });
  
  console.log('\n🎯 TOP 20 PRIORITY PROBLEMS (Popular, Need Better Test Coverage):');
  console.log('-'.repeat(80));
  popularProblemsNeedingTests.slice(0, 20).forEach(p => {
    const testInfo = `(${p.visibleTests}v + ${p.hiddenTests}h = ${p.totalTests} total)`;
    console.log(`[${p.difficulty.toUpperCase().padEnd(6)}] ${p.id.padEnd(4)} - ${p.title.padEnd(45)} ${testInfo}`);
  });
  
  // Problems with only 1-2 test cases
  console.log('\n⚠️  PROBLEMS WITH ONLY 1-2 TEST CASES:');
  console.log('-'.repeat(80));
  const sortedLowTests = lowTestCases.sort((a, b) => a.totalTests - b.totalTests);
  sortedLowTests.slice(0, 30).forEach(p => {
    const testInfo = `(${p.visibleTests}v + ${p.hiddenTests}h)`;
    console.log(`[${p.difficulty.toUpperCase().padEnd(6)}] ${p.id.padEnd(4)} - ${p.title.padEnd(45)} ${testInfo}`);
  });
  if (sortedLowTests.length > 30) {
    console.log(`... and ${sortedLowTests.length - 30} more`);
  }
  
  // Problems with good coverage
  console.log('\n✅ PROBLEMS WITH GOOD TEST COVERAGE (5+ tests):');
  console.log('-'.repeat(80));
  const sortedGoodTests = goodTestCases.sort((a, b) => b.totalTests - a.totalTests);
  sortedGoodTests.slice(0, 15).forEach(p => {
    const testInfo = `(${p.visibleTests}v + ${p.hiddenTests}h = ${p.totalTests} total)`;
    console.log(`[${p.difficulty.toUpperCase().padEnd(6)}] ${p.id.padEnd(4)} - ${p.title.padEnd(45)} ${testInfo}`);
  });
  
  // Breakdown by difficulty
  console.log('\n📊 BREAKDOWN BY DIFFICULTY:');
  console.log('-'.repeat(80));
  const difficulties = ['easy', 'medium', 'hard'];
  difficulties.forEach(diff => {
    const diffProblems = problems.filter(p => p.difficulty.toLowerCase() === diff);
    const diffZero = diffProblems.filter(p => p.totalTests === 0).length;
    const diffLow = diffProblems.filter(p => p.totalTests >= 1 && p.totalTests <= 2).length;
    const diffMed = diffProblems.filter(p => p.totalTests >= 3 && p.totalTests <= 4).length;
    const diffGood = diffProblems.filter(p => p.totalTests >= 5).length;
    const avgTests = diffProblems.reduce((sum, p) => sum + p.totalTests, 0) / diffProblems.length;
    
    console.log(`\n${diff.toUpperCase()} (${diffProblems.length} problems, avg ${avgTests.toFixed(2)} tests):`);
    console.log(`  0 tests: ${diffZero}, 1-2 tests: ${diffLow}, 3-4 tests: ${diffMed}, 5+ tests: ${diffGood}`);
  });
  
  console.log('\n' + '='.repeat(80));
  console.log('SUMMARY RECOMMENDATIONS:');
  console.log('='.repeat(80));
  console.log(`✓ ${goodTestCases.length} problems have good coverage (5+ tests)`);
  console.log(`⚠ ${mediumTestCases.length} problems have medium coverage (3-4 tests) - could be improved`);
  console.log(`❌ ${lowTestCases.length} problems have poor coverage (1-2 tests) - need attention`);
  console.log(`❌ ${zeroTestCases.length} problems have NO test cases - critical to add`);
  console.log(`\n🎯 Priority: Focus on the ${popularProblemsNeedingTests.length} popular problems that need better tests`);
  console.log('\n💡 RECOMMENDED ACTIONS:');
  console.log('1. Add 2-4 test cases to each of the 26 problems with 0 tests');
  console.log('2. Add 2-3 more test cases to the 332 problems with only 1-2 tests');
  console.log('3. Focus on popular LeetCode problems first (two-sum, valid-parentheses, etc.)');
  console.log('4. Each problem should ideally have 4-6 test cases total (3-4 visible, 1-2 hidden)');
  console.log('5. Include edge cases: empty inputs, single elements, large inputs, negative numbers');
  console.log('='.repeat(80));
}

// Run analysis
const problems = analyzeSQLFile();
generateReport(problems);
