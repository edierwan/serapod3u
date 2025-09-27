// Product creation form component with hierarchical data selection
"use client";

// Product creation form with hierarchical data selection
import { useState, useEffect } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Loader2, Package, ArrowLeft } from "lucide-react";
import {
  getCategories,
  getBrands,
  getProductGroups,
  getProductSubGroups,
  getManufacturers,
  createProduct,
} from "../../app/(protected)/master/products/actions";
import type { Category, BrandWithCategory, ProductGroupWithCategory, ProductSubGroupWithGroup, Manufacturer } from "@/lib/types/master";

const productSchema = z.object({
  name: z.string().min(1, "Product name is required"),
  category_id: z.string().min(1, "Category is required"),
  brand_id: z.string().min(1, "Brand is required"),
  group_id: z.string().min(1, "Group is required"),
  sub_group_id: z.string().min(1, "Sub-group is required"),
  manufacturer_id: z.string().min(1, "Manufacturer is required"),
  price: z.string().optional(),
  status: z.enum(["active", "inactive"]),
});

type ProductFormData = z.infer<typeof productSchema>;

interface ProductCreateFormProps {
  onSuccess?: () => void;
  onCancel?: () => void;
}

export function ProductCreateForm({ onSuccess, onCancel }: ProductCreateFormProps) {
  const [loading, setLoading] = useState(false);
  const [categories, setCategories] = useState<Category[]>([]);
  const [brands, setBrands] = useState<BrandWithCategory[]>([]);
  const [groups, setGroups] = useState<ProductGroupWithCategory[]>([]);
  const [subGroups, setSubGroups] = useState<ProductSubGroupWithGroup[]>([]);
  const [manufacturers, setManufacturers] = useState<Manufacturer[]>([]);
  const [selectedCategory, setSelectedCategory] = useState<string>("");
  const [selectedBrand, setSelectedBrand] = useState<string>("");
  const [selectedGroup, setSelectedGroup] = useState<string>("");

  const {
    register,
    handleSubmit,
    setValue,
    watch,
    formState: { errors },
  } = useForm<ProductFormData>({
    resolver: zodResolver(productSchema),
    defaultValues: {
      status: "active",
    },
  });

  const watchedCategory = watch("category_id");
  const watchedBrand = watch("brand_id");
  const watchedGroup = watch("group_id");

  useEffect(() => {
    loadInitialData();
  }, []);

  useEffect(() => {
    if (watchedCategory && watchedCategory !== selectedCategory) {
      setSelectedCategory(watchedCategory);
      loadBrands(watchedCategory);
      // Reset dependent fields
      setValue("brand_id", "");
      setValue("group_id", "");
      setValue("sub_group_id", "");
      setBrands([]);
      setGroups([]);
      setSubGroups([]);
    }
  }, [watchedCategory, selectedCategory, setValue]);

  useEffect(() => {
    if (watchedBrand && watchedBrand !== selectedBrand) {
      setSelectedBrand(watchedBrand);
      loadGroups(watchedBrand);
      // Reset dependent fields
      setValue("group_id", "");
      setValue("sub_group_id", "");
      setGroups([]);
      setSubGroups([]);
    }
  }, [watchedBrand, selectedBrand, setValue]);

  useEffect(() => {
    if (watchedGroup && watchedGroup !== selectedGroup) {
      setSelectedGroup(watchedGroup);
      loadSubGroups(watchedGroup);
      // Reset dependent field
      setValue("sub_group_id", "");
      setSubGroups([]);
    }
  }, [watchedGroup, selectedGroup, setValue]);

  const loadInitialData = async () => {
    try {
      const [categoriesData, manufacturersData] = await Promise.all([
        getCategories(),
        getManufacturers(),
      ]);
      setCategories(categoriesData);
      setManufacturers(manufacturersData);
    } catch (error) {
      console.error("Failed to load initial data:", error);
    }
  };

  const loadBrands = async (categoryId: string) => {
    try {
      const brandsData = await getBrands(categoryId);
      // Transform the data to match the expected interface
      const transformedData = brandsData.map(brand => ({
        ...brand,
        category: Array.isArray(brand.category) ? brand.category[0] : brand.category,
      }));
      setBrands(transformedData);
    } catch (error) {
      console.error("Failed to load brands:", error);
    }
  };

  const loadGroups = async (brandId: string) => {
    try {
      const groupsData = await getProductGroups(brandId);
      setGroups(groupsData);
    } catch (error) {
      console.error("Failed to load groups:", error);
    }
  };

  const loadSubGroups = async (groupId: string) => {
    try {
      const subGroupsData = await getProductSubGroups(groupId);
      // Transform the data to match the expected interface
      const transformedData = subGroupsData.map(subGroup => ({
        ...subGroup,
        group: Array.isArray(subGroup.group) ? subGroup.group[0] : subGroup.group,
      }));
      setSubGroups(transformedData);
    } catch (error) {
      console.error("Failed to load sub-groups:", error);
    }
  };

  const onSubmit = async (data: ProductFormData) => {
    try {
      setLoading(true);
      const formData = new FormData();
      Object.entries(data).forEach(([key, value]) => {
        if (value !== undefined && value !== null) {
          formData.append(key, value.toString());
        }
      });

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
              <Label htmlFor="status">Status</Label>
              <Select onValueChange={(value) => setValue("status", value as "active" | "inactive")}>
                <SelectTrigger>
                  <SelectValue placeholder="Select status" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="active">
                    <Badge variant="default">Active</Badge>
                  </SelectItem>
                  <SelectItem value="inactive">
                    <Badge variant="secondary">Inactive</Badge>
                  </SelectItem>
                </SelectContent>
              </Select>
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
                <Select
                  onValueChange={(value) => setValue("brand_id", value)}
                  disabled={!watchedCategory}
                >
                  <SelectTrigger>
                    <SelectValue placeholder={watchedCategory ? "Select brand" : "Select category first"} />
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
                  disabled={!watchedBrand}
                >
                  <SelectTrigger>
                    <SelectValue placeholder={watchedBrand ? "Select group" : "Select brand first"} />
                  </SelectTrigger>
                  <SelectContent>
                    {groups.map((group) => (
                      <SelectItem key={group.id} value={group.id}>
                        {group.name}
                      </SelectItem>
                    ))}
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
                    <SelectValue placeholder={watchedGroup ? "Select sub-group" : "Select group first"} />
                  </SelectTrigger>
                  <SelectContent>
                    {subGroups.map((subGroup) => (
                      <SelectItem key={subGroup.id} value={subGroup.id}>
                        {subGroup.name}
                      </SelectItem>
                    ))}
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
          <Button type="submit" disabled={loading}>
            {loading && <Loader2 className="h-4 w-4 mr-2 animate-spin" />}
            Create Product
          </Button>
        </div>
      </form>
    </div>
  );
}