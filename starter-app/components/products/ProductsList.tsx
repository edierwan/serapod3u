// Products list component with search and display functionality
// Displays products in a grid layout with hierarchical data
// Supports create, edit, view, and delete operations
// Uses shadcn/ui components for consistent styling
"use client";

import { useState, useEffect, useCallback } from "react";
import { useRouter } from "next/navigation";
import { Search, Package, Plus, Edit, Trash2, Eye } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { EmptyState } from "@/components/ui/empty-state";
import { Switch } from "@/components/ui/switch";
import { Label } from "@/components/ui/label";
import { getProducts, deleteProduct } from "../../app/(protected)/master/products/actions";
import type { Product } from "@/lib/types/master";

interface ProductsListProps {
  onCreateProduct?: () => void;
}

export function ProductsList({ onCreateProduct }: ProductsListProps) {
  const router = useRouter();
  const [products, setProducts] = useState<Product[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState("");
  const [showInactive, setShowInactive] = useState(false);
  const [deletingId, setDeletingId] = useState<string | null>(null);

  const loadProducts = useCallback(async () => {
    try {
      setLoading(true);
      const data = await getProducts(searchTerm, showInactive);
      setProducts(data as Product[]);
    } catch (error) {
      console.error("Failed to load products:", error);
    } finally {
      setLoading(false);
    }
  }, [searchTerm, showInactive]);

  useEffect(() => {
    loadProducts();
  }, [loadProducts, router]);

  const handleViewProduct = useCallback((product: Product) => {
    router.push(`/master/products/${product.id}`);
  }, [router]);

  const handleEditProduct = useCallback((product: Product) => {
    router.push(`/master/products/${product.id}/edit`);
  }, [router]);

  const handleDeleteProduct = useCallback(async (product: Product) => {
    if (!confirm(`Are you sure you want to delete "${product.name}"? This action cannot be undone.`)) {
      return;
    }

    try {
      setDeletingId(product.id);
      const result = await deleteProduct(product.id);
      if (result.ok) {
        // Refresh the products list
        loadProducts();
        router.refresh();
        // Dispatch event to notify other components (like forms) to refresh active combos
        window.dispatchEvent(new CustomEvent('products:deleted', { 
          detail: { manufacturerId: product.manufacturer?.id } 
        }));
      } else {
        // Map error codes to user-friendly messages
        let errorMessage = result.message;
        if (result.message.includes("23503")) {
          errorMessage = "Cannot delete: this product is used elsewhere.";
        } else if (result.message.includes("42501")) {
          errorMessage = "You don't have permission to delete this product.";
        }
        alert(`Failed to delete product: ${errorMessage}`);
      }
    } catch (error) {
      console.error("Delete product error:", error);
      alert("Failed to delete product");
    } finally {
      setDeletingId(null);
    }
  }, [loadProducts, router]);

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

  if (loading) {
    return (
      <div className="space-y-4">
        <div className="flex items-center justify-between">
          <h2 className="text-xl font-semibold">Products</h2>
          <Button disabled>
            <Plus className="h-4 w-4 mr-2" />
            Create Product
          </Button>
        </div>
        <div className="flex items-center space-x-2">
          <div className="relative flex-1">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
            <Input
              placeholder="Search products..."
              value=""
              className="pl-10"
              disabled
            />
          </div>
        </div>
        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
          {[...Array(6)].map((_, i) => (
            <Card key={i} className="animate-pulse">
              <CardHeader>
                <div className="h-4 bg-gray-200 rounded w-3/4"></div>
                <div className="h-3 bg-gray-200 rounded w-1/2"></div>
              </CardHeader>
              <CardContent>
                <div className="space-y-2">
                  <div className="h-3 bg-gray-200 rounded"></div>
                  <div className="h-3 bg-gray-200 rounded w-2/3"></div>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-xl font-semibold">Products</h2>
          <p className="text-sm text-gray-500">
            {products.length} product{products.length !== 1 ? "s" : ""} found
            {showInactive && " (including inactive)"}
          </p>
        </div>
        <Button onClick={onCreateProduct} variant="primary" data-testid="cta-create-product">
          <Plus className="h-4 w-4 mr-2" />
          Create Product
        </Button>
      </div>

      <div className="flex items-center space-x-2">
        <div className="relative flex-1">
          <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
          <Input
            placeholder="Search products..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="pl-10"
          />
        </div>
        <div className="flex items-center space-x-2">
          <Label htmlFor="show-inactive" className="text-sm font-medium">
            Show Inactive
          </Label>
          <Switch
            id="show-inactive"
            checked={showInactive}
            onCheckedChange={setShowInactive}
          />
        </div>
      </div>

      {products.length === 0 ? (
        <EmptyState
          icon={Package}
          title="No products found"
          body={searchTerm ? "No products match your search criteria." : "Get started by creating your first product."}
          primaryCta={onCreateProduct ? {
            label: "Create Product",
            onClick: onCreateProduct
          } : undefined}
        />
      ) : (
        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
          {products.map((product) => (
            <Card key={product.id} className="hover:shadow-md transition-shadow">
              <CardHeader className="pb-3">
                <div className="flex items-start justify-between">
                  <div className="flex items-start space-x-3 flex-1">
                    <Avatar className="h-12 w-12 rounded-lg">
                      <AvatarImage src={product.image_url || undefined} alt={product.name} />
                      <AvatarFallback className="rounded-lg">
                        <Package className="h-6 w-6" />
                      </AvatarFallback>
                    </Avatar>
                    <div className="flex-1">
                      <CardTitle className="text-lg line-clamp-2">{product.name}</CardTitle>
                      <p className="text-sm text-gray-500 font-mono">{product.sku}</p>
                    </div>
                  </div>
                  {getStatusBadge(product.is_active ?? true)}
                </div>
              </CardHeader>
              <CardContent className="space-y-3">
                <div className="space-y-1 text-sm">
                  <div className="flex justify-between">
                    <span className="text-gray-500">Category:</span>
                    <span className="font-medium">{product.category?.name || "N/A"}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-gray-500">Brand:</span>
                    <span className="font-medium">{product.brand?.name || "N/A"}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-gray-500">Group:</span>
                    <span className="font-medium">{product.group?.name || "N/A"}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-gray-500">Sub-Group:</span>
                    <span className="font-medium">{product.sub_group?.name || "N/A"}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-gray-500">Manufacturer:</span>
                    <span className="font-medium">{product.manufacturer?.name || "N/A"}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-gray-500">Price:</span>
                    <span className="font-medium">{formatPrice(product.price ?? null)}</span>
                  </div>
                </div>

                <div className="flex items-center justify-between pt-2 border-t">
                  <Button
                    variant="ghost"
                    size="sm"
                    onClick={() => handleViewProduct(product)}
                    title="View product details"
                    aria-label={`View ${product.name}`}
                  >
                    <Eye className="h-4 w-4 mr-1" />
                    View
                  </Button>
                  <div className="flex space-x-1">
                    <Button
                      variant="ghost"
                      size="sm"
                      onClick={() => handleEditProduct(product)}
                      title="Edit product"
                      aria-label={`Edit ${product.name}`}
                    >
                      <Edit className="h-4 w-4" />
                    </Button>
                    <Button
                      variant="ghost"
                      size="sm"
                      onClick={() => handleDeleteProduct(product)}
                      disabled={deletingId === product.id}
                      className="text-red-600 hover:text-red-700 hover:bg-red-50"
                      title="Delete product"
                      aria-label={`Delete ${product.name}`}
                    >
                      <Trash2 className="h-4 w-4" />
                    </Button>
                  </div>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      )}
    </div>
  );
}
