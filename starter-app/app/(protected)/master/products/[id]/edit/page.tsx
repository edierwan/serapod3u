"use client";

import { useState, useEffect, useCallback, useRef, useMemo } from "react";
import { useForm, useWatch } from "react-hook-form";
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
import { useRouter } from "next/navigation";
import { useParams } from "next/navigation";
import {
  getCategories,
  getBrands,
  getManufacturers,
  updateProduct,
  checkActiveCollision,
  getActiveCombosForManufacturer,
} from "../../actions";
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

interface ActiveHierarchyCombo {
  category_id: string;
  brand_id: string;
  group_id: string;
  sub_group_id: string;
  product_id: string;
  product_name: string;
}

export default function ProductEditPage() {
  const router = useRouter();
  const params = useParams();
  const productId = params.id as string;

  const [loading, setLoading] = useState(false);
  const [initialLoading, setInitialLoading] = useState(true);
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

  const [activeCombos, setActiveCombos] = useState<ActiveHierarchyCombo[]>([]);
  const [activeCombosLoading, setActiveCombosLoading] = useState(false);
  const [activeCombosError, setActiveCombosError] = useState<string | null>(null);

  const [selectedImage, setSelectedImage] = useState<File | null>(null);
  const [imagePreview, setImagePreview] = useState<string | null>(null);

  // Collision detection state
  const [collisionCheck, setCollisionCheck] = useState<{
    conflict: boolean;
    product?: { id: string; name: string };
    loading: boolean;
  }>({ conflict: false, loading: false });
  const collisionTimeoutRef = useRef<NodeJS.Timeout | null>(null);

  // Original product data for comparison
  const [originalProduct, setOriginalProduct] = useState<{
    manufacturer_id: string;
    category_id: string;
    brand_id: string;
    group_id: string;
    sub_group_id: string;
    is_active: boolean;
  } | null>(null);

  const {
    register,
    handleSubmit,
    setValue,
    watch,
    control,
    getValues,
    formState: { errors },
  } = useForm<ProductFormData>({
    resolver: zodResolver(productSchema),
  });

  // Watch collision check fields
  const watchedManufacturerId = useWatch({ control, name: "manufacturer_id" });
  const watchedCategoryId = useWatch({ control, name: "category_id" });
  const watchedBrandId = useWatch({ control, name: "brand_id" });
  const watchedGroupId = useWatch({ control, name: "group_id" });
  const watchedSubGroupId = useWatch({ control, name: "sub_group_id" });
  const watchedIsActive = useWatch({ control, name: "is_active" });
  const watchedName = useWatch({ control, name: "name" });

  const previousManufacturerRef = useRef<string | undefined>();
  const previousCategoryRef = useRef<string | undefined>();
  const previousGroupRef = useRef<string | undefined>();

  const restrictHierarchyForActive = watchedIsActive ?? true;

  const normalizedCombos = useMemo(() => {
    if (!productId) {
      return activeCombos;
    }
    return activeCombos.filter(combo => combo.product_id !== productId);
  }, [activeCombos, productId]);

  const combosForCategory = useMemo(() => {
    if (!watchedCategoryId) {
      return normalizedCombos;
    }
    return normalizedCombos.filter(combo => combo.category_id === watchedCategoryId);
  }, [normalizedCombos, watchedCategoryId]);

  const brandConflictMap = useMemo(() => {
    const map = new Map<string, ActiveHierarchyCombo>();
    if (!watchedCategoryId) {
      return map;
    }

    combosForCategory.forEach(combo => {
      if (combo.brand_id && !map.has(combo.brand_id)) {
        map.set(combo.brand_id, combo);
      }
    });

    return map;
  }, [combosForCategory, watchedCategoryId]);

  const groupConflictMap = useMemo(() => {
    const map = new Map<string, ActiveHierarchyCombo>();
    if (!watchedCategoryId || !watchedBrandId) {
      return map;
    }

    combosForCategory.forEach(combo => {
      if (combo.brand_id === watchedBrandId && combo.group_id && !map.has(combo.group_id)) {
        map.set(combo.group_id, combo);
      }
    });

    return map;
  }, [combosForCategory, watchedBrandId, watchedCategoryId]);

  const subGroupConflictMap = useMemo(() => {
    const map = new Map<string, ActiveHierarchyCombo>();
    if (!watchedCategoryId || !watchedBrandId || !watchedGroupId) {
      return map;
    }

    combosForCategory.forEach(combo => {
      if (
        combo.brand_id === watchedBrandId &&
        combo.group_id === watchedGroupId &&
        combo.sub_group_id &&
        !map.has(combo.sub_group_id)
      ) {
        map.set(combo.sub_group_id, combo);
      }
    });

    return map;
  }, [combosForCategory, watchedBrandId, watchedCategoryId, watchedGroupId]);

  const filteredBrands = useMemo(() => {
    if (!watchedCategoryId) {
      return brands;
    }
    return brands.filter(brand => brand.category?.id === watchedCategoryId);
  }, [brands, watchedCategoryId]);

  const combosReady = restrictHierarchyForActive && watchedManufacturerId && !activeCombosLoading;

  const brandOptionsBlocked =
    combosReady &&
    filteredBrands.length > 0 &&
    filteredBrands.every(brand => brandConflictMap.has(brand.id));

  const groupOptionsBlocked =
    combosReady &&
    watchedBrandId &&
    groups.length > 0 &&
    groups.every(group => groupConflictMap.has(group.id));

  const subGroupOptionsBlocked =
    combosReady &&
    watchedBrandId &&
    watchedGroupId &&
    subGroups.length > 0 &&
    subGroups.every(subGroup => subGroupConflictMap.has(subGroup.id));

  const hierarchyBlocked = brandOptionsBlocked || groupOptionsBlocked || subGroupOptionsBlocked;

  const isComboLoadingForCurrent =
    restrictHierarchyForActive && Boolean(watchedManufacturerId) && activeCombosLoading;
  const comboFetchErrorForCurrent =
    restrictHierarchyForActive && watchedManufacturerId ? activeCombosError : null;

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

  const debouncedCheckCollision = useCallback((payload: {
    manufacturer_id: string;
    category_id: string;
    brand_id: string;
    group_id: string;
    sub_group_id: string;
    is_active: boolean;
  }) => {
    if (!payload.is_active) {
      setCollisionCheck(prev => {
        if (!prev.conflict && !prev.loading) {
          return prev;
        }
        return { conflict: false, loading: false };
      });
      return;
    }

    if (collisionTimeoutRef.current) {
      clearTimeout(collisionTimeoutRef.current);
    }

    collisionTimeoutRef.current = setTimeout(async () => {
      setCollisionCheck(prev => (prev.loading ? prev : { ...prev, loading: true }));

      try {
        const result = await checkActiveCollision({
          ...payload,
          exclude_product_id: productId,
        });

        setCollisionCheck(prev => {
          const sameConflict = prev.conflict === result.conflict;
          const prevProductId = prev.product?.id;
          const nextProductId = result.product?.id;
          const sameProduct = prevProductId === nextProductId;

          if (sameConflict && sameProduct) {
            if (prev.loading) {
              return { ...prev, loading: false };
            }
            return prev;
          }

          return {
            conflict: result.conflict,
            product: result.product,
            loading: false,
          };
        });
      } catch (error) {
        console.error("Collision check error:", error);
        setCollisionCheck({ conflict: false, loading: false });
      } finally {
        collisionTimeoutRef.current = null;
      }
    }, 250);
  }, [productId]);

  useEffect(() => {
    return () => {
      if (collisionTimeoutRef.current) {
        clearTimeout(collisionTimeoutRef.current);
      }
    };
  }, []);

  useEffect(() => {
    if (initialLoading) {
      previousCategoryRef.current = watchedCategoryId || undefined;
      return;
    }

    const previous = previousCategoryRef.current;
    if (previous === watchedCategoryId) {
      return;
    }

    previousCategoryRef.current = watchedCategoryId ?? undefined;

    const currentBrandId = getValues("brand_id");
    const currentGroupId = getValues("group_id");
    const currentSubGroupId = getValues("sub_group_id");

    if (currentBrandId) {
      setValue("brand_id", "");
    }
    if (currentGroupId) {
      setValue("group_id", "");
    }
    if (currentSubGroupId) {
      setValue("sub_group_id", "");
    }

    setGroups([]);
    setSubGroups([]);
    setGroupsError(null);
    setSubGroupsError(null);

    if (watchedCategoryId) {
      fetchGroups(watchedCategoryId);
    }
  }, [watchedCategoryId, fetchGroups, getValues, setValue, initialLoading]);

  useEffect(() => {
    if (initialLoading) {
      previousGroupRef.current = watchedGroupId || undefined;
      return;
    }

    const previous = previousGroupRef.current;
    if (previous === watchedGroupId) {
      return;
    }

    previousGroupRef.current = watchedGroupId ?? undefined;

    const currentSubGroupId = getValues("sub_group_id");
    if (currentSubGroupId) {
      setValue("sub_group_id", "");
    }

    setSubGroups([]);
    setSubGroupsError(null);

    if (watchedGroupId) {
      fetchSubGroups(watchedGroupId);
    }
  }, [watchedGroupId, fetchSubGroups, getValues, setValue, initialLoading]);

  useEffect(() => {
    if (initialLoading || !originalProduct) {
      return;
    }

    if (!restrictHierarchyForActive) {
      if (collisionTimeoutRef.current) {
        clearTimeout(collisionTimeoutRef.current);
        collisionTimeoutRef.current = null;
      }
      setCollisionCheck(prev => {
        if (!prev.conflict && !prev.loading) {
          return prev;
        }
        return { conflict: false, loading: false };
      });
      return;
    }

    if (
      watchedManufacturerId &&
      watchedCategoryId &&
      watchedBrandId &&
      watchedGroupId &&
      watchedSubGroupId
    ) {
      const currentCombo = {
        manufacturer_id: watchedManufacturerId,
        category_id: watchedCategoryId,
        brand_id: watchedBrandId,
        group_id: watchedGroupId,
        sub_group_id: watchedSubGroupId,
      };

      const originalCombo = {
        manufacturer_id: originalProduct.manufacturer_id,
        category_id: originalProduct.category_id,
        brand_id: originalProduct.brand_id,
        group_id: originalProduct.group_id,
        sub_group_id: originalProduct.sub_group_id,
      };

      const comboChanged = Object.entries(currentCombo).some(([key, value]) => {
        return value !== (originalCombo as Record<string, string | null>)[key];
      });

      const activationChange = !originalProduct.is_active && (watchedIsActive ?? true);
      const shouldCheck = (watchedIsActive ?? true) && (comboChanged || activationChange);

      if (shouldCheck) {
        debouncedCheckCollision({
          ...currentCombo,
          is_active: watchedIsActive ?? true,
        });
      } else {
        if (collisionTimeoutRef.current) {
          clearTimeout(collisionTimeoutRef.current);
          collisionTimeoutRef.current = null;
        }
        setCollisionCheck(prev => {
          if (!prev.conflict && !prev.loading) {
            return prev;
          }
          return { conflict: false, loading: false };
        });
      }
    } else {
      if (collisionTimeoutRef.current) {
        clearTimeout(collisionTimeoutRef.current);
        collisionTimeoutRef.current = null;
      }
      setCollisionCheck(prev => {
        if (!prev.conflict && !prev.loading) {
          return prev;
        }
        return { conflict: false, loading: false };
      });
    }
  }, [
    watchedManufacturerId,
    watchedCategoryId,
    watchedBrandId,
    watchedGroupId,
    watchedSubGroupId,
    watchedIsActive,
    debouncedCheckCollision,
    originalProduct,
    restrictHierarchyForActive,
    initialLoading,
  ]);

  const loadInitialData = useCallback(async () => {
    try {
      setInitialLoading(true);

      // Load master data
      const [categoriesData, brandsData, manufacturersData] = await Promise.all([
        getCategories(),
        getBrands(),
        getManufacturers(),
      ]);
      setCategories(categoriesData);
      const transformedBrands = brandsData.map((brand: any) => ({
        ...brand,
        category: Array.isArray(brand.category) ? brand.category[0] : brand.category,
      }));
      setBrands(transformedBrands);
      setManufacturers(manufacturersData);

      // Load product data
      const response = await fetch(`/api/master/products/${productId}`);
      const result = await response.json();

      if (!result.ok) {
        throw new Error(result.message || "Failed to load product");
      }

      const product = result.data;

      // Store original product data for collision checking
      setOriginalProduct({
        manufacturer_id: product.manufacturer_id,
        category_id: product.category_id,
        brand_id: product.brand_id,
        group_id: product.group_id,
        sub_group_id: product.sub_group_id,
        is_active: product.is_active ?? true,
      });

      // Prefill form
      setValue("name", product.name);
      setValue("category_id", product.category_id);
      setValue("brand_id", product.brand_id);
      setValue("group_id", product.group_id);
      setValue("sub_group_id", product.sub_group_id);
      setValue("manufacturer_id", product.manufacturer_id);
      setValue("price", product.price?.toString() || "");
      setValue("is_active", product.is_active ?? true);

      if (product.image_url) {
        setImagePreview(product.image_url);
      }

      // Load groups and sub-groups for the selected category/group
      if (product.category_id) {
        await fetchGroups(product.category_id);
      }
      if (product.group_id) {
        await fetchSubGroups(product.group_id);
      }

      previousManufacturerRef.current = product.manufacturer_id || undefined;
      previousCategoryRef.current = product.category_id || undefined;
      previousGroupRef.current = product.group_id || undefined;
      setActiveCombos([]);
      setActiveCombosError(null);

    } catch (error) {
      console.error("Failed to load data:", error);
      alert("Failed to load product data");
      router.push("/master/products");
    } finally {
      setInitialLoading(false);
    }
  }, [productId, setValue, fetchGroups, fetchSubGroups, router]);

  // Load initial data and product
  useEffect(() => {
    loadInitialData();
  }, [loadInitialData]);

  // Listen for product deletion events to refresh active combos
  useEffect(() => {
    const handleProductDeleted = () => {
      // If the form is currently showing combos for a manufacturer, refresh them
      if (watchedManufacturerId && restrictHierarchyForActive && !initialLoading) {
        getActiveCombosForManufacturer(watchedManufacturerId)
          .then(result => {
            const sanitized = result.filter(combo => combo.product_id !== productId);
            setActiveCombos(sanitized);
          })
          .catch(error => {
            console.error("Failed to refresh active product combos after delete:", error);
            setActiveCombos([]);
            setActiveCombosError("Unable to check existing products right now.");
          });
      }
    };

    window.addEventListener('products:deleted', handleProductDeleted);
    return () => {
      window.removeEventListener('products:deleted', handleProductDeleted);
    };
  }, [watchedManufacturerId, restrictHierarchyForActive, initialLoading, productId]);

  useEffect(() => {
    if (initialLoading) {
      previousManufacturerRef.current = watchedManufacturerId || undefined;
      return;
    }

    const previous = previousManufacturerRef.current;
    if (previous === watchedManufacturerId) {
      return;
    }

    previousManufacturerRef.current = watchedManufacturerId ?? undefined;

    if (previous || watchedManufacturerId) {
      const currentValues = getValues();

      if (currentValues.category_id) {
        setValue("category_id", "");
      }
      if (currentValues.brand_id) {
        setValue("brand_id", "");
      }
      if (currentValues.group_id) {
        setValue("group_id", "");
      }
      if (currentValues.sub_group_id) {
        setValue("sub_group_id", "");
      }

      setGroups([]);
      setSubGroups([]);
      setGroupsError(null);
      setSubGroupsError(null);
    }

    setActiveCombos([]);
    setActiveCombosError(null);
    setActiveCombosLoading(false);
  }, [watchedManufacturerId, getValues, setValue, initialLoading]);

  useEffect(() => {
    if (!restrictHierarchyForActive || !watchedManufacturerId || initialLoading) {
      setActiveCombos([]);
      setActiveCombosError(null);
      setActiveCombosLoading(false);
      return;
    }

    let cancelled = false;
    setActiveCombosLoading(true);
    setActiveCombosError(null);

    getActiveCombosForManufacturer(watchedManufacturerId)
      .then(result => {
        if (cancelled) return;
        const sanitized = result.filter(combo => combo.product_id !== productId);
        setActiveCombos(sanitized);
      })
      .catch(error => {
        if (cancelled) return;
        console.error("Failed to fetch active product combos:", error);
        setActiveCombos([]);
        setActiveCombosError("Unable to check existing products right now.");
      })
      .finally(() => {
        if (cancelled) return;
        setActiveCombosLoading(false);
      });

    return () => {
      cancelled = true;
    };
  }, [restrictHierarchyForActive, watchedManufacturerId, initialLoading, productId]);

  const onSubmit = async (data: ProductFormData) => {
    // Check for collision if activating or changing combination while active
    if (data.is_active && originalProduct) {
      const currentCombo = {
        manufacturer_id: data.manufacturer_id,
        category_id: data.category_id,
        brand_id: data.brand_id,
        group_id: data.group_id,
        sub_group_id: data.sub_group_id
      };
      const originalCombo = {
        manufacturer_id: originalProduct.manufacturer_id,
        category_id: originalProduct.category_id,
        brand_id: originalProduct.brand_id,
        group_id: originalProduct.group_id,
        sub_group_id: originalProduct.sub_group_id
      };

      const comboChanged = JSON.stringify(currentCombo) !== JSON.stringify(originalCombo);

      if (comboChanged || (!originalProduct.is_active && data.is_active)) {
        const finalCheck = await checkActiveCollision({
          manufacturer_id: data.manufacturer_id,
          category_id: data.category_id,
          brand_id: data.brand_id,
          group_id: data.group_id,
          sub_group_id: data.sub_group_id,
          is_active: data.is_active,
        });

        if (finalCheck.conflict) {
          setCollisionCheck({ conflict: true, product: finalCheck.product, loading: false });
          return; // Don't submit
        }
      }
    }

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

      const result = await updateProduct(productId, formData);
      if (result.ok) {
        router.push(`/master/products/${productId}`);
      } else {
        alert(result.message || "Failed to update product");
      }
    } catch (error) {
      console.error("Update product error:", error);
      alert("Failed to update product");
    } finally {
      setLoading(false);
    }
  };

  // Handle "Save as Inactive" - sets active to false and submits
  const onSaveAsInactive = async () => {
    setValue("is_active", false, { shouldDirty: true, shouldTouch: true });
    const data = watch();
    const inactiveData = { ...data, is_active: false };

    try {
      setLoading(true);
      const formData = new FormData();

      // Add all form fields except image
      Object.entries(inactiveData).forEach(([key, value]) => {
        if (key !== "image" && value !== undefined && value !== null) {
          formData.append(key, value.toString());
        }
      });

      // Handle image upload separately if provided
      if (inactiveData.image) {
        formData.append("image", inactiveData.image);
      }

      const result = await updateProduct(productId, formData);
      if (result.ok) {
        router.push(`/master/products/${productId}`);
      } else {
        alert(result.message || "Failed to update product");
      }
    } catch (error) {
      console.error("Update product error:", error);
      alert("Failed to update product");
    } finally {
      setLoading(false);
    }
  };

  if (initialLoading) {
    return (
      <div className="flex items-center justify-center min-h-96">
        <Loader2 className="h-8 w-8 animate-spin" />
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center space-x-4">
        <Button variant="ghost" onClick={() => router.push(`/master/products/${productId}`)}>
          <ArrowLeft className="h-4 w-4 mr-2" />
          Back to Product
        </Button>
        <div>
          <h2 className="text-xl font-semibold">Edit Product</h2>
          <p className="text-sm text-gray-500">Update product information</p>
        </div>
      </div>

      <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
        {/* Image Upload Section */}
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
                checked={watchedIsActive ?? true}
                onCheckedChange={(checked) => setValue("is_active", checked)}
                disabled={loading}
              />
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
              <Select
                value={watchedManufacturerId || undefined}
                onValueChange={(value) => setValue("manufacturer_id", value)}
              >
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
                <Select
                  value={watchedCategoryId || undefined}
                  onValueChange={(value) => setValue("category_id", value)}
                >
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
                  value={watchedBrandId || undefined}
                  onValueChange={(value) => setValue("brand_id", value)}
                  disabled={
                    !watchedManufacturerId ||
                    !watchedCategoryId ||
                    isComboLoadingForCurrent
                  }
                >
                  <SelectTrigger>
                    <SelectValue
                      placeholder={
                        !watchedManufacturerId
                          ? "Select manufacturer first"
                          : !watchedCategoryId
                          ? "Select category first"
                          : isComboLoadingForCurrent
                          ? "Checking active combinations..."
                          : filteredBrands.length === 0
                          ? "No brands in this category"
                          : "Select brand"
                      }
                    />
                  </SelectTrigger>
                  <SelectContent>
                    {!watchedManufacturerId || !watchedCategoryId ? (
                      <div className="flex items-center justify-center p-4 text-gray-500">
                        Choose manufacturer and category first
                      </div>
                    ) : isComboLoadingForCurrent ? (
                      <div className="flex items-center justify-center p-4">
                        <Loader2 className="h-4 w-4 animate-spin mr-2" />
                        Checking existing products...
                      </div>
                    ) : filteredBrands.length === 0 ? (
                      <div className="flex items-center justify-center p-4 text-gray-500">
                        No brands in this category
                      </div>
                    ) : (
                      filteredBrands.map((brand) => (
                        <SelectItem
                          key={brand.id}
                          value={brand.id}
                        >
                          {brand.name}
                        </SelectItem>
                      ))
                    )}
                  </SelectContent>
                </Select>
                {comboFetchErrorForCurrent && (
                  <p className="text-sm text-orange-600">{comboFetchErrorForCurrent}</p>
                )}
                {errors.brand_id && (
                  <p className="text-sm text-red-600">{errors.brand_id.message}</p>
                )}
              </div>

              <div className="space-y-2">
                <Label htmlFor="group_id">Group *</Label>
                <Select
                  value={watchedGroupId || undefined}
                  onValueChange={(value) => setValue("group_id", value)}
                  disabled={!watchedCategoryId || !watchedBrandId}
                >
                  <SelectTrigger>
                    <SelectValue placeholder={
                      !watchedCategoryId
                        ? "Select category first"
                        : !watchedBrandId
                        ? "Select brand first"
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
                    {!watchedCategoryId || !watchedBrandId ? (
                      <div className="flex items-center justify-center p-4 text-gray-500">
                        Choose category and brand first
                      </div>
                    ) : groupsLoading ? (
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
                        <SelectItem
                          key={group.id}
                          value={group.id}
                        >
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
                  value={watchedSubGroupId || undefined}
                  onValueChange={(value) => setValue("sub_group_id", value)}
                  disabled={!watchedGroupId}
                >
                  <SelectTrigger>
                    <SelectValue placeholder={
                      !watchedGroupId
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
                        <SelectItem
                          key={subGroup.id}
                          value={subGroup.id}
                        >
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

            {restrictHierarchyForActive && (collisionCheck.conflict || hierarchyBlocked) && (
              <div className="rounded-md border border-muted-foreground/30 bg-muted/20 p-3 text-sm leading-5 text-muted-foreground">
                {collisionCheck.conflict ? (
                  <>
                    <p>
                      That exact combination already exists as an active product
                      {collisionCheck.product ? ` (${collisionCheck.product.name})` : ""}.
                    </p>
                    <p className="mt-2">
                      Update the hierarchy selections or save this product as inactive to avoid the conflict.
                    </p>
                    <div className="mt-3 flex flex-wrap gap-3">
                      <Button
                        type="button"
                        variant="outline"
                        size="sm"
                        onClick={onSaveAsInactive}
                        disabled={loading}
                      >
                        {loading ? "Saving..." : "Save as Inactive"}
                      </Button>
                      {collisionCheck.product && (
                        <Button
                          type="button"
                          variant="ghost"
                          size="sm"
                          onClick={() => {
                            window.open(`/master/products/${collisionCheck.product!.id}`, "_blank");
                          }}
                        >
                          View active product
                        </Button>
                      )}
                    </div>
                  </>
                ) : (
                  <p>
                    This combination is already used by another active product. Adjust Category, Brand, or Group or switch the product to inactive to continue.
                  </p>
                )}
              </div>
            )}
          </CardContent>
        </Card>

        <div className="flex justify-end space-x-4">
          <Button type="button" variant="outline" onClick={() => router.push(`/master/products/${productId}`)}>
            Cancel
          </Button>
          <Button
            type="submit"
            disabled={
              loading ||
              collisionCheck.loading ||
              !watchedCategoryId ||
              !watchedBrandId ||
              !watchedGroupId ||
              !watchedSubGroupId ||
              !watchedManufacturerId ||
              !watchedName ||
              (restrictHierarchyForActive && collisionCheck.conflict)
            }
            variant="primary"
          >
            {loading && <Loader2 className="h-4 w-4 mr-2 animate-spin" />}
            Update Product
          </Button>
        </div>
      </form>
    </div>
  );
}
