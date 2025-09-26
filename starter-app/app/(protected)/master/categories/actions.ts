"use server";

import { createSupabaseServerClient } from "@/lib/supabase/server";
import { revalidatePath } from "next/cache";
import { z } from "zod";

export type ActionResult = { ok: true } | { ok: false; message: string };

const CategorySchema = z.object({
  name: z.string().min(1, "Name is required"),
  is_active: z.boolean().default(true)
});

async function checkPermission(): Promise<boolean> {
  const supabase = await createSupabaseServerClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return false;

  const { data: profile } = await supabase
    .from("profiles")
    .select("role_code")
    .eq("id", user.id)
    .single();

  return profile?.role_code === "hq_admin" || profile?.role_code === "power_user";
}

export async function createCategory(formData: FormData): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to modify Master Data." };
    }

    const data = {
      name: formData.get("name") as string,
      is_active: formData.get("is_active") === "true"
    };

    const validated = CategorySchema.parse(data);
    const supabase = await createSupabaseServerClient();

    const { error } = await supabase
      .from("categories")
      .insert([validated]);

    if (error) {
      if (error.code === "23505") {
        return { ok: false, message: "A category with this name already exists." };
      }
      throw error;
    }

    revalidatePath("/master/categories");
    return { ok: true };
  } catch (error) {
    console.error("Create category error:", error);
    return { ok: false, message: "Failed to create category" };
  }
}

export async function updateCategory(id: string, formData: FormData): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to modify Master Data." };
    }

    const data = {
      name: formData.get("name") as string,
      is_active: formData.get("is_active") === "true"
    };

    const validated = CategorySchema.parse(data);
    const supabase = await createSupabaseServerClient();

    const { error } = await supabase
      .from("categories")
      .update({
        ...validated,
        updated_at: new Date().toISOString()
      })
      .eq("id", id);

    if (error) {
      if (error.code === "23505") {
        return { ok: false, message: "A category with this name already exists." };
      }
      throw error;
    }

    revalidatePath("/master/categories");
    return { ok: true };
  } catch (error) {
    console.error("Update category error:", error);
    return { ok: false, message: "Failed to update category" };
  }
}

export async function deleteCategory(id: string): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to modify Master Data." };
    }

    const supabase = await createSupabaseServerClient();

    const { error } = await supabase
      .from("categories")
      .delete()
      .eq("id", id);

    if (error) {
      if (error.code === "23503") {
        return { ok: false, message: "This category is linked to products and cannot be deleted." };
      }
      throw error;
    }

    revalidatePath("/master/categories");
    return { ok: true };
  } catch (error) {
    console.error("Delete category error:", error);
    return { ok: false, message: "Failed to delete category" };
  }
}