import { createSupabaseServerClient } from "@/lib/supabase/server";
import ManufacturersPageClient from "./client";

export default async function ManufacturersPage() {
  const supabase = await createSupabaseServerClient();

  // Get current user role
  const { data: { user } } = await supabase.auth.getUser();
  const { data: profile } = await supabase
    .from("users_profile")
    .select("role")
    .eq("user_id", user?.id)
    .single();

  // Fetch manufacturers
  const { data: manufacturers = [] } = await supabase
    .from("manufacturers")
    .select("*")
    .order("updated_at", { ascending: false });

  return (
    <ManufacturersPageClient
      manufacturers={manufacturers || []}
      currentUserRole={profile?.role || "shop"}
    />
  );
}
