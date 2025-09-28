"use client";

import React, { useState, useTransition } from "react";
import { toast } from "sonner";
import { useRouter, useSearchParams } from "next/navigation";
import { createVariant, updateVariant, deleteVariant } from "./actions";
import { Button } from "@/components/ui/button";

interface Variant {
  id: string;
  product_id: string;
  flavor_name?: string;
  sku?: string;
  is_active: boolean;
  created_at: string;
  updated_at?: string;
  products?: { name: string; sku?: string };
}

interface Product {
  id: string;
  name: string;
}

interface VariantsClientProps {
  variants: Variant[];
  products: Product[];
  productId: string | null;
}

export default function VariantsClient({ variants, products, productId }: VariantsClientProps) {
  const [isPending, startTransition] = useTransition();
  const [editingId, setEditingId] = useState<string | null>(null);
  const [selectedProductId, setSelectedProductId] = useState<string>(productId || "");
  const router = useRouter();
  const searchParams = useSearchParams();

  const handleProductFilter = (newProductId: string) => {
    setSelectedProductId(newProductId);
    const params = new URLSearchParams(searchParams.toString());
    if (newProductId) {
      params.set("product_id", newProductId);
    } else {
      params.delete("product_id");
    }
    router.push(`/master/products/variants?${params.toString()}`);
  };

  const handleCreate = (formData: FormData) => {
    // If a product is preselected, use it
    if (selectedProductId && !formData.get("product_id")) {
      formData.set("product_id", selectedProductId);
    }
    
    startTransition(async () => {
      const result = await createVariant(formData);
      if (result.success) {
        toast.success("Variant created successfully");
        // Reset form
        const form = document.querySelector("form") as HTMLFormElement;
        form?.reset();
      } else {
        toast.error(result.error || "Failed to create variant");
      }
    });
  };

  const handleUpdate = (formData: FormData) => {
    startTransition(async () => {
      const result = await updateVariant(formData);
      if (result.success) {
        toast.success("Variant updated successfully");
        setEditingId(null);
      } else {
        toast.error(result.error || "Failed to update variant");
      }
    });
  };

  const handleDelete = (id: string) => {
    if (confirm("Are you sure you want to delete this variant?")) {
      startTransition(async () => {
        const result = await deleteVariant(id);
        if (result.success) {
          toast.success("Variant deleted successfully");
        } else {
          toast.error(result.error || "Failed to delete variant");
        }
      });
    }
  };

  const filteredVariants = selectedProductId ? 
    variants.filter(v => v.product_id === selectedProductId) : 
    variants;

  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold mb-6">Product Variants</h1>
      
      {/* Product Filter */}
      {!productId && (
        <div className="bg-white p-4 rounded-lg shadow mb-6">
          <h2 className="text-lg font-semibold mb-4">Filter by Product</h2>
          <select
            value={selectedProductId}
            onChange={(e) => handleProductFilter(e.target.value)}
            className="block w-full max-w-md rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
          >
            <option value="">All Products</option>
            {products.map((product) => (
              <option key={product.id} value={product.id}>
                {product.name}
              </option>
            ))}
          </select>
        </div>
      )}
      
      {/* + Add Variant Form */}
      <div className="bg-white p-4 rounded-lg shadow mb-6">
        <h2 className="text-lg font-semibold mb-4">+ Add Variant</h2>
        <form action={handleCreate} className="space-y-4">
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-4">
            <div>
              <label htmlFor="product_id" className="block text-sm font-medium text-gray-700">
                Product *
              </label>
              <select
                id="product_id"
                name="product_id"
                required
                defaultValue={selectedProductId}
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
              >
                <option value="">Select Product</option>
                {products.map((product) => (
                  <option key={product.id} value={product.id}>
                    {product.name}
                  </option>
                ))}
              </select>
            </div>
            <div>
              <label htmlFor="variant" className="block text-sm font-medium text-gray-700">
                Variant *
              </label>
              <input
                type="text"
                id="variant"
                name="variant"
                required
                placeholder="e.g., Strawberry"
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
              />
            </div>
            <div>
              <label htmlFor="barcode" className="block text-sm font-medium text-gray-700">
                Barcode/SKU
              </label>
              <input
                type="text"
                id="barcode"
                name="barcode"
                placeholder="Optional barcode"
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
              />
            </div>
            <div>
              <label htmlFor="units_per_box" className="block text-sm font-medium text-gray-700">
                Units/Box
              </label>
              <input
                type="number"
                id="units_per_box"
                name="units_per_box"
                min="1"
                placeholder="Optional"
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
              />
            </div>
            <div className="flex items-center">
              <input
                type="checkbox"
                id="active"
                name="active"
                defaultChecked
                className="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded"
              />
              <label htmlFor="active" className="ml-2 block text-sm text-gray-900">
                Active
              </label>
            </div>
          </div>
          <Button
            type="submit"
            variant="primary"
            size="lg"
            disabled={isPending}
          >
            {isPending ? "Creating..." : "Create Variant"}
          </Button>
        </form>
      </div>

      {/* Variants List */}
      <div className="bg-white rounded-lg shadow overflow-hidden">
        <table className="min-w-full divide-y divide-gray-200">
          <thead className="bg-gray-50">
            <tr>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Product
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Variant
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Barcode/SKU
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Status
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Actions
              </th>
            </tr>
          </thead>
          <tbody className="bg-white divide-y divide-gray-200">
            {filteredVariants.map((variant) => (
              <tr key={variant.id}>
                {editingId === variant.id ? (
                  <>
                    <td className="px-6 py-4 whitespace-nowrap" colSpan={5}>
                      <form action={handleUpdate} className="flex items-center space-x-2 flex-wrap">
                        <input type="hidden" name="id" value={variant.id} />
                        <select
                          name="product_id"
                          defaultValue={variant.product_id}
                          required
                          className="border rounded px-2 py-1 text-sm"
                        >
                          {products.map((product) => (
                            <option key={product.id} value={product.id}>
                              {product.name}
                            </option>
                          ))}
                        </select>
                        <input
                          type="text"
                          name="variant"
                          defaultValue={variant.flavor_name || ""}
                          required
                          placeholder="Variant"
                          className="border rounded px-2 py-1 text-sm"
                        />
                        <input
                          type="text"
                          name="barcode"
                          defaultValue={variant.sku || ""}
                          placeholder="Barcode/SKU"
                          className="border rounded px-2 py-1 text-sm"
                        />
                        <label className="flex items-center">
                          <input
                            type="checkbox"
                            name="active"
                            defaultChecked={variant.is_active}
                            className="h-4 w-4 mr-1"
                          />
                          Active
                        </label>
                        <Button
                          type="submit"
                          variant="primary"
                          size="sm"
                        >
                          Save
                        </Button>
                        <Button
                          type="button"
                          variant="outline"
                          size="sm"
                          onClick={() => setEditingId(null)}
                        >
                          Cancel
                        </Button>
                      </form>
                    </td>
                  </>
                ) : (
                  <>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                      {variant.products?.name || "N/A"}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                      {variant.flavor_name || "-"}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                      {variant.sku || "-"}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <span
                        className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${
                          variant.is_active
                            ? "bg-green-100 text-green-800"
                            : "bg-red-100 text-red-800"
                        }`}
                      >
                        {variant.is_active ? "Active" : "Inactive"}
                      </span>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium">
                      <Button
                        onClick={() => setEditingId(variant.id)}
                        variant="outline"
                        size="sm"
                        className="mr-2"
                      >
                        Edit
                      </Button>
                      <Button
                        onClick={() => handleDelete(variant.id)}
                        variant="destructive"
                        size="sm"
                      >
                        Delete
                      </Button>
                    </td>
                  </>
                )}
              </tr>
            ))}
          </tbody>
        </table>
        {filteredVariants.length === 0 && (
          <div className="text-center py-8 text-gray-500">
            No variants found.
          </div>
        )}
      </div>
    </div>
  );
}