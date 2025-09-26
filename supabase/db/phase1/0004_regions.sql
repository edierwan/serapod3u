-- 0004_regions.sql
-- Phase: 1
-- Generated: 2025-09-25T17:40:10.006146Z
-- Purpose: Malaysia regions (int PK) + per-negeri uniqueness

-- 0004_regions.sql
-- Malaysia regions

create table if not exists public.master_negeri (
  id integer primary key,
  code text unique,
  name text not null
);

create table if not exists public.master_daerah (
  id integer primary key,
  negeri_id integer not null references public.master_negeri(id) on delete cascade,
  name text not null
);

do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'uq_daerah_per_negeri') then
    alter table public.master_daerah
      add constraint uq_daerah_per_negeri unique (negeri_id, name);
  end if;
end $$;

