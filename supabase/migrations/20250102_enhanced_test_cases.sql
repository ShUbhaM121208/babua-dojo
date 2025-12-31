-- Week 2: Enhanced Test Cases for Top Priority Problems
-- This migration adds comprehensive test cases with edge cases

-- 1. Two Sum (id: 1) - Currently has 4 tests, adding 3 more
UPDATE problems 
SET 
  test_cases = '[
    {"id":"1","input":"[2,7,11,15]\\n9","expectedOutput":"[0,1]","hidden":false},
    {"id":"2","input":"[3,2,4]\\n6","expectedOutput":"[1,2]","hidden":false},
    {"id":"3","input":"[3,3]\\n6","expectedOutput":"[0,1]","hidden":false},
    {"id":"4","input":"[-1,-2,-3,-4,-5]\\n-8","expectedOutput":"[2,4]","hidden":false},
    {"id":"5","input":"[0,4,3,0]\\n0","expectedOutput":"[0,3]","hidden":false}
  ]'::jsonb,
  hidden_test_cases = '[
    {"id":"6","input":"[1,5,3,7,9]\\n12","expectedOutput":"[2,4]","hidden":true},
    {"id":"7","input":"[1000000000,999999999,2]\\n1999999999","expectedOutput":"[0,1]","hidden":true},
    {"id":"8","input":"[1,2]\\n3","expectedOutput":"[0,1]","hidden":true}
  ]'::jsonb,
  time_limit = 2000,
  memory_limit = 256000
WHERE id = '1';

-- 2. Valid Parentheses - Currently has 3 tests, adding 4 more
UPDATE problems 
SET 
  test_cases = '[
    {"id":"1","input":"()","expectedOutput":"true","hidden":false},
    {"id":"2","input":"()[]{}","expectedOutput":"true","hidden":false},
    {"id":"3","input":"(]","expectedOutput":"false","hidden":false},
    {"id":"4","input":"([)]","expectedOutput":"false","hidden":false},
    {"id":"5","input":"","expectedOutput":"true","hidden":false}
  ]'::jsonb,
  hidden_test_cases = '[
    {"id":"6","input":"{[]}","expectedOutput":"true","hidden":true},
    {"id":"7","input":"((((((((((","expectedOutput":"false","hidden":true},
    {"id":"8","input":")(","expectedOutput":"false","hidden":true}
  ]'::jsonb
WHERE slug = 'valid-parentheses';

-- 3. Binary Search - Currently has 3 tests, adding 4 more
UPDATE problems 
SET 
  test_cases = '[
    {"id":"1","input":"[-1,0,3,5,9,12]\\n9","expectedOutput":"4","hidden":false},
    {"id":"2","input":"[-1,0,3,5,9,12]\\n2","expectedOutput":"-1","hidden":false},
    {"id":"3","input":"[5]\\n5","expectedOutput":"0","hidden":false},
    {"id":"4","input":"[5]\\n-5","expectedOutput":"-1","hidden":false},
    {"id":"5","input":"[1,2,3,4,5,6,7,8,9,10]\\n1","expectedOutput":"0","hidden":false}
  ]'::jsonb,
  hidden_test_cases = '[
    {"id":"6","input":"[1,2,3,4,5,6,7,8,9,10]\\n10","expectedOutput":"9","hidden":true},
    {"id":"7","input":"[-1000000000,1000000000]\\n1000000000","expectedOutput":"1","hidden":true}
  ]'::jsonb
WHERE slug = 'binary-search';

-- 4. Reverse Linked List - Adding 6 more tests
UPDATE problems 
SET 
  test_cases = '[
    {"id":"1","input":"[1,2,3,4,5]","expectedOutput":"[5,4,3,2,1]","hidden":false},
    {"id":"2","input":"[1,2]","expectedOutput":"[2,1]","hidden":false},
    {"id":"3","input":"[]","expectedOutput":"[]","hidden":false},
    {"id":"4","input":"[1]","expectedOutput":"[1]","hidden":false}
  ]'::jsonb,
  hidden_test_cases = '[
    {"id":"5","input":"[1,2,3,4,5,6,7,8,9,10]","expectedOutput":"[10,9,8,7,6,5,4,3,2,1]","hidden":true},
    {"id":"6","input":"[-1,-2,-3]","expectedOutput":"[-3,-2,-1]","hidden":true}
  ]'::jsonb
WHERE slug = 'reverse-linked-list';

