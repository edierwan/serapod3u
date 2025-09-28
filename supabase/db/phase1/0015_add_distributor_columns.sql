-- Add missing columns to distributors table to match manufacturers structure
-- Migration: 0015_add_distributor_columns.sql

-- Add contact and communication columns
ALTER TABLE public.distributors
ADD COLUMN IF NOT EXISTS contact_person text,
ADD COLUMN IF NOT EXISTS phone text,
ADD COLUMN IF NOT EXISTS email text,
ADD COLUMN IF NOT EXISTS whatsapp text,
ADD COLUMN IF NOT EXISTS address_line1 text,
ADD COLUMN IF NOT EXISTS address_line2 text,
ADD COLUMN IF NOT EXISTS city text,
ADD COLUMN IF NOT EXISTS state_region text,
ADD COLUMN IF NOT EXISTS postal_code text,
ADD COLUMN IF NOT EXISTS country_code character(2),
ADD COLUMN IF NOT EXISTS website_url text,
ADD COLUMN IF NOT EXISTS notes text,
ADD COLUMN IF NOT EXISTS logo_url text;

-- Add indexes for commonly queried columns
CREATE INDEX IF NOT EXISTS idx_distributors_email ON public.distributors (email);
CREATE INDEX IF NOT EXISTS idx_distributors_phone ON public.distributors (phone);
CREATE INDEX IF NOT EXISTS idx_distributors_country ON public.distributors (country_code);

-- Rename 'active' column to 'is_active' if it exists (to match manufacturers)
DO $$ 
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.columns 
             WHERE table_name = 'distributors' AND column_name = 'active') THEN
    ALTER TABLE public.distributors RENAME COLUMN active TO is_active;
  END IF;
END $$;

-- Ensure is_active has a default value
ALTER TABLE public.distributors 
ALTER COLUMN is_active SET DEFAULT true;

-- Update existing records to have is_active = true if null
UPDATE public.distributors 
SET is_active = true 
WHERE is_active IS NULL;
