"use server";

import { createSupabaseServerClient } from "@/lib/supabase/server";
import { revalidatePath } from "next/cache";
import { z } from "zod";

export type ActionResult = { ok: true } | { ok: false; message: string };

const CreateProductSchema = z.object({
  name: z.string().min(1, "Name is required"),
  price: z.number().nonnegative().optional(),
  status: z.enum(["active", "inactive"]).default("active"),
  category_id: z.string().uuid("Valid category is required"),
  brand_id: z.string().uuid("Valid brand is required"),
  group_id: z.string().uuid("Valid group is required"),
  sub_group_id: z.string().uuid("Valid sub-group is required"),
  manufacturer_id: z.string().uuid("Valid manufacturer is required"),
});

const UpdateProductSchema = CreateProductSchema.partial().extend({
  id: z.string().uuid()
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

// Generate unique SKU
async function generateSKU(): Promise<string> {
  const supabase = await createSupabaseServerClient();
  let attempts = 0;
  
  while (attempts < 3) {
    const sku = "P" + Date.now().toString().slice(-8);
    
    const { data, error } = await supabase
      .from("products")
      .select("id")
      .eq("sku", sku)
      .limit(1);
      
    if (error || !data || data.length === 0) {
      return sku;
    }
    
    attempts++;
    // Small delay to ensure different timestamp
    await new Promise(resolve => setTimeout(resolve, 1));
  }
  
  throw new Error("Failed to generate unique SKU");
}

// Check for duplicate product
async function checkDuplicate(data: any): Promise<boolean> {
  const supabase = await createSupabaseServerClient();
  
  const { data: existing, error } = await supabase
    .from("products")
    .select("id", { count: "exact", head: true })
    .eq("category_id", data.category_id)
    .eq("brand_id", data.brand_id)
    .eq("group_id", data.group_id)
    .eq("sub_group_id", data.sub_group_id)
    .eq("manufacturer_id", data.manufacturer_id)
    .ilike("name", data.name);
    
  return !error && existing && existing.length > 0;
}

export async function getProducts() {
  const supabase = await createSupabaseServerClient();
  
  const { data: products, error } = await supabase
    .from("products")
    .select(`
      id, name, sku, price, status, image_url,
      category:categories(name),
      brand:brands(name),
      group:product_groups(name),
      sub_group:product_subgroups(name),
      manufacturer:manufacturers(name)
    `)
    .order("updated_at", { ascending: false });

  if (error) {
    console.error("Error fetching products:", error);
    return [];
  }

  return products || [];
}

export async function createProduct(formData: FormData): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to create products." };
    }

    const data = {
      name: formData.get("name") as string,
      price: formData.get("price") ? parseFloat(formData.get("price") as string) : undefined,
      status: (formData.get("status") as string) || "active",
      category_id: formData.get("category_id") as string,
      brand_id: formData.get("brand_id") as string,
      group_id: formData.get("group_id") as string,
      sub_group_id: formData.get("sub_group_id") as string,
      manufacturer_id: formData.get("manufacturer_id") as string,
    };

    const validated = CreateProductSchema.parse(data);

    // Check for duplicates
    if (await checkDuplicate(validated)) {
      return { ok: false, message: "This product combination already exists." };
    }

    // Generate SKU if not provided
    const sku = await generateSKU();

    const supabase = await createSupabaseServerClient();

    const { data: product, error } = await supabase
      .from("products")
      .insert([{
        ...validated,
        sku,
        image_url: null // Will be updated after image upload
      }])
      .select()
      .single();

    if (error) {
      if (error.code === "23505") {
        return { ok: false, message: "A product with this SKU already exists." };
      }
      throw error;
    }

    revalidatePath("/master/products");
    return { ok: true };
  } catch (error) {
    console.error("Create product error:", error);
    return { ok: false, message: "Failed to create product" };
  }
}

export async function updateProduct(formData: FormData): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to update products." };
    }

    const data = {
      id: formData.get("id") as string,
      name: formData.get("name") as string,
      price: formData.get("price") ? parseFloat(formData.get("price") as string) : undefined,
      status: formData.get("status") as string,
      category_id: formData.get("category_id") as string,
      brand_id: formData.get("brand_id") as string,
      group_id: formData.get("group_id") as string,
      sub_group_id: formData.get("sub_group_id") as string,
      manufacturer_id: formData.get("manufacturer_id") as string,
    };

    const validated = UpdateProductSchema.parse(data);
    const { id, ...updateData } = validated;

    const supabase = await createSupabaseServerClient();

    const { error } = await supabase
      .from("products")
      .update({
        ...updateData,
        updated_at: new Date().toISOString()
      })
      .eq("id", id);

    if (error) {
      throw error;
    }

    revalidatePath("/master/products");
    return { ok: true };
  } catch (error) {
    console.error("Update product error:", error);
    return { ok: false, message: "Failed to update product" };
  }
}

export async function deleteProduct(id: string): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to delete products." };
    }

    const supabase = await createSupabaseServerClient();

    const { error } = await supabase
      .from("products")
      .delete()
      .eq("id", id);

    if (error) {
      if (error.code === "23503") {
        return { ok: false, message: "This product cannot be deleted as it has related records." };
      }
      throw error;
    }

    revalidatePath("/master/products");
    return { ok: true };
  } catch (error) {
    console.error("Delete product error:", error);
    return { ok: false, message: "Failed to delete product" };
  }
}

export async function updateProductImage(productId: string, imageUrl: string): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to update products." };
    }

    const supabase = await createSupabaseServerClient();

    const { error } = await supabase
      .from("products")
      .update({ 
        image_url: imageUrl,
        updated_at: new Date().toISOString()
      })
      .eq("id", productId);

    if (error) {
      throw error;
    }

    revalidatePath("/master/products");
    return { ok: true };
  } catch (error) {
    console.error("Update product image error:", error);
    return { ok: false, message: "Failed to update product image" };
  }
}

// Helper functions for dropdowns
export async function getCategories() {
  const supabase = await createSupabaseServerClient();
  const { data } = await supabase
    .from("categories")
    .select("id, name")
    .eq("is_active", true)
    .order("name");
  return data || [];
}

export async function getBrands() {
  const supabase = await createSupabaseServerClient();
  const { data } = await supabase
    .from("brands")
    .select("id, name")
    .eq("is_active", true)
    .order("name");
  return data || [];
}

export async function getProductGroups(categoryId?: string) {
  const supabase = await createSupabaseServerClient();
  let query = supabase
    .from("product_groups")
    .select("id, name, category_id")
    .eq("is_active", true);
    
  if (categoryId) {
    query = query.eq("category_id", categoryId);
  }
  
  const { data } = await query.order("name");
  return data || [];
}

export async function getProductSubGroups(groupId?: string) {
  const supabase = await createSupabaseServerClient();
  let query = supabase
    .from("product_subgroups")
    .select("id, name, group_id")
    .eq("is_active", true);
    
  if (groupId) {
    query = query.eq("group_id", groupId);
  }
  
  const { data } = await query.order("name");
  return data || [];
}

export async function getManufacturers() {
  const supabase = await createSupabaseServerClient();
  const { data } = await supabase
    .from("manufacturers")
    .select("id, name")
    .eq("is_active", true)
    .order("name");
  return data || [];
}