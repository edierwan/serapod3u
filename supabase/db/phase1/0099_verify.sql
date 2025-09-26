-- 0099_verify.sql
-- Phase: 1
-- Generated: 2025-09-25T17:40:10.006146Z
-- Purpose: Print a concise checklist of Phase 1 objects

-- 0099_verify.sql
select 'profiles'              as table, to_regclass('public.profiles');
select 'categories'            as table, to_regclass('public.categories');
select 'brands'                as table, to_regclass('public.brands');
select 'product_groups'        as table, to_regclass('public.product_groups');
select 'product_subgroups'     as table, to_regclass('public.product_subgroups');
select 'manufacturers'         as table, to_regclass('public.manufacturers');
select 'distributors'          as table, to_regclass('public.distributors');
select 'shops'                 as table, to_regclass('public.shops');
select 'manufacturer_users'    as table, to_regclass('public.manufacturer_users');
select 'shop_distributors'     as table, to_regclass('public.shop_distributors');
select 'products'              as table, to_regclass('public.products');
select 'product_variants'      as table, to_regclass('public.product_variants');
select 'master_negeri'         as table, to_regclass('public.master_negeri');
select 'master_daerah'         as table, to_regclass('public.master_daerah');
select 'dev_fastlogin_accounts'as table, to_regclass('public.dev_fastlogin_accounts');
