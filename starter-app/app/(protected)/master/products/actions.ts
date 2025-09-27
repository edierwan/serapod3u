"use server";

import { createSupabaseServerClient } from "@/lib/supabase/server";
import { revalidatePath } from "next/cache";
import { z } from "zod";
import type { ProductGroupWithCategory, ProductVariantWithProduct } from "@/lib/types/master";

export type ActionResult = { ok: true } | { ok: false; message: string };

// Master Data Schemas
const CategorySchema = z.object({
  name: z.string().min(1, "Name is required"),
});

const BrandSchema = z.object({
  name: z.string().min(1, "Name is required"),
  category_id: z.string().uuid("Valid category is required"),
});

const ProductGroupSchema = z.object({
  name: z.string().min(1, "Name is required"),
  category_id: z.string().uuid("Valid category is required"),
});

const ProductSubGroupSchema = z.object({
  name: z.string().min(1, "Name is required"),
  group_id: z.string().uuid("Valid group is required"),
});

const ManufacturerSchema = z.object({
  name: z.string().min(1, "Name is required"),
  legal_name: z.string().optional(),
  brand_name: z.string().optional(),
  contact_person: z.string().optional(),
  phone: z.string().optional(),
  email: z.string().email().optional().or(z.literal("")),
  address: z.string().optional(),
  registration_number: z.string().optional(),
  tax_id: z.string().optional(),
  country_code: z.string().length(2).optional(),
  website_url: z.string().url().optional().or(z.literal("")),
  support_email: z.string().email().optional().or(z.literal("")),
  support_phone: z.string().optional(),
  whatsapp: z.string().optional(),
  address_line1: z.string().optional(),
  address_line2: z.string().optional(),
  city: z.string().optional(),
  state_region: z.string().optional(),
  postal_code: z.string().optional(),
  secondary_email: z.string().email().optional().or(z.literal("")),
  fax: z.string().optional(),
});

const ProductSchema = z.object({
  name: z.string().min(1, "Name is required"),
  category_id: z.string().uuid("Valid category is required"),
  brand_id: z.string().uuid("Valid brand is required"),
  group_id: z.string().uuid("Valid group is required"),
  sub_group_id: z.string().uuid("Valid sub-group is required"),
  manufacturer_id: z.string().uuid("Valid manufacturer is required"),
  price: z.number().nonnegative().optional(),
  status: z.enum(["active", "inactive"]).default("active"),
});

const ProductVariantSchema = z.object({
  product_id: z.string().uuid("Valid product is required"),
  flavor_name: z.string().optional(),
  nic_strength: z.string().optional(),
  packaging: z.string().optional(),
});

// Permission check
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

// ==================== CATEGORIES ====================

export async function getCategories() {
  const supabase = await createSupabaseServerClient();
  const { data, error } = await supabase
    .from("categories")
    .select("id, name, is_active, created_at, updated_at")
    .eq("is_active", true)
    .order("name");

  if (error) {
    console.error("Error fetching categories:", error);
    return [];
  }
  return data || [];
}

export async function createCategory(formData: FormData): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to create categories." };
    }

    const data = {
      name: formData.get("name") as string,
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

    revalidatePath("/master/products");
    return { ok: true };
  } catch (error) {
    console.error("Create category error:", error);
    return { ok: false, message: "Failed to create category" };
  }
}

export async function updateCategory(id: string, formData: FormData): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to update categories." };
    }

    const data = {
      name: formData.get("name") as string,
    };

    const validated = CategorySchema.parse(data);

    const supabase = await createSupabaseServerClient();
    const { error } = await supabase
      .from("categories")
      .update(validated)
      .eq("id", id);

    if (error) {
      if (error.code === "23505") {
        return { ok: false, message: "A category with this name already exists." };
      }
      throw error;
    }

    revalidatePath("/master/products");
    return { ok: true };
  } catch (error) {
    console.error("Update category error:", error);
    return { ok: false, message: "Failed to update category" };
  }
}

export async function deleteCategory(id: string): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to delete categories." };
    }

    const supabase = await createSupabaseServerClient();
    const { error } = await supabase
      .from("categories")
      .update({ is_active: false })
      .eq("id", id);

    if (error) {
      throw error;
    }

    revalidatePath("/master/products");
    return { ok: true };
  } catch (error) {
    console.error("Delete category error:", error);
    return { ok: false, message: "Failed to delete category" };
  }
}

// ==================== BRANDS ====================

