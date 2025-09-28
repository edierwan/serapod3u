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
        available: false,
        message: "Name is required"
      }, { status: 400 });
    }

    // Check if manufacturer name already exists (case-insensitive)
    let query = supabase
      .from("manufacturers")
      .select("id, name")
      .ilike("name", name.trim());

    if (excludeId) {
      query = query.neq("id", excludeId);
    }

    const { data, error } = await query.limit(1);

    if (error) {
      console.error("Error checking manufacturer name:", error);
      return NextResponse.json({
        available: false,
        message: "Unable to verify name availability"
      }, { status: 500 });
    }

    const exists = data && data.length > 0;

    return NextResponse.json({
      available: !exists,
      message: exists ? "Manufacturer name already exists" : "Name is available",
      conflictingName: exists ? data[0].name : null
    });

  } catch (error) {
    console.error("Unexpected error in manufacturer name check:", error);
    return NextResponse.json({
      available: false,
      message: "Unable to verify name availability"
    }, { status: 500 });
  }
}