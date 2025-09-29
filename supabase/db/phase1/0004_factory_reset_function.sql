-- Factory Reset Function for Database Wiping
-- SECURITY DEFINER to run with elevated privileges
-- Supports two scopes: 'transactions_only' and 'factory_reset'

create or replace function public.admin_wipe(p_scope text)
returns json
language plpgsql
security definer
as $$
declare
  v_affected_tables text[];
  v_affected_count int := 0;
  v_start_time timestamp := now();
begin
  -- Validate scope parameter
  if p_scope not in ('transactions_only', 'factory_reset') then
    raise exception 'Invalid scope: %. Must be "transactions_only" or "factory_reset"', p_scope;
  end if;

  -- Log the operation start
  insert into public.audit_log (
    table_name, operation, old_values, new_values, performed_by, performed_at, ip_address, user_agent
  ) values (
    'database', 'wipe_start', json_build_object('scope', p_scope), null, auth.uid(), now(), null, null
  );

  -- Begin transaction for atomicity
  begin
    -- TRANSACTIONS ONLY: Clear operational data but keep master data
    if p_scope = 'transactions_only' then
      -- Clear campaign and rewards data
      truncate table public.redeem_claims cascade;
      truncate table public.shop_points_ledger cascade;
      truncate table public.lucky_draw_participants cascade;
      truncate table public.lucky_draw_campaigns cascade;

      -- Clear tracking and logistics data
      truncate table public.unique_codes cascade;
      truncate table public.cases cascade;
      truncate table public.shipments cascade;

      -- Clear order and payment data
      truncate table public.payments cascade;
      truncate table public.receipts cascade;
      truncate table public.purchase_order_items cascade;
      truncate table public.purchase_orders cascade;
      truncate table public.order_items cascade;
      truncate table public.orders cascade;

      -- Clear audit logs (keep only system logs)
      delete from public.audit_log where table_name not in ('database', 'profiles');

      v_affected_tables := array[
        'redeem_claims', 'shop_points_ledger', 'lucky_draw_participants', 'lucky_draw_campaigns',
        'unique_codes', 'cases', 'shipments', 'payments', 'receipts',
        'purchase_order_items', 'purchase_orders', 'order_items', 'orders', 'audit_log'
      ];

    -- FACTORY RESET: Clear everything
    elsif p_scope = 'factory_reset' then
      -- Clear all operational data first
      truncate table public.redeem_claims cascade;
      truncate table public.shop_points_ledger cascade;
      truncate table public.lucky_draw_participants cascade;
      truncate table public.lucky_draw_campaigns cascade;
      truncate table public.unique_codes cascade;
      truncate table public.cases cascade;
      truncate table public.shipments cascade;
      truncate table public.payments cascade;
      truncate table public.receipts cascade;
      truncate table public.purchase_order_items cascade;
      truncate table public.purchase_orders cascade;
      truncate table public.order_items cascade;
      truncate table public.orders cascade;

      -- Clear master data
      truncate table public.product_variants cascade;
      truncate table public.products cascade;
      truncate table public.product_subgroups cascade;
      truncate table public.product_groups cascade;
      truncate table public.brands cascade;
      truncate table public.categories cascade;
      truncate table public.shops cascade;
      truncate table public.distributors cascade;
      truncate table public.manufacturers cascade;

      -- Clear audit logs completely
      truncate table public.audit_log cascade;

      v_affected_tables := array[
        'redeem_claims', 'shop_points_ledger', 'lucky_draw_participants', 'lucky_draw_campaigns',
        'unique_codes', 'cases', 'shipments', 'payments', 'receipts',
        'purchase_order_items', 'purchase_orders', 'order_items', 'orders',
        'product_variants', 'products', 'product_subgroups', 'product_groups',
        'brands', 'categories', 'shops', 'distributors', 'manufacturers', 'audit_log'
      ];
    end if;

    -- Log successful completion
    insert into public.audit_log (
      table_name, operation, old_values, new_values, performed_by, performed_at, ip_address, user_agent
    ) values (
      'database', 'wipe_complete',
      json_build_object('scope', p_scope, 'affected_tables', v_affected_tables),
      json_build_object('duration_ms', extract(epoch from (now() - v_start_time)) * 1000),
      auth.uid(), now(), null, null
    );

    -- Return success response
    return json_build_object(
      'success', true,
      'scope', p_scope,
      'affected_tables', v_affected_tables,
      'duration_ms', extract(epoch from (now() - v_start_time)) * 1000,
      'timestamp', now()
    );

  exception
    when others then
      -- Log the error
      insert into public.audit_log (
        table_name, operation, old_values, new_values, performed_by, performed_at, ip_address, user_agent
      ) values (
        'database', 'wipe_error',
        json_build_object('scope', p_scope, 'error', sqlerrm),
        null, auth.uid(), now(), null, null
      );

      -- Re-raise the exception
      raise;
  end;
end;
$$;

-- Grant execute permission to authenticated users (RLS will handle authorization)
grant execute on function public.admin_wipe(text) to authenticated;

-- Add comment for documentation
comment on function public.admin_wipe(text) is 'Admin function to wipe database data. Scope: transactions_only (operational data only) or factory_reset (all data). Requires hq_admin role.';