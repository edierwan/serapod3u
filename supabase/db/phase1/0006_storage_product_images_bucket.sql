-- 0006_storage_product-images_bucket.sql
-- Purpose: Ensure single Supabase Storage bucket 'product-images' exists with baseline RLS policies.
-- Phase: 1
-- Generated: 2025-09-25T17:19:55.436476Z

-- 1) Bucket (private by default)
insert into storage.buckets (id, name, public)
values ('product-images', 'product-images', false)
on conflict (id) do nothing;

-- 2) Make sure RLS is enabled on storage.objects (usually enabled by default in Supabase)
alter table if exists storage.objects enable row level security;

-- 3) Policies for 'product-images' bucket
-- Read (public) - allow anon + authenticated to SELECT objects only within the 'product-images' bucket
drop policy if exists product-images_public_read on storage.objects;
create policy product-images_public_read on storage.objects
for select
to anon, authenticated
using ( bucket_id = 'product-images' );

-- Insert (auth only) - temporarily allow anon for testing
drop policy if exists product-images_authenticated_insert on storage.objects;
create policy product-images_authenticated_insert on storage.objects
for insert
to anon, authenticated
with check ( bucket_id = 'product-images' );

-- Update (auth only)
drop policy if exists product-images_authenticated_update on storage.objects;
create policy product-images_authenticated_update on storage.objects
for update
to authenticated
using ( bucket_id = 'product-images' )
with check ( bucket_id = 'product-images' );

-- Delete (auth only)
drop policy if exists product-images_authenticated_delete on storage.objects;
create policy product-images_authenticated_delete on storage.objects
for delete
to authenticated
using ( bucket_id = 'product-images' );

-- 4) Recommended folder prefixes for organization (optional, not enforced by DB):
-- product/, manufacturer/, distributor/, shop/
-- Application code should write under these prefixes and use signed URLs in SSR.
