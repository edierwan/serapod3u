import { Suspense } from 'react';
import OrderDetail from '@/components/orders/OrderDetail';

interface OrderDetailPageProps {
  params: Promise<{
    id: string;
  }>;
}

export default async function OrderDetailPage({ params }: OrderDetailPageProps) {
  const { id } = await params;

  return (
    <div className="container mx-auto py-6">
      <Suspense fallback={<div>Loading...</div>}>
        <OrderDetail orderId={id} />
      </Suspense>
    </div>
  );
}