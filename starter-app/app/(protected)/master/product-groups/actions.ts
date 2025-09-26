"use server";

import { createSupabaseServerClient } from "@/lib/supabase/server";
import { revalidatePath } from "next/cache";
import { z } from "zod";
import type { ProductCategoryValue } from "@/lib/constants/productCategories";
import { CATEGORY_ENUM_TO_NAME_MAP } from "@/lib/constants/productCategories";

export type ActionResult = { ok: true } | { ok: false; message: string };

const ProductGroupSchema = z.object({
  name: z.string().min(1, "Name is required"),
  category: z.enum(["vape", "nonvape"]),
  is_active: z.boolean().default(true)
});

async function getCategoryIdByName(categoryName: string): Promise<string | null> {
  const supabase = await createSupabaseServerClient();
  const { data, error } = await supabase
    .from("categories")
    .select("id")
    .eq("name", categoryName)
    .single();
    
  if (error || !data) {
    console.error("Error fetching category ID:", error);
    return null;
  }
  
  return data.id;
}

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

export async function createProductGroup(formData: FormData): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to modify Master Data." };
    }

    const data = {
      name: formData.get("name") as string,
      category: formData.get("category") as ProductCategoryValue,
      is_active: formData.get("is_active") === "true"
    };

    const validated = ProductGroupSchema.parse(data);
    
    // Convert enum to category_id
    const categoryName = CATEGORY_ENUM_TO_NAME_MAP[validated.category];
    const categoryId = await getCategoryIdByName(categoryName);
    
    if (!categoryId) {
      return { ok: false, message: "Invalid category selected." };
    }
    
    const supabase = await createSupabaseServerClient();

    const { error } = await supabase
      .from("product_groups")
      .insert([{
        name: validated.name,
        category_id: categoryId,
        is_active: validated.is_active
      }]);

    if (error) {
      if (error.code === "23505") {
        return { ok: false, message: "A product group with this name already exists." };
      }
      throw error;
    }

    revalidatePath("/master/product-groups");
    return { ok: true };
  } catch (error) {
    console.error("Create product group error:", error);
    return { ok: false, message: "Failed to create product group" };
  }
}

export async function updateProductGroup(id: string, formData: FormData): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to modify Master Data." };
    }

    const data = {
      name: formData.get("name") as string,
      category: formData.get("category") as ProductCategoryValue,
      is_active: formData.get("is_active") === "true"
    };

    const validated = ProductGroupSchema.parse(data);
    
    // Convert enum to category_id
    const categoryName = CATEGORY_ENUM_TO_NAME_MAP[validated.category];
    const categoryId = await getCategoryIdByName(categoryName);
    
    if (!categoryId) {
      return { ok: false, message: "Invalid category selected." };
    }
    
    const supabase = await createSupabaseServerClient();

    const { error } = await supabase
      .from("product_groups")
      .update({
        name: validated.name,
        category_id: categoryId,
        is_active: validated.is_active,
        updated_at: new Date().toISOString()
      })
      .eq("id", id);

    if (error) {
      if (error.code === "23505") {
        return { ok: false, message: "A product group with this name already exists." };
      }
      throw error;
    }

    revalidatePath("/master/product-groups");
    return { ok: true };
  } catch (error) {
    console.error("Update product group error:", error);
    return { ok: false, message: "Failed to update product group" };
  }
}

export async function deleteProductGroup(id: string): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to modify Master Data." };
    }

    const supabase = await createSupabaseServerClient();

    const { error } = await supabase
      .from("product_groups")
      .delete()
      .eq("id", id);

    if (error) {
      if (error.code === "23503") {
        return { ok: false, message: "This product group is linked to products and cannot be deleted." };
      }
      throw error;
    }

    revalidatePath("/master/product-groups");
    return { ok: true };
  } catch (error) {
    console.error("Delete product group error:", error);
    return { ok: false, message: "Failed to delete product group" };
  }
}