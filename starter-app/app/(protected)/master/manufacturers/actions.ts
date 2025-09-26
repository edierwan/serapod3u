"use server";

import { createSSRClient } from "@/lib/supabase/server";
import { revalidatePath } from "next/cache";
import { z } from "zod";

export type ActionResult = { ok: true } | { ok: false; message: string };

const ManufacturerSchema = z.object({
  name: z.string().min(1, "Name is required"),
  email: z.string().email().optional().or(z.literal("")),
  phone: z.string().optional(),
  address: z.string().optional(),
  logo_url: z.string().url().optional().or(z.literal(""))
});

async function checkPermission(): Promise<boolean> {
  const supabase = createSSRClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return false;

  const { data: profile } = await supabase
    .from("users_profile")
    .select("role")
    .eq("user_id", user.id)
    .single();

  return profile?.role === "hq_admin" || profile?.role === "power_user";
}

export async function createManufacturer(formData: FormData): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to modify Master Data." };
    }

    const data = {
      name: formData.get("name") as string,
      email: formData.get("email") as string || undefined,
      phone: formData.get("phone") as string || undefined,
      address: formData.get("address") as string || undefined,
      logo_url: formData.get("logo_url") as string || undefined
    };

    const validated = ManufacturerSchema.parse(data);
    const supabase = createSSRClient();

    const { error } = await supabase
      .from("manufacturers")
      .insert([validated]);

    if (error) {
      if (error.code === "23505") {
        return { ok: false, message: "A manufacturer with this name already exists." };
      }
      throw error;
    }

    revalidatePath("/master/manufacturers");
    return { ok: true };
  } catch (error) {
    console.error("Create manufacturer error:", error);
    return { ok: false, message: "Failed to create manufacturer" };
  }
}

export async function updateManufacturer(id: string, formData: FormData): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to modify Master Data." };
    }

    const data = {
      name: formData.get("name") as string,
      email: formData.get("email") as string || undefined,
      phone: formData.get("phone") as string || undefined,
      address: formData.get("address") as string || undefined,
      logo_url: formData.get("logo_url") as string || undefined
    };

    const validated = ManufacturerSchema.parse(data);
    const supabase = createSSRClient();

    const { error } = await supabase
      .from("manufacturers")
      .update(validated)
      .eq("id", id);

    if (error) {
      if (error.code === "23505") {
        return { ok: false, message: "A manufacturer with this name already exists." };
      }
      throw error;
    }

    revalidatePath("/master/manufacturers");
    return { ok: true };
  } catch (error) {
    console.error("Update manufacturer error:", error);
    return { ok: false, message: "Failed to update manufacturer" };
  }
}

export async function deleteManufacturer(id: string): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to modify Master Data." };
    }

    const supabase = createSSRClient();

    const { error } = await supabase
      .from("manufacturers")
      .delete()
      .eq("id", id);

    if (error) {
      if (error.code === "23503") {
        return { ok: false, message: "This item is linked and cannot be deleted." };
      }
      throw error;
    }

    revalidatePath("/master/manufacturers");
    return { ok: true };
  } catch (error) {
    console.error("Delete manufacturer error:", error);
    return { ok: false, message: "Failed to delete manufacturer" };
  }
}