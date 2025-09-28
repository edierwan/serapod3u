import { NextRequest, NextResponse } from "next/server";
import { createSupabaseServerClient } from "@/lib/supabase/server";

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const groupId = searchParams.get("group_id");
    const active = searchParams.get("active");

    if (!groupId) {
      return NextResponse.json(
        { ok: false, code: "MISSING_GROUP_ID", message: "group_id parameter is required" },
        { status: 400 }
      );
    }

    const supabase = await createSupabaseServerClient();

    let query = supabase
      .from("product_subgroups")
      .select("id, name")
      .eq("group_id", groupId);

    if (active === "1") {
      query = query.eq("is_active", true);
    }

    const { data, error } = await query.order("name");

    if (error) {
      console.error("API /master/sub-groups error:", { groupId, error });
      return NextResponse.json(
        { ok: false, code: "DATABASE_ERROR", message: "Failed to fetch sub-groups" },
        { status: 500 }
      );
    }

    return NextResponse.json({ ok: true, data: data || [] });
  } catch (error) {
    console.error("API /master/sub-groups unexpected error:", error);
    return NextResponse.json(
      { ok: false, code: "INTERNAL_ERROR", message: "Internal server error" },
      { status: 500 }
    );
  }
}