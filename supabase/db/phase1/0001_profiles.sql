-- 0001_profiles.sql
-- Phase: 1
-- Generated: 2025-09-25T17:40:10.006146Z
-- Purpose: role enum + profiles + RLS (self + admin read-all)

-- 0001_profiles.sql
-- role enum + profiles + RLS

do $$ begin
  create type role_code as enum ('hq_admin','power_user','manufacturer','warehouse','distributor','shop');
exception when duplicate_object then null; end $$;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  role_code role_code not null,
  full_name text,
  avatar_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- updated_at helper (idempotent)
create or replace function public.set_updated_at()
returns trigger language plpgsql as $fn$
begin
  new.updated_at := now();
  return new;
end $fn$;

do $$ begin
  create trigger trg_profiles_updated_at
  before update on public.profiles
  for each row execute function public.set_updated_at();
exception when duplicate_object then null; end $$;

alter table public.profiles enable row level security;

drop policy if exists profiles_self_select on public.profiles;
create policy profiles_self_select on public.profiles
for select to authenticated using (id = auth.uid());

drop policy if exists profiles_self_update on public.profiles;
create policy profiles_self_update on public.profiles
for update to authenticated
using (id = auth.uid()) with check (id = auth.uid());

drop policy if exists profiles_admin_read_all on public.profiles;
create policy profiles_admin_read_all on public.profiles
for select to authenticated
using (coalesce((current_setting('request.jwt.claims', true)::jsonb ->> 'role'),'')
       in ('hq_admin','power_user'));
