"use server";

import { createSupabaseServerClient } from "@/lib/supabase/server";
import { createServiceClient } from "@/lib/supabase/service";

export async function resetSystemAction() {
  // First, verify the user's role
  const supabase = await createSupabaseServerClient();
  const { data: { user } } = await supabase.auth.getUser();

  if (!user) {
    throw new Error("Not authenticated");
  }

  // Check user role
  const { data: profile } = await supabase
    .from("profiles")
    .select("role_code")
    .eq("id", user.id)
    .maybeSingle();

  if (!profile || (profile.role_code !== "hq_admin" && profile.role_code !== "power_user")) {
    throw new Error("Insufficient permissions");
  }

    // Perform system reset operations
  const svc = createServiceClient();

  try {
    // Clear transaction data first (to avoid foreign key constraints)
    // Clear orders and related data
    await svc.from("orders").delete().neq("id", "00000000-0000-0000-0000-000000000000");
    await svc.from("purchase_orders").delete().neq("id", "00000000-0000-0000-0000-000000000000");
    await svc.from("order_items").delete().neq("id", "00000000-0000-0000-0000-000000000000");
    await svc.from("purchase_order_items").delete().neq("id", "00000000-0000-0000-0000-000000000000");

    // Clear tracking data
    await svc.from("movement_events").delete().neq("id", "00000000-0000-0000-0000-000000000000");
    await svc.from("pack_events").delete().neq("id", "00000000-0000-0000-0000-000000000000");
    await svc.from("cases").delete().neq("id", "00000000-0000-0000-0000-000000000000");
    await svc.from("unique_codes").delete().neq("id", "00000000-0000-0000-0000-000000000000");

    // Clear campaigns and rewards data
    await svc.from("lucky_draw_campaigns").delete().neq("id", "00000000-0000-0000-0000-000000000000");
    await svc.from("lucky_draw_participants").delete().neq("id", "00000000-0000-0000-0000-000000000000");
    await svc.from("redeem_claims").delete().neq("id", "00000000-0000-0000-0000-000000000000");
    await svc.from("shop_points_ledger").delete().neq("id", 0);

    // Clear shipments
    await svc.from("shipments").delete().neq("id", "00000000-0000-0000-0000-000000000000");
    await svc.from("shipment_cases").delete().neq("id", "00000000-0000-0000-0000-000000000000");
    await svc.from("shipment_uniques").delete().neq("id", "00000000-0000-0000-0000-000000000000");

    // Clear master data (products and variants first due to foreign keys)
    await svc.from("product_variants").delete().neq("id", "00000000-0000-0000-0000-000000000000");
    await svc.from("products").delete().neq("id", "00000000-0000-0000-0000-000000000000");

    // Clear master data entities
    await svc.from("manufacturers").delete().neq("id", "00000000-0000-0000-0000-000000000000");
    await svc.from("distributors").delete().neq("id", "00000000-0000-0000-0000-000000000000");
    await svc.from("shops").delete().neq("id", "00000000-0000-0000-0000-000000000000");

    // Clear master data hierarchies
    await svc.from("product_subgroups").delete().neq("id", "00000000-0000-0000-0000-000000000000");
    await svc.from("product_groups").delete().neq("id", "00000000-0000-0000-0000-000000000000");
    await svc.from("brands").delete().neq("id", "00000000-0000-0000-0000-000000000000");
    await svc.from("categories").delete().neq("id", "00000000-0000-0000-0000-000000000000");

    // Clear user assignments and relationships
    await svc.from("manufacturer_users").delete().neq("id", "00000000-0000-0000-0000-000000000000");
    await svc.from("shop_distributors").delete().neq("id", "00000000-0000-0000-0000-000000000000");

    // Clear rewards system data
    await svc.from("points_rules").delete().neq("id", "00000000-0000-0000-0000-000000000000");
    await svc.from("rewards_catalog").delete().neq("id", "00000000-0000-0000-0000-000000000000");
    await svc.from("rewards_redemptions").delete().neq("id", "00000000-0000-0000-0000-000000000000");
    await svc.from("points_activities").delete().neq("id", "00000000-0000-0000-0000-000000000000");
    await svc.from("shop_activity_progress").delete().neq("id", "00000000-0000-0000-0000-000000000000");

    // Clear development data
    await svc.from("dev_fastlogin_accounts").delete().neq("id", "00000000-0000-0000-0000-000000000000");

  } catch (error) {
    console.error("System reset error:", error);
    throw new Error("System reset failed. Please try again.");
  }
}
