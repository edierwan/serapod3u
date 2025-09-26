"use server";

import { z } from "zod";
import { revalidatePath } from "next/cache";
import { createSupabaseServerClient } from "@/lib/supabase/server";

// Zod schema for shop points ledger entries
const pointsLedgerSchema = z.object({
  shop_id: z.string().uuid(),
  delta: z.coerce.number().int(),
  reason: z.string().optional(),
});

export async function addPointsLedgerEntry(formData: FormData) {
  try {
    const data = {
      shop_id: formData.get("shop_id") as string,
      delta: parseInt(formData.get("delta") as string),
      reason: formData.get("reason") as string || undefined,
    };

    const parsed = pointsLedgerSchema.parse(data);
    
    const supabase = createSupabaseServerClient();
    const { error } = await (await supabase)
      .from("shop_points_ledger")
      .insert([{
        shop_id: parsed.shop_id,
        delta: parsed.delta,
        reason: parsed.reason,
      }]);

    if (error) throw error;

    revalidatePath("/(protected)/master/shops?tab=points");
    return { success: true };
  } catch (error) {
    console.error("Error adding points ledger entry:", error);
    return { success: false, error: error instanceof Error ? error.message : "Unknown error" };
  }
}