import { NextRequest, NextResponse } from "next/server";
import { createSupabaseServerClient } from "@/lib/supabase/server";

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const categoryId = searchParams.get("category_id");
    const active = searchParams.get("active");

    if (!categoryId) {
      return NextResponse.json(
        { ok: false, code: "MISSING_CATEGORY_ID", message: "category_id parameter is required" },
        { status: 400 }
      );
    }

    const supabase = await createSupabaseServerClient();

    let query = supabase
      .from("product_groups")
      .select("id, name")
      .eq("category_id", categoryId);

    if (active === "1") {
      query = query.eq("is_active", true);
    }

    const { data, error } = await query.order("name");

    if (error) {
      console.error("API /master/groups error:", { categoryId, error });
      return NextResponse.json(
        { ok: false, code: "DATABASE_ERROR", message: "Failed to fetch groups" },
        { status: 500 }
      );
    }

    return NextResponse.json({ ok: true, data: data || [] });
  } catch (error) {
    console.error("API /master/groups unexpected error:", error);
    return NextResponse.json(
      { ok: false, code: "INTERNAL_ERROR", message: "Internal server error" },
      { status: 500 }
    );
  }
}