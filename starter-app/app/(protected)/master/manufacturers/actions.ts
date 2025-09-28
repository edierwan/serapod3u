"use server";

import { revalidatePath } from "next/cache";
import { z } from "zod";
import { createSupabaseServerClient } from "@/lib/supabase/server";
import { uploadManufacturerLogo } from "@/lib/storage/uploadManufacturerLogo";

const Upsert = z.object({
  id: z.string().optional(),
  name: z.string().min(1, "Name is required"),
  is_active: z.boolean(),
  contact_person: z.string().optional(),
  phone: z.string().optional(),
  email: z.string().optional(),
  whatsapp: z.string().optional(),
  address_line1: z.string().optional(),
  address_line2: z.string().optional(),
  city: z.string().optional(),
  state_region: z.string().optional(),
  postal_code: z.string().optional(),
  address: z.string().optional(),
  website_url: z.string().optional(),
  notes: z.string().optional(),
});

export async function upsertManufacturer(_: unknown, formData: FormData) {
  // Parse all form fields
  const parsed = Upsert.safeParse({
    id: formData.get("id") ?? undefined,
    name: formData.get("name"),
    is_active: formData.get("is_active") === "on",
    contact_person: formData.get("contact_person") || undefined,
    phone: formData.get("phone") || undefined,
    email: formData.get("email") || undefined,
    whatsapp: formData.get("whatsapp") || undefined,
    address_line1: formData.get("address_line1") || undefined,
    address_line2: formData.get("address_line2") || undefined,
    city: formData.get("city") || undefined,
    state_region: formData.get("state_region") || undefined,
    postal_code: formData.get("postal_code") || undefined,
    address: formData.get("address") || undefined,
    website_url: formData.get("website_url") || undefined,
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
    whatsapp: parsed.data.whatsapp || null,
    address_line1: parsed.data.address_line1 || null,
    address_line2: parsed.data.address_line2 || null,
    city: parsed.data.city || null,
    state_region: parsed.data.state_region || null,
    postal_code: parsed.data.postal_code || null,
    address: parsed.data.address || null,
    website_url: parsed.data.website_url || null,
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