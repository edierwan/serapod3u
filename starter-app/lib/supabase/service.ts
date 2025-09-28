
import 'server-only';
import { createClient } from "@supabase/supabase-js";

export function createServiceClient() {
  return createClient(
    process.env.SUPABASE_URL!,
    process.env.SUPABASE_SERVICE_ROLE_KEY!,
    { auth: { persistSession: false, autoRefreshToken: false } }
  );
}

// Create order from first item (matches SQL: returns UUID)
export async function createOrderFromFirstItem(input: {
  productId: string;
  quantity: number;
  unitPrice: number;
  discountRate?: number; // 0..1
  taxRate?: number;      // 0..1
  shippingCost?: number;
  orderDiscount?: number;
}): Promise<{ orderId: string }> {
  'use server';
  const s = createServiceClient();
  const { data, error } = await s.rpc('create_order_from_first_item', {
    p_product_id: input.productId,
    p_quantity: input.quantity,
    p_unit_price: input.unitPrice,
    p_discount_rate: input.discountRate ?? 0,
    p_tax_rate: input.taxRate ?? 0,
    p_shipping_cost: input.shippingCost ?? 0,
    p_order_discount: input.orderDiscount ?? 0
  });
  if (error) throw new Error(error.message);
  // Handle both UUID return and JSON return for compatibility
  if (typeof data === 'string') {
    return { orderId: data };
  } else if (data && typeof data === 'object' && 'order_id' in data) {
    return { orderId: data.order_id };
  }
  throw new Error('Invalid response from create_order_from_first_item');
}

// Create full order with customer info and multiple items
export async function createFullOrder(input: {
  customer_name: string;
  customer_email?: string;
  customer_contact_no?: string;
  delivery_address?: string;
  notes?: string;
  manufacturer_id: string | null;
  items: Array<{
    product_id: string;
    quantity: number;
    units_per_case: number;
    unit_price: number;
    discount_rate: number;
    tax_rate: number;
    lucky_draw_on: boolean;
    redeem_on: boolean;
  }>;
}): Promise<{ orderId: string }> {
  'use server';
  const s = createServiceClient();

  // Create the order header
  const { data: orderData, error: orderError } = await s
    .from('orders')
    .insert({
      customer_name: input.customer_name,
      customer_email: input.customer_email,
      customer_contact_no: input.customer_contact_no,
      delivery_address: input.delivery_address,
      notes: input.notes,
      manufacturer_id: input.manufacturer_id,
      status: 'draft'
    })
    .select('id')
    .single();

  if (orderError) throw new Error(orderError.message);

  // Add order items
  const itemsToInsert = input.items.map(item => ({
    order_id: orderData.id,
    product_id: item.product_id,
    quantity: item.quantity,
    units_per_case: item.units_per_case,
    unit_price: item.unit_price,
    discount_rate: item.discount_rate,
    tax_rate: item.tax_rate,
    lucky_draw_on: item.lucky_draw_on,
    redeem_on: item.redeem_on
  }));

  const { error: itemsError } = await s
    .from('order_items')
    .insert(itemsToInsert);

  if (itemsError) throw new Error(itemsError.message);

  return { orderId: orderData.id };
}

export async function addOrderItem(input: {
  orderId: string; productId: string; quantity: number;
  unitPrice: number; discountRate: number; taxRate: number;
}) {
  'use server';
  const s = createServiceClient();
  const { error } = await s.from('order_items').insert({
    order_id: input.orderId,
    product_id: input.productId,
    quantity: input.quantity,
    unit_price: input.unitPrice,
    discount_rate: input.discountRate,
    tax_rate: input.taxRate
  });
  if (error) throw new Error(error.message);
}

export async function updateOrderItem(id: string, patch: Partial<{
  quantity: number; unitPrice: number; discountRate: number; taxRate: number;
}>) {
  'use server';
  const s = createServiceClient();
  const { error } = await s.from('order_items').update({
    quantity: patch.quantity,
    unit_price: patch.unitPrice,
    discount_rate: patch.discountRate,
    tax_rate: patch.taxRate
  }).eq('id', id);
  if (error) throw new Error(error.message);
}

export async function deleteOrderItem(id: string) {
  'use server';
  const s = createServiceClient();
  const { error } = await s.from('order_items').delete().eq('id', id);
  if (error) throw new Error(error.message);
}

export async function updateOrderHeader(id: string, patch: Partial<{ shippingCost: number; orderDiscount: number }>) {
  'use server';
  const s = createServiceClient();
  const { error } = await s.from('orders').update({
    shipping_cost: patch.shippingCost,
    discount_amount: patch.orderDiscount
  }).eq('id', id);
  if (error) throw new Error(error.message);
}

export async function submitOrder(id: string) {
  'use server';
  const s = createServiceClient();
  const { error } = await s.from('orders').update({
    status: 'submitted', submitted_at: new Date().toISOString()
  }).eq('id', id);
  if (error) throw new Error(error.message);
}

export async function approveOrder(id: string) {
  'use server';
  const s = createServiceClient();
  const { error } = await s.from('orders').update({
    status: 'approved', approved_at: new Date().toISOString()
  }).eq('id', id);
  if (error) throw new Error(error.message);
}
