"use client";

import { useState, useEffect, useTransition } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import { Upload, Loader2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { 
  createProduct, 
  getCategories, 
  getBrands, 
  getProductGroups, 
  getProductSubGroups, 
  getManufacturers 
} from "@/app/(protected)/master/products/actions";
import { uploadProductImage } from "@/lib/storage/upload";
import { toast } from "sonner";

const CreateProductSchema = z.object({
  name: z.string().min(1, "Name is required"),
  price: z.number().nonnegative().optional(),
  status: z.enum(["active", "inactive"]),
  category_id: z.string().min(1, "Category is required"),
  brand_id: z.string().min(1, "Brand is required"),
  group_id: z.string().min(1, "Group is required"),
  sub_group_id: z.string().min(1, "Sub-group is required"),
  manufacturer_id: z.string().min(1, "Manufacturer is required"),
});

type FormData = z.infer<typeof CreateProductSchema>;

interface Option {
  id: string;
  name: string;
  category_id?: string;
  group_id?: string;
}

export default function ProductCreateForm() {
  const [categories, setCategories] = useState<Option[]>([]);
  const [brands, setBrands] = useState<Option[]>([]);
  const [groups, setGroups] = useState<Option[]>([]);
  const [subGroups, setSubGroups] = useState<Option[]>([]);
  const [manufacturers, setManufacturers] = useState<Option[]>([]);
  const [selectedImage, setSelectedImage] = useState<File | null>(null);
  const [imagePreview, setImagePreview] = useState<string | null>(null);
  const [isPending, startTransition] = useTransition();

  const form = useForm<FormData>({
    resolver: zodResolver(CreateProductSchema),
    defaultValues: {
      status: "active",
      name: "",
      category_id: "",
      brand_id: "",
      group_id: "",
      sub_group_id: "",
      manufacturer_id: "",
    },
  });

  const watchedCategory = form.watch("category_id");
  const watchedGroup = form.watch("group_id");

  useEffect(() => {
    loadInitialData();
  }, []);

  useEffect(() => {
    if (watchedCategory) {
      loadGroups(watchedCategory);
      // Clear dependent fields
      form.setValue("group_id", "");
      form.setValue("sub_group_id", "");
      setSubGroups([]);
    }
  }, [watchedCategory, form]);

  useEffect(() => {
    if (watchedGroup) {
      loadSubGroups(watchedGroup);
      // Clear dependent field
      form.setValue("sub_group_id", "");
    }
  }, [watchedGroup, form]);

  const loadInitialData = async () => {
    try {
      const [categoriesData, brandsData, manufacturersData] = await Promise.all([
        getCategories(),
        getBrands(),
        getManufacturers(),
      ]);
      
      setCategories(categoriesData);
      setBrands(brandsData);
      setManufacturers(manufacturersData);
    } catch (error) {
      toast.error("Failed to load form data");
    }
  };

  const loadGroups = async (categoryId: string) => {
    try {
      const groupsData = await getProductGroups(categoryId);
      setGroups(groupsData);
    } catch (error) {
      toast.error("Failed to load product groups");
    }
  };

  const loadSubGroups = async (groupId: string) => {
    try {
      const subGroupsData = await getProductSubGroups(groupId);
      setSubGroups(subGroupsData);
    } catch (error) {
      toast.error("Failed to load sub-groups");
    }
  };

  const handleImageChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    if (file) {
      setSelectedImage(file);
      
      // Create preview
      const reader = new FileReader();
      reader.onloadend = () => {
        setImagePreview(reader.result as string);
      };
      reader.readAsDataURL(file);
    }
  };

  const onSubmit = async (data: FormData) => {
    startTransition(async () => {
      try {
        const formData = new FormData();
        Object.entries(data).forEach(([key, value]) => {
          if (value !== undefined) {
            formData.append(key, value.toString());
          }
        });

        const result = await createProduct(formData);
        
        if (result.ok) {
          toast.success("Product created successfully");
          form.reset();
          setSelectedImage(null);
          setImagePreview(null);
          setGroups([]);
          setSubGroups([]);
        } else {
          toast.error(result.message || "Failed to create product");
        }
      } catch (error) {
        toast.error("Failed to create product");
      }
    });
  };

  return (
    <div className="bg-white shadow rounded-lg p-6">
      <h2 className="text-lg font-medium text-gray-900 mb-6">Create New Product</h2>
      
      <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-6">
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          {/* Product Name */}
          <div>
            <label htmlFor="name" className="block text-sm font-medium text-gray-700 mb-2">
              Product Name *
            </label>
            <Input
              id="name"
              {...form.register("name")}
              placeholder="Enter product name"
              className={form.formState.errors.name ? "border-red-500" : ""}
            />
            {form.formState.errors.name && (
              <p className="mt-1 text-sm text-red-600">{form.formState.errors.name.message}</p>
            )}
          </div>

          {/* Price */}
          <div>
            <label htmlFor="price" className="block text-sm font-medium text-gray-700 mb-2">
              Price
            </label>
            <Input
              id="price"
              type="number"
              step="0.01"
              min="0"
              {...form.register("price", { valueAsNumber: true })}
              placeholder="0.00"
              className={form.formState.errors.price ? "border-red-500" : ""}
            />
            {form.formState.errors.price && (
              <p className="mt-1 text-sm text-red-600">{form.formState.errors.price.message}</p>
            )}
          </div>

          {/* Category */}
          <div>
            <label htmlFor="category_id" className="block text-sm font-medium text-gray-700 mb-2">
              Category *
            </label>
            <Select value={form.watch("category_id")} onValueChange={(value) => form.setValue("category_id", value)}>
              <SelectTrigger className={form.formState.errors.category_id ? "border-red-500" : ""}>
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
            {form.formState.errors.category_id && (
              <p className="mt-1 text-sm text-red-600">{form.formState.errors.category_id.message}</p>
            )}
          </div>

          {/* Brand */}
          <div>
            <label htmlFor="brand_id" className="block text-sm font-medium text-gray-700 mb-2">
              Brand *
            </label>
            <Select value={form.watch("brand_id")} onValueChange={(value) => form.setValue("brand_id", value)}>
              <SelectTrigger className={form.formState.errors.brand_id ? "border-red-500" : ""}>
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
            {form.formState.errors.brand_id && (
              <p className="mt-1 text-sm text-red-600">{form.formState.errors.brand_id.message}</p>
            )}
          </div>

          {/* Product Group */}
          <div>
            <label htmlFor="group_id" className="block text-sm font-medium text-gray-700 mb-2">
              Product Group *
            </label>
            <Select 
              value={form.watch("group_id")} 
              onValueChange={(value) => form.setValue("group_id", value)}
              disabled={!watchedCategory}
            >
              <SelectTrigger className={form.formState.errors.group_id ? "border-red-500" : ""}>
                <SelectValue placeholder={watchedCategory ? "Select group" : "Select category first"} />
              </SelectTrigger>
              <SelectContent>
                {groups.map((group) => (
                  <SelectItem key={group.id} value={group.id}>
                    {group.name}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
            {form.formState.errors.group_id && (
              <p className="mt-1 text-sm text-red-600">{form.formState.errors.group_id.message}</p>
            )}
          </div>

          {/* Sub Group */}
          <div>
            <label htmlFor="sub_group_id" className="block text-sm font-medium text-gray-700 mb-2">
              Sub Group *
            </label>
            <Select 
              value={form.watch("sub_group_id")} 
              onValueChange={(value) => form.setValue("sub_group_id", value)}
              disabled={!watchedGroup}
            >
              <SelectTrigger className={form.formState.errors.sub_group_id ? "border-red-500" : ""}>
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
            {form.formState.errors.sub_group_id && (
              <p className="mt-1 text-sm text-red-600">{form.formState.errors.sub_group_id.message}</p>
            )}
          </div>

          {/* Manufacturer */}
          <div>
            <label htmlFor="manufacturer_id" className="block text-sm font-medium text-gray-700 mb-2">
              Manufacturer *
            </label>
            <Select value={form.watch("manufacturer_id")} onValueChange={(value) => form.setValue("manufacturer_id", value)}>
              <SelectTrigger className={form.formState.errors.manufacturer_id ? "border-red-500" : ""}>
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
            {form.formState.errors.manufacturer_id && (
              <p className="mt-1 text-sm text-red-600">{form.formState.errors.manufacturer_id.message}</p>
            )}
          </div>

          {/* Status */}
          <div>
            <label htmlFor="status" className="block text-sm font-medium text-gray-700 mb-2">
              Status
            </label>
            <Select value={form.watch("status")} onValueChange={(value: "active" | "inactive") => form.setValue("status", value)}>
              <SelectTrigger>
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="active">Active</SelectItem>
                <SelectItem value="inactive">Inactive</SelectItem>
              </SelectContent>
            </Select>
          </div>
        </div>

        {/* Image Upload */}
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">
            Product Image
          </label>
          <div className="flex items-center gap-4">
            {imagePreview && (
              <img 
                src={imagePreview} 
                alt="Preview" 
                className="h-20 w-20 object-cover rounded-lg border"
              />
            )}
            <div className="flex-1">
              <label className="cursor-pointer">
                <div className="border-2 border-dashed border-gray-300 rounded-lg p-4 text-center hover:border-gray-400 transition-colors">
                  <Upload className="mx-auto h-6 w-6 text-gray-400 mb-2" />
                  <span className="text-sm text-gray-600">
                    {selectedImage ? selectedImage.name : "Click to upload image"}
                  </span>
                </div>
                <input
                  type="file"
                  accept="image/*"
                  onChange={handleImageChange}
                  className="hidden"
                />
              </label>
            </div>
          </div>
        </div>

        {/* Submit Button */}
        <div className="flex justify-end gap-3">
          <Button
            type="button"
            variant="outline"
            onClick={() => {
              form.reset();
              setSelectedImage(null);
              setImagePreview(null);
              setGroups([]);
              setSubGroups([]);
            }}
            disabled={isPending}
          >
            Reset
          </Button>
          <Button type="submit" disabled={isPending}>
            {isPending && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
            Create Product
          </Button>
        </div>
      </form>
    </div>
  );
}