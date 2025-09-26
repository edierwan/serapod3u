"use client";

import React, { useState, useTransition } from "react";
import { toast } from "sonner";
import { createSubtype, updateSubtype, deleteSubtype } from "./actions";

interface Subtype {
  id: string;
  group_id: string;
  name: string;
  code?: string;
  active: boolean;
  updated_at?: string;
  product_groups?: { 
    id: string; 
    name: string; 
    product_categories?: { name: string };
  };
}

interface Group {
  id: string;
  name: string;
  product_categories?: { name: string }[];
}

interface SubtypesClientProps {
  subtypes: Subtype[];
  groups: Group[];
}

export default function SubtypesClient({ subtypes, groups }: SubtypesClientProps) {
  const [isPending, startTransition] = useTransition();
  const [editingId, setEditingId] = useState<string | null>(null);

  const handleCreate = (formData: FormData) => {
    startTransition(async () => {
      const result = await createSubtype(formData);
      if (result.success) {
        toast.success("Subtype created successfully");
        // Reset form
        const form = document.querySelector("form") as HTMLFormElement;
        form?.reset();
      } else {
        toast.error(result.error || "Failed to create subtype");
      }
    });
  };

  const handleUpdate = (formData: FormData) => {
    startTransition(async () => {
      const result = await updateSubtype(formData);
      if (result.success) {
        toast.success("Subtype updated successfully");
        setEditingId(null);
      } else {
        toast.error(result.error || "Failed to update subtype");
      }
    });
  };

  const handleDelete = (id: string) => {
    if (confirm("Are you sure you want to delete this subtype?")) {
      startTransition(async () => {
        const result = await deleteSubtype(id);
        if (result.success) {
          toast.success("Subtype deleted successfully");
        } else {
          toast.error(result.error || "Failed to delete subtype");
        }
      });
    }
  };

  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold mb-6">Product Sub-Types</h1>
      
      {/* Create Form */}
      <div className="bg-white p-4 rounded-lg shadow mb-6">
        <h2 className="text-lg font-semibold mb-4">Create New Sub-Type</h2>
        <form action={handleCreate} className="space-y-4">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
            <div>
              <label htmlFor="group_id" className="block text-sm font-medium text-gray-700">
                Group *
              </label>
              <select
                id="group_id"
                name="group_id"
                required
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
              >
                <option value="">Select Group</option>
                {groups.map((group) => (
                  <option key={group.id} value={group.id}>
                    {group.name} ({group.product_categories?.[0]?.name})
                  </option>
                ))}
              </select>
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
              <label htmlFor="code" className="block text-sm font-medium text-gray-700">
                Code
              </label>
              <input
                type="text"
                id="code"
                name="code"
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
            {isPending ? "Creating..." : "Create Sub-Type"}
          </button>
        </form>
      </div>

      {/* Subtypes List */}
      <div className="bg-white rounded-lg shadow overflow-hidden">
        <table className="min-w-full divide-y divide-gray-200">
          <thead className="bg-gray-50">
            <tr>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Category
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Group
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Name
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Code
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
            {subtypes.map((subtype) => (
              <tr key={subtype.id}>
                {editingId === subtype.id ? (
                  <>
                    <td className="px-6 py-4 whitespace-nowrap" colSpan={6}>
                      <form action={handleUpdate} className="flex items-center space-x-2">
                        <input type="hidden" name="id" value={subtype.id} />
                        <select
                          name="group_id"
                          defaultValue={subtype.group_id}
                          required
                          className="border rounded px-2 py-1 text-sm"
                        >
                          {groups.map((group) => (
                            <option key={group.id} value={group.id}>
                              {group.name} ({group.product_categories?.[0]?.name})
                            </option>
                          ))}
                        </select>
                        <input
                          type="text"
                          name="name"
                          defaultValue={subtype.name}
                          required
                          placeholder="Name"
                          className="border rounded px-2 py-1 text-sm"
                        />
                        <input
                          type="text"
                          name="code"
                          defaultValue={subtype.code || ""}
                          placeholder="Code"
                          className="border rounded px-2 py-1 text-sm"
                        />
                        <label className="flex items-center">
                          <input
                            type="checkbox"
                            name="active"
                            defaultChecked={subtype.active}
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
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                      {subtype.product_groups?.product_categories?.name || "N/A"}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                      {subtype.product_groups?.name || "N/A"}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                      {subtype.name}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                      {subtype.code || "-"}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <span
                        className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${
                          subtype.active
                            ? "bg-green-100 text-green-800"
                            : "bg-red-100 text-red-800"
                        }`}
                      >
                        {subtype.active ? "Active" : "Inactive"}
                      </span>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium">
                      <button
                        onClick={() => setEditingId(subtype.id)}
                        className="text-indigo-600 hover:text-indigo-900 mr-2"
                      >
                        Edit
                      </button>
                      <button
                        onClick={() => handleDelete(subtype.id)}
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