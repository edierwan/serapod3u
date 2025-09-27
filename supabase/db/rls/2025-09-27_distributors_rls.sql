-- Enable RLS (already enabled, but keep idempotent)
ALTER TABLE public.distributors ENABLE ROW LEVEL SECURITY;

-- Drop old "hq only" policy
DROP POLICY IF EXISTS hq_all_distributors ON public.distributors;

-- Read policy (HQ & Power User can read all)
CREATE POLICY distributors_admin_read_all
ON public.distributors
FOR SELECT
TO authenticated
USING (app.is_hq_admin() OR app.is_power_user());

-- Insert policy (HQ & Power User can create any row)
CREATE POLICY distributors_admin_insert
ON public.distributors
FOR INSERT
TO authenticated
WITH CHECK (app.is_hq_admin() OR app.is_power_user());

-- Update policy (HQ & Power User can edit any row)
CREATE POLICY distributors_admin_update
ON public.distributors
FOR UPDATE
TO authenticated
USING (app.is_hq_admin() OR app.is_power_user())
WITH CHECK (app.is_hq_admin() OR app.is_power_user());

-- Delete policy (HQ & Power User can delete any row)
CREATE POLICY distributors_admin_delete
ON public.distributors
FOR DELETE
TO authenticated
USING (app.is_hq_admin() OR app.is_power_user());