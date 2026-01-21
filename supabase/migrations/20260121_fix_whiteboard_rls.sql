-- Fix RLS policy for whiteboard_rooms to allow solvers to update/close their rooms
DROP POLICY IF EXISTS "Solvers can update own rooms" ON public.whiteboard_rooms;

CREATE POLICY "Solvers can update own rooms"
  ON public.whiteboard_rooms
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = solver_id)
  WITH CHECK (auth.uid() = solver_id);
