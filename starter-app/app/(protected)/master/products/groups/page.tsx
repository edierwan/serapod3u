import { createSupabaseServerClient } from "@/lib/supabase/server";
import Client from "./client";

export default async function GroupsPage() {
  const supabase = await createSupabaseServerClient();
  
  const [
    { data: groups = [] },
    { data: categories = [] }
  ] = await Promise.all([
    supabase
      .from("product_groups")
      .select("*, product_categories(id, name)")
      .order("updated_at", { ascending: false }),
    supabase
      .from("product_categories")
      .select("id, name")
      .eq("active", true)
      .order("name")
  ]);

  return <Client groups={groups || []} categories={categories || []} />;
}