# serapod3u
QR Management System
Project

Serapod2u — end‑to‑end QR/RFID product movement + campaigns (Lucky Draw, Redeem, Rewards Points) across Manufacturer → Warehouse → Distributor → Shop.

Roles

hq_admin, power_user, manufacturer, warehouse, distributor, shop.

Phase Milestone (this repo)

Phase 1 + 2 shell with solid SSR auth, routing, sidebar/header, Fast Login (dev‑only), and master‑data scaffolding.

DB migrations applied via Supabase Session Pooler.

Tech Stack

Next.js App Router (TypeScript, server components first)

Auth: @supabase/ssr (cookies). No auth-helpers-nextjs.

DB: Supabase Postgres with RLS; CLI pushes via POOL_DATABASE_URL.

UI: Tailwind v4 + shadcn/ui + lucide + sonner (toast). Optional later: framer‑motion (light), recharts (dynamic import), RHF + zod for forms.

Decisions

Server Actions for loginAction, logoutAction, devFastLogin (dev only).

Canonical redirect: /app/:path* → /:path* using @/lib/paths helpers.

Header avatar dropdown includes Logout (server action). Not in Settings.

Local Setup

Clone & install (pick one package manager; remove others):

pnpm i
# or: npm i / yarn

Create .env.local from template (see Environment below).

Run dev:

pnpm dev

(When DB ready) Push migrations via pooler:

supabase db push --db-url "$POOL_DATABASE_URL"
Environment (put this as /env/.env.example, then copy to .env.local)

Never commit real secrets to git. For initial bootstrap you may paste values, but rotate later for production.

# ===== Public (OK in browser) =====
NEXT_PUBLIC_SUPABASE_URL=https://opbesretiesctwpdqikl.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9wYmVzcmV0aWVzY3R3cGRxaWtsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ4MzQwNjEsImV4cCI6MjA3MDQxMDA2MX0.JfSf9UqjFMnQ9YbZb6rMpk8c5Nh8rL5fFySGgvGDlFQ


# Dev feature flag (do not enable in prod)
NEXT_PUBLIC_ENABLE_FAST_LOGIN=true


# ===== Server-only =====
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9wYmVzcmV0aWVzY3R3cGRxaWtsIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1NDgzNDA2MSwiZXhwIjoyMDcwNDEwMDYxfQ.lnLrUqA7BHVJtTFqu_bWF48OYFP_YdgbAzDdizfViRs


# Optional direct connection (not used for CLI)
DATABASE_URL=postgresql://postgres:REDACTED@db.opbesretiesctwpdqikl.supabase.co:5432/postgres?sslmode=require


# Use pooler for CLI and migration tools
POOL_DATABASE_URL=postgresql://postgres.opbesretiesctwpdqikl:Turun_2020-@aws-0-ap-southeast-1.pooler.supabase.com:5432/postgres
Scripts (add in package.json)
{
  "scripts": {
    "dev": "next dev -p 3000",
    "build": "next build",
    "start": "next start -p 3000",
    "lint": "eslint . --max-warnings=0"
  }
}
Definition of Done (DoD) — This Milestone

/login → server action auth → redirect to /dashboard.

Fast Login (dev) works via server action; must be disabled in prod.

Protected pages render via SSR; no client supabase.auth.* calls.

Tailwind builds clean; tokens utilities exist (no “unknown utility” errors).

TypeScript strict passes.
