"use client";

import React, { useState, useTransition } from "react";
import { toast } from "sonner";
import { useRouter } from "next/navigation";
import { Button } from "@/components/ui/button";
import { createDistributor, updateDistributor, deleteDistributor } from "./actions";
import ShopsClient from "./shops/client";

interface Distributor {
  id: string;
  name: string;
  is_active: boolean;
  created_at: string;
  updated_at?: string;
}

interface Shop {
  id: string;
  name: string;
  distributor_id: string;
  is_active: boolean;
  created_at: string;
  updated_at?: string;
}

interface DistributorsClientProps {
  tab: "list" | "shops";
  distributors: Distributor[];
  distributor: Distributor | null;
  shops: Shop[];
}

export default function DistributorsClient({ tab, distributors, distributor, shops }: DistributorsClientProps) {
  const [isPending, startTransition] = useTransition();
  const [editingId, setEditingId] = useState<string | null>(null);
  const router = useRouter();

  const handleTabChange = (newTab: string, distributorId?: string) => {
    if (newTab === "shops" && distributorId) {
      router.push(`/master/distributors?tab=shops&id=${distributorId}`);
    } else {
      router.push("/master/distributors?tab=list");
    }
  };

  const handleCreate = (formData: FormData) => {
    startTransition(async () => {
      const result = await createDistributor(formData);
      if (result.success) {
        toast.success("Distributor created successfully");
        // Reset form
        const form = document.querySelector("form") as HTMLFormElement;
        form?.reset();
      } else {
        toast.error(result.error || "Failed to create distributor");
      }
    });
  };

  const handleUpdate = (formData: FormData) => {
    startTransition(async () => {
      const result = await updateDistributor(formData);
      if (result.success) {
        toast.success("Distributor updated successfully");
        setEditingId(null);
      } else {
        toast.error(result.error || "Failed to update distributor");
      }
    });
  };

  const handleDelete = (id: string) => {
    if (confirm("Are you sure you want to delete this distributor?")) {
      startTransition(async () => {
        const result = await deleteDistributor(id);
        if (result.success) {
          toast.success("Distributor deleted successfully");
        } else {
          toast.error(result.error || "Failed to delete distributor");
        }
      });
    }
  };

  if (tab === "shops" && distributor) {
    return (
      <div className="p-6">
        <div className="mb-6">
          <Button
            onClick={() => handleTabChange("list")}
            variant="secondary"
            className="mb-4"
          >
            ← Back to Distributors List
          </Button>
          <h1 className="text-2xl font-bold">
            Shops Management - {distributor.name}
          </h1>
        </div>
        <ShopsClient distributorId={distributor.id} shops={shops} />
      </div>
    );
  }

  // List tab
  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold mb-6">Distributors</h1>
      
      {/* Tab Navigation */}
      <div className="border-b border-gray-200 mb-6">
        <nav className="-mb-px flex space-x-8">
          <Button
            onClick={() => handleTabChange("list")}
            variant={tab === "list" ? "primary" : "ghost"}
            size="sm"
            className={`py-2 px-1 border-b-2 font-medium text-sm ${
              tab === "list"
                ? "border-blue-500 text-blue-600"
                : "border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300"
            }`}
          >
            List
          </Button>
          <Button
            disabled
            variant="ghost"
            size="sm"
            className="py-2 px-1 border-b-2 border-transparent text-gray-400 text-sm"
          >
            Shops Management
          </Button>
        </nav>
      </div>
      
      {/* + Add Distributor Form */}
      <div className="bg-white p-4 rounded-lg shadow mb-6">
        <h2 className="text-lg font-semibold mb-4">+ Add Distributor</h2>
        <form action={handleCreate} className="space-y-4">
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
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
          <Button
            type="submit"
            variant="primary"
            size="lg"
            disabled={isPending}
          >
            {isPending ? "Creating..." : "Create Distributor"}
          </Button>
        </form>
      </div>

      {/* Distributors List */}
      <div className="bg-white rounded-lg shadow overflow-hidden">
        <table className="min-w-full divide-y divide-gray-200">
          <thead className="bg-gray-50">
            <tr>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Name
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
            {distributors.map((distributor) => (
              <tr key={distributor.id}>
                {editingId === distributor.id ? (
                  <>
                    <td className="px-6 py-4 whitespace-nowrap" colSpan={4}>
                      <form action={handleUpdate} className="flex items-center space-x-2 flex-wrap">
                        <input type="hidden" name="id" value={distributor.id} />
                        <input
                          type="text"
                          name="name"
                          defaultValue={distributor.name}
                          required
                          placeholder="Name"
                          className="border rounded px-2 py-1 text-sm"
                        />
                        <label className="flex items-center">
                          <input
                            type="checkbox"
                            name="active"
                            defaultChecked={distributor.is_active}
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
                      {distributor.name}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <span
                        className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${
                          distributor.is_active
                            ? "bg-green-100 text-green-800"
                            : "bg-red-100 text-red-800"
                        }`}
                      >
                        {distributor.is_active ? "Active" : "Inactive"}
                      </span>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                      {new Date(distributor.created_at).toLocaleDateString()}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium">
                      <Button
                        onClick={() => handleTabChange("shops", distributor.id)}
                        variant="outline"
                        size="sm"
                        className="mr-2"
                      >
                        Manage Shops
                      </Button>
                      <Button
                        onClick={() => setEditingId(distributor.id)}
                        variant="outline"
                        size="sm"
                        className="mr-2"
                      >
                        Edit
                      </Button>
                      <Button
                        onClick={() => handleDelete(distributor.id)}
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
        {distributors.length === 0 && (
          <div className="text-center py-8 text-gray-500">
            No distributors found.
          </div>
        )}
      </div>
    </div>
  );
}