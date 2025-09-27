-- 0010_add_product_groups_name_unique.sql
-- Phase: 1
-- Generated: 2025-09-27
-- Purpose: Add unique constraint on product_groups name to prevent duplicates

-- First, handle any existing duplicates by keeping the first one and updating others
do $$
declare
  dup_record record;
begin
  -- For each duplicate name, keep the one with the smallest ID and update others
  for dup_record in
    select name, array_agg(id order by id) as ids
    from public.product_groups
    group by name
    having count(*) > 1
  loop
    -- Update all but the first ID to have a suffix
    update public.product_groups
    set name = name || ' (duplicate ' || (row_number() over (order by id) - 1) || ')'
    where id = any(dup_record.ids[2:])
      and name = dup_record.name;
  end loop;
end $$;

-- Now add the unique constraint
do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'product_groups_name_key') then
    alter table public.product_groups
      add constraint product_groups_name_key unique (name);
  end if;
end $$;