-- 0007_dev_fastlogin_seed.sql
-- Phase: 1 (Dev only usage by server action - safe in prod since unused)
-- Generated: 2025-09-25T17:40:10.006146Z
-- Purpose: Provide dev-only role→email map used by Fast Login buttons

create table if not exists public.dev_fastlogin_accounts (
  email text primary key,
  role_code role_code not null,
  full_name text default null,
  created_at timestamptz not null default now()
);

insert into public.dev_fastlogin_accounts (email, role_code, full_name) values
('dev_hq_admin@example.com','hq_admin','HQ Admin'),
('dev_power_user@example.com','power_user','Power User'),
('dev_manufacturer@example.com','manufacturer','Manufacturer User'),
('dev_warehouse@example.com','warehouse','Warehouse User'),
('dev_distributor@example.com','distributor','Distributor User'),
('dev_shop@example.com','shop','Shop User')
on conflict (email) do nothing;
