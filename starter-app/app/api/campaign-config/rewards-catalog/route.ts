import { NextRequest, NextResponse } from "next/server";
import { createSupabaseServerClient } from "@/lib/supabase/server";
import { uploadImage } from "@/lib/storage";

export async function GET() {
  try {
    const supabase = await createSupabaseServerClient();

    // Check if user has admin role
    const { data: { user }, error: userError } = await supabase.auth.getUser();
    if (userError || !user) {
      return NextResponse.json(
        { ok: false, code: "UNAUTHORIZED", message: "Not authenticated" },
        { status: 401 }
      );
    }

    // Check role (this should be handled by RLS, but double-check)
    const { data: roleData } = await supabase.rpc('jwt_role');
    if (!['hq_admin', 'power_user'].includes(roleData)) {
      return NextResponse.json(
        { ok: false, code: "FORBIDDEN", message: "Admin access required" },
        { status: 403 }
      );
    }

    const { data: catalog, error } = await supabase
      .from("rewards_catalog")
      .select("*")
      .order("created_at", { ascending: false });

    if (error) {
      console.error("API /campaign-config/rewards-catalog error:", error);
      return NextResponse.json(
        { ok: false, code: "DATABASE_ERROR", message: "Failed to fetch catalog" },
        { status: 500 }
      );
    }

    return NextResponse.json({ ok: true, data: catalog || [] });
  } catch (error) {
    console.error("API /campaign-config/rewards-catalog unexpected error:", error);
    return NextResponse.json(
      { ok: false, code: "INTERNAL_ERROR", message: "Internal server error" },
      { status: 500 }
    );
  }
}

export async function POST(request: NextRequest) {
  try {
    const formData = await request.formData();
    const title = formData.get("title") as string;
    const description = formData.get("description") as string;
    const pointsCost = parseInt(formData.get("points_cost") as string);
    const category = formData.get("category") as string;
    const isFeatured = formData.get("is_featured") === "true";
    const validityStart = formData.get("validity_start") as string;
    const validityEnd = formData.get("validity_end") as string;
    const imageFile = formData.get("image") as File;

    if (!title || !pointsCost || !category) {
      return NextResponse.json(
        { ok: false, code: "MISSING_FIELDS", message: "title, points_cost, and category are required" },
        { status: 400 }
      );
    }

    const supabase = await createSupabaseServerClient();

    // Check admin role
    const { data: roleData } = await supabase.rpc('jwt_role');
    if (!['hq_admin', 'power_user'].includes(roleData)) {
      return NextResponse.json(
        { ok: false, code: "FORBIDDEN", message: "Admin access required" },
        { status: 403 }
      );
    }

    let imageKey = null;
    if (imageFile) {
      imageKey = await uploadImage("reward", crypto.randomUUID(), imageFile);
    }

    const { data: newItem, error } = await supabase
      .from("rewards_catalog")
      .insert({
        title,
        description,
        points_cost: pointsCost,
        category,
        image_key: imageKey,
        is_featured: isFeatured,
        validity_start: validityStart || null,
        validity_end: validityEnd || null
      })
      .select()
      .single();

    if (error) {
      console.error("API /campaign-config/rewards-catalog POST error:", error);
      return NextResponse.json(
        { ok: false, code: "DATABASE_ERROR", message: "Failed to create catalog item" },
        { status: 500 }
      );
    }

    return NextResponse.json({ ok: true, data: newItem });
  } catch (error) {
    console.error("API /campaign-config/rewards-catalog POST unexpected error:", error);
    return NextResponse.json(
      { ok: false, code: "INTERNAL_ERROR", message: "Internal server error" },
      { status: 500 }
    );
  }
}