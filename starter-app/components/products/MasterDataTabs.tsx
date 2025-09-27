"use client";

import { useState, useEffect, useTransition } from "react";
import { Plus, Edit, Trash2, Loader2 } from "lucide-react";
import { Tabs } from "@/components/ui/tabs";
import { OvalTabsList, OvalTab } from "@/components/ui/oval-tabs";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { toast } from "sonner";
import ManufacturerFormModal from "./ManufacturerFormModal";
import {
  getBrands, createBrand, updateBrand, deleteBrand,
  getManufacturers, createManufacturer, updateManufacturer, deleteManufacturer,
  getProductGroups, createProductGroup, updateProductGroup, deleteProductGroup,
  getProductSubGroups, createProductSubGroup, updateProductSubGroup, deleteProductSubGroup,
  getProductVariants, createProductVariant, updateProductVariant, deleteProductVariant
} from "@/app/(protected)/master/products/master-data/actions";
import { getCategories, getProducts } from "@/app/(protected)/master/products/actions";

interface BaseEntity {
  id: string;
  name: string;
  is_active?: boolean;
  created_at: string;
  updated_at?: string;
}

interface ProductGroup extends BaseEntity {
  category_id: string;
  categories?: { name: string }[];
}

interface ProductSubGroup extends BaseEntity {
  group_id: string;
  product_groups?: { name: string }[];
}

interface ProductVariant {
  id: string;
  name: string;
  product_id: string;
  sku?: string;
  is_active: boolean;
  created_at: string;
  updated_at?: string;
  products?: { name: string }[];
}

interface Category {
  id: string;
  name: string;
}

interface Product {
  id: string;
  name: string;
}

