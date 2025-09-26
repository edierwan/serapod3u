"use client";

import React, { useState, useTransition } from "react";
import { toast } from "sonner";
import { createProduct, updateProduct, deleteProduct } from "./actions";

interface Product {
  id: string;
  subtype_id: string;
  manufacturer_id: string;
  sku: string;
  name: string;
  uom?: string;
  active: boolean;
  updated_at?: string;
  product_subtypes?: { name: string };
  manufacturers?: { name: string };
}

interface Subtype {
  id: string;
  name: string;
}

interface Manufacturer {
  id: string;
  name: string;
}

interface ProductsClientProps {
  products: Product[];
  subtypes: Subtype[];
  manufacturers: Manufacturer[];
}

export default function ProductsClient({ products, subtypes, manufacturers }: ProductsClientProps) {
  const [isPending, startTransition] = useTransition();
  const [editingId, setEditingId] = useState<string | null>(null);

  const handleCreate = (formData: FormData) => {
    startTransition(async () => {
      const result = await createProduct(formData);
      if (result.success) {
        toast.success("Product created successfully");
        // Reset form
        const form = document.querySelector("form") as HTMLFormElement;
        form?.reset();
      } else {
        toast.error(result.error || "Failed to create product");
      }
    });
  };

  const handleUpdate = (formData: FormData) => {
    startTransition(async () => {
      const result = await updateProduct(formData);
      if (result.success) {
        toast.success("Product updated successfully");
        setEditingId(null);
      } else {
        toast.error(result.error || "Failed to update product");
      }
    });
  };

  const handleDelete = (id: string) => {
    if (confirm("Are you sure you want to delete this product?")) {
      startTransition(async () => {
        const result = await deleteProduct(id);
        if (result.success) {
          toast.success("Product deleted successfully");
        } else {
          toast.error(result.error || "Failed to delete product");
        }
      });
    }
  };

  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold mb-6">Products</h1>
      
      {/* + Add Product Form */}
      <div className="bg-white p-4 rounded-lg shadow mb-6">
        <h2 className="text-lg font-semibold mb-4">+ Add Product</h2>
        <form action={handleCreate} className="space-y-4">
          <div className="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-6 gap-4">
            <div>
              <label htmlFor="subtype_id" className="block text-sm font-medium text-gray-700">
                Sub-Type *
              </label>
              <select
                id="subtype_id"
                name="subtype_id"
                required
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
              >
                <option value="">Select Sub-Type</option>
                {subtypes.map((subtype) => (
                  <option key={subtype.id} value={subtype.id}>
                    {subtype.name}
                  </option>
                ))}
              </select>
            </div>
            <div>
              <label htmlFor="manufacturer_id" className="block text-sm font-medium text-gray-700">
                Manufacturer *
              </label>
              <select
                id="manufacturer_id"
                name="manufacturer_id"
                required
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
              >
                <option value="">Select Manufacturer</option>
                {manufacturers.map((manufacturer) => (
                  <option key={manufacturer.id} value={manufacturer.id}>
                    {manufacturer.name}
                  </option>
                ))}
              </select>
            </div>
            <div>
              <label htmlFor="sku" className="block text-sm font-medium text-gray-700">
                SKU *
              </label>
              <input
                type="text"
                id="sku"
                name="sku"
                required
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
              />
            </div>
            <div>
              <label htmlFor="name" className="block text-sm font-medium text-gray-700">
                Name *
              </label>
              <input
                type="text"
                id="name"
                name="name"
                required
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
              />
            </div>
            <div>
              <label htmlFor="uom" className="block text-sm font-medium text-gray-700">
                UOM
              </label>
              <input
                type="text"
                id="uom"
                name="uom"
                placeholder="Unit of Measure"
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
          <button
            type="submit"
            disabled={isPending}
            className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded disabled:opacity-50"
          >
            {isPending ? "Creating..." : "Create Product"}
          </button>
        </form>
      </div>

      {/* Products List */}
      <div className="bg-white rounded-lg shadow overflow-hidden">
        <table className="min-w-full divide-y divide-gray-200">
          <thead className="bg-gray-50">
            <tr>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                SKU
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Name
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Sub-Type
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Manufacturer
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                UOM
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
            {products.map((product) => (
              <tr key={product.id}>
                {editingId === product.id ? (
                  <>
                    <td className="px-6 py-4 whitespace-nowrap" colSpan={7}>
                      <form action={handleUpdate} className="flex items-center space-x-2 flex-wrap">
                        <input type="hidden" name="id" value={product.id} />
                        <select
                          name="subtype_id"
                          defaultValue={product.subtype_id}
                          required
                          className="border rounded px-2 py-1 text-sm"
                        >
                          {subtypes.map((subtype) => (
                            <option key={subtype.id} value={subtype.id}>
                              {subtype.name}
                            </option>
                          ))}
                        </select>
                        <select
                          name="manufacturer_id"
                          defaultValue={product.manufacturer_id}
                          required
                          className="border rounded px-2 py-1 text-sm"
                        >
                          {manufacturers.map((manufacturer) => (
                            <option key={manufacturer.id} value={manufacturer.id}>
                              {manufacturer.name}
                            </option>
                          ))}
                        </select>
                        <input
                          type="text"
                          name="sku"
                          defaultValue={product.sku}
                          required
                          placeholder="SKU"
                          className="border rounded px-2 py-1 text-sm"
                        />
                        <input
                          type="text"
                          name="name"
                          defaultValue={product.name}
                          required
                          placeholder="Name"
                          className="border rounded px-2 py-1 text-sm"
                        />
                        <input
                          type="text"
                          name="uom"
                          defaultValue={product.uom || ""}
                          placeholder="UOM"
                          className="border rounded px-2 py-1 text-sm"
                        />
                        <label className="flex items-center">
                          <input
                            type="checkbox"
                            name="active"
                            defaultChecked={product.active}
                            className="h-4 w-4 mr-1"
                          />
                          Active
                        </label>
                        <button
                          type="submit"
                          className="text-green-600 hover:text-green-900 px-2 py-1 border border-green-600 rounded"
                        >
                          Save
                        </button>
                        <button
                          type="button"
                          onClick={() => setEditingId(null)}
                          className="text-gray-600 hover:text-gray-900 px-2 py-1 border border-gray-600 rounded"
                        >
                          Cancel
                        </button>
                      </form>
                    </td>
                  </>
                ) : (
                  <>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                      {product.sku}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                      {product.name}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                      {product.product_subtypes?.name || "N/A"}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                      {product.manufacturers?.name || "N/A"}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                      {product.uom || "-"}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <span
                        className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${
                          product.active
                            ? "bg-green-100 text-green-800"
                            : "bg-red-100 text-red-800"
                        }`}
                      >
                        {product.active ? "Active" : "Inactive"}
                      </span>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium">
                      <button
                        onClick={() => setEditingId(product.id)}
                        className="text-indigo-600 hover:text-indigo-900 mr-2"
                      >
                        Edit
                      </button>
                      <button
                        onClick={() => handleDelete(product.id)}
                        className="text-red-600 hover:text-red-900"
                      >
                        Delete
                      </button>
                    </td>
                  </>
                )}
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}