import TabBar from "@/components/layout/TabBar";
import { getPageTabs } from "@/lib/tabs";

export default function ProductVariants() {
  const tabs = getPageTabs("/master/products");
  
  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-gray-900">Products</h1>
        <p className="mt-1 text-sm text-gray-500">
          Manage product categories, groups, sub-types, items, and variants
        </p>
      </div>
      
      <TabBar tabs={tabs} basePath="/master/products" />
      
      <div className="bg-white shadow rounded-lg p-6">
        <h2 className="text-lg font-medium text-gray-900 mb-4">Variants</h2>
        <p className="text-gray-600">
          This is the Variants tab content. Manage product variants here.
        </p>
        <div className="mt-4 p-4 bg-blue-50 rounded-md">
          <p className="text-blue-800 text-sm">
            <strong>Navigation:</strong> Click on different tabs above to switch between Categories, Groups, Sub‑Types, Items, and Variants.
          </p>
        </div>
      </div>
    </div>
  );
}