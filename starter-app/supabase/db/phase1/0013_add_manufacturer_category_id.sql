-- Add category_id column to manufacturers table
-- Migration: 0013_add_manufacturer_category_id

do $$ begin
  -- Add category_id column if it doesn't exist
  if not exists (select 1 from information_schema.columns
                 where table_schema = 'public'
                 and table_name = 'manufacturers'
                 and column_name = 'category_id') then
    alter table public.manufacturers add column category_id uuid;
  end if;

  -- Add foreign key constraint if it doesn't exist
  if not exists (select 1 from pg_constraint
                 where conname = 'manufacturers_category_id_fkey') then
    alter table public.manufacturers
    add constraint manufacturers_category_id_fkey
    foreign key (category_id) references public.categories(id) on delete set null;
  end if;

  -- Add index if it doesn't exist
  if not exists (select 1 from pg_indexes
                 where tablename = 'manufacturers'
                 and indexname = 'idx_manufacturers_category_id') then
    create index idx_manufacturers_category_id on public.manufacturers(category_id);
  end if;
end $$;