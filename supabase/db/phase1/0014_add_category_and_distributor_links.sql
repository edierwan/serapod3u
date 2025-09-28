-- Add category_id to distributors and shops, add distributor_id to shops, add indexes and constraints
-- Migration: 0014_add_category_and_distributor_links.sql

-- Distributors: Add category_id
ALTER TABLE public.distributors
ADD COLUMN IF NOT EXISTS category_id uuid REFERENCES public.categories(id) ON UPDATE CASCADE ON DELETE SET NULL;

-- Distributors: Add unique index on lower(name)
CREATE UNIQUE INDEX IF NOT EXISTS distributors_name_ci_uidx ON public.distributors (lower(name));

-- Distributors: Add indexes for filters
CREATE INDEX IF NOT EXISTS idx_distributors_category ON public.distributors (category_id);
CREATE INDEX IF NOT EXISTS idx_distributors_active ON public.distributors (is_active);

-- Shops: Add distributor_id (authoritative link)
ALTER TABLE public.shops
ADD COLUMN IF NOT EXISTS distributor_id uuid REFERENCES public.distributors(id) ON UPDATE CASCADE ON DELETE CASCADE;

-- Shops: Add category_id
ALTER TABLE public.shops
ADD COLUMN IF NOT EXISTS category_id uuid REFERENCES public.categories(id) ON UPDATE CASCADE ON DELETE SET NULL;

-- Shops: Ensure is_active is standardized (already exists, but confirm)
-- ALTER TABLE public.shops ALTER COLUMN is_active SET DEFAULT true; -- Already has default

-- Shops: Add unique index on (distributor_id, lower(name))
CREATE UNIQUE INDEX IF NOT EXISTS shops_distributor_name_ci_uidx ON public.shops (distributor_id, lower(name));

-- Shops: Add filter indexes
CREATE INDEX IF NOT EXISTS idx_shops_distributor ON public.shops (distributor_id);
CREATE INDEX IF NOT EXISTS idx_shops_category ON public.shops (category_id);
CREATE INDEX IF NOT EXISTS idx_shops_active ON public.shops (is_active);