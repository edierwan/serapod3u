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

  // Fetch manufacturers with metrics and category
  const { data: manufacturersData } = await supabase
    .from("manufacturers")
    .select(`
      id, name, is_active, logo_url, contact_person, phone, email, website_url, 
      address_line1, address_line2, city, state_region, postal_code, country_code, 
      language_code, currency_code, tax_id, registration_number, 
      support_email, support_phone, timezone, notes, created_at, updated_at,
      category:categories(id, name)
    `)
    .order("name", { ascending: true });

  const manufacturers = manufacturersData || [];

  // Fetch categories for the filter
  const { data: categoriesData } = await supabase
    .from("categories")
    .select("id, name")
    .eq("is_active", true)
    .order("name");

  const categories = categoriesData || [];

  // Get product counts for each manufacturer
  const manufacturerIds = manufacturers.map(m => m.id);
  const { data: productCountsData } = await supabase
    .from("products")
    .select("manufacturer_id")
    .in("manufacturer_id", manufacturerIds);

  const productCounts = productCountsData || [];

  // Count products per manufacturer
  const productCountsMap = productCounts.reduce((acc, product) => {
    if (product.manufacturer_id) {
      acc[product.manufacturer_id] = (acc[product.manufacturer_id] || 0) + 1;
    }
    return acc;
  }, {} as Record<string, number>);

  // Add metrics to manufacturers
  const manufacturersWithMetrics = manufacturers.map(manufacturer => ({
    ...manufacturer,
    category: Array.isArray(manufacturer.category) ? manufacturer.category[0] : manufacturer.category,
    products_count: productCountsMap[manufacturer.id] || 0,
    orders_count: 0 // Placeholder for now since orders aren't directly linked to manufacturers
  }));

  return (
    <ManufacturersPageClient
      manufacturers={manufacturersWithMetrics || []}
      categories={categories}
      currentUserRole={profile?.role || "shop"}
    />
  );
}
