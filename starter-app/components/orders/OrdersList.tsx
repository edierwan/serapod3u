'use client';

import { useState, useEffect, useCallback } from 'react';
import Link from 'next/link';
import { Plus, Eye } from 'lucide-react';
import { createClient } from '@/lib/supabase/client';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table';
import { formatCurrency } from '@/lib/format';
import type { Order } from '@/lib/types/orders';

interface OrdersListProps {
  status?: string;
  dateFrom?: string;
  dateTo?: string;
  manufacturerId?: string;
}

export default function OrdersList({ status, dateFrom, dateTo, manufacturerId }: OrdersListProps) {
  const [orders, setOrders] = useState<Order[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetchOrders = useCallback(async () => {
    try {
      setLoading(true);
      const supabase = createClient();

      let query = supabase
        .from('orders')
        .select(`
          *,
          manufacturers:manufacturer_id(name)
        `)
        .order('created_at', { ascending: false });

      if (status && status !== 'all') {
        query = query.eq('status', status);
      }

      if (dateFrom) {
        query = query.gte('created_at', dateFrom);
      }

      if (dateTo) {
        query = query.lte('created_at', dateTo);
      }

      if (manufacturerId) {
        query = query.eq('manufacturer_id', manufacturerId);
      }

      const { data, error } = await query;

      if (error) throw error;

      // Transform the data to include manufacturer name
      const transformedOrders = (data || []).map(order => ({
        ...order,
        manufacturer_name: order.manufacturers?.name || 'Unknown'
      }));

      setOrders(transformedOrders);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to fetch orders');
    } finally {
      setLoading(false);
    }
  }, [status, dateFrom, dateTo, manufacturerId]);

  useEffect(() => {
    fetchOrders().catch(console.error);
  }, [fetchOrders]);

  function getStatusBadge(status: string) {
    const variants = {
      draft: 'secondary',
      submitted: 'default',
      approved: 'outline',
      rejected: 'destructive',
      cancelled: 'outline'
    } as const;

    return (
      <Badge variant={variants[status as keyof typeof variants] || 'secondary'}>
        {status.charAt(0).toUpperCase() + status.slice(1)}
      </Badge>
    );
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="text-gray-500">Loading orders...</div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="text-red-500">Error: {error}</div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h2 className="text-lg font-medium text-gray-900">Orders</h2>
          <p className="text-sm text-gray-500">
            Manage and track all orders
          </p>
        </div>
        <Link href="/orders/new">
          <Button>
            <Plus className="w-4 h-4 mr-2" />
            Create Order
          </Button>
        </Link>
      </div>

      {orders.length === 0 ? (
        <Card>
          <CardContent className="flex flex-col items-center justify-center py-12">
            <div className="text-gray-400 mb-4">
              <Plus className="w-12 h-12" />
            </div>
            <h3 className="text-lg font-medium text-gray-900 mb-2">No orders found</h3>
            <p className="text-gray-500 text-center mb-6">
              Get started by creating your first order.
            </p>
            <Link href="/orders/new">
              <Button>
                <Plus className="w-4 h-4 mr-2" />
                Create Order
              </Button>
            </Link>
          </CardContent>
        </Card>
      ) : (
        <Card>
          <CardHeader>
            <CardTitle>Orders ({orders.length})</CardTitle>
          </CardHeader>
          <CardContent>
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Order No</TableHead>
                  <TableHead>Status</TableHead>
                  <TableHead>Manufacturer</TableHead>
                  <TableHead>Created</TableHead>
                  <TableHead className="text-right">Total</TableHead>
                  <TableHead>Actions</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {orders.map((order) => (
                  <TableRow key={order.id}>
                    <TableCell className="font-medium">
                      {order.order_no || `ORD-${order.id.slice(-8)}`}
                    </TableCell>
                    <TableCell>{getStatusBadge(order.status)}</TableCell>
                    <TableCell>{order.manufacturer_name}</TableCell>
                    <TableCell>{new Date(order.created_at).toLocaleDateString()}</TableCell>
                    <TableCell className="text-right font-medium">{formatCurrency(order.total)}</TableCell>
                    <TableCell>
                      <Link href={`/orders/${order.id}`}>
                        <Button variant="outline" size="sm">
                          <Eye className="w-4 h-4 mr-2" />
                          View
                        </Button>
                      </Link>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </CardContent>
        </Card>
      )}
    </div>
  );
}