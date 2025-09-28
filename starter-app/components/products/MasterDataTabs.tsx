"use client";

import { useState, useEffect } from "react";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { EmptyState } from "@/components/ui/empty-state";
import { FormDialog } from "@/components/ui/form-dialog";
import { Textarea } from "@/components/ui/textarea";
import { Plus, Edit, Trash2, Tag, Package, Layers, Layers3, Box, Building2, Users } from "lucide-react";
import { toast } from "sonner";
import ManufacturerFormModal from "./ManufacturerFormModal";
import {
  getCategories,
  createCategory,
  updateCategory,
  deleteCategory,
  getBrands,
  createBrand,
  updateBrand,
  deleteBrand,
  getProductGroups,
  createProductGroup,
  updateProductGroup,
  deleteProductGroup,
  getProductSubGroups,
  createProductSubGroup,
  updateProductSubGroup,
  deleteProductSubGroup,
  getManufacturers,
  getProducts,
  getProductVariants,
  createProductVariant,
  updateProductVariant,
  deleteProductVariant,
} from "../../app/(protected)/master/products/actions";
import {
  Category,
  BrandWithCategory,
  ProductGroupWithCategory,
  ProductSubGroupWithGroup,
  Manufacturer,
  Product,
  ProductVariantWithProduct,
  TabKey,
  CategoryForm,
  BrandForm,
  ProductGroupForm,
  ProductSubGroupForm,
  ProductVariantForm
} from "@/lib/types/master";

