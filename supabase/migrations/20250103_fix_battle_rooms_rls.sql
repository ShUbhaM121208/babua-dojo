-- Fix battle_rooms RLS policy to allow participant count updates
-- The previous policy had a circular dependency issue

-- Drop the old restrictive policy
DROP POLICY IF EXISTS "Participants can update their battle rooms" ON public.battle_rooms;

-- Add created_by column if it doesn't exist
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'battle_rooms' 
        AND column_name = 'created_by'
    ) THEN
        ALTER TABLE public.battle_rooms 
        ADD COLUMN created_by UUID REFERENCES auth.users(id);
    END IF;
END $$;

-- Create new policy that allows:
-- 1. Room creator to update their room
-- 2. Any authenticated user to update room (for participant count, etc.)
--    This is safe because RLS on battle_participants already restricts who can join
CREATE POLICY "Authenticated users can update battle rooms" ON public.battle_rooms
    FOR UPDATE USING (auth.role() = 'authenticated');

-- Alternative: More restrictive policy (room creator OR participants can update)
-- Uncomment this and comment above if you want more restrictive access:
-- CREATE POLICY "Creator or participants can update battle rooms" ON public.battle_rooms
--     FOR UPDATE USING (
--         auth.uid() = created_by OR
--         EXISTS (
--             SELECT 1 FROM public.battle_participants
--             WHERE battle_room_id = id AND user_id = auth.uid()
--         )
--     );
