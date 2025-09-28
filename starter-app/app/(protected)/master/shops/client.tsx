"use client";

import React, { useState, useTransition } from "react";
import { toast } from "sonner";
import { useRouter } from "next/navigation";
import { createShop, updateShop, deleteShop } from "./actions";
import PointsClient from "./points/client";
import { Button } from "@/components/ui/button";

interface Shop {
  id: string;
  name: string;
  distributor_id: string;
  is_active: boolean;
  created_at: string;
  updated_at?: string;
  distributors?: { name: string };
}

interface Balance {
  shop_id: string;
  points: number;
}

interface Distributor {
  id: string;
  name: string;
}

interface ShopsClientProps {
  tab: "list" | "points";
  shops: Shop[];
  balances: Balance[];
  distributors: Distributor[];
}

export default function ShopsClient({ tab, shops, balances, distributors }: ShopsClientProps) {
  const [isPending, startTransition] = useTransition();
  const [editingId, setEditingId] = useState<string | null>(null);
  const router = useRouter();

  const handleTabChange = (newTab: string) => {
    router.push(`/master/shops?tab=${newTab}`);
  };

  const handleCreate = (formData: FormData) => {
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
        const result = await deleteShop(id);
        if (result.success) {
          toast.success("Shop deleted successfully");
        } else {
          toast.error(result.error || "Failed to delete shop");
        }
      });
    }
  };

  if (tab === "points") {
    return (
      <div className="p-6">
        <h1 className="text-2xl font-bold mb-6">Shops - Points Balance</h1>
        
        {/* Tab Navigation */}
        <div className="border-b border-gray-200 mb-6">
          <nav className="-mb-px flex space-x-8">
            <Button
              onClick={() => handleTabChange("list")}
              variant="ghost"
              size="sm"
              className="py-2 px-1 border-b-2 border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 font-medium text-sm"
            >
              List
            </Button>
            <Button
              onClick={() => handleTabChange("points")}
              variant="ghost"
              size="sm"
              className="py-2 px-1 border-b-2 border-blue-500 text-blue-600 font-medium text-sm"
            >
              Points Balance
            </Button>
          </nav>
        </div>
        
        <PointsClient shops={shops} balances={balances} />
      </div>
    );
  }

  // List tab
  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold mb-6">Shops</h1>
      
      {/* Tab Navigation */}
      <div className="border-b border-gray-200 mb-6">
        <nav className="-mb-px flex space-x-8">
          <Button
            onClick={() => handleTabChange("list")}
            variant="ghost"
            size="sm"
            className="py-2 px-1 border-b-2 border-blue-500 text-blue-600 font-medium text-sm"
          >
            List
          </Button>
          <Button
            onClick={() => handleTabChange("points")}
            variant="ghost"
            size="sm"
            className="py-2 px-1 border-b-2 border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 font-medium text-sm"
          >
            Points Balance
          </Button>
        </nav>
      </div>
      
      {/* + Add Shop Form */}
      <div className="bg-white p-4 rounded-lg shadow mb-6">
        <h2 className="text-lg font-semibold mb-4">+ Add Shop</h2>
        <form action={handleCreate} className="space-y-4">
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
            <div>
              <label htmlFor="distributor_id" className="block text-sm font-medium text-gray-700">
                Distributor *
              </label>
              <select
                id="distributor_id"
                name="distributor_id"
                required
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
              >
                <option value="">Select Distributor</option>
                {distributors.map((distributor) => (
                  <option key={distributor.id} value={distributor.id}>
                    {distributor.name}
                  </option>
                ))}
              </select>
            </div>
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
            {isPending ? "Creating..." : "Create Shop"}
          </Button>
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
                Distributor
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
                    <td className="px-6 py-4 whitespace-nowrap" colSpan={5}>
                      <form action={handleUpdate} className="flex items-center space-x-2 flex-wrap">
                        <input type="hidden" name="id" value={shop.id} />
                        <select
                          name="distributor_id"
                          defaultValue={shop.distributor_id}
                          required
                          className="border rounded px-2 py-1 text-sm"
                        >
                          {distributors.map((distributor) => (
                            <option key={distributor.id} value={distributor.id}>
                              {distributor.name}
                            </option>
                          ))}
                        </select>
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
                      {shop.name}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                      {shop.distributors?.name || "N/A"}
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
                      <Button
                        variant="outline"
                        size="sm"
                        onClick={() => setEditingId(shop.id)}
                        className="mr-2"
                      >
                        Edit
                      </Button>
                      <Button
                        variant="destructive"
                        size="sm"
                        onClick={() => handleDelete(shop.id)}
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
        {shops.length === 0 && (
          <div className="text-center py-8 text-gray-500">
            No shops found.
          </div>
        )}
      </div>
    </div>
  );
}