"use client";

import React, { useState, useTransition } from "react";
import { toast } from "sonner";
import { createShop, updateShop, deleteShop } from "./actions";

interface Shop {
  id: string;
  name: string;
  distributor_id: string;
  is_active: boolean;
  created_at: string;
  updated_at?: string;
}

interface ShopsClientProps {
  distributorId: string;
  shops: Shop[];
}

export default function ShopsClient({ distributorId, shops }: ShopsClientProps) {
  const [isPending, startTransition] = useTransition();
  const [editingId, setEditingId] = useState<string | null>(null);

  const handleCreate = (formData: FormData) => {
    // Ensure distributor_id is set
    formData.set("distributor_id", distributorId);
    
    startTransition(async () => {
      const result = await createShop(formData);
      if (result.success) {
        toast.success("Shop created successfully");
        // Reset form
        const form = document.querySelector("form") as HTMLFormElement;
        form?.reset();
      } else {
        toast.error(result.error || "Failed to create shop");
      }
    });
  };

  const handleUpdate = (formData: FormData) => {
    // Ensure distributor_id is set
    formData.set("distributor_id", distributorId);
    
    startTransition(async () => {
      const result = await updateShop(formData);
      if (result.success) {
        toast.success("Shop updated successfully");
        setEditingId(null);
      } else {
        toast.error(result.error || "Failed to update shop");
      }
    });
  };

  const handleDelete = (id: string) => {
    if (confirm("Are you sure you want to delete this shop?")) {
      startTransition(async () => {
        const result = await deleteShop(id, distributorId);
        if (result.success) {
          toast.success("Shop deleted successfully");
        } else {
          toast.error(result.error || "Failed to delete shop");
        }
      });
    }
  };

  return (
    <div>
      {/* + Add Shop Form */}
      <div className="bg-white p-4 rounded-lg shadow mb-6">
        <h2 className="text-lg font-semibold mb-4">+ Add Shop</h2>
        <form action={handleCreate} className="space-y-4">
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
            <div>
              <label htmlFor="name" className="block text-sm font-medium text-gray-700">
                Shop Name *
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
              <label htmlFor="code" className="block text-sm font-medium text-gray-700">
                Code
              </label>
              <input
                type="text"
                id="code"
                name="code"
                placeholder="Optional"
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
              />
            </div>
            <div>
              <label htmlFor="email" className="block text-sm font-medium text-gray-700">
                Email
              </label>
              <input
                type="email"
                id="email"
                name="email"
                placeholder="Optional"
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
              />
            </div>
            <div>
              <label htmlFor="phone" className="block text-sm font-medium text-gray-700">
                Phone
              </label>
              <input
                type="text"
                id="phone"
                name="phone"
                placeholder="Optional"
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
              />
            </div>
            <div>
              <label htmlFor="address" className="block text-sm font-medium text-gray-700">
                Address
              </label>
              <input
                type="text"
                id="address"
                name="address"
                placeholder="Optional"
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
              />
            </div>
            <div>
              <label htmlFor="city" className="block text-sm font-medium text-gray-700">
                City
              </label>
              <input
                type="text"
                id="city"
                name="city"
                placeholder="Optional"
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
              />
            </div>
            <div>
              <label htmlFor="state_region" className="block text-sm font-medium text-gray-700">
                State/Region
              </label>
              <input
                type="text"
                id="state_region"
                name="state_region"
                placeholder="Optional"
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
              />
            </div>
            <div>
              <label htmlFor="postal_code" className="block text-sm font-medium text-gray-700">
                Postal Code
              </label>
              <input
                type="text"
                id="postal_code"
                name="postal_code"
                placeholder="Optional"
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
              />
            </div>
            <div>
              <label htmlFor="country_code" className="block text-sm font-medium text-gray-700">
                Country Code
              </label>
              <input
                type="text"
                id="country_code"
                name="country_code"
                placeholder="MY"
                maxLength={2}
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
            {isPending ? "Creating..." : "Create Shop"}
          </button>
        </form>
      </div>

      {/* Shops List */}
      <div className="bg-white rounded-lg shadow overflow-hidden">
        <table className="min-w-full divide-y divide-gray-200">
          <thead className="bg-gray-50">
            <tr>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Shop Name
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Status
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Created
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Actions
              </th>
            </tr>
          </thead>
          <tbody className="bg-white divide-y divide-gray-200">
            {shops.map((shop) => (
              <tr key={shop.id}>
                {editingId === shop.id ? (
                  <>
                    <td className="px-6 py-4 whitespace-nowrap" colSpan={4}>
                      <form action={handleUpdate} className="flex items-center space-x-2 flex-wrap">
                        <input type="hidden" name="id" value={shop.id} />
                        <input
                          type="text"
                          name="name"
                          defaultValue={shop.name}
                          required
                          placeholder="Shop Name"
                          className="border rounded px-2 py-1 text-sm"
                        />
                        <label className="flex items-center">
                          <input
                            type="checkbox"
                            name="active"
                            defaultChecked={shop.is_active}
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
                      {shop.name}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <span
                        className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${
                          shop.is_active
                            ? "bg-green-100 text-green-800"
                            : "bg-red-100 text-red-800"
                        }`}
                      >
                        {shop.is_active ? "Active" : "Inactive"}
                      </span>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                      {new Date(shop.created_at).toLocaleDateString()}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium">
                      <button
                        onClick={() => setEditingId(shop.id)}
                        className="text-indigo-600 hover:text-indigo-900 mr-2"
                      >
                        Edit
                      </button>
                      <button
                        onClick={() => handleDelete(shop.id)}
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
        {shops.length === 0 && (
          <div className="text-center py-8 text-gray-500">
            No shops found for this distributor.
          </div>
        )}
      </div>
    </div>
  );
}