import TabBar from "@/components/layout/TabBar";
import { getPageTabs } from "@/lib/tabs";

export default function OrdersApproval() {
  const tabs = getPageTabs("/orders");
  
  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-gray-900">Orders</h1>
        <p className="mt-1 text-sm text-gray-500">
          Create, approve, and manage orders
        </p>
      </div>
      
      <TabBar tabs={tabs}>
        <div className="bg-white shadow rounded-lg p-6">
          <h2 className="text-lg font-medium text-gray-900 mb-4">Order Approval</h2>
          <p className="text-gray-600">
            This is the Approval tab content. Review and approve pending orders here.
          </p>
          <div className="mt-4 p-4 bg-yellow-50 rounded-md">
            <p className="text-yellow-800 text-sm">
              <strong>Active Tab:</strong> Approval - Review orders that require approval before processing.
            </p>
          </div>
          
          <div className="mt-6">
            <h3 className="text-base font-medium text-gray-900 mb-3">Pending Approvals</h3>
            <div className="bg-gray-50 rounded-lg p-4">
              <p className="text-sm text-gray-600">No pending orders for approval at this time.</p>
            </div>
          </div>
        </div>
      </TabBar>
    </div>
  );
}