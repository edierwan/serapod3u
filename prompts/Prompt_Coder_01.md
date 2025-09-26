# Prompt_Coder_01.md — Phase‑1 Kickoff

You are the Coder AI working in this repository. Follow strictly:

1. Read `docs/ARCHITECTURE.md`, `docs/SPEC.md`, and `docs/UI_CONTRACT.md`.
2. Scaffold Next.js SSR app under `starter-app/` with:
   - `(public)/login` + server actions (email + Fast Login for roles).
   - `(protected)/layout.tsx` with role-aware Sidebar.
   - Placeholder pages for Master Data + Settings.
3. Generate idempotent SQL migrations under `supabase/db/phase1/` using the **reference** in `supabase/schemas/current_schema.sql` (do not reapply the snapshot).
4. Ensure `0099_verify.sql` prints clear OK/missing messages.
5. Update `docs/PROGRESS.md` on each commit. Include a short "What I did" section.

**Non-negotiables:** SSR only, no client secrets, single `product-images` bucket, no destructive drops.
