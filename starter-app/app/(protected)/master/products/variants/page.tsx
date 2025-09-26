import { createSupabaseServerClient } from "@/lib/supabase/server";
import Client from "./client";

interface SearchParams {
  product_id?: string;
}

interface Props {
  searchParams: Promise<SearchParams>;
}

export default async function VariantsPage({ searchParams }: Props) {
  const { product_id } = await searchParams;
  const supabase = await createSupabaseServerClient();

  // Fetch variants with product relations
  let variantsQuery = supabase
    .from("product_variants")
    .select(`
      *,
      products(name, sku)
    `)
    .order("created_at", { ascending: false });

  // Filter by product_id if provided
  if (product_id) {
    variantsQuery = variantsQuery.eq("product_id", product_id);
  }

  const { data: variants, error: variantsError } = await variantsQuery;

  if (variantsError) {
    console.error("Error fetching variants:", variantsError);
  }

  // Fetch all products for the dropdown
  const { data: products, error: productsError } = await supabase
    .from("products")
    .select("id, name")
    .eq("is_active", true)
    .order("name");

  if (productsError) {
    console.error("Error fetching products:", productsError);
  }

  return (
    <Client
      variants={variants || []}
      products={products || []}
      productId={product_id || null}
    />
  );
}