"use server";

import { z } from "zod";
import { revalidatePath } from "next/cache";
import { createSupabaseServerClient } from "@/lib/supabase/server";

// Same Zod schema as distributors/shops (generic shops CRUD)
const shopSchema = z.object({
  distributor_id: z.string().uuid(),
  name: z.string().min(1, "Name is required"),
  code: z.string().optional(),
  email: z.string().email().optional().or(z.string().length(0)),
  phone: z.string().optional(),
  address: z.string().optional(),
  city: z.string().optional(),
  state_region: z.string().optional(),
  postal_code: z.string().optional(),
  country_code: z.string().length(2).optional().or(z.string().length(0)),
  active: z.boolean().default(true),
});

const updateShopSchema = shopSchema.extend({
  id: z.string().uuid(),
});

const TABLE = "shops";
const LIST = "/(protected)/master/shops";

export async function createShop(formData: FormData) {
  try {
    const data = {
      distributor_id: formData.get("distributor_id") as string,
      name: formData.get("name") as string,
      code: formData.get("code") as string || undefined,
      email: formData.get("email") as string || undefined,
      phone: formData.get("phone") as string || undefined,
      address: formData.get("address") as string || undefined,
      city: formData.get("city") as string || undefined,
      state_region: formData.get("state_region") as string || undefined,
      postal_code: formData.get("postal_code") as string || undefined,
      country_code: formData.get("country_code") as string || undefined,
      active: formData.get("active") === "on" || formData.get("active") === "true",
    };

    const parsed = shopSchema.parse(data);
    
    // Map to actual table structure - only fields that exist
    const insertData = {
      distributor_id: parsed.distributor_id,
      name: parsed.name,
      // Note: most fields like code, email, phone, address, city, etc. don't exist in current schema
      // They would need to be added to the table or stored differently
      is_active: parsed.active,
    };
    
    const supabase = createSupabaseServerClient();
    const { error } = await (await supabase)
      .from(TABLE)
      .insert([insertData]);

    if (error) throw error;

    revalidatePath(LIST);
    return { success: true };
  } catch (error) {
    console.error("Error creating shop:", error);
    return { success: false, error: error instanceof Error ? error.message : "Unknown error" };
  }
}

export async function updateShop(formData: FormData) {
  try {
    const data = {
      id: formData.get("id") as string,
      distributor_id: formData.get("distributor_id") as string,
      name: formData.get("name") as string,
      code: formData.get("code") as string || undefined,
      email: formData.get("email") as string || undefined,
      phone: formData.get("phone") as string || undefined,
      address: formData.get("address") as string || undefined,
      city: formData.get("city") as string || undefined,
      state_region: formData.get("state_region") as string || undefined,
      postal_code: formData.get("postal_code") as string || undefined,
      country_code: formData.get("country_code") as string || undefined,
      active: formData.get("active") === "on" || formData.get("active") === "true",
    };

    const parsed = updateShopSchema.parse(data);
    const { id, ...updateFields } = parsed;
    
    // Map to actual table structure
    const updateData = {
      distributor_id: updateFields.distributor_id,
      name: updateFields.name,
      is_active: updateFields.active,
      updated_at: new Date().toISOString(),
    };
    
    const supabase = createSupabaseServerClient();
    const { error } = await (await supabase)
      .from(TABLE)
      .update(updateData)
      .eq("id", id);

    if (error) throw error;

    revalidatePath(LIST);
    return { success: true };
  } catch (error) {
    console.error("Error updating shop:", error);
    return { success: false, error: error instanceof Error ? error.message : "Unknown error" };
  }
}

export async function deleteShop(id: string) {
  try {
    const supabase = createSupabaseServerClient();
    const { error } = await (await supabase)
      .from(TABLE)
      .delete()
      .eq("id", id);

    if (error) throw error;

    revalidatePath(LIST);
    return { success: true };
  } catch (error) {
    console.error("Error deleting shop:", error);
    return { success: false, error: error instanceof Error ? error.message : "Unknown error" };
  }
}