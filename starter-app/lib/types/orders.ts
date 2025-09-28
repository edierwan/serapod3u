export type OrderStatus = 'draft' | 'submitted' | 'approved' | 'rejected' | 'cancelled';

export interface Order {
  id: string;
  order_no: string | null;
  status: OrderStatus;
  manufacturer_id: string;
  created_by: string | null;
  submitted_by: string | null;
  approved_by: string | null;
  approved_at: string | null;
  notes: string | null;
  created_at: string;
  updated_at: string;
  subtotal: number;
  discount_amount: number;
  tax_amount: number;
  shipping_cost: number;
  total: number;
  // Joined fields
  manufacturer_name?: string;
}

export interface OrderItem {
  id: string;
  order_id: string;
  product_id: string;
  variant_id: string | null;
  quantity: number;
  unit_price: number;
  discount_rate: number;
  tax_rate: number;
  // Joined fields
  product_name?: string;
  variant_name?: string;
  line_subtotal?: number;
  line_discount?: number;
  line_tax?: number;
  line_total?: number;
}

export interface OrderWithItems extends Order {
  items: OrderItem[];
}

export interface CreateOrderData {
  manufacturer_id: string;
  items: CreateOrderItemData[];
  shipping_cost?: number;
  discount_amount?: number;
  notes?: string;
}

export interface CreateOrderItemData {
  product_id: string;
  variant_id?: string | null;
  quantity: number;
  unit_price: number;
  discount_rate?: number;
  tax_rate?: number;
}

export interface UpdateOrderData {
  shipping_cost?: number;
  discount_amount?: number;
  notes?: string;
}

export interface UpdateOrderItemData {
  quantity?: number;
  unit_price?: number;
  discount_rate?: number;
  tax_rate?: number;
}