-- 5. Best Time to Buy and Sell Stock - Adding 4 more tests
UPDATE problems 
SET 
  test_cases = '[
    {"id":"1","input":"[7,1,5,3,6,4]","expectedOutput":"5","hidden":false},
    {"id":"2","input":"[7,6,4,3,1]","expectedOutput":"0","hidden":false},
    {"id":"3","input":"[1,2]","expectedOutput":"1","hidden":false},
    {"id":"4","input":"[2,4,1]","expectedOutput":"2","hidden":false}
  ]'::jsonb,
  hidden_test_cases = '[
    {"id":"5","input":"[3,3,3,3,3]","expectedOutput":"0","hidden":true},
    {"id":"6","input":"[1,2,3,4,5]","expectedOutput":"4","hidden":true}
  ]'::jsonb
WHERE slug = 'best-time-buy-sell-stock';

-- 6. Linked List Cycle - Adding 4 more tests
UPDATE problems 
SET 
  test_cases = '[
    {"id":"1","input":"[3,2,0,-4]\\n1","expectedOutput":"true","hidden":false},
    {"id":"2","input":"[1,2]\\n0","expectedOutput":"true","hidden":false},
    {"id":"3","input":"[1]\\n-1","expectedOutput":"false","hidden":false},
    {"id":"4","input":"[]\\n-1","expectedOutput":"false","hidden":false}
  ]'::jsonb,
  hidden_test_cases = '[
    {"id":"5","input":"[1,2,3,4,5]\\n2","expectedOutput":"true","hidden":true},
    {"id":"6","input":"[1,2,3,4,5]\\n-1","expectedOutput":"false","hidden":true}
  ]'::jsonb
WHERE slug = 'linked-list-cycle';

-- 7. Climbing Stairs - Adding 4 more tests
UPDATE problems 
SET 
  test_cases = '[
    {"id":"1","input":"2","expectedOutput":"2","hidden":false},
    {"id":"2","input":"3","expectedOutput":"3","hidden":false},
    {"id":"3","input":"1","expectedOutput":"1","hidden":false},
    {"id":"4","input":"5","expectedOutput":"8","hidden":false}
  ]'::jsonb,
  hidden_test_cases = '[
    {"id":"5","input":"10","expectedOutput":"89","hidden":true},
    {"id":"6","input":"20","expectedOutput":"10946","hidden":true}
  ]'::jsonb
WHERE slug = 'climbing-stairs';

-- 8. Merge Sorted Array - Adding 5 more tests
UPDATE problems 
SET 
  test_cases = '[
    {"id":"1","input":"[1,2,3,0,0,0]\\n3\\n[2,5,6]\\n3","expectedOutput":"[1,2,2,3,5,6]","hidden":false},
    {"id":"2","input":"[1]\\n1\\n[]\\n0","expectedOutput":"[1]","hidden":false},
    {"id":"3","input":"[0]\\n0\\n[1]\\n1","expectedOutput":"[1]","hidden":false},
    {"id":"4","input":"[2,0]\\n1\\n[1]\\n1","expectedOutput":"[1,2]","hidden":false}
  ]'::jsonb,
  hidden_test_cases = '[
    {"id":"5","input":"[-1,0,0,3,3,3,0,0,0]\\n6\\n[1,2,2]\\n3","expectedOutput":"[-1,0,0,1,2,2,3,3,3]","hidden":true},
    {"id":"6","input":"[1,2,3,4,5,0,0,0]\\n5\\n[6,7,8]\\n3","expectedOutput":"[1,2,3,4,5,6,7,8]","hidden":true}
  ]'::jsonb
WHERE slug = 'merge-sorted-array';

-- 9. Valid Palindrome - Adding 5 more tests
UPDATE problems 
SET 
  test_cases = '[
    {"id":"1","input":"A man, a plan, a canal: Panama","expectedOutput":"true","hidden":false},
    {"id":"2","input":"race a car","expectedOutput":"false","hidden":false},
    {"id":"3","input":" ","expectedOutput":"true","hidden":false},
    {"id":"4","input":"a","expectedOutput":"true","hidden":false}
  ]'::jsonb,
  hidden_test_cases = '[
    {"id":"5","input":"0P","expectedOutput":"false","hidden":true},
    {"id":"6","input":".,","expectedOutput":"true","hidden":true}
  ]'::jsonb
WHERE slug = 'valid-palindrome';

-- 10. Symmetric Tree - Adding 5 more tests
UPDATE problems 
SET 
  test_cases = '[
    {"id":"1","input":"[1,2,2,3,4,4,3]","expectedOutput":"true","hidden":false},
    {"id":"2","input":"[1,2,2,null,3,null,3]","expectedOutput":"false","hidden":false},
    {"id":"3","input":"[1]","expectedOutput":"true","hidden":false},
    {"id":"4","input":"[]","expectedOutput":"true","hidden":false}
  ]'::jsonb,
  hidden_test_cases = '[
    {"id":"5","input":"[1,2,2,2,null,2]","expectedOutput":"false","hidden":true},
    {"id":"6","input":"[1,2,3]","expectedOutput":"false","hidden":true}
  ]'::jsonb