export function MasterDataTabs({ onCreateProduct }: { onCreateProduct?: () => void }) {
  const [activeTab, setActiveTab] = useState<TabKey>("categories");
  const [showManufacturerModal, setShowManufacturerModal] = useState(false);
  const [editingManufacturer, setEditingManufacturer] = useState<Manufacturer | null>(null);

  // Categories state
  const [categories, setCategories] = useState<Category[]>([]);
  const [showCategoryDialog, setShowCategoryDialog] = useState(false);
  const [editingCategory, setEditingCategory] = useState<Category | null>(null);
  const [categoryForm, setCategoryForm] = useState<CategoryForm>({ name: "", description: "" });

  // Brands state
  const [brands, setBrands] = useState<BrandWithCategory[]>([]);
  const [showBrandDialog, setShowBrandDialog] = useState(false);
  const [editingBrand, setEditingBrand] = useState<BrandWithCategory | null>(null);
  const [brandForm, setBrandForm] = useState<BrandForm>({ name: "", category_id: "" });
  const [isBrandSubmitting, setIsBrandSubmitting] = useState(false);

  // Product Groups state
  const [productGroups, setProductGroups] = useState<ProductGroupWithCategory[]>([]);
  const [showGroupDialog, setShowGroupDialog] = useState(false);
  const [editingGroup, setEditingGroup] = useState<ProductGroupWithCategory | null>(null);
  const [groupForm, setGroupForm] = useState<ProductGroupForm>({ name: "", category_id: "" });
  const [isGroupSubmitting, setIsGroupSubmitting] = useState(false);

  // Product Sub-Groups state
  const [productSubGroups, setProductSubGroups] = useState<ProductSubGroupWithGroup[]>([]);
  const [showSubGroupDialog, setShowSubGroupDialog] = useState(false);
  const [editingSubGroup, setEditingSubGroup] = useState<ProductSubGroupWithGroup | null>(null);
  const [subGroupForm, setSubGroupForm] = useState<ProductSubGroupForm>({ name: "", group_id: "" });
  const [isSubGroupSubmitting, setIsSubGroupSubmitting] = useState(false);

  // Manufacturers state
  const [manufacturers, setManufacturers] = useState<Manufacturer[]>([]);

  // Variants state
  const [products, setProducts] = useState<Product[]>([]);
  const [productVariants, setProductVariants] = useState<ProductVariantWithProduct[]>([]);
  const [showVariantDialog, setShowVariantDialog] = useState(false);
  const [editingVariant, setEditingVariant] = useState<ProductVariantWithProduct | null>(null);
  const [variantForm, setVariantForm] = useState<ProductVariantForm>({
    product_id: "",
    flavor_name: "",
    nic_strength: "",
    packaging: ""
  });
  const [isVariantSubmitting, setIsVariantSubmitting] = useState(false);

  // Loading states
  // const [loading, setLoading] = useState(false);

  // Load data on mount
  useEffect(() => {
    loadAllData();
  }, []);

  const loadAllData = async () => {
    try {
      const [
        categoriesData,
        brandsData,
        groupsData,
        subGroupsData,
        manufacturersData,
        productsData,
        variantsData
      ] = await Promise.all([
        getCategories(),
        getBrands(),
        getProductGroups(),
        getProductSubGroups(),
        getManufacturers(),
        getProducts(),
        getProductVariants()
      ]);

      setCategories(categoriesData || []);
      // Transform brands data
      const transformedBrands = (brandsData || []).map(brand => ({
        ...brand,
        category: Array.isArray(brand.category) ? brand.category[0] : brand.category,
      }));
      setBrands(transformedBrands);
      setProductGroups(groupsData || []);
      // Transform sub-groups data
      const transformedSubGroups = (subGroupsData || []).map(subGroup => ({
        ...subGroup,
        group: Array.isArray(subGroup.group) ? subGroup.group[0] : subGroup.group,
      }));
      setProductSubGroups(transformedSubGroups);
      setManufacturers(manufacturersData || []);
      // Transform products data
      const transformedProducts = (productsData || []).map(product => ({
        ...product,
        category: Array.isArray(product.category) ? product.category[0] : product.category,
        brand: Array.isArray(product.brand) ? product.brand[0] : product.brand,
        group: Array.isArray(product.group) ? product.group[0] : product.group,
        sub_group: Array.isArray(product.sub_group) ? product.sub_group[0] : product.sub_group,
        manufacturer: Array.isArray(product.manufacturer) ? product.manufacturer[0] : product.manufacturer,
      }));
      setProducts(transformedProducts);
      // Transform variants data
      const transformedVariants = (variantsData || []).map(variant => ({
        ...variant,
        product: Array.isArray(variant.product) ? variant.product[0] : variant.product,
      }));
      setProductVariants(transformedVariants);
    } catch (error) {
      console.error("Failed to load master data:", error);
      // Don't throw - just log and continue with empty arrays
      setCategories([]);
      setBrands([]);
      setProductGroups([]);
      setProductSubGroups([]);
      setManufacturers([]);
      setProducts([]);
      setProductVariants([]);
    }
  };

  // ==================== CATEGORIES CRUD ====================
  const handleCreateCategory = () => {
    setEditingCategory(null);
    setCategoryForm({ name: "", description: "" });
    setShowCategoryDialog(true);
  };

  const handleEditCategory = (category: Category) => {
    setEditingCategory(category);
    setCategoryForm({ name: category.name, description: category.description || "" });
    setShowCategoryDialog(true);
  };

  const handleCategorySubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const formData = new FormData();
      formData.append("name", categoryForm.name);

      const result = editingCategory
        ? await updateCategory(editingCategory.id, formData)
        : await createCategory(formData);

      if (result.ok) {
        setShowCategoryDialog(false);
        loadAllData();
      } else {
        alert(result.message);
      }
    } catch (error) {
      console.error("Category operation error:", error);
      alert("Failed to save category");
    }
  };

  const handleDeleteCategory = async (id: string) => {
    if (!confirm("Are you sure you want to delete this category?")) return;
    try {
      const result = await deleteCategory(id);
      if (result.ok) {
        loadAllData();
      } else {
        alert(result.message);
      }
    } catch (error) {
      console.error("Delete category error:", error);
      alert("Failed to delete category");
    }
  };

  // ==================== BRANDS CRUD ====================
  const handleCreateBrand = () => {
    setEditingBrand(null);
    setBrandForm({ name: "", category_id: "" });
    setShowBrandDialog(true);
  };

  const handleEditBrand = (brand: BrandWithCategory) => {
    setEditingBrand(brand);
    setBrandForm({ name: brand.name, category_id: brand.category?.id || "" });
    setShowBrandDialog(true);
  };

  const handleBrandSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsBrandSubmitting(true);

    const toastId = toast.loading("Saving brand...");

    try {
      const formData = new FormData();
      formData.append("name", brandForm.name);
      formData.append("category_id", brandForm.category_id);

      const result = editingBrand
        ? await updateBrand(editingBrand.id, formData)
        : await createBrand(formData);

      if (result.ok) {
        toast.success(editingBrand ? "Brand updated successfully" : "Brand created successfully", { id: toastId });
        setShowBrandDialog(false);
        setBrandForm({ name: "", category_id: "" });
        loadAllData();
      } else {
        toast.error(`Failed to save brand: ${result.message}`, { id: toastId });
      }
    } catch (error) {
      console.error("Brand operation error:", error);
      toast.error("Failed to save brand", { id: toastId });
    } finally {
      setIsBrandSubmitting(false);
    }
  };

  const isBrandFormValid = brandForm.name.trim() !== "" && brandForm.category_id !== "";

  const handleDeleteBrand = async (id: string) => {
    if (!confirm("Are you sure you want to delete this brand?")) return;
    try {
      const result = await deleteBrand(id);
      if (result.ok) {
        loadAllData();
      } else {
        alert(result.message);
      }
    } catch (error) {
      console.error("Delete brand error:", error);
      alert("Failed to delete brand");
    }
  };

  // ==================== PRODUCT GROUPS CRUD ====================
  const handleCreateGroup = () => {
    setEditingGroup(null);
    setGroupForm({ name: "", category_id: "" });
    setShowGroupDialog(true);
  };

  const handleEditGroup = (group: ProductGroupWithCategory) => {
    setEditingGroup(group);
    setGroupForm({ name: group.name, category_id: group.category?.id || "" });
    setShowGroupDialog(true);
  };

  const handleGroupSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsGroupSubmitting(true);

    const toastId = toast.loading("Saving group...");

    try {
      const formData = new FormData();
      formData.append("name", groupForm.name);
      formData.append("category_id", groupForm.category_id);

      const result = editingGroup
        ? await updateProductGroup(editingGroup.id, formData)
        : await createProductGroup(formData);

      if (result.ok) {
        toast.success(editingGroup ? "Group updated successfully" : "Group created successfully", { id: toastId });
        setShowGroupDialog(false);
        setGroupForm({ name: "", category_id: "" });
        loadAllData();
      } else {
        toast.error(`Failed to save group: ${result.message}`, { id: toastId });
      }
    } catch (error) {
      console.error("Group operation error:", error);
      toast.error("Failed to save group", { id: toastId });
    } finally {
      setIsGroupSubmitting(false);
    }
  };

  const isGroupFormValid = groupForm.name.trim() !== "" && groupForm.category_id !== "";

  const handleDeleteGroup = async (id: string) => {
    if (!confirm("Are you sure you want to delete this group?")) return;
    try {
      const result = await deleteProductGroup(id);
      if (result.ok) {
        loadAllData();
      } else {
        alert(result.message);
      }
    } catch (error) {
      console.error("Delete group error:", error);
      alert("Failed to delete group");
    }
  };

  // ==================== PRODUCT SUB-GROUPS CRUD ====================
  const handleCreateSubGroup = () => {
    setEditingSubGroup(null);
    setSubGroupForm({ name: "", group_id: "" });
    setShowSubGroupDialog(true);
  };

  const handleEditSubGroup = (subGroup: ProductSubGroupWithGroup) => {
    setEditingSubGroup(subGroup);
    setSubGroupForm({ name: subGroup.name, group_id: subGroup.group?.id || "" });
    setShowSubGroupDialog(true);
  };

  const handleSubGroupSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsSubGroupSubmitting(true);

    const toastId = toast.loading("Saving sub-group...");

    try {
      const formData = new FormData();
      formData.append("name", subGroupForm.name);
      formData.append("group_id", subGroupForm.group_id);

      const result = editingSubGroup
        ? await updateProductSubGroup(editingSubGroup.id, formData)
        : await createProductSubGroup(formData);

      if (result.ok) {
        toast.success(editingSubGroup ? "Sub-group updated successfully" : "Sub-group created successfully", { id: toastId });
        setShowSubGroupDialog(false);
        setSubGroupForm({ name: "", group_id: "" });
        loadAllData();
      } else {
        toast.error(`Failed to save sub-group: ${result.message}`, { id: toastId });
      }
    } catch (error) {
      console.error("Sub-group operation error:", error);
      toast.error("Failed to save sub-group", { id: toastId });
    } finally {
      setIsSubGroupSubmitting(false);
    }
  };

  const isSubGroupFormValid = subGroupForm.name.trim() !== "" && subGroupForm.group_id !== "";

  const handleDeleteSubGroup = async (id: string) => {
    if (!confirm("Are you sure you want to delete this sub-group?")) return;
    try {
      const result = await deleteProductSubGroup(id);
      if (result.ok) {
        loadAllData();
      } else {
        alert(result.message);
      }
    } catch (error) {
      console.error("Delete sub-group error:", error);
      alert("Failed to delete sub-group");
    }
  };

  // ==================== VARIANTS CRUD ====================
  const handleCreateVariant = () => {
    setEditingVariant(null);
    setVariantForm({ product_id: "", flavor_name: "", nic_strength: "", packaging: "" });
    setShowVariantDialog(true);
  };

  const handleEditVariant = (variant: ProductVariantWithProduct) => {
    setEditingVariant(variant);
    setVariantForm({
      product_id: variant.product?.id || "",
      flavor_name: variant.flavor_name || "",
      nic_strength: variant.nic_strength || "",
      packaging: variant.packaging || ""
    });
    setShowVariantDialog(true);
  };

  const handleVariantSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsVariantSubmitting(true);

    const toastId = toast.loading("Saving variant...");

    try {
      // Check if the selected product still exists
      const selectedProduct = products.find(p => p.id === variantForm.product_id);
      if (!selectedProduct) {
        toast.error("The selected product no longer exists. Please choose another product or create a new one.", { id: toastId });
        setIsVariantSubmitting(false);
        return;
      }

      const formData = new FormData();
      formData.append("product_id", variantForm.product_id);
      if (variantForm.flavor_name) formData.append("flavor_name", variantForm.flavor_name);
      if (variantForm.nic_strength) formData.append("nic_strength", variantForm.nic_strength);
      if (variantForm.packaging) formData.append("packaging", variantForm.packaging);

      const result = editingVariant
        ? await updateProductVariant(editingVariant.id, formData)
        : await createProductVariant(formData);

      if (result.ok) {
        toast.success(editingVariant ? "Variant updated successfully" : "Variant created successfully", { id: toastId });
        setShowVariantDialog(false);
        setVariantForm({ product_id: "", flavor_name: "", nic_strength: "", packaging: "" });
        loadAllData();
      } else {
        toast.error(`Failed to save variant: ${result.message}`, { id: toastId });
      }
    } catch (error) {
      console.error("Variant operation error:", error);
      toast.error("Failed to save variant", { id: toastId });
    } finally {
      setIsVariantSubmitting(false);
    }
  };

  const isVariantFormValid = variantForm.product_id !== "";

  const handleDeleteVariant = async (id: string) => {
    if (!confirm("Are you sure you want to delete this variant?")) return;
    try {
      const result = await deleteProductVariant(id);
      if (result.ok) {
        loadAllData();
      } else {
        alert(result.message);
      }
    } catch (error) {
      console.error("Delete variant error:", error);
      alert("Failed to delete variant");
    }
  };

  const handleCreateManufacturer = () => {
    setEditingManufacturer(null);
    setShowManufacturerModal(true);
  };

  const handleManufacturerSuccess = () => {
    setShowManufacturerModal(false);
    setEditingManufacturer(null);
    // Refresh data would happen here
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-xl font-semibold">Master Data Management</h2>
          <p className="text-sm text-gray-500">
            Manage categories, brands, groups, manufacturers, and other master data
          </p>
        </div>
      </div>

      <Tabs value={activeTab} onValueChange={(value) => setActiveTab(value as TabKey)}>
        <TabsList className="grid w-full grid-cols-7">
          <TabsTrigger value="categories" className="flex items-center gap-2">
            <Tag className="h-4 w-4" />
            Categories
          </TabsTrigger>
          <TabsTrigger value="brands" className="flex items-center gap-2">
            <Package className="h-4 w-4" />
            Brands
          </TabsTrigger>
          <TabsTrigger value="groups" className="flex items-center gap-2">
            <Layers className="h-4 w-4" />
            Groups
          </TabsTrigger>
          <TabsTrigger value="subgroups" className="flex items-center gap-2">
            <Layers3 className="h-4 w-4" />
            Sub-Groups
          </TabsTrigger>
          <TabsTrigger value="variants" className="flex items-center gap-2">
            <Box className="h-4 w-4" />
            Variants
          </TabsTrigger>
          <TabsTrigger value="manufacturers" className="flex items-center gap-2">
            <Building2 className="h-4 w-4" />
            Manufacturers
          </TabsTrigger>
          <TabsTrigger value="distributors" className="flex items-center gap-2">
            <Users className="h-4 w-4" />
            Distributors
          </TabsTrigger>
        </TabsList>

        <TabsContent value="categories" className="space-y-4">
          <div className="flex flex-col sm:flex-row sm:justify-between sm:items-center gap-4">
            <h2 className="text-2xl font-bold">Categories</h2>
            <Button onClick={handleCreateCategory} variant="primary" className="w-full sm:w-auto" data-testid="cta-create-category">
              <Plus className="w-4 h-4 mr-2" />
              Add Category
            </Button>
          </div>
          <div className="grid gap-4">
            {categories.map((category) => (
              <Card key={category.id}>
                <CardContent className="p-4">
                  <div className="flex justify-between items-center">
                    <div>
                      <h3 className="font-semibold">{category.name}</h3>
                      <p className="text-sm text-muted-foreground">{category.description}</p>
                    </div>
                    <div className="flex gap-2">
                      <Button variant="outline" size="sm" onClick={() => handleEditCategory(category)}>
                        <Edit className="w-4 h-4" />
                      </Button>
                      <Button variant="outline" size="sm" onClick={() => handleDeleteCategory(category.id)}>
                        <Trash2 className="w-4 h-4" />
                      </Button>
                    </div>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        </TabsContent>

        <TabsContent value="brands" className="space-y-4">
          <div className="flex flex-col sm:flex-row sm:justify-between sm:items-center gap-4">
            <h2 className="text-2xl font-bold">Brands</h2>
            <Button onClick={handleCreateBrand} variant="primary" className="w-full sm:w-auto" data-testid="cta-create-brand">
              <Plus className="w-4 h-4 mr-2" />
              Add Brand
            </Button>
          </div>
          {brands.length === 0 ? (
            <EmptyState
              icon={Package}
              title="No brands found"
              body="Get started by creating your first brand."
              primaryCta={{
                label: "Add Brand",
                onClick: handleCreateBrand
              }}
            />
          ) : (
            <div className="grid gap-4">
              {brands.map((brand) => (
                <Card key={brand.id}>
                  <CardContent className="p-4">
                    <div className="flex justify-between items-center">
                      <div>
                        <h3 className="font-semibold">{brand.name}</h3>
                        <p className="text-sm text-muted-foreground">Category: {brand.category?.name}</p>
                      </div>
                      <div className="flex gap-2">
                        <Button variant="outline" size="sm" onClick={() => handleEditBrand(brand)}>
                          <Edit className="w-4 h-4" />
                        </Button>
                        <Button variant="outline" size="sm" onClick={() => handleDeleteBrand(brand.id)}>
                          <Trash2 className="w-4 h-4" />
                        </Button>
                      </div>
                    </div>
                  </CardContent>
                </Card>
              ))}
            </div>
          )}
        </TabsContent>

                <TabsContent value="groups" className="space-y-4">
          <div className="flex flex-col sm:flex-row sm:justify-between sm:items-center gap-4">
            <h2 className="text-2xl font-bold">Product Groups</h2>
            <Button onClick={handleCreateGroup} variant="primary" className="w-full sm:w-auto" data-testid="cta-create-group">
              <Plus className="w-4 h-4 mr-2" />
              Add Group
            </Button>
          </div>
          {productGroups.length === 0 ? (
            <EmptyState
              icon={Layers}
              title="No product groups found"
              body="Get started by creating your first product group."
              primaryCta={{
                label: "Add Group",
                onClick: handleCreateGroup
              }}
            />
          ) : (
            <div className="grid gap-4">
              {productGroups.map((group) => (
                <Card key={group.id}>
                  <CardContent className="p-4">
                    <div className="flex justify-between items-center">
                      <div>
                        <h3 className="font-semibold">{group.name}</h3>
                        <p className="text-sm text-muted-foreground">Category: {group.category?.name}</p>
                      </div>
                      <div className="flex gap-2">
                        <Button variant="outline" size="sm" onClick={() => handleEditGroup(group)}>
                          <Edit className="w-4 h-4" />
                        </Button>
                        <Button variant="outline" size="sm" onClick={() => handleDeleteGroup(group.id)}>
                          <Trash2 className="w-4 h-4" />
                        </Button>
                      </div>
                    </div>
                  </CardContent>
                </Card>
              ))}
            </div>
          )}
        </TabsContent>

        <TabsContent value="subgroups" className="space-y-4">
          <div className="flex flex-col sm:flex-row sm:justify-between sm:items-center gap-4">
            <h2 className="text-2xl font-bold">Product Sub-Groups</h2>
            <Button onClick={handleCreateSubGroup} variant="primary" className="w-full sm:w-auto" data-testid="cta-create-subgroup">
              <Plus className="w-4 h-4 mr-2" />
              Add Sub-Group
            </Button>
          </div>
          {productSubGroups.length === 0 ? (
            <EmptyState
              icon={Layers3}
              title="No product sub-groups found"
              body="Get started by creating your first product sub-group."
              primaryCta={{
                label: "Add Sub-Group",
                onClick: handleCreateSubGroup
              }}
            />
          ) : (
            <div className="grid gap-4">
              {productSubGroups.map((subGroup) => (
                <Card key={subGroup.id}>
                  <CardContent className="p-4">
                    <div className="flex justify-between items-center">
                      <div>
                        <h3 className="font-semibold">{subGroup.name}</h3>
                        <p className="text-sm text-muted-foreground">Group: {subGroup.group?.name}</p>
                      </div>
                      <div className="flex gap-2">
                        <Button variant="outline" size="sm" onClick={() => handleEditSubGroup(subGroup)}>
                          <Edit className="w-4 h-4" />
                        </Button>
                        <Button variant="outline" size="sm" onClick={() => handleDeleteSubGroup(subGroup.id)}>
                          <Trash2 className="w-4 h-4" />
                        </Button>
                      </div>
                    </div>
                  </CardContent>
                </Card>
              ))}
            </div>
          )}
        </TabsContent>

        <TabsContent value="variants" className="space-y-4">
          <div className="flex flex-col sm:flex-row sm:justify-between sm:items-center gap-4">
            <h2 className="text-2xl font-bold">Product Variants</h2>
            {products.length > 0 && (
              <Button onClick={handleCreateVariant} variant="primary" className="w-full sm:w-auto" data-testid="cta-create-variant">
                <Plus className="w-4 h-4 mr-2" />
                Add Variant
              </Button>
            )}
          </div>
          
          {products.length === 0 ? (
            <EmptyState
              icon={Box}
              title="Create a product first"
              body="Variants belong to a product. Add your first product, then come back to create its variants (flavor, nicotine strength, packaging)."
              primaryCta={{
                label: "Create Product",
                onClick: onCreateProduct || (() => {})
              }}
              secondaryCta={{
                label: "Back to Products",
                onClick: () => window.location.href = "/master/products?tab=products"
              }}
            />
          ) : productVariants.length === 0 ? (
            <EmptyState
              icon={Box}
              title="No product variants found"
              body="Get started by creating your first product variant."
              primaryCta={{
                label: "Add Variant",
                onClick: handleCreateVariant
              }}
            />
          ) : (
            <div className="grid gap-4">
              {productVariants.map((variant) => (
                <Card key={variant.id}>
                  <CardContent className="p-4">
                    <div className="flex justify-between items-center">
                      <div>
                        <h3 className="font-semibold">{variant.sku}</h3>
                        <p className="text-sm text-muted-foreground">
                          Product: {variant.product?.name} | Flavor: {variant.flavor_name} | Nic: {variant.nic_strength} | Pack: {variant.packaging}
                        </p>
                      </div>
                      <div className="flex gap-2">
                        <Button variant="outline" size="sm" onClick={() => handleEditVariant(variant)}>
                          <Edit className="w-4 h-4" />
                        </Button>
                        <Button variant="outline" size="sm" onClick={() => handleDeleteVariant(variant.id)}>
                          <Trash2 className="w-4 h-4" />
                        </Button>
                      </div>
                    </div>
                  </CardContent>
                </Card>
              ))}
            </div>
          )}
        </TabsContent>

        <TabsContent value="manufacturers" className="space-y-4">
          <div className="flex flex-col sm:flex-row sm:justify-between sm:items-center gap-4">
            <h2 className="text-2xl font-bold">Manufacturers</h2>
            <Button onClick={handleCreateManufacturer} variant="primary" className="w-full sm:w-auto" size="sm" data-testid="cta-create-manufacturer">
              <Plus className="w-4 h-4 mr-2" />
              Add Manufacturer
            </Button>
          </div>
          {manufacturers.length === 0 ? (
            <EmptyState
              icon={Building2}
              title="No manufacturers found"
              body="Get started by creating your first manufacturer."
              primaryCta={{
                label: "Add Manufacturer",
                onClick: handleCreateManufacturer
              }}
            />
          ) : (
            <div className="grid gap-4">
              {manufacturers.map((manufacturer) => (
                <Card key={manufacturer.id}>
                  <CardContent className="p-4">
                    <div className="flex justify-between items-center">
                      <div>
                        <h3 className="font-semibold">{manufacturer.name}</h3>
                        <p className="text-sm text-muted-foreground">
                          {manufacturer.contact_person && `Contact: ${manufacturer.contact_person}`}
                          {manufacturer.phone && ` | Phone: ${manufacturer.phone}`}
                          {manufacturer.email && ` | Email: ${manufacturer.email}`}
                        </p>
                      </div>
                      <div className="flex gap-2">
                        <Button variant="outline" size="sm" onClick={() => {
                          setEditingManufacturer(manufacturer);
                          setShowManufacturerModal(true);
                        }}>
                          <Edit className="w-4 h-4" />
                        </Button>
                        <Button variant="outline" size="sm" onClick={() => {
                          // TODO: Implement delete manufacturer
                          alert("Delete manufacturer functionality coming soon");
                        }}>
                          <Trash2 className="w-4 h-4" />
                        </Button>
                      </div>
                    </div>
                  </CardContent>
                </Card>
              ))}
            </div>
          )}
        </TabsContent>

        <TabsContent value="distributors" className="space-y-4">
          <Card>
            <CardHeader className="flex flex-col sm:flex-row sm:justify-between sm:items-center gap-4">
              <CardTitle>Distributors</CardTitle>
              <Button variant="primary" className="w-full sm:w-auto">
                <Plus className="h-4 w-4 mr-2" />
                Add Distributor
              </Button>
            </CardHeader>
            <CardContent>
              <p className="text-sm text-gray-500">
                Manage distributor information and relationships.
              </p>
              <div className="mt-4 text-center text-gray-500">
                Distributors management coming soon...
              </div>
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>

      {/* Category Dialog */}
      <FormDialog
        title={editingCategory ? "Edit Category" : "Add Category"}
        isOpen={showCategoryDialog}
        onClose={() => setShowCategoryDialog(false)}
        onSubmit={handleCategorySubmit}
        submitLabel={editingCategory ? "Update" : "Create"}
      >
        <div>
          <Label htmlFor="category-name">Name</Label>
          <Input
            id="category-name"
            value={categoryForm.name}
            onChange={(e) => setCategoryForm({ ...categoryForm, name: e.target.value })}
            required
            className="h-12"
          />
        </div>
        <div>
          <Label htmlFor="category-description">Description</Label>
          <Textarea
            id="category-description"
            value={categoryForm.description}
            onChange={(e) => setCategoryForm({ ...categoryForm, description: e.target.value })}
            className="h-12"
          />
        </div>
      </FormDialog>

      {/* Brand Dialog */}
      <FormDialog
        title="Add Brand"
        isOpen={showBrandDialog}
        onClose={() => setShowBrandDialog(false)}
        onSubmit={handleBrandSubmit}
        submitLabel="Save"
        busy={isBrandSubmitting}
        disableSubmit={!isBrandFormValid}
      >
        <div>
          <Label htmlFor="brand-name">
            Name <span className="text-red-500">*</span>
          </Label>
          <Input
            id="brand-name"
            value={brandForm.name}
            onChange={(e) => setBrandForm({ ...brandForm, name: e.target.value })}
            required
            disabled={isBrandSubmitting}
            className="h-12"
          />
        </div>
        <div>
          <Label htmlFor="brand-category">
            Category <span className="text-red-500">*</span>
          </Label>
          <Select
            value={brandForm.category_id}
            onValueChange={(value) => setBrandForm({ ...brandForm, category_id: value })}
            disabled={isBrandSubmitting}
          >
            <SelectTrigger className="h-12">
              <SelectValue placeholder="Select a category" />
            </SelectTrigger>
            <SelectContent>
              {categories.map((category) => (
                <SelectItem key={category.id} value={category.id}>
                  {category.name}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>
      </FormDialog>

      {/* Group Dialog */}
      <FormDialog
        title="Add Group"
        isOpen={showGroupDialog}
        onClose={() => setShowGroupDialog(false)}
        onSubmit={handleGroupSubmit}
        submitLabel="Save"
        busy={isGroupSubmitting}
        disableSubmit={!isGroupFormValid}
      >
        <div>
          <Label htmlFor="group-name">
            Name <span className="text-red-500">*</span>
          </Label>
          <Input
            id="group-name"
            value={groupForm.name}
            onChange={(e) => setGroupForm({ ...groupForm, name: e.target.value })}
            required
            disabled={isGroupSubmitting}
            className="h-12"
          />
        </div>
        <div>
          <Label htmlFor="group-category">
            Category <span className="text-red-500">*</span>
          </Label>
          <Select
            value={groupForm.category_id}
            onValueChange={(value) => setGroupForm({ ...groupForm, category_id: value })}
            disabled={isGroupSubmitting}
          >
            <SelectTrigger className="h-12">
              <SelectValue placeholder="Select a category" />
            </SelectTrigger>
            <SelectContent>
              {categories.map((category) => (
                <SelectItem key={category.id} value={category.id}>
                  {category.name}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>
      </FormDialog>

      {/* Sub-Group Dialog */}
      <FormDialog
        title="Add Sub-Group"
        isOpen={showSubGroupDialog}
        onClose={() => setShowSubGroupDialog(false)}
        onSubmit={handleSubGroupSubmit}
        submitLabel="Save"
        busy={isSubGroupSubmitting}
        disableSubmit={!isSubGroupFormValid}
      >
        <div>
          <Label htmlFor="subgroup-name">
            Name <span className="text-red-500">*</span>
          </Label>
          <Input
            id="subgroup-name"
            value={subGroupForm.name}
            onChange={(e) => setSubGroupForm({ ...subGroupForm, name: e.target.value })}
            required
            disabled={isSubGroupSubmitting}
            className="h-12"
          />
        </div>
        <div>
          <Label htmlFor="subgroup-group">
            Group <span className="text-red-500">*</span>
          </Label>
          <Select
            value={subGroupForm.group_id}
            onValueChange={(value) => setSubGroupForm({ ...subGroupForm, group_id: value })}
            disabled={isSubGroupSubmitting}
          >
            <SelectTrigger className="h-12">
              <SelectValue placeholder="Select a group" />
            </SelectTrigger>
            <SelectContent>
              {productGroups.map((group) => (
                <SelectItem key={group.id} value={group.id}>
                  {group.name}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>
      </FormDialog>

      {/* Variant Dialog */}
      <FormDialog
        title="Add Variant"
        isOpen={showVariantDialog}
        onClose={() => setShowVariantDialog(false)}
        onSubmit={handleVariantSubmit}
        submitLabel="Save"
        busy={isVariantSubmitting}
        disableSubmit={!isVariantFormValid}
      >
        <div>
          <Label htmlFor="variant-product">
            Product <span className="text-red-500">*</span>
          </Label>
          <Select
            value={variantForm.product_id}
            onValueChange={(value) => setVariantForm({ ...variantForm, product_id: value })}
            disabled={isVariantSubmitting}
          >
            <SelectTrigger className="h-12">
              <SelectValue placeholder="Select a product" />
            </SelectTrigger>
            <SelectContent>
              {products.map((product) => (
                <SelectItem key={product.id} value={product.id}>
                  {product.name}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>
        <div>
          <Label htmlFor="variant-flavor">Flavor Name</Label>
          <Input
            id="variant-flavor"
            value={variantForm.flavor_name}
            onChange={(e) => setVariantForm({ ...variantForm, flavor_name: e.target.value })}
            disabled={isVariantSubmitting}
            className="h-12"
          />
        </div>
        <div>
          <Label htmlFor="variant-nic">Nicotine Strength</Label>
          <Input
            id="variant-nic"
            value={variantForm.nic_strength}
            onChange={(e) => setVariantForm({ ...variantForm, nic_strength: e.target.value })}
            disabled={isVariantSubmitting}
            className="h-12"
          />
        </div>
        <div>
          <Label htmlFor="variant-packaging">Packaging</Label>
          <Input
            id="variant-packaging"
            value={variantForm.packaging}
            onChange={(e) => setVariantForm({ ...variantForm, packaging: e.target.value })}
            disabled={isVariantSubmitting}
            className="h-12"
          />
        </div>
      </FormDialog>

      <ManufacturerFormModal
        open={showManufacturerModal}
        onOpenChange={setShowManufacturerModal}
        onSuccess={handleManufacturerSuccess}
        manufacturer={editingManufacturer || undefined}
        categories={categories}
      />
    </div>
  );
}
