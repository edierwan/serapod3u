"use server";

import { createSSRClient } from "@/lib/supabase/server";
import { revalidatePath } from "next/cache";

export type ActionResult = { ok: true } | { ok: false; message: string };

async function checkPermission(): Promise<boolean> {
  const supabase = await createSSRClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return false;

  const { data: profile } = await supabase
    .from("users_profile")
    .select("role")
    .eq("user_id", user.id)
    .single();

  return profile?.role === "hq_admin" || profile?.role === "power_user";
}

export async function createDistributor(formData: FormData): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to modify Master Data." };
    }

    const data = {
      name: formData.get("name") as string,
      negeri_id: formData.get("negeri_id") as string,
      daerah_id: formData.get("daerah_id") as string,
      phone: formData.get("phone") as string || null,
      email: formData.get("email") as string || null,
      address: formData.get("address") as string || null,
    };

    if (!data.name || !data.negeri_id || !data.daerah_id) {
      return { ok: false, message: "Name, Negeri, and Daerah are required." };
    }

    const supabase = await createSSRClient();

    const { error } = await supabase
      .from("distributors")
      .insert([data]);

    if (error) {
      if (error.code === "23505") {
        return { ok: false, message: "A distributor with this name already exists." };
      }
      throw error;
    }

    revalidatePath("/master/distributors");
    return { ok: true };
  } catch (error) {
    console.error("Create distributor error:", error);
    return { ok: false, message: "Failed to create distributor" };
  }
}

export async function updateDistributor(id: string, formData: FormData): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to modify Master Data." };
    }

    const data = {
      name: formData.get("name") as string,
      negeri_id: formData.get("negeri_id") as string,
      daerah_id: formData.get("daerah_id") as string,
      phone: formData.get("phone") as string || null,
      email: formData.get("email") as string || null,
      address: formData.get("address") as string || null,
    };

    const supabase = await createSSRClient();

    const { error } = await supabase
      .from("distributors")
      .update(data)
      .eq("id", id);

    if (error) {
      if (error.code === "23505") {
        return { ok: false, message: "A distributor with this name already exists." };
      }
      throw error;
    }

    revalidatePath("/master/distributors");
    return { ok: true };
  } catch (error) {
    console.error("Update distributor error:", error);
    return { ok: false, message: "Failed to update distributor" };
  }
}

export async function deleteDistributor(id: string): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to modify Master Data." };
    }

    const supabase = await createSSRClient();

    const { error } = await supabase
      .from("distributors")
      .delete()
      .eq("id", id);

    if (error) {
      if (error.code === "23503") {
        return { ok: false, message: "This item is linked and cannot be deleted." };
      }
      throw error;
    }

    revalidatePath("/master/distributors");
    return { ok: true };
  } catch (error) {
    console.error("Delete distributor error:", error);
    return { ok: false, message: "Failed to delete distributor" };
  }
}

export async function assignShopToDistributor(distributorId: string, shopId: string): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to modify Master Data." };
    }

    const supabase = await createSSRClient();

    const { error } = await supabase
      .from("shop_distributors")
      .insert([{ distributor_id: distributorId, shop_id: shopId }]);

    if (error) {
      if (error.code === "23505") {
        return { ok: false, message: "This shop is already assigned to this distributor." };
      }
      throw error;
    }

    revalidatePath("/master/distributors");
    return { ok: true };
  } catch (error) {
    console.error("Assign shop error:", error);
    return { ok: false, message: "Failed to assign shop" };
  }
}

export async function removeShopFromDistributor(distributorId: string, shopId: string): Promise<ActionResult> {
  try {
    if (!(await checkPermission())) {
      return { ok: false, message: "You don't have permission to modify Master Data." };
    }

    const supabase = await createSSRClient();

    const { error } = await supabase
      .from("shop_distributors")
      .delete()
      .eq("distributor_id", distributorId)
      .eq("shop_id", shopId);

    if (error) {
      throw error;
    }

    revalidatePath("/master/distributors");
    return { ok: true };
  } catch (error) {
    console.error("Remove shop error:", error);
    return { ok: false, message: "Failed to remove shop" };
  }
}