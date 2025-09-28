import { NextResponse } from "next/server";
import { createSupabaseServerClient } from "@/lib/supabase/server";

export async function GET() {
  try {
    const supabase = await createSupabaseServerClient();

    // Get current user and their shop
    const { data: { user }, error: userError } = await supabase.auth.getUser();
    if (userError || !user) {
      return NextResponse.json(
        { ok: false, code: "UNAUTHORIZED", message: "Not authenticated" },
        { status: 401 }
      );
    }

    // Get shop ID from JWT claims
    const { data: shopData, error: shopError } = await supabase
      .rpc('get_my_shop_id');

    if (shopError || !shopData) {
      return NextResponse.json(
        { ok: false, code: "NO_SHOP_ACCESS", message: "No shop access found" },
        { status: 403 }
      );
    }

    const shopId = shopData;

    // Get recent earn events (last 20)
    const { data: recentEarns } = await supabase
      .from("shop_points_ledger")
      .select(`
        id,
        points,
        source,
        reference_type,
        reference_id,
        created_at,
        products(name),
        product_variants(flavor_name, packaging)
      `)
      .eq("shop_id", shopId)
      .eq("status", "completed")
      .gt("points", 0) // Only earn transactions
      .order("created_at", { ascending: false })
      .limit(20);

    // Get available activities (simplified - just active ones for now)
    const { data: activities } = await supabase
      .from("points_activities")
      .select("id, name, description, points_reward, activity_type")
      .eq("is_active", true)
      .order("created_at", { ascending: false })
      .limit(10);

    // For each activity, get shop's progress
    const activitiesWithProgress = [];
    if (activities) {
      for (const activity of activities) {
        const { data: progress } = await supabase
          .from("shop_activity_progress")
          .select("completions_count, last_completed_at")
          .eq("shop_id", shopId)
          .eq("activity_id", activity.id)
          .single();

        activitiesWithProgress.push({
          ...activity,
          progress: progress || { completions_count: 0, last_completed_at: null }
        });
      }
    }

    return NextResponse.json({
      ok: true,
      data: {
        recent_earns: recentEarns || [],
        available_activities: activitiesWithProgress
      }
    });
  } catch (error) {
    console.error("API /rewards/earn error:", error);
    return NextResponse.json(
      { ok: false, code: "INTERNAL_ERROR", message: "Internal server error" },
      { status: 500 }
    );
  }
}