"use client";

import { useState, useTransition, useEffect } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { ArrowLeft, Save } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { updateCategory } from "../../actions";
import { toast } from "sonner";
import { createClient } from "@/lib/supabase/client";

interface PageProps {
  params: Promise<{ id: string }>;
}

export default function EditCategoryPage({ params }: PageProps) {
  const router = useRouter();
  const [isPending, startTransition] = useTransition();
  const [loading, setLoading] = useState(true);
  const [categoryId, setCategoryId] = useState("");
  const [formData, setFormData] = useState({
    name: "",
    is_active: true
  });

  useEffect(() => {
    const loadCategory = async () => {
      const { id } = await params;
      setCategoryId(id);
      
      const supabase = createClient();
      const { data: category, error } = await supabase
        .from("categories")
        .select("*")
        .eq("id", id)
        .single();

      if (error || !category) {
        toast.error("Category not found");
        router.push("/master/categories");
        return;
      }

      setFormData({
        name: category.name,
        is_active: category.is_active
      });
      setLoading(false);
    };

    loadCategory();
  }, [params, router]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    startTransition(async () => {
      const data = new FormData();
      data.append("name", formData.name);
      data.append("is_active", formData.is_active.toString());
      
      const result = await updateCategory(categoryId, data);
      
      if (result.ok) {
        toast.success("Category updated successfully");
        router.push("/master/categories");
      } else {
        toast.error(result.message);
      }
    });
  };

  if (loading) {
    return (
      <div className="max-w-2xl mx-auto space-y-6">
        <div className="bg-white shadow sm:rounded-lg">
          <div className="px-4 py-5 sm:p-6">
            <div className="animate-pulse">
              <div className="h-4 bg-gray-200 rounded w-1/4 mb-4"></div>
              <div className="space-y-3">
                <div className="h-4 bg-gray-200 rounded"></div>
                <div className="h-4 bg-gray-200 rounded w-5/6"></div>
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="max-w-2xl mx-auto space-y-6">
      <div className="flex items-center gap-4">
        <Link 
          href="/master/categories"
          className="inline-flex items-center gap-2 text-sm text-gray-600 hover:text-gray-900"
        >
          <ArrowLeft className="h-4 w-4" />
          Back to Categories
        </Link>
      </div>

      <div className="bg-white shadow sm:rounded-lg">
        <div className="px-4 py-5 sm:p-6">
          <h1 className="text-lg font-medium text-gray-900 mb-6">Edit Category</h1>
          
          <form onSubmit={handleSubmit} className="space-y-6">
            <div>
              <label htmlFor="name" className="block text-sm font-medium text-gray-700 mb-2">
                Category Name *
              </label>
              <Input
                id="name"
                type="text"
                value={formData.name}
                onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                placeholder="Enter category name"
                required
                className="w-full"
              />
            </div>

            <div>
              <label className="flex items-center gap-2">
                <input
                  type="checkbox"
                  checked={formData.is_active}
                  onChange={(e) => setFormData({ ...formData, is_active: e.target.checked })}
                  className="rounded border-gray-300 text-blue-600 focus:ring-blue-500"
                />
                <span className="text-sm font-medium text-gray-700">Active</span>
              </label>
            </div>

            <div className="flex gap-3 pt-4">
              <Button
                type="submit"
                disabled={isPending || !formData.name.trim()}
                className="inline-flex items-center gap-2"
              >
                <Save className="h-4 w-4" />
                {isPending ? "Updating..." : "Update Category"}
              </Button>
              <Button
                type="button"
                variant="outline"
                onClick={() => router.push("/master/categories")}
                disabled={isPending}
              >
                Cancel
              </Button>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
}