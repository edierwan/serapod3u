import { createSupabaseServerClient } from "@/lib/supabase/server";
import Client from "./client";

interface SearchParams {
  tab?: string;
  id?: string;
}

interface Props {
  searchParams: Promise<SearchParams>;
}

export default async function DistributorsPage({ searchParams }: Props) {
  const { tab = "list", id } = await searchParams;
  const supabase = await createSupabaseServerClient();

  if (tab === "shops" && id) {
    // Fetch selected distributor and its shops
    const { data: distributor, error: distributorError } = await supabase
      .from("distributors")
      .select("*")
      .eq("id", id)
      .single();

    if (distributorError) {
      console.error("Error fetching distributor:", distributorError);
    }

    // Fetch shops for this distributor
    const { data: shops, error: shopsError } = await supabase
      .from("shops")
      .select("*")
      .eq("distributor_id", id)
      .order("name");

    if (shopsError) {
      console.error("Error fetching shops:", shopsError);
    }

    return (
      <Client
        tab="shops"
        distributors={[]}
        distributor={distributor || null}
        shops={shops || []}
      />
    );
  } else {
    // Default: list tab - fetch all distributors
    const { data: distributors, error: distributorsError } = await supabase
      .from("distributors")
      .select("*")
      .order("name");

    if (distributorsError) {
      console.error("Error fetching distributors:", distributorsError);
    }

    return (
      <Client
        tab="list"
        distributors={distributors || []}
        distributor={null}
        shops={[]}
      />
    );
  }
}