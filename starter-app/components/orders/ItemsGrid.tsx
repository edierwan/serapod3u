'use client';

import { useState, useEffect } from 'react';
import { Plus } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { formatCurrency } from '@/lib/format';
import { createClient } from '@/lib/supabase/client';
import { toast } from 'sonner';
import type { OrderItem } from '@/lib/types/orders';

interface Product {
  id: string;
  name: string;
  sku?: string;
  manufacturer_id: string;
  is_active: boolean;
  manufacturer_name?: string;
}

interface ItemsGridProps {
  orderId: string;
  orderManufacturerId: string;
  onChanged: () => void;
}

interface NewItemForm {
  product_id: string;
  variant_id: string | null;
  quantity: number;
  unit_price: number;
  discount_rate: number;
  tax_rate: number;
}

export default function ItemsGrid({
  orderId,
  orderManufacturerId,
  onChanged
}: ItemsGridProps) {
  const [orderItems, setOrderItems] = useState<OrderItem[]>([]);
  const [products, setProducts] = useState<Product[]>([]);
  const [showAddForm, setShowAddForm] = useState(false);
  const [adding, setAdding] = useState(false);
  const [newItem, setNewItem] = useState<NewItemForm>({
    product_id: '',
    variant_id: null,
    quantity: 1,
    unit_price: 0,
    discount_rate: 0,
    tax_rate: 0
  });

  // Load products and order items
  useEffect(() => {
    const loadData = async () => {
      const supabase = createClient();

      // Load active products
      const { data: productsData } = await supabase
        .from('products')
        .select('id,name,manufacturer_id,is_active')
        .eq('is_active', true);

      setProducts(productsData || []);

      // Load order items
      const { data: itemsData } = await supabase
        .from('order_items')
        .select(`
          *,
          products:product_id(name)
        `)
        .eq('order_id', orderId);

      const transformedItems = (itemsData || []).map((item: any) => ({
        ...item,
        product_name: item.products?.name || 'Unknown Product'
      }));

      setOrderItems(transformedItems);
    };

    loadData();
  }, [orderId]);

  const handleAddItem = async () => {
    if (!newItem.product_id || newItem.quantity <= 0 || newItem.unit_price < 0) {
      toast.error('Please fill in all required fields');
      return;
    }

    try {
      setAdding(true);
      const supabase = createClient();

      const { error } = await supabase
        .from('order_items')
        .insert({
          order_id: orderId,
          product_id: newItem.product_id,
          variant_id: newItem.variant_id || null,
          quantity: newItem.quantity,
          unit_price: newItem.unit_price,
          discount_rate: newItem.discount_rate,
          tax_rate: newItem.tax_rate
        });

      if (error) {
        // Handle specific error messages
        if (error.message.includes('not active')) {
          toast.error('Product is inactive — pick another product.');
        } else if (error.message.includes('manufacturer mismatch') || error.message.includes('does not match')) {
          toast.error(`This order is locked to this supplier. Choose a product from the same supplier.`);
        } else {
          toast.error(`Failed to add item: ${error.message}`);
        }
        return;
      }

      toast.success('Item added successfully');
      setShowAddForm(false);
      setNewItem({
        product_id: '',
        variant_id: null,
        quantity: 1,
        unit_price: 0,
        discount_rate: 0,
        tax_rate: 0
      });
      onChanged();
    } catch (error) {
      console.error('Failed to add item:', error);
      toast.error('Failed to add item');
    } finally {
      setAdding(false);
    }
  };

  // Filter products by order manufacturer
  const allowedProducts = products.filter(p => p.manufacturer_id === orderManufacturerId);
  const canAddItems = allowedProducts.length > 0;

  return (
    <Card>
      <CardHeader>
        <div className="flex justify-between items-center">
          <CardTitle>Order Items</CardTitle>
          <Button
            type="button"
            onClick={() => setShowAddForm(true)}
            disabled={!canAddItems}
            variant="outline"
            size="sm"
            title={!canAddItems ? `No active products from this supplier.` : undefined}
          >
            <Plus className="w-4 h-4 mr-2" />
            Add Item
          </Button>
        </div>
      </CardHeader>
      <CardContent>
        {orderItems.length === 0 && !showAddForm ? (
          <div className="text-center py-8 text-gray-500">
            No items in this order yet.
          </div>
        ) : (
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Product</TableHead>
                <TableHead>Variant</TableHead>
                <TableHead className="text-right">Qty</TableHead>
                <TableHead className="text-right">Unit Price</TableHead>
                <TableHead className="text-right">Discount</TableHead>
                <TableHead className="text-right">Tax</TableHead>
                <TableHead className="text-right">Total</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {orderItems.map((item) => (
                <TableRow key={item.id}>
                  <TableCell className="font-medium">{item.product_name}</TableCell>
                  <TableCell>{item.variant_name}</TableCell>
                  <TableCell className="text-right">{item.quantity}</TableCell>
                  <TableCell className="text-right">{formatCurrency(item.unit_price)}</TableCell>
                  <TableCell className="text-right">{item.discount_rate}%</TableCell>
                  <TableCell className="text-right">{item.tax_rate}%</TableCell>
                  <TableCell className="text-right font-medium">
                    {formatCurrency(item.line_total || 0)}
                  </TableCell>
                </TableRow>
              ))}

              {showAddForm && (
                <TableRow className="border-t-2 border-blue-200 bg-blue-50">
                  <TableCell>
                    <Select
                      value={newItem.product_id}
                      onValueChange={(value) => setNewItem({ ...newItem, product_id: value, variant_id: null })}
                    >
                      <SelectTrigger className="w-full">
                        <SelectValue placeholder="Select product" />
                      </SelectTrigger>
                      <SelectContent>
                        {allowedProducts.map((product) => (
                          <SelectItem key={product.id} value={product.id}>
                            {product.name}
                          </SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                  </TableCell>
                  <TableCell>
                    <span className="text-sm text-gray-500">Variant (optional)</span>
                  </TableCell>
                  <TableCell>
                    <Input
                      type="number"
                      min="1"
                      value={newItem.quantity}
                      onChange={(e) => setNewItem({ ...newItem, quantity: parseInt(e.target.value) || 1 })}
                      className="w-20"
                    />
                  </TableCell>
                  <TableCell>
                    <Input
                      type="number"
                      min="0"
                      step="0.01"
                      value={newItem.unit_price}
                      onChange={(e) => setNewItem({ ...newItem, unit_price: parseFloat(e.target.value) || 0 })}
                      className="w-28"
                    />
                  </TableCell>
                  <TableCell>
                    <Input
                      type="number"
                      min="0"
                      max="100"
                      value={newItem.discount_rate}
                      onChange={(e) => setNewItem({ ...newItem, discount_rate: parseFloat(e.target.value) || 0 })}
                      className="w-20"
                    />
                  </TableCell>
                  <TableCell>
                    <Input
                      type="number"
                      min="0"
                      max="100"
                      value={newItem.tax_rate}
                      onChange={(e) => setNewItem({ ...newItem, tax_rate: parseFloat(e.target.value) || 0 })}
                      className="w-20"
                    />
                  </TableCell>
                  <TableCell>
                    <div className="flex space-x-2">
                      <Button
                        type="button"
                        size="sm"
                        onClick={handleAddItem}
                        disabled={adding}
                      >
                        {adding ? 'Adding...' : 'Add'}
                      </Button>
                      <Button
                        type="button"
                        variant="outline"
                        size="sm"
                        onClick={() => setShowAddForm(false)}
                      >
                        Cancel
                      </Button>
                    </div>
                  </TableCell>
                </TableRow>
              )}
            </TableBody>
          </Table>
        )}

        {!canAddItems && (
          <div className="mt-4 p-4 bg-yellow-50 border border-yellow-200 rounded-md">
            <p className="text-sm text-yellow-800">
              <strong>No active products from this supplier.</strong> Adjust existing lines or create a new order to add different products.
            </p>
          </div>
        )}
      </CardContent>
    </Card>
  );
}