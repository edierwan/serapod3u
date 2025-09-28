-- 0101_rewards_storage_bucket.sql
-- Phase: Rewards (Points)
-- Generated: 2025-09-28
-- Purpose: Create rewards-images storage bucket and policies

-- Create rewards-images bucket
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
    'rewards-images',
    'rewards-images',
    false,
    2097152, -- 2MB limit
    array['image/jpeg', 'image/png', 'image/webp', 'image/gif']
)
on conflict (id) do nothing;

-- RLS policies for rewards-images bucket
create policy "rewards_images_admin_all" on storage.objects
    to authenticated
    using (
        bucket_id = 'rewards-images'
        and public.has_any_role(array['hq_admin', 'power_user'])
    )
    with check (
        bucket_id = 'rewards-images'
        and public.has_any_role(array['hq_admin', 'power_user'])
    );

-- Allow authenticated users to read rewards images (for catalog display)
create policy "rewards_images_read_all" on storage.objects
    for select
    to authenticated
    using (bucket_id = 'rewards-images');