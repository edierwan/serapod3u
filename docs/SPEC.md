# SPEC.md (Phase 1 Scope — Locked)

- SSR-only login & Fast Login stubs (dev‑only).  
- Sidebar by role; non‑authorized menu items are hidden.  
- Master Data scaffolding with anti‑duplication guards; SKU auto‑generation.  
- Image uploads via `product-images` bucket with signed URLs.  
- CI pipeline: install/lint/build; optional DB verify using `POOL_DATABASE_URL`.  
- No destructive `DROP` in Phase‑1 migrations.  
- `0099_verify.sql` ends with clear NOTICEs (OK/missing).
