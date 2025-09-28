-- Create RPC function to create order from first item
-- This automatically derives manufacturer_id from the product

create or replace function public.create_order_from_first_item(
  p_product_id uuid,
  p_quantity integer,
  p_unit_price numeric,
  p_discount_rate numeric default 0,
  p_tax_rate numeric default 0,
  p_shipping_cost numeric default 0,
  p_order_discount numeric default 0
)
returns json
language plpgsql
security definer
as $$
declare
  v_order_id uuid;
  v_manufacturer_id uuid;
  v_product_active boolean;
  v_order_item_id uuid;
  v_line_subtotal numeric;
  v_line_discount numeric;
  v_line_tax numeric;
  v_line_total numeric;
begin
  -- Validate product exists and is active
  select manufacturer_id, is_active into v_manufacturer_id, v_product_active
  from products
  where id = p_product_id;

  if not found then
    return json_build_object('success', false, 'error', 'Product not found');
  end if;

  if not v_product_active then
    return json_build_object('success', false, 'error', 'Product is not active');
  end if;

  -- Create the order
  insert into orders (
    status,
    manufacturer_id,
    shipping_cost,
    discount_amount,
    subtotal,
    tax_amount,
    total
  )
  values (
    'draft',
    v_manufacturer_id,
    p_shipping_cost,
    p_order_discount,
    0, -- Will be calculated by trigger
    0, -- Will be calculated by trigger
    0  -- Will be calculated by trigger
  )
  returning id into v_order_id;

  -- Calculate line amounts
  v_line_subtotal := p_quantity * p_unit_price;
  v_line_discount := v_line_subtotal * (p_discount_rate / 100);
  v_line_tax := (v_line_subtotal - v_line_discount) * (p_tax_rate / 100);
  v_line_total := v_line_subtotal - v_line_discount + v_line_tax;

  -- Create the order item
  insert into order_items (
    order_id,
    product_id,
    quantity,
    unit_price,
    discount_rate,
    tax_rate,
    line_subtotal,
    line_discount,
    line_tax,
    line_total
  )
  values (
    v_order_id,
    p_product_id,
    p_quantity,
    p_unit_price,
    p_discount_rate,
    p_tax_rate,
    v_line_subtotal,
    v_line_discount,
    v_line_tax,
    v_line_total
  )
  returning id into v_order_item_id;

  -- Update order totals (this will trigger the calculation)
  perform update_order_totals(v_order_id);

  return json_build_object(
    'success', true,
    'order_id', v_order_id,
    'order_item_id', v_order_item_id
  );
end;
$$;

-- Grant execute permission to authenticated users
grant execute on function public.create_order_from_first_item(uuid, integer, numeric, numeric, numeric, numeric, numeric) to authenticated;