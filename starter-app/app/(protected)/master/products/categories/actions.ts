"use server";

import { z } from "zod";
import { revalidatePath } from "next/cache";
import { createSupabaseServerClient } from "@/lib/supabase/server";

const supabase = await createSupabaseServerClient();

const categorySchema = z.object({
  name: z.string().min(1, "Name is required"),
  code: z.string().optional(),
  active: z.boolean().default(true),
});

const updateCategorySchema = categorySchema.extend({
  id: z.string().uuid(),
});

const TABLE = "product_categories";
const LIST = "/(protected)/master/products/categories";

export async function createCategory(formData: FormData) {
  try {
    const data = {
      name: formData.get("name") as string,
      code: formData.get("code") as string || undefined,
      active: formData.get("active") === "on" || formData.get("active") === "true",
    };

    const parsed = categorySchema.parse(data);
    
    const { error } = await supabase
      .from(TABLE)
      .insert([parsed]);

    if (error) throw error;

    revalidatePath(LIST);
    return { success: true };
  } catch (error) {
    console.error("Error creating category:", error);
    return { success: false, error: error instanceof Error ? error.message : "Unknown error" };
  }
}

export async function updateCategory(formData: FormData) {
  try {
    const data = {
      id: formData.get("id") as string,
      name: formData.get("name") as string,
      code: formData.get("code") as string || undefined,
      active: formData.get("active") === "on" || formData.get("active") === "true",
    };

    const parsed = updateCategorySchema.parse(data);
    const { id, ...updateData } = parsed;
    
    const { error } = await supabase
      .from(TABLE)
      .update({ ...updateData, updated_at: new Date().toISOString() })
      .eq("id", id);

    if (error) throw error;

    revalidatePath(LIST);
    return { success: true };
  } catch (error) {
    console.error("Error updating category:", error);
    return { success: false, error: error instanceof Error ? error.message : "Unknown error" };
  }
}

export async function deleteCategory(id: string) {
  try {
    const { error } = await supabase
      .from(TABLE)
      .delete()
      .eq("id", id);

    if (error) throw error;

    revalidatePath(LIST);
    return { success: true };
  } catch (error) {
    console.error("Error deleting category:", error);
    return { success: false, error: error instanceof Error ? error.message : "Unknown error" };
  }
}