export async function getBrands(categoryId?: string) {
  const supabase = await createSupabaseServerClient();
  let query = supabase
    .from("brands")
    .select(`
      id, name, is_active, created_at, updated_at,
      category:categories(id, name)
    `)
    .eq("is_active", true);

  if (categoryId) {
    query = query.eq("category_id", categoryId);
  }

  const { data, error } = await query.order("name");

  if (error) {
    console.error("Error fetching brands:", error);
    return [];
  }
  return data || [];
}

export async function createBrand(formData: FormData): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to create brands." };
    }

    const data = {
      name: formData.get("name") as string,
      category_id: formData.get("category_id") as string,
    };

    const validated = BrandSchema.parse(data);

    const supabase = await createSupabaseServerClient();
    const { error } = await supabase
      .from("brands")
      .insert([validated]);

    if (error) {
      if (error.code === "23505") {
        return { ok: false, message: "A brand with this name already exists." };
      }
      throw error;
    }

    revalidatePath("/master/products");
    return { ok: true };
  } catch (error) {
    console.error("Create brand error:", error);
    return { ok: false, message: "Failed to create brand" };
  }
}

export async function updateBrand(id: string, formData: FormData): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to update brands." };
    }

    const data = {
      name: formData.get("name") as string,
      category_id: formData.get("category_id") as string,
    };

    const validated = BrandSchema.parse(data);

    const supabase = await createSupabaseServerClient();
    const { error } = await supabase
      .from("brands")
      .update(validated)
      .eq("id", id);

    if (error) {
      if (error.code === "23505") {
        return { ok: false, message: "A brand with this name already exists." };
      }
      throw error;
    }

    revalidatePath("/master/products");
    return { ok: true };
  } catch (error) {
    console.error("Update brand error:", error);
    return { ok: false, message: "Failed to update brand" };
  }
}

export async function deleteBrand(id: string): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to delete brands." };
    }

    const supabase = await createSupabaseServerClient();
    const { error } = await supabase
      .from("brands")
      .update({ is_active: false })
      .eq("id", id);

    if (error) {
      throw error;
    }

    revalidatePath("/master/products");
    return { ok: true };
  } catch (error) {
    console.error("Delete brand error:", error);
    return { ok: false, message: "Failed to delete brand" };
  }
}

// ==================== PRODUCT GROUPS ====================

export async function getProductGroups(categoryId?: string): Promise<ProductGroupWithCategory[]> {
  const supabase = await createSupabaseServerClient();
  let query = supabase
    .from("product_groups")
    .select(`
      id, name, is_active, created_at, updated_at,
      category:categories(id, name)
    `)
    .eq("is_active", true);

  if (categoryId) {
    query = query.eq("category_id", categoryId);
  }

  const { data, error } = await query.order("name");

  if (error) {
    console.error("Error fetching product groups:", error);
    return [];
  }

  // Transform the data to match the expected interface
  const transformedData = (data || []).map(group => ({
    ...group,
    category: Array.isArray(group.category) ? group.category[0] : group.category,
  }));

  return transformedData;
}

export async function createProductGroup(formData: FormData): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to create product groups." };
    }

    const data = {
      name: formData.get("name") as string,
      category_id: formData.get("category_id") as string,
    };

    const validated = ProductGroupSchema.parse(data);

    const supabase = await createSupabaseServerClient();
    const { error } = await supabase
      .from("product_groups")
      .insert([validated]);

    if (error) {
      throw error;
    }

    revalidatePath("/master/products");
    return { ok: true };
  } catch (error) {
    console.error("Create product group error:", error);
    return { ok: false, message: "Failed to create product group" };
  }
}

export async function updateProductGroup(id: string, formData: FormData): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to update product groups." };
    }

    const data = {
      name: formData.get("name") as string,
      category_id: formData.get("category_id") as string,
    };

    const validated = ProductGroupSchema.parse(data);

    const supabase = await createSupabaseServerClient();
    const { error } = await supabase
      .from("product_groups")
      .update(validated)
      .eq("id", id);

    if (error) {
      throw error;
    }

    revalidatePath("/master/products");
    return { ok: true };
  } catch (error) {
    console.error("Update product group error:", error);
    return { ok: false, message: "Failed to update product group" };
  }
}

