import { Suspense } from 'react';
import OrdersList from '@/components/orders/OrdersList';

interface OrdersListPageProps {
  searchParams: Promise<{
    status?: string;
    dateFrom?: string;
    dateTo?: string;
    manufacturerId?: string;
  }>;
}

export default async function OrdersListPage({ searchParams }: OrdersListPageProps) {
  const params = await searchParams;

  return (
    <div className="container mx-auto py-6">
      <Suspense fallback={<div>Loading...</div>}>
        <OrdersList
          status={params.status}
          dateFrom={params.dateFrom}
          dateTo={params.dateTo}
          manufacturerId={params.manufacturerId}
        />
      </Suspense>
    </div>
  );
}