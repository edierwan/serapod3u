import { NextRequest, NextResponse } from "next/server";
import { deleteManufacturer } from "@/app/(protected)/master/manufacturers/actions";

export async function POST(request: NextRequest) {
  try {
    const { id } = await request.json();

    if (!id) {
      return NextResponse.json({ success: false, error: "Manufacturer ID is required" }, { status: 400 });
    }

    const result = await deleteManufacturer(id);

    if (result.success) {
      return NextResponse.json({ success: true });
    } else {
      return NextResponse.json({ success: false, error: result.error }, { status: 400 });
    }
  } catch (error) {
    console.error("API error:", error);
    return NextResponse.json(
      { success: false, error: "Internal server error" },
      { status: 500 }
    );
  }
}