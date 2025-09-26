-- 0002_master_core.sql
-- Phase: 1
-- Generated: 2025-09-25T17:40:10.006146Z
-- Purpose: Core master tables (categories/brands/groups/subgroups/products) and parties

-- Categories
-- 0002_master_core.sql
-- Core masters + parties + products

create table if not exists public.categories (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.brands (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.product_groups (
  id uuid primary key default gen_random_uuid(),
  category_id uuid references public.categories(id) on delete restrict,
  name text not null,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.product_subgroups (
  id uuid primary key default gen_random_uuid(),
  group_id uuid references public.product_groups(id) on delete restrict,
  name text not null,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.manufacturers (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  is_active boolean not null default true,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists public.distributors (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  negeri_id integer,
  daerah_id integer,
  is_active boolean not null default true,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists public.shops (
  id uuid primary key default gen_random_uuid(),
  distributor_id uuid references public.distributors(id) on delete set null,
  name text not null,
  negeri_id integer,
  daerah_id integer,
  is_active boolean not null default true,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists public.manufacturer_users (
  id uuid primary key default gen_random_uuid(),
  manufacturer_id uuid not null references public.manufacturers(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  unique (manufacturer_id, user_id)
);

create table if not exists public.shop_distributors (
  shop_id uuid not null references public.shops(id) on delete cascade,
  distributor_id uuid not null references public.distributors(id) on delete cascade,
  primary key (shop_id, distributor_id)
);

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  category_id uuid references public.categories(id) on delete restrict,
  brand_id uuid references public.brands(id) on delete restrict,
  group_id uuid references public.product_groups(id) on delete restrict,
  sub_group_id uuid references public.product_subgroups(id) on delete restrict,
  manufacturer_id uuid references public.manufacturers(id) on delete restrict,
  name text not null,
  name_ci text generated always as (lower(coalesce(name,''))) stored,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- unique only if missing
do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'uq_product_tuple') then
    alter table public.products
      add constraint uq_product_tuple
      unique (category_id, brand_id, group_id, sub_group_id, manufacturer_id, name_ci);
  end if;
end $$;

-- updated_at triggers
do $$ begin
  create trigger trg_categories_updated_at    before update on public.categories        for each row execute function public.set_updated_at();
exception when duplicate_object then null; end $$;
do $$ begin
  create trigger trg_brands_updated_at        before update on public.brands            for each row execute function public.set_updated_at();
exception when duplicate_object then null; end $$;
do $$ begin
  create trigger trg_groups_updated_at        before update on public.product_groups    for each row execute function public.set_updated_at();
exception when duplicate_object then null; end $$;
do $$ begin
  create trigger trg_subgroups_updated_at     before update on public.product_subgroups for each row execute function public.set_updated_at();
exception when duplicate_object then null; end $$;
do $$ begin
  create trigger trg_manufacturers_updated_at before update on public.manufacturers     for each row execute function public.set_updated_at();
exception when duplicate_object then null; end $$;
do $$ begin
  create trigger trg_distributors_updated_at  before update on public.distributors      for each row execute function public.set_updated_at();
exception when duplicate_object then null; end $$;
do $$ begin
  create trigger trg_shops_updated_at         before update on public.shops             for each row execute function public.set_updated_at();
exception when duplicate_object then null; end $$;
do $$ begin
  create trigger trg_products_updated_at      before update on public.products          for each row execute function public.set_updated_at();
exception when duplicate_object then null; end $$;
