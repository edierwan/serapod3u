"use server";

import { createSupabaseServerClient } from "@/lib/supabase/server";
import { revalidatePath } from "next/cache";
import { z } from "zod";

export type ActionResult = { ok: true } | { ok: false; message: string };

// Schemas
const BrandSchema = z.object({
  name: z.string().min(1, "Name is required"),
  is_active: z.boolean().default(true)
});

const ManufacturerSchema = z.object({
  name: z.string().min(1, "Name is required"),
  legal_name: z.string().optional(),
  brand_name: z.string().optional(),
  registration_number: z.string().optional(),
  tax_id: z.string().optional(),
  contact_person: z.string().optional(),
  phone: z.string().optional(),
  email: z.string().email().optional().or(z.literal("")),
  secondary_email: z.string().email().optional().or(z.literal("")),
  support_email: z.string().email().optional().or(z.literal("")),
  support_phone: z.string().optional(),
  whatsapp: z.string().optional(),
  fax: z.string().optional(),
  address_line1: z.string().optional(),
  address_line2: z.string().optional(),
  city: z.string().optional(),
  state_region: z.string().optional(),
  postal_code: z.string().optional(),
  country_code: z.string().length(2).optional(),
  website_url: z.string().url().optional().or(z.literal("")),
  timezone: z.string().optional(),
  language_code: z.string().length(2).optional(),
  currency_code: z.string().length(3).optional(),
  logo_url: z.string().optional(),
  social_links: z.string().optional(), // JSON string
  certifications: z.string().optional(), // JSON string
  notes: z.string().optional(),
  status: z.enum(["active", "inactive", "blocked"]).default("active"),
  is_active: z.boolean().default(true)
});

const ProductGroupSchema = z.object({
  name: z.string().min(1, "Name is required"),
  category_id: z.string().uuid("Valid category is required"),
  is_active: z.boolean().default(true)
});

const ProductSubGroupSchema = z.object({
  name: z.string().min(1, "Name is required"),
  group_id: z.string().uuid("Valid group is required"),
  is_active: z.boolean().default(true)
});

const ProductVariantSchema = z.object({
  name: z.string().min(1, "Name is required"),
  product_id: z.string().uuid("Valid product is required"),
  sku: z.string().optional()
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

// BRAND ACTIONS
export async function getBrands() {
  const supabase = await createSupabaseServerClient();
  const { data } = await supabase
    .from("brands")
    .select("*")
    .order("name");
  return data || [];
}

export async function createBrand(formData: FormData): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to create brands." };
    }

    const data = BrandSchema.parse({
      name: formData.get("name"),
      is_active: formData.has("is_active")
    });

    const supabase = await createSupabaseServerClient();
    const { error } = await supabase.from("brands").insert([data]);

    if (error) {
      if (error.code === "23505") {
        return { ok: false, message: "A brand with this name already exists." };
      }
      throw error;
    }

    revalidatePath("/(protected)/master/products");
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

    const data = BrandSchema.parse({
      name: formData.get("name"),
      is_active: formData.has("is_active")
    });

    const supabase = await createSupabaseServerClient();
    const { error } = await supabase
      .from("brands")
      .update({ ...data, updated_at: new Date().toISOString() })
      .eq("id", id);

    if (error) throw error;

    revalidatePath("/(protected)/master/products");
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
    const { error } = await supabase.from("brands").delete().eq("id", id);

    if (error) {
      if (error.code === "23503") {
        return { ok: false, message: "This brand cannot be deleted as it has related products." };
      }
      throw error;
    }

    revalidatePath("/(protected)/master/products");
    return { ok: true };
  } catch (error) {
    console.error("Delete brand error:", error);
    return { ok: false, message: "Failed to delete brand" };
  }
}

// MANUFACTURER ACTIONS
export async function getManufacturers() {
  const supabase = await createSupabaseServerClient();
  const { data } = await supabase
    .from("manufacturers")
    .select("*")
    .order("name");
  return data || [];
}

