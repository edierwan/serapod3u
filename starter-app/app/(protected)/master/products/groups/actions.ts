"use server";

import { z } from "zod";
import { revalidatePath } from "next/cache";
import { createSupabaseServerClient } from "@/lib/supabase/server";

const supabase = await createSupabaseServerClient();

const groupSchema = z.object({
  category_id: z.string().uuid(),
  name: z.string().min(1, "Name is required"),
  code: z.string().optional(),
  active: z.boolean().default(true),
});

const updateGroupSchema = groupSchema.extend({
  id: z.string().uuid(),
});

const TABLE = "product_groups";
const LIST = "/(protected)/master/products/groups";

export async function createGroup(formData: FormData) {
  try {
    const data = {
      category_id: formData.get("category_id") as string,
      name: formData.get("name") as string,
      code: formData.get("code") as string || undefined,
      active: formData.get("active") === "on" || formData.get("active") === "true",
    };

    const parsed = groupSchema.parse(data);
    
    const { error } = await supabase
      .from(TABLE)
      .insert([parsed]);

    if (error) throw error;

    revalidatePath(LIST);
    return { success: true };
  } catch (error) {
    console.error("Error creating group:", error);
    return { success: false, error: error instanceof Error ? error.message : "Unknown error" };
  }
}

export async function updateGroup(formData: FormData) {
  try {
    const data = {
      id: formData.get("id") as string,
      category_id: formData.get("category_id") as string,
      name: formData.get("name") as string,
      code: formData.get("code") as string || undefined,
      active: formData.get("active") === "on" || formData.get("active") === "true",
    };

    const parsed = updateGroupSchema.parse(data);
    const { id, ...updateData } = parsed;
    
    const { error } = await supabase
      .from(TABLE)
      .update({ ...updateData, updated_at: new Date().toISOString() })
      .eq("id", id);

    if (error) throw error;

    revalidatePath(LIST);
    return { success: true };
  } catch (error) {
    console.error("Error updating group:", error);
    return { success: false, error: error instanceof Error ? error.message : "Unknown error" };
  }
}

export async function deleteGroup(id: string) {
  try {
    const { error } = await supabase
      .from(TABLE)
      .delete()
      .eq("id", id);

    if (error) throw error;

    revalidatePath(LIST);
    return { success: true };
  } catch (error) {
    console.error("Error deleting group:", error);
    return { success: false, error: error instanceof Error ? error.message : "Unknown error" };
  }
}