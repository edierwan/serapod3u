import { createSupabaseServerClient } from "@/lib/supabase/server";
import DistributorsPageClient from "./DistributorsPageClient";

export default async function DistributorsPage({ searchParams }: { searchParams: Promise<{ [key: string]: string | string[] | undefined }> }) {
  const supabase = await createSupabaseServerClient();

  // Get current user role
  const { data: { user } } = await supabase.auth.getUser();
  const { data: profile } = await supabase
    .from("users_profile")
    .select("role")
    .eq("user_id", user?.id)
    .single();

  // Await search params
  const params = await searchParams;

  // Parse search params
  const search = typeof params?.search === 'string' ? params.search : '';
  const categoryId = typeof params?.category_id === 'string' ? params.category_id : '';
  const isActive = params?.is_active === 'true' ? true : params?.is_active === 'false' ? false : undefined;

  // Build query
  let query = supabase
    .from("distributors")
    .select(`
      id, name, is_active, logo_url, contact_person, phone, email, whatsapp,
      address_line1, address_line2, city, state_region, postal_code, country_code,
      website_url, notes, created_at, updated_at,
      category:categories(id, name)
    `);

  if (search) {
    query = query.ilike('name', `%${search}%`);
  }
  if (categoryId) {
    query = query.eq('category_id', categoryId);
  }
  if (isActive !== undefined) {
    query = query.eq('is_active', isActive);
  }

  const { data: distributorsData, error } = await query.order("name", { ascending: true });

  if (error) {
    console.error("Error fetching distributors:", error);
  }

  const distributors = distributorsData || [];

  // Fetch categories for the filter
  const { data: categoriesData } = await supabase
    .from("categories")
    .select("id, name")
    .eq("is_active", true)
    .order("name");

  const categories = categoriesData || [];

  // Get shops count for each distributor
  const distributorIds = distributors.map(d => d.id);
  const { data: shopsCountsData } = await supabase
    .from("shops")
    .select("distributor_id")
    .in("distributor_id", distributorIds);

  const shopsCounts = shopsCountsData || [];

  // Count shops per distributor
  const shopsCountsMap = shopsCounts.reduce((acc, shop) => {
    if (shop.distributor_id) {
      acc[shop.distributor_id] = (acc[shop.distributor_id] || 0) + 1;
    }
    return acc;
  }, {} as Record<string, number>);

  // Add metrics to distributors
  const distributorsWithMetrics = distributors.map(distributor => ({
    ...distributor,
    category: Array.isArray(distributor.category) ? distributor.category[0] : distributor.category,
    shops_count: shopsCountsMap[distributor.id] || 0,
    orders_count: 0 // Placeholder for now
  }));

  return (
    <DistributorsPageClient
      distributors={distributorsWithMetrics || []}
      categories={categories}
      currentUserRole={profile?.role || "shop"}
      searchParams={{ search, category_id: categoryId, is_active: isActive?.toString() }}
    />
  );
}