export async function createManufacturer(formData: FormData): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to create manufacturers." };
    }

    const data = ManufacturerSchema.parse({
      name: formData.get("name"),
      legal_name: formData.get("legal_name") || undefined,
      brand_name: formData.get("brand_name") || undefined,
      registration_number: formData.get("registration_number") || undefined,
      tax_id: formData.get("tax_id") || undefined,
      contact_person: formData.get("contact_person") || undefined,
      phone: formData.get("phone") || undefined,
      email: formData.get("email") || undefined,
      secondary_email: formData.get("secondary_email") || undefined,
      support_email: formData.get("support_email") || undefined,
      support_phone: formData.get("support_phone") || undefined,
      whatsapp: formData.get("whatsapp") || undefined,
      fax: formData.get("fax") || undefined,
      address_line1: formData.get("address_line1") || undefined,
      address_line2: formData.get("address_line2") || undefined,
      city: formData.get("city") || undefined,
      state_region: formData.get("state_region") || undefined,
      postal_code: formData.get("postal_code") || undefined,
      country_code: formData.get("country_code") || undefined,
      website_url: formData.get("website_url") || undefined,
      timezone: formData.get("timezone") || undefined,
      language_code: formData.get("language_code") || undefined,
      currency_code: formData.get("currency_code") || undefined,
      logo_url: formData.get("logo_url") || undefined,
      social_links: formData.get("social_links") || undefined,
      certifications: formData.get("certifications") || undefined,
      notes: formData.get("notes") || undefined,
      status: formData.get("status") || "active",
      is_active: formData.has("is_active")
    });

    // Convert JSON strings to objects
    if (data.social_links) {
      try {
        data.social_links = JSON.parse(data.social_links);
      } catch {
        data.social_links = undefined;
      }
    }
    if (data.certifications) {
      try {
        data.certifications = JSON.parse(data.certifications);
      } catch {
        data.certifications = undefined;
      }
    }

    const supabase = await createSupabaseServerClient();
    const { error } = await supabase.from("manufacturers").insert([data]);

    if (error) {
      if (error.code === "23505") {
        return { ok: false, message: "A manufacturer with this registration number and country already exists." };
      }
      throw error;
    }

    revalidatePath("/(protected)/master/products");
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

    const data = ManufacturerSchema.parse({
      name: formData.get("name"),
      legal_name: formData.get("legal_name") || undefined,
      brand_name: formData.get("brand_name") || undefined,
      registration_number: formData.get("registration_number") || undefined,
      tax_id: formData.get("tax_id") || undefined,
      contact_person: formData.get("contact_person") || undefined,
      phone: formData.get("phone") || undefined,
      email: formData.get("email") || undefined,
      secondary_email: formData.get("secondary_email") || undefined,
      support_email: formData.get("support_email") || undefined,
      support_phone: formData.get("support_phone") || undefined,
      whatsapp: formData.get("whatsapp") || undefined,
      fax: formData.get("fax") || undefined,
      address_line1: formData.get("address_line1") || undefined,
      address_line2: formData.get("address_line2") || undefined,
      city: formData.get("city") || undefined,
      state_region: formData.get("state_region") || undefined,
      postal_code: formData.get("postal_code") || undefined,
      country_code: formData.get("country_code") || undefined,
      website_url: formData.get("website_url") || undefined,
      timezone: formData.get("timezone") || undefined,
      language_code: formData.get("language_code") || undefined,
      currency_code: formData.get("currency_code") || undefined,
      logo_url: formData.get("logo_url") || undefined,
      social_links: formData.get("social_links") || undefined,
      certifications: formData.get("certifications") || undefined,
      notes: formData.get("notes") || undefined,
      status: formData.get("status") || "active",
      is_active: formData.has("is_active")
    });

    // Convert JSON strings to objects
    if (data.social_links) {
      try {
        data.social_links = JSON.parse(data.social_links);
      } catch {
        data.social_links = undefined;
      }
    }
    if (data.certifications) {
      try {
        data.certifications = JSON.parse(data.certifications);
      } catch {
        data.certifications = undefined;
      }
    }

    const supabase = await createSupabaseServerClient();
    const { error } = await supabase
      .from("manufacturers")
      .update({ ...data, updated_at: new Date().toISOString() })
      .eq("id", id);

    if (error) throw error;

    revalidatePath("/(protected)/master/products");
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
    const { error } = await supabase.from("manufacturers").delete().eq("id", id);

    if (error) {
      if (error.code === "23503") {
        return { ok: false, message: "This manufacturer cannot be deleted as it has related products." };
      }
      throw error;
    }

    revalidatePath("/(protected)/master/products");
    return { ok: true };
  } catch (error) {
    console.error("Delete manufacturer error:", error);
    return { ok: false, message: "Failed to delete manufacturer" };
  }
}

// PRODUCT GROUP ACTIONS
export async function getProductGroups() {
  const supabase = await createSupabaseServerClient();
  const { data } = await supabase
    .from("product_groups")
    .select("*, categories(name)")
    .order("name");
  return data || [];
}

