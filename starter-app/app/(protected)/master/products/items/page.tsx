import { createSupabaseServerClient } from "@/lib/supabase/server";
import Client from "./client";

export default async function ProductsPage() {
  const supabase = await createSupabaseServerClient();
  
  const [
    { data: products = [] },
    { data: subtypes = [] },
    { data: manufacturers = [] }
  ] = await Promise.all([
    supabase
      .from("products")
      .select("*, product_subtypes(name), manufacturers(name)")
      .order("updated_at", { ascending: false }),
    supabase
      .from("product_subtypes")
      .select("id, name")
      .eq("active", true)
      .order("name"),
    supabase
      .from("manufacturers")
      .select("id, name")
      .eq("status", "active")
      .order("name")
  ]);

  return <Client products={products || []} subtypes={subtypes || []} manufacturers={manufacturers || []} />;
}