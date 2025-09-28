import { NextRequest, NextResponse } from "next/server";
import { createSupabaseServerClient } from "@/lib/supabase/server";

export async function GET(request: NextRequest) {
  try {
    const supabase = await createSupabaseServerClient();
    const { searchParams } = new URL(request.url);
    const name = searchParams.get("name");
    const excludeId = searchParams.get("excludeId");

    if (!name || name.trim().length === 0) {
      return NextResponse.json({
        code: "bad_request",
        message: "Name is required"
      }, { status: 400 });
    }

    // Check if distributor name already exists (case-insensitive)
    let query = supabase
      .from("distributors")
      .select("id, name")
      .ilike("name", name.trim());

    if (excludeId) {
      query = query.neq("id", excludeId);
    }

    const { data, error } = await query.limit(1);

    if (error) {
      console.error("Error checking distributor name:", error);
      return NextResponse.json({
        code: "server_error",
        message: "Unable to verify name availability"
      }, { status: 500 });
    }

    const exists = data && data.length > 0;

    if (exists) {
      return NextResponse.json({
        code: "name_taken",
        message: "Name already exists"
      }, { status: 409 });
    }

    return NextResponse.json({
      available: true
    });

  } catch (error) {
    console.error("Unexpected error in distributor name check:", error);
    return NextResponse.json({
      code: "server_error",
      message: "Unable to verify name availability"
    }, { status: 500 });
  }
}