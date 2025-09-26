// Product category constants for the enum public.product_category_type ('vape' | 'nonvape')
export const PRODUCT_CATEGORY_OPTIONS = [
  { value: "vape", label: "Vape" },
  { value: "nonvape", label: "NonVape" },
] as const;

export type ProductCategoryValue = (typeof PRODUCT_CATEGORY_OPTIONS)[number]["value"]; // 'vape' | 'nonvape'

// Mapping between enum values and category names in the database
export const CATEGORY_ENUM_TO_NAME_MAP: Record<ProductCategoryValue, string> = {
  vape: "Vape",
  nonvape: "Non-Vape"
} as const;

export const CATEGORY_NAME_TO_ENUM_MAP: Record<string, ProductCategoryValue> = {
  "Vape": "vape",
  "Non-Vape": "nonvape"
} as const;