export default function MasterDataTabs() {
  const [activeTab, setActiveTab] = useState("manufacturers");
  const [isPending, startTransition] = useTransition();
  
  // Data states
  const [brands, setBrands] = useState<BaseEntity[]>([]);
  const [manufacturers, setManufacturers] = useState<BaseEntity[]>([]);
  const [productGroups, setProductGroups] = useState<ProductGroup[]>([]);
  const [productSubGroups, setProductSubGroups] = useState<ProductSubGroup[]>([]);
  const [productVariants, setProductVariants] = useState<ProductVariant[]>([]);
  const [categories, setCategories] = useState<Category[]>([]);
  const [products, setProducts] = useState<Product[]>([]);
  
  // Form states
  const [editingId, setEditingId] = useState<string | null>(null);
  const [showAddForm, setShowAddForm] = useState(false);
  const [loading, setLoading] = useState(true);

  // Modal states
  const [manufacturerModalOpen, setManufacturerModalOpen] = useState(false);
  const [editingManufacturer, setEditingManufacturer] = useState<any>(null);

  useEffect(() => {
    loadData();
  }, [activeTab]);

  const loadData = async () => {
    try {
      setLoading(true);
      
      // Load categories and products for dropdowns
      if (activeTab === "groups" || activeTab === "subgroups" || activeTab === "variants") {
        const [categoriesData, productsData] = await Promise.all([
          getCategories(),
          getProducts()
        ]);
        setCategories(categoriesData);
        setProducts(productsData);
      }
      
      // Load specific data based on active tab
      switch (activeTab) {
        case "brands":
          const brandsData = await getBrands();
          setBrands(brandsData);
          break;
        case "manufacturers":
          const manufacturersData = await getManufacturers();
          setManufacturers(manufacturersData);
          break;
        case "groups":
          const groupsData = await getProductGroups();
          setProductGroups(groupsData);
          break;
        case "subgroups":
          const subGroupsData = await getProductSubGroups();
          setProductSubGroups(subGroupsData);
          break;
        case "variants":
          const variantsData = await getProductVariants();
          setProductVariants(variantsData);
          break;
      }
    } catch {
      toast.error("Failed to load data");
    } finally {
      setLoading(false);
    }
  };

  const handleCreate = async (formData: FormData) => {
    startTransition(async () => {
      let result;
      
      switch (activeTab) {
        case "brands":
          result = await createBrand(formData);
          break;
        case "manufacturers":
          result = await createManufacturer(formData);
          break;
        case "groups":
          result = await createProductGroup(formData);
          break;
        case "subgroups":
          result = await createProductSubGroup(formData);
          break;
        case "variants":
          result = await createProductVariant(formData);
          break;
        default:
          return;
      }
      
      if (result?.ok) {
        toast.success(`${activeTab.slice(0, -1)} created successfully`);
        setShowAddForm(false);
        loadData();
      } else {
        toast.error(result?.message || `Failed to create ${activeTab.slice(0, -1)}`);
      }
    });
  };

  const handleUpdate = async (id: string, formData: FormData) => {
    startTransition(async () => {
      let result;
      
      switch (activeTab) {
        case "brands":
          result = await updateBrand(id, formData);
          break;
        case "manufacturers":
          result = await updateManufacturer(id, formData);
          break;
        case "groups":
          result = await updateProductGroup(id, formData);
          break;
        case "subgroups":
          result = await updateProductSubGroup(id, formData);
          break;
        case "variants":
          result = await updateProductVariant(id, formData);
          break;
        default:
          return;
      }
      
      if (result?.ok) {
        toast.success(`${activeTab.slice(0, -1)} updated successfully`);
        setEditingId(null);
        loadData();
      } else {
        toast.error(result?.message || `Failed to update ${activeTab.slice(0, -1)}`);
      }
    });
  };

  const handleDelete = async (id: string, name: string) => {
    if (!confirm(`Are you sure you want to delete "${name}"?`)) return;
    
    startTransition(async () => {
      let result;
      
      switch (activeTab) {
        case "brands":
          result = await deleteBrand(id);
          break;
        case "manufacturers":
          result = await deleteManufacturer(id);
          break;
        case "groups":
          result = await deleteProductGroup(id);
          break;
        case "subgroups":
          result = await deleteProductSubGroup(id);
          break;
        case "variants":
          result = await deleteProductVariant(id);
          break;
        default:
          return;
      }
      
      if (result?.ok) {
        toast.success(`${activeTab.slice(0, -1)} deleted successfully`);
        loadData();
      } else {
        toast.error(result?.message || `Failed to delete ${activeTab.slice(0, -1)}`);
      }
    });
  };

  const renderAddForm = () => {
    // Manufacturers use modal, not inline form
    if (activeTab === "manufacturers") {
      return null;
    }

    return (
      <div className="bg-gray-50 p-4 rounded-lg mb-6">
        <h3 className="text-sm font-medium text-gray-900 mb-3">Add New {activeTab.slice(0, -1)}</h3>
        <form onSubmit={(e) => {
          e.preventDefault();
          const formData = new FormData(e.currentTarget);
          handleCreate(formData);
        }} className="space-y-3">
          {renderFormFields()}
          <div className="flex gap-2">
            <Button type="submit" variant="outline" size="sm" disabled={isPending}>
              {isPending && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
              Create
            </Button>
            <Button type="button" variant="outline" size="sm" onClick={() => setShowAddForm(false)}>
              Cancel
            </Button>
          </div>
        </form>
      </div>
    );
  };

  const renderFormFields = (item?: any) => {
    switch (activeTab) {
      case "manufacturers":
        // Manufacturers use modal form, not inline
        return null;
      case "brands":
      case "manufacturers":
        return (
          <>
            <Input
              name="name"
              placeholder="Name"
              defaultValue={item?.name}
              required
              className="text-sm"
            />
            <label className="flex items-center gap-2 text-sm">
              <input
                type="checkbox"
                name="is_active"
                defaultChecked={item?.is_active ?? true}
                className="rounded"
              />
              Active
            </label>
          </>
        );
      case "groups":
        return (
          <>
            <Input
              name="name"
              placeholder="Group Name"
              defaultValue={item?.name}
              required
              className="text-sm"
            />
            <Select name="category_id" defaultValue={item?.category_id}>
              <SelectTrigger className="text-sm">
                <SelectValue placeholder="Select Category" />
              </SelectTrigger>
              <SelectContent>
                {categories.map((category) => (
                  <SelectItem key={category.id} value={category.id}>
                    {category.name}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
            <label className="flex items-center gap-2 text-sm">
              <input
                type="checkbox"
                name="is_active"
                defaultChecked={item?.is_active ?? true}
                className="rounded"
              />
              Active
            </label>
          </>
        );
      case "subgroups":
        return (
          <>
            <Input
              name="name"
              placeholder="Sub-Group Name"
              defaultValue={item?.name}
              required
              className="text-sm"
            />
            <Select name="group_id" defaultValue={item?.group_id}>
              <SelectTrigger className="text-sm">
                <SelectValue placeholder="Select Group" />
              </SelectTrigger>
              <SelectContent>
                {productGroups.map((group) => (
                  <SelectItem key={group.id} value={group.id}>
                    {group.name}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
            <label className="flex items-center gap-2 text-sm">
              <input
                type="checkbox"
                name="is_active"
                defaultChecked={item?.is_active ?? true}
                className="rounded"
              />
              Active
            </label>
          </>
        );
      case "variants":
        return (
          <>
            <Input
              name="name"
              placeholder="Variant Name"
              defaultValue={item?.name}
              required
              className="text-sm"
            />
            <Select name="product_id" defaultValue={item?.product_id}>
              <SelectTrigger className="text-sm">
                <SelectValue placeholder="Select Product" />
              </SelectTrigger>
              <SelectContent>
                {products.map((product) => (
                  <SelectItem key={product.id} value={product.id}>
                    {product.name}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
            <Input
              name="sku"
              placeholder="SKU (optional)"
              defaultValue={item?.sku}
              className="text-sm"
            />
          </>
        );
    }
  };

  const renderTable = () => {
    let data: any[] = [];
    
    switch (activeTab) {
      case "brands":
        data = brands;
        break;
      case "manufacturers":
        data = manufacturers;
        break;
      case "groups":
        data = productGroups;
        break;
      case "subgroups":
        data = productSubGroups;
        break;
      case "variants":
        data = productVariants;
        break;
    }

    if (loading) {
      return (
        <div className="space-y-3">
          {[...Array(5)].map((_, i) => (
            <div key={i} className="h-12 bg-gray-200 rounded animate-pulse"></div>
          ))}
        </div>
      );
    }

    return (
      <div className="overflow-x-auto">
        <table className="min-w-full divide-y divide-gray-200">
          <thead className="bg-gray-50">
            <tr>
              <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Name
              </th>
              {(activeTab === "groups" || activeTab === "subgroups" || activeTab === "variants") && (
                <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  {activeTab === "groups" ? "Category" : activeTab === "subgroups" ? "Group" : "Product"}
                </th>
              )}
              {activeTab === "variants" && (
                <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  SKU
                </th>
              )}
              {activeTab !== "variants" && (
                <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Status
                </th>
              )}
              <th className="px-4 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                Actions
              </th>
            </tr>
          </thead>
          <tbody className="bg-white divide-y divide-gray-200">
            {data.length === 0 ? (
              <tr>
                <td colSpan={5} className="px-4 py-8 text-center text-gray-500">
                  No {activeTab} found
                </td>
              </tr>
            ) : (
              data.map((item) => (
                <tr key={item.id} className="hover:bg-gray-50">
                  {editingId === item.id ? (
                    <td colSpan={5} className="px-4 py-4">
                      <form onSubmit={(e) => {
                        e.preventDefault();
                        const formData = new FormData(e.currentTarget);
                        handleUpdate(item.id, formData);
                      }} className="flex items-center gap-2 flex-wrap">
                        {renderFormFields(item)}
                        <div className="flex gap-1">
                          <Button type="submit" variant="outline" size="sm" disabled={isPending}>
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
                        </div>
                      </form>
                    </td>
                  ) : (
                    <>
                      <td className="px-4 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                        {item.name}
                      </td>
                      {(activeTab === "groups" || activeTab === "subgroups" || activeTab === "variants") && (
                        <td className="px-4 py-4 whitespace-nowrap text-sm text-gray-500">
                          {activeTab === "groups" && item.categories?.[0]?.name}
                          {activeTab === "subgroups" && item.product_groups?.[0]?.name}
                          {activeTab === "variants" && item.products?.[0]?.name}
                        </td>
                      )}
                      {activeTab === "variants" && (
                        <td className="px-4 py-4 whitespace-nowrap text-sm text-gray-500">
                          {item.sku || "—"}
                        </td>
                      )}
                      {activeTab !== "variants" && (
                        <td className="px-4 py-4 whitespace-nowrap">
                          <span
                            className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${
                              item.is_active
                                ? "bg-green-100 text-green-800"
                                : "bg-red-100 text-red-800"
                            }`}
                          >
                            {item.is_active ? "Active" : "Inactive"}
                          </span>
                        </td>
                      )}
                      <td className="px-4 py-4 whitespace-nowrap text-right text-sm font-medium">
                        <div className="flex items-center justify-end gap-1">
                          <Button
                            size="sm"
                            variant="outline"
                            onClick={() => {
                              if (activeTab === "manufacturers") {
                                setEditingManufacturer(item);
                                setManufacturerModalOpen(true);
                              } else {
                                setEditingId(item.id);
                              }
                            }}
                            disabled={isPending}
                          >
                            <Edit className="h-4 w-4" />
                          </Button>
                          <Button
                            size="sm"
                            variant="outline"
                            onClick={() => handleDelete(item.id, item.name)}
                            disabled={isPending}
                          >
                            <Trash2 className="h-4 w-4" />
                          </Button>
                        </div>
                      </td>
                    </>
                  )}
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>
    );
  };

  return (
    <div className="bg-white shadow rounded-lg p-6">
      <div className="flex items-center justify-between mb-6">
        <h2 className="text-lg font-medium text-gray-900">Master Data</h2>
        <Button 
          onClick={() => {
            if (activeTab === "manufacturers") {
              setEditingManufacturer(null);
              setManufacturerModalOpen(true);
            } else {
              setShowAddForm(true);
            }
          }}
          disabled={activeTab !== "manufacturers" && showAddForm}
          size="default"
          className="bg-blue-600 hover:bg-blue-700 text-white shadow-sm border-0 px-4 py-2 h-9 font-medium"
        >
          <Plus className="h-4 w-4 mr-2" />
          Add {activeTab.slice(0, -1)}
        </Button>
      </div>
      
      <Tabs value={activeTab} onValueChange={setActiveTab} className="space-y-6">
        <div className="flex items-center justify-between">
          <OvalTabsList size="md" className="w-auto">
            <OvalTab value="manufacturers" size="md">
              <svg className="h-4 w-4 opacity-80 data-[state=active]:opacity-100" viewBox="0 0 24 24" aria-hidden="true">
                <path fill="currentColor" d="M12 2L2 7v10c0 5.55 3.84 9.74 9 11 5.16-1.26 9-5.45 9-11V7l-10-5z"/>
              </svg>
              <span>Manufacturers</span>
            </OvalTab>
            <OvalTab value="brands" size="md">
              <span className="h-4 w-4 rounded-sm border border-border opacity-80 data-[state=active]:opacity-100" aria-hidden="true" />
              <span>Brands</span>
            </OvalTab>
            <OvalTab value="groups" size="md">
              <span className="h-4 w-4 rounded-sm border border-border opacity-80 data-[state=active]:opacity-100" aria-hidden="true" />
              <span>Groups</span>
            </OvalTab>
            <OvalTab value="subgroups" size="md">
              <span className="h-4 w-4 rounded-sm border border-border opacity-80 data-[state=active]:opacity-100" aria-hidden="true" />
              <span>Sub-Groups</span>
            </OvalTab>
            <OvalTab value="variants" size="md">
              <span className="h-4 w-4 rounded-sm border border-border opacity-80 data-[state=active]:opacity-100" aria-hidden="true" />
              <span>Variants</span>
            </OvalTab>
          </OvalTabsList>
        </div>
        
        <div className="space-y-4">
          {showAddForm && renderAddForm()}
          {renderTable()}
        </div>
      </Tabs>

      <ManufacturerFormModal
        open={manufacturerModalOpen}
        onOpenChange={(open) => {
          setManufacturerModalOpen(open);
          if (!open) {
            setEditingManufacturer(null);
          }
        }}
        manufacturer={editingManufacturer}
        onSuccess={() => {
          setManufacturerModalOpen(false);
          setEditingManufacturer(null);
          loadData();
        }}
      />
    </div>
  );
}