# DB_VERIFY.md

**Do not** reapply `supabase/schemas/current_schema.sql`.  
Coder will produce idempotent migrations into `supabase/db/phase1/`.

To verify in CI, set `POOL_DATABASE_URL` secret and run the workflow in `.github/workflows/ci.yml`.
