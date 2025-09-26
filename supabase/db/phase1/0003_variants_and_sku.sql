-- 0003_variants_and_sku.sql
-- Phase: 1
-- Generated: 2025-09-25T17:40:10.006146Z
-- Purpose: product_variants with case-insensitive tuple + SKU generator

-- 0003_variants_and_sku.sql
-- product_variants + SKU generator

create table if not exists public.product_variants (
  id uuid primary key default gen_random_uuid(),
  product_id uuid not null references public.products(id) on delete cascade,
  flavor_name text,
  nic_strength text,
  packaging text,
  sku text,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  flavor_name_ci text generated always as (lower(coalesce(flavor_name,''))) stored,
  nic_strength_ci text generated always as (lower(coalesce(nic_strength,''))) stored,
  packaging_ci text generated always as (lower(coalesce(packaging,''))) stored
);

do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'uq_variant_tuple') then
    alter table public.product_variants
      add constraint uq_variant_tuple
      unique (product_id, flavor_name_ci, nic_strength_ci, packaging_ci);
  end if;
end $$;

create or replace function public.generate_sku(p_product_id uuid, p_serial int)
returns text language plpgsql as $fn$
begin
  return 'SKU-' || replace(p_product_id::text,'-','') || '-' || lpad(p_serial::text,6,'0');
end $fn$;

create or replace function public.trg_assign_sku()
returns trigger language plpgsql as $fn$
declare v_serial int;
begin
  if new.sku is null or new.sku = '' then
    select coalesce(max((regexp_match(sku, '-(\\d+)$'))[1]::int), 0) + 1
      into v_serial
    from public.product_variants
    where product_id = new.product_id;
    new.sku := public.generate_sku(new.product_id, v_serial);
  end if;
  return new;
end $fn$;

do $$ begin
  create trigger trg_product_variants_assign_sku
  before insert on public.product_variants
  for each row execute function public.trg_assign_sku();
exception when duplicate_object then null; end $$;

do $$ begin
  create trigger trg_product_variants_updated_at
  before update on public.product_variants
  for each row execute function public.set_updated_at();
exception when duplicate_object then null; end $$;
