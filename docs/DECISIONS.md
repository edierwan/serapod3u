# DECISIONS.md

- Chosen SSR-only auth with Supabase server actions for security & simplicity.
- Single images bucket `product-images` to standardize storage behavior.
- Idempotent SQL migrations to support CI verification with pooler.
- PROGRESS.md to ensure visibility of coder output without digging into commits.
