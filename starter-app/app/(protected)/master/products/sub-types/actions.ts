"use server";

import { z } from "zod";
import { revalidatePath } from "next/cache";
import { createSupabaseServerClient } from "@/lib/supabase/server";

const supabase = await createSupabaseServerClient();

const subtypeSchema = z.object({
  group_id: z.string().uuid(),
  name: z.string().min(1, "Name is required"),
  code: z.string().optional(),
  active: z.boolean().default(true),
});

const updateSubtypeSchema = subtypeSchema.extend({
  id: z.string().uuid(),
});

const TABLE = "product_subtypes";
const LIST = "/(protected)/master/products/sub-types";

export async function createSubtype(formData: FormData) {
  try {
    const data = {
      group_id: formData.get("group_id") as string,
      name: formData.get("name") as string,
      code: formData.get("code") as string || undefined,
      active: formData.get("active") === "on" || formData.get("active") === "true",
    };

    const parsed = subtypeSchema.parse(data);
    
    const { error } = await supabase
      .from(TABLE)
      .insert([parsed]);

    if (error) throw error;

    revalidatePath(LIST);
    return { success: true };
  } catch (error) {
    console.error("Error creating subtype:", error);
    return { success: false, error: error instanceof Error ? error.message : "Unknown error" };
  }
}

export async function updateSubtype(formData: FormData) {
  try {
    const data = {
      id: formData.get("id") as string,
      group_id: formData.get("group_id") as string,
      name: formData.get("name") as string,
      code: formData.get("code") as string || undefined,
      active: formData.get("active") === "on" || formData.get("active") === "true",
    };

    const parsed = updateSubtypeSchema.parse(data);
    const { id, ...updateData } = parsed;
    
    const { error } = await supabase
      .from(TABLE)
      .update({ ...updateData, updated_at: new Date().toISOString() })
      .eq("id", id);

    if (error) throw error;

    revalidatePath(LIST);
    return { success: true };
  } catch (error) {
    console.error("Error updating subtype:", error);
    return { success: false, error: error instanceof Error ? error.message : "Unknown error" };
  }
}

export async function deleteSubtype(id: string) {
  try {
    const { error } = await supabase
      .from(TABLE)
      .delete()
      .eq("id", id);

    if (error) throw error;

    revalidatePath(LIST);
    return { success: true };
  } catch (error) {
    console.error("Error deleting subtype:", error);
    return { success: false, error: error instanceof Error ? error.message : "Unknown error" };
  }
}