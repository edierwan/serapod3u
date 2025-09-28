-- Add category_id column to brands table
-- This allows brands to be associated with categories

do $$ begin
  -- Add category_id column if it doesn't exist
  if not exists (select 1 from information_schema.columns
                 where table_name = 'brands' and column_name = 'category_id') then
    alter table public.brands add column category_id uuid;
  end if;

  -- Add foreign key constraint if it doesn't exist
  if not exists (select 1 from pg_constraint
                 where conname = 'brands_category_id_fkey') then
    alter table public.brands
    add constraint brands_category_id_fkey
    foreign key (category_id) references public.categories(id) on delete restrict;
  end if;

  -- Add index on category_id for performance
  if not exists (select 1 from pg_indexes
                 where tablename = 'brands' and indexname = 'idx_brands_category_id') then
    create index idx_brands_category_id on public.brands(category_id);
  end if;

end $$;