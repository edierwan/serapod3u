import { NextRequest, NextResponse } from "next/server";
import { createSupabaseServerClient } from "@/lib/supabase/server";

export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const { id } = await params;
    const supabase = await createSupabaseServerClient();

    const { data: product, error } = await supabase
      .from("products")
      .select(`
        id, name, sku, price, is_active, image_url, created_at, updated_at,
        category_id, brand_id, group_id, sub_group_id, manufacturer_id
      `)
      .eq("id", id)
      .eq("is_active", true)
      .single();

    if (error) {
      if (error.code === "PGRST116") {
        return NextResponse.json(
          { ok: false, message: "Product not found" },
          { status: 404 }
        );
      }
      throw error;
    }

    return NextResponse.json({ ok: true, data: product });
  } catch (error) {
    console.error("Get product error:", error);
    return NextResponse.json(
      { ok: false, message: "Failed to fetch product" },
      { status: 500 }
    );
  }
}