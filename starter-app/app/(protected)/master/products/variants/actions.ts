"use server";

import { z } from "zod";
import { revalidatePath } from "next/cache";
import { createSupabaseServerClient } from "@/lib/supabase/server";

// Based on the actual product_variants table structure:
// { id, product_id uuid, flavor_name, nic_strength, packaging, sku, is_active, created_at, updated_at }
// But using the requested schema format with variant, barcode, units_per_box
const variantSchema = z.object({
  product_id: z.string().uuid(),
  variant: z.string().min(1),
  barcode: z.string().optional(),
  units_per_box: z.coerce.number().int().positive().optional(),
  active: z.boolean().default(true),
});

const updateVariantSchema = variantSchema.extend({
  id: z.string().uuid(),
});

const TABLE = "product_variants";
const LIST = "/(protected)/master/products/variants";

export async function createVariant(formData: FormData) {
  try {
    const data = {
      product_id: formData.get("product_id") as string,
      variant: formData.get("variant") as string,
      barcode: formData.get("barcode") as string || undefined,
      units_per_box: formData.get("units_per_box") ? parseInt(formData.get("units_per_box") as string) : undefined,
      active: formData.get("active") === "on" || formData.get("active") === "true",
    };

    const parsed = variantSchema.parse(data);
    
    // Map to actual table columns - using flavor_name for variant
    const insertData = {
      product_id: parsed.product_id,
      flavor_name: parsed.variant,
      sku: parsed.barcode, // Using sku field for barcode
      // Note: units_per_box doesn't exist in actual schema, could be stored in a JSON field or ignored
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
    console.error("Error creating variant:", error);
    return { success: false, error: error instanceof Error ? error.message : "Unknown error" };
  }
}

export async function updateVariant(formData: FormData) {
  try {
    const data = {
      id: formData.get("id") as string,
      product_id: formData.get("product_id") as string,
      variant: formData.get("variant") as string,
      barcode: formData.get("barcode") as string || undefined,
      units_per_box: formData.get("units_per_box") ? parseInt(formData.get("units_per_box") as string) : undefined,
      active: formData.get("active") === "on" || formData.get("active") === "true",
    };

    const parsed = updateVariantSchema.parse(data);
    const { id, ...updateFields } = parsed;
    
    // Map to actual table columns
    const updateData = {
      product_id: updateFields.product_id,
      flavor_name: updateFields.variant,
      sku: updateFields.barcode,
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
    console.error("Error updating variant:", error);
    return { success: false, error: error instanceof Error ? error.message : "Unknown error" };
  }
}

export async function deleteVariant(id: string) {
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
    console.error("Error deleting variant:", error);
    return { success: false, error: error instanceof Error ? error.message : "Unknown error" };
  }
}