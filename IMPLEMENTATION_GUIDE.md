# Per-User Data Implementation Guide

This guide explains the per-user data tracking system that has been implemented in Babua Dojo.

## Overview

Each user now has their own:
- **Profile**: Streak count, total problems solved, time spent
- **Problem Progress**: Which problems they've solved, attempts, time taken
- **Track Progress**: Progress percentage per track (DSA, System Design, etc.)
- **Daily Activity**: Problems solved per day for streak calculation

## Database Schema

### Tables Created

1. **user_profiles**
   - Stores user stats: streak, total solved, time spent
   - Auto-created when user signs up
   
2. **user_problem_progress**
   - Tracks each problem: solved status, attempts, time spent
   - One row per user per problem
   
3. **user_track_progress**
   - Progress percentage per track
   - Problems solved count per track
   
4. **user_daily_activity**
   - Daily activity for streak calculation
   - One row per user per day

## Setup Instructions

### Step 1: Run Migration in Supabase

1. Go to your Supabase project dashboard
2. Navigate to **SQL Editor**
3. Open the file: `supabase/migrations/20231229_user_data.sql`
4. Copy all the SQL content
5. Paste it into the SQL Editor
6. Click **Run** to execute the migration

This will:
- Create all 4 tables
- Set up Row Level Security (RLS) policies
- Create indexes for performance
- Add automatic user profile creation trigger
- Create streak calculation function

### Step 2: Verify Tables

After running the migration, verify in Supabase:

1. Go to **Table Editor**
2. You should see these new tables:
   - `user_profiles`
   - `user_problem_progress`
   - `user_track_progress`
   - `user_daily_activity`

### Step 3: Test the System

1. **Sign up a new account** - Should auto-create profile
2. **Solve a problem** - Click Submit on any problem
3. **Check Dashboard** - Should show your real streak and progress
4. **View Track Progress** - Should show problems you've solved

## Features Implemented

### Dashboard
- Shows **real streak** from database (not mock data)
- Displays **actual problems solved** count
- Shows **time spent** across all problems
- Track progress cards show **real percentages**

### Track Detail Page
- Problems you've solved have ✓ checkmark
- Progress calculated from your actual data

### Problem Solver
- **Submit button** marks problems as solved
- Updates your profile stats automatically
- Increments streak on first solve of the day
- Tracks time spent per problem

## API Functions

Located in `src/lib/userDataService.ts`:

```typescript
// Get user profile
getUserProfile(userId)

// Mark problem as solved (also updates streak & progress)
markProblemSolved(userId, problemId, trackSlug, difficulty, timeSpent)

// Get user's solved problems
getUserProblemProgress(userId)

// Get track progress
getUserTrackProgress(userId)
```

## How Streaks Work

1. When you solve your **first problem of the day**, streak is updated
2. If last activity was **yesterday** → streak continues (+1)
3. If last activity was **today** → no change (already counted)
4. If last activity was **2+ days ago** → streak resets to 1
5. **Longest streak** is tracked separately

## Data Privacy

- **Row Level Security (RLS)** is enabled on all tables
- Users can only see/edit their own data
- Queries automatically filter by authenticated user ID

## Testing Checklist

- [ ] Sign up new account → Check if profile created
- [ ] Solve a problem → Check if marked as solved
- [ ] Check Dashboard → See real streak and stats
- [ ] Solve problem on new day → Verify streak increments
- [ ] View track page → See checkmarks on solved problems
- [ ] Log out and log in → Data persists

## Troubleshooting

### Migration fails
- Check if tables already exist (drop them first)
- Verify you're connected to the correct Supabase project
- Check SQL Editor for specific error messages

### Profile not created on signup
- Check if trigger `on_auth_user_created` exists
- Verify in SQL: `SELECT * FROM user_profiles WHERE id = 'your-user-id'`

### Progress not saving
- Check browser console for errors
- Verify RLS policies allow INSERT/UPDATE
- Check if user is authenticated

### Streak not updating
- Check `user_daily_activity` table for entries
- Verify `update_user_streak` function exists
- Check last_activity_date in user_profiles

## Future Enhancements

Potential additions:
- Weekly/monthly stats
- Problem difficulty breakdown
- Time-of-day activity heatmap
- Social features (compare with friends)
- Achievement badges
- Learning path recommendations based on solved problems

## Support

If you encounter issues:
1. Check browser console for errors
2. Verify Supabase project is running
3. Check SQL logs in Supabase dashboard
4. Ensure all migrations ran successfully
