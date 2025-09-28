'use client';

import { useCallback, useEffect, useState } from 'react';
import { User, Package, Calculator, CheckCircle, XCircle, Clock, FileText, MapPin, Edit } from 'lucide-react';
import { createClient as createBrowserClient } from '@/lib/supabase/client';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { formatCurrency } from '@/lib/format';
import { toast } from 'sonner';
import ItemsGrid from './ItemsGrid';

interface OrderDetailProps {
  orderId: string;
  userRole?: string;
}

export default function OrderDetail({ orderId, userRole }: OrderDetailProps) {
  const supabase = createBrowserClient();
  const [order, setOrder] = useState<any>(null);
  const [manufacturer, setManufacturer] = useState<any>(null);
  const [orderItems, setOrderItems] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [approving, setApproving] = useState(false);
  const [rejecting, setRejecting] = useState(false);

  const fetchOrder = useCallback(async () => {
    try {
      setLoading(true);

      // Fetch order with manufacturer info
      const { data: orderData, error: orderError } = await supabase
        .from('orders')
        .select(`
          *,
          manufacturers:manufacturer_id(name)
        `)
        .eq('id', orderId)
        .single();

      if (orderError) throw orderError;
      setOrder(orderData);

      // Fetch manufacturer details
      if (orderData?.manufacturer_id) {
        const { data: mfrData } = await supabase
          .from('manufacturers')
          .select('*')
          .eq('id', orderData.manufacturer_id)
          .single();
        setManufacturer(mfrData);
      }

      // Fetch order items with product info
      const { data: itemsData, error: itemsError } = await supabase
        .from('order_items')
        .select(`
          *,
          products:product_id(name, sku)
        `)
        .eq('order_id', orderId)
        .order('created_at');

      if (itemsError) throw itemsError;
      setOrderItems(itemsData || []);

    } catch (error) {
      console.error('Failed to fetch order:', error);
      toast.error('Failed to load order details');
    } finally {
      setLoading(false);
    }
  }, [supabase, orderId]);

  useEffect(() => {
    fetchOrder();
  }, [fetchOrder]);

  const handleApprove = async () => {
    if (!canApprove) return;

    try {
      setApproving(true);

      const { error } = await supabase
        .from('orders')
        .update({
          status: 'approved',
          approved_by: (await supabase.auth.getUser()).data.user?.id,
          approved_at: new Date().toISOString()
        })
        .eq('id', orderId);

      if (error) throw error;

      toast.success('Order approved successfully');
      fetchOrder(); // Refresh data
    } catch (error) {
      console.error('Failed to approve order:', error);
      toast.error('Failed to approve order');
    } finally {
      setApproving(false);
    }
  };

  const handleReject = async () => {
    if (!canReject) return;

    try {
      setRejecting(true);

      const { error } = await supabase
        .from('orders')
        .update({
          status: 'rejected',
          approved_by: (await supabase.auth.getUser()).data.user?.id,
          approved_at: new Date().toISOString()
        })
        .eq('id', orderId);

      if (error) throw error;

      toast.success('Order rejected');
      fetchOrder(); // Refresh data
    } catch (error) {
      console.error('Failed to reject order:', error);
      toast.error('Failed to reject order');
    } finally {
      setRejecting(false);
    }
  };

  const getStatusBadge = (status: string) => {
    const variants = {
      draft: 'secondary',
      submitted: 'default',
      approved: 'outline',
      rejected: 'destructive',
      cancelled: 'outline'
    } as const;

    const icons = {
      draft: <Clock className="h-3 w-3" />,
      submitted: <Clock className="h-3 w-3" />,
      approved: <CheckCircle className="h-3 w-3" />,
      rejected: <XCircle className="h-3 w-3" />,
      cancelled: <XCircle className="h-3 w-3" />
    };

    return (
      <Badge variant={variants[status as keyof typeof variants] || 'secondary'} className="flex items-center gap-1">
        {icons[status as keyof typeof icons]}
        {status.charAt(0).toUpperCase() + status.slice(1)}
      </Badge>
    );
  };

  // Calculate totals
  const subtotal = orderItems.reduce((sum, item) => sum + (item.quantity * item.unit_price), 0);
  const taxAmount = orderItems.reduce((sum, item) => sum + (item.quantity * item.unit_price * item.tax_rate), 0);
  const discountAmount = orderItems.reduce((sum, item) => sum + (item.quantity * item.unit_price * item.discount_rate), 0);
  const total = subtotal + taxAmount - discountAmount + (order?.shipping_cost || 0);

  // Calculate QR summary
  const totalCases = orderItems.reduce((sum, item) => sum + Math.ceil(item.quantity / item.units_per_case), 0);
  const totalUniqueUnits = orderItems.reduce((sum, item) => sum + Math.ceil(item.quantity * 1.1), 0);

  // Role-based permissions
  const canApprove = userRole && ['hq_admin', 'power_user'].includes(userRole) && order?.status === 'submitted';
  const canReject = userRole && ['hq_admin', 'power_user'].includes(userRole) && order?.status === 'submitted';
  const canEdit = order?.status === 'draft';

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="text-gray-500">Loading order details...</div>
      </div>
    );
  }

  if (!order) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="text-red-500">Order not found</div>
      </div>
    );
  }

  return (
    <div className="container mx-auto py-6 max-w-7xl">
      {/* Header */}
      <div className="flex justify-between items-center mb-6">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">
            Order {order.order_no || `ORD-${order.id.slice(-8)}`}
          </h1>
          <p className="text-sm text-gray-500">
            Order details and approval workflow
          </p>
        </div>
        <div className="flex items-center gap-3">
          {getStatusBadge(order.status)}
          {canEdit && (
            <Button variant="outline" size="sm">
              <Edit className="h-4 w-4 mr-2" />
              Edit Order
            </Button>
          )}
        </div>
      </div>

      <div className="grid grid-cols-1 xl:grid-cols-3 gap-6">
        {/* Main Content - 2 columns */}
        <div className="xl:col-span-2 space-y-6">
          {/* Customer Information */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <User className="h-5 w-5" />
                Customer Information
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <Label className="text-sm font-medium text-muted-foreground">Customer Name</Label>
                  <p className="text-sm">{order.customer_name || 'Not specified'}</p>
                </div>
                <div>
                  <Label className="text-sm font-medium text-muted-foreground">Customer Email</Label>
                  <p className="text-sm">{order.customer_email || 'Not specified'}</p>
                </div>
              </div>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <Label className="text-sm font-medium text-muted-foreground">Contact Number</Label>
                  <p className="text-sm">{order.customer_contact_no || 'Not specified'}</p>
                </div>
                <div>
                  <Label className="text-sm font-medium text-muted-foreground">Manufacturer</Label>
                  <p className="text-sm">{manufacturer?.name || 'Unknown'}</p>
                </div>
              </div>
              <div>
                <Label className="text-sm font-medium text-muted-foreground flex items-center gap-2">
                  <MapPin className="h-4 w-4" />
                  Delivery Address
                </Label>
                <p className="text-sm">{order.delivery_address || 'Not specified'}</p>
              </div>
              {order.notes && (
                <div>
                  <Label className="text-sm font-medium text-muted-foreground">Order Notes</Label>
                  <p className="text-sm">{order.notes}</p>
                </div>
              )}
            </CardContent>
          </Card>

          {/* Order Items */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Package className="h-5 w-5" />
                Order Items
              </CardTitle>
            </CardHeader>
            <CardContent>
              {canEdit ? (
                <ItemsGrid
                  orderId={orderId}
                  orderManufacturerId={order.manufacturer_id}
                  onChanged={fetchOrder}
                />
              ) : (
                // Read-only view for approved/rejected orders
                <div className="space-y-3">
                  {orderItems.map((item: any) => (
                    <Card key={item.id} className="bg-muted/30">
                      <CardContent className="p-4">
                        <div className="flex justify-between items-start">
                          <div>
                            <h4 className="font-medium">{item.products?.name || 'Unknown Product'}</h4>
                            <p className="text-sm text-muted-foreground">{item.products?.sku}</p>
                            <div className="flex gap-4 mt-2 text-sm">
                              <span>Qty: {item.quantity}</span>
                              <span>Units/Case: {item.units_per_case}</span>
                              <span>Price: {formatCurrency(item.unit_price)}</span>
                            </div>
                            <div className="flex gap-4 mt-1 text-sm">
                              <span>Cases: {Math.ceil(item.quantity / item.units_per_case)}</span>
                              <span>Unique Units: {Math.ceil(item.quantity * 1.1)}</span>
                              <span>Total: {formatCurrency(item.quantity * item.unit_price)}</span>
                            </div>
                            {(item.lucky_draw_on || item.redeem_on) && (
                              <div className="flex gap-2 mt-2">
                                {item.lucky_draw_on && <Badge variant="outline" className="text-xs">Lucky Draw</Badge>}
                                {item.redeem_on && <Badge variant="outline" className="text-xs">Redeem</Badge>}
                              </div>
                            )}
                          </div>
                        </div>
                      </CardContent>
                    </Card>
                  ))}
                </div>
              )}
            </CardContent>
          </Card>
        </div>

        {/* Sidebar */}
        <div className="space-y-6">
          {/* Order Summary */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Calculator className="h-5 w-5" />
                Order Summary
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="flex justify-between">
                <span className="text-sm">Order Reference</span>
                <Badge variant="outline">{order.order_no || `ORD-${order.id.slice(-8)}`}</Badge>
              </div>

              <div className="h-px bg-border" />

              <div className="space-y-2">
                <div className="flex justify-between text-sm">
                  <span>Subtotal</span>
                  <span>{formatCurrency(subtotal)}</span>
                </div>
                <div className="flex justify-between text-sm">
                  <span>Tax</span>
                  <span>{formatCurrency(taxAmount)}</span>
                </div>
                <div className="flex justify-between text-sm text-green-600">
                  <span>Discount</span>
                  <span>-{formatCurrency(discountAmount)}</span>
                </div>
                <div className="flex justify-between text-sm">
                  <span>Shipping</span>
                  <span>{formatCurrency(order.shipping_cost || 0)}</span>
                </div>
              </div>

              <div className="h-px bg-border" />

              <div className="flex justify-between font-medium">
                <span>Total</span>
                <span>{formatCurrency(total)}</span>
              </div>

              <div className="h-px bg-border" />

              <div className="space-y-2">
                <div className="flex justify-between text-sm">
                  <span className="flex items-center gap-1">
                    <Package className="h-3 w-3" />
                    Total Cases
                  </span>
                  <span>{totalCases}</span>
                </div>
                <div className="flex justify-between text-sm">
                  <span className="flex items-center gap-1">
                    <Package className="h-3 w-3" />
                    Unique Units
                  </span>
                  <span>{totalUniqueUnits}</span>
                </div>
              </div>

              {/* Status Information */}
              <div className="h-px bg-border" />
              <div className="space-y-2">
                <div className="flex justify-between text-sm">
                  <span>Status</span>
                  {getStatusBadge(order.status)}
                </div>
                <div className="flex justify-between text-sm">
                  <span>Created</span>
                  <span>{new Date(order.created_at).toLocaleDateString()}</span>
                </div>
                {order.approved_at && (
                  <div className="flex justify-between text-sm">
                    <span>Approved</span>
                    <span>{new Date(order.approved_at).toLocaleDateString()}</span>
                  </div>
                )}
              </div>
            </CardContent>
          </Card>

          {/* Approval Actions */}
          {(canApprove || canReject) && order.status === 'submitted' && (
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <FileText className="h-5 w-5" />
                  Approval Actions
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-3">
                <Button
                  onClick={handleApprove}
                  disabled={approving}
                  className="w-full"
                  variant="primary"
                >
                  <CheckCircle className="h-4 w-4 mr-2" />
                  {approving ? 'Approving...' : 'Approve Order'}
                </Button>

                <Button
                  onClick={handleReject}
                  disabled={rejecting}
                  className="w-full"
                  variant="destructive"
                >
                  <XCircle className="h-4 w-4 mr-2" />
                  {rejecting ? 'Rejecting...' : 'Reject Order'}
                </Button>

                <div className="text-xs text-muted-foreground space-y-1">
                  <p>• Approve: Order will be processed for fulfillment</p>
                  <p>• Reject: Order will be returned to draft status</p>
                </div>
              </CardContent>
            </Card>
          )}
        </div>
      </div>
    </div>
  );
}

// Missing Label import
import { Label } from '@/components/ui/label';