import { createClient } from "@/lib/supabase/client";

export async function uploadProductImage(file: File): Promise<{ url: string }> {
  const supabase = createClient();

  // Generate unique filename
  const fileExt = file.name.split('.').pop();
  const fileName = `${Date.now()}-${Math.random().toString(36).substring(2)}.${fileExt}`;

  // Upload to storage
  const { error } = await supabase.storage
    .from('product-images')
    .upload(fileName, file);

  if (error) {
    throw new Error(`Upload failed: ${error.message}`);
  }

  // Get public URL
  const { data: { publicUrl } } = supabase.storage
    .from('product-images')
    .getPublicUrl(fileName);

  return { url: publicUrl };
}

export async function uploadManufacturerLogo(file: File): Promise<{ url: string }> {
  const supabase = createClient();

  // Generate unique filename
  const fileExt = file.name.split('.').pop();
  const fileName = `${Date.now()}-${Math.random().toString(36).substring(2)}.${fileExt}`;

  // Upload to storage
  const { error } = await supabase.storage
    .from('product-images')
    .upload(`manufacturer/${fileName}`, file);

  if (error) {
    throw new Error(`Upload failed: ${error.message}`);
  }

  // Get public URL
  const { data: { publicUrl } } = supabase.storage
    .from('product-images')
    .getPublicUrl(`manufacturer/${fileName}`);

  return { url: publicUrl };
}