-- 0100_rewards_points_system.sql
-- Phase: Rewards (Points)
-- Generated: 2025-09-28
-- Purpose: Create rewards/points system tables, views, and RLS policies

-- Points rules table: defines how many points a shop earns for a case activation scan per product/variant/campaign
create table if not exists public.points_rules (
    id uuid primary key default gen_random_uuid(),
    campaign_id uuid, -- nullable for default rules
    product_id uuid references public.products(id) on delete cascade,
    variant_id uuid references public.product_variants(id) on delete cascade, -- nullable for product-level rules
    points_per_case integer not null check (points_per_case > 0),
    is_active boolean not null default true,
    created_at timestamp with time zone not null default now(),
    updated_at timestamp with time zone not null default now(),
    created_by uuid default public.current_user_id(),
    updated_by uuid,
    -- Ensure uniqueness: can't have multiple rules for same scope
    unique (campaign_id, product_id, variant_id)
);

-- Shop points ledger: append-only ledger of each earn/redeem event
create table if not exists public.shop_points_ledger (
    id uuid primary key default gen_random_uuid(),
    shop_id uuid not null references public.shops(id) on delete cascade,
    points integer not null, -- positive for earn, negative for redeem
    source text not null check (source in ('scan_case', 'manual_adjust', 'redeem')),
    reference_type text not null check (reference_type in ('case_code', 'redemption_id', 'manual')),
    reference_id text not null, -- case code, redemption uuid, or manual description
    product_id uuid references public.products(id) on delete set null,
    variant_id uuid references public.product_variants(id) on delete set null,
    campaign_id uuid, -- nullable
    status text not null default 'completed' check (status in ('completed', 'reversed')),
    created_at timestamp with time zone not null default now(),
    created_by uuid default public.current_user_id()
);

-- Rewards catalog: managed by HQ Admin/Power User
create table if not exists public.rewards_catalog (
    id uuid primary key default gen_random_uuid(),
    title text not null,
    description text,
    points_cost integer not null check (points_cost > 0),
    category text not null, -- e.g., 'electronics', 'voucher', etc.
    image_key text, -- storage path in rewards bucket
    is_active boolean not null default true,
    is_featured boolean not null default false,
    validity_start timestamp with time zone,
    validity_end timestamp with time zone,
    created_at timestamp with time zone not null default now(),
    updated_at timestamp with time zone not null default now(),
    created_by uuid default public.current_user_id(),
    updated_by uuid,
    -- Ensure validity dates make sense
    check (validity_end is null or validity_start is null or validity_start <= validity_end)
);

-- Rewards redemptions: when a shop redeems a catalog item
create table if not exists public.rewards_redemptions (
    id uuid primary key default gen_random_uuid(),
    shop_id uuid not null references public.shops(id) on delete cascade,
    catalog_id uuid not null references public.rewards_catalog(id) on delete cascade,
    points_cost_snapshot integer not null, -- snapshot at redemption time
    status text not null default 'pending' check (status in ('pending', 'processing', 'fulfilled', 'cancelled')),
    fulfillment_data jsonb, -- optional data for fulfillment
    created_at timestamp with time zone not null default now(),
    updated_at timestamp with time zone not null default now(),
    created_by uuid default public.current_user_id(),
    updated_by uuid
);

-- Optional: Points activities for non-scan earn types
create table if not exists public.points_activities (
    id uuid primary key default gen_random_uuid(),
    name text not null,
    description text,
    activity_type text not null check (activity_type in ('daily', 'weekly', 'one_time', 'repeatable')),
    points_reward integer not null check (points_reward > 0),
    max_completions integer, -- null for unlimited
    reset_period_days integer, -- for daily/weekly resets
    is_active boolean not null default true,
    created_at timestamp with time zone not null default now(),
    updated_at timestamp with time zone not null default now(),
    created_by uuid default public.current_user_id(),
    updated_by uuid
);

-- Optional: Shop activity progress tracking
create table if not exists public.shop_activity_progress (
    id uuid primary key default gen_random_uuid(),
    shop_id uuid not null references public.shops(id) on delete cascade,
    activity_id uuid not null references public.points_activities(id) on delete cascade,
    completions_count integer not null default 0,
    last_completed_at timestamp with time zone,
    reset_at timestamp with time zone, -- next reset time
    created_at timestamp with time zone not null default now(),
    updated_at timestamp with time zone not null default now(),
    unique (shop_id, activity_id)
);

-- View for current points balance per shop
create or replace view public.v_shop_points_balance as
select
    shop_id,
    sum(points) as current_balance,
    count(*) as total_transactions,
    max(created_at) as last_transaction_at
from public.shop_points_ledger
where status = 'completed'
group by shop_id;

