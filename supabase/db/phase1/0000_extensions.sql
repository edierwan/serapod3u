-- 0000_extensions.sql
-- Phase: 1
-- Generated: 2025-09-25T17:40:10.006146Z
-- Purpose: Ensure required extensions exist

-- gen_random_uuid()
create extension if not exists pgcrypto;
