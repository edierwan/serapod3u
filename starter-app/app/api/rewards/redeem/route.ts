import { NextRequest, NextResponse } from "next/server";
import { createSupabaseServerClient } from "@/lib/supabase/server";

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { catalog_id } = body;

    if (!catalog_id) {
      return NextResponse.json(
        { ok: false, code: "MISSING_CATALOG_ID", message: "catalog_id is required" },
        { status: 400 }
      );
    }

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

    // Start transaction
    const { data: result, error: txError } = await supabase.rpc('redeem_reward', {
      p_shop_id: shopId,
      p_catalog_id: catalog_id,
      p_user_id: user.id
    });

    if (txError) {
      console.error("Redeem transaction error:", txError);
      return NextResponse.json(
        { ok: false, code: "REDEEM_FAILED", message: txError.message },
        { status: 400 }
      );
    }

    return NextResponse.json({
      ok: true,
      data: {
        redemption_id: result.redemption_id,
        points_deducted: result.points_deducted,
        new_balance: result.new_balance
      }
    });
  } catch (error) {
    console.error("API /rewards/redeem error:", error);
    return NextResponse.json(
      { ok: false, code: "INTERNAL_ERROR", message: "Internal server error" },
      { status: 500 }
    );
  }
}