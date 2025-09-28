export const PRODUCT_IMAGES_BUCKET = "product-images";
export const REWARDS_IMAGES_BUCKET = "rewards-images";

import { createServiceClient } from "@/lib/supabase/service";

/** Server-only upload; returns the storage path */
export async function uploadImage(entity: "product"|"manufacturer"|"distributor"|"shop"|"campaign"|"prize"|"reward", id: string, file: File) {
  "use server";
  const svc = createServiceClient();
  const bucket = entity === "reward" ? REWARDS_IMAGES_BUCKET : PRODUCT_IMAGES_BUCKET;
  const ext = file.name.split(".").pop() || "bin";
  const path = `${entity}/${id}/${Date.now()}.${ext}`;
  const buf = Buffer.from(await file.arrayBuffer());
  const { error } = await svc.storage.from(bucket).upload(path, buf, { upsert: false, contentType: file.type || "application/octet-stream" });
  if (error) throw error;
  return path;
}

/** Server-only signed URL generator */
export async function getSignedUrl(path: string, expiresInSec = 3600, bucket = PRODUCT_IMAGES_BUCKET) {
  "use server";
  const svc = createServiceClient();
  const { data, error } = await svc.storage.from(bucket).createSignedUrl(path, expiresInSec);
  if (error) throw error;
  return data.signedUrl;
}
