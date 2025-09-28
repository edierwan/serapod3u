"use server";

import { revalidatePath } from "next/cache";
import { z } from "zod";
import { createSupabaseServerClient } from "@/lib/supabase/server";
import { uploadManufacturerLogo } from "@/lib/storage/uploadManufacturerLogo"; // Reuse for distributors

const Upsert = z.object({
  id: z.string().optional(),
  name: z.string().min(1, "Name is required"),
  is_active: z.boolean(),
  categoryId: z.string().uuid().optional().nullable(),
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

export async function upsertDistributor(_: unknown, formData: FormData) {
  // Parse all form fields
  const parsed = Upsert.safeParse({
    id: formData.get("id") ?? undefined,
    name: formData.get("name"),
    is_active: formData.get("is_active") === "true",
    categoryId: formData.get("categoryId") || undefined,
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
    const { data } = await supabase.from("distributors").select("logo_url").eq("id", id).single();
    logo_url = data?.logo_url ?? null;
  }

  // Handle logo upload
  const file = formData.get("logo") as File | null;
  if (file && file.size > 0) {
    const up = await uploadManufacturerLogo(id, file); // Reuse upload function
    if (!up.ok) return { success: false, message: up.error };
    logo_url = up.url;
  }

  // Prepare data for database
  const distributorData = {
    name: parsed.data.name,
    is_active: parsed.data.is_active,
    category_id: parsed.data.categoryId || null,
    contact_person: parsed.data.contact_person || null,
    phone: parsed.data.phone || null,
    email: parsed.data.email || null,
    whatsapp: parsed.data.whatsapp || null,
    address_line1: parsed.data.address_line1 || null,
    address_line2: parsed.data.address_line2 || null,
    city: parsed.data.city || null,
    state_region: parsed.data.state_region || null,
    postal_code: parsed.data.postal_code || null,
    website_url: parsed.data.website_url || null,
    notes: parsed.data.notes || null,
    logo_url,
  };

  let error;
  if (parsed.data.id) {
    ({ error } = await supabase
      .from("distributors")
      .update(distributorData)
      .eq("id", id));
  } else {
    ({ error } = await supabase
      .from("distributors")
      .insert({ id, ...distributorData }));
  }

  if (error) {
    // Handle unique constraint violation for distributor name
    if (error.code === "23505" && error.message.includes("distributors_name_ci_uidx")) {
      return { success: false, message: "Distributor name already exists. Please use a different name." };
    }
    return { success: false, message: error.message };
  }

  revalidatePath("/master/distributors");
  return { success: true, id, logo_url };
}

export async function deleteDistributor(id: string) {
  try {
    const supabase = await createSupabaseServerClient();

    const { error } = await supabase
      .from("distributors")
      .delete()
      .eq("id", id);

    if (error) {
      if (error.code === "42501") {
        throw new Error("You don't have permission to delete distributors");
      }
      throw error;
    }

    revalidatePath("/master/distributors");
    return { success: true };
  } catch (error) {
    console.error("Error deleting distributor:", error);
    return {
      success: false,
      error: error instanceof Error ? error.message : "Unknown error"
    };
  }
}

// Get shops count for a distributor
export async function getDistributorShopsCount(distributorId: string) {
  try {
    const supabase = await createSupabaseServerClient();
    const { count, error } = await supabase
      .from("shops")
      .select("*", { count: "exact", head: true })
      .eq("distributor_id", distributorId);

    if (error) throw error;
    return { success: true, count: count || 0 };
  } catch (error) {
    console.error("Error getting shops count:", error);
    return { success: false, count: 0 };
  }
}