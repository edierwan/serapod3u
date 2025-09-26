import TabBar from "@/components/layout/TabBar";
import { getPageTabs } from "@/lib/tabs";

export default function Orders() {
  const tabs = getPageTabs("/orders");
  
  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-gray-900">Orders</h1>
        <p className="mt-1 text-sm text-gray-500">
          Create, approve, and manage orders
        </p>
      </div>
      
      <TabBar tabs={tabs} basePath="/orders">
        <div className="bg-white shadow rounded-lg p-6">
          <h2 className="text-lg font-medium text-gray-900 mb-4">Create Orders</h2>
          <p className="text-gray-600">
            This is the Create tab content. Use the tabs above to navigate between:
            Create | Approval | List
          </p>
          <div className="mt-4 p-4 bg-green-50 rounded-md">
            <p className="text-green-800 text-sm">
              <strong>Active Tab:</strong> Create - This is where you would create new orders.
            </p>
          </div>
        </div>
      </TabBar>
    </div>
  );
}