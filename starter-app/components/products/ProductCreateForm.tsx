"use client";

import { useState, useEffect, useTransition } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import { Upload, Loader2, Plus } from "lucide-react";
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
    } catch {
      toast.error("Failed to load form data");
    }
  };

  const loadGroups = async (categoryId: string) => {
    try {
      const groupsData = await getProductGroups(categoryId);
      setGroups(groupsData);
    } catch {
      toast.error("Failed to load product groups");
    }
  };

  const loadSubGroups = async (groupId: string) => {
    try {
      const subGroupsData = await getProductSubGroups(groupId);
      setSubGroups(subGroupsData);
    } catch {
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
      } catch {
        toast.error("Failed to create product");
      }
    });
  };

  return (
    <div className="bg-gradient-to-br from-white via-blue-50/30 to-indigo-50/20 border-0 shadow-xl shadow-blue-500/5 rounded-lg">
      <div className="p-6 pb-4">
        <h2 className="text-xl font-bold text-slate-800 flex items-center gap-3 mb-6">
          <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-blue-500 to-indigo-600 flex items-center justify-center shadow-lg">
            <Plus className="h-5 w-5 text-white" />
          </div>
          Create New Product
        </h2>
      </div>

      <div className="px-6 pb-6">
        <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-6">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            {/* Product Name */}
            <div>
              <label htmlFor="name" className="block text-sm font-semibold text-slate-700 mb-2">
                Product Name *
              </label>
              <Input
                id="name"
                {...form.register("name")}
                placeholder="Enter product name"
                className={`bg-white/80 backdrop-blur-sm border-slate-200 focus:border-blue-400 focus:ring-blue-400/20 transition-colors ${
                  form.formState.errors.name ? "border-red-400 focus:border-red-400 focus:ring-red-400/20" : ""
                }`}
              />
              {form.formState.errors.name && (
                <p className="mt-1 text-sm text-red-600 font-medium">{form.formState.errors.name.message}</p>
              )}
            </div>

            {/* Price */}
            <div>
              <label htmlFor="price" className="block text-sm font-semibold text-slate-700 mb-2">
                Price
              </label>
              <Input
                id="price"
                type="number"
                step="0.01"
                min="0"
                {...form.register("price", { valueAsNumber: true })}
                placeholder="0.00"
                className={`bg-white/80 backdrop-blur-sm border-slate-200 focus:border-blue-400 focus:ring-blue-400/20 transition-colors ${
                  form.formState.errors.price ? "border-red-400 focus:border-red-400 focus:ring-red-400/20" : ""
                }`}
              />
              {form.formState.errors.price && (
                <p className="mt-1 text-sm text-red-600 font-medium">{form.formState.errors.price.message}</p>
              )}
            </div>

            {/* Category */}
            <div>
              <label htmlFor="category_id" className="block text-sm font-semibold text-slate-700 mb-2">
                Category *
              </label>
              <Select value={form.watch("category_id")} onValueChange={(value) => form.setValue("category_id", value)}>
                <SelectTrigger className={`bg-white/80 backdrop-blur-sm border-slate-200 focus:border-blue-400 focus:ring-blue-400/20 transition-colors ${
                  form.formState.errors.category_id ? "border-red-400 focus:border-red-400 focus:ring-red-400/20" : ""
                }`}>
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
                <p className="mt-1 text-sm text-red-600 font-medium">{form.formState.errors.category_id.message}</p>
              )}
            </div>

            {/* Brand */}
            <div>
              <label htmlFor="brand_id" className="block text-sm font-semibold text-slate-700 mb-2">
                Brand *
              </label>
              <Select value={form.watch("brand_id")} onValueChange={(value) => form.setValue("brand_id", value)}>
                <SelectTrigger className={`bg-white/80 backdrop-blur-sm border-slate-200 focus:border-blue-400 focus:ring-blue-400/20 transition-colors ${
                  form.formState.errors.brand_id ? "border-red-400 focus:border-red-400 focus:ring-red-400/20" : ""
                }`}>
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
                <p className="mt-1 text-sm text-red-600 font-medium">{form.formState.errors.brand_id.message}</p>
              )}
            </div>

            {/* Product Group */}
            <div>
              <label htmlFor="group_id" className="block text-sm font-semibold text-slate-700 mb-2">
                Product Group *
              </label>
              <Select
                value={form.watch("group_id")}
                onValueChange={(value) => form.setValue("group_id", value)}
                disabled={!watchedCategory}
              >
                <SelectTrigger className={`bg-white/80 backdrop-blur-sm border-slate-200 focus:border-blue-400 focus:ring-blue-400/20 transition-colors ${
                  form.formState.errors.group_id ? "border-red-400 focus:border-red-400 focus:ring-red-400/20" : ""
                }`}>
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
                <p className="mt-1 text-sm text-red-600 font-medium">{form.formState.errors.group_id.message}</p>
              )}
            </div>

            {/* Sub Group */}
            <div>
              <label htmlFor="sub_group_id" className="block text-sm font-semibold text-slate-700 mb-2">
                Sub Group *
              </label>
              <Select
                value={form.watch("sub_group_id")}
                onValueChange={(value) => form.setValue("sub_group_id", value)}
                disabled={!watchedGroup}
              >
                <SelectTrigger className={`bg-white/80 backdrop-blur-sm border-slate-200 focus:border-blue-400 focus:ring-blue-400/20 transition-colors ${
                  form.formState.errors.sub_group_id ? "border-red-400 focus:border-red-400 focus:ring-red-400/20" : ""
                }`}>
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
                <p className="mt-1 text-sm text-red-600 font-medium">{form.formState.errors.sub_group_id.message}</p>
              )}
            </div>

            {/* Manufacturer */}
            <div>
              <label htmlFor="manufacturer_id" className="block text-sm font-semibold text-slate-700 mb-2">
                Manufacturer *
              </label>
              <Select value={form.watch("manufacturer_id")} onValueChange={(value) => form.setValue("manufacturer_id", value)}>
                <SelectTrigger className={`bg-white/80 backdrop-blur-sm border-slate-200 focus:border-blue-400 focus:ring-blue-400/20 transition-colors ${
                  form.formState.errors.manufacturer_id ? "border-red-400 focus:border-red-400 focus:ring-red-400/20" : ""
                }`}>
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
                <p className="mt-1 text-sm text-red-600 font-medium">{form.formState.errors.manufacturer_id.message}</p>
              )}
            </div>

            {/* Status */}
            <div>
              <label htmlFor="status" className="block text-sm font-semibold text-slate-700 mb-2">
                Status
              </label>
              <Select value={form.watch("status")} onValueChange={(value: "active" | "inactive") => form.setValue("status", value)}>
                <SelectTrigger className="bg-white/80 backdrop-blur-sm border-slate-200 focus:border-blue-400 focus:ring-blue-400/20 transition-colors">
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
            <label className="block text-sm font-semibold text-slate-700 mb-2">
              Product Image
            </label>
            <div className="flex items-center gap-4">
              {imagePreview && (
                <img
                  src={imagePreview}
                  alt="Preview"
                  className="h-20 w-20 object-cover rounded-lg border-2 border-slate-200 shadow-md"
                />
              )}
              <div className="flex-1">
                <label className="cursor-pointer">
                  <div className="border-2 border-dashed border-slate-300 rounded-lg p-6 text-center hover:border-blue-400 hover:bg-blue-50/50 transition-colors bg-white/60 backdrop-blur-sm">
                    <Upload className="mx-auto h-8 w-8 text-slate-400 mb-2" />
                    <span className="text-sm text-slate-600 font-medium">
                      {selectedImage ? selectedImage.name : "Click to upload image"}
                    </span>
                    <p className="text-xs text-slate-500 mt-1">PNG, JPG up to 2MB</p>
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
          <div className="flex justify-end gap-3 pt-4 border-t border-slate-200/60">
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
              className="bg-white hover:bg-slate-50 border-slate-200 hover:border-slate-300 transition-colors shadow-sm"
            >
              Reset
            </Button>
            <Button
              type="submit"
              variant="outline"
              disabled={isPending}
              className="bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-700 hover:to-indigo-700 text-white shadow-lg shadow-blue-500/25 hover:shadow-xl hover:shadow-blue-500/30 transition-all duration-200"
            >
              {isPending && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
              Create Product
            </Button>
          </div>
        </form>
      </div>
    </div>
  );
}