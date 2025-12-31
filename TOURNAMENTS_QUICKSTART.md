# Quick Start: Tournament System

## 1. Run the Migration

```bash
# Connect to your Supabase database
cd supabase/migrations

# Run the tournament migration
psql -U postgres -h your-db-host -d your-database -f 20250105_tournaments.sql
```

## 2. Set Up Auto-Status Updates

```sql
-- Enable pg_cron if not already enabled
CREATE EXTENSION IF NOT EXISTS pg_cron;

-- Schedule status updates every 5 minutes
SELECT cron.schedule(
  'update-tournament-status',
  '*/5 * * * *',
  'SELECT update_tournament_status()'
);
```

## 3. Create a Test Tournament

```sql
INSERT INTO tournaments (
  title,
  description,
  start_time,
  end_time,
  difficulty,
  is_rated,
  prize_pool,
  max_participants,
  problem_ids,
  rules,
  status
) VALUES (
  'New Year Coding Challenge 2025',
  'Welcome the new year with an exciting coding challenge! Solve problems and win prizes.',
  NOW() + INTERVAL '2 hours',  -- Starts in 2 hours
  NOW() + INTERVAL '4 hours',  -- Runs for 2 hours
  'medium',
  true,
  25000,  -- ₹25,000 prize pool
  50,     -- Max 50 participants
  ARRAY['problem-uuid-1', 'problem-uuid-2', 'problem-uuid-3'],  -- Replace with real problem IDs
  'Standard competitive programming rules apply. Each wrong submission adds a 20-minute penalty.',
  'upcoming'
);
```

## 4. Test the UI

1. **Navigate to Tournaments Page**:
   ```
   http://localhost:5173/tournaments
   ```

2. **Test User Flow**:
   - Browse tournaments (upcoming/live/completed tabs)
   - Click on a tournament card
   - Register for the tournament
   - View leaderboard
   - Check calendar view
   - Use search and filters

3. **Test Live Mode** (when tournament is live):
   - Enter live tournament mode
   - See countdown timer
   - View problem list
   - Track progress
   - Check real-time leaderboard

## 5. Verify Database

```sql
-- Check tournament created
SELECT * FROM tournaments;

-- Check tables exist
\dt tournament*

-- Verify triggers
SELECT * FROM pg_trigger WHERE tgname LIKE '%tournament%';

-- Test leaderboard calculation
SELECT * FROM tournament_leaderboard;
```

## 6. Test Registration

```sql
-- Manually register a user (replace UUIDs)
INSERT INTO tournament_registrations (tournament_id, user_id, status)
VALUES ('tournament-uuid', 'user-uuid', 'registered');

-- Check registration count
SELECT COUNT(*) FROM tournament_registrations 
WHERE tournament_id = 'tournament-uuid' 
AND status = 'registered';
```

## 7. Test Status Transitions

```sql
-- Manually trigger status update
SELECT update_tournament_status();

-- Or update specific tournament
UPDATE tournaments 
SET status = 'live' 
WHERE id = 'tournament-uuid';
```

## 8. Test Leaderboard

```sql
-- Add test submission
INSERT INTO tournament_submissions (
  tournament_id,
  user_id,
  problem_id,
  language,
  code,
  status,
  passed_count,
  failed_count,
  total_test_cases,
  total_time,
  penalty_time
) VALUES (
  'tournament-uuid',
  'user-uuid',
  'problem-uuid',
  'javascript',
  'console.log("hello")',
  'accepted',
  10,
  0,
  10,
  15.5,  -- 15.5 minutes
  0      -- No penalty
);

-- Check leaderboard updated
SELECT * FROM tournament_leaderboard 
WHERE tournament_id = 'tournament-uuid'
ORDER BY rank;
```

## Common Issues & Solutions

### Issue: Migration fails
**Solution**: Check if tables already exist. Drop them if needed:
```sql
DROP TABLE IF EXISTS tournament_editorials CASCADE;
DROP TABLE IF EXISTS tournament_prizes CASCADE;
DROP TABLE IF EXISTS tournament_leaderboard CASCADE;
DROP TABLE IF EXISTS tournament_submissions CASCADE;
DROP TABLE IF EXISTS tournament_registrations CASCADE;
DROP TABLE IF EXISTS tournaments CASCADE;
```

### Issue: Status doesn't update automatically
**Solution**: Check cron job is running:
```sql
SELECT * FROM cron.job;
-- If not scheduled, run the schedule command from step 2
```

### Issue: Leaderboard not updating
**Solution**: Check triggers exist:
```sql
SELECT * FROM pg_trigger WHERE tgname = 'trigger_update_leaderboard';
-- If missing, re-run migration
```

### Issue: Can't see tournaments in UI
**Solution**: 
1. Check database connection in browser console
2. Verify RLS policies allow SELECT
3. Check Supabase types are generated:
   ```bash
   npx supabase gen types typescript --local > src/integrations/supabase/types.ts
   ```

### Issue: Registration fails
**Solution**: Check max_participants not exceeded:
```sql
SELECT 
  t.title,
  t.max_participants,
  COUNT(tr.id) as current_count
FROM tournaments t
LEFT JOIN tournament_registrations tr ON t.id = tr.tournament_id
WHERE t.id = 'tournament-uuid'
GROUP BY t.id, t.title, t.max_participants;
```

## Feature Checklist

After setup, verify these features work:

- [ ] Tournament list displays
- [ ] Can filter by status (upcoming/live/completed)
- [ ] Can search tournaments
- [ ] Can filter by difficulty
- [ ] Calendar view shows tournaments
- [ ] Tournament details page loads
- [ ] Can register for tournament
- [ ] Can withdraw registration
- [ ] Leaderboard displays correctly
- [ ] Countdown timer works
- [ ] Live mode accessible when tournament is live
- [ ] Problem list displays in live mode
- [ ] Progress bar updates
- [ ] Recent submissions show
- [ ] Real-time leaderboard updates (every 30s)

## Next Steps

Once basic functionality is verified:

1. **Add Real Problems**: Replace mock problem IDs with actual problems from your `problems` table
2. **Test End-to-End**: Register → Enter Live Mode → Submit Solution → Check Leaderboard
3. **Add More Tournaments**: Create tournaments at different times to test all states
4. **Monitor Performance**: Check leaderboard query performance with many participants
5. **Set Up Notifications**: Add email/push notifications for tournament start
6. **Create Admin Interface**: Build UI for creating/managing tournaments

## Support

If you encounter issues:

1. Check browser console for errors
2. Check database logs
3. Verify all migrations ran successfully
4. Ensure RLS policies are correct
5. Test with different user accounts
6. Check network requests in DevTools

## Quick Links

- Full Documentation: `TOURNAMENTS_COMPLETE.md`
- Implementation Summary: `WEEK13_TOURNAMENTS_SUMMARY.md`
- Database Schema: `supabase/migrations/20250105_tournaments.sql`
- Service Layer: `src/services/tournamentService.ts`
- Main Page: `src/pages/Tournaments.tsx`

---

**Ready to compete!** 🏆
