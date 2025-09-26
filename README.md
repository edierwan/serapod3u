# Serapod2u v1 — README

Serapod2u is an end‑to‑end QR/RFID product movement + campaigns platform (Lucky Draw, Redeem, Rewards Points) across **Manufacturer → Warehouse → Distributor → Shop**.

## Roles
`hq_admin`, `power_user`, `manufacturer`, `warehouse`, `distributor`, `shop`

## Milestone (this repo)
Phase 1 + 2 **shell** with SSR auth, routing, sidebar/header, Fast Login (dev‑only), and master‑data scaffolding. DB migrations will be created by the coder and pushed via **Supabase Session Pooler**.

## Tech Stack
- Next.js App Router (TypeScript, server components first)
- Auth: `@supabase/ssr` (cookies only). **No client `supabase.auth.*`**
- DB: Supabase Postgres with RLS; CLI pushes via `POOL_DATABASE_URL`
- UI: Tailwind v4 + shadcn/ui + lucide + sonner
- Optional later: framer‑motion (light), recharts (dynamic import), RHF + zod

## Decisions
- Server Actions for `loginAction`, `logoutAction`, `devFastLogin` (dev only)
- Canonical redirect: `/app/:path* → /:path*` via `@/lib/paths`
- Header avatar dropdown contains Logout (server action form)

## Local Setup
```bash
pnpm i   # or yarn / npm (choose ONE manager)
pnpm dev
```
When DB migrations exist:
```bash
supabase db push --db-url "$POOL_DATABASE_URL"
```

## Environment
Create `env/.env.example` → copy to `.env.local`.
```dotenv
NEXT_PUBLIC_SUPABASE_URL=https://opbesretiesctwpdqikl.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9wYmVzcmV0aWVzY3R3cGRxaWtsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ4MzQwNjEsImV4cCI6MjA3MDQxMDA2MX0.JfSf9UqjFMnQ9YbZb6rMpk8c5Nh8rL5fFySGgvGDlFQ

# Dev feature flag (do not enable in prod)
NEXT_PUBLIC_ENABLE_FAST_LOGIN=true

# Server-only
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9wYmVzcmV0aWVzY3R3cGRxaWtsIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1NDgzNDA2MSwiZXhwIjoyMDcwNDEwMDYxfQ.lnLrUqA7BHVJtTFqu_bWF48OYFP_YdgbAzDdizfViRs

# Optional direct (not used for CLI)
DATABASE_URL=postgresql://postgres:REDACTED@db.opbesretiesctwpdqikl.supabase.co:5432/postgres?sslmode=require

# Use pooler for CLI + migrations
POOL_DATABASE_URL=postgresql://postgres.opbesretiesctwpdqikl:Turun_2020-@aws-0-ap-southeast-1.pooler.supabase.com:5432/postgres
```

## Scripts (package.json)
```json
{
  "scripts": {
    "dev": "next dev -p 3000",
    "build": "next build",
    "start": "next start -p 3000",
    "lint": "eslint . --max-warnings=0"
  }
}
```

## Definition of Done (this milestone)
- `/login` → server action auth → redirect to `/dashboard`
- **Fast Login (dev)** via server action; disabled in prod
- Protected pages render via SSR; **no client `supabase.auth.*`**
- Tailwind builds clean (token utilities ok)
- TypeScript strict passes


## Phase 1 Scope (must deliver first)
- **Fast Login (dev-only)** with SSR cookies; disabled in production
- **Role-based Sidebar** (each role sees only its menus; e.g., Shop cannot see Manufacturer)
- **Master Data CRUD**:
  - Categories (seeded: Vape/Non-Vape)
  - Brands, Groups, Sub-Groups
  - **Products + Variants (SKU)** — include full Variant CRUD in Phase 1
    - Uniqueness: (product_id, flavor_name_ci, nic_strength_ci, packaging_ci)
    - Auto `sku` generator trigger
- Tailwind v4 tokens + Rewards UI kit in place


### Storage (Phase 1)
- Create a **single Supabase Storage bucket** named **`product-images`** for all entity images:
  - Prefixes: `product/`, `manufacturer/`, `distributor/`, `shop/`
  - Private bucket; serve via signed URLs (SSR). Public policy can be added later if needed.

### Workflow
- Work on `develop` branch → **open PR to `staging`** when Phase 1 is tested and ready.
- Phase 2 work starts only after `staging` verification.


### Phase 1 UI completeness
- Avatar dropdown contains **Logout** (server action form) — icon `LogOut` (lucide-react)
- **Settings** includes: Profile, Preferences, **Danger Zone** (admins only, disabled placeholders)


### Storage — Bucket name reconciliation
If your environment previously used `images` (plural) policies from a dump, standardize to **`product-images`** (singular) by creating `product-images` and equivalent policies in migrations.


## ⚠️ Important — Read before running migrations
Before executing any SQL, **review and follow** `docs/MIGRATION_GUIDE.md`.  
This prevents duplicate functions/triggers/policies and keeps Phase 1 idempotent and conflict-free.


## Database — Phase 1 scripts location
All Phase 1 SQL migrations are under **`supabase/db/phase1/`**.  
Run them with `psql` using the **POOL_DATABASE_URL** in the order defined in `docs/MIGRATION_GUIDE.md`.

- All entity and campaign images are consolidated in the single **`product-images`** bucket.


## GitHub Actions CI
A minimal CI is included at `.github/workflows/ci.yml`:
- Installs with **pnpm**, lints, and builds the **starter-app** on pushes/PRs.
- If you add a repository secret **`POOL_DATABASE_URL`**, CI will also run the DB **Phase 1 verify** script (`0099_verify.sql`) against your Supabase pooler.

### Required GitHub Secret (optional step)
- **POOL_DATABASE_URL**: your Supabase pooler connection string (same as in `.env.local`). If not set, the `db-verify` job is skipped.

This pack is the single source of truth for **Phase 1**. It contains docs, CI templates, env examples, and a progress log for the coder AI.  
**Date:** 2025-09-26

## Contents
- `docs/` — architecture, spec, UI contract, decisions, and a living `PROGRESS.md` the coder updates.
- `env/.env.example` — fill and copy to your runtime.
- `.github/` — CI, PR template, and issue templates.
- `supabase/db/phase1/` — migration entrypoint for Phase‑1 (coder will generate concrete SQL here).
- `supabase/schemas/current_schema.sql` — snapshot of current DB **reference** (do not re‑apply as migration).
- `prompts/` — ready-to-paste prompts for the coder (start with **Prompt_Coder_01.md**).
- `starter-app/` — reserved path; coder will scaffold here.

## Quickstart (human)
1. Create GitHub repo and push this pack to `main`.
2. Create protected branches: `develop`, `staging`, `production` (see below).
3. Add `POOL_DATABASE_URL` and `NEXT_PUBLIC_SUPABASE_*` as repo/Org **Actions secrets**.
4. Migrations: do **not** reapply `current_schema.sql`. Coder AI will emit idempotent SQL files into `supabase/db/phase1/*` and CI will verify with pooler.
5. Run app locally after coder scaffolds: `cd starter-app && pnpm i && pnpm dev`.

## Branching model
- `develop` → daily development
- `staging` → pre‑prod verification
- `production` → releases

Use PRs `develop → staging` (QA) and `staging → production` (release).

