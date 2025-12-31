# 🚀 Quick Start - Per-User Data Setup

## Step 1: Run Migration (5 minutes)

1. Go to [Supabase Dashboard](https://supabase.com/dashboard)
2. Select your **babua-dojo** project
3. Click **SQL Editor** in sidebar
4. Open `supabase/migrations/20231229_user_data.sql`
5. Copy all SQL code
6. Paste into SQL Editor
7. Click **Run**

## Step 1.5: Add Daily Planner (Optional - 2 minutes)

1. In **SQL Editor**, create a new query
2. Open `supabase/migrations/20231229_daily_planner.sql`
3. Copy all SQL code
4. Paste and click **Run**
5. This adds the Daily Planner feature to your dashboard

## Step 2: Verify (1 minute)

Go to **Table Editor** and check for these tables:
- ✅ `user_profiles`
- ✅ `user_problem_progress`
- ✅ `user_track_progress`
- ✅ `user_daily_activity`
- ✅ `daily_tasks` (if you ran the daily planner migration)

## Step 3: Test (2 minutes)

1. **Sign up** with new account
2. **Solve a problem** (click Submit)
3. **Check Dashboard** → See your streak & stats!

---

## 🎯 What You Get

### Before
- ❌ All users see same mock data
- ❌ Progress not saved
- ❌ Fake streaks
- ❌ No task planning

### After
- ✅ Each user has separate data
- ✅ Progress saved to database
- ✅ Real streak tracking
- ✅ Per-user problem completion
- ✅ Track progress percentages
- ✅ Daily task planner with tracking

---

## 📊 Key Features

| Feature | Description |
|---------|-------------|
| **Streaks** | Auto-increments on first daily solve |
| **Problem Tracking** | Marks solved with ✓ checkmark |
| **Progress** | Real percentages per track |
| **Time Tracking** | Total time spent solving |
| **Security** | RLS ensures data privacy |
| **Daily Planner** | Plan and track daily tasks with 3 states |

---

## 🐛 Troubleshooting

### Migration Error
```sql
-- If tables exist, drop first:
DROP TABLE IF EXISTS user_profiles CASCADE;
DROP TABLE IF EXISTS user_problem_progress CASCADE;
DROP TABLE IF EXISTS user_track_progress CASCADE;
DROP TABLE IF EXISTS user_daily_activity CASCADE;
-- Then re-run migration
```

### Profile Not Created
Check auth trigger:
```sql
SELECT * FROM pg_trigger WHERE tgname = 'on_auth_user_created';
```

### Check Your Data
```sql
-- See your profile
SELECT * FROM user_profiles WHERE id = auth.uid();

-- See solved problems
SELECT * FROM user_problem_progress 
WHERE user_id = auth.uid() AND solved = true;
```

---

## 📖 Full Documentation

- **Setup Guide**: `IMPLEMENTATION_GUIDE.md`
- **Summary**: `IMPLEMENTATION_SUMMARY.md`
- **Migration File**: `supabase/migrations/20231229_user_data.sql`
- **API Functions**: `src/lib/userDataService.ts`

---

## 🎉 You're Ready!

After migration:
1. Every user tracks their own progress
2. Streaks calculate automatically
3. Dashboard shows real stats
4. Problems stay marked as solved

**Happy coding! 🚀**
