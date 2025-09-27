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
    .select("id, name, is_active, logo_url, contact_person, phone, email, website_url, address_line1, address_line2, city, postal_code, country_code, language_code, currency_code, tax_id, registration_number, support_email, support_phone, timezone, notes, created_at, updated_at")
    .order("name", { ascending: true });

  return (
    <ManufacturersPageClient
      manufacturers={manufacturers || []}
      currentUserRole={profile?.role || "shop"}
    />
  );
}
