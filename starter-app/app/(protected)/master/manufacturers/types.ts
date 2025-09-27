import { z } from "zod";

export const iso2 = z.string().length(2, "Use 2-letter code").regex(/^[A-Za-z]{2}$/).optional().nullable();
export const iso3 = z.string().length(3, "Use 3-letter code").regex(/^[A-Za-z]{3}$/).optional().nullable();

export const manufacturerFormSchema = z.object({
  name: z.string().min(2, "Name is required"),
  is_active: z.boolean(),

  contact_person: z.string().optional().nullable(),
  phone: z.string().optional().nullable(),
  email: z.string().email().optional().nullable(),
  website_url: z.string().url().optional().nullable(),

  address_line1: z.string().optional().nullable(),
  address_line2: z.string().optional().nullable(),
  city: z.string().optional().nullable(),
  postal_code: z.string().optional().nullable(),
  country_code: iso2,
  language_code: iso2,
  currency_code: iso3,

  tax_id: z.string().optional().nullable(),
  registration_number: z.string().optional().nullable(),

  support_email: z.string().email().optional().nullable(),
  support_phone: z.string().optional().nullable(),

  timezone: z.string().optional().nullable(),
  notes: z.string().optional().nullable(),
});

export type ManufacturerFormValues = z.infer<typeof manufacturerFormSchema>;