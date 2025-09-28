'use server';

import { createFullOrder as createFullOrderService } from '@/lib/supabase/service';

export async function createOrder(formData: FormData) {
  try {
    const customer_name = formData.get('customer_name') as string;
    const customer_email = formData.get('customer_email') as string;
    const customer_contact_no = formData.get('customer_contact_no') as string;
    const delivery_address = formData.get('delivery_address') as string;
    const notes = formData.get('notes') as string;
    const manufacturer_id = formData.get('manufacturer_id') as string;
    const items = JSON.parse(formData.get('items') as string);

    const result = await createFullOrderService({
      customer_name,
      customer_email,
      customer_contact_no,
      delivery_address,
      notes,
      manufacturer_id: manufacturer_id || null,
      items
    });

    return { success: true, orderId: result.orderId };
  } catch (error) {
    console.error('Failed to create order:', error);
    return { success: false, error: 'Failed to create order' };
  }
}