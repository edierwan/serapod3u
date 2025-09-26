"use server";

import { z } from "zod";
import { revalidatePath } from "next/cache";
import { createSupabaseServerClient } from "@/lib/supabase/server";

const supabase = await createSupabaseServerClient();

const productSchema = z.object({
  subtype_id: z.string().uuid(),
  manufacturer_id: z.string().uuid(),
  sku: z.string().min(1, "SKU is required"),
  name: z.string().min(1, "Name is required"),
  uom: z.string().optional(),
  active: z.boolean().default(true),
});

const updateProductSchema = productSchema.extend({
  id: z.string().uuid(),
});

const TABLE = "products";
const LIST = "/(protected)/master/products/items";

export async function createProduct(formData: FormData) {
  try {
    const data = {
      subtype_id: formData.get("subtype_id") as string,
      manufacturer_id: formData.get("manufacturer_id") as string,
      sku: formData.get("sku") as string,
      name: formData.get("name") as string,
      uom: formData.get("uom") as string || undefined,
      active: formData.get("active") === "on" || formData.get("active") === "true",
    };

    const parsed = productSchema.parse(data);
    
    const { error } = await supabase
      .from(TABLE)
      .insert([parsed]);

    if (error) throw error;

    revalidatePath(LIST);
    return { success: true };
  } catch (error) {
    console.error("Error creating product:", error);
    return { success: false, error: error instanceof Error ? error.message : "Unknown error" };
  }
}

export async function updateProduct(formData: FormData) {
  try {
    const data = {
      id: formData.get("id") as string,
      subtype_id: formData.get("subtype_id") as string,
      manufacturer_id: formData.get("manufacturer_id") as string,
      sku: formData.get("sku") as string,
      name: formData.get("name") as string,
      uom: formData.get("uom") as string || undefined,
      active: formData.get("active") === "on" || formData.get("active") === "true",
    };

    const parsed = updateProductSchema.parse(data);
    const { id, ...updateData } = parsed;
    
    const { error } = await supabase
      .from(TABLE)
      .update({ ...updateData, updated_at: new Date().toISOString() })
      .eq("id", id);

    if (error) throw error;

    revalidatePath(LIST);
    return { success: true };
  } catch (error) {
    console.error("Error updating product:", error);
    return { success: false, error: error instanceof Error ? error.message : "Unknown error" };
  }
}

export async function deleteProduct(id: string) {
  try {
    const { error } = await supabase
      .from(TABLE)
      .delete()
      .eq("id", id);

    if (error) throw error;

    revalidatePath(LIST);
    return { success: true };
  } catch (error) {
    console.error("Error deleting product:", error);
    return { success: false, error: error instanceof Error ? error.message : "Unknown error" };
  }
}