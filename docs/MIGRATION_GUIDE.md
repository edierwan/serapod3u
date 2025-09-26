# MIGRATION GUIDE — Phase 1

**Purpose:** prevent conflicts when multiple AI coders work on the DB. Follow these guardrails **before any `supabase db push`**.

---

## Golden Rules

1) **Review-before-execute.** Read each SQL under `supabase/db/` and ensure it does NOT redefine existing objects under a different name (functions, triggers, types, enums, policies, constraints).
2) **Idempotent by design.** Every migration must be safe to run multiple times. Use `create if not exists`, `on conflict do nothing`, and `do $$ begin … exception when duplicate_* then null; end $$;` guards.
3) **No duplicates** under new names. If an object with the **same purpose** already exists (e.g., `set_updated_at()`), **reuse it** instead of creating `set_updated_at_v2()` or similar.
4) **Do not drop** core objects in Phase 1. Only add what’s missing.
5) **One-way migrations.** Avoid destructive changes; we’ll handle refactors in Phase 2 with explicit deprecation steps.

---

## Preflight Checklist (run these queries first)

### 1) Functions that might already exist (avoid duplicates)
```sql
select n.nspname as schema, p.proname as func, pg_get_function_identity_arguments(p.oid) as signature
from pg_proc p
join pg_namespace n on n.oid = p.pronamespace
where n.nspname in ('public','storage')
  and p.proname in ('set_updated_at','set_updated_by','generate_sku','trg_assign_sku');
```

### 2) Triggers that might already exist
```sql
select event_object_table as table, trigger_name
from information_schema.triggers
where trigger_name in ('trg_profiles_updated_at','trg_product_variants_assign_sku',
                       'trg_manufacturers_updated_at','trg_distributors_updated_at','trg_shops_updated_at');
```

### 3) Existing policies on storage.objects
```sql
select policyname, permissive, roles, cmd, qual, with_check
from pg_policies
where schemaname='storage' and tablename='objects';
```

### 4) Constraint names that could collide
```sql
select tc.table_schema, tc.table_name, tc.constraint_name, tc.constraint_type
from information_schema.table_constraints tc
where tc.table_schema='public'
  and tc.constraint_name in ('uq_variant_tuple','uq_daerah_per_negeri');
```

### 5) Enums already present
```sql
select t.typname as enum_type, e.enumlabel as value
from pg_type t
join pg_enum e on t.oid = e.enumtypid
join pg_catalog.pg_namespace n ON n.oid = t.typnamespace
where n.nspname = 'public' and t.typname in ('role_code');
```

If these queries return existing objects, confirm that your migrations **reuse** them rather than creating alternatives.

---

## Migration Style Guide

- **Use guard blocks** for create/alter operations:
```sql
do $$ begin
  -- your DDL
exception when duplicate_object then null;
end $$;
```

- **Add columns** with `exception when duplicate_column then null;` guards.
- **Constraints/indexes**: wrap `alter table ... add constraint` with duplicate guards.
- **Enums**: `do $$ begin create type ...; exception when duplicate_object then null; end $$;`
- **Triggers**: always `create trigger …; exception when duplicate_object then null;`
- **Insert seeds**: `on conflict do nothing` with a stable unique column.

---

## Execution Order

Run with Supabase CLI using the pooler:
```bash
supabase db push --db-url "$POOL_DATABASE_URL"
```

Recommended order (already reflected in file numbering):
1. `0001_profiles.sql`
2. `0002_categories_seed.sql`
3. `0003_variants_uniques_and_sku.sql`
4. `0004_regions_guard.sql`
5. `0005_parties_guard.sql`
6. `0007_storage_image_bucket.sql`
7. `9999_verify.sql` (prints a NOTICE of missing items or OK)

---

## Naming Conventions

- **Functions**: reuse `set_updated_at`, `set_updated_by`, `generate_sku`, `trg_assign_sku` (no “_v2” variants).
- **Policies**: for storage bucket `product-images`: `image_public_read`, `image_authenticated_insert`, `image_authenticated_update`, `image_authenticated_delete`.
- **Constraints**: `uq_variant_tuple`, `uq_daerah_per_negeri`.
- **Tables/Views**: do not rename existing ones from the dump in Phase 1.

---

## What to do if a conflict is found

1) **Stop and review.** Do **not** create a near-duplicate object with a new name.
2) If the existing object is compatible, **reuse it**.
3) If a change is required, propose a **Phase 2** migration plan (deprecate/replace) rather than altering Phase 1 scope.

---

**Generated:** 2025-09-25T17:30:36.324270Z
