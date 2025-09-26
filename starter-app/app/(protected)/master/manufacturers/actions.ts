"use server";

import { z } from "zod";
import { revalidatePath } from "next/cache";
import { createSupabaseServerClient } from "@/lib/supabase/server";

const supabase = await createSupabaseServerClient();

const manufacturerSchema = z.object({
  name: z.string().min(1, "Name is required"),
  contact_person: z.string().optional(),
  phone: z.string().optional(),
  email: z.string().email().optional().or(z.literal("")),
  address: z.string().optional(),
  logo_url: z.string().optional(),
  legal_name: z.string().optional(),
  brand_name: z.string().optional(),
  registration_number: z.string().optional(),
  tax_id: z.string().optional(),
  country_code: z.string().length(2).optional().or(z.literal("")),
  language_code: z.string().length(2).optional().or(z.literal("")),
  currency_code: z.string().length(3).optional().or(z.literal("")),
  website_url: z.string().optional(),
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
  social_links: z.any().optional(),
  certifications: z.any().optional(),
  notes: z.string().optional(),
  status: z.enum(["active", "inactive", "blocked"]).default("active"),
});

const updateManufacturerSchema = manufacturerSchema.extend({
  id: z.string().uuid(),
});

const TABLE = "manufacturers";
const LIST = "/(protected)/master/manufacturers";

export async function createManufacturer(formData: FormData) {
  try {
    const data: any = {
      name: formData.get("name") as string,
      contact_person: formData.get("contact_person") as string || undefined,
      phone: formData.get("phone") as string || undefined,
      email: formData.get("email") as string || undefined,
      address: formData.get("address") as string || undefined,
      logo_url: formData.get("logo_url") as string || undefined,
      legal_name: formData.get("legal_name") as string || undefined,
      brand_name: formData.get("brand_name") as string || undefined,
      registration_number: formData.get("registration_number") as string || undefined,
      tax_id: formData.get("tax_id") as string || undefined,
      country_code: formData.get("country_code") as string || undefined,
      language_code: formData.get("language_code") as string || undefined,
      currency_code: formData.get("currency_code") as string || undefined,
      website_url: formData.get("website_url") as string || undefined,
      support_email: formData.get("support_email") as string || undefined,
      support_phone: formData.get("support_phone") as string || undefined,
      whatsapp: formData.get("whatsapp") as string || undefined,
      address_line1: formData.get("address_line1") as string || undefined,
      address_line2: formData.get("address_line2") as string || undefined,
      city: formData.get("city") as string || undefined,
      state_region: formData.get("state_region") as string || undefined,
      postal_code: formData.get("postal_code") as string || undefined,
      secondary_email: formData.get("secondary_email") as string || undefined,
      fax: formData.get("fax") as string || undefined,
      notes: formData.get("notes") as string || undefined,
      status: (formData.get("status") as string) || "active",
    };

    // Clean up empty strings to undefined for optional fields
    Object.keys(data).forEach(key => {
      if (data[key] === "") {
        data[key] = undefined;
      }
    });

    const parsed = manufacturerSchema.parse(data);
    
    const { error } = await supabase
      .from(TABLE)
      .insert([parsed]);

    if (error) throw error;

    revalidatePath(LIST);
    return { success: true };
  } catch (error) {
    console.error("Error creating manufacturer:", error);
    return { success: false, error: error instanceof Error ? error.message : "Unknown error" };
  }
}

export async function updateManufacturer(formData: FormData) {
  try {
    const data: any = {
      id: formData.get("id") as string,
      name: formData.get("name") as string,
      contact_person: formData.get("contact_person") as string || undefined,
      phone: formData.get("phone") as string || undefined,
      email: formData.get("email") as string || undefined,
      address: formData.get("address") as string || undefined,
      logo_url: formData.get("logo_url") as string || undefined,
      legal_name: formData.get("legal_name") as string || undefined,
      brand_name: formData.get("brand_name") as string || undefined,
      registration_number: formData.get("registration_number") as string || undefined,
      tax_id: formData.get("tax_id") as string || undefined,
      country_code: formData.get("country_code") as string || undefined,
      language_code: formData.get("language_code") as string || undefined,
      currency_code: formData.get("currency_code") as string || undefined,
      website_url: formData.get("website_url") as string || undefined,
      support_email: formData.get("support_email") as string || undefined,
      support_phone: formData.get("support_phone") as string || undefined,
      whatsapp: formData.get("whatsapp") as string || undefined,
      address_line1: formData.get("address_line1") as string || undefined,
      address_line2: formData.get("address_line2") as string || undefined,
      city: formData.get("city") as string || undefined,
      state_region: formData.get("state_region") as string || undefined,
      postal_code: formData.get("postal_code") as string || undefined,
      secondary_email: formData.get("secondary_email") as string || undefined,
      fax: formData.get("fax") as string || undefined,
      notes: formData.get("notes") as string || undefined,
      status: (formData.get("status") as string) || "active",
    };

    // Clean up empty strings to undefined for optional fields
    Object.keys(data).forEach(key => {
      if (data[key] === "" && key !== "id") {
        data[key] = undefined;
      }
    });

    const parsed = updateManufacturerSchema.parse(data);
    const { id, ...updateData } = parsed;
    
    const { error } = await supabase
      .from(TABLE)
      .update({ ...updateData, updated_at: new Date().toISOString() })
      .eq("id", id);

    if (error) throw error;

    revalidatePath(LIST);
    return { success: true };
  } catch (error) {
    console.error("Error updating manufacturer:", error);
    return { success: false, error: error instanceof Error ? error.message : "Unknown error" };
  }
}

export async function deleteManufacturer(id: string) {
  try {
    const { error } = await supabase
      .from(TABLE)
      .delete()
      .eq("id", id);

    if (error) throw error;

    revalidatePath(LIST);
    return { success: true };
  } catch (error) {
    console.error("Error deleting manufacturer:", error);
    return { success: false, error: error instanceof Error ? error.message : "Unknown error" };
  }
}