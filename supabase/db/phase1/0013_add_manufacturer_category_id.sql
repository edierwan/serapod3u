-- 0013_add_manufacturer_category_id.sql
-- Phase: 1
-- Purpose: Add category_id column to manufacturers table with foreign key constraint

-- Add category_id column to manufacturers
do $$ begin
  if not exists (select 1 from information_schema.columns where table_name = 'manufacturers' and column_name = 'category_id') then
    alter table public.manufacturers add column category_id uuid null references public.categories(id) on update cascade on delete set null;
  end if;
end $$;

-- Add index on category_id
do $$ begin
  if not exists (select 1 from pg_indexes where tablename = 'manufacturers' and indexname = 'manufacturers_category_id_idx') then
    create index manufacturers_category_id_idx on public.manufacturers(category_id);
  end if;
end $$;