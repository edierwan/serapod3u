"use server";

import { revalidatePath } from "next/cache";
import { z } from "zod";
import { createSupabaseServerClient } from "@/lib/supabase/server";
import { uploadManufacturerLogo } from "@/lib/storage/uploadManufacturerLogo";

const Upsert = z.object({
  id: z.string().uuid().optional(),
  name: z.string().trim().min(1, "Name is required"),
  is_active: z.coerce.boolean().default(true),
  contact_person: z.string().optional(),
  phone: z.string().optional(),
  email: z.string().email().optional().or(z.literal("")),
  address: z.string().optional(),
  legal_name: z.string().optional(),
  brand_name: z.string().optional(),
  registration_number: z.string().optional(),
  tax_id: z.string().optional(),
  country_code: z.string().length(2).optional().or(z.literal("")),
  timezone: z.string().optional(),
  language_code: z.string().length(2).optional().or(z.literal("")),
  currency_code: z.string().length(3).optional().or(z.literal("")),
  website_url: z.string().url().optional().or(z.literal("")),
  support_email: z.string().email().optional().or(z.literal("")),
  support_phone: z.string().optional(),
  whatsapp: z.string().optional(),
  address_line1: z.string().optional(),
  address_line2: z.string().optional(),
  city: z.string().optional(),
  state_region: z.string().optional(),
  postal_code: z.string().optional(),
  secondary_email: z.string().email().optional().or(z.literal("")),
  fax: z.string().optional(),
  social_links: z.string().optional(),
  certifications: z.string().optional(),
  notes: z.string().optional(),
});

export async function upsertManufacturer(_: any, formData: FormData) {
  // Parse all form fields
  const parsed = Upsert.safeParse({
    id: formData.get("id") ?? undefined,
    name: formData.get("name"),
    is_active: (formData.get("is_active") ?? "true") === "true",
    contact_person: formData.get("contact_person") || undefined,
    phone: formData.get("phone") || undefined,
    email: formData.get("email") || undefined,
    address: formData.get("address") || undefined,
    legal_name: formData.get("legal_name") || undefined,
    brand_name: formData.get("brand_name") || undefined,
    registration_number: formData.get("registration_number") || undefined,
    tax_id: formData.get("tax_id") || undefined,
    country_code: formData.get("country_code") || undefined,
    timezone: formData.get("timezone") || undefined,
    language_code: formData.get("language_code") || undefined,
    currency_code: formData.get("currency_code") || undefined,
    website_url: formData.get("website_url") || undefined,
    support_email: formData.get("support_email") || undefined,
    support_phone: formData.get("support_phone") || undefined,
    whatsapp: formData.get("whatsapp") || undefined,
    address_line1: formData.get("address_line1") || undefined,
    address_line2: formData.get("address_line2") || undefined,
    city: formData.get("city") || undefined,
    state_region: formData.get("state_region") || undefined,
    postal_code: formData.get("postal_code") || undefined,
    secondary_email: formData.get("secondary_email") || undefined,
    fax: formData.get("fax") || undefined,
    social_links: formData.get("social_links") || undefined,
    certifications: formData.get("certifications") || undefined,
    notes: formData.get("notes") || undefined,
  });

  if (!parsed.success) {
    return { success: false, errors: parsed.error.flatten().fieldErrors };
  }

  const supabase = await createSupabaseServerClient();
  const id = parsed.data.id ?? crypto.randomUUID();

  // Keep old logo if none uploaded
  let logo_url: string | null = null;
  if (parsed.data.id) {
    const { data } = await supabase.from("manufacturers").select("logo_url").eq("id", id).single();
    logo_url = data?.logo_url ?? null;
  }

  // Handle logo upload
  const file = formData.get("logo") as File | null;
  if (file && file.size > 0) {
    const up = await uploadManufacturerLogo(id, file);
    if (!up.ok) return { success: false, message: up.error };
    logo_url = up.url;
  }

  // Prepare data for database
  const manufacturerData = {
    name: parsed.data.name,
    is_active: parsed.data.is_active,
    contact_person: parsed.data.contact_person || null,
    phone: parsed.data.phone || null,
    email: parsed.data.email || null,
    address: parsed.data.address || null,
    legal_name: parsed.data.legal_name || null,
    brand_name: parsed.data.brand_name || null,
    registration_number: parsed.data.registration_number || null,
    tax_id: parsed.data.tax_id || null,
    country_code: parsed.data.country_code || null,
    timezone: parsed.data.timezone || null,
    language_code: parsed.data.language_code || null,
    currency_code: parsed.data.currency_code || null,
    website_url: parsed.data.website_url || null,
    support_email: parsed.data.support_email || null,
    support_phone: parsed.data.support_phone || null,
    whatsapp: parsed.data.whatsapp || null,
    address_line1: parsed.data.address_line1 || null,
    address_line2: parsed.data.address_line2 || null,
    city: parsed.data.city || null,
    state_region: parsed.data.state_region || null,
    postal_code: parsed.data.postal_code || null,
    secondary_email: parsed.data.secondary_email || null,
    fax: parsed.data.fax || null,
    social_links: parsed.data.social_links ? JSON.parse(parsed.data.social_links) : null,
    certifications: parsed.data.certifications ? JSON.parse(parsed.data.certifications) : null,
    notes: parsed.data.notes || null,
    logo_url,
  };

  let error;
  if (parsed.data.id) {
    ({ error } = await supabase
      .from("manufacturers")
      .update(manufacturerData)
      .eq("id", id));
  } else {
    ({ error } = await supabase
      .from("manufacturers")
      .insert({ id, ...manufacturerData }));
  }

  if (error) return { success: false, message: error.message };

  revalidatePath("/master/manufacturers");
  return { success: true, id, logo_url };
}

export async function deleteManufacturer(id: string) {
  try {
    const supabase = await createSupabaseServerClient();

    const { error } = await supabase
      .from("manufacturers")
      .delete()
      .eq("id", id);

    if (error) {
      if (error.code === "42501") { // insufficient privilege
        throw new Error("You don't have permission to delete manufacturers");
      }
      throw error;
    }

    revalidatePath("/master"); // adjust path to your tab route
    return { success: true };
  } catch (error) {
    console.error("Error deleting manufacturer:", error);
    return {
      success: false,
      error: error instanceof Error ? error.message : "Unknown error"
    };
  }
}