# Daily Planner Feature

## Overview
A floating daily task planner that helps users organize and track their daily coding tasks.

## Features

### Task Management
- ✅ Add tasks with custom titles
- ✅ Select specific dates for tasks
- ✅ Three status categories: Ongoing, Completed, Missed
- ✅ Delete tasks when no longer needed

### User Interface
- **Floating Button**: Fixed bottom-right corner when closed
- **Side Panel**: Slides in from the right (400px width on desktop, full width on mobile)
- **Date Picker**: Calendar input for selecting task dates
- **Tabbed View**: Switch between Ongoing, Completed, and Missed tasks
- **Task Counts**: Shows number of tasks in each category

### Task States
1. **Ongoing** - Tasks currently in progress
   - Can mark as Completed or Missed
   - Default state for new tasks

2. **Completed** - Successfully finished tasks
   - Green badge indicator
   - Read-only display

3. **Missed** - Tasks that weren't completed
   - Red badge indicator
   - Read-only display

## Database Setup

Run this SQL in Supabase SQL Editor:

```sql
-- Create daily_tasks table
CREATE TABLE IF NOT EXISTS daily_tasks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  date DATE NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('ongoing', 'completed', 'missed')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_daily_tasks_user_id ON daily_tasks(user_id);
CREATE INDEX IF NOT EXISTS idx_daily_tasks_date ON daily_tasks(user_id, date);

-- Enable RLS
ALTER TABLE daily_tasks ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Users can view own tasks" ON daily_tasks
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own tasks" ON daily_tasks
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own tasks" ON daily_tasks
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own tasks" ON daily_tasks
  FOR DELETE USING (auth.uid() = user_id);
```

## Usage

### Opening the Planner
- Click the "Daily Planner" button in the bottom-right corner of the dashboard

### Adding a Task
1. Enter task title in the input field
2. Select a date (defaults to today)
3. Click "Add" button or press Enter

### Managing Tasks
- **Switch Tabs**: Click Ongoing/Completed/Missed to filter tasks
- **Mark Complete**: Click "Completed" button on ongoing tasks
- **Mark Missed**: Click "Missed" button on ongoing tasks
- **Delete**: Click trash icon on any task

### Closing the Planner
- Click the X button in the top-right corner
- Planner state is preserved (tasks remain)

## Technical Details

### Component Location
`src/components/ui/DailyPlanner.tsx`

### Dependencies
- React hooks (useState, useEffect)
- Supabase client for database operations
- Shadcn UI components (Button, Input)
- Toast notifications for user feedback
- Auth context for user identification

### State Management
- Local state for tasks array
- Real-time sync with Supabase database
- Automatic reload on date change
- Optimistic UI updates

### Styling
- Tailwind CSS classes
- Fixed positioning for floating button
- Responsive design (full-width on mobile)
- Dark theme compatible
- Smooth transitions

## Data Privacy
- Row Level Security (RLS) ensures users only see their own tasks
- All database operations filtered by authenticated user ID
- Automatic cascade delete when user account is deleted

## Future Enhancements
- [ ] Drag and drop to reorder tasks
- [ ] Task priorities (high/medium/low)
- [ ] Recurring tasks
- [ ] Task categories/tags
- [ ] Due time (not just date)
- [ ] Task notes/descriptions
- [ ] Export tasks to calendar
- [ ] Task templates
- [ ] Keyboard shortcuts
- [ ] Mobile app version
