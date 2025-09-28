"use client";

import React, { useState, useTransition } from "react";
import { toast } from "sonner";
import { Button } from "@/components/ui/button";
import { createGroup, updateGroup, deleteGroup } from "./actions";

interface Group {
  id: string;
  category_id: string;
  name: string;
  code?: string;
  active: boolean;
  updated_at?: string;
  product_categories?: { id: string; name: string };
}

interface Category {
  id: string;
  name: string;
}

interface GroupsClientProps {
  groups: Group[];
  categories: Category[];
}

export default function GroupsClient({ groups, categories }: GroupsClientProps) {
  const [isPending, startTransition] = useTransition();
  const [editingId, setEditingId] = useState<string | null>(null);

  const handleCreate = (formData: FormData) => {
    startTransition(async () => {
      const result = await createGroup(formData);
      if (result.success) {
        toast.success("Group created successfully");
        // Reset form
        const form = document.querySelector("form") as HTMLFormElement;
        form?.reset();
      } else {
        toast.error(result.error || "Failed to create group");
      }
    });
  };

  const handleUpdate = (formData: FormData) => {
    startTransition(async () => {
      const result = await updateGroup(formData);
      if (result.success) {
        toast.success("Group updated successfully");
        setEditingId(null);
      } else {
        toast.error(result.error || "Failed to update group");
      }
    });
  };

  const handleDelete = (id: string) => {
    if (confirm("Are you sure you want to delete this group?")) {
      startTransition(async () => {
        const result = await deleteGroup(id);
        if (result.success) {
          toast.success("Group deleted successfully");
        } else {
          toast.error(result.error || "Failed to delete group");
        }
      });
    }
  };

  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold mb-6">Product Groups</h1>
      
      {/* Create Form */}
      <div className="bg-white p-4 rounded-lg shadow mb-6">
        <h2 className="text-lg font-semibold mb-4">Create New Group</h2>
        <form action={handleCreate} className="space-y-4">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
            <div>
              <label htmlFor="category_id" className="block text-sm font-medium text-gray-700">
                Category *
              </label>
              <select
                id="category_id"
                name="category_id"
                required
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
              >
                <option value="">Select Category</option>
                {categories.map((category) => (
                  <option key={category.id} value={category.id}>
                    {category.name}
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
          <Button
            type="submit"
            variant="primary"
            size="lg"
            disabled={isPending}
          >
            {isPending ? "Creating..." : "Create Group"}
          </Button>
        </form>
      </div>

      {/* Groups List */}
      <div className="bg-white rounded-lg shadow overflow-hidden">
        <table className="min-w-full divide-y divide-gray-200">
          <thead className="bg-gray-50">
            <tr>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Category
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
            {groups.map((group) => (
              <tr key={group.id}>
                {editingId === group.id ? (
                  <>
                    <td className="px-6 py-4 whitespace-nowrap" colSpan={5}>
                      <form action={handleUpdate} className="flex items-center space-x-2">
                        <input type="hidden" name="id" value={group.id} />
                        <select
                          name="category_id"
                          defaultValue={group.category_id}
                          required
                          className="border rounded px-2 py-1 text-sm"
                        >
                          {categories.map((category) => (
                            <option key={category.id} value={category.id}>
                              {category.name}
                            </option>
                          ))}
                        </select>
                        <input
                          type="text"
                          name="name"
                          defaultValue={group.name}
                          required
                          placeholder="Name"
                          className="border rounded px-2 py-1 text-sm"
                        />
                        <input
                          type="text"
                          name="code"
                          defaultValue={group.code || ""}
                          placeholder="Code"
                          className="border rounded px-2 py-1 text-sm"
                        />
                        <label className="flex items-center">
                          <input
                            type="checkbox"
                            name="active"
                            defaultChecked={group.active}
                            className="h-4 w-4 mr-1"
                          />
                          Active
                        </label>
                        <Button
                          type="submit"
                          variant="primary"
                          size="sm"
                          disabled={isPending}
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
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                      {group.product_categories?.name || "N/A"}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                      {group.name}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                      {group.code || "-"}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <span
                        className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${
                          group.active
                            ? "bg-green-100 text-green-800"
                            : "bg-red-100 text-red-800"
                        }`}
                      >
                        {group.active ? "Active" : "Inactive"}
                      </span>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium">
                      <Button
                        onClick={() => setEditingId(group.id)}
                        variant="outline"
                        size="sm"
                        className="mr-2"
                      >
                        Edit
                      </Button>
                      <Button
                        onClick={() => handleDelete(group.id)}
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
      </div>
    </div>
  );
}