-- Indexes for performance
create index if not exists idx_points_rules_active on public.points_rules(is_active) where is_active = true;
create index if not exists idx_points_rules_scope on public.points_rules(campaign_id, product_id, variant_id);
create index if not exists idx_shop_points_ledger_shop on public.shop_points_ledger(shop_id);
create index if not exists idx_shop_points_ledger_created on public.shop_points_ledger(created_at desc);
create index if not exists idx_shop_points_ledger_reference on public.shop_points_ledger(reference_type, reference_id);
create index if not exists idx_rewards_catalog_active on public.rewards_catalog(is_active) where is_active = true;
create index if not exists idx_rewards_catalog_featured on public.rewards_catalog(is_featured) where is_featured = true;
create index if not exists idx_rewards_catalog_validity on public.rewards_catalog(validity_start, validity_end);
create index if not exists idx_rewards_redemptions_shop on public.rewards_redemptions(shop_id);
create index if not exists idx_rewards_redemptions_status on public.rewards_redemptions(status);
create index if not exists idx_points_activities_active on public.points_activities(is_active) where is_active = true;
create index if not exists idx_shop_activity_progress_shop on public.shop_activity_progress(shop_id);

-- Triggers for updated_at
create trigger set_updated_at_trg before update on public.points_rules for each row execute function public.set_updated_at();
create trigger set_updated_at_trg before update on public.rewards_catalog for each row execute function public.set_updated_at();
create trigger set_updated_at_trg before update on public.rewards_redemptions for each row execute function public.set_updated_at();
create trigger set_updated_at_trg before update on public.points_activities for each row execute function public.set_updated_at();
create trigger set_updated_at_trg before update on public.shop_activity_progress for each row execute function public.set_updated_at();

-- Triggers for updated_by
create trigger set_updated_by_trg before update on public.points_rules for each row execute function public.set_updated_by();
create trigger set_updated_by_trg before update on public.rewards_catalog for each row execute function public.set_updated_by();
create trigger set_updated_by_trg before update on public.rewards_redemptions for each row execute function public.set_updated_by();
create trigger set_updated_by_trg before update on public.points_activities for each row execute function public.set_updated_by();
create trigger set_updated_by_trg before update on public.shop_activity_progress for each row execute function public.set_updated_by();

-- Enable RLS
alter table public.points_rules enable row level security;
alter table public.shop_points_ledger enable row level security;
alter table public.rewards_catalog enable row level security;
alter table public.rewards_redemptions enable row level security;
alter table public.points_activities enable row level security;
alter table public.shop_activity_progress enable row level security;

-- RLS Policies

-- Points rules: HQ Admin/Power User can manage, others can read active ones
create policy "points_rules_admin_all" on public.points_rules
    to authenticated
    using (public.has_any_role(array['hq_admin', 'power_user']))
    with check (public.has_any_role(array['hq_admin', 'power_user']));

create policy "points_rules_read_active" on public.points_rules
    for select
    to authenticated
    using (is_active = true);

-- Shop points ledger: Shops can see their own, HQ can see all
create policy "shop_points_ledger_shop_own" on public.shop_points_ledger
    to authenticated
    using (shop_id in (
        select s.id from public.shops s
        where s.id::text = app.claim_uuid('shop_id')::text
    ));

create policy "shop_points_ledger_admin_all" on public.shop_points_ledger
    to authenticated
    using (public.has_any_role(array['hq_admin', 'power_user']))
    with check (public.has_any_role(array['hq_admin', 'power_user']));

-- Rewards catalog: HQ can manage, others can read active/valid ones
create policy "rewards_catalog_admin_all" on public.rewards_catalog
    to authenticated
    using (public.has_any_role(array['hq_admin', 'power_user']))
    with check (public.has_any_role(array['hq_admin', 'power_user']));

create policy "rewards_catalog_read_valid" on public.rewards_catalog
    for select
    to authenticated
    using (
        is_active = true
        and (validity_start is null or validity_start <= now())
        and (validity_end is null or validity_end >= now())
    );

-- Rewards redemptions: Shops can see their own, HQ can see all and manage
create policy "rewards_redemptions_shop_own" on public.rewards_redemptions
    to authenticated
    using (shop_id in (
        select s.id from public.shops s
        where s.id::text = app.claim_uuid('shop_id')::text
    ));

create policy "rewards_redemptions_admin_all" on public.rewards_redemptions
    to authenticated
    using (public.has_any_role(array['hq_admin', 'power_user']))
    with check (public.has_any_role(array['hq_admin', 'power_user']));

-- Points activities: HQ can manage, others can read active ones
create policy "points_activities_admin_all" on public.points_activities
    to authenticated
    using (public.has_any_role(array['hq_admin', 'power_user']))
    with check (public.has_any_role(array['hq_admin', 'power_user']));

create policy "points_activities_read_active" on public.points_activities
    for select
    to authenticated
    using (is_active = true);

-- Shop activity progress: Shops can see their own, HQ can see all
create policy "shop_activity_progress_shop_own" on public.shop_activity_progress
    to authenticated
    using (shop_id in (
        select s.id from public.shops s
        where s.id::text = app.claim_uuid('shop_id')::text
    ));

create policy "shop_activity_progress_admin_all" on public.shop_activity_progress
    to authenticated
    using (public.has_any_role(array['hq_admin', 'power_user']))
    with check (public.has_any_role(array['hq_admin', 'power_user']));