WHERE slug = 'symmetric-tree';

-- 11. First Bad Version - Adding 4 more tests
UPDATE problems 
SET 
  test_cases = '[
    {"id":"1","input":"5\\n4","expectedOutput":"4","hidden":false},
    {"id":"2","input":"1\\n1","expectedOutput":"1","hidden":false},
    {"id":"3","input":"10\\n1","expectedOutput":"1","hidden":false}
  ]'::jsonb,
  hidden_test_cases = '[
    {"id":"4","input":"100\\n50","expectedOutput":"50","hidden":true},
    {"id":"5","input":"2147483647\\n2147483647","expectedOutput":"2147483647","hidden":true}
  ]'::jsonb
WHERE slug = 'first-bad-version';

-- 12. Single Number - Adding 5 more tests
UPDATE problems 
SET 
  test_cases = '[
    {"id":"1","input":"[2,2,1]","expectedOutput":"1","hidden":false},
    {"id":"2","input":"[4,1,2,1,2]","expectedOutput":"4","hidden":false},
    {"id":"3","input":"[1]","expectedOutput":"1","hidden":false}
  ]'::jsonb,
  hidden_test_cases = '[
    {"id":"4","input":"[-1,-1,-2]","expectedOutput":"-2","hidden":true},
    {"id":"5","input":"[0,1,0]","expectedOutput":"1","hidden":true}
  ]'::jsonb
WHERE slug = 'single-number';

-- 13. 3Sum - Adding 5 more tests
UPDATE problems 
SET 
  test_cases = '[
    {"id":"1","input":"[-1,0,1,2,-1,-4]","expectedOutput":"[[-1,-1,2],[-1,0,1]]","hidden":false},
    {"id":"2","input":"[0,1,1]","expectedOutput":"[]","hidden":false},
    {"id":"3","input":"[0,0,0]","expectedOutput":"[[0,0,0]]","hidden":false},
    {"id":"4","input":"[-2,0,1,1,2]","expectedOutput":"[[-2,0,2],[-2,1,1]]","hidden":false}
  ]'::jsonb,
  hidden_test_cases = '[
    {"id":"5","input":"[-1,0,1,2,-1,-4,-2,-3,3,0,4]","expectedOutput":"[[-4,0,4],[-4,1,3],[-3,-1,4],[-3,0,3],[-3,1,2],[-2,-1,3],[-2,0,2],[-1,-1,2],[-1,0,1]]","hidden":true}
  ]'::jsonb
WHERE slug = '3sum';

-- 14. Longest Common Prefix - Adding 4 more tests
UPDATE problems 
SET 
  test_cases = '[
    {"id":"1","input":"[flower,flow,flight]","expectedOutput":"fl","hidden":false},
    {"id":"2","input":"[dog,racecar,car]","expectedOutput":"","hidden":false},
    {"id":"3","input":"[a]","expectedOutput":"a","hidden":false},
    {"id":"4","input":"[ab,a]","expectedOutput":"a","hidden":false}
  ]'::jsonb,
  hidden_test_cases = '[
    {"id":"5","input":"[,]","expectedOutput":"","hidden":true},
    {"id":"6","input":"[prefix,prefixes,preform]","expectedOutput":"pre","hidden":true}
  ]'::jsonb
WHERE slug = 'longest-common-prefix';

-- 15. Reverse Integer - Adding 4 more tests
UPDATE problems 
SET 
  test_cases = '[
    {"id":"1","input":"123","expectedOutput":"321","hidden":false},
    {"id":"2","input":"-123","expectedOutput":"-321","hidden":false},
    {"id":"3","input":"120","expectedOutput":"21","hidden":false},
    {"id":"4","input":"0","expectedOutput":"0","hidden":false}
  ]'::jsonb,
  hidden_test_cases = '[
    {"id":"5","input":"1534236469","expectedOutput":"0","hidden":true},
    {"id":"6","input":"-2147483648","expectedOutput":"0","hidden":true}
  ]'::jsonb
WHERE slug = 'reverse-integer';

-- Comment
COMMENT ON TABLE problems IS 'Updated with comprehensive test cases for top 15 priority problems - Week 2';

-- Summary
SELECT 
  COUNT(*) as problems_updated,
  SUM(jsonb_array_length(test_cases)) as total_visible_tests,
  SUM(jsonb_array_length(hidden_test_cases)) as total_hidden_tests
FROM problems
WHERE slug IN (
  'two-sum', 'valid-parentheses', 'binary-search', 'reverse-linked-list',
  'best-time-buy-sell-stock', 'linked-list-cycle', 'climbing-stairs',
  'merge-sorted-array', 'valid-palindrome', 'symmetric-tree',
  'first-bad-version', 'single-number', '3sum', 'longest-common-prefix',
  'reverse-integer'
);
