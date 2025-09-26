# ARCHITECTURE.md (Phase 1)

**App:** Next.js (SSR-only), Tailwind, shadcn/ui  
**Auth:** Supabase SSR (cookies), server actions only  
**DB:** Supabase/Postgres with strict RLS (later phases), idempotent SQL migrations  
**Storage:** Single bucket `product-images` (products, manufacturers, distributors, shops, campaigns, prizes)

**Key flows in-scope**
- Fast Login (dev‑only) for roles: `hq_admin`, `power_user`, `manufacturer`, `warehouse`, `distributor`, `shop`
- Role‑aware Sidebar (see UI_CONTRACT.md)
- Master Data CRUD scaffold (Category, Brand, Group, Sub‑group, Product, Variant/SKU)
- Variant generator & uniqueness guard (idempotent)
- Settings page: Danger Zone (placeholder), Sign Out

Out-of-scope in Phase 1: production RLS hardening, e‑contest logic, invoices/payments logic beyond placeholders.
