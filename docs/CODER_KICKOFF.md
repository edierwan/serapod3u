# CODER_KICKOFF.md

You are the **Coder AI**. Deliver Phase‑1 under `starter-app/` and `supabase/db/phase1/`.

## Deliverables
1) **Migrations** (idempotent .sql) into `supabase/db/phase1/`:
   - 0000_extensions.sql
   - 0001_profiles.sql
   - 0002_master_core.sql
   - 0003_variants_and_sku.sql
   - 0004_regions.sql
   - 0005_seed_categories.sql
   - 0006_storage_product_images_bucket.sql
   - 0007_dev_fastlogin_seed.sql
   - 0099_verify.sql (prints NOTICE OK/missing)

2) **App scaffold** in `starter-app/`:
   - SSR login + Fast Login buttons for 6 roles (dev only).
   - Role‑aware layout + Sidebar per UI_CONTRACT.md.
   - Master data skeleton pages.
   - Settings page with Danger Zone placeholder and Sign Out.

3) **Progress file**: Update `docs/PROGRESS.md` on each commit (see format).

## Constraints
- SSR‑only (no client‑side auth libraries).
- No destructive drops; migrations idempotent.
- Respect single bucket `product-images` with signed URLs.

## Inputs
- Reference schema: `supabase/schemas/current_schema.sql` (do NOT re‑apply).

