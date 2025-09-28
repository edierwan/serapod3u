// Product creation form with hierarchical data selection
"use client";

// Product creation form with hierarchical data selection
import { useState, useEffect, useCallback } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import Image from "next/image";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { StatusToggle } from "@/components/ui/status-toggle";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Loader2, Package, ArrowLeft, AlertCircle } from "lucide-react";
import {
  getCategories,
  getBrands,
  getManufacturers,
  createProduct,
} from "../../app/(protected)/master/products/actions";
import type { Category, BrandWithCategory, Manufacturer } from "@/lib/types/master";

const productSchema = z.object({
  name: z.string().min(1, "Product name is required"),
  category_id: z.string().min(1, "Category is required"),
  brand_id: z.string().min(1, "Brand is required"),
  group_id: z.string().min(1, "Group is required"),
  sub_group_id: z.string().min(1, "Sub-group is required"),
  manufacturer_id: z.string().min(1, "Manufacturer is required"),
  price: z.string().optional(),
  is_active: z.boolean(),
  image: z.instanceof(File).optional(),
});

type ProductFormData = z.infer<typeof productSchema>;

interface GroupOption {
  id: string;
  name: string;
}

interface SubGroupOption {
  id: string;
  name: string;
}

interface ProductCreateFormProps {
  onSuccess?: () => void;
  onCancel?: () => void;
}

