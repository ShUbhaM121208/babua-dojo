import { detailedProblems } from '../src/data/mockData';
import fs from 'fs';
import path from 'path';

// Generate SQL migration from TypeScript problems
function generateMigration() {
  const timestamp = '20250101';
  const migrationName = 'problems_data';
  
  let sql = `-- Migration: Insert all problems from mockData.ts into database
-- Generated from detailedProblems object
-- Total problems: ${Object.keys(detailedProblems).length}

`;

  // Track seen slugs to avoid duplicates
  const seenSlugs = new Set<string>();
  let skippedCount = 0;

  // Convert each problem to SQL INSERT
  for (const [key, problem] of Object.entries(detailedProblems)) {
    const {
      id,
      title,
      slug,
      difficulty,
      description,
      examples,
      constraints,
      tags,
      track,
      starterCode,
      testCases,
      hints,
      solved,
      acceptanceRate,
      companies,
      timeLimit = 2000,
      memoryLimit = 256000
    } = problem as any;

    // Skip duplicate slugs (keep first occurrence only)
    if (seenSlugs.has(slug)) {
      console.log(`⚠️  Skipping duplicate slug: ${slug} (id: ${id})`);
      skippedCount++;
      continue;
    }
    seenSlugs.add(slug);

    // Separate visible and hidden test cases
    const visibleTestCases = testCases.filter((tc: any) => !tc.hidden);
    const hiddenTestCases = testCases.filter((tc: any) => tc.hidden);

    // Escape single quotes in JSON strings for SQL
    const escapeJson = (obj: any) => JSON.stringify(obj).replace(/'/g, "''");
    const escape = (str: string) => str.replace(/'/g, "''");

    // Build INSERT statement
    sql += `INSERT INTO problems (
  id, 
  title, 
  slug, 
  difficulty, 
  description, 
  examples, 
  constraints, 
  tags, 
  track_slug, 
  starter_code,
  test_cases, 
  hidden_test_cases, 
  hints, 
  acceptance_rate, 
  companies, 
  time_limit, 
  memory_limit
) VALUES (
  '${escape(String(id))}',
  '${escape(title)}',
  '${escape(slug)}',
  '${difficulty}',
  '${escape(description)}',
  '${escapeJson(examples)}'::jsonb,
  '${escapeJson(constraints)}'::jsonb,
  '${escapeJson(tags)}'::jsonb,
  '${escape(track || 'DSA')}',
  '${escapeJson(starterCode)}'::jsonb,
  '${escapeJson(visibleTestCases)}'::jsonb,
  '${escapeJson(hiddenTestCases)}'::jsonb,
  '${escapeJson(hints)}'::jsonb,
  ${acceptanceRate},
  '${escapeJson(companies)}'::jsonb,
  ${timeLimit},
  ${memoryLimit}
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  examples = EXCLUDED.examples,
  constraints = EXCLUDED.constraints,
  test_cases = EXCLUDED.test_cases,
  hidden_test_cases = EXCLUDED.hidden_test_cases,
  updated_at = NOW();

`;
  }

  // Add comment at end
  const totalProblems = Object.keys(detailedProblems).length;
  const insertedProblems = totalProblems - skippedCount;
  
  sql += `
-- Migration complete!
-- Total problems in mockData: ${totalProblems}
-- Problems inserted: ${insertedProblems}
-- Duplicates skipped: ${skippedCount}
-- All problems are now in the database with proper test cases
`;

  // Write to migration file
  const migrationPath = path.join(
    process.cwd(),
    'supabase',
    'migrations',
    `${timestamp}_${migrationName}.sql`
  );

  fs.writeFileSync(migrationPath, sql, 'utf-8');

  console.log(`✅ Migration generated: ${migrationPath}`);
  console.log(`📊 Total problems in mockData: ${totalProblems}`);
  console.log(`✅ Unique problems inserted: ${insertedProblems}`);
  console.log(`⚠️  Duplicate slugs skipped: ${skippedCount}`);
  console.log(`📁 File size: ${(sql.length / 1024).toFixed(2)} KB`);
}

generateMigration();