export async function createProductGroup(formData: FormData): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to create product groups." };
    }

    const data = ProductGroupSchema.parse({
      name: formData.get("name"),
      category_id: formData.get("category_id"),
      is_active: formData.has("is_active")
    });

    const supabase = await createSupabaseServerClient();
    const { error } = await supabase.from("product_groups").insert([data]);

    if (error) throw error;

    revalidatePath("/(protected)/master/products");
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

    const data = ProductGroupSchema.parse({
      name: formData.get("name"),
      category_id: formData.get("category_id"),
      is_active: formData.has("is_active")
    });

    const supabase = await createSupabaseServerClient();
    const { error } = await supabase
      .from("product_groups")
      .update({ ...data, updated_at: new Date().toISOString() })
      .eq("id", id);

    if (error) throw error;

    revalidatePath("/(protected)/master/products");
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
    const { error } = await supabase.from("product_groups").delete().eq("id", id);

    if (error) {
      if (error.code === "23503") {
        return { ok: false, message: "This product group cannot be deleted as it has related records." };
      }
      throw error;
    }

    revalidatePath("/(protected)/master/products");
    return { ok: true };
  } catch (error) {
    console.error("Delete product group error:", error);
    return { ok: false, message: "Failed to delete product group" };
  }
}

// PRODUCT SUBGROUP ACTIONS
export async function getProductSubGroups() {
  const supabase = await createSupabaseServerClient();
  const { data } = await supabase
    .from("product_subgroups")
    .select("*, product_groups(name)")
    .order("name");
  return data || [];
}

export async function createProductSubGroup(formData: FormData): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to create sub-groups." };
    }

    const data = ProductSubGroupSchema.parse({
      name: formData.get("name"),
      group_id: formData.get("group_id"),
      is_active: formData.has("is_active")
    });

    const supabase = await createSupabaseServerClient();
    const { error } = await supabase.from("product_subgroups").insert([data]);

    if (error) throw error;

    revalidatePath("/(protected)/master/products");
    return { ok: true };
  } catch (error) {
    console.error("Create sub-group error:", error);
    return { ok: false, message: "Failed to create sub-group" };
  }
}

export async function updateProductSubGroup(id: string, formData: FormData): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to update sub-groups." };
    }

    const data = ProductSubGroupSchema.parse({
      name: formData.get("name"),
      group_id: formData.get("group_id"),
      is_active: formData.has("is_active")
    });

    const supabase = await createSupabaseServerClient();
    const { error } = await supabase
      .from("product_subgroups")
      .update({ ...data, updated_at: new Date().toISOString() })
      .eq("id", id);

    if (error) throw error;

    revalidatePath("/(protected)/master/products");
    return { ok: true };
  } catch (error) {
    console.error("Update sub-group error:", error);
    return { ok: false, message: "Failed to update sub-group" };
  }
}

export async function deleteProductSubGroup(id: string): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to delete sub-groups." };
    }

    const supabase = await createSupabaseServerClient();
    const { error } = await supabase.from("product_subgroups").delete().eq("id", id);

    if (error) {
      if (error.code === "23503") {
        return { ok: false, message: "This sub-group cannot be deleted as it has related records." };
      }
      throw error;
    }

    revalidatePath("/(protected)/master/products");
    return { ok: true };
  } catch (error) {
    console.error("Delete sub-group error:", error);
    return { ok: false, message: "Failed to delete sub-group" };
  }
}

// PRODUCT VARIANT ACTIONS
export async function getProductVariants() {
  const supabase = await createSupabaseServerClient();
  const { data } = await supabase
    .from("product_variants")
    .select("*, products(name)")
    .order("name");
  return data || [];
}

export async function createProductVariant(formData: FormData): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to create variants." };
    }

    const data = ProductVariantSchema.parse({
      name: formData.get("name"),
      product_id: formData.get("product_id"),
      sku: formData.get("sku") || undefined
    });

    const supabase = await createSupabaseServerClient();
    const { error } = await supabase.from("product_variants").insert([data]);

    if (error) throw error;

    revalidatePath("/(protected)/master/products");
    return { ok: true };
  } catch (error) {
    console.error("Create variant error:", error);
    return { ok: false, message: "Failed to create variant" };
  }
}

export async function updateProductVariant(id: string, formData: FormData): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to update variants." };
    }

    const data = ProductVariantSchema.parse({
      name: formData.get("name"),
      product_id: formData.get("product_id"),
      sku: formData.get("sku") || undefined
    });

    const supabase = await createSupabaseServerClient();
    const { error } = await supabase
      .from("product_variants")
      .update({ ...data, updated_at: new Date().toISOString() })
      .eq("id", id);

    if (error) throw error;

    revalidatePath("/(protected)/master/products");
    return { ok: true };
  } catch (error) {
    console.error("Update variant error:", error);
    return { ok: false, message: "Failed to update variant" };
  }
}

export async function deleteProductVariant(id: string): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to delete variants." };
    }

    const supabase = await createSupabaseServerClient();
    const { error } = await supabase.from("product_variants").delete().eq("id", id);

    if (error) {
      if (error.code === "23503") {
        return { ok: false, message: "This variant cannot be deleted as it has related records." };
      }
      throw error;
    }

    revalidatePath("/(protected)/master/products");
    return { ok: true };
  } catch (error) {
    console.error("Delete variant error:", error);
    return { ok: false, message: "Failed to delete variant" };
  }
}