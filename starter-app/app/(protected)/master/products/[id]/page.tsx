import { notFound } from "next/navigation";
import { createSupabaseServerClient } from "@/lib/supabase/server";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { ArrowLeft, Package, Edit } from "lucide-react";
import Link from "next/link";

interface ProductDetailPageProps {
  params: Promise<{ id: string }>;
}

export default async function ProductDetailPage({ params }: ProductDetailPageProps) {
  const { id } = await params;
  const supabase = await createSupabaseServerClient();

  const { data: product, error } = await supabase
    .from("products")
    .select(`
      id, name, sku, price, is_active, image_url, created_at, updated_at,
      category:categories(id, name),
      brand:brands(id, name),
      group:product_groups(id, name),
      sub_group:product_subgroups(id, name),
      manufacturer:manufacturers(id, name, contact_person, phone, email)
    `)
    .eq("id", id)
    .eq("is_active", true)
    .single();

  if (error || !product) {
    notFound();
  }

  // Transform the data
  const transformedProduct = {
    ...product,
    category: Array.isArray(product.category) ? product.category[0] : product.category,
    brand: Array.isArray(product.brand) ? product.brand[0] : product.brand,
    group: Array.isArray(product.group) ? product.group[0] : product.group,
    sub_group: Array.isArray(product.sub_group) ? product.sub_group[0] : product.sub_group,
    manufacturer: Array.isArray(product.manufacturer) ? product.manufacturer[0] : product.manufacturer,
  };

  const formatPrice = (price: number | null) => {
    if (price === null) return "N/A";
    return new Intl.NumberFormat("en-US", {
      style: "currency",
      currency: "USD",
    }).format(price);
  };

  const getStatusBadge = (isActive: boolean) => {
    return (
      <Badge variant={isActive ? "default" : "secondary"}>
        {isActive ? "Active" : "Inactive"}
      </Badge>
    );
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center space-x-4">
        <Button variant="ghost" asChild>
          <Link href="/master/products">
            <ArrowLeft className="h-4 w-4 mr-2" />
            Back to Products
          </Link>
        </Button>
        <div>
          <h1 className="text-2xl font-bold text-gray-900">{transformedProduct.name}</h1>
          <p className="text-sm text-gray-500">Product Details</p>
        </div>
      </div>

      <div className="grid gap-6 md:grid-cols-3">
        {/* Main Product Info */}
        <div className="md:col-span-2 space-y-6">
          <Card>
            <CardHeader>
              <div className="flex items-start justify-between">
                <div className="flex items-start space-x-4">
                  <Avatar className="h-16 w-16 rounded-lg">
                    <AvatarImage src={transformedProduct.image_url || undefined} alt={transformedProduct.name} />
                    <AvatarFallback className="rounded-lg">
                      <Package className="h-8 w-8" />
                    </AvatarFallback>
                  </Avatar>
                  <div>
                    <CardTitle className="text-xl">{transformedProduct.name}</CardTitle>
                    <p className="text-sm text-gray-500 font-mono">{transformedProduct.sku}</p>
                    <div className="mt-2">
                      {getStatusBadge(transformedProduct.is_active ?? true)}
                    </div>
                  </div>
                </div>
                <Button asChild>
                  <Link href={`/master/products/${id}/edit`}>
                    <Edit className="h-4 w-4 mr-2" />
                    Edit Product
                  </Link>
                </Button>
              </div>
            </CardHeader>
            <CardContent>
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <p className="text-sm font-medium text-gray-500">Price</p>
                  <p className="text-lg font-semibold">{formatPrice(transformedProduct.price ?? null)}</p>
                </div>
                <div>
                  <p className="text-sm font-medium text-gray-500">Created</p>
                  <p className="text-sm">{new Date(transformedProduct.created_at).toLocaleDateString()}</p>
                </div>
              </div>
            </CardContent>
          </Card>

          {/* Taxonomy */}
          <Card>
            <CardHeader>
              <CardTitle>Product Taxonomy</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <p className="text-sm font-medium text-gray-500">Category</p>
                  <p className="font-medium">{transformedProduct.category?.name || "N/A"}</p>
                </div>
                <div>
                  <p className="text-sm font-medium text-gray-500">Brand</p>
                  <p className="font-medium">{transformedProduct.brand?.name || "N/A"}</p>
                </div>
                <div>
                  <p className="text-sm font-medium text-gray-500">Group</p>
                  <p className="font-medium">{transformedProduct.group?.name || "N/A"}</p>
                </div>
                <div>
                  <p className="text-sm font-medium text-gray-500">Sub-Group</p>
                  <p className="font-medium">{transformedProduct.sub_group?.name || "N/A"}</p>
                </div>
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Manufacturer Info */}
        <div className="space-y-6">
          <Card>
            <CardHeader>
              <CardTitle>Manufacturer</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="space-y-2">
                <p className="font-medium">{transformedProduct.manufacturer?.name || "N/A"}</p>
                {transformedProduct.manufacturer?.contact_person && (
                  <p className="text-sm text-gray-500">
                    Contact: {transformedProduct.manufacturer.contact_person}
                  </p>
                )}
                {transformedProduct.manufacturer?.phone && (
                  <p className="text-sm text-gray-500">
                    Phone: {transformedProduct.manufacturer.phone}
                  </p>
                )}
                {transformedProduct.manufacturer?.email && (
                  <p className="text-sm text-gray-500">
                    Email: {transformedProduct.manufacturer.email}
                  </p>
                )}
              </div>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  );
}