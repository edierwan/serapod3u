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

    // Get shop ID from JWT claims (assuming it's set in JWT)
    const { data: shopData, error: shopError } = await supabase
      .rpc('get_my_shop_id');

    if (shopError || !shopData) {
      return NextResponse.json(
        { ok: false, code: "NO_SHOP_ACCESS", message: "No shop access found" },
        { status: 403 }
      );
    }

    const shopId = shopData;

    // Get current balance
    const { data: balanceData } = await supabase
      .from("v_shop_points_balance")
      .select("current_balance, total_transactions, last_transaction_at")
      .eq("shop_id", shopId)
      .single();

    // Get level based on total earned points
    const { data: levelData } = await supabase
      .from("shop_points_ledger")
      .select("points")
      .eq("shop_id", shopId)
      .eq("status", "completed")
      .gt("points", 0); // Only positive transactions (earns)

    let totalEarned = 0;
    let level = 1;
    if (levelData) {
      totalEarned = levelData.reduce((sum, tx) => sum + tx.points, 0);
      // Simple level calculation: 500, 1000, 2000, etc.
      level = Math.floor(totalEarned / 500) + 1;
    }

    // Get recent transactions (last 10)
    const { data: recentTx } = await supabase
      .from("shop_points_ledger")
      .select(`
        id,
        points,
        source,
        reference_type,
        reference_id,
        created_at,
        products(name)
      `)
      .eq("shop_id", shopId)
      .eq("status", "completed")
      .order("created_at", { ascending: false })
      .limit(10);

    // Get monthly stats
    const now = new Date();
    const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);
    const { data: monthlyEarned } = await supabase
      .from("shop_points_ledger")
      .select("points")
      .eq("shop_id", shopId)
      .eq("status", "completed")
      .gt("points", 0)
      .gte("created_at", startOfMonth.toISOString());

    const { data: monthlyRedeemed } = await supabase
      .from("shop_points_ledger")
      .select("points")
      .eq("shop_id", shopId)
      .eq("status", "completed")
      .lt("points", 0)
      .gte("created_at", startOfMonth.toISOString());

    const monthlyEarnedPoints = monthlyEarned ? monthlyEarned.reduce((sum, tx) => sum + tx.points, 0) : 0;
    const monthlyRedeemedPoints = monthlyRedeemed ? Math.abs(monthlyRedeemed.reduce((sum, tx) => sum + tx.points, 0)) : 0;

    return NextResponse.json({
      ok: true,
      data: {
        current_balance: balanceData?.current_balance || 0,
        total_earned: totalEarned,
        level,
        next_level_threshold: level * 500,
        monthly_earned: monthlyEarnedPoints,
        monthly_redeemed: monthlyRedeemedPoints,
        recent_transactions: recentTx || [],
        total_transactions: balanceData?.total_transactions || 0,
        last_transaction_at: balanceData?.last_transaction_at
      }
    });
  } catch (error) {
    console.error("API /rewards/summary error:", error);
    return NextResponse.json(
      { ok: false, code: "INTERNAL_ERROR", message: "Internal server error" },
      { status: 500 }
    );
  }
}