export async function deleteProductGroup(id: string): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to delete product groups." };
    }

    const supabase = await createSupabaseServerClient();
    const { error } = await supabase
      .from("product_groups")
      .update({ is_active: false })
      .eq("id", id);

    if (error) {
      throw error;
    }

    revalidatePath("/master/products");
    return { ok: true };
  } catch (error) {
    console.error("Delete product group error:", error);
    return { ok: false, message: "Failed to delete product group" };
  }
}

// ==================== PRODUCT SUB-GROUPS ====================

export async function getProductSubGroups(groupId?: string) {
  const supabase = await createSupabaseServerClient();
  let query = supabase
    .from("product_subgroups")
    .select(`
      id, name, is_active, created_at, updated_at,
      group:product_groups(id, name, category_id)
    `)
    .eq("is_active", true);

  if (groupId) {
    query = query.eq("group_id", groupId);
  }

  const { data, error } = await query.order("name");

  if (error) {
    console.error("Error fetching product sub-groups:", error);
    return [];
  }
  return data || [];
}

export async function createProductSubGroup(formData: FormData): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to create product sub-groups." };
    }

    const data = {
      name: formData.get("name") as string,
      group_id: formData.get("group_id") as string,
    };

    const validated = ProductSubGroupSchema.parse(data);

    const supabase = await createSupabaseServerClient();
    const { error } = await supabase
      .from("product_subgroups")
      .insert([validated]);

    if (error) {
      throw error;
    }

    revalidatePath("/master/products");
    return { ok: true };
  } catch (error) {
    console.error("Create product sub-group error:", error);
    return { ok: false, message: "Failed to create product sub-group" };
  }
}

export async function updateProductSubGroup(id: string, formData: FormData): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to update product sub-groups." };
    }

    const data = {
      name: formData.get("name") as string,
      group_id: formData.get("group_id") as string,
    };

    const validated = ProductSubGroupSchema.parse(data);

    const supabase = await createSupabaseServerClient();
    const { error } = await supabase
      .from("product_subgroups")
      .update(validated)
      .eq("id", id);

    if (error) {
      throw error;
    }

    revalidatePath("/master/products");
    return { ok: true };
  } catch (error) {
    console.error("Update product sub-group error:", error);
    return { ok: false, message: "Failed to update product sub-group" };
  }
}

export async function deleteProductSubGroup(id: string): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to delete product sub-groups." };
    }

    const supabase = await createSupabaseServerClient();
    const { error } = await supabase
      .from("product_subgroups")
      .update({ is_active: false })
      .eq("id", id);

    if (error) {
      throw error;
    }

    revalidatePath("/master/products");
    return { ok: true };
  } catch (error) {
    console.error("Delete product sub-group error:", error);
    return { ok: false, message: "Failed to delete product sub-group" };
  }
}

// ==================== MANUFACTURERS ====================

export async function getManufacturers() {
  const supabase = await createSupabaseServerClient();
  const { data, error } = await supabase
    .from("manufacturers")
    .select(`
      id, name, legal_name, brand_name, contact_person, phone, email,
      address, registration_number, tax_id, country_code, website_url,
      support_email, support_phone, whatsapp, address_line1, address_line2,
      city, state_region, postal_code, secondary_email, fax,
      is_active, status, created_at, updated_at
    `)
    .eq("is_active", true)
    .order("name");

  if (error) {
    console.error("Error fetching manufacturers:", error);
    return [];
  }
  return data || [];
}

export async function createManufacturer(formData: FormData): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to create manufacturers." };
    }

    const data = {
      name: formData.get("name") as string,
      legal_name: formData.get("legal_name") as string || undefined,
      brand_name: formData.get("brand_name") as string || undefined,
      contact_person: formData.get("contact_person") as string || undefined,
      phone: formData.get("phone") as string || undefined,
      email: formData.get("email") as string || undefined,
      address: formData.get("address") as string || undefined,
      registration_number: formData.get("registration_number") as string || undefined,
      tax_id: formData.get("tax_id") as string || undefined,
      country_code: formData.get("country_code") as string || undefined,
      website_url: formData.get("website_url") as string || undefined,
      support_email: formData.get("support_email") as string || undefined,
      support_phone: formData.get("support_phone") as string || undefined,
      whatsapp: formData.get("whatsapp") as string || undefined,
      address_line1: formData.get("address_line1") as string || undefined,
      address_line2: formData.get("address_line2") as string || undefined,
      city: formData.get("city") as string || undefined,
      state_region: formData.get("state_region") as string || undefined,
      postal_code: formData.get("postal_code") as string || undefined,
      secondary_email: formData.get("secondary_email") as string || undefined,
      fax: formData.get("fax") as string || undefined,
    };

    const validated = ManufacturerSchema.parse(data);

    const supabase = await createSupabaseServerClient();
    const { error } = await supabase
      .from("manufacturers")
      .insert([validated]);

    if (error) {
      throw error;
    }

    revalidatePath("/master/products");
    return { ok: true };
  } catch (error) {
    console.error("Create manufacturer error:", error);
    return { ok: false, message: "Failed to create manufacturer" };
  }
}

