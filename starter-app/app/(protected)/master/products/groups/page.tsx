import TabBar from "@/components/layout/TabBar";
import { getPageTabs } from "@/lib/tabs";

export default function ProductGroups() {
  const tabs = getPageTabs("/master/products");
  
  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-gray-900">Products</h1>
        <p className="mt-1 text-sm text-gray-500">
          Manage product categories, groups, sub-types, items, and variants
        </p>
      </div>
      
      <TabBar tabs={tabs}>
        <div className="bg-white shadow rounded-lg p-6">
          <h2 className="text-lg font-medium text-gray-900 mb-4">Groups</h2>
          <p className="text-gray-600">
            This is the Groups tab content. Organize products into logical groups for better management.
          </p>
          <div className="mt-4 p-4 bg-indigo-50 rounded-md">
            <p className="text-indigo-800 text-sm">
              <strong>Active Tab:</strong> Groups - Define product groupings and hierarchical structures.
            </p>
          </div>
        </div>
      </TabBar>
    </div>
  );
}