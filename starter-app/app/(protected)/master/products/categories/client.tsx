"use client";

import React, { useState, useTransition } from "react";
import { toast } from "sonner";
import { Button } from "@/components/ui/button";
import { createCategory, updateCategory, deleteCategory } from "./actions";

interface Category {
  id: string;
  name: string;
  code?: string;
  active: boolean;
  updated_at?: string;
}

interface CategoriesClientProps {
  categories: Category[];
}

export default function CategoriesClient({ categories }: CategoriesClientProps) {
  const [isPending, startTransition] = useTransition();
  const [editingId, setEditingId] = useState<string | null>(null);

  const handleCreate = (formData: FormData) => {
    startTransition(async () => {
      const result = await createCategory(formData);
      if (result.success) {
        toast.success("Category created successfully");
        // Reset form
        const form = document.querySelector("form") as HTMLFormElement;
        form?.reset();
      } else {
        toast.error(result.error || "Failed to create category");
      }
    });
  };

  const handleUpdate = (formData: FormData) => {
    startTransition(async () => {
      const result = await updateCategory(formData);
      if (result.success) {
        toast.success("Category updated successfully");
        setEditingId(null);
      } else {
        toast.error(result.error || "Failed to update category");
      }
    });
  };

  const handleDelete = (id: string) => {
    if (confirm("Are you sure you want to delete this category?")) {
      startTransition(async () => {
        const result = await deleteCategory(id);
        if (result.success) {
          toast.success("Category deleted successfully");
        } else {
          toast.error(result.error || "Failed to delete category");
        }
      });
    }
  };

  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold mb-6">Product Categories</h1>
      
      {/* Create Form */}
      <div className="bg-white p-4 rounded-lg shadow mb-6">
        <h2 className="text-lg font-semibold mb-4">Create New Category</h2>
        <form action={handleCreate} className="space-y-4">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
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
            {isPending ? "Creating..." : "Create Category"}
          </Button>
        </form>
      </div>

      {/* Categories List */}
      <div className="bg-white rounded-lg shadow overflow-hidden">
        <table className="min-w-full divide-y divide-gray-200">
          <thead className="bg-gray-50">
            <tr>
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
            {categories.map((category) => (
              <tr key={category.id}>
                {editingId === category.id ? (
                  <>
                    <td className="px-6 py-4 whitespace-nowrap" colSpan={4}>
                      <form action={handleUpdate} className="flex items-center space-x-2">
                        <input type="hidden" name="id" value={category.id} />
                        <input
                          type="text"
                          name="name"
                          defaultValue={category.name}
                          required
                          placeholder="Name"
                          className="border rounded px-2 py-1 text-sm"
                        />
                        <input
                          type="text"
                          name="code"
                          defaultValue={category.code || ""}
                          placeholder="Code"
                          className="border rounded px-2 py-1 text-sm"
                        />
                        <label className="flex items-center">
                          <input
                            type="checkbox"
                            name="active"
                            defaultChecked={category.active}
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
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                      {category.name}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                      {category.code || "-"}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <span
                        className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${
                          category.active
                            ? "bg-green-100 text-green-800"
                            : "bg-red-100 text-red-800"
                        }`}
                      >
                        {category.active ? "Active" : "Inactive"}
                      </span>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium">
                      <Button
                        onClick={() => setEditingId(category.id)}
                        variant="outline"
                        size="sm"
                        className="mr-2"
                      >
                        Edit
                      </Button>
                      <Button
                        onClick={() => handleDelete(category.id)}
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