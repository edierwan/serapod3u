import { createSupabaseServerClient } from "@/lib/supabase/server";
import Client from "./client";

interface SearchParams {
  tab?: string;
}

interface Props {
  searchParams: Promise<SearchParams>;
}

export default async function ShopsPage({ searchParams }: Props) {
  const { tab = "list" } = await searchParams;
  const supabase = await createSupabaseServerClient();

  if (tab === "points") {
    // Fetch shops without embed to avoid relationship ambiguity
    const { data: shops, error: shopsError } = await supabase
      .from("shops")
      .select("id,name,code,email,phone,is_active,distributor_id,created_at,updated_at")
      .order("name");

    if (shopsError) {
      console.error("Error fetching shops:", shopsError.code, shopsError.message);
    }

    // Fetch distributors separately for name lookup
    const { data: distributors = [] } = await supabase
      .from("distributors")
      .select("id,name")
      .order("name", { ascending: true });

    // Transform shops data to include distributor name via lookup
    const shopsWithDistributors = (shops || []).map(shop => {
      const distributor = distributors?.find(d => d.id === shop.distributor_id);
      return {
        ...shop,
        distributors: distributor ? { name: distributor.name } : undefined
      };
    });

    // Fetch shop points balance
    const { data: balances, error: balancesError } = await supabase
      .from("shop_points_balance")
      .select("shop_id, points");

    if (balancesError) {
      console.error("Error fetching points balance:", balancesError);
    }

    return (
      <Client
        tab="points"
        shops={shopsWithDistributors}
        balances={balances || []}
        distributors={[]}
      />
    );
  } else {
    // Default: list tab - fetch shops without embed to avoid relationship ambiguity
    const { data: shops, error: shopsError } = await supabase
      .from("shops")
      .select("id,name,code,email,phone,is_active,distributor_id,created_at,updated_at")
      .order("name");

    if (shopsError) {
      console.error("Error fetching shops:", shopsError.code, shopsError.message);
    }

    // Fetch distributors for the dropdown and name lookup
    const { data: distributors, error: distributorsError } = await supabase
      .from("distributors")
      .select("id, name")
      .eq("is_active", true)
      .order("name");

    if (distributorsError) {
      console.error("Error fetching distributors:", distributorsError);
    }

    // Transform shops data to include distributor name via lookup
    const shopsWithDistributors = (shops || []).map(shop => {
      const distributor = distributors?.find(d => d.id === shop.distributor_id);
      return {
        ...shop,
        distributors: distributor ? { name: distributor.name } : undefined
      };
    });

    return (
      <Client
        tab="list"
        shops={shopsWithDistributors}
        balances={[]}
        distributors={distributors || []}
      />
    );
  }
}