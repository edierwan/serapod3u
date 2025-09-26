"use server";

import { z } from "zod";
import { revalidatePath } from "next/cache";
import { createSupabaseServerClient } from "@/lib/supabase/server";

// Updated Zod schema as requested
const distributorSchema = z.object({
  name: z.string().min(1, "Name is required"),
  code: z.string().optional(),
  email: z.string().email().optional().or(z.string().length(0)),
  phone: z.string().optional(),
  address: z.string().optional(),
  country_code: z.string().length(2).optional().or(z.string().length(0)),
  active: z.boolean().default(true),
});

const updateDistributorSchema = distributorSchema.extend({
  id: z.string().uuid(),
});

const TABLE = "distributors";
const LIST = "/(protected)/master/distributors";

export async function createDistributor(formData: FormData) {
  try {
    const data = {
      name: formData.get("name") as string,
      code: formData.get("code") as string || undefined,
      email: formData.get("email") as string || undefined,
      phone: formData.get("phone") as string || undefined,
      address: formData.get("address") as string || undefined,
      country_code: formData.get("country_code") as string || undefined,
      active: formData.get("active") === "on" || formData.get("active") === "true",
    };

    const parsed = distributorSchema.parse(data);
    
    // Map to actual table structure - using is_active instead of active
    const insertData = {
      name: parsed.name,
      // Note: code, email, phone, address, country_code don't exist in current schema
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
    console.error("Error creating distributor:", error);
    return { success: false, error: error instanceof Error ? error.message : "Unknown error" };
  }
}

export async function updateDistributor(formData: FormData) {
  try {
    const data = {
      id: formData.get("id") as string,
      name: formData.get("name") as string,
      code: formData.get("code") as string || undefined,
      email: formData.get("email") as string || undefined,
      phone: formData.get("phone") as string || undefined,
      address: formData.get("address") as string || undefined,
      country_code: formData.get("country_code") as string || undefined,
      active: formData.get("active") === "on" || formData.get("active") === "true",
    };

    const parsed = updateDistributorSchema.parse(data);
    const { id, ...updateFields } = parsed;
    
    // Map to actual table structure
    const updateData = {
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
    console.error("Error updating distributor:", error);
    return { success: false, error: error instanceof Error ? error.message : "Unknown error" };
  }
}

export async function deleteDistributor(id: string) {
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
    console.error("Error deleting distributor:", error);
    return { success: false, error: error instanceof Error ? error.message : "Unknown error" };
  }
}