export function ProductCreateForm({ onSuccess, onCancel }: ProductCreateFormProps) {
  const [loading, setLoading] = useState(false);
  const [categories, setCategories] = useState<Category[]>([]);
  const [brands, setBrands] = useState<BrandWithCategory[]>([]);
  const [manufacturers, setManufacturers] = useState<Manufacturer[]>([]);

  // Cascading selects state
  const [groups, setGroups] = useState<GroupOption[]>([]);
  const [subGroups, setSubGroups] = useState<SubGroupOption[]>([]);
  const [groupsLoading, setGroupsLoading] = useState(false);
  const [subGroupsLoading, setSubGroupsLoading] = useState(false);
  const [groupsError, setGroupsError] = useState<string | null>(null);
  const [subGroupsError, setSubGroupsError] = useState<string | null>(null);

  const [selectedImage, setSelectedImage] = useState<File | null>(null);
  const [imagePreview, setImagePreview] = useState<string | null>(null);

  const {
    register,
    handleSubmit,
    setValue,
    watch,
    formState: { errors },
  } = useForm<ProductFormData>({
    resolver: zodResolver(productSchema),
    defaultValues: {
      is_active: true,
    },
  });

  const watchedCategory = watch("category_id");
  const watchedGroup = watch("group_id");

  // Fetch groups when category changes
  const fetchGroups = useCallback(async (categoryId: string) => {
    if (!categoryId) return;

    setGroupsLoading(true);
    setGroupsError(null);

    try {
      const response = await fetch(`/api/master/groups?category_id=${categoryId}&active=1`);
      const result = await response.json();

      if (!result.ok) {
        throw new Error(result.message || "Failed to fetch groups");
      }

      setGroups(result.data);
    } catch (error) {
      console.error("fetchGroups error:", { categoryId, error });
      setGroupsError(error instanceof Error ? error.message : "Failed to fetch groups");
      setGroups([]);
    } finally {
      setGroupsLoading(false);
    }
  }, []);

  // Fetch sub-groups when group changes
  const fetchSubGroups = useCallback(async (groupId: string) => {
    if (!groupId) return;

    setSubGroupsLoading(true);
    setSubGroupsError(null);

    try {
      const response = await fetch(`/api/master/sub-groups?group_id=${groupId}&active=1`);
      const result = await response.json();

      if (!result.ok) {
        throw new Error(result.message || "Failed to fetch sub-groups");
      }

      setSubGroups(result.data);
    } catch (error) {
      console.error("fetchSubGroups error:", { groupId, error });
      setSubGroupsError(error instanceof Error ? error.message : "Failed to fetch sub-groups");
      setSubGroups([]);
    } finally {
      setSubGroupsLoading(false);
    }
  }, []);

  useEffect(() => {
    loadInitialData();
  }, []);

  // Category change effect
  useEffect(() => {
    if (watchedCategory) {
      // Reset dependent fields
      setValue("group_id", "");
      setValue("sub_group_id", "");
      setGroups([]);
      setSubGroups([]);
      setGroupsError(null);
      setSubGroupsError(null);

      // Fetch groups for the selected category
      fetchGroups(watchedCategory);
    } else {
      // Clear everything if no category selected
      setGroups([]);
      setSubGroups([]);
      setGroupsError(null);
      setSubGroupsError(null);
    }
  }, [watchedCategory, setValue, fetchGroups]);

  // Group change effect
  useEffect(() => {
    if (watchedGroup) {
      // Reset dependent field
      setValue("sub_group_id", "");
      setSubGroups([]);
      setSubGroupsError(null);

      // Fetch sub-groups for the selected group
      fetchSubGroups(watchedGroup);
    } else {
      // Clear sub-groups if no group selected
      setSubGroups([]);
      setSubGroupsError(null);
    }
  }, [watchedGroup, setValue, fetchSubGroups]);

  const loadInitialData = async () => {
    try {
      const [categoriesData, brandsData, manufacturersData] = await Promise.all([
        getCategories(),
        getBrands(),
        getManufacturers(),
      ]);
      setCategories(categoriesData);
      // Transform brands data to match expected interface
      const transformedBrands = brandsData.map(brand => ({
        ...brand,
        category: Array.isArray(brand.category) ? brand.category[0] : brand.category,
      }));
      setBrands(transformedBrands);
      setManufacturers(manufacturersData);
    } catch (error) {
      console.error("Failed to load initial data:", error);
    }
  };

  const onSubmit = async (data: ProductFormData) => {
    try {
      setLoading(true);
      const formData = new FormData();

      // Add all form fields except image
      Object.entries(data).forEach(([key, value]) => {
        if (key !== "image" && value !== undefined && value !== null) {
          formData.append(key, value.toString());
        }
      });

      // Handle image upload separately if provided
      if (data.image) {
        formData.append("image", data.image);
      }

      const result = await createProduct(formData);
      if (result.ok) {
        onSuccess?.();
      } else {
        alert(result.message || "Failed to create product");
      }
    } catch (error) {
      console.error("Create product error:", error);
      alert("Failed to create product");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center space-x-4">
        <Button variant="ghost" onClick={onCancel}>
          <ArrowLeft className="h-4 w-4 mr-2" />
          Back
        </Button>
        <div>
          <h2 className="text-xl font-semibold">Create New Product</h2>
          <p className="text-sm text-gray-500">Fill in the details to create a new product</p>
        </div>
      </div>

      <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
        {/* Image Upload Section - At the top like Manufacturer */}
        <Card>
          <CardContent className="p-6">
            <div className="flex items-center gap-4">
              <div className="relative h-16 w-16 overflow-hidden rounded-lg border">
                {imagePreview ? (
                  <Image src={imagePreview} alt="Product preview" fill sizes="64px" className="object-cover" />
                ) : (
                  <div className="h-full w-full bg-gray-200 flex items-center justify-center text-gray-500 text-sm">
                    Image
                  </div>
                )}
              </div>
              <div className="flex-1">
                <Label className="block text-sm font-medium mb-2">Image</Label>
                <Input
                  type="file"
                  accept="image/*"
                  onChange={(e) => {
                    const file = e.target.files?.[0];
                    if (file) {
                      // Validate file size (2MB max)
                      if (file.size > 2 * 1024 * 1024) {
                        alert("File size must be less than 2MB");
                        return;
                      }
                      // Validate file type
                      if (!file.type.startsWith('image/') || !['image/jpeg', 'image/jpg', 'image/png', 'image/webp'].includes(file.type)) {
                        alert("Please upload a valid image file (JPG, PNG, or WebP)");
                        return;
                      }
                      setSelectedImage(file);
                      setValue("image", file);
                      const reader = new FileReader();
                      reader.onload = (e) => {
                        setImagePreview(e.target?.result as string);
                      };
                      reader.readAsDataURL(file);
                    }
                  }}
                  className="w-full"
                />
                <p className="text-xs text-muted-foreground mt-1">
                  Upload an image (max 2MB)
                </p>
                {selectedImage && (
                  <div className="flex items-center gap-2 mt-2">
                    <span className="text-sm text-gray-600">{selectedImage.name}</span>
                    <Button
                      type="button"
                      variant="outline"
                      size="sm"
                      onClick={() => {
                        setSelectedImage(null);
                        setImagePreview(null);
                        setValue("image", undefined);
                      }}
                    >
                      Remove
                    </Button>
                  </div>
                )}
              </div>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle className="flex items-center">
              <Package className="h-5 w-5 mr-2" />
              Product Information
            </CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="name">Product Name *</Label>
                <Input
                  id="name"
                  {...register("name")}
                  placeholder="Enter product name"
                />
                {errors.name && (
                  <p className="text-sm text-red-600">{errors.name.message}</p>
                )}
              </div>

              <div className="space-y-2">
                <Label htmlFor="price">Price</Label>
                <Input
                  id="price"
                  type="number"
                  step="0.01"
                  {...register("price")}
                  placeholder="0.00"
                />
                {errors.price && (
                  <p className="text-sm text-red-600">{errors.price.message}</p>
                )}
              </div>
            </div>

            <div className="space-y-2">
              <Label>Active Status</Label>
              <StatusToggle
                id="is_active"
                checked={watch("is_active")}
                onCheckedChange={(checked) => setValue("is_active", checked)}
                disabled={loading}
              />
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Hierarchy Selection</CardTitle>
            <p className="text-sm text-gray-500">
              Select the hierarchical structure for this product
            </p>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="category_id">Category *</Label>
                <Select onValueChange={(value) => setValue("category_id", value)}>
                  <SelectTrigger>
                    <SelectValue placeholder="Select category" />
                  </SelectTrigger>
                  <SelectContent>
                    {categories.map((category) => (
                      <SelectItem key={category.id} value={category.id}>
                        {category.name}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
                {errors.category_id && (
                  <p className="text-sm text-red-600">{errors.category_id.message}</p>
                )}
              </div>

              <div className="space-y-2">
                <Label htmlFor="brand_id">Brand *</Label>
                <Select onValueChange={(value) => setValue("brand_id", value)}>
                  <SelectTrigger>
                    <SelectValue placeholder="Select brand" />
                  </SelectTrigger>
                  <SelectContent>
                    {brands.map((brand) => (
                      <SelectItem key={brand.id} value={brand.id}>
                        {brand.name}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
                {errors.brand_id && (
                  <p className="text-sm text-red-600">{errors.brand_id.message}</p>
                )}
              </div>

              <div className="space-y-2">
                <Label htmlFor="group_id">Group *</Label>
                <Select
                  onValueChange={(value) => setValue("group_id", value)}
                  disabled={!watchedCategory}
                >
                  <SelectTrigger>
                    <SelectValue placeholder={
                      !watchedCategory
                        ? "Select category first"
                        : groupsLoading
                        ? "Loading groups..."
                        : groupsError
                        ? "Error loading groups"
                        : groups.length === 0
                        ? "No groups in this category"
                        : "Select group"
                    } />
                  </SelectTrigger>
                  <SelectContent>
                    {groupsLoading ? (
                      <div className="flex items-center justify-center p-4">
                        <Loader2 className="h-4 w-4 animate-spin mr-2" />
                        Loading...
                      </div>
                    ) : groupsError ? (
                      <div className="flex items-center justify-center p-4 text-red-600">
                        <AlertCircle className="h-4 w-4 mr-2" />
                        {groupsError}
                      </div>
                    ) : groups.length === 0 ? (
                      <div className="flex items-center justify-center p-4 text-gray-500">
                        No groups in this category
                      </div>
                    ) : (
                      groups.map((group) => (
                        <SelectItem key={group.id} value={group.id}>
                          {group.name}
                        </SelectItem>
                      ))
                    )}
                  </SelectContent>
                </Select>
                {errors.group_id && (
                  <p className="text-sm text-red-600">{errors.group_id.message}</p>
                )}
              </div>

              <div className="space-y-2">
                <Label htmlFor="sub_group_id">Sub-Group *</Label>
                <Select
                  onValueChange={(value) => setValue("sub_group_id", value)}
                  disabled={!watchedGroup}
                >
                  <SelectTrigger>
                    <SelectValue placeholder={
                      !watchedGroup
                        ? "Select group first"
                        : subGroupsLoading
                        ? "Loading sub-groups..."
                        : subGroupsError
                        ? "Error loading sub-groups"
                        : subGroups.length === 0
                        ? "No sub-groups under this group"
                        : "Select sub-group"
                    } />
                  </SelectTrigger>
                  <SelectContent>
                    {subGroupsLoading ? (
                      <div className="flex items-center justify-center p-4">
                        <Loader2 className="h-4 w-4 animate-spin mr-2" />
                        Loading...
                      </div>
                    ) : subGroupsError ? (
                      <div className="flex items-center justify-center p-4 text-red-600">
                        <AlertCircle className="h-4 w-4 mr-2" />
                        {subGroupsError}
                      </div>
                    ) : subGroups.length === 0 ? (
                      <div className="flex items-center justify-center p-4 text-gray-500">
                        No sub-groups under this group
                      </div>
                    ) : (
                      subGroups.map((subGroup) => (
                        <SelectItem key={subGroup.id} value={subGroup.id}>
                          {subGroup.name}
                        </SelectItem>
                      ))
                    )}
                  </SelectContent>
                </Select>
                {errors.sub_group_id && (
                  <p className="text-sm text-red-600">{errors.sub_group_id.message}</p>
                )}
              </div>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Manufacturer</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-2">
              <Label htmlFor="manufacturer_id">Manufacturer *</Label>
              <Select onValueChange={(value) => setValue("manufacturer_id", value)}>
                <SelectTrigger>
                  <SelectValue placeholder="Select manufacturer" />
                </SelectTrigger>
                <SelectContent>
                  {manufacturers.map((manufacturer) => (
                    <SelectItem key={manufacturer.id} value={manufacturer.id}>
                      {manufacturer.name}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
              {errors.manufacturer_id && (
                <p className="text-sm text-red-600">{errors.manufacturer_id.message}</p>
              )}
            </div>
          </CardContent>
        </Card>

        <div className="flex justify-end space-x-4">
          <Button type="button" variant="outline" onClick={onCancel}>
            Cancel
          </Button>
          <Button
            type="submit"
            disabled={
              loading ||
              !watch("category_id") ||
              !watch("brand_id") ||
              !watch("group_id") ||
              !watch("sub_group_id") ||
              !watch("manufacturer_id") ||
              !watch("name")
            }
            variant="primary"
          >
            {loading && <Loader2 className="h-4 w-4 mr-2 animate-spin" />}
            Create Product
          </Button>
        </div>
      </form>
    </div>
  );
}