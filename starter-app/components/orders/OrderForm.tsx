'use client';

import { useState, useEffect, useTransition } from 'react';
import { useRouter } from 'next/navigation';
import { User, Package, Calculator, Save, Send, Plus, Trash2, MapPin } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Switch } from '@/components/ui/switch';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { useProductData } from '@/lib/hooks/useProductData';
import { formatCurrency } from '@/lib/format';
import { toast } from 'sonner';
import { createOrder } from '@/lib/actions/orders';

interface OrderItem {
  id: string;
  product_id: string;
  product_name: string;
  quantity: number;
  units_per_case: number;
  unit_price: number;
  discount_rate: number;
  tax_rate: number;
  lucky_draw_on: boolean;
  redeem_on: boolean;
  line_total: number;
  cases_count: number;
  unique_units: number;
}

interface CustomerInfo {
  name: string;
  email: string;
  contact_no: string;
  delivery_address: string;
  notes: string;
}

interface OrderFormProps {
  orderId?: string;
  initialOrder?: any;
  onSave?: (data: any) => Promise<void>;
}

export default function OrderForm({ orderId, initialOrder, onSave }: OrderFormProps) {
  const router = useRouter();
  const { products, loading: productsLoading } = useProductData();

  const [customerInfo, setCustomerInfo] = useState<CustomerInfo>({
    name: initialOrder?.customer_name || '',
    email: initialOrder?.customer_email || '',
    contact_no: initialOrder?.customer_contact_no || '',
    delivery_address: initialOrder?.delivery_address || '',
    notes: initialOrder?.notes || ''
  });

  const [orderItems, setOrderItems] = useState<OrderItem[]>([]);
  const [isPending, startTransition] = useTransition();
  const [selectedProductId, setSelectedProductId] = useState('');
  const [manufacturerId, setManufacturerId] = useState<string | null>(null);
  const [manufacturerName, setManufacturerName] = useState('');

  // Calculate totals
  const subtotal = orderItems.reduce((sum, item) => sum + item.line_total, 0);
  const taxAmount = orderItems.reduce((sum, item) => sum + (item.line_total * item.tax_rate), 0);
  const discountAmount = orderItems.reduce((sum, item) => sum + (item.line_total * item.discount_rate), 0);
  const shippingCost = 0; // Could be made configurable
  const total = subtotal + taxAmount - discountAmount + shippingCost;

  // Calculate QR codes summary
  const totalCases = orderItems.reduce((sum, item) => sum + item.cases_count, 0);
  const totalUniqueUnits = orderItems.reduce((sum, item) => sum + item.unique_units, 0);

  useEffect(() => {
    if (initialOrder?.order_items) {
      // Load existing order items
      const items = initialOrder.order_items.map((item: any) => ({
        id: item.id,
        product_id: item.product_id,
        product_name: item.products?.name || 'Unknown Product',
        quantity: item.quantity,
        units_per_case: item.units_per_case,
        unit_price: item.unit_price,
        discount_rate: item.discount_rate,
        tax_rate: item.tax_rate,
        lucky_draw_on: item.lucky_draw_on,
        redeem_on: item.redeem_on,
        line_total: item.quantity * item.unit_price,
        cases_count: Math.ceil(item.quantity / item.units_per_case),
        unique_units: Math.ceil(item.quantity * 1.1) // 10% buffer
      }));
      setOrderItems(items);
      setManufacturerId(initialOrder.manufacturer_id);
      setManufacturerName(initialOrder.manufacturers?.name || `Manufacturer ${initialOrder.manufacturer_id?.slice(-8)}`);
    }
  }, [initialOrder]);

  const addProduct = () => {
    if (!selectedProductId) {
      toast.error('Please select a product');
      return;
    }

    const product = products.find(p => p.id === selectedProductId);
    if (!product) return;

    // Manufacturer gate: first product sets manufacturer, subsequent must match
    if (manufacturerId && product.manufacturer_id !== manufacturerId) {
      toast.error('All products must be from the same manufacturer');
      return;
    }

    if (!manufacturerId) {
      setManufacturerId(product.manufacturer_id);
      setManufacturerName(`Manufacturer ${product.manufacturer_id.slice(-8)}`);
    }

    const newItem: OrderItem = {
      id: crypto.randomUUID(),
      product_id: selectedProductId,
      product_name: product.name,
      quantity: 1,
      units_per_case: 100, // Default, could be configurable
      unit_price: product.price || 0,
      discount_rate: 0,
      tax_rate: 0,
      lucky_draw_on: false,
      redeem_on: false,
      line_total: product.price || 0,
      cases_count: 1,
      unique_units: Math.ceil(1 * 1.1)
    };

    setOrderItems([...orderItems, newItem]);
    setSelectedProductId('');
  };

  const updateItem = (id: string, updates: Partial<OrderItem>) => {
    setOrderItems(items =>
      items.map(item => {
        if (item.id === id) {
          const updated = { ...item, ...updates };
          // Recalculate derived values
          updated.line_total = updated.quantity * updated.unit_price;
          updated.cases_count = Math.ceil(updated.quantity / updated.units_per_case);
          updated.unique_units = Math.ceil(updated.quantity * 1.1); // 10% buffer
          return updated;
        }
        return item;
      })
    );
  };

  const removeItem = (id: string) => {
    setOrderItems(items => items.filter(item => item.id !== id));

    // If removing last item, reset manufacturer
    if (orderItems.length === 1) {
      setManufacturerId(null);
      setManufacturerName('');
    }
  };

  const handleSave = async () => {
    if (!customerInfo.name.trim()) {
      toast.error('Customer name is required');
      return;
    }

    if (orderItems.length === 0) {
      toast.error('At least one product is required');
      return;
    }

    try {
      const orderData = {
        customer_name: customerInfo.name,
        customer_email: customerInfo.email,
        customer_contact_no: customerInfo.contact_no,
        delivery_address: customerInfo.delivery_address,
        notes: customerInfo.notes,
        manufacturer_id: manufacturerId,
        items: orderItems.map(item => ({
          product_id: item.product_id,
          quantity: item.quantity,
          units_per_case: item.units_per_case,
          unit_price: item.unit_price,
          discount_rate: item.discount_rate,
          tax_rate: item.tax_rate,
          lucky_draw_on: item.lucky_draw_on,
          redeem_on: item.redeem_on
        }))
      };

      if (onSave) {
        await onSave(orderData);
      }

      toast.success('Order saved successfully');
    } catch (error) {
      toast.error('Failed to save order');
      console.error(error);
    }
  };

  const handleSubmit = async () => {
    if (!customerInfo.name.trim()) {
      toast.error('Customer name is required');
      return;
    }

    if (orderItems.length === 0) {
      toast.error('At least one product is required');
      return;
    }

    const formData = new FormData();
    formData.append('customer_name', customerInfo.name);
    formData.append('customer_email', customerInfo.email);
    formData.append('customer_contact_no', customerInfo.contact_no);
    formData.append('delivery_address', customerInfo.delivery_address);
    formData.append('notes', customerInfo.notes);
    formData.append('manufacturer_id', manufacturerId || '');
    formData.append('items', JSON.stringify(orderItems.map(item => ({
      product_id: item.product_id,
      quantity: item.quantity,
      units_per_case: item.units_per_case,
      unit_price: item.unit_price,
      discount_rate: item.discount_rate,
      tax_rate: item.tax_rate,
      lucky_draw_on: item.lucky_draw_on,
      redeem_on: item.redeem_on
    }))));

    startTransition(async () => {
      const result = await createOrder(formData);

      if (result.success) {
        toast.success('Order submitted successfully');
        router.push(`/orders/${result.orderId}`);
      } else {
        toast.error(result.error || 'Failed to submit order');
      }
    });
  };

  const availableProducts = products.filter(product =>
    !manufacturerId || product.manufacturer_id === manufacturerId
  );

  if (productsLoading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="text-gray-500">Loading products...</div>
      </div>
    );
  }

  return (
    <div className="container mx-auto py-6 max-w-7xl">
      {/* Header */}
      <div className="flex justify-between items-center mb-6">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">
            {orderId ? 'Edit Order' : 'Create New Order'}
          </h1>
          <p className="text-sm text-gray-500">
            {orderId ? 'Update order details and items' : 'Create a new order with customer information and products'}
          </p>
        </div>
        <Badge variant="secondary">Draft</Badge>
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
                  <Label htmlFor="customer_name">Customer Name *</Label>
                  <Input
                    id="customer_name"
                    value={customerInfo.name}
                    onChange={(e) => setCustomerInfo({ ...customerInfo, name: e.target.value })}
                    placeholder="Enter customer name"
                  />
                </div>
                <div>
                  <Label htmlFor="customer_email">Customer Email</Label>
                  <Input
                    id="customer_email"
                    type="email"
                    value={customerInfo.email}
                    onChange={(e) => setCustomerInfo({ ...customerInfo, email: e.target.value })}
                    placeholder="Enter customer email"
                  />
                </div>
              </div>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <Label htmlFor="customer_contact">Contact Number</Label>
                  <Input
                    id="customer_contact"
                    value={customerInfo.contact_no}
                    onChange={(e) => setCustomerInfo({ ...customerInfo, contact_no: e.target.value })}
                    placeholder="Enter contact number"
                  />
                </div>
                <div></div>
              </div>
              <div>
                <Label htmlFor="delivery_address" className="flex items-center gap-2">
                  <MapPin className="h-4 w-4" />
                  Delivery Address
                </Label>
                <Textarea
                  id="delivery_address"
                  value={customerInfo.delivery_address}
                  onChange={(e) => setCustomerInfo({ ...customerInfo, delivery_address: e.target.value })}
                  placeholder="Enter delivery address"
                  rows={3}
                />
              </div>
              <div>
                <Label htmlFor="notes">Order Notes</Label>
                <Textarea
                  id="notes"
                  value={customerInfo.notes}
                  onChange={(e) => setCustomerInfo({ ...customerInfo, notes: e.target.value })}
                  placeholder="Additional notes for this order"
                  rows={3}
                />
              </div>
            </CardContent>
          </Card>

          {/* Product Selection */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Package className="h-5 w-5" />
                Product Selection
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              {/* Add Product Section */}
              <div className="flex gap-2">
                <div className="flex-1">
                  <Select value={selectedProductId} onValueChange={setSelectedProductId}>
                    <SelectTrigger>
                      <SelectValue placeholder="Select a product to add" />
                    </SelectTrigger>
                    <SelectContent>
                      {availableProducts.map((product) => (
                        <SelectItem key={product.id} value={product.id}>
                          {product.name}
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>
                <Button onClick={addProduct} disabled={!selectedProductId}>
                  <Plus className="h-4 w-4 mr-2" />
                  Add Product
                </Button>
              </div>

              {/* Manufacturer Info */}
              {manufacturerName && (
                <div className="bg-muted/30 p-3 rounded-md">
                  <p className="text-sm text-muted-foreground">
                    <strong>Manufacturer:</strong> {manufacturerName}
                  </p>
                  <p className="text-xs text-muted-foreground mt-1">
                    All products must be from this manufacturer
                  </p>
                </div>
              )}

              {/* Order Items */}
              {orderItems.length === 0 ? (
                <div className="text-center py-8 text-muted-foreground">
                  <Package className="h-12 w-12 mx-auto mb-4 opacity-50" />
                  <p>No products selected yet</p>
                  <p className="text-sm">Add your first product above</p>
                </div>
              ) : (
                <div className="space-y-3">
                  {orderItems.map((item) => (
                    <Card key={item.id} className="bg-muted/30">
                      <CardContent className="p-4">
                        <div className="grid grid-cols-1 md:grid-cols-4 gap-4 items-end">
                          {/* Product Info */}
                          <div className="md:col-span-2">
                            <Label className="text-sm font-medium">{item.product_name}</Label>
                            <div className="grid grid-cols-2 gap-2 mt-2">
                              <div>
                                <Label className="text-xs">Quantity</Label>
                                <Input
                                  type="number"
                                  min="1"
                                  value={item.quantity}
                                  onChange={(e) => updateItem(item.id, { quantity: parseInt(e.target.value) || 1 })}
                                />
                              </div>
                              <div>
                                <Label className="text-xs">Units/Case</Label>
                                <Input
                                  type="number"
                                  min="1"
                                  value={item.units_per_case}
                                  onChange={(e) => updateItem(item.id, { units_per_case: parseInt(e.target.value) || 1 })}
                                />
                              </div>
                            </div>
                          </div>

                          {/* Pricing */}
                          <div>
                            <Label className="text-xs">Unit Price</Label>
                            <Input
                              type="number"
                              min="0"
                              step="0.01"
                              value={item.unit_price}
                              onChange={(e) => updateItem(item.id, { unit_price: parseFloat(e.target.value) || 0 })}
                            />
                          </div>

                          {/* Actions */}
                          <div className="flex items-center gap-2">
                            <Button
                              variant="outline"
                              size="sm"
                              onClick={() => removeItem(item.id)}
                            >
                              <Trash2 className="h-4 w-4" />
                            </Button>
                          </div>
                        </div>

                        {/* Calculations */}
                        <div className="grid grid-cols-4 gap-4 mt-4 pt-4 border-t">
                          <div>
                            <Label className="text-xs text-muted-foreground">Cases</Label>
                            <p className="text-sm font-medium">{item.cases_count}</p>
                          </div>
                          <div>
                            <Label className="text-xs text-muted-foreground">Unique Units</Label>
                            <p className="text-sm font-medium">{item.unique_units}</p>
                          </div>
                          <div>
                            <Label className="text-xs text-muted-foreground">Line Total</Label>
                            <p className="text-sm font-medium">{formatCurrency(item.line_total)}</p>
                          </div>
                          <div className="flex items-center gap-2">
                            <div className="flex items-center space-x-2">
                              <Switch
                                checked={item.lucky_draw_on}
                                onCheckedChange={(checked) => updateItem(item.id, { lucky_draw_on: checked })}
                              />
                              <Label className="text-xs">Lucky Draw</Label>
                            </div>
                            <div className="flex items-center space-x-2">
                              <Switch
                                checked={item.redeem_on}
                                onCheckedChange={(checked) => updateItem(item.id, { redeem_on: checked })}
                              />
                              <Label className="text-xs">Redeem</Label>
                            </div>
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
                <Badge variant="outline">{orderId ? `ORD-${orderId.slice(-8)}` : 'New Order'}</Badge>
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
                  <span>{formatCurrency(shippingCost)}</span>
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
            </CardContent>
          </Card>

          {/* Order Actions */}
          <Card>
            <CardHeader>
              <CardTitle>Order Actions</CardTitle>
            </CardHeader>
            <CardContent className="space-y-3">
              <Button
                onClick={handleSave}
                disabled={isPending || !customerInfo.name.trim() || orderItems.length === 0}
                className="w-full"
              >
                <Save className="h-4 w-4 mr-2" />
                {isPending ? 'Saving...' : 'Save Draft'}
              </Button>

              <Button
                onClick={handleSubmit}
                disabled={isPending || !customerInfo.name.trim() || orderItems.length === 0}
                className="w-full"
                variant="primary"
              >
                <Send className="h-4 w-4 mr-2" />
                {isPending ? 'Submitting...' : 'Submit Order'}
              </Button>

              <div className="text-xs text-muted-foreground space-y-1">
                <p>• Save Draft: Save current progress without submitting</p>
                <p>• Submit Order: Finalize and send for approval</p>
              </div>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  );
}
