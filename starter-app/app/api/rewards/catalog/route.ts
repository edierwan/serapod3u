import { NextRequest, NextResponse } from "next/server";
import { createSupabaseServerClient } from "@/lib/supabase/server";
import { getSignedUrl, REWARDS_IMAGES_BUCKET } from "@/lib/storage";

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const featured = searchParams.get("featured");
    const category = searchParams.get("category");
    const search = searchParams.get("search");

    const supabase = await createSupabaseServerClient();

    let query = supabase
      .from("rewards_catalog")
      .select("*")
      .eq("is_active", true)
      .lte("validity_start", new Date().toISOString())
      .or(`validity_end.is.null,validity_end.gte.${new Date().toISOString()}`);

    if (featured === "1") {
      query = query.eq("is_featured", true);
    }

    if (category) {
      query = query.ilike("category", `%${category}%`);
    }

    if (search) {
      query = query.or(`title.ilike.%${search}%,description.ilike.%${search}%`);
    }

    const { data: catalog, error } = await query.order("is_featured", { ascending: false }).order("title");

    if (error) {
      console.error("API /rewards/catalog error:", error);
      return NextResponse.json(
        { ok: false, code: "DATABASE_ERROR", message: "Failed to fetch catalog" },
        { status: 500 }
      );
    }

    // Generate signed URLs for images
    const catalogWithUrls = await Promise.all(
      (catalog || []).map(async (item) => {
        let imageUrl = null;
        if (item.image_key) {
          try {
            imageUrl = await getSignedUrl(item.image_key, 3600, REWARDS_IMAGES_BUCKET);
          } catch (err) {
            console.warn("Failed to generate signed URL for", item.image_key, err);
          }
        }
        return { ...item, image_url: imageUrl };
      })
    );

    return NextResponse.json({ ok: true, data: catalogWithUrls });
  } catch (error) {
    console.error("API /rewards/catalog unexpected error:", error);
    return NextResponse.json(
      { ok: false, code: "INTERNAL_ERROR", message: "Internal server error" },
      { status: 500 }
    );
  }
}