# Database Migration Instructions

## Issue: Interview Profiles Table Not Found

If you're seeing 406/400 errors for `interview_profiles` table, you need to run the migration.

### Quick Fix:

1. **Open Supabase Dashboard**
   - Go to your project: https://supabase.com/dashboard/project/ksfrhktwinymgrtssczf

2. **Navigate to SQL Editor**
   - Click "SQL Editor" in the left sidebar

3. **Run the Migration**
   - Copy the entire content of `supabase/migrations/20250104_interview_prep_complete.sql`
   - Paste into the SQL Editor
   - Click "Run"

### Or use Supabase CLI:

```powershell
# If you have Supabase CLI installed
supabase db push

# Or run specific migration
supabase migration up --db-url "your-database-url"
```

### Verify Migration:

After running, check that these tables exist:
- ✅ `interview_profiles`
- ✅ `interview_sessions`
- ✅ `interview_feedback`
- ✅ `interview_matching_queue`

### Alternative: Continue Without Interview Prep

The error is now handled gracefully. The InterviewMatching page will:
- Show empty peer list if table doesn't exist
- Still allow AI Practice mode to work
- Display a friendly message instead of crashing

The AI Practice tab will work without any database migration since it uses the existing `ai_interview_sessions` table.
