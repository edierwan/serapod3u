"use server";

import { createSupabaseServerClient } from "@/lib/supabase/server";
const BUCKET = "product-images";

const extOf = (n: string) => {
  const p = n.lastIndexOf(".");
  return p > -1 ? n.slice(p + 1).toLowerCase() : "png";
};

export async function uploadManufacturerLogo(id: string, file: File) {
  if (!file || file.size === 0) return { ok: false as const, error: "Empty file" };
  const supabase = await createSupabaseServerClient();

  const ext = extOf(file.name);
  const path = `manufacturers/${id}/logo.${ext}`;

  const bytes = new Uint8Array(await file.arrayBuffer());
  const { error } = await supabase.storage
    .from(BUCKET)
    .upload(path, bytes, { upsert: true, contentType: file.type || "image/png", cacheControl: "3600" });
  if (error) return { ok: false as const, error: error.message };

  const { data } = supabase.storage.from(BUCKET).getPublicUrl(path);
  return { ok: true as const, url: data.publicUrl };
}