# 🚀 Quick Start: Time Travel Submissions

## Step 1: Run Database Migration

1. Open Supabase Dashboard: https://supabase.com/dashboard
2. Navigate to **SQL Editor**
3. Click **New Query**
4. Copy contents of `supabase/migrations/20250105_submission_versioning.sql`
5. Click **Run** (or press Ctrl+Enter)
6. Verify success: Should see "Success. No rows returned"

## Step 2: Verify Tables Created

Run this query in SQL Editor:
```sql
-- Check tables exist
SELECT table_name 
FROM information_schema.tables 
WHERE table_name IN ('problem_submissions', 'user_problem_progress', 'latest_submissions', 'submission_stats');

-- Should return 4 rows
```

## Step 3: Test the Feature

### Submit Code
1. Navigate to any problem: http://localhost:5173/problem/two-sum
2. Write some code in the editor
3. Click "Submit" button
4. Wait for results

### View Submission History
1. Click on **"Submissions"** tab (next to Description)
2. You should see:
   - Stats cards at top (Total Attempts, Success Rate, etc.)
   - Timeline of your submissions below
   - Each submission card shows version, status, time, test results

### Compare Versions
1. In the Submissions tab, check the checkbox on **2 different versions**
2. Click **"Compare v1 vs v2"** button that appears
3. You'll see:
   - Side-by-side diff view
   - Stats comparison (similarity, lines changed, tests, time)
   - Three view modes: Side by Side, Unified, Full Code

### Load Old Code
1. In any submission card, click **"Load Code"** button
2. The code from that version will be loaded into the editor
3. You can now run or modify it

### View Analytics
1. In Submissions tab, click **"Analytics"** tab
2. See improvement graphs:
   - Tests passed over time
   - Execution time trends

## Step 4: Test Different Scenarios

### Scenario 1: Progressive Improvement
```javascript
// Version 1 - Wrong approach
function twoSum(nums, target) {
  return [0, 1]; // Hardcoded
}

// Submit → Should fail some tests

// Version 2 - Better but slow
function twoSum(nums, target) {
  for (let i = 0; i < nums.length; i++) {
    for (let j = i + 1; j < nums.length; j++) {
      if (nums[i] + nums[j] === target) return [i, j];
    }
  }
}

// Submit → Should pass more tests

// Version 3 - Optimal
function twoSum(nums, target) {
  const map = new Map();
  for (let i = 0; i < nums.length; i++) {
    const complement = target - nums[i];
    if (map.has(complement)) return [map.get(complement), i];
    map.set(nums[i], i);
  }
}

// Submit → Should pass all tests
```

Now:
- Check Submissions tab
- Compare v1 vs v3
- See the improvement graph
- Check success rate

### Scenario 2: Different Languages
1. Submit Python solution
2. Submit JavaScript solution
3. Compare them (will show language difference)

### Scenario 3: Replay Old Code
1. Load an old version
2. Modify it slightly
3. Submit again
4. Compare with original

## Step 5: Verify Data in Database

Run these queries:
```sql
-- See all your submissions
SELECT version, language, status, passed_count, submitted_at
FROM problem_submissions
WHERE user_id = auth.uid()
ORDER BY submitted_at DESC;

-- Check your stats
SELECT *
FROM submission_stats
WHERE user_id = auth.uid();

-- See your progress
SELECT *
FROM user_problem_progress
WHERE user_id = auth.uid();
```

## 🐛 Troubleshooting

### Issue: "No submissions yet" message
**Solution**: Make sure you're signed in and have submitted code

### Issue: Tabs not showing
**Solution**: Refresh the page after migration

### Issue: Supabase type errors
**Solution**: This is normal before migration. Run the migration, then errors will go away.

### Issue: Charts not rendering
**Solution**: Make sure you have at least 2 submissions for graphs to show

### Issue: Compare button not appearing
**Solution**: Select exactly 2 versions by checking the checkboxes

## 📊 Expected Results

After 3 submissions, you should see:
- **Total Attempts**: 3
- **Success Rate**: 33% (if only last one passed)
- **Best Time**: ~150ms
- **First Success**: v3
- **Timeline**: 3 cards showing v3, v2, v1
- **Graph**: Line showing improvement from 0 → 2 → 5 tests passed

## 🎯 Key Features to Test

- [x] Submission versioning (auto-increments)
- [x] Status badges (green for accepted, red for failed)
- [x] Timeline sorting (latest first)
- [x] Stats calculation (attempts, success rate, best time)
- [x] Checkbox selection (max 2 at a time)
- [x] Compare button appears
- [x] Side-by-side diff with colors
- [x] Unified diff with +/- markers
- [x] Full code with syntax highlighting
- [x] Load code functionality
- [x] Replay button in diff viewer
- [x] Back navigation
- [x] Analytics charts
- [x] Responsive design

## 🎉 Success Criteria

Feature is working if you can:
1. ✅ Submit code multiple times
2. ✅ See all submissions in timeline
3. ✅ Select 2 versions and compare
4. ✅ See color-coded differences
5. ✅ Load old code back into editor
6. ✅ View analytics graphs
7. ✅ See accurate stats (attempts, success rate, etc.)

## 📞 Need Help?

Check the full documentation: `TIME_TRAVEL_SUBMISSIONS_COMPLETE.md`

---

**Happy Time Traveling! 🕐**