export async function updateManufacturer(id: string, formData: FormData): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to update manufacturers." };
    }

    const data = {
      name: formData.get("name") as string,
      legal_name: formData.get("legal_name") as string || undefined,
      brand_name: formData.get("brand_name") as string || undefined,
      contact_person: formData.get("contact_person") as string || undefined,
      phone: formData.get("phone") as string || undefined,
      email: formData.get("email") as string || undefined,
      address: formData.get("address") as string || undefined,
      registration_number: formData.get("registration_number") as string || undefined,
      tax_id: formData.get("tax_id") as string || undefined,
      country_code: formData.get("country_code") as string || undefined,
      website_url: formData.get("website_url") as string || undefined,
      support_email: formData.get("support_email") as string || undefined,
      support_phone: formData.get("support_phone") as string || undefined,
      whatsapp: formData.get("whatsapp") as string || undefined,
      address_line1: formData.get("address_line1") as string || undefined,
      address_line2: formData.get("address_line2") as string || undefined,
      city: formData.get("city") as string || undefined,
      state_region: formData.get("state_region") as string || undefined,
      postal_code: formData.get("postal_code") as string || undefined,
      secondary_email: formData.get("secondary_email") as string || undefined,
      fax: formData.get("fax") as string || undefined,
    };

    const validated = ManufacturerSchema.parse(data);

    const supabase = await createSupabaseServerClient();
    const { error } = await supabase
      .from("manufacturers")
      .update(validated)
      .eq("id", id);

    if (error) {
      throw error;
    }

    revalidatePath("/master/products");
    return { ok: true };
  } catch (error) {
    console.error("Update manufacturer error:", error);
    return { ok: false, message: "Failed to update manufacturer" };
  }
}

export async function deleteManufacturer(id: string): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to delete manufacturers." };
    }

    const supabase = await createSupabaseServerClient();
    const { error } = await supabase
      .from("manufacturers")
      .update({ is_active: false })
      .eq("id", id);

    if (error) {
      throw error;
    }

    revalidatePath("/master/products");
    return { ok: true };
  } catch (error) {
    console.error("Delete manufacturer error:", error);
    return { ok: false, message: "Failed to delete manufacturer" };
  }
}

// ==================== PRODUCTS ====================

export async function getProducts(search?: string) {
  const supabase = await createSupabaseServerClient();

  let query = supabase
    .from("products")
    .select(`
      id, name, sku, price, status, image_url, created_at, updated_at,
      category:categories(id, name),
      brand:brands(id, name),
      group:product_groups(id, name),
      sub_group:product_subgroups(id, name),
      manufacturer:manufacturers(id, name)
    `)
    .eq("is_active", true);

  if (search) {
    query = query.ilike("name", `%${search}%`);
  }

  const { data, error } = await query
    .order("updated_at", { ascending: false });

  if (error) {
    console.error("Error fetching products:", error);
    return [];
  }

  // Transform the data to match the expected interface
  const transformedData = (data || []).map(product => ({
    ...product,
    category: Array.isArray(product.category) ? product.category[0] : product.category,
    brand: Array.isArray(product.brand) ? product.brand[0] : product.brand,
    group: Array.isArray(product.group) ? product.group[0] : product.group,
    sub_group: Array.isArray(product.sub_group) ? product.sub_group[0] : product.sub_group,
    manufacturer: Array.isArray(product.manufacturer) ? product.manufacturer[0] : product.manufacturer,
  }));

  return transformedData;
}