-- Grant permissions
grant select on public.v_shop_points_balance to authenticated;

-- Insert some seed data for testing
insert into public.points_rules (product_id, points_per_case) 
select p.id, 10 -- Default 10 points per case
from public.products p
where not exists (
    select 1 from public.points_rules pr 
    where pr.product_id = p.id and pr.variant_id is null and pr.campaign_id is null
)
limit 5; -- Only for first 5 products to avoid too much seed data

-- Insert sample rewards catalog
insert into public.rewards_catalog (title, description, points_cost, category, is_featured) values
('Gift Card RM50', 'Universal gift card worth RM50', 500, 'voucher', true),
('Wireless Earbuds', 'Premium wireless earbuds with noise cancellation', 1200, 'electronics', true),
('Coffee Voucher RM30', 'Coffee voucher for local cafes', 300, 'food', false),
('Phone Case', 'Protective phone case with screen protector', 150, 'accessories', false);

-- RPC Functions

-- Get current user's shop ID
create or replace function public.get_my_shop_id()
returns uuid
language sql
security definer
set search_path = public
stable
as $$
  select app.claim_uuid('shop_id');
$$;

-- Award points for case scan (idempotent per case_id + shop_id)
create or replace function public.award_points_for_scan(
  p_case_code text,
  p_shop_id uuid,
  p_product_id uuid default null,
  p_variant_id uuid default null,
  p_campaign_id uuid default null
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_points integer := 0;
  v_ledger_id uuid;
  v_existing_count integer;
begin
  -- Check if already awarded (idempotent)
  select count(*) into v_existing_count
  from public.shop_points_ledger
  where shop_id = p_shop_id
    and reference_type = 'case_code'
    and reference_id = p_case_code
    and source = 'scan_case'
    and status = 'completed';

  if v_existing_count > 0 then
    return jsonb_build_object('awarded', false, 'reason', 'already_awarded');
  end if;

  -- Find applicable points rule (most specific first)
  select points_per_case into v_points
  from public.points_rules
  where is_active = true
    and (campaign_id = p_campaign_id or campaign_id is null)
    and (product_id = p_product_id or product_id is null)
    and (variant_id = p_variant_id or variant_id is null)
  order by
    case when campaign_id = p_campaign_id then 1 else 0 end +
    case when product_id = p_product_id then 1 else 0 end +
    case when variant_id = p_variant_id then 1 else 0 end desc
  limit 1;

  if v_points is null or v_points = 0 then
    return jsonb_build_object('awarded', false, 'reason', 'no_rule_found');
  end if;

  -- Insert ledger entry
  insert into public.shop_points_ledger (
    shop_id, points, source, reference_type, reference_id,
    product_id, variant_id, campaign_id, status
  ) values (
    p_shop_id, v_points, 'scan_case', 'case_code', p_case_code,
    p_product_id, p_variant_id, p_campaign_id, 'completed'
  ) returning id into v_ledger_id;

  return jsonb_build_object(
    'awarded', true,
    'points', v_points,
    'ledger_id', v_ledger_id
  );
end;
$$;

-- Redeem reward (atomic transaction)
create or replace function public.redeem_reward(
  p_shop_id uuid,
  p_catalog_id uuid,
  p_user_id uuid
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_catalog public.rewards_catalog;
  v_current_balance integer := 0;
  v_redemption_id uuid;
  v_ledger_id uuid;
begin
  -- Get catalog item
  select * into v_catalog
  from public.rewards_catalog
  where id = p_catalog_id
    and is_active = true
    and (validity_start is null or validity_start <= now())
    and (validity_end is null or validity_end >= now());

  if not found then
    raise exception 'Reward not available' using errcode = '22023';
  end if;

  -- Get current balance
  select coalesce(current_balance, 0) into v_current_balance
  from public.v_shop_points_balance
  where shop_id = p_shop_id;

  if v_current_balance < v_catalog.points_cost then
    raise exception 'Insufficient points: have %%, need %%', v_current_balance, v_catalog.points_cost using errcode = '22023';
  end if;

  -- Insert redemption (pending)
  insert into public.rewards_redemptions (
    shop_id, catalog_id, points_cost_snapshot, status
  ) values (
    p_shop_id, p_catalog_id, v_catalog.points_cost, 'pending'
  ) returning id into v_redemption_id;

  -- Deduct points
  insert into public.shop_points_ledger (
    shop_id, points, source, reference_type, reference_id,
    status
  ) values (
    p_shop_id, -v_catalog.points_cost, 'redeem', 'redemption_id', v_redemption_id::text, 'completed'
  ) returning id into v_ledger_id;

  -- Update redemption with ledger reference (optional)
  update public.rewards_redemptions
  set fulfillment_data = jsonb_build_object('ledger_id', v_ledger_id)
  where id = v_redemption_id;

  return jsonb_build_object(
    'redemption_id', v_redemption_id,
    'points_deducted', v_catalog.points_cost,
    'new_balance', v_current_balance - v_catalog.points_cost
  );
end;
$$;