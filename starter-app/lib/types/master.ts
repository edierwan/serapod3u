// Domain types for master data entities
// These types represent the data structures used across the application

// Database row interfaces (matching Supabase schema)
export interface CategoryRow {
  id: string;
  name: string;
  description?: string;
  created_at?: string;
  updated_at?: string;
}

export interface BrandRow {
  id: string;
  name: string;
  category_id: string;
  created_at?: string;
  updated_at?: string;
}

export interface ProductGroupRow {
  id: string;
  name: string;
  category_id: string;
  brand_id?: string; // Note: This might be incorrect based on current usage
  is_active?: boolean;
  created_at?: string;
  updated_at?: string;
}

export interface ProductSubGroupRow {
  id: string;
  name: string;
  group_id: string;
  created_at?: string;
  updated_at?: string;
}

export interface ManufacturerRow {
  id: string;
  name: string;
  contact_person?: string;
  phone?: string;
  email?: string;
  address?: string;
  logo_url?: string;
  is_active?: boolean;
  address_line1?: string;
  address_line2?: string;
  city?: string;
  state_region?: string;
  postal_code?: string;
  country_code?: string;
  language_code?: string;
  currency_code?: string;
  tax_id?: string;
  registration_number?: string;
  support_email?: string;
  support_phone?: string;
  timezone?: string;
  website_url?: string;
  whatsapp?: string;
  notes?: string;
  created_at?: string;
  updated_at?: string;
}

export interface ProductRow {
  id: string;
  name: string;
  sku?: string;
  price?: number;
  status?: string;
  image_url?: string;
  manufacturer_id?: string;
  category_id?: string;
  brand_id?: string;
  group_id?: string;
  subgroup_id?: string;
  created_at?: string;
  updated_at?: string;
}

export interface ProductVariantRow {
  id: string;
  product_id: string;
  sku: string;
  flavor_name?: string;
  nic_strength?: string;
  packaging?: string;
  is_active?: boolean;
  created_at?: string;
  updated_at?: string;
}

// Domain types (with relations)
export type Category = CategoryRow;

export interface Brand extends BrandRow {
  category?: Category;
}

export interface ProductGroup extends ProductGroupRow {
  category?: Category;
  brand?: Brand;
}

// Query result types (with joined relations)
export interface ProductGroupWithCategory extends Omit<ProductGroupRow, 'category_id'> {
  category: Category;
}

export interface BrandWithCategory extends Omit<BrandRow, 'category_id'> {
  category: Category;
}

export interface ProductSubGroupWithGroup extends Omit<ProductSubGroupRow, 'group_id'> {
  group: ProductGroup;
}

export interface ProductVariantWithProduct extends Omit<ProductVariantRow, 'product_id'> {
  product: Product;
}

export interface ProductSubGroup extends ProductSubGroupRow {
  group?: ProductGroup;
}

export type Manufacturer = ManufacturerRow;

export interface Product extends ProductRow {
  category?: Category;
  brand?: Brand;
  group?: ProductGroup;
  sub_group?: ProductSubGroup;
  manufacturer?: Manufacturer;
}

export interface ProductVariant extends ProductVariantRow {
  product?: Product;
}

// Form types for create/edit operations
export interface CategoryForm {
  name: string;
  description: string;
}

export interface BrandForm {
  name: string;
  category_id: string;
}

export interface ProductGroupForm {
  name: string;
  category_id: string;
}

export interface ProductSubGroupForm {
  name: string;
  group_id: string;
}

export interface ProductVariantForm {
  product_id: string;
  flavor_name: string;
  nic_strength: string;
  packaging: string;
}

// Tab key union type for MasterDataTabs
export type TabKey = "categories" | "brands" | "groups" | "subgroups" | "variants" | "manufacturers" | "distributors";

// API response types
export interface ApiResponse<T> {
  ok: boolean;
  data?: T;
  message?: string;
  error?: string;
}