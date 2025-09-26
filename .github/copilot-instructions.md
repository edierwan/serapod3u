# Copilot Instructions: Serapod2u

## Architecture Overview
**Serapod2u** is a QR/RFID product tracking platform with campaign management across the supply chain. This is a **Phase 1 shell** implementing SSR auth, role-based routing, and master data scaffolding.

**Tech Stack:**
- Next.js App Router (TypeScript) - **SSR-only, no client auth**  
- Supabase Auth via `@supabase/ssr` (cookies only)
- Database: Supabase Postgres with RLS + pooler migrations
- UI: Tailwind v4 + shadcn/ui + lucide-react + sonner

## Critical Patterns

### Authentication (SSR-Only)
```typescript
// ✅ ALWAYS use server-side auth
import { createSSRClient } from "@/lib/supabase/server";
const supabase = createSSRClient();
const { data: { user } } = await supabase.auth.getUser();

// ❌ NEVER use client-side auth
// supabase.auth.* is forbidden in client components
```

**Server Actions:** All auth flows use server actions (`loginAction`, `logoutAction`, `devFastLogin`). Fast Login is dev-only via `NEXT_PUBLIC_ENABLE_FAST_LOGIN=true`.

### Role-Based Access Control
Roles: `hq_admin`, `power_user`, `manufacturer`, `warehouse`, `distributor`, `shop`

```typescript
// Check in lib/rbac.ts
import { SidebarByRole } from "@/lib/rbac";
const items = SidebarByRole[role]; // Different menus per role
```

**Complete Sidebar Menu Structure:**
```
🏠 Dashboard

📂 Order Management
├─ Orders (Create | Approval | List)
├─ Purchase Orders (PO List | Acknowledge)
├─ Invoices (Invoice List | Download/Print)
├─ Payments (Upload Proof | Verification | History)
└─ Receipts (Receipt List | Download/Print)

📍 Tracking
├─ Case Movements (Inbound | Outbound)
├─ Scan History (By Batch | By Case)
└─ Blocked/Returned (Blocked | Returned)

🎯 Campaigns & Rewards
├─ 🎲 Lucky Draw (Campaigns | Entries | Results)
├─ 🎁 Redeem (Campaigns | Redemption Logs)
└─ ⭐ Rewards (Points) (Ledger | Rules | Reports)

⚙️ Master Data
├─ Products (Categories | Groups | Sub-Types | Items)
├─ Manufacturers (List | Details)
├─ Distributors (List | Shops Management)
├─ Shops (List | Points Balance)
└─ Campaign Config (Lucky Draw | Redeem | Rewards)

🔔 Notifications
👤 My Profile
⚙️ Settings
🚪 Sign Out
```

**Role-Based Menu Filtering:**
- **HQ Admin & Power User:** Full access to all menu sections
- **Manufacturer:** Limited (Dashboard, Purchase Orders, Settings)
- **Warehouse:** Operations focus (Dashboard, Tracking, Settings)
- **Distributor:** Distribution flow (Dashboard, Orders, Tracking, Settings)
- **Shop:** Customer-facing (Dashboard, Rewards, Settings)

**Layout Pattern:** `app/(protected)/layout.tsx` loads user profile, extracts role, and renders role-filtered sidebar.

