import { useState, useEffect } from 'react';
import { createClient } from '@/lib/supabase/client';

export interface Product {
  id: string;
  name: string;
  sku: string;
  manufacturer_id: string;
  category_id: string;
  is_active: boolean;
  price: number | null;
}

export interface ProductVariant {
  id: string;
  product_id: string;
  flavor_name: string | null;
  nic_strength: string | null;
  packaging: string | null;
  sku: string;
  is_active: boolean;
}

export function useProductData() {
  const [products, setProducts] = useState<Product[]>([]);
  const [variants, setVariants] = useState<ProductVariant[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    async function fetchData() {
      try {
        const supabase = createClient();

        // Fetch products
        const { data: productsData, error: productsError } = await supabase
          .from('products')
          .select('id, name, sku, manufacturer_id, category_id, is_active, price')
          .eq('is_active', true)
          .order('name');

        if (productsError) throw productsError;

        // Fetch variants
        const { data: variantsData, error: variantsError } = await supabase
          .from('product_variants')
          .select('id, product_id, flavor_name, nic_strength, packaging, sku, is_active')
          .eq('is_active', true)
          .order('flavor_name');

        if (variantsError) throw variantsError;

        setProducts(productsData || []);
        setVariants(variantsData || []);
      } catch (err) {
        setError(err instanceof Error ? err.message : 'Failed to fetch product data');
      } finally {
        setLoading(false);
      }
    }

    fetchData();
  }, []);

  return { products, variants, loading, error };
}