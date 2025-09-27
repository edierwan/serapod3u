-- Migration: Add missing fields to products table for the Products management system
-- Date: 2025-09-27
-- Purpose: Add sku, price, status, image_url columns to products table

do $$
begin
  -- Add sku column if it doesn't exist
  if not exists (
    select 1
    from information_schema.columns
    where table_schema='public' and table_name='products' and column_name='sku'
  ) then
    alter table public.products add column sku text unique;
  end if;

  -- Add price column if it doesn't exist
  if not exists (
    select 1
    from information_schema.columns
    where table_schema='public' and table_name='products' and column_name='price'
  ) then
    alter table public.products add column price numeric(10,2);
  end if;

  -- Add status column if it doesn't exist
  if not exists (
    select 1
    from information_schema.columns
    where table_schema='public' and table_name='products' and column_name='status'
  ) then
    alter table public.products add column status text default 'active' check (status in ('active', 'inactive'));
  end if;

  -- Add image_url column if it doesn't exist
  if not exists (
    select 1
    from information_schema.columns
    where table_schema='public' and table_name='products' and column_name='image_url'
  ) then
    alter table public.products add column image_url text;
  end if;
end$$;

-- Ensure the product-images storage bucket exists (already exists from phase1)
insert into storage.buckets (id, name, public)
values ('product-images', 'product-images', true)
on conflict (id) do nothing;