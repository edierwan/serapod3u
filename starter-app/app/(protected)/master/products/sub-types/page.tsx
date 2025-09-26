import { createSupabaseServerClient } from "@/lib/supabase/server";
import Client from "./client";

export default async function SubtypesPage() {
  const supabase = await createSupabaseServerClient();
  
  const [
    { data: subtypes = [] },
    { data: groups = [] }
  ] = await Promise.all([
    supabase
      .from("product_subtypes")
      .select("*, product_groups(id, name, product_categories(name))")
      .order("updated_at", { ascending: false }),
    supabase
      .from("product_groups")
      .select("id, name, product_categories!inner(name)")
      .eq("active", true)
      .order("name")
  ]);

  return <Client subtypes={subtypes || []} groups={groups || []} />;
}