export const PRODUCT_IMAGES_BUCKET = "product-images";

import { createServiceClient } from "@/lib/supabase/service";
import { createSSRClient } from "@/lib/supabase/server";

/** Server-only upload; returns the storage path */
export async function uploadImage(entity: "product"|"manufacturer"|"distributor"|"shop"|"campaign"|"prize", id: string, file: File) {
  "use server";
  const svc = createServiceClient();
  const ext = file.name.split(".").pop() || "bin";
  const path = `${entity}/${id}/${Date.now()}.${ext}`;
  const buf = Buffer.from(await file.arrayBuffer());
  const { error } = await svc.storage.from(PRODUCT_IMAGES_BUCKET).upload(path, buf, { upsert: false, contentType: file.type || "application/octet-stream" });
  if (error) throw error;
  return path;
}

/** Server-only signed URL generator */
export async function getSignedUrl(path: string, expiresInSec = 3600) {
  "use server";
  const svc = createServiceClient();
  const { data, error } = await svc.storage.from(PRODUCT_IMAGES_BUCKET).createSignedUrl(path, expiresInSec);
  if (error) throw error;
  return data.signedUrl;
}
