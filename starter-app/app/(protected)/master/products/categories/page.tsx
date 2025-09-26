import { createSupabaseServerClient } from "@/lib/supabase/server";
import Client from "./client";

export default async function CategoriesPage() {
  const supabase = await createSupabaseServerClient();
  
  const { data: categories = [] } = await supabase
    .from("product_categories")
    .select("*")
    .order("updated_at", { ascending: false });

  return <Client categories={categories || []} />;
}