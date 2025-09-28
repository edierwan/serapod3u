-- 0012_add_manufacturer_name_unique_index.sql
-- Phase: 1
-- Purpose: Add unique functional index on manufacturers for case-insensitive name checking

-- Add unique functional index on (lower(name)) for manufacturers
-- This ensures case-insensitive uniqueness without requiring a denormalized column
do $$ begin
  if not exists (select 1 from pg_indexes where tablename = 'manufacturers' and indexname = 'idx_manufacturers_name_lower_unique') then
    create unique index idx_manufacturers_name_lower_unique on public.manufacturers (lower(name));
  end if;
end $$;