export async function createProduct(formData: FormData): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to create products." };
    }

    const data = {
      name: formData.get("name") as string,
      category_id: formData.get("category_id") as string,
      brand_id: formData.get("brand_id") as string,
      group_id: formData.get("group_id") as string,
      sub_group_id: formData.get("sub_group_id") as string,
      manufacturer_id: formData.get("manufacturer_id") as string,
      price: formData.get("price") ? parseFloat(formData.get("price") as string) : undefined,
      status: (formData.get("status") as string) || "active",
    };

    const validated = ProductSchema.parse(data);

    const supabase = await createSupabaseServerClient();
    const { error } = await supabase
      .from("products")
      .insert([validated]);

    if (error) {
      if (error.code === "23505") {
        return { ok: false, message: "A product with this combination already exists." };
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

export async function updateProduct(id: string, formData: FormData): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to update products." };
    }

    const data = {
      name: formData.get("name") as string,
      category_id: formData.get("category_id") as string,
      brand_id: formData.get("brand_id") as string,
      group_id: formData.get("group_id") as string,
      sub_group_id: formData.get("sub_group_id") as string,
      manufacturer_id: formData.get("manufacturer_id") as string,
      price: formData.get("price") ? parseFloat(formData.get("price") as string) : undefined,
      status: formData.get("status") as string,
    };

    const validated = ProductSchema.parse(data);

    const supabase = await createSupabaseServerClient();
    const { error } = await supabase
      .from("products")
      .update(validated)
      .eq("id", id);

    if (error) {
      if (error.code === "23505") {
        return { ok: false, message: "A product with this combination already exists." };
      }
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
      .update({ is_active: false })
      .eq("id", id);

    if (error) {
      throw error;
    }

    revalidatePath("/master/products");
    return { ok: true };
  } catch (error) {
    console.error("Delete product error:", error);
    return { ok: false, message: "Failed to delete product" };
  }
}

// ==================== PRODUCT VARIANTS ====================

export async function getProductVariants(productId?: string): Promise<ProductVariantWithProduct[]> {
  const supabase = await createSupabaseServerClient();
  let query = supabase
    .from("product_variants")
    .select(`
      id, flavor_name, nic_strength, packaging, sku, is_active, created_at, updated_at,
      product:products(id, name)
    `)
    .eq("is_active", true);

  if (productId) {
    query = query.eq("product_id", productId);
  }

  const { data, error } = await query.order("created_at", { ascending: false });

  if (error) {
    console.error("Error fetching product variants:", error);
    return [];
  }

  // Transform the data to match the expected interface
  const transformedData = (data || []).map(variant => ({
    ...variant,
    product: Array.isArray(variant.product) ? variant.product[0] : variant.product,
  }));

  return transformedData;
}

export async function createProductVariant(formData: FormData): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to create product variants." };
    }

    const data = {
      product_id: formData.get("product_id") as string,
      flavor_name: formData.get("flavor_name") as string || undefined,
      nic_strength: formData.get("nic_strength") as string || undefined,
      packaging: formData.get("packaging") as string || undefined,
    };

    const validated = ProductVariantSchema.parse(data);

    const supabase = await createSupabaseServerClient();
    const { error } = await supabase
      .from("product_variants")
      .insert([validated]);

    if (error) {
      if (error.code === "23505") {
        return { ok: false, message: "A variant with this combination already exists." };
      }
      throw error;
    }

    revalidatePath("/master/products");
    return { ok: true };
  } catch (error) {
    console.error("Create product variant error:", error);
    return { ok: false, message: "Failed to create product variant" };
  }
}

export async function updateProductVariant(id: string, formData: FormData): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to update product variants." };
    }

    const data = {
      product_id: formData.get("product_id") as string,
      flavor_name: formData.get("flavor_name") as string || undefined,
      nic_strength: formData.get("nic_strength") as string || undefined,
      packaging: formData.get("packaging") as string || undefined,
    };

    const validated = ProductVariantSchema.parse(data);

    const supabase = await createSupabaseServerClient();
    const { error } = await supabase
      .from("product_variants")
      .update(validated)
      .eq("id", id);

    if (error) {
      if (error.code === "23505") {
        return { ok: false, message: "A variant with this combination already exists." };
      }
      throw error;
    }

    revalidatePath("/master/products");
    return { ok: true };
  } catch (error) {
    console.error("Update product variant error:", error);
    return { ok: false, message: "Failed to update product variant" };
  }
}

export async function deleteProductVariant(id: string): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to delete product variants." };
    }

    const supabase = await createSupabaseServerClient();
    const { error } = await supabase
      .from("product_variants")
      .update({ is_active: false })
      .eq("id", id);

    if (error) {
      throw error;
    }

    revalidatePath("/master/products");
    return { ok: true };
  } catch (error) {
    console.error("Delete product variant error:", error);
    return { ok: false, message: "Failed to delete product variant" };
  }
}