### Database Migrations
**Location:** `supabase/db/phase1/` - Numbered files (0001_, 0002_, etc.)
**Idempotency:** All SQL uses `do $$ begin ... exception when duplicate_object then null; end $$;`
**Reference:** `supabase/schemas/current_schema.sql` shows existing schema (don't re-apply)
**Deployment:** Via Supabase pooler using `POOL_DATABASE_URL`

Example pattern:
```sql
-- Check if exists before creating
create table if not exists public.products (...);

-- Idempotent constraint
do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'uq_product_tuple') then
    alter table public.products add constraint uq_product_tuple unique (...);
  end if;
end $$;
```

### Master Data Architecture
**Products → Variants (SKU)** with auto-generation:
- Products have category/brand/group/subgroup hierarchy
- Variants ensure uniqueness: `(product_id, flavor_name_ci, nic_strength_ci, packaging_ci)`
- SKU auto-generated via `generate_sku()` trigger on insert
- Case-insensitive comparisons via generated columns (`*_ci`)

### Storage Pattern
**Single bucket:** `product-images` for ALL entities (products, manufacturers, distributors, shops, campaigns)
**Prefixes:** `product/`, `manufacturer/`, `distributor/`, `shop/`
**Access:** Private bucket with server-side signed URLs

```typescript
// lib/storage.ts usage
await uploadImage("product", productId, file); // Returns path
await getSignedUrl(path, 3600); // Server-side signed URL
```

## Development Workflow

### Local Setup
```bash
pnpm i && pnpm dev  # Port 3000
# DB migrations (when needed):
supabase db push --db-url "$POOL_DATABASE_URL"
```

### Branch Model
- `develop` → daily work
- `staging` → pre-prod verification  
- `production` → releases
- **Current:** Working on `production` branch

### Environment Variables
Real credentials for development:
```bash
NEXT_PUBLIC_SUPABASE_URL=https://opbesretiesctwpdqikl.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9wYmVzcmV0aWVzY3R3cGRxaWtsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ4MzQwNjEsImV4cCI6MjA3MDQxMDA2MX0.JfSf9UqjFMnQ9YbZb6rMpk8c5Nh8rL5fFySGgvGDlFQ
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9wYmVzcmV0aWVzY3R3cGRxaWtsIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1NDgzNDA2MSwiZXhwIjoyMDcwNDEwMDYxfQ.lnLrUqA7BHVJtTFqu_bWF48OYFP_YdgbAzDdizfViRs
POOL_DATABASE_URL=postgresql://postgres.opbesretiesctwpdqikl:Turun_2020-@aws-0-ap-southeast-1.pooler.supabase.com:5432/postgres
NEXT_PUBLIC_ENABLE_FAST_LOGIN=true # Dev only
```

## Code Conventions

### File Structure
```
app/
  (public)/login/          # Unauthenticated routes
  (protected)/             # Authenticated routes with layout
    layout.tsx             # Role-aware sidebar + auth check
    dashboard/page.tsx     # Landing after login
    master/                # Master data pages
    settings/page.tsx      # User settings
```

### Component Patterns
- **Header:** Logout button with server action form
- **Sidebar:** Role-filtered menu items from `lib/rbac.ts`
- **Server Components:** Default for SSR data fetching
- **Client Components:** Only for interactivity (marked `"use client"`)

### Error Handling
```typescript
// Server actions return errors, don't throw to UI
if (error) {
  // avoid leaking exact reason to UI
  throw new Error("Login failed");
}
```

## Phase 1 Scope (Current)
- ✅ SSR auth with Fast Login (dev)
- ✅ Role-based sidebar navigation
- 🔄 Master Data CRUD (Categories, Brands, Products, Variants)
- 🔄 Image uploads via `product-images` bucket
- 📋 Settings page with Danger Zone placeholder

**Definition of Done:**
- TypeScript strict passes
- Tailwind builds clean  
- All pages render via SSR
- CI passes (lint, build, optional DB verify)

## UI Design Guidelines

### Rewards System Architecture
- **KV Store Pattern:** Use key patterns like `user:${userId}:rewards` for data storage
- **API Structure:** Server endpoints at `/make-server-64cb7b77/` prefix
- **Level Progression:** Each level requires increasingly more points (500, 1000, 2000, etc.)
- **Activities:** Support daily, weekly, one-time, and repeatable types

### Role-Based Dashboard Design
- **Three-Way Business Model:** Manufacturer → Distributor → Shop relationships
- **Component Structure:** Reusable cards (ManufacturerCard, DistributorCard, ShopCard)
- **Visual Hierarchy:** Statistics row at top, entity grids below, search/filter bar
- **Status Indicators:** Color-coded badges (green=active, orange=pending, red=inactive)

### UI Component Patterns
- **shadcn/ui Consistency:** Use Cards, Badges, Tables, Search inputs throughout
- **Grid Layouts:** Responsive 1-3 column grids (mobile-first approach)
- **Interactive Elements:** Click-to-view details, status changes, contact management
- **Professional Aesthetic:** Clean design with proper spacing and typography hierarchy

## Key Files to Reference
- `docs/UI_CONTRACT.md` - Complete sidebar structure by role
- `docs/UI_REWARDS_GENERAL.md` - Comprehensive rewards system implementation guide
- `docs/UI_DESIGN_MANU_DISTRI_SHOP.md` - Business dashboard design patterns
- `lib/rbac.ts` - Role definitions and menu mappings  
- `lib/supabase/server.ts` - SSR client pattern
- `app/(protected)/layout.tsx` - Auth + role loading pattern
- `supabase/db/phase1/` - Migration examples with idempotency

## Testing Commands
```bash
pnpm lint              # ESLint (max-warnings=0)
pnpm build             # Next.js build
pnpm start             # Production server
```

**Remember:** Phase 1 is about scaffolding and patterns. Focus on SSR architecture, role-based access, and idempotent migrations. No client-side auth secrets!

## ⚠️ Critical Issues to Address in Phase 1

### Missing Development Tools
- **ESLint Configuration:** No `.eslintrc.js` or `eslint.config.js` found - linting will fail
- **TypeScript Config:** Verify `tsconfig.json` has strict mode enabled
- **Environment Setup:** Create `.env.local` with real credentials provided above
- **Storage Bucket Setup:** Verify `product-images` bucket exists with proper RLS policies (see attachment)

### Database & Migration Concerns
- **Migration Order:** Ensure migrations run in sequence (0001_, 0002_, 0003_...)
- **RLS Policies:** Current schema has complex RLS - verify policies don't block legitimate operations
- **Foreign Key Cascades:** Products reference manufacturers with `ON DELETE RESTRICT` - handle deletion flows carefully
- **Dev Data Seeding:** Fast Login depends on `dev_fastlogin_accounts` table being populated

### API & Security Gaps
- **Server Action Error Handling:** Ensure all server actions have proper try/catch and don't leak DB errors to UI
- **Role Validation:** Verify all protected routes check user roles before DB operations
- **Storage Policies:** `product-images` bucket needs proper RLS policies for role-based access
- **JWT Claims:** Functions depend on `request.jwt.claims` - ensure JWT structure matches expectations

### UI/UX Implementation Risks
- **Route Coverage:** Many sidebar menu items don't have corresponding page implementations yet
- **Loading States:** Server actions need loading/pending states for better UX
- **Error Boundaries:** Add React error boundaries for graceful fallbacks
- **Form Validation:** Master data forms need client + server validation

### Performance & Scalability
- **Database Indexes:** Verify indexes exist on frequently queried columns (role_code, manufacturer_id, etc.)
- **Image Upload Size:** Current limit is 2MB - consider if sufficient for product images
- **Query Optimization:** Some functions do expensive JOINs - monitor for N+1 queries

### Deployment Readiness
- **CI/CD Pipeline:** GitHub Actions needs `POOL_DATABASE_URL` secret to run DB verify
- **Environment Variables:** Production deployment needs all required env vars
- **Build Optimization:** Verify Next.js builds successfully with current dependencies