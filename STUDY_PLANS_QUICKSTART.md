# Study Plans - Quick Start Guide

## 🚀 Getting Started

### Step 1: Run Database Migration
```bash
# Navigate to your project directory
cd babua-dojo

# Run the migration
psql -h <your-supabase-host> -U postgres -d postgres -f supabase/migrations/20250101_study_plans.sql

# OR via Supabase CLI
supabase migration up
```

### Step 2: Create Template Plans
Access the Supabase dashboard and insert template plans:

```sql
-- Example: "30 Days to Interview Ready" Template
INSERT INTO study_plans (
  title,
  description,
  difficulty,
  estimated_days,
  is_template,
  is_public,
  created_by,
  target_topics,
  problems_per_day
) VALUES (
  '30 Days to Interview Ready',
  'A comprehensive 30-day plan covering all essential DSA topics for technical interviews',
  'intermediate',
  30,
  true,
  true,
  'admin',
  ARRAY['arrays', 'strings', 'dynamic-programming', 'graphs', 'trees'],
  3
);

-- Add items to the template
-- (Repeat for Days 1-30 with relevant problems)
INSERT INTO study_plan_items (
  plan_id,
  item_type,
  item_id,
  title,
  day_number,
  order_in_day,
  problem_difficulty,
  problem_tags,
  estimated_time_minutes
) VALUES (
  '<template-plan-id>',
  'problem',
  'two-sum',
  'Two Sum',
  1,
  1,
  'easy',
  ARRAY['arrays', 'hash-table'],
  30
);
```

### Step 3: Access the Feature
1. Navigate to `http://localhost:5173/study-plans`
2. You should see the Study Plans page with three tabs
3. Try creating your first plan!

---

## 📖 User Guide

### Creating a Study Plan

1. **From Scratch**:
   - Click "Create Plan" button
   - Fill in: Title, Description, Difficulty, Duration
   - Add topic tags (optional)
   - Set daily target (default: 3 items)
   - Click "Create"

2. **From Template**:
   - Go to "Templates" tab
   - Browse available templates
   - Click "Clone" on desired template
   - Customize if needed

3. **From AI Recommendations**:
   - Go to "AI Recommendations" tab
   - Review personalized suggestions
   - Click "Accept" to add to your plans

### Managing Your Plans

#### Starting a Plan
1. Find your plan in "My Plans"
2. Click the ⋮ menu button
3. Select "Start Plan"
4. The plan status changes to "Active"

#### Completing Daily Tasks
1. **From Dashboard**:
   - See "Today's Study Tasks" widget
   - Check off completed items
   - Click task title to open problem

2. **From Study Plans Page**:
   - Open your active plan
   - Expand the current day
   - Mark items as complete

#### Tracking Progress
- **Progress Chart**: Visual representation of daily completion
- **Mood Tracker**: Record how you're feeling each day
- **Stats**: View items completed, time spent, streak

### Study Buddies

#### Inviting a Buddy
1. Go to "Study Buddies" section
2. Enter their email address
3. Click "Send"
4. They'll receive a request

#### Managing Requests
- **Incoming**: Accept ✓ or Reject ✗
- **Active Buddies**: View their progress
- **Group Stats**: See combined achievements

---

## 🎯 Best Practices

### For Maximum Success:

1. **Start Small**
   - Begin with a 7-day or 14-day plan
   - Don't overwhelm yourself
   - Build consistency first

2. **Be Realistic**
   - Set achievable daily targets (2-3 problems)
   - Account for your schedule
   - Include rest days if needed

3. **Track Your Mood**
   - Record daily how you're feeling
   - Identify patterns (productive days, struggles)
   - Adjust plan based on insights

4. **Use Study Buddies**
   - Accountability boosts completion rates
   - Share struggles and wins
   - Motivate each other

5. **Review Progress Weekly**
   - Check your progress chart
   - Celebrate milestones
   - Adjust plan if falling behind

---

## 🛠️ Troubleshooting

### Issue: "No tasks showing today"
**Solution**: 
- Ensure your plan status is "Active"
- Check if the plan has a start_date set
- Verify you're on the correct day (day_number matches days since start)

### Issue: "Can't clone template"
**Solution**:
- Check if you're logged in
- Verify template is marked as public
- Try refreshing the page

### Issue: "Study buddy not found"
**Solution**:
- Confirm the email is correct
- Ask them to sign up first
- Check spelling of email address

### Issue: "Tasks not updating"
**Solution**:
- Refresh the page
- Check network connection
- Verify Supabase is connected
- Look for console errors

---

## 💡 Tips & Tricks

### Time Management
- Morning: Review daily tasks (5 min)
- Focused time: Complete problems (60-90 min)
- Evening: Track progress and mood (5 min)

### Staying Motivated
- ✅ Celebrate small wins
- 🔥 Maintain your streak
- 📊 Visualize progress
- 👥 Share achievements with buddies

### Optimizing Learning
- Mix easy and hard problems
- Focus on weak topics
- Review failed attempts
- Use video explanations

### Study Plan Ideas
- **Topic Deep Dive**: Master one topic (e.g., DP)
- **Company Prep**: Problems from target company
- **Mixed Practice**: Variety for interviews
- **Blind 75**: Classic interview problems
- **Daily Challenge Focus**: Just do daily challenges

---

## 🔧 Developer Notes

### Adding Custom Fields to Plans
Edit `src/lib/studyPlanService.ts`:
```typescript
export interface StudyPlan {
  // ... existing fields
  custom_field?: string;
}
```

Update database:
```sql
ALTER TABLE study_plans ADD COLUMN custom_field TEXT;
```

### Creating New Item Types
Currently supported:
- `problem` - Coding problems
- `topic` - Theory/concepts
- `resource` - Videos, articles
- `milestone` - Achievements

To add new type:
1. Update database constraint
2. Add to TypeScript type
3. Update PlanTimeline component icon logic

### Extending AI Recommendations
Modify `generate_ai_study_plan` RPC function in database to:
- Analyze user's weakness data
- Query problems by topic
- Generate structured plan
- Create recommendation entries

---

## 📊 Analytics & Metrics

### Track These Metrics:
- **Completion Rate**: % of daily tasks completed
- **Streak**: Consecutive days active
- **Time Investment**: Minutes per day
- **Plan Retention**: % of started plans completed
- **Buddy Engagement**: Messages, check-ins

### Export Data:
(Future feature - planned for Phase 5)
- Export plan as PDF
- Download progress CSV
- Share completion certificate

---

## 🎓 Example Study Plans

### 1. Beginner - "First 30 Days"
- **Duration**: 30 days
- **Difficulty**: Beginner
- **Daily Target**: 2 problems
- **Topics**: Arrays, Strings, Basic Math
- **Best For**: Complete beginners

### 2. Intermediate - "FAANG Prep"
- **Duration**: 60 days
- **Difficulty**: Advanced
- **Daily Target**: 3-4 problems
- **Topics**: All DSA + System Design
- **Best For**: Interview preparation

### 3. Focus - "Dynamic Programming Master"
- **Duration**: 21 days
- **Difficulty**: Advanced
- **Daily Target**: 2 problems
- **Topics**: DP patterns
- **Best For**: Mastering one topic

### 4. Consistency - "Daily Practice"
- **Duration**: 90 days
- **Difficulty**: Mixed
- **Daily Target**: 1 problem
- **Topics**: Variety
- **Best For**: Building habit

---

## 🚀 Roadmap & Future Features

### Phase 2 (Q2 2026):
- [ ] AI auto-generation from user weaknesses
- [ ] Drag-and-drop reordering
- [ ] Calendar view
- [ ] Progress heatmap
- [ ] Email reminders

### Phase 3 (Q3 2026):
- [ ] Mobile push notifications
- [ ] Study plan marketplace
- [ ] Collaborative plans
- [ ] Leaderboards
- [ ] Achievement badges

### Phase 4 (Q4 2026):
- [ ] Video course integration
- [ ] Live study sessions
- [ ] Mentor matching
- [ ] Certification programs

---

## 📞 Support & Feedback

### Need Help?
- Check documentation: `/STUDY_PLANS_IMPLEMENTATION.md`
- Open GitHub issue: [Link to repo]
- Contact support: support@babua.lms

### Share Feedback:
- What features do you love?
- What needs improvement?
- Feature requests welcome!

---

## 📜 License & Credits

Study Plans feature developed as part of Babua LMS.

**Contributors**:
- Core Implementation: GitHub Copilot
- UI/UX Design: shadcn/ui components
- Database: Supabase PostgreSQL

---

**Happy Learning! 🎓✨**

Remember: Consistency beats intensity. A little progress every day adds up to big results!
