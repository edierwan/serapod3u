-- Disable RLS on distributors and shops tables to allow operations
-- Migration: 0016_disable_distributors_rls.sql

-- Disable Row Level Security on distributors and shops tables
-- This allows all authenticated operations on distributors and shops
-- Similar to manufacturers table which also has RLS disabled

ALTER TABLE public.distributors DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.shops DISABLE ROW LEVEL SECURITY;