-- 0005_seed_categories.sql
-- Phase: 1
-- Generated: 2025-09-25T17:40:10.006146Z
-- Purpose: seed Vape / Non-Vape

-- 0005_seed_categories.sql
insert into public.categories (name) values ('Vape') on conflict (name) do nothing;
insert into public.categories (name) values ('Non-Vape') on conflict (name) do nothing;

