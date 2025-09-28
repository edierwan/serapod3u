import Link from 'next/link';
import { Plus } from 'lucide-react';
import TabBar from "@/components/layout/TabBar";
import { getPageTabs } from "@/lib/tabs";
import { Button } from "@/components/ui/button";

export default function Orders() {
  const tabs = getPageTabs("/orders");

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Orders</h1>
          <p className="mt-1 text-sm text-gray-500">
            Create, approve, and manage orders
          </p>
        </div>
        <Link href="/orders/new">
          <Button>
            <Plus className="w-4 h-4 mr-2" />
            Create Order
          </Button>
        </Link>
      </div>

      <TabBar tabs={tabs}>
        <div className="bg-white shadow rounded-lg p-6">
          <h2 className="text-lg font-medium text-gray-900 mb-4">Orders</h2>
          <p className="text-gray-600">
            Select a tab above to view orders for approval or browse the complete list.
          </p>
        </div>
      </TabBar>
    </div>
  );
}