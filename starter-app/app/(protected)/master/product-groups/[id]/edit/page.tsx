"use client";

import { useState, useTransition, useEffect } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { ArrowLeft, Save } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Select, SelectTrigger, SelectValue, SelectContent, SelectItem } from "@/components/ui/select";
import { updateProductGroup } from "../../actions";
import { toast } from "sonner";
import { createClient } from "@/lib/supabase/client";
import { PRODUCT_CATEGORY_OPTIONS, CATEGORY_NAME_TO_ENUM_MAP, type ProductCategoryValue } from "@/lib/constants/productCategories";

interface PageProps {
  params: Promise<{ id: string }>;
}

export default function EditProductGroupPage({ params }: PageProps) {
  const router = useRouter();
  const [isPending, startTransition] = useTransition();
  const [loading, setLoading] = useState(true);
  const [productGroupId, setProductGroupId] = useState("");
  const [formData, setFormData] = useState({
    name: "",
    category: undefined as ProductCategoryValue | undefined,
    is_active: true
  });

  useEffect(() => {
    const loadProductGroup = async () => {
      const { id } = await params;
      setProductGroupId(id);
      
      const supabase = createClient();
      const { data: productGroup, error } = await supabase
        .from("product_groups")
        .select(`
          *,
          categories:category_id (
            id,
            name
          )
        `)
        .eq("id", id)
        .single();

      if (error || !productGroup) {
        toast.error("Product group not found");
        router.push("/master/product-groups");
        return;
      }

      // Convert category name back to enum value
      const categoryEnum = productGroup.categories?.name ? 
        CATEGORY_NAME_TO_ENUM_MAP[productGroup.categories.name] : 
        undefined;

      setFormData({
        name: productGroup.name,
        category: categoryEnum,
        is_active: productGroup.is_active
      });
      setLoading(false);
    };

    loadProductGroup();
  }, [params, router]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    // Validation: ensure both name and category are provided
    if (!formData.name.trim() || !formData.category) {
      toast.error("Please fill in all required fields");
      return;
    }
    
    startTransition(async () => {
      const data = new FormData();
      data.append("name", formData.name);
      data.append("category", formData.category!);
      data.append("is_active", formData.is_active.toString());
      
      const result = await updateProductGroup(productGroupId, data);
      
      if (result.ok) {
        toast.success("Product group updated successfully");
        router.push("/master/product-groups");
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
          href="/master/product-groups"
          className="inline-flex items-center gap-2 text-sm text-gray-600 hover:text-gray-900"
        >
          <ArrowLeft className="h-4 w-4" />
          Back to Product Groups
        </Link>
      </div>

      <div className="bg-white shadow sm:rounded-lg">
        <div className="px-4 py-5 sm:p-6">
          <h1 className="text-lg font-medium text-gray-900 mb-6">Edit Product Group</h1>
          
          <form onSubmit={handleSubmit} className="space-y-6">
            <div>
              <label htmlFor="name" className="block text-sm font-medium text-gray-700 mb-2">
                Product Group Name *
              </label>
              <Input
                id="name"
                type="text"
                value={formData.name}
                onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                placeholder="Enter product group name"
                required
                className="w-full"
              />
            </div>

            <div>
              <label htmlFor="category" className="block text-sm font-medium text-gray-700 mb-2">
                Category *
              </label>
              <Select
                value={formData.category}
                onValueChange={(val: ProductCategoryValue) => setFormData({ ...formData, category: val })}
              >
                <SelectTrigger className="w-full">
                  <SelectValue placeholder="Select Category" />
                </SelectTrigger>
                <SelectContent>
                  {PRODUCT_CATEGORY_OPTIONS.map(option => (
                    <SelectItem key={option.value} value={option.value}>
                      {option.label}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
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
                disabled={isPending || !formData.name.trim() || !formData.category}
                className="inline-flex items-center gap-2"
              >
                <Save className="h-4 w-4" />
                {isPending ? "Updating..." : "Update Product Group"}
              </Button>
              <Button
                type="button"
                variant="outline"
                onClick={() => router.push("/master/product-groups")}
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