--
-- PostgreSQL database dump
--

\restrict QdMMvEieMDDxnrtn6rUkLGDJvWdDxIIOXWuNWdyGTSozIzgoVsCNjmwH5suV3Lm

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.6

-- Started on 2025-09-26 23:28:18 +08

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 13 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- TOC entry 4398 (class 0 OID 0)
-- Dependencies: 13
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 141 (class 2615 OID 16540)
-- Name: storage; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA storage;


--
-- TOC entry 1447 (class 1247 OID 84439)
-- Name: app_role; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.app_role AS ENUM (
    'hq_admin',
    'distributor_admin',
    'shop_user'
);


--
-- TOC entry 1474 (class 1247 OID 57062)
-- Name: batch_priority_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.batch_priority_type AS ENUM (
    'normal',
    'high'
);


--
-- TOC entry 1471 (class 1247 OID 57053)
-- Name: batch_status_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.batch_status_type AS ENUM (
    'created',
    'in_progress',
    'quality_check',
    'completed'
);


--
-- TOC entry 1450 (class 1247 OID 57267)
-- Name: campaign_status_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.campaign_status_type AS ENUM (
    'draft',
    'pending_approval',
    'active',
    'inactive'
);


--
-- TOC entry 1534 (class 1247 OID 67167)
-- Name: draw_selection_method; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.draw_selection_method AS ENUM (
    'random',
    'manual'
);


--
-- TOC entry 1332 (class 1247 OID 56931)
-- Name: hq_order_status_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.hq_order_status_type AS ENUM (
    'draft',
    'pending_approval',
    'approved',
    'po_sent',
    'payment_notified',
    'payment_verified',
    'rejected'
);


--
-- TOC entry 1459 (class 1247 OID 52114)
-- Name: inventory_tx_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.inventory_tx_type AS ENUM (
    'in',
    'out',
    'reserve',
    'release',
    'adjust'
);


--
-- TOC entry 1426 (class 1247 OID 84275)
-- Name: manufacturer_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.manufacturer_status AS ENUM (
    'active',
    'inactive',
    'blocked'
);


--
-- TOC entry 1441 (class 1247 OID 57196)
-- Name: notification_channel_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.notification_channel_type AS ENUM (
    'whatsapp',
    'email'
);


--
-- TOC entry 1438 (class 1247 OID 57169)
-- Name: notification_event_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.notification_event_type AS ENUM (
    'order_created',
    'batch_created',
    'manufacture_acknowledged',
    'produced',
    'shipment_to_warehouse',
    'received_at_warehouse',
    'assigned_to_distributor',
    'shipment_to_distributor',
    'delivered_to_shop',
    'shop_first_scan',
    'consumer_verify',
    'campaign_gift',
    'fraud_anomaly'
);


--
-- TOC entry 1444 (class 1247 OID 57202)
-- Name: notification_status_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.notification_status_type AS ENUM (
    'queued',
    'sent',
    'failed'
);


--
-- TOC entry 1414 (class 1247 OID 56946)
-- Name: order_priority_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.order_priority_type AS ENUM (
    'normal',
    'high'
);


--
-- TOC entry 1453 (class 1247 OID 52085)
-- Name: order_status_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.order_status_type AS ENUM (
    'draft',
    'pending',
    'confirmed',
    'paid',
    'packing',
    'shipped',
    'completed',
    'cancelled'
);


--
-- TOC entry 1456 (class 1247 OID 52102)
-- Name: payment_status_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.payment_status_type AS ENUM (
    'unpaid',
    'partial',
    'paid',
    'refunded',
    'failed'
);


--
-- TOC entry 1525 (class 1247 OID 61285)
-- Name: po_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.po_status AS ENUM (
    'draft',
    'sent',
    'acknowledged',
    'approved',
    'locked'
);


--
-- TOC entry 1516 (class 1247 OID 48273)
-- Name: product_category_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.product_category_type AS ENUM (
    'vape',
    'nonvape'
);


--
-- TOC entry 1462 (class 1247 OID 49587)
-- Name: product_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.product_status AS ENUM (
    'draft',
    'active',
    'inactive',
    'discontinued'
);


--
-- TOC entry 1411 (class 1247 OID 82219)
-- Name: role_code; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.role_code AS ENUM (
    'hq_admin',
    'power_user',
    'manufacturer',
    'warehouse',
    'distributor',
    'shop'
);


--
-- TOC entry 1546 (class 1247 OID 70693)
-- Name: royalty_activity_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.royalty_activity_type AS ENUM (
    'daily',
    'weekly',
    'one-time',
    'repeatable'
);


--
-- TOC entry 1555 (class 1247 OID 70718)
-- Name: royalty_redemption_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.royalty_redemption_status AS ENUM (
    'pending',
    'processing',
    'fulfilled',
    'cancelled'
);


--
-- TOC entry 1552 (class 1247 OID 70710)
-- Name: royalty_tx_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.royalty_tx_status AS ENUM (
    'completed',
    'pending',
    'cancelled'
);


--
-- TOC entry 1549 (class 1247 OID 70702)
-- Name: royalty_tx_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.royalty_tx_type AS ENUM (
    'earned',
    'redeemed',
    'adjustment'
);


--
-- TOC entry 1519 (class 1247 OID 48278)
-- Name: status_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.status_type AS ENUM (
    'active',
    'inactive'
);


--
-- TOC entry 1432 (class 1247 OID 48031)
-- Name: buckettype; Type: TYPE; Schema: storage; Owner: -
--

CREATE TYPE storage.buckettype AS ENUM (
    'STANDARD',
    'ANALYTICS'
);


--
-- TOC entry 568 (class 1255 OID 70854)
-- Name: adjust_user_points(uuid, integer, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.adjust_user_points(p_user_id uuid, p_points integer, p_description text) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_level_info RECORD;
  v_tx_type royalty_tx_type;
BEGIN
  -- Determine transaction type based on points value
  IF p_points >= 0 THEN
    v_tx_type := 'earned';
  ELSE
    v_tx_type := 'adjustment';
  END IF;

  -- Create transaction record
  INSERT INTO royalty_transactions (
    user_id, type, description, points, category, status
  ) VALUES (
    p_user_id, v_tx_type, p_description, ABS(p_points), 'admin_adjustment', 'completed'
  );

  -- Update user points
  UPDATE royalty_user_rewards 
  SET 
    current_points = GREATEST(0, current_points + p_points),
    total_earned = CASE 
      WHEN p_points > 0 THEN total_earned + p_points 
      ELSE total_earned 
    END,
    updated_at = NOW()
  WHERE user_id = p_user_id;

  -- Recalculate level if points were added
  IF p_points > 0 THEN
    SELECT * INTO v_level_info 
    FROM calculate_user_level((SELECT total_earned FROM royalty_user_rewards WHERE user_id = p_user_id));

    UPDATE royalty_user_rewards 
    SET 
      level = v_level_info.level,
      current_level_points = v_level_info.current_level_points,
      next_level_points = v_level_info.next_level_points
    WHERE user_id = p_user_id;
  END IF;
END;
$$;


--
-- TOC entry 612 (class 1255 OID 55414)
-- Name: app_approve_product(uuid, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.app_approve_product(p_product_id uuid, p_comment text DEFAULT NULL::text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE 
  v_org uuid;
BEGIN
  IF NOT (app.is_hq_admin() OR app.is_power_user()) THEN
    RAISE EXCEPTION 'Forbidden: Only HQ Admin or Power User can approve products';
  END IF;

  v_org := app.current_org_id();
  IF NOT EXISTS (SELECT 1 FROM products WHERE id = p_product_id AND org_id = v_org) THEN
    RAISE EXCEPTION 'Product not found in your organization';
  END IF;

  IF NOT EXISTS (SELECT 1 FROM products WHERE id = p_product_id AND approval_status = 'pending_approval') THEN
    RAISE EXCEPTION 'Product must be in pending_approval status to be approved';
  END IF;

  UPDATE products
  SET approval_status = 'approved',
      updated_at = now(),
      updated_by = auth.uid(),
      status = 'active'
  WHERE id = p_product_id;

  INSERT INTO product_approval_history(product_id, action, comment, performed_by)
  VALUES (p_product_id, 'approved', p_comment, auth.uid());

  RETURN jsonb_build_object('ok', true);
END;
$$;


--
-- TOC entry 482 (class 1255 OID 55415)
-- Name: app_reject_product(uuid, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.app_reject_product(p_product_id uuid, p_comment text DEFAULT NULL::text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE 
  v_org uuid;
BEGIN
  IF NOT (app.is_hq_admin() OR app.is_power_user()) THEN
    RAISE EXCEPTION 'Forbidden: Only HQ Admin or Power User can reject products';
  END IF;

  v_org := app.current_org_id();
  IF NOT EXISTS (SELECT 1 FROM products WHERE id = p_product_id AND org_id = v_org) THEN
    RAISE EXCEPTION 'Product not found in your organization';
  END IF;

  IF NOT EXISTS (SELECT 1 FROM products WHERE id = p_product_id AND approval_status = 'pending_approval') THEN
    RAISE EXCEPTION 'Product must be in pending_approval status to be rejected';
  END IF;

  UPDATE products
  SET approval_status = 'rejected',
      updated_at = now(),
      updated_by = auth.uid(),
      status = 'inactive'
  WHERE id = p_product_id;

  INSERT INTO product_approval_history(product_id, action, comment, performed_by)
  VALUES (p_product_id, 'rejected', p_comment, auth.uid());

  RETURN jsonb_build_object('ok', true);
END;
$$;


--
-- TOC entry 424 (class 1255 OID 55413)
-- Name: app_submit_product_for_approval(uuid, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.app_submit_product_for_approval(p_product_id uuid, p_comment text DEFAULT NULL::text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_org uuid;
  v_user_id uuid := auth.uid();
  v_is_hq_admin boolean;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM users_profile WHERE user_id = v_user_id) THEN
    RAISE EXCEPTION 'User profile not found - please contact administrator';
  END IF;

  SELECT app.is_hq_admin() INTO v_is_hq_admin;
  IF NOT v_is_hq_admin THEN
    RAISE EXCEPTION 'Forbidden: Only HQ Admin can submit products for approval';
  END IF;

  SELECT app.current_org_id() INTO v_org;
  IF NOT EXISTS (SELECT 1 FROM products WHERE id = p_product_id AND org_id = v_org) THEN
    RAISE EXCEPTION 'Product not found in your organization';
  END IF;

  UPDATE products
  SET approval_status = 'pending_approval',
      updated_at = now(),
      updated_by = v_user_id
  WHERE id = p_product_id;

  INSERT INTO product_approval_history(product_id, action, comment, performed_by)
  VALUES (p_product_id, 'pending_approval', p_comment, v_user_id);

  RETURN jsonb_build_object('ok', true);
END;
$$;


--
-- TOC entry 605 (class 1255 OID 57336)
-- Name: approve_campaign(uuid, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.approve_campaign(p_campaign_id uuid, p_approved boolean DEFAULT true) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  current_status campaign_status_type;
  new_status     campaign_status_type;
BEGIN
  -- Only Power User can approve/reject
  IF NOT app.is_power_user() THEN
    RETURN json_build_object('success', false, 'message', 'Only Power User can approve campaigns');
  END IF;

  SELECT status INTO current_status FROM public.campaigns WHERE id = p_campaign_id;
  IF current_status IS NULL THEN
    RETURN json_build_object('success', false, 'message', 'Campaign not found');
  END IF;

  IF current_status <> 'pending_approval' THEN
    RETURN json_build_object('success', false, 'message', 'Only pending campaigns can be approved or rejected');
  END IF;

  new_status := CASE WHEN p_approved THEN 'active' ELSE 'draft' END;

  UPDATE public.campaigns
  SET status      = new_status,
      approved_by = CASE WHEN p_approved THEN auth.uid() ELSE NULL END,
      approved_at = CASE WHEN p_approved THEN now() ELSE NULL END,
      updated_at  = now()
  WHERE id = p_campaign_id;

  RETURN json_build_object('success', true, 'message', 'Campaign decision recorded', 'status', new_status);
END;
$$;


--
-- TOC entry 476 (class 1255 OID 67552)
-- Name: approve_campaign(uuid, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.approve_campaign(p_campaign_id uuid, p_approver_comment text DEFAULT NULL::text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  current_user_id uuid;
BEGIN
  -- Get current user ID
  current_user_id := auth.uid();
  
  -- Check if user has permission
  IF NOT EXISTS (
    SELECT 1 FROM public.users_profile 
    WHERE user_id = current_user_id 
    AND role IN ('hq_admin', 'power_user')
  ) THEN
    RETURN jsonb_build_object(
      'success', false,
      'error', 'Insufficient permissions'
    );
  END IF;

  -- Update campaign status
  UPDATE public.campaigns
  SET 
    status = 'approved',
    approved_at = NOW(),
    approved_by = current_user_id,
    updated_at = NOW()
  WHERE id = p_campaign_id;

  RETURN jsonb_build_object(
    'success', true,
    'message', 'Campaign approved successfully'
  );
END;
$$;


--
-- TOC entry 650 (class 1255 OID 67550)
-- Name: approve_product(uuid, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.approve_product(p_product_id uuid, p_approver_comment text DEFAULT NULL::text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  current_user_id uuid;
  result jsonb;
BEGIN
  -- Get current user ID
  current_user_id := auth.uid();
  
  -- Check if user has permission (implement your role checking logic)
  IF NOT EXISTS (
    SELECT 1 FROM public.users_profile 
    WHERE user_id = current_user_id 
    AND role IN ('hq_admin', 'power_user')
  ) THEN
    RETURN jsonb_build_object(
      'success', false,
      'error', 'Insufficient permissions'
    );
  END IF;

  -- Update product approval status
  UPDATE public.products
  SET 
    approval_status = 'approved',
    approved_at = NOW(),
    approved_by = current_user_id,
    updated_at = NOW()
  WHERE id = p_product_id;

  -- Insert approval history if table exists
  BEGIN
    INSERT INTO public.product_approval_history (
      product_id,
      action,
      comment,
      performed_by,
      performed_at
    ) VALUES (
      p_product_id,
      'approved',
      p_approver_comment,
      current_user_id,
      NOW()
    );
  EXCEPTION WHEN undefined_table THEN
    -- Table doesn't exist, skip history logging
    NULL;
  END;

  RETURN jsonb_build_object(
    'success', true,
    'message', 'Product approved successfully'
  );
END;
$$;


--
-- TOC entry 502 (class 1255 OID 57672)
-- Name: assign_manufacturer_to_user(uuid, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.assign_manufacturer_to_user(p_user_id uuid, p_manufacturer_id uuid) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  -- Only allow HQ Admin and Power User to assign manufacturers
  IF (SELECT auth.jwt() ->> 'role') NOT IN ('hq_admin', 'power_user') THEN
    RAISE EXCEPTION 'Access denied. Only HQ Admin and Power User can assign manufacturers.';
  END IF;

  -- Verify manufacturer exists
  IF NOT EXISTS (SELECT 1 FROM public.manufacturers WHERE id = p_manufacturer_id) THEN
    RAISE EXCEPTION 'Manufacturer not found.';
  END IF;

  -- Verify user exists
  IF NOT EXISTS (SELECT 1 FROM public.users_profile WHERE user_id = p_user_id) THEN
    RAISE EXCEPTION 'User not found.';
  END IF;

  -- Update user with manufacturer assignment
  UPDATE public.users_profile 
  SET 
    manufacturer_id = p_manufacturer_id,
    updated_at = now()
  WHERE user_id = p_user_id;

  RETURN true;
END;
$$;


--
-- TOC entry 542 (class 1255 OID 57756)
-- Name: auto_generate_pos_after_approval(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.auto_generate_pos_after_approval() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  -- Only generate POs when status changes to 'approved'
  IF OLD.status != 'approved' AND NEW.status = 'approved' THEN
    -- Trigger PO generation (this will be handled by the application)
    -- We just log this event for now
    INSERT INTO public.system_logs (event_type, event_data, created_at)
    VALUES (
      'order_approved_po_needed',
      json_build_object('order_id', NEW.id, 'order_code', NEW.code),
      now()
    );
  END IF;
  
  RETURN NEW;
END;
$$;


--
-- TOC entry 522 (class 1255 OID 67192)
-- Name: award_manual_winner(uuid, uuid, uuid, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.award_manual_winner(p_campaign_id uuid, p_submission_id uuid, p_prize_id uuid, p_note text DEFAULT NULL::text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_user_id uuid := auth.uid();
  v_user_role text;
  v_draw_id uuid;
  v_prize_qty int;
  v_awarded_count int;
BEGIN
  -- role check
  SELECT up.role INTO v_user_role FROM public.users_profile up WHERE up.user_id = v_user_id;
  IF v_user_role NOT IN ('hq_admin','power_user') THEN
    RETURN json_build_object('success',false,'message','Only HQ Admin/Power User may award');
  END IF;

  -- campaign: lucky_draw & active
  IF NOT EXISTS (SELECT 1 FROM public.campaigns WHERE id=p_campaign_id AND type='lucky_draw' AND status='active') THEN
    RETURN json_build_object('success',false,'message','Campaign not active/lucky_draw');
  END IF;

  -- prize belongs to campaign
  IF NOT EXISTS (SELECT 1 FROM public.campaign_prizes WHERE id=p_prize_id AND campaign_id=p_campaign_id) THEN
    RETURN json_build_object('success',false,'message','Prize invalid');
  END IF;

  -- submission belongs to campaign and not already a winner
  IF NOT EXISTS (SELECT 1 FROM public.campaign_draw_submissions WHERE id=p_submission_id AND campaign_id=p_campaign_id) THEN
    RETURN json_build_object('success',false,'message','Submission invalid');
  END IF;
  IF EXISTS (SELECT 1 FROM public.campaign_draw_winners WHERE campaign_id=p_campaign_id AND submission_id=p_submission_id) THEN
    RETURN json_build_object('success',false,'message','Already a winner');
  END IF;

  -- prize capacity
  SELECT quantity INTO v_prize_qty FROM public.campaign_prizes WHERE id=p_prize_id;
  SELECT COUNT(*) INTO v_awarded_count FROM public.campaign_draw_winners WHERE prize_id=p_prize_id;
  IF v_awarded_count >= v_prize_qty THEN
    RETURN json_build_object('success',false,'message','Prize already fully awarded');
  END IF;

  -- audit draw row
  INSERT INTO public.campaign_draws (campaign_id, executed_by, note)
  VALUES (p_campaign_id, v_user_id, 'Manual award') RETURNING id INTO v_draw_id;

  -- write winner with selection_method='manual'
  INSERT INTO public.campaign_draw_winners (campaign_id, submission_id, prize_id, draw_id, drawn_by, selection_method, notes)
  VALUES (p_campaign_id, p_submission_id, p_prize_id, v_draw_id, v_user_id, 'manual', p_note);

  RETURN json_build_object('success',true,'message','Manual winner awarded','draw_id',v_draw_id);
END $$;


--
-- TOC entry 432 (class 1255 OID 63172)
-- Name: award_shop_points(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.award_shop_points(p_order_id uuid) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
declare
  o_total numeric;
  o_qty   int;
  o_shop  uuid;
  pts     int := 0;
  r       record;
begin
  -- Only shop orders are eligible (adjust if your schema differs)
  select o.org_id as shop_id,
         (o.totals->>'grand_total')::numeric as total
    into o_shop, o_total
  from public.orders o
  where o.id = p_order_id and o.buyer_type = 'shop';

  if o_shop is null then
    return;
  end if;

  select coalesce(sum(qty),0) into o_qty
  from public.order_items
  where order_id = p_order_id;

  for r in
    select *
    from public.points_rules
    where scope='shop' and event='payment.verified' and status='active'
      and (start_at is null or now() >= start_at)
      and (end_at   is null or now() <= end_at)
  loop
    if r.points_per_currency is not null and o_total >= coalesce(r.min_amount,0) then
      pts := pts + floor(o_total * r.points_per_currency)::int;
    end if;

    if r.points_per_qty is not null and o_qty > 0 then
      pts := pts + floor(o_qty * r.points_per_qty)::int;
    end if;
  end loop;

  if pts > 0 then
    insert into public.shop_points_ledger (shop_id, order_id, direction, points, reason, meta)
    values (o_shop, p_order_id, 'earn', pts, 'payment.verified',
            jsonb_build_object('order_id', p_order_id, 'award', 'auto'));
  end if;
end;
$$;


--
-- TOC entry 660 (class 1255 OID 63422)
-- Name: award_shop_points_from_case(uuid, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.award_shop_points_from_case(p_case_id uuid, p_shop_id uuid) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
declare
  v_units_per_case int := 1;
  v_po_id uuid;
  v_pts int := 0;
  r record;
begin
  -- get case info (units per case, optional PO for future use)
  select units_per_case, po_id
    into v_units_per_case, v_po_id
  from public.cases
  where id = p_case_id;

  if v_units_per_case is null then
    v_units_per_case := 1;
  end if;

  -- apply active rules for shop scope on scan events
  for r in
    select *
    from public.points_rules
    where scope='shop'
      and status='active'
      and event in ('qr.activated','case.activated')
      and (start_at is null or now() >= start_at)
      and (end_at   is null or now() <= end_at)
  loop
    -- simple calculator examples:
    if r.points_per_qty is not null then
      v_pts := v_pts + floor(v_units_per_case * r.points_per_qty)::int;
    end if;
    -- (Optional) if you later want per-currency rules based on the PO/order totals,
    -- you can join those totals here and add:
    -- if r.points_per_currency is not null and v_total is not null then
    --   v_pts := v_pts + floor(v_total * r.points_per_currency)::int;
    -- end if;
  end loop;

  if v_pts > 0 then
    insert into public.shop_points_ledger (shop_id, direction, points, reason, meta)
    values (p_shop_id, 'earn', v_pts, 'case.activated',
            jsonb_build_object('case_id', p_case_id, 'po_id', v_po_id));
  end if;
end;
$$;


--
-- TOC entry 606 (class 1255 OID 63302)
-- Name: award_shop_points_from_qr(uuid, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.award_shop_points_from_qr(p_qr_id uuid, p_shop_id uuid) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
declare
  v_order uuid;
  v_total numeric;
  v_qty int := 1;
  r record;
  v_pts int := 0;
begin
  -- Optionally resolve the order/po behind this QR for richer rules
  select po_id into v_order from public.qr_master where id = p_qr_id;

  for r in
    select * from public.points_rules
    where scope='shop' and event='qr.activated' and status='active'
      and (start_at is null or now() >= start_at)
      and (end_at   is null or now() <= end_at)
  loop
    -- simplest example: points_per_qty applies per item
    if r.points_per_qty is not null then
      v_pts := v_pts + floor(v_qty * r.points_per_qty)::int;
    end if;
    -- Or use r.points_per_currency with order total if you want.
  end loop;

  if v_pts > 0 then
    insert into public.shop_points_ledger (shop_id, direction, points, reason, meta)
    values (p_shop_id, 'earn', v_pts, 'qr.activated',
            jsonb_build_object('qr_id', p_qr_id));
  end if;
end;
$$;


--
-- TOC entry 450 (class 1255 OID 70855)
-- Name: calculate_user_level(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.calculate_user_level(p_total_points integer) RETURNS TABLE(level integer, current_level_points integer, next_level_points integer)
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
  v_level INTEGER := 1;
  v_thresholds INTEGER[] := ARRAY[0, 500, 1000, 2000, 4000, 8000];
  v_current_level_points INTEGER;
  v_next_level_points INTEGER;
  i INTEGER;
BEGIN
  -- Find current level
  FOR i IN REVERSE array_length(v_thresholds, 1)..1 LOOP
    IF p_total_points >= v_thresholds[i] THEN
      v_level := i;
      v_current_level_points := p_total_points - v_thresholds[i];
      EXIT;
    END IF;
  END LOOP;

  -- Calculate next level points
  IF v_level >= array_length(v_thresholds, 1) THEN
    -- Max level reached
    v_next_level_points := 0;
  ELSE
    v_next_level_points := v_thresholds[v_level + 1] - v_thresholds[v_level];
  END IF;

  RETURN QUERY SELECT v_level, v_current_level_points, v_next_level_points;
END;
$$;


--
-- TOC entry 474 (class 1255 OID 59255)
-- Name: can_product_be_added_to_order(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.can_product_be_added_to_order(p_product_id uuid) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  product_exists boolean := false;
BEGIN
  -- Check if product exists and is approved
  SELECT EXISTS(
    SELECT 1
    FROM public.products p
    WHERE p.id = p_product_id
      AND p.approval_status = 'approved'
      AND (p.is_active = true OR p.is_active IS NULL)
      AND p.manufacturer_id IS NOT NULL
  ) INTO product_exists;

  RETURN product_exists;
END;
$$;


--
-- TOC entry 641 (class 1255 OID 57489)
-- Name: can_product_be_added_to_order(uuid, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.can_product_be_added_to_order(p_product_id uuid, p_order_id uuid DEFAULT NULL::uuid) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
  v_approval_status text;
  v_is_active       boolean;
  v_already_in_this boolean;
begin
  -- must exist, be approved & active
  select approval_status, is_active
  into   v_approval_status, v_is_active
  from public.products
  where id = p_product_id;

  if v_approval_status is null then
    return false; -- not found
  end if;

  if v_approval_status <> 'approved' then
    return false; -- not approved
  end if;

  if v_is_active = false then
    return false; -- inactive
  end if;

  -- only block duplicates inside the SAME order (HQ flow uses hq_order_line_items)
  if p_order_id is not null then
    select exists(
      select 1
      from public.hq_order_line_items
      where product_id = p_product_id
        and order_id   = p_order_id
    ) into v_already_in_this;

    if v_already_in_this then
      return false; -- already on this order
    end if;
  end if;

  return true;
end;
$$;


--
-- TOC entry 587 (class 1255 OID 63400)
-- Name: case_scan_activate(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.case_scan_activate(p_code text DEFAULT NULL::text, p_rfid_uid text DEFAULT NULL::text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
declare
  v_user uuid := auth.uid();
  v_org  uuid;
  v_case public.cases%rowtype;
  v_now  timestamptz := now();
  v_first boolean := false;
begin
  if v_user is null then
    raise exception 'unauthenticated';
  end if;

  select up.org_id into v_org
  from public.users_profile up
  where up.user_id = v_user
  limit 1;

  if v_org is null then
    raise exception 'no_org_for_user';
  end if;

  select * into v_case
  from public.cases
  where (p_code is not null and code = p_code)
     or (p_rfid_uid is not null and rfid_uid = p_rfid_uid)
  limit 1;

  if not found then
    raise exception 'case_not_found';
  end if;

  -- first activation flips status/owner; subsequent scans just log
  if v_case.status <> 'activated' then
    v_first := true;
    update public.cases
       set status = 'activated',
           owner_org_id = v_org,
           updated_at = v_now
     where id = v_case.id;

    -- ✅ award points here (inside the function we use PERFORM)
    perform public.award_shop_points_from_case(v_case.id, v_org);
  end if;

  insert into public.case_events(case_id, event, org_id, performed_by, meta)
  values (v_case.id, case when v_first then 'activated' else 'scanned' end, v_org, v_user,
          jsonb_build_object('code', p_code, 'rfid', p_rfid_uid));

  return json_build_object(
    'ok', true,
    'first_activation', v_first,
    'case_id', v_case.id,
    'po_id', v_case.po_id,
    'po_item_id', v_case.po_item_id,
    'product_id', v_case.product_id,
    'units_per_case', v_case.units_per_case
  );
end;
$$;


--
-- TOC entry 588 (class 1255 OID 63650)
-- Name: claim_free_device(text, text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.claim_free_device(p_code text, p_name text, p_email text, p_phone text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
  v_qr   record;
  v_now  timestamptz := now();
begin
  -- Cari QR di qr_master (code) atau fallback kalau perlu
  select id from public.qr_master where code = p_code limit 1 into v_qr;

  -- Kalau dah pernah claim, pulangkan info "already_claimed"
  if exists (select 1 from public.rewards_claims where code = p_code) then
    return json_build_object(
      'ok', false, 'reason', 'already_claimed', 'page', 'REWARD_ALREADY_CLAIMED'
    );
  end if;

  -- Simpan klaim
  insert into public.rewards_claims(code, qr_id, claimant_name, email, phone, reward_type)
  values (p_code, coalesce(v_qr.id, null), p_name, p_email, p_phone, 'free_device');

  -- Log event (selari dengan corak qr_events/qr_scan_events)
  insert into public.qr_events(qr_id, event, org_id, performed_by, meta)
  values (coalesce(v_qr.id, null), 'campaign_gift', app.current_org_id(), auth.uid(),
          jsonb_build_object('code', p_code, 'reward','free_device'));

  -- (Opsyenal) hantar notifikasi melalui queue sedia ada
  perform public.enqueue_notification(
    'campaign_gift',
    jsonb_build_object('code', p_code, 'name', p_name, 'type','free_device'),
    null, 'whatsapp'
  );

  return json_build_object('ok', true, 'page', 'REWARD_CLAIM_OK');
end $$;


--
-- TOC entry 516 (class 1255 OID 63740)
-- Name: claim_free_device(text, text, text, text, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.claim_free_device(p_code text, p_name text, p_email text, p_phone text, p_campaign_id uuid DEFAULT NULL::uuid) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_qr   public.qr_master%ROWTYPE;
  v_now  timestamptz := now();
BEGIN
  IF p_code IS NULL OR length(trim(p_code)) = 0 THEN
    RETURN json_build_object('ok', false, 'reason', 'invalid_code');
  END IF;

  SELECT * INTO v_qr FROM public.qr_master WHERE code = p_code LIMIT 1;
  IF NOT FOUND THEN
    RETURN json_build_object('ok', false, 'reason', 'not_found');
  END IF;

  -- One time only per QR
  IF EXISTS (SELECT 1 FROM public.reward_claims WHERE qr_id = v_qr.id) THEN
    RETURN json_build_object('ok', false, 'reason', 'already_claimed', 'claimed_at',
                             (SELECT claimed_at FROM public.reward_claims WHERE qr_id = v_qr.id));
  END IF;

  INSERT INTO public.reward_claims(qr_id, code, campaign_id, reward_type, claimant_name, email, phone, claimed_at)
  VALUES (v_qr.id, p_code, p_campaign_id, 'free_device', p_name, p_email, p_phone, v_now);

  -- Log as a redeem event (allowed by qr_events check constraint)
  INSERT INTO public.qr_events(qr_id, actor_org_id, event_type, payload, created_at)
  VALUES (v_qr.id, NULL, 'redeem',
          jsonb_build_object('kind','free_device_claim','name',p_name,'email',p_email,'phone',p_phone,'code',p_code),
          v_now);

  -- Optional: enqueue notification using existing enum event 'campaign_gift'
  PERFORM public.enqueue_notification(
    'campaign_gift',
    jsonb_build_object('code', p_code, 'reward','free_device', 'name', p_name, 'email', p_email, 'phone', p_phone),
    NULL, 'whatsapp'
  );

  RETURN json_build_object('ok', true, 'reason', NULL, 'claimed_at', v_now);
END;
$$;


--
-- TOC entry 631 (class 1255 OID 52167)
-- Name: commit_stock(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.commit_stock(p_order_id uuid) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE r RECORD;
BEGIN
  FOR r IN
    SELECT oi.product_id, oi.batch_id, oi.quantity
    FROM public.order_items oi
    WHERE oi.order_id = p_order_id
  LOOP
    INSERT INTO public.inventory_ledger(product_id, batch_id, order_id, transaction_type, quantity, created_by, notes)
    VALUES (r.product_id, r.batch_id, p_order_id, 'out', r.quantity, auth.uid(), 'Order ship/commit');
  END LOOP;
  UPDATE public.orders SET order_status='shipped', updated_at=now() WHERE id = p_order_id;
END;
$$;


--
-- TOC entry 678 (class 1255 OID 70852)
-- Name: complete_activity_transaction(uuid, uuid, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.complete_activity_transaction(p_user_id uuid, p_activity_id uuid, p_points integer) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_level_info RECORD;
BEGIN
  -- Insert or update user activity progress
  INSERT INTO royalty_user_activities (
    user_id, activity_id, completed, progress, 
    last_completed_at, completion_count
  ) VALUES (
    p_user_id, p_activity_id, true, 100,
    NOW(), 1
  )
  ON CONFLICT (user_id, activity_id) 
  DO UPDATE SET
    completed = true,
    progress = 100,
    last_completed_at = NOW(),
    completion_count = royalty_user_activities.completion_count + 1,
    updated_at = NOW();

  -- Create transaction record
  INSERT INTO royalty_transactions (
    user_id, type, description, points, category, status
  ) VALUES (
    p_user_id, 'earned', 'Activity completion', p_points, 'activity', 'completed'
  );

  -- Update user rewards and recalculate level
  INSERT INTO royalty_user_rewards (
    user_id, current_points, total_earned, level, 
    current_level_points, next_level_points
  ) VALUES (
    p_user_id, p_points, p_points, 1, p_points, 500
  )
  ON CONFLICT (user_id) 
  DO UPDATE SET
    current_points = royalty_user_rewards.current_points + p_points,
    total_earned = royalty_user_rewards.total_earned + p_points,
    updated_at = NOW();

  -- Recalculate level based on total earned points
  SELECT * INTO v_level_info 
  FROM calculate_user_level((SELECT total_earned FROM royalty_user_rewards WHERE user_id = p_user_id));

  -- Update level information
  UPDATE royalty_user_rewards 
  SET 
    level = v_level_info.level,
    current_level_points = v_level_info.current_level_points,
    next_level_points = v_level_info.next_level_points
  WHERE user_id = p_user_id;
END;
$$;


--
-- TOC entry 521 (class 1255 OID 50629)
-- Name: create_batch_with_qr_codes(uuid, integer, uuid, numeric, date, date, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.create_batch_with_qr_codes(product_id_param uuid, quantity_param integer, manufacturer_id_param uuid DEFAULT NULL::uuid, unit_cost_param numeric DEFAULT NULL::numeric, production_date_param date DEFAULT NULL::date, expiry_date_param date DEFAULT NULL::date, notes_param text DEFAULT NULL::text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  batch_rec public.batches%ROWTYPE;
  qr_prefix text;
  qr_code_value text;
  i integer;
  batch_number_val text;
  has_manufacturer_column boolean;
  product_sku text;
  product_active boolean := true;
BEGIN
  IF coalesce(auth.jwt()->>'role','') NOT IN ('hq_admin','manufacturer') THEN
    RETURN json_build_object('success', false, 'message', 'Insufficient permissions');
  END IF;

  SELECT sku INTO product_sku FROM public.products WHERE id = product_id_param;
  IF NOT FOUND THEN
    RETURN json_build_object('success', false, 'message', 'Product not found');
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='products' AND column_name='status') THEN
    SELECT EXISTS (SELECT 1 FROM public.products WHERE id=product_id_param AND status='active') INTO product_active;
  ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='products' AND column_name='is_active') THEN
    SELECT EXISTS (SELECT 1 FROM public.products WHERE id=product_id_param AND is_active=true) INTO product_active;
  END IF;
  IF NOT product_active THEN
    RETURN json_build_object('success', false, 'message', 'Product must be active');
  END IF;

  SELECT to_char(current_date,'YYYYMMDD') || '-' || product_sku || '-' ||
         lpad((coalesce((SELECT count(*) FROM public.batches b2 WHERE b2.product_id = product_id_param),0)+1)::text,3,'0')
  INTO batch_number_val;

  SELECT EXISTS(
    SELECT 1 FROM information_schema.columns
    WHERE table_schema='public' AND table_name='batches' AND column_name='manufacturer_id'
  ) INTO has_manufacturer_column;

  IF has_manufacturer_column THEN
    INSERT INTO public.batches (
      batch_number, product_id, manufacturer_id, quantity, unit_cost,
      production_date, expiry_date, notes, created_by
    ) VALUES (
      batch_number_val, product_id_param, manufacturer_id_param, quantity_param, unit_cost_param,
      production_date_param, expiry_date_param, notes_param, auth.uid()
    )
    RETURNING * INTO batch_rec;
  ELSE
    INSERT INTO public.batches (
      batch_number, product_id, quantity, unit_cost,
      production_date, expiry_date, notes, created_by
    ) VALUES (
      batch_number_val, product_id_param, quantity_param, unit_cost_param,
      production_date_param, expiry_date_param, notes_param, auth.uid()
    )
    RETURNING * INTO batch_rec;
  END IF;

  qr_prefix := replace(batch_rec.id::text,'-','') || to_char(now(),'YYYYMMDDHH24MISS');
  FOR i IN 1..quantity_param LOOP
    qr_code_value := qr_prefix || lpad(i::text,4,'0');
    INSERT INTO public.qr_codes (qr_code, batch_id, product_id, sequence_number)
    VALUES (qr_code_value, batch_rec.id, product_id_param, i);
  END LOOP;

  UPDATE public.batches
  SET status='qr_generated', qr_generated_at=now(), updated_at=now()
  WHERE id=batch_rec.id;

  INSERT INTO public.batch_status_history (batch_id, status, changed_by, comment)
  VALUES (batch_rec.id, 'qr_generated', auth.uid(), 'QR codes generated');

  RETURN json_build_object('success', true, 'message', 'Batch created with QR codes',
                           'batch_id', batch_rec.id, 'batch_number', batch_number_val,
                           'qr_codes_generated', quantity_param);
END;
$$;


--
-- TOC entry 430 (class 1255 OID 48327)
-- Name: create_category_with_subcats(public.product_category_type, text, text, text, text, uuid, jsonb); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.create_category_with_subcats(p_product_category public.product_category_type, p_name text, p_code text, p_description text, p_icon_url text, p_created_by uuid, p_subcats jsonb DEFAULT '[]'::jsonb) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
  v_category_id uuid;
  v_sc jsonb;
  v_sc2 jsonb;
  v_sc1_id uuid;
begin
  insert into categories(product_category, name, code, description, icon_url, created_by)
  values (p_product_category, p_name, p_code, p_description, p_icon_url, p_created_by)
  returning id into v_category_id;

  for v_sc in select * from jsonb_array_elements(coalesce(p_subcats, '[]'::jsonb)) loop
    insert into subcategories(category_id, level, name, code, description)
    values (v_category_id, 1, v_sc->>'name', v_sc->>'code', v_sc->>'description')
    returning id into v_sc1_id;

    if (v_sc ? 'children') then
      for v_sc2 in select * from jsonb_array_elements(v_sc->'children') loop
        insert into subcategories(category_id, level, parent_subcategory_id, name, code, description)
        values (v_category_id, 2, v_sc1_id, v_sc2->>'name', v_sc2->>'code', v_sc2->>'description');
      end loop;
    end if;
  end loop;

  return v_category_id;
end;
$$;


--
-- TOC entry 632 (class 1255 OID 59458)
-- Name: create_product_version(uuid, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.create_product_version(p_product_id uuid, p_user_id uuid) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_new_product_id UUID;
  v_prev_version INTEGER;
  v_parent_id UUID;
BEGIN
  SELECT version, COALESCE(parent_id, p_product_id)
    INTO v_prev_version, v_parent_id
  FROM products
  WHERE id = p_product_id;

  INSERT INTO products (
    name, sku, product_category, status, approval_status,
    description, brand_id, flavour_id, manufacturer_id,
    category_id, l1_category_id, l2_category_id,
    org_id, created_by, version, parent_id, is_current,
    lifecycle_status
  )
  SELECT
    name, sku, product_category, status, 'draft',
    description, brand_id, flavour_id, manufacturer_id,
    category_id, l1_category_id, l2_category_id,
    org_id, p_user_id, COALESCE(v_prev_version,1) + 1, v_parent_id, false,
    lifecycle_status
  FROM products
  WHERE id = p_product_id
  RETURNING id INTO v_new_product_id;

  INSERT INTO product_approval_history(
    product_id, action, comment, performed_by
  ) VALUES (
    v_new_product_id,
    'version_created',
    'New version created from v' || COALESCE(v_prev_version,1),
    p_user_id
  );

  RETURN v_new_product_id;
END;
$$;


--
-- TOC entry 491 (class 1255 OID 52932)
-- Name: debug_user_permissions(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.debug_user_permissions(user_id_param uuid DEFAULT NULL::uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    current_user_id uuid;
    result jsonb;
BEGIN
    current_user_id := COALESCE(user_id_param, auth.uid());
    
    SELECT jsonb_build_object(
        'user_id', current_user_id,
        'jwt_role', auth.jwt()->>'role',
        'database_role', (SELECT role FROM users_profile WHERE user_id = current_user_id),
        'is_power_user', app.is_power_user(),
        'is_hq_admin', app.is_hq_admin(),
        'org_id', app.current_org_id(),
        'user_profile_exists', EXISTS(SELECT 1 FROM users_profile WHERE user_id = current_user_id),
        'jwt_claims', auth.jwt(),
        'auth_uid', auth.uid()
    ) INTO result;
    
    RETURN result;
END;
$$;


--
-- TOC entry 429 (class 1255 OID 65828)
-- Name: draw_lucky_winners(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.draw_lucky_winners(p_campaign_id uuid) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_draw_id uuid;
  v_user_id uuid := auth.uid();
  v_user_role text;
  v_total_winners int := 0;
  rec_prize record;
  v_pool uuid[];
  v_idx int;
  v_pick uuid;
BEGIN
  SELECT up.role INTO v_user_role
  FROM public.users_profile up
  WHERE up.user_id = v_user_id;

  IF v_user_role NOT IN ('hq_admin','power_user') THEN
    RETURN json_build_object('success', false, 'message','Only HQ Admin and Power User can start draws');
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM public.campaigns 
    WHERE id = p_campaign_id AND type='lucky_draw' AND status='active'
  ) THEN
    RETURN json_build_object('success', false, 'message','Campaign not found or not active');
  END IF;

  IF NOT EXISTS (SELECT 1 FROM public.campaign_prizes WHERE campaign_id=p_campaign_id) THEN
    RETURN json_build_object('success', false, 'message','No prizes configured');
  END IF;

  IF NOT EXISTS (SELECT 1 FROM public.campaign_draw_submissions WHERE campaign_id=p_campaign_id) THEN
    RETURN json_build_object('success', false, 'message','No participants');
  END IF;

  INSERT INTO public.campaign_draws (campaign_id, executed_by, note)
  VALUES (p_campaign_id, v_user_id, 'Lucky draw executed')
  RETURNING id INTO v_draw_id;

  SELECT array_agg(s.id) INTO v_pool
  FROM public.campaign_draw_submissions s
  WHERE s.campaign_id = p_campaign_id
  AND NOT EXISTS (
    SELECT 1 FROM public.campaign_draw_winners w WHERE w.submission_id = s.id
  );

  IF v_pool IS NULL OR array_length(v_pool,1)=0 THEN
    RETURN json_build_object('success', false, 'message','No eligible participants');
  END IF;

  FOR rec_prize IN
    SELECT id, prize_rank, quantity
    FROM public.campaign_prizes
    WHERE campaign_id=p_campaign_id
    ORDER BY prize_rank ASC
  LOOP
    IF array_length(v_pool,1) IS NULL OR array_length(v_pool,1)=0 THEN EXIT; END IF;

    FOR v_idx IN 1..LEAST(rec_prize.quantity, COALESCE(array_length(v_pool,1),0)) LOOP
      v_pick := v_pool[1 + floor(random() * array_length(v_pool,1))::int];

      INSERT INTO public.campaign_draw_winners (campaign_id, submission_id, prize_id, draw_id, drawn_by)
      VALUES (p_campaign_id, v_pick, rec_prize.id, v_draw_id, v_user_id);

      v_pool := array_remove(v_pool, v_pick);
      v_total_winners := v_total_winners + 1;

      EXIT WHEN v_pool IS NULL OR array_length(v_pool,1)=0;
    END LOOP;
  END LOOP;

  RETURN json_build_object('success', true, 'message','Lucky draw completed', 'draw_id', v_draw_id, 'total_winners', v_total_winners);
END;
$$;


--
-- TOC entry 567 (class 1255 OID 84458)
-- Name: enforce_profile_parent(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.enforce_profile_parent() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
  if new.shop_id is not null then
    select s.distributor_id into new.distributor_id
    from public.shops s
    where s.id = new.shop_id;
  end if;
  return new;
end
$$;


--
-- TOC entry 575 (class 1255 OID 57237)
-- Name: enqueue_notification(public.notification_event_type, jsonb, jsonb, public.notification_channel_type); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.enqueue_notification(p_event public.notification_event_type, p_payload_json jsonb DEFAULT '{}'::jsonb, p_recipients_json jsonb DEFAULT '[]'::jsonb, p_channel public.notification_channel_type DEFAULT 'whatsapp'::public.notification_channel_type) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  notification_id uuid;
  event_enabled boolean := TRUE;
  whatsapp_enabled boolean := TRUE;
  daily_cap integer := 1000;
  today_count integer := 0;
BEGIN
  -- Check if event is enabled
  SELECT (value_json::boolean) INTO event_enabled
  FROM public.system_settings 
  WHERE key = 'notifications.events.' || p_event::text || '.enabled';
  
  -- Check if WhatsApp is globally enabled
  SELECT (value_json::boolean) INTO whatsapp_enabled
  FROM public.system_settings 
  WHERE key = 'notifications.whatsapp.enabled';
  
  -- If WhatsApp channel but WhatsApp disabled, skip
  IF p_channel = 'whatsapp' AND NOT whatsapp_enabled THEN
    RETURN NULL;
  END IF;
  
  -- If event not enabled, skip
  IF NOT event_enabled THEN
    RETURN NULL;
  END IF;
  
  -- Check daily cap for WhatsApp
  IF p_channel = 'whatsapp' THEN
    SELECT (value_json::integer) INTO daily_cap
    FROM public.system_settings 
    WHERE key = 'notifications.whatsapp.daily_cap';
    
    SELECT COUNT(*) INTO today_count
    FROM public.notification_queue
    WHERE channel = 'whatsapp' 
      AND DATE(created_at) = CURRENT_DATE
      AND status = 'sent';
    
    IF today_count >= daily_cap THEN
      -- Switch to email if daily cap reached
      p_channel := 'email';
    END IF;
  END IF;
  
  -- Queue the notification
  INSERT INTO public.notification_queue (
    event, payload_json, recipients_json, channel
  ) VALUES (
    p_event, p_payload_json, p_recipients_json, p_channel
  ) RETURNING id INTO notification_id;
  
  RETURN notification_id;
END;
$$;


--
-- TOC entry 557 (class 1255 OID 64144)
-- Name: ensure_distributor_org(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.ensure_distributor_org() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM public.orgs WHERE id = NEW.distributor_org_id AND type = 'distributor'
  ) THEN
    RAISE EXCEPTION 'Invalid distributor_org_id: org is not type=distributor';
  END IF;
  RETURN NEW;
END$$;


--
-- TOC entry 608 (class 1255 OID 63672)
-- Name: enter_lucky_draw(uuid, text, text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.enter_lucky_draw(p_campaign_id uuid, p_code text, p_name text, p_email text, p_phone text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_qr public.qr_master%ROWTYPE;
  v_now timestamptz := now();
BEGIN
  IF p_campaign_id IS NULL OR p_code IS NULL OR length(trim(p_code)) = 0 THEN
    RETURN json_build_object('ok', false, 'reason', 'invalid_input');
  END IF;

  SELECT * INTO v_qr FROM public.qr_master WHERE code = p_code LIMIT 1;
  IF NOT FOUND THEN
    RETURN json_build_object('ok', false, 'reason', 'not_found');
  END IF;

  IF EXISTS (
    SELECT 1 FROM public.campaign_draw_submissions
     WHERE campaign_id = p_campaign_id AND qr_id = v_qr.id
  ) THEN
    RETURN json_build_object('ok', false, 'reason', 'already_used',
                             'created_at', (SELECT created_at FROM public.campaign_draw_submissions
                                            WHERE campaign_id = p_campaign_id AND qr_id = v_qr.id));
  END IF;

  INSERT INTO public.campaign_draw_submissions(campaign_id, qr_id, code, name, email, phone, created_at)
  VALUES (p_campaign_id, v_qr.id, p_code, p_name, p_email, p_phone, v_now);

  -- Optional: also record a verify-style scan event for audit
  INSERT INTO public.qr_scan_events(qr_code_id, qr_code, scanned_by, scan_type, additional_data)
  SELECT qc.id, p_code, auth.uid(), 'verify',
         jsonb_build_object('campaign_id', p_campaign_id, 'form','lucky_draw')
  FROM public.qr_codes qc WHERE qc.qr_code = p_code
  ON CONFLICT DO NOTHING;

  -- Optional: notify using existing notification enum 'consumer_verify'
  PERFORM public.enqueue_notification(
    'consumer_verify',
    jsonb_build_object('code', p_code, 'campaign_id', p_campaign_id, 'name', p_name, 'email', p_email, 'phone', p_phone),
    NULL, 'whatsapp'
  );

  RETURN json_build_object('ok', true, 'reason', NULL, 'created_at', v_now);
END;
$$;


--
-- TOC entry 442 (class 1255 OID 56969)
-- Name: gen_hq_order_code(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.gen_hq_order_code() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NEW.code IS NULL OR NEW.code = '' THEN
    NEW.code := 'ORD-' || to_char(current_date,'YYYY') || '-' ||
      lpad(nextval('hq_order_seq')::text, 4, '0');
  END IF;
  RETURN NEW;
END;
$$;


--
-- TOC entry 517 (class 1255 OID 57125)
-- Name: gen_manufacturer_batch_number(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.gen_manufacturer_batch_number() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NEW.batch_number IS NULL OR NEW.batch_number = '' THEN
    NEW.batch_number := 'BATCH-' || to_char(current_date,'YYYY') || '-' ||
      lpad(nextval('manufacturer_batch_seq')::text, 4, '0');
  END IF;
  RETURN NEW;
END;
$$;


--
-- TOC entry 633 (class 1255 OID 52126)
-- Name: gen_order_number(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.gen_order_number() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NEW.order_number IS NULL OR NEW.order_number = '' THEN
    NEW.order_number := 'SO-' || to_char(current_date,'YYYYMMDD') || '-' ||
      lpad(nextval('order_no_seq')::text,5,'0');
  END IF;
  RETURN NEW;
END;
$$;


--
-- TOC entry 601 (class 1255 OID 50098)
-- Name: generate_sku(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.generate_sku(product_name text DEFAULT NULL::text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
  sku_prefix text;
  random_suffix text;
  final_sku text;
  attempt_count int := 0;
  max_attempts int := 10;
BEGIN
  -- Generate SKU prefix from product name or use default
  IF product_name IS NOT NULL AND length(trim(product_name)) > 0 THEN
    -- Extract first 3 alphanumeric characters from name
    sku_prefix := upper(regexp_replace(trim(product_name), '[^a-zA-Z0-9]', '', 'g'));
    sku_prefix := left(sku_prefix, 3);
    -- Pad with 'X' if less than 3 characters
    WHILE length(sku_prefix) < 3 LOOP
      sku_prefix := sku_prefix || 'X';
    END LOOP;
  ELSE
    sku_prefix := 'PRD';
  END IF;

  -- Generate unique SKU
  LOOP
    -- Generate random 5-character suffix
    random_suffix := upper(substr(md5(random()::text), 1, 5));
    final_sku := sku_prefix || random_suffix;
    
    -- Check if SKU already exists
    IF NOT EXISTS (SELECT 1 FROM public.products WHERE sku = final_sku) THEN
      EXIT;
    END IF;
    
    attempt_count := attempt_count + 1;
    IF attempt_count >= max_attempts THEN
      -- Fallback: use timestamp-based suffix
      final_sku := sku_prefix || to_char(extract(epoch from now())::int, 'FM00000');
      EXIT;
    END IF;
  END LOOP;

  RETURN final_sku;
END;
$$;


--
-- TOC entry 585 (class 1255 OID 49597)
-- Name: generate_sku(public.product_category_type); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.generate_sku(p_category public.product_category_type) RETURNS text
    LANGUAGE plpgsql
    AS $$
declare
  v_seq bigint;
  v_prefix text := case when p_category = 'vape' then 'V' else 'N' end;
  v_date text := to_char(now(),'YYMMDD');
begin
  if p_category = 'vape' then
    v_seq := nextval('sku_seq_vape');
  else
    v_seq := nextval('sku_seq_nonvape');
  end if;
  return v_prefix || '-' || v_date || '-' || lpad(v_seq::text, 4, '0');
end;
$$;


--
-- TOC entry 530 (class 1255 OID 82501)
-- Name: generate_sku(uuid, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.generate_sku(p_product_id uuid, p_serial integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
begin
  return 'SKU-' || replace(p_product_id::text,'-','') || '-' || lpad(p_serial::text,6,'0');
end $$;


--
-- TOC entry 652 (class 1255 OID 57671)
-- Name: get_all_users_for_management(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_all_users_for_management() RETURNS TABLE(user_id uuid, email text, first_name text, last_name text, role text, manufacturer_id uuid, manufacturer_name text, org_id uuid, org_name text, is_active boolean, last_login timestamp with time zone, created_at timestamp with time zone, created_by uuid)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  -- Only allow HQ Admin and Power User to access this function
  IF (SELECT auth.jwt() ->> 'role') NOT IN ('hq_admin', 'power_user') THEN
    RAISE EXCEPTION 'Access denied. Only HQ Admin and Power User can access user management.';
  END IF;

  RETURN QUERY
  SELECT 
    up.user_id,
    up.email,
    up.first_name,
    up.last_name,
    up.role,
    up.manufacturer_id,
    m.name as manufacturer_name,
    up.org_id,
    o.name as org_name,
    up.is_active,
    up.last_login,
    up.created_at,
    up.created_by
  FROM public.users_profile up
  LEFT JOIN public.manufacturers m ON m.id = up.manufacturer_id
  LEFT JOIN public.orgs o ON o.id = up.org_id
  ORDER BY up.created_at DESC;
END;
$$;


--
-- TOC entry 554 (class 1255 OID 59254)
-- Name: get_available_products_for_orders(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_available_products_for_orders() RETURNS TABLE(id uuid, name text, sku text, manufacturer_id uuid, manufacturer_name text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    p.id,
    p.name,
    p.sku,
    p.manufacturer_id,
    m.name as manufacturer_name
  FROM public.products p
  INNER JOIN public.manufacturers m ON p.manufacturer_id = m.id  -- Changed to INNER JOIN
  WHERE p.approval_status = 'approved'
    AND (p.is_active = true OR p.is_active IS NULL)
    AND p.manufacturer_id IS NOT NULL  -- Ensure manufacturer_id is not null
    AND m.name IS NOT NULL  -- Ensure manufacturer name exists
    -- Removed the restriction that prevented re-ordering products already in approved orders
    -- This allows HQ Admin to create new orders with products that are already in approved orders
  ORDER BY p.name;
END;
$$;


--
-- TOC entry 640 (class 1255 OID 57238)
-- Name: get_notification_template(public.notification_event_type, public.notification_channel_type); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_notification_template(p_event public.notification_event_type, p_channel public.notification_channel_type) RETURNS text
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  template_json jsonb;
  template_text text;
BEGIN
  SELECT value_json INTO template_json
  FROM public.system_settings 
  WHERE key = 'notifications.templates.' || p_event::text;
  
  IF template_json IS NULL THEN
    RETURN 'Notification: ' || p_event::text;
  END IF;
  
  template_text := template_json ->> p_channel::text;
  
  IF template_text IS NULL THEN
    template_text := template_json ->> 'whatsapp';
  END IF;
  
  RETURN COALESCE(template_text, 'Notification: ' || p_event::text);
END;
$$;


--
-- TOC entry 593 (class 1255 OID 57670)
-- Name: get_orders_for_current_user(text, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_orders_for_current_user(p_status text DEFAULT NULL::text, p_limit integer DEFAULT 50, p_offset integer DEFAULT 0) RETURNS TABLE(id uuid, code text, status public.hq_order_status_type, priority public.order_priority_type, notes text, created_by uuid, approved_by uuid, approved_at timestamp with time zone, total_qty integer, total_qr integer, total_po_amount numeric, created_at timestamp with time zone, updated_at timestamp with time zone, line_items_count bigint, manufacturer_names text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  user_role text;
  user_manufacturer_id uuid;
BEGIN
  -- Get current user role and manufacturer ID
  SELECT auth.jwt() ->> 'role' INTO user_role;
  
  IF user_role = 'manufacturer' THEN
    SELECT up.manufacturer_id INTO user_manufacturer_id
    FROM public.users_profile up 
    WHERE up.user_id = auth.uid()
    AND up.manufacturer_id IS NOT NULL;
  END IF;

  RETURN QUERY
  SELECT 
    o.id,
    o.code,
    o.status,
    o.priority,
    o.notes,
    o.created_by,
    o.approved_by,
    o.approved_at,
    o.total_qty,
    o.total_qr,
    o.total_po_amount,
    o.created_at,
    o.updated_at,
    COUNT(oli.id) as line_items_count,
    STRING_AGG(DISTINCT m.name, ', ') as manufacturer_names
  FROM public.hq_orders o
  LEFT JOIN public.hq_order_line_items oli ON oli.order_id = o.id
  LEFT JOIN public.manufacturers m ON m.id = oli.manufacturer_id
  WHERE 
    -- Apply status filter if provided
    (p_status IS NULL OR o.status::text = p_status)
    AND
    -- Apply role-based filtering
    CASE 
      WHEN user_role IN ('hq_admin', 'power_user') THEN true
      WHEN user_role = 'manufacturer' AND user_manufacturer_id IS NOT NULL THEN 
        EXISTS (
          SELECT 1 FROM public.hq_order_line_items oli2 
          WHERE oli2.order_id = o.id 
          AND oli2.manufacturer_id = user_manufacturer_id
        )
      ELSE false
    END
  GROUP BY o.id, o.code, o.status, o.priority, o.notes, o.created_by, o.approved_by, o.approved_at, 
           o.total_qty, o.total_qr, o.total_po_amount, o.created_at, o.updated_at
  ORDER BY o.created_at DESC
  LIMIT p_limit OFFSET p_offset;
END;
$$;


--
-- TOC entry 533 (class 1255 OID 53024)
-- Name: has_role(text[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.has_role(roles text[]) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  select exists (
    select 1
    from public.users_profile up
    where up.user_id = auth.uid()
      and up.role = any(roles)
  );
$$;


--
-- TOC entry 544 (class 1255 OID 57542)
-- Name: initialize_user_profile(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.initialize_user_profile() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    INSERT INTO public.users_profile (
        user_id,
        email,
        first_name,
        last_name,
        phone,
        role,
        org_id,
        created_at,
        updated_at
    )
    VALUES (
        NEW.id,
        NEW.email,
        COALESCE(NEW.raw_user_meta_data->>'first_name', split_part(NEW.email, '@', 1)),
        NEW.raw_user_meta_data->>'last_name',
        NEW.phone,
        COALESCE(NEW.raw_user_meta_data->>'role', 'customer'),
        COALESCE(
            (SELECT id FROM public.orgs WHERE type = COALESCE(NEW.raw_user_meta_data->>'role', 'customer') LIMIT 1),
            (SELECT id FROM public.orgs LIMIT 1)
        ),
        now(),
        now()
    )
    ON CONFLICT (user_id) DO UPDATE SET
        email = EXCLUDED.email,
        updated_at = now();
    
    RETURN NEW;
END;
$$;


--
-- TOC entry 708 (class 1255 OID 57368)
-- Name: is_product_in_approved_orders(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.is_product_in_approved_orders(p_product_id uuid) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  order_count integer;
BEGIN
  SELECT COUNT(*) INTO order_count
  FROM public.hq_order_line_items oli
  INNER JOIN public.hq_orders o ON oli.order_id = o.id
  WHERE oli.product_id = p_product_id
    AND o.status IN ('approved', 'po_sent', 'payment_notified', 'payment_verified');
  
  RETURN order_count > 0;
END;
$$;


--
-- TOC entry 543 (class 1255 OID 66989)
-- Name: is_qr_eligible_for_campaign(uuid, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.is_qr_eligible_for_campaign(p_campaign_id uuid, p_qr_id uuid) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.qr_master qm
    JOIN public.purchase_orders po ON po.id = qm.po_id
    WHERE qm.id = p_qr_id
      AND po.campaign_id = p_campaign_id
  );
$$;


--
-- TOC entry 463 (class 1255 OID 67655)
-- Name: migrate_campaign_approvals(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.migrate_campaign_approvals() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  campaign_record RECORD;
  workflow_id UUID;
BEGIN
  -- Get the campaign approval workflow ID
  SELECT id INTO workflow_id FROM public.approval_workflows WHERE name = 'Campaign Approval';
  
  -- If workflow doesn't exist, create it
  IF workflow_id IS NULL THEN
    INSERT INTO public.approval_workflows (name, description) 
    VALUES ('Campaign Approval', 'Approval workflow for campaign submissions')
    RETURNING id INTO workflow_id;
  END IF;
  
  -- Migrate existing campaign approvals
  FOR campaign_record IN 
    SELECT c.id, c.name, c.type, c.created_by, c.status, c.approved_at, c.approved_by
    FROM public.campaigns c 
    WHERE c.status IS NOT NULL
  LOOP
    -- Insert into approval_entities
    INSERT INTO public.approval_entities (
      workflow_id,
      entity_id,
      entity_type,
      title,
      description,
      submitter_id,
      status,
      approver_id,
      approved_at,
      metadata
    ) VALUES (
      workflow_id,
      campaign_record.id,
      'campaign',
      campaign_record.name,
      'Campaign type: ' || campaign_record.type,
      campaign_record.created_by,
      CASE 
        WHEN campaign_record.status = 'pending_approval' THEN 'pending'
        WHEN campaign_record.status = 'active' THEN 'approved'
        WHEN campaign_record.status = 'draft' THEN 'draft'
        ELSE campaign_record.status
      END,
      campaign_record.approved_by,
      campaign_record.approved_at,
      jsonb_build_object('type', campaign_record.type)
    );
  END LOOP;
END;
$$;


--
-- TOC entry 449 (class 1255 OID 67654)
-- Name: migrate_existing_approvals(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.migrate_existing_approvals() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  product_record RECORD;
  workflow_id UUID;
  entity_id UUID;
BEGIN
  -- Get the product approval workflow ID
  SELECT id INTO workflow_id FROM public.approval_workflows WHERE name = 'Product Approval';
  
  -- If workflow doesn't exist, create it
  IF workflow_id IS NULL THEN
    INSERT INTO public.approval_workflows (name, description) 
    VALUES ('Product Approval', 'Approval workflow for product submissions')
    RETURNING id INTO workflow_id;
  END IF;
  
  -- Migrate existing product approvals
  FOR product_record IN 
    SELECT p.id, p.name, p.sku, p.created_by, p.approval_status, p.submitted_for_approval_at, 
           p.approved_at, p.approved_by, p.rejected_at, p.rejected_by, p.rejection_reason
    FROM public.products p 
    WHERE p.approval_status IS NOT NULL AND p.approval_status != 'draft'
  LOOP
    -- Insert into approval_entities
    INSERT INTO public.approval_entities (
      workflow_id,
      entity_id,
      entity_type,
      title,
      description,
      submitter_id,
      submitted_at,
      status,
      approver_id,
      approved_at,
      rejected_at,
      rejection_reason,
      metadata
    ) VALUES (
      workflow_id,
      product_record.id,
      'product',
      product_record.name,
      'Product SKU: ' || product_record.sku,
      product_record.created_by,
      product_record.submitted_for_approval_at,
      CASE 
        WHEN product_record.approval_status = 'submitted' THEN 'pending'
        WHEN product_record.approval_status = 'approved' THEN 'approved'
        WHEN product_record.approval_status = 'rejected' THEN 'rejected'
        ELSE product_record.approval_status
      END,
      product_record.approved_by,
      product_record.approved_at,
      product_record.rejected_at,
      product_record.rejection_reason,
      jsonb_build_object('sku', product_record.sku)
    );
  END LOOP;
END;
$$;


--
-- TOC entry 512 (class 1255 OID 62928)
-- Name: po_acknowledge(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.po_acknowledge(p_po_id uuid) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
begin
  -- authorize: caller must belong to the PO's manufacturer
  if not exists (
    select 1
    from public.purchase_orders p
    join public.manufacturer_users mu
      on mu.manufacturer_id = p.manufacturer_id
    where p.id = p_po_id
      and mu.user_id = auth.uid()
  ) then
    raise exception 'not allowed';
  end if;

  -- update status
  update public.purchase_orders
     set status = 'acknowledged',
         updated_at = now()
   where id = p_po_id
     and status in ('approved','sent');

  -- history
  insert into public.po_status_history(po_id, action, performed_by, comment)
  values (p_po_id, 'acknowledged', auth.uid(), null);
end;
$$;


--
-- TOC entry 457 (class 1255 OID 57370)
-- Name: prevent_critical_product_updates(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.prevent_critical_product_updates() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Only check if product is in approved orders
  IF public.is_product_in_approved_orders(OLD.id) THEN
    -- Prevent status changes that would make product inactive
    IF OLD.status = 'active' AND NEW.status != 'active' THEN
      RAISE EXCEPTION 'Cannot change status of product "%". Product is in approved orders and must remain active.', OLD.name
        USING HINT = 'Products in approved orders cannot be deactivated.',
              ERRCODE = 'P0002';
    END IF;
    
    -- Prevent manufacturer changes
    IF OLD.manufacturer_id != NEW.manufacturer_id THEN
      RAISE EXCEPTION 'Cannot change manufacturer of product "%". Product is in approved orders.', OLD.name
        USING HINT = 'Products in approved orders cannot change manufacturers.',
              ERRCODE = 'P0003';
    END IF;
    
    -- Prevent category changes that would affect workflow
    IF OLD.product_category != NEW.product_category THEN
      RAISE EXCEPTION 'Cannot change product category of "%". Product is in approved orders.', OLD.name
        USING HINT = 'Products in approved orders cannot change categories.',
              ERRCODE = 'P0004';
    END IF;
  END IF;
  
  RETURN NEW;
END;
$$;


--
-- TOC entry 514 (class 1255 OID 57369)
-- Name: prevent_product_deletion(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.prevent_product_deletion() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Check if product is in any approved orders
  IF public.is_product_in_approved_orders(OLD.id) THEN
    RAISE EXCEPTION 'Cannot delete product "%". Product is already in approved orders and cannot be removed.', OLD.name
      USING HINT = 'Products in approved orders are locked for transaction integrity.',
            ERRCODE = 'P0001';
  END IF;
  
  RETURN OLD;
END;
$$;


--
-- TOC entry 635 (class 1255 OID 67214)
-- Name: publish_draw(uuid, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.publish_draw(p_draw_id uuid, p_publish boolean DEFAULT true) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  UPDATE public.campaign_draws SET is_published = p_publish WHERE id = p_draw_id;
  RETURN json_build_object('success', true, 'draw_id', p_draw_id, 'is_published', p_publish);
END $$;


--
-- TOC entry 702 (class 1255 OID 63280)
-- Name: qr_scan_activate(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.qr_scan_activate(p_code text DEFAULT NULL::text, p_rfid_uid text DEFAULT NULL::text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
declare
  v_user uuid := auth.uid();
  v_org  uuid;
  v_qr   qr_master%rowtype;
  v_now  timestamptz := now();
  v_first boolean := false;
begin
  if v_user is null then
    raise exception 'unauthenticated';
  end if;

  select org_id into v_org
  from public.users_profile
  where user_id = v_user
  limit 1;

  if v_org is null then
    raise exception 'no_org_for_user';
  end if;

  -- Find the QR by code or RFID
  select * into v_qr
  from public.qr_master
  where (p_code is not null and code = p_code)
     or (p_rfid_uid is not null and rfid_uid = p_rfid_uid)
  limit 1;

  if not found then
    raise exception 'qr_not_found';
  end if;

  -- First activation only flips status/owner; subsequent scans just log
  if v_qr.status <> 'activated' then
    v_first := true;
    update public.qr_master
       set status = 'activated',
           owner_org_id = v_org,
           updated_at = v_now
     where id = v_qr.id;
  end if;

  insert into public.qr_events(qr_id, event, org_id, performed_by, meta)
  values (v_qr.id, case when v_first then 'activated' else 'scanned' end, v_org, v_user,
          jsonb_build_object('by','shop_scan','code',p_code,'rfid',p_rfid_uid));

  return json_build_object(
    'ok', true,
    'first_activation', v_first,
    'qr_id', v_qr.id,
    'product_id', v_qr.product_id,
    'po_id', v_qr.po_id
  );
end;
$$;


--
-- TOC entry 615 (class 1255 OID 57018)
-- Name: recalc_hq_order_totals(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.recalc_hq_order_totals(p_order_id uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_total_qty integer;
  v_total_qr integer;
  v_total_amount numeric(12,2);
BEGIN
  SELECT 
    COALESCE(SUM(order_qty), 0),
    COALESCE(SUM(total_qr), 0), 
    COALESCE(SUM(line_total), 0)
  INTO v_total_qty, v_total_qr, v_total_amount
  FROM public.hq_order_line_items 
  WHERE order_id = p_order_id;

  UPDATE public.hq_orders 
  SET 
    total_qty = v_total_qty,
    total_qr = v_total_qr,
    total_po_amount = v_total_amount,
    updated_at = now()
  WHERE id = p_order_id;
END;
$$;


--
-- TOC entry 553 (class 1255 OID 52160)
-- Name: recalc_order_totals(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.recalc_order_totals(p_order_id uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_subtotal numeric(12,2);
  v_tax      numeric(12,2);
BEGIN
  SELECT
    COALESCE(SUM( (oi.quantity * oi.unit_price) * (1 - oi.discount_rate) ),0)::numeric(12,2),
    COALESCE(SUM( (oi.quantity * oi.unit_price) * (1 - oi.discount_rate) * oi.tax_rate ),0)::numeric(12,2)
  INTO v_subtotal, v_tax
  FROM public.order_items oi
  WHERE oi.order_id = p_order_id;

  UPDATE public.orders o
  SET subtotal   = v_subtotal,
      tax_amount = v_tax,
      total      = (v_subtotal + o.shipping_cost + v_tax - o.discount_amount),
      updated_at = now()
  WHERE o.id = p_order_id;
END;
$$;


--
-- TOC entry 519 (class 1255 OID 50630)
-- Name: record_qr_scan(text, text, jsonb, jsonb, jsonb); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.record_qr_scan(qr_code_param text, scan_type_param text DEFAULT 'verify'::text, location_data_param jsonb DEFAULT NULL::jsonb, device_info_param jsonb DEFAULT NULL::jsonb, additional_data_param jsonb DEFAULT NULL::jsonb) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  qr_rec public.qr_codes%ROWTYPE;
BEGIN
  SELECT * INTO qr_rec FROM public.qr_codes WHERE qr_code = qr_code_param;
  IF NOT FOUND THEN
    RETURN json_build_object('success', false, 'message', 'Invalid QR code');
  END IF;

  INSERT INTO public.qr_scan_events (qr_code_id, qr_code, scanned_by, scan_type, location_data, device_info, additional_data)
  VALUES (qr_rec.id, qr_code_param, auth.uid(), scan_type_param, location_data_param, device_info_param, additional_data_param);

  UPDATE public.qr_codes
  SET scan_count = scan_count + 1,
      last_scanned_at = now(),
      first_scanned_at = coalesce(first_scanned_at, now())
  WHERE id = qr_rec.id;

  RETURN json_build_object('success', true, 'message', 'QR scan recorded',
                           'qr_code_id', qr_rec.id, 'batch_id', qr_rec.batch_id, 'product_id', qr_rec.product_id);
END;
$$;


--
-- TOC entry 496 (class 1255 OID 70853)
-- Name: redeem_reward_transaction(uuid, uuid, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.redeem_reward_transaction(p_user_id uuid, p_reward_id uuid, p_points_cost integer) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_transaction_id UUID;
  v_redemption_id UUID;
  v_current_points INTEGER;
BEGIN
  -- Check user has enough points
  SELECT current_points INTO v_current_points
  FROM royalty_user_rewards
  WHERE user_id = p_user_id;

  IF v_current_points < p_points_cost THEN
    RAISE EXCEPTION 'Insufficient points: % available, % required', v_current_points, p_points_cost;
  END IF;

  -- Create transaction record
  INSERT INTO royalty_transactions (
    user_id, type, description, points, category, status
  ) VALUES (
    p_user_id, 'redeemed', 'Reward redemption', p_points_cost, 'redemption', 'completed'
  ) RETURNING id INTO v_transaction_id;

  -- Create redemption record
  INSERT INTO royalty_redemptions (
    user_id, reward_id, transaction_id, status
  ) VALUES (
    p_user_id, p_reward_id, v_transaction_id, 'pending'
  ) RETURNING id INTO v_redemption_id;

  -- Deduct points from user
  UPDATE royalty_user_rewards 
  SET 
    current_points = current_points - p_points_cost,
    updated_at = NOW()
  WHERE user_id = p_user_id;

  -- Update reward redemption count
  UPDATE royalty_catalog 
  SET 
    current_redemptions = current_redemptions + 1,
    updated_at = NOW()
  WHERE id = p_reward_id;

  RETURN v_redemption_id;
END;
$$;


--
-- TOC entry 614 (class 1255 OID 67551)
-- Name: reject_product(uuid, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.reject_product(p_product_id uuid, p_rejection_reason text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  current_user_id uuid;
  result jsonb;
BEGIN
  -- Get current user ID
  current_user_id := auth.uid();
  
  -- Check if user has permission
  IF NOT EXISTS (
    SELECT 1 FROM public.users_profile 
    WHERE user_id = current_user_id 
    AND role IN ('hq_admin', 'power_user')
  ) THEN
    RETURN jsonb_build_object(
      'success', false,
      'error', 'Insufficient permissions'
    );
  END IF;

  -- Update product approval status
  UPDATE public.products
  SET 
    approval_status = 'rejected',
    rejected_at = NOW(),
    rejected_by = current_user_id,
    rejection_reason = p_rejection_reason,
    updated_at = NOW()
  WHERE id = p_product_id;

  -- Insert rejection history if table exists
  BEGIN
    INSERT INTO public.product_approval_history (
      product_id,
      action,
      comment,
      performed_by,
      performed_at
    ) VALUES (
      p_product_id,
      'rejected',
      p_rejection_reason,
      current_user_id,
      NOW()
    );
  EXCEPTION WHEN undefined_table THEN
    -- Table doesn't exist, skip history logging
    NULL;
  END;

  RETURN jsonb_build_object(
    'success', true,
    'message', 'Product rejected successfully'
  );
END;
$$;


--
-- TOC entry 627 (class 1255 OID 50213)
-- Name: reject_product(uuid, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.reject_product(product_id_param uuid, reason_param text, comment_param text DEFAULT NULL::text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE st text;
DECLARE user_id uuid;
BEGIN
  -- Get current user ID, use NULL if not available (for admin operations)
  user_id := auth.uid();
  
  -- Check permissions - allow both hq_admin and power_user
  IF NOT (app.is_hq_admin() OR app.is_power_user()) THEN
    -- Check if this is a test user by checking the users_profile table directly
    IF user_id IS NOT NULL AND NOT EXISTS (
      SELECT 1 FROM public.users_profile up
      WHERE up.user_id = user_id
      AND (up.role = 'hq_admin' OR up.role = 'power_user')
    ) THEN
      RETURN json_build_object('success', false, 'message', 'Insufficient permissions. Only HQ Admin or Power User can reject products.');
    END IF;
  END IF;

  SELECT approval_status INTO st FROM public.products WHERE id = product_id_param;
  IF NOT FOUND THEN
    RETURN json_build_object('success', false, 'message', 'Product not found');
  END IF;
  IF st <> 'pending_approval' THEN
    RETURN json_build_object('success', false, 'message', 'Product is not pending approval');
  END IF;

  UPDATE public.products
  SET approval_status='rejected',
      rejected_at=now(),
      rejected_by=user_id,
      rejection_reason=reason_param,
      status='inactive'
  WHERE id = product_id_param;

  -- Insert into history with proper NULL handling
  INSERT INTO public.product_approval_history (product_id, action, performed_by, comment)
  VALUES (product_id_param, 'rejected', user_id, comment_param);

  RETURN json_build_object('success', true, 'message', 'Product rejected');
END;
$$;


--
-- TOC entry 4399 (class 0 OID 0)
-- Dependencies: 627
-- Name: FUNCTION reject_product(product_id_param uuid, reason_param text, comment_param text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.reject_product(product_id_param uuid, reason_param text, comment_param text) IS 'Reject product with reason (HQ admin only)';


--
-- TOC entry 662 (class 1255 OID 52166)
-- Name: release_stock(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.release_stock(p_order_id uuid) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE r RECORD;
BEGIN
  FOR r IN
    SELECT oi.product_id, oi.batch_id, oi.quantity
    FROM public.order_items oi
    WHERE oi.order_id = p_order_id
  LOOP
    INSERT INTO public.inventory_ledger(product_id, batch_id, order_id, transaction_type, quantity, created_by, notes)
    VALUES (r.product_id, r.batch_id, p_order_id, 'release', r.quantity, auth.uid(), 'Order cancel/release');
  END LOOP;
  UPDATE public.orders SET order_status='cancelled', updated_at=now() WHERE id = p_order_id;
END;
$$;


--
-- TOC entry 549 (class 1255 OID 57673)
-- Name: request_user_password_reset(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.request_user_password_reset(p_user_id uuid) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  -- Only allow HQ Admin and Power User to request password resets
  IF (SELECT auth.jwt() ->> 'role') NOT IN ('hq_admin', 'power_user') THEN
    RAISE EXCEPTION 'Access denied. Only HQ Admin and Power User can request password resets.';
  END IF;

  -- Set password reset flag
  UPDATE public.users_profile 
  SET 
    password_reset_required = true,
    updated_at = now()
  WHERE user_id = p_user_id;

  RETURN true;
END;
$$;


--
-- TOC entry 541 (class 1255 OID 49602)
-- Name: reserve_sku(public.product_category_type); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.reserve_sku(p_product_category public.product_category_type) RETURNS text
    LANGUAGE sql SECURITY DEFINER
    AS $$
  select generate_sku(p_product_category);
$$;


--
-- TOC entry 511 (class 1255 OID 52165)
-- Name: reserve_stock(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.reserve_stock(p_order_id uuid) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE r RECORD;
BEGIN
  FOR r IN
    SELECT oi.product_id, oi.batch_id, oi.quantity
    FROM public.order_items oi
    WHERE oi.order_id = p_order_id
  LOOP
    INSERT INTO public.inventory_ledger(product_id, batch_id, order_id, transaction_type, quantity, created_by, notes)
    VALUES (r.product_id, r.batch_id, p_order_id, 'reserve', r.quantity, auth.uid(), 'Order reserve');
  END LOOP;
  UPDATE public.orders SET order_status='confirmed', updated_at=now() WHERE id = p_order_id;
END;
$$;


--
-- TOC entry 644 (class 1255 OID 65754)
-- Name: resolve_shop_from_link(uuid, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.resolve_shop_from_link(p_campaign_id uuid, p_token text) RETURNS uuid
    LANGUAGE sql SECURITY DEFINER
    AS $$
  SELECT csl.shop_id
  FROM public.campaign_shop_links csl
  WHERE csl.campaign_id = p_campaign_id
    AND csl.token       = p_token
    AND csl.is_active   = true
    AND (csl.expires_at IS NULL OR now() <= csl.expires_at);
$$;


--
-- TOC entry 656 (class 1255 OID 48362)
-- Name: set_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.set_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
  new.updated_at := now();
  return new;
end $$;


--
-- TOC entry 703 (class 1255 OID 57335)
-- Name: submit_campaign_for_approval(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.submit_campaign_for_approval(p_campaign_id uuid) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  current_status campaign_status_type;
BEGIN
  -- Only HQ Admin can submit
  IF NOT app.is_hq_admin() THEN
    RETURN json_build_object('success', false, 'message', 'Only HQ Admin can submit campaigns for approval');
  END IF;

  SELECT status INTO current_status FROM public.campaigns WHERE id = p_campaign_id;
  IF current_status IS NULL THEN
    RETURN json_build_object('success', false, 'message', 'Campaign not found');
  END IF;

  IF current_status <> 'draft' THEN
    RETURN json_build_object('success', false, 'message', 'Only draft campaigns can be submitted for approval');
  END IF;

  UPDATE public.campaigns
  SET status = 'pending_approval',
      updated_at = now()
  WHERE id = p_campaign_id;

  RETURN json_build_object('success', true, 'message', 'Campaign submitted for approval');
END;
$$;


--
-- TOC entry 528 (class 1255 OID 50211)
-- Name: submit_product_for_approval(uuid, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.submit_product_for_approval(product_id_param uuid, comment_param text DEFAULT NULL::text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE st text;
DECLARE user_id uuid;
BEGIN
  -- Get current user ID, use NULL if not available (for admin operations)
  user_id := auth.uid();
  
  -- Check permissions - allow both hq_admin and power_user
  IF NOT (app.is_hq_admin() OR app.is_power_user()) THEN
    -- Check if this is a test user by checking the users_profile table directly
    IF user_id IS NOT NULL AND NOT EXISTS (
      SELECT 1 FROM public.users_profile up
      WHERE up.user_id = user_id
      AND (up.role = 'hq_admin' OR up.role = 'power_user')
    ) THEN
      RETURN json_build_object('success', false, 'message', 'Insufficient permissions. Only HQ Admin or Power User can submit products for approval.');
    END IF;
  END IF;
  
  SELECT approval_status INTO st FROM public.products WHERE id = product_id_param;
  IF NOT FOUND THEN
    RETURN json_build_object('success', false, 'message', 'Product not found');
  END IF;
  IF st <> 'draft' THEN
    RETURN json_build_object('success', false, 'message', 'Product is not in draft status');
  END IF;

  UPDATE public.products
  SET approval_status='pending_approval'
  WHERE id = product_id_param;

  -- Insert into history with proper NULL handling
  INSERT INTO public.product_approval_history (product_id, action, performed_by, comment)
  VALUES (product_id_param, 'submitted', user_id, comment_param);

  RETURN json_build_object('success', true, 'message', 'Submitted for approval');
END;
$$;


--
-- TOC entry 4400 (class 0 OID 0)
-- Dependencies: 528
-- Name: FUNCTION submit_product_for_approval(product_id_param uuid, comment_param text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.submit_product_for_approval(product_id_param uuid, comment_param text) IS 'Submit product for HQ admin approval';


--
-- TOC entry 561 (class 1255 OID 65710)
-- Name: tg_populate_lucky_draw_submission_ctx(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.tg_populate_lucky_draw_submission_ctx() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_shop_id     uuid;
  v_order_id    uuid;
  v_hq_order_id uuid;
BEGIN
  -- Prefer provided shop_id (e.g., shop link or logged-in); else resolve from QR events
  IF NEW.shop_id IS NULL AND NEW.qr_id IS NOT NULL THEN
    SELECT qe.actor_org_id
      INTO v_shop_id
      FROM public.qr_events qe
     WHERE qe.qr_id = NEW.qr_id
     ORDER BY qe.created_at DESC
     LIMIT 1;
    NEW.shop_id := v_shop_id;
  END IF;

  -- Shop order via units.code (if code present)
  IF NEW.order_id IS NULL AND NEW.code IS NOT NULL THEN
    SELECT u.order_id INTO v_order_id
    FROM public.units u WHERE u.code = NEW.code;
    NEW.order_id := v_order_id;
  END IF;

  -- HQ order via qr_master → purchase_orders → hq_orders
  IF NEW.hq_order_id IS NULL AND NEW.qr_id IS NOT NULL THEN
    SELECT ho.id INTO v_hq_order_id
    FROM public.qr_master qm
    JOIN public.purchase_orders po ON po.id = qm.po_id
    JOIN public.hq_orders      ho ON ho.id = po.order_id
    WHERE qm.id = NEW.qr_id;
    NEW.hq_order_id := v_hq_order_id;
  END IF;

  -- Default source_type if not provided
  IF NEW.source_type IS NULL THEN
    NEW.source_type := CASE
      WHEN NEW.qr_id    IS NOT NULL THEN 'unit_qr'
      WHEN NEW.shop_id  IS NOT NULL THEN 'shop_link'
      WHEN auth.uid()   IS NOT NULL THEN 'logged_in'
      ELSE 'generic_link'
    END;
  END IF;

  NEW.resolved_at := now();
  RETURN NEW;
END;
$$;


--
-- TOC entry 475 (class 1255 OID 57019)
-- Name: tg_recalc_hq_order_totals(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.tg_recalc_hq_order_totals() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM public.recalc_hq_order_totals(COALESCE(NEW.order_id, OLD.order_id));
  RETURN COALESCE(NEW, OLD);
END;
$$;


--
-- TOC entry 607 (class 1255 OID 52161)
-- Name: tg_recalc_order_totals(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.tg_recalc_order_totals() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM public.recalc_order_totals(COALESCE(NEW.order_id, OLD.order_id));
  RETURN COALESCE(NEW, OLD);
END;
$$;


--
-- TOC entry 572 (class 1255 OID 69535)
-- Name: tg_set_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.tg_set_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN NEW.updated_at = now(); RETURN NEW; END $$;


--
-- TOC entry 455 (class 1255 OID 59789)
-- Name: tg_touch_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.tg_touch_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END $$;


--
-- TOC entry 468 (class 1255 OID 46841)
-- Name: touch_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.touch_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
  new.updated_at = now();
  return new;
end;
$$;


--
-- TOC entry 576 (class 1255 OID 82502)
-- Name: trg_assign_sku(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.trg_assign_sku() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$
declare v_serial int;
begin
  if new.sku is null or new.sku = '' then
    select coalesce(max((regexp_match(sku, '-(\\d+)$'))[1]::int), 0) + 1
      into v_serial
    from public.product_variants
    where product_id = new.product_id;
    new.sku := public.generate_sku(new.product_id, v_serial);
  end if;
  return new;
end $_$;


--
-- TOC entry 498 (class 1255 OID 49598)
-- Name: trg_products_ensure_sku_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.trg_products_ensure_sku_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
  if new.sku is null or btrim(new.sku) = '' then
    new.sku := generate_sku(new.product_category);
  else
    -- normalize user-provided sku (if any)
    new.sku := upper(regexp_replace(new.sku, '[^A-Za-z0-9\-]', '', 'g'));
  end if;
  return new;
end;
$$;


--
-- TOC entry 471 (class 1255 OID 50019)
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;


--
-- TOC entry 577 (class 1255 OID 57333)
-- Name: validate_campaign_product(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.validate_campaign_product() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  product_category text;
BEGIN
  -- Get the product category
  SELECT p.product_category INTO product_category
  FROM public.products p
  WHERE p.id = NEW.product_id;
  
  -- Check if product is nonvape
  IF product_category != 'nonvape' THEN
    RAISE EXCEPTION 'Only nonvape products can be added to campaigns. Product category: %', product_category;
  END IF;
  
  RETURN NEW;
END;
$$;


--
-- TOC entry 604 (class 1255 OID 57375)
-- Name: validate_order_line_item(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.validate_order_line_item() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Validate that product can be added to this order
  IF NOT public.can_product_be_added_to_order(NEW.product_id, NEW.order_id) THEN
    RAISE EXCEPTION 'Product cannot be added to order. Product may be inactive, already in this order, or locked in approved orders.'
      USING HINT = 'Only active products not in approved orders can be added.',
            ERRCODE = 'P0005';
  END IF;
  
  RETURN NEW;
END;
$$;


--
-- TOC entry 616 (class 1255 OID 63564)
-- Name: verify_case_public(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.verify_case_public(p_code text) RETURNS TABLE(case_code text, product_name text, sku text, manufacturer_name text, status text, last_event text, last_event_at timestamp with time zone)
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  select
    c.code                          as case_code,
    p.name                          as product_name,
    p.sku                           as sku,
    m.name                          as manufacturer_name,
    c.status                        as status,
    e.event                         as last_event,
    e.created_at                    as last_event_at
  from public.cases c
  join public.products p on p.id = c.product_id
  left join public.manufacturers m on m.id = p.manufacturer_id
  left join lateral (
    select ce.event, ce.created_at
    from public.case_events ce
    where ce.case_id = c.id
    order by ce.created_at desc
    limit 1
  ) e on true
  where c.code = p_code
$$;


--
-- TOC entry 547 (class 1255 OID 63834)
-- Name: verify_qr_public(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.verify_qr_public(p_code text) RETURNS TABLE(qr_code text, product_name text, manufacturer_name text, status text, last_event text, last_event_at timestamp with time zone)
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT
    q.code,
    p.name,
    m.name,
    q.status,
    e.event AS last_event,
    e.scanned_at AS last_event_at
  FROM public.qr_master q
  JOIN public.products p ON p.id = q.product_id
  LEFT JOIN public.manufacturers m ON m.id = p.manufacturer_id
  LEFT JOIN LATERAL (
    SELECT se.scan_type AS event, se.scanned_at
    FROM public.qr_scan_events se
    WHERE se.qr_code_id = q.id
    ORDER BY se.scanned_at DESC
    LIMIT 1
  ) e ON TRUE
  WHERE q.code = p_code
$$;


--
-- TOC entry 692 (class 1255 OID 48009)
-- Name: add_prefixes(text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.add_prefixes(_bucket_id text, _name text) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    prefixes text[];
BEGIN
    prefixes := "storage"."get_prefixes"("_name");

    IF array_length(prefixes, 1) > 0 THEN
        INSERT INTO storage.prefixes (name, bucket_id)
        SELECT UNNEST(prefixes) as name, "_bucket_id" ON CONFLICT DO NOTHING;
    END IF;
END;
$$;


--
-- TOC entry 532 (class 1255 OID 17119)
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


--
-- TOC entry 574 (class 1255 OID 82185)
-- Name: delete_leaf_prefixes(text[], text[]); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.delete_leaf_prefixes(bucket_ids text[], names text[]) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_rows_deleted integer;
BEGIN
    LOOP
        WITH candidates AS (
            SELECT DISTINCT
                t.bucket_id,
                unnest(storage.get_prefixes(t.name)) AS name
            FROM unnest(bucket_ids, names) AS t(bucket_id, name)
        ),
        uniq AS (
             SELECT
                 bucket_id,
                 name,
                 storage.get_level(name) AS level
             FROM candidates
             WHERE name <> ''
             GROUP BY bucket_id, name
        ),
        leaf AS (
             SELECT
                 p.bucket_id,
                 p.name,
                 p.level
             FROM storage.prefixes AS p
                  JOIN uniq AS u
                       ON u.bucket_id = p.bucket_id
                           AND u.name = p.name
                           AND u.level = p.level
             WHERE NOT EXISTS (
                 SELECT 1
                 FROM storage.objects AS o
                 WHERE o.bucket_id = p.bucket_id
                   AND o.level = p.level + 1
                   AND o.name COLLATE "C" LIKE p.name || '/%'
             )
             AND NOT EXISTS (
                 SELECT 1
                 FROM storage.prefixes AS c
                 WHERE c.bucket_id = p.bucket_id
                   AND c.level = p.level + 1
                   AND c.name COLLATE "C" LIKE p.name || '/%'
             )
        )
        DELETE
        FROM storage.prefixes AS p
            USING leaf AS l
        WHERE p.bucket_id = l.bucket_id
          AND p.name = l.name
          AND p.level = l.level;

        GET DIAGNOSTICS v_rows_deleted = ROW_COUNT;
        EXIT WHEN v_rows_deleted = 0;
    END LOOP;
END;
$$;


--
-- TOC entry 436 (class 1255 OID 48010)
-- Name: delete_prefix(text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.delete_prefix(_bucket_id text, _name text) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    -- Check if we can delete the prefix
    IF EXISTS(
        SELECT FROM "storage"."prefixes"
        WHERE "prefixes"."bucket_id" = "_bucket_id"
          AND level = "storage"."get_level"("_name") + 1
          AND "prefixes"."name" COLLATE "C" LIKE "_name" || '/%'
        LIMIT 1
    )
    OR EXISTS(
        SELECT FROM "storage"."objects"
        WHERE "objects"."bucket_id" = "_bucket_id"
          AND "storage"."get_level"("objects"."name") = "storage"."get_level"("_name") + 1
          AND "objects"."name" COLLATE "C" LIKE "_name" || '/%'
        LIMIT 1
    ) THEN
    -- There are sub-objects, skip deletion
    RETURN false;
    ELSE
        DELETE FROM "storage"."prefixes"
        WHERE "prefixes"."bucket_id" = "_bucket_id"
          AND level = "storage"."get_level"("_name")
          AND "prefixes"."name" = "_name";
        RETURN true;
    END IF;
END;
$$;


--
-- TOC entry 469 (class 1255 OID 48013)
-- Name: delete_prefix_hierarchy_trigger(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.delete_prefix_hierarchy_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    prefix text;
BEGIN
    prefix := "storage"."get_prefix"(OLD."name");

    IF coalesce(prefix, '') != '' THEN
        PERFORM "storage"."delete_prefix"(OLD."bucket_id", prefix);
    END IF;

    RETURN OLD;
END;
$$;


--
-- TOC entry 628 (class 1255 OID 48028)
-- Name: enforce_bucket_name_length(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.enforce_bucket_name_length() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    if length(new.name) > 100 then
        raise exception 'bucket name "%" is too long (% characters). Max is 100.', new.name, length(new.name);
    end if;
    return new;
end;
$$;


--
-- TOC entry 586 (class 1255 OID 17044)
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
    _filename text;
BEGIN
    SELECT string_to_array(name, '/') INTO _parts;
    SELECT _parts[array_length(_parts,1)] INTO _filename;
    RETURN reverse(split_part(reverse(_filename), '.', 1));
END
$$;


--
-- TOC entry 487 (class 1255 OID 17043)
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


--
-- TOC entry 508 (class 1255 OID 17039)
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
BEGIN
    -- Split on "/" to get path segments
    SELECT string_to_array(name, '/') INTO _parts;
    -- Return everything except the last segment
    RETURN _parts[1 : array_length(_parts,1) - 1];
END
$$;


--
-- TOC entry 596 (class 1255 OID 47991)
-- Name: get_level(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_level(name text) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
SELECT array_length(string_to_array("name", '/'), 1);
$$;


--
-- TOC entry 639 (class 1255 OID 48007)
-- Name: get_prefix(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_prefix(name text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
SELECT
    CASE WHEN strpos("name", '/') > 0 THEN
             regexp_replace("name", '[\/]{1}[^\/]+\/?$', '')
         ELSE
             ''
        END;
$_$;


--
-- TOC entry 495 (class 1255 OID 48008)
-- Name: get_prefixes(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_prefixes(name text) RETURNS text[]
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $$
DECLARE
    parts text[];
    prefixes text[];
    prefix text;
BEGIN
    -- Split the name into parts by '/'
    parts := string_to_array("name", '/');
    prefixes := '{}';

    -- Construct the prefixes, stopping one level below the last part
    FOR i IN 1..array_length(parts, 1) - 1 LOOP
            prefix := array_to_string(parts[1:i], '/');
            prefixes := array_append(prefixes, prefix);
    END LOOP;

    RETURN prefixes;
END;
$$;


--
-- TOC entry 421 (class 1255 OID 48026)
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::bigint) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


--
-- TOC entry 582 (class 1255 OID 17162)
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


--
-- TOC entry 472 (class 1255 OID 17123)
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(name COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                        substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1)))
                    ELSE
                        name
                END AS name, id, metadata, updated_at
            FROM
                storage.objects
            WHERE
                bucket_id = $5 AND
                name ILIKE $1 || ''%'' AND
                CASE
                    WHEN $6 != '''' THEN
                    name COLLATE "C" > $6
                ELSE true END
                AND CASE
                    WHEN $4 != '''' THEN
                        CASE
                            WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                                substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                name COLLATE "C" > $4
                            END
                    ELSE
                        true
                END
            ORDER BY
                name COLLATE "C" ASC) as e order by name COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_token, bucket_id, start_after;
END;
$_$;


--
-- TOC entry 444 (class 1255 OID 82184)
-- Name: lock_top_prefixes(text[], text[]); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.lock_top_prefixes(bucket_ids text[], names text[]) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_bucket text;
    v_top text;
BEGIN
    FOR v_bucket, v_top IN
        SELECT DISTINCT t.bucket_id,
            split_part(t.name, '/', 1) AS top
        FROM unnest(bucket_ids, names) AS t(bucket_id, name)
        WHERE t.name <> ''
        ORDER BY 1, 2
        LOOP
            PERFORM pg_advisory_xact_lock(hashtextextended(v_bucket || '/' || v_top, 0));
        END LOOP;
END;
$$;


--
-- TOC entry 492 (class 1255 OID 82186)
-- Name: objects_delete_cleanup(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.objects_delete_cleanup() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_bucket_ids text[];
    v_names      text[];
BEGIN
    IF current_setting('storage.gc.prefixes', true) = '1' THEN
        RETURN NULL;
    END IF;

    PERFORM set_config('storage.gc.prefixes', '1', true);

    SELECT COALESCE(array_agg(d.bucket_id), '{}'),
           COALESCE(array_agg(d.name), '{}')
    INTO v_bucket_ids, v_names
    FROM deleted AS d
    WHERE d.name <> '';

    PERFORM storage.lock_top_prefixes(v_bucket_ids, v_names);
    PERFORM storage.delete_leaf_prefixes(v_bucket_ids, v_names);

    RETURN NULL;
END;
$$;


--
-- TOC entry 689 (class 1255 OID 48012)
-- Name: objects_insert_prefix_trigger(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.objects_insert_prefix_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM "storage"."add_prefixes"(NEW."bucket_id", NEW."name");
    NEW.level := "storage"."get_level"(NEW."name");

    RETURN NEW;
END;
$$;


--
-- TOC entry 613 (class 1255 OID 82187)
-- Name: objects_update_cleanup(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.objects_update_cleanup() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    -- NEW - OLD (destinations to create prefixes for)
    v_add_bucket_ids text[];
    v_add_names      text[];

    -- OLD - NEW (sources to prune)
    v_src_bucket_ids text[];
    v_src_names      text[];
BEGIN
    IF TG_OP <> 'UPDATE' THEN
        RETURN NULL;
    END IF;

    -- 1) Compute NEW−OLD (added paths) and OLD−NEW (moved-away paths)
    WITH added AS (
        SELECT n.bucket_id, n.name
        FROM new_rows n
        WHERE n.name <> '' AND position('/' in n.name) > 0
        EXCEPT
        SELECT o.bucket_id, o.name FROM old_rows o WHERE o.name <> ''
    ),
    moved AS (
         SELECT o.bucket_id, o.name
         FROM old_rows o
         WHERE o.name <> ''
         EXCEPT
         SELECT n.bucket_id, n.name FROM new_rows n WHERE n.name <> ''
    )
    SELECT
        -- arrays for ADDED (dest) in stable order
        COALESCE( (SELECT array_agg(a.bucket_id ORDER BY a.bucket_id, a.name) FROM added a), '{}' ),
        COALESCE( (SELECT array_agg(a.name      ORDER BY a.bucket_id, a.name) FROM added a), '{}' ),
        -- arrays for MOVED (src) in stable order
        COALESCE( (SELECT array_agg(m.bucket_id ORDER BY m.bucket_id, m.name) FROM moved m), '{}' ),
        COALESCE( (SELECT array_agg(m.name      ORDER BY m.bucket_id, m.name) FROM moved m), '{}' )
    INTO v_add_bucket_ids, v_add_names, v_src_bucket_ids, v_src_names;

    -- Nothing to do?
    IF (array_length(v_add_bucket_ids, 1) IS NULL) AND (array_length(v_src_bucket_ids, 1) IS NULL) THEN
        RETURN NULL;
    END IF;

    -- 2) Take per-(bucket, top) locks: ALL prefixes in consistent global order to prevent deadlocks
    DECLARE
        v_all_bucket_ids text[];
        v_all_names text[];
    BEGIN
        -- Combine source and destination arrays for consistent lock ordering
        v_all_bucket_ids := COALESCE(v_src_bucket_ids, '{}') || COALESCE(v_add_bucket_ids, '{}');
        v_all_names := COALESCE(v_src_names, '{}') || COALESCE(v_add_names, '{}');

        -- Single lock call ensures consistent global ordering across all transactions
        IF array_length(v_all_bucket_ids, 1) IS NOT NULL THEN
            PERFORM storage.lock_top_prefixes(v_all_bucket_ids, v_all_names);
        END IF;
    END;

    -- 3) Create destination prefixes (NEW−OLD) BEFORE pruning sources
    IF array_length(v_add_bucket_ids, 1) IS NOT NULL THEN
        WITH candidates AS (
            SELECT DISTINCT t.bucket_id, unnest(storage.get_prefixes(t.name)) AS name
            FROM unnest(v_add_bucket_ids, v_add_names) AS t(bucket_id, name)
            WHERE name <> ''
        )
        INSERT INTO storage.prefixes (bucket_id, name)
        SELECT c.bucket_id, c.name
        FROM candidates c
        ON CONFLICT DO NOTHING;
    END IF;

    -- 4) Prune source prefixes bottom-up for OLD−NEW
    IF array_length(v_src_bucket_ids, 1) IS NOT NULL THEN
        -- re-entrancy guard so DELETE on prefixes won't recurse
        IF current_setting('storage.gc.prefixes', true) <> '1' THEN
            PERFORM set_config('storage.gc.prefixes', '1', true);
        END IF;

        PERFORM storage.delete_leaf_prefixes(v_src_bucket_ids, v_src_names);
    END IF;

    RETURN NULL;
END;
$$;


--
-- TOC entry 677 (class 1255 OID 82192)
-- Name: objects_update_level_trigger(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.objects_update_level_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Ensure this is an update operation and the name has changed
    IF TG_OP = 'UPDATE' AND (NEW."name" <> OLD."name" OR NEW."bucket_id" <> OLD."bucket_id") THEN
        -- Set the new level
        NEW."level" := "storage"."get_level"(NEW."name");
    END IF;
    RETURN NEW;
END;
$$;


--
-- TOC entry 580 (class 1255 OID 48027)
-- Name: objects_update_prefix_trigger(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.objects_update_prefix_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    old_prefixes TEXT[];
BEGIN
    -- Ensure this is an update operation and the name has changed
    IF TG_OP = 'UPDATE' AND (NEW."name" <> OLD."name" OR NEW."bucket_id" <> OLD."bucket_id") THEN
        -- Retrieve old prefixes
        old_prefixes := "storage"."get_prefixes"(OLD."name");

        -- Remove old prefixes that are only used by this object
        WITH all_prefixes as (
            SELECT unnest(old_prefixes) as prefix
        ),
        can_delete_prefixes as (
             SELECT prefix
             FROM all_prefixes
             WHERE NOT EXISTS (
                 SELECT 1 FROM "storage"."objects"
                 WHERE "bucket_id" = OLD."bucket_id"
                   AND "name" <> OLD."name"
                   AND "name" LIKE (prefix || '%')
             )
         )
        DELETE FROM "storage"."prefixes" WHERE name IN (SELECT prefix FROM can_delete_prefixes);

        -- Add new prefixes
        PERFORM "storage"."add_prefixes"(NEW."bucket_id", NEW."name");
    END IF;
    -- Set the new level
    NEW."level" := "storage"."get_level"(NEW."name");

    RETURN NEW;
END;
$$;


--
-- TOC entry 659 (class 1255 OID 17179)
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


--
-- TOC entry 486 (class 1255 OID 82188)
-- Name: prefixes_delete_cleanup(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.prefixes_delete_cleanup() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_bucket_ids text[];
    v_names      text[];
BEGIN
    IF current_setting('storage.gc.prefixes', true) = '1' THEN
        RETURN NULL;
    END IF;

    PERFORM set_config('storage.gc.prefixes', '1', true);

    SELECT COALESCE(array_agg(d.bucket_id), '{}'),
           COALESCE(array_agg(d.name), '{}')
    INTO v_bucket_ids, v_names
    FROM deleted AS d
    WHERE d.name <> '';

    PERFORM storage.lock_top_prefixes(v_bucket_ids, v_names);
    PERFORM storage.delete_leaf_prefixes(v_bucket_ids, v_names);

    RETURN NULL;
END;
$$;


--
-- TOC entry 653 (class 1255 OID 48011)
-- Name: prefixes_insert_trigger(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.prefixes_insert_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM "storage"."add_prefixes"(NEW."bucket_id", NEW."name");
    RETURN NEW;
END;
$$;


--
-- TOC entry 706 (class 1255 OID 17101)
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql
    AS $$
declare
    can_bypass_rls BOOLEAN;
begin
    SELECT rolbypassrls
    INTO can_bypass_rls
    FROM pg_roles
    WHERE rolname = coalesce(nullif(current_setting('role', true), 'none'), current_user);

    IF can_bypass_rls THEN
        RETURN QUERY SELECT * FROM storage.search_v1_optimised(prefix, bucketname, limits, levels, offsets, search, sortcolumn, sortorder);
    ELSE
        RETURN QUERY SELECT * FROM storage.search_legacy_v1(prefix, bucketname, limits, levels, offsets, search, sortcolumn, sortorder);
    END IF;
end;
$$;


--
-- TOC entry 537 (class 1255 OID 48024)
-- Name: search_legacy_v1(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search_legacy_v1(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
    v_order_by text;
    v_sort_order text;
begin
    case
        when sortcolumn = 'name' then
            v_order_by = 'name';
        when sortcolumn = 'updated_at' then
            v_order_by = 'updated_at';
        when sortcolumn = 'created_at' then
            v_order_by = 'created_at';
        when sortcolumn = 'last_accessed_at' then
            v_order_by = 'last_accessed_at';
        else
            v_order_by = 'name';
        end case;

    case
        when sortorder = 'asc' then
            v_sort_order = 'asc';
        when sortorder = 'desc' then
            v_sort_order = 'desc';
        else
            v_sort_order = 'asc';
        end case;

    v_order_by = v_order_by || ' ' || v_sort_order;

    return query execute
        'with folders as (
           select path_tokens[$1] as folder
           from storage.objects
             where objects.name ilike $2 || $3 || ''%''
               and bucket_id = $4
               and array_length(objects.path_tokens, 1) <> $1
           group by folder
           order by folder ' || v_sort_order || '
     )
     (select folder as "name",
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[$1] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where objects.name ilike $2 || $3 || ''%''
       and bucket_id = $4
       and array_length(objects.path_tokens, 1) = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


--
-- TOC entry 419 (class 1255 OID 48023)
-- Name: search_v1_optimised(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search_v1_optimised(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
    v_order_by text;
    v_sort_order text;
begin
    case
        when sortcolumn = 'name' then
            v_order_by = 'name';
        when sortcolumn = 'updated_at' then
            v_order_by = 'updated_at';
        when sortcolumn = 'created_at' then
            v_order_by = 'created_at';
        when sortcolumn = 'last_accessed_at' then
            v_order_by = 'last_accessed_at';
        else
            v_order_by = 'name';
        end case;

    case
        when sortorder = 'asc' then
            v_sort_order = 'asc';
        when sortorder = 'desc' then
            v_sort_order = 'desc';
        else
            v_sort_order = 'asc';
        end case;

    v_order_by = v_order_by || ' ' || v_sort_order;

    return query execute
        'with folders as (
           select (string_to_array(name, ''/''))[level] as name
           from storage.prefixes
             where lower(prefixes.name) like lower($2 || $3) || ''%''
               and bucket_id = $4
               and level = $1
           order by name ' || v_sort_order || '
     )
     (select name,
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[level] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where lower(objects.name) like lower($2 || $3) || ''%''
       and bucket_id = $4
       and level = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


--
-- TOC entry 538 (class 1255 OID 82183)
-- Name: search_v2(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer DEFAULT 100, levels integer DEFAULT 1, start_after text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text, sort_column text DEFAULT 'name'::text, sort_column_after text DEFAULT ''::text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    sort_col text;
    sort_ord text;
    cursor_op text;
    cursor_expr text;
    sort_expr text;
BEGIN
    -- Validate sort_order
    sort_ord := lower(sort_order);
    IF sort_ord NOT IN ('asc', 'desc') THEN
        sort_ord := 'asc';
    END IF;

    -- Determine cursor comparison operator
    IF sort_ord = 'asc' THEN
        cursor_op := '>';
    ELSE
        cursor_op := '<';
    END IF;
    
    sort_col := lower(sort_column);
    -- Validate sort column  
    IF sort_col IN ('updated_at', 'created_at') THEN
        cursor_expr := format(
            '($5 = '''' OR ROW(date_trunc(''milliseconds'', %I), name COLLATE "C") %s ROW(COALESCE(NULLIF($6, '''')::timestamptz, ''epoch''::timestamptz), $5))',
            sort_col, cursor_op
        );
        sort_expr := format(
            'COALESCE(date_trunc(''milliseconds'', %I), ''epoch''::timestamptz) %s, name COLLATE "C" %s',
            sort_col, sort_ord, sort_ord
        );
    ELSE
        cursor_expr := format('($5 = '''' OR name COLLATE "C" %s $5)', cursor_op);
        sort_expr := format('name COLLATE "C" %s', sort_ord);
    END IF;

    RETURN QUERY EXECUTE format(
        $sql$
        SELECT * FROM (
            (
                SELECT
                    split_part(name, '/', $4) AS key,
                    name,
                    NULL::uuid AS id,
                    updated_at,
                    created_at,
                    NULL::timestamptz AS last_accessed_at,
                    NULL::jsonb AS metadata
                FROM storage.prefixes
                WHERE name COLLATE "C" LIKE $1 || '%%'
                    AND bucket_id = $2
                    AND level = $4
                    AND %s
                ORDER BY %s
                LIMIT $3
            )
            UNION ALL
            (
                SELECT
                    split_part(name, '/', $4) AS key,
                    name,
                    id,
                    updated_at,
                    created_at,
                    last_accessed_at,
                    metadata
                FROM storage.objects
                WHERE name COLLATE "C" LIKE $1 || '%%'
                    AND bucket_id = $2
                    AND level = $4
                    AND %s
                ORDER BY %s
                LIMIT $3
            )
        ) obj
        ORDER BY %s
        LIMIT $3
        $sql$,
        cursor_expr,    -- prefixes WHERE
        sort_expr,      -- prefixes ORDER BY
        cursor_expr,    -- objects WHERE
        sort_expr,      -- objects ORDER BY
        sort_expr       -- final ORDER BY
    )
    USING prefix, bucket_name, limits, levels, start_after, sort_column_after;
END;
$_$;


--
-- TOC entry 480 (class 1255 OID 17102)
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


--
-- TOC entry 394 (class 1259 OID 50507)
-- Name: batch_number_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.batch_number_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 401 (class 1259 OID 82763)
-- Name: brands; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.brands (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 400 (class 1259 OID 82750)
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categories (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 413 (class 1259 OID 83094)
-- Name: dev_fastlogin_accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dev_fastlogin_accounts (
    email text NOT NULL,
    role_code public.role_code NOT NULL,
    full_name text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 405 (class 1259 OID 82819)
-- Name: distributors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.distributors (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    negeri_id integer,
    daerah_id integer,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    active boolean DEFAULT true NOT NULL
);


--
-- TOC entry 396 (class 1259 OID 56968)
-- Name: hq_order_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.hq_order_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 397 (class 1259 OID 57124)
-- Name: manufacturer_batch_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.manufacturer_batch_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 407 (class 1259 OID 82846)
-- Name: manufacturer_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.manufacturer_users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    manufacturer_id uuid NOT NULL,
    user_id uuid NOT NULL
);


--
-- TOC entry 404 (class 1259 OID 82808)
-- Name: manufacturers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.manufacturers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    contact_person text,
    phone text,
    email text,
    address text,
    logo_url text,
    legal_name text,
    brand_name text,
    registration_number text,
    tax_id text,
    country_code character(2),
    timezone text,
    language_code character(2),
    currency_code character(3),
    website_url text,
    support_email text,
    support_phone text,
    whatsapp text,
    address_line1 text,
    address_line2 text,
    city text,
    state_region text,
    postal_code text,
    secondary_email text,
    fax text,
    social_links jsonb,
    certifications jsonb,
    notes text,
    status public.manufacturer_status DEFAULT 'active'::public.manufacturer_status,
    CONSTRAINT manufacturers_country_len_chk CHECK (((country_code IS NULL) OR (length(country_code) = 2))),
    CONSTRAINT manufacturers_currency_len_chk CHECK (((currency_code IS NULL) OR (length(currency_code) = 3))),
    CONSTRAINT manufacturers_lang_len_chk CHECK (((language_code IS NULL) OR (length(language_code) = 2)))
);


--
-- TOC entry 4401 (class 0 OID 0)
-- Dependencies: 404
-- Name: COLUMN manufacturers.legal_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.manufacturers.legal_name IS 'Registered legal name';


--
-- TOC entry 4402 (class 0 OID 0)
-- Dependencies: 404
-- Name: COLUMN manufacturers.brand_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.manufacturers.brand_name IS 'Marketing/brand display name';


--
-- TOC entry 4403 (class 0 OID 0)
-- Dependencies: 404
-- Name: COLUMN manufacturers.registration_number; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.manufacturers.registration_number IS 'Company/business registration number';


--
-- TOC entry 4404 (class 0 OID 0)
-- Dependencies: 404
-- Name: COLUMN manufacturers.tax_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.manufacturers.tax_id IS 'Tax/VAT/GST identifier';


--
-- TOC entry 4405 (class 0 OID 0)
-- Dependencies: 404
-- Name: COLUMN manufacturers.country_code; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.manufacturers.country_code IS 'ISO-3166-1 alpha-2';


--
-- TOC entry 4406 (class 0 OID 0)
-- Dependencies: 404
-- Name: COLUMN manufacturers.language_code; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.manufacturers.language_code IS 'ISO-639-1';


--
-- TOC entry 4407 (class 0 OID 0)
-- Dependencies: 404
-- Name: COLUMN manufacturers.currency_code; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.manufacturers.currency_code IS 'ISO-4217';


--
-- TOC entry 4408 (class 0 OID 0)
-- Dependencies: 404
-- Name: COLUMN manufacturers.support_email; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.manufacturers.support_email IS 'Support contact email';


--
-- TOC entry 4409 (class 0 OID 0)
-- Dependencies: 404
-- Name: COLUMN manufacturers.support_phone; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.manufacturers.support_phone IS 'Support phone';


--
-- TOC entry 4410 (class 0 OID 0)
-- Dependencies: 404
-- Name: COLUMN manufacturers.whatsapp; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.manufacturers.whatsapp IS 'WhatsApp contact';


--
-- TOC entry 4411 (class 0 OID 0)
-- Dependencies: 404
-- Name: COLUMN manufacturers.address_line1; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.manufacturers.address_line1 IS 'Address line 1';


--
-- TOC entry 4412 (class 0 OID 0)
-- Dependencies: 404
-- Name: COLUMN manufacturers.address_line2; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.manufacturers.address_line2 IS 'Address line 2';


--
-- TOC entry 4413 (class 0 OID 0)
-- Dependencies: 404
-- Name: COLUMN manufacturers.state_region; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.manufacturers.state_region IS 'State/Region';


--
-- TOC entry 4414 (class 0 OID 0)
-- Dependencies: 404
-- Name: COLUMN manufacturers.social_links; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.manufacturers.social_links IS 'JSON of social links';


--
-- TOC entry 4415 (class 0 OID 0)
-- Dependencies: 404
-- Name: COLUMN manufacturers.certifications; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.manufacturers.certifications IS 'JSON array of certification objects';


--
-- TOC entry 4416 (class 0 OID 0)
-- Dependencies: 404
-- Name: COLUMN manufacturers.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.manufacturers.status IS 'active | inactive | blocked';


--
-- TOC entry 412 (class 1259 OID 82999)
-- Name: master_daerah; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.master_daerah (
    id integer NOT NULL,
    negeri_id integer NOT NULL,
    name text NOT NULL
);


--
-- TOC entry 411 (class 1259 OID 82990)
-- Name: master_negeri; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.master_negeri (
    id integer NOT NULL,
    code text,
    name text NOT NULL
);


--
-- TOC entry 395 (class 1259 OID 52125)
-- Name: order_no_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.order_no_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 402 (class 1259 OID 82776)
-- Name: product_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_groups (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    category_id uuid,
    name text NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 403 (class 1259 OID 82792)
-- Name: product_subgroups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_subgroups (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    group_id uuid,
    name text NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 410 (class 1259 OID 82946)
-- Name: product_variants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_variants (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    flavor_name text,
    nic_strength text,
    packaging text,
    sku text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    flavor_name_ci text GENERATED ALWAYS AS (lower(COALESCE(flavor_name, ''::text))) STORED,
    nic_strength_ci text GENERATED ALWAYS AS (lower(COALESCE(nic_strength, ''::text))) STORED,
    packaging_ci text GENERATED ALWAYS AS (lower(COALESCE(packaging, ''::text))) STORED
);


--
-- TOC entry 409 (class 1259 OID 82879)
-- Name: products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    category_id uuid,
    brand_id uuid,
    group_id uuid,
    sub_group_id uuid,
    manufacturer_id uuid,
    name text NOT NULL,
    name_ci text GENERATED ALWAYS AS (lower(COALESCE(name, ''::text))) STORED,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 399 (class 1259 OID 82712)
-- Name: profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.profiles (
    id uuid NOT NULL,
    role_code public.role_code NOT NULL,
    full_name text,
    avatar_url text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    role public.app_role DEFAULT 'shop_user'::public.app_role NOT NULL,
    distributor_id uuid,
    shop_id uuid
);


--
-- TOC entry 418 (class 1259 OID 84672)
-- Name: profiles_compat; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.profiles_compat AS
 SELECT id AS user_id,
    id,
    role,
    distributor_id,
    shop_id,
    full_name,
    created_at,
    updated_at
   FROM public.profiles;


--
-- TOC entry 408 (class 1259 OID 82864)
-- Name: shop_distributors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shop_distributors (
    shop_id uuid NOT NULL,
    distributor_id uuid NOT NULL
);


--
-- TOC entry 415 (class 1259 OID 84311)
-- Name: shop_points_ledger; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shop_points_ledger (
    id bigint NOT NULL,
    shop_id uuid NOT NULL,
    delta integer NOT NULL,
    reason text,
    ref_type text,
    ref_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 416 (class 1259 OID 84552)
-- Name: shop_points_balance; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.shop_points_balance AS
 SELECT shop_id,
    COALESCE(sum(delta), (0)::bigint) AS points
   FROM public.shop_points_ledger
  GROUP BY shop_id;


--
-- TOC entry 414 (class 1259 OID 84310)
-- Name: shop_points_ledger_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.shop_points_ledger_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4417 (class 0 OID 0)
-- Dependencies: 414
-- Name: shop_points_ledger_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.shop_points_ledger_id_seq OWNED BY public.shop_points_ledger.id;


--
-- TOC entry 406 (class 1259 OID 82830)
-- Name: shops; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shops (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    distributor_id uuid NOT NULL,
    name text NOT NULL,
    negeri_id integer,
    daerah_id integer,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    active boolean DEFAULT true NOT NULL,
    code text,
    email text,
    phone text,
    address text,
    city text,
    state_region text,
    postal_code text,
    country_code character(2)
);


--
-- TOC entry 393 (class 1259 OID 49596)
-- Name: sku_seq_nonvape; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sku_seq_nonvape
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 392 (class 1259 OID 49595)
-- Name: sku_seq_vape; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sku_seq_vape
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 417 (class 1259 OID 84644)
-- Name: v_current_profile; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_current_profile AS
 SELECT id,
    role_code,
    full_name,
    avatar_url,
    created_at,
    updated_at,
    role,
    distributor_id,
    shop_id
   FROM public.profiles p
  WHERE (id = auth.uid());


--
-- TOC entry 361 (class 1259 OID 16544)
-- Name: buckets; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text,
    type storage.buckettype DEFAULT 'STANDARD'::storage.buckettype NOT NULL
);


--
-- TOC entry 4418 (class 0 OID 0)
-- Dependencies: 361
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- TOC entry 391 (class 1259 OID 48036)
-- Name: buckets_analytics; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets_analytics (
    id text NOT NULL,
    type storage.buckettype DEFAULT 'ANALYTICS'::storage.buckettype NOT NULL,
    format text DEFAULT 'ICEBERG'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 363 (class 1259 OID 16586)
-- Name: migrations; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- TOC entry 362 (class 1259 OID 16559)
-- Name: objects; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb,
    level integer
);


--
-- TOC entry 4419 (class 0 OID 0)
-- Dependencies: 362
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- TOC entry 390 (class 1259 OID 47992)
-- Name: prefixes; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.prefixes (
    bucket_id text NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    level integer GENERATED ALWAYS AS (storage.get_level(name)) STORED NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- TOC entry 384 (class 1259 OID 17126)
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb
);


--
-- TOC entry 385 (class 1259 OID 17141)
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 4064 (class 2604 OID 84314)
-- Name: shop_points_ledger id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shop_points_ledger ALTER COLUMN id SET DEFAULT nextval('public.shop_points_ledger_id_seq'::regclass);


--
-- TOC entry 4103 (class 2606 OID 82775)
-- Name: brands brands_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.brands
    ADD CONSTRAINT brands_name_key UNIQUE (name);


--
-- TOC entry 4105 (class 2606 OID 82773)
-- Name: brands brands_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.brands
    ADD CONSTRAINT brands_pkey PRIMARY KEY (id);


--
-- TOC entry 4099 (class 2606 OID 82762)
-- Name: categories categories_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_name_key UNIQUE (name);


--
-- TOC entry 4101 (class 2606 OID 82760)
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- TOC entry 4146 (class 2606 OID 83101)
-- Name: dev_fastlogin_accounts dev_fastlogin_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dev_fastlogin_accounts
    ADD CONSTRAINT dev_fastlogin_accounts_pkey PRIMARY KEY (email);


--
-- TOC entry 4117 (class 2606 OID 82829)
-- Name: distributors distributors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.distributors
    ADD CONSTRAINT distributors_pkey PRIMARY KEY (id);


--
-- TOC entry 4124 (class 2606 OID 82853)
-- Name: manufacturer_users manufacturer_users_manufacturer_id_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manufacturer_users
    ADD CONSTRAINT manufacturer_users_manufacturer_id_user_id_key UNIQUE (manufacturer_id, user_id);


--
-- TOC entry 4126 (class 2606 OID 82851)
-- Name: manufacturer_users manufacturer_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manufacturer_users
    ADD CONSTRAINT manufacturer_users_pkey PRIMARY KEY (id);


--
-- TOC entry 4113 (class 2606 OID 82818)
-- Name: manufacturers manufacturers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manufacturers
    ADD CONSTRAINT manufacturers_pkey PRIMARY KEY (id);


--
-- TOC entry 4115 (class 2606 OID 84283)
-- Name: manufacturers manufacturers_reg_country_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manufacturers
    ADD CONSTRAINT manufacturers_reg_country_uniq UNIQUE (registration_number, country_code) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4142 (class 2606 OID 83005)
-- Name: master_daerah master_daerah_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.master_daerah
    ADD CONSTRAINT master_daerah_pkey PRIMARY KEY (id);


--
-- TOC entry 4138 (class 2606 OID 82998)
-- Name: master_negeri master_negeri_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.master_negeri
    ADD CONSTRAINT master_negeri_code_key UNIQUE (code);


--
-- TOC entry 4140 (class 2606 OID 82996)
-- Name: master_negeri master_negeri_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.master_negeri
    ADD CONSTRAINT master_negeri_pkey PRIMARY KEY (id);


--
-- TOC entry 4107 (class 2606 OID 82786)
-- Name: product_groups product_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_groups
    ADD CONSTRAINT product_groups_pkey PRIMARY KEY (id);


--
-- TOC entry 4109 (class 2606 OID 82802)
-- Name: product_subgroups product_subgroups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_subgroups
    ADD CONSTRAINT product_subgroups_pkey PRIMARY KEY (id);


--
-- TOC entry 4134 (class 2606 OID 82959)
-- Name: product_variants product_variants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT product_variants_pkey PRIMARY KEY (id);


--
-- TOC entry 4130 (class 2606 OID 82890)
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- TOC entry 4097 (class 2606 OID 82720)
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- TOC entry 4128 (class 2606 OID 82868)
-- Name: shop_distributors shop_distributors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shop_distributors
    ADD CONSTRAINT shop_distributors_pkey PRIMARY KEY (shop_id, distributor_id);


--
-- TOC entry 4149 (class 2606 OID 84319)
-- Name: shop_points_ledger shop_points_ledger_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shop_points_ledger
    ADD CONSTRAINT shop_points_ledger_pkey PRIMARY KEY (id);


--
-- TOC entry 4122 (class 2606 OID 82840)
-- Name: shops shops_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shops
    ADD CONSTRAINT shops_pkey PRIMARY KEY (id);


--
-- TOC entry 4144 (class 2606 OID 83012)
-- Name: master_daerah uq_daerah_per_negeri; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.master_daerah
    ADD CONSTRAINT uq_daerah_per_negeri UNIQUE (negeri_id, name);


--
-- TOC entry 4132 (class 2606 OID 82917)
-- Name: products uq_product_tuple; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT uq_product_tuple UNIQUE (category_id, brand_id, group_id, sub_group_id, manufacturer_id, name_ci);


--
-- TOC entry 4136 (class 2606 OID 82966)
-- Name: product_variants uq_variant_tuple; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT uq_variant_tuple UNIQUE (product_id, flavor_name_ci, nic_strength_ci, packaging_ci);


--
-- TOC entry 4093 (class 2606 OID 48046)
-- Name: buckets_analytics buckets_analytics_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets_analytics
    ADD CONSTRAINT buckets_analytics_pkey PRIMARY KEY (id);


--
-- TOC entry 4071 (class 2606 OID 16552)
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- TOC entry 4081 (class 2606 OID 16593)
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- TOC entry 4083 (class 2606 OID 16591)
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 4079 (class 2606 OID 16569)
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- TOC entry 4091 (class 2606 OID 48001)
-- Name: prefixes prefixes_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.prefixes
    ADD CONSTRAINT prefixes_pkey PRIMARY KEY (bucket_id, level, name);


--
-- TOC entry 4088 (class 2606 OID 17150)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- TOC entry 4086 (class 2606 OID 17135)
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- TOC entry 4118 (class 1259 OID 84389)
-- Name: idx_distributors_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_distributors_active ON public.distributors USING btree (active);


--
-- TOC entry 4110 (class 1259 OID 84285)
-- Name: idx_manufacturers_country; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_manufacturers_country ON public.manufacturers USING btree (country_code);


--
-- TOC entry 4111 (class 1259 OID 84286)
-- Name: idx_manufacturers_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_manufacturers_status ON public.manufacturers USING btree (status);


--
-- TOC entry 4094 (class 1259 OID 84456)
-- Name: idx_profiles_distributor; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_profiles_distributor ON public.profiles USING btree (distributor_id);


--
-- TOC entry 4095 (class 1259 OID 84457)
-- Name: idx_profiles_shop; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_profiles_shop ON public.profiles USING btree (shop_id);


--
-- TOC entry 4147 (class 1259 OID 84320)
-- Name: idx_shop_points_ledger_shop_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_shop_points_ledger_shop_id ON public.shop_points_ledger USING btree (shop_id);


--
-- TOC entry 4119 (class 1259 OID 84417)
-- Name: idx_shops_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_shops_active ON public.shops USING btree (active);


--
-- TOC entry 4120 (class 1259 OID 84416)
-- Name: idx_shops_distributor; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_shops_distributor ON public.shops USING btree (distributor_id);


--
-- TOC entry 4069 (class 1259 OID 16558)
-- Name: bname; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- TOC entry 4072 (class 1259 OID 16580)
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- TOC entry 4084 (class 1259 OID 17161)
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- TOC entry 4073 (class 1259 OID 48019)
-- Name: idx_name_bucket_level_unique; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX idx_name_bucket_level_unique ON storage.objects USING btree (name COLLATE "C", bucket_id, level);


--
-- TOC entry 4074 (class 1259 OID 17124)
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- TOC entry 4075 (class 1259 OID 48021)
-- Name: idx_objects_lower_name; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_lower_name ON storage.objects USING btree ((path_tokens[level]), lower(name) text_pattern_ops, bucket_id, level);


--
-- TOC entry 4089 (class 1259 OID 48022)
-- Name: idx_prefixes_lower_name; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_prefixes_lower_name ON storage.prefixes USING btree (bucket_id, level, ((string_to_array(name, '/'::text))[level]), lower(name) text_pattern_ops);


--
-- TOC entry 4076 (class 1259 OID 16581)
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- TOC entry 4077 (class 1259 OID 48020)
-- Name: objects_bucket_id_level_idx; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX objects_bucket_id_level_idx ON storage.objects USING btree (bucket_id, level, name COLLATE "C");


--
-- TOC entry 4184 (class 2620 OID 82919)
-- Name: brands trg_brands_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_brands_updated_at BEFORE UPDATE ON public.brands FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4183 (class 2620 OID 82918)
-- Name: categories trg_categories_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_categories_updated_at BEFORE UPDATE ON public.categories FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4188 (class 2620 OID 82923)
-- Name: distributors trg_distributors_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_distributors_updated_at BEFORE UPDATE ON public.distributors FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4185 (class 2620 OID 82920)
-- Name: product_groups trg_groups_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_groups_updated_at BEFORE UPDATE ON public.product_groups FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4187 (class 2620 OID 82922)
-- Name: manufacturers trg_manufacturers_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_manufacturers_updated_at BEFORE UPDATE ON public.manufacturers FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4191 (class 2620 OID 82967)
-- Name: product_variants trg_product_variants_assign_sku; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_product_variants_assign_sku BEFORE INSERT ON public.product_variants FOR EACH ROW EXECUTE FUNCTION public.trg_assign_sku();


--
-- TOC entry 4192 (class 2620 OID 82968)
-- Name: product_variants trg_product_variants_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_product_variants_updated_at BEFORE UPDATE ON public.product_variants FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4190 (class 2620 OID 82925)
-- Name: products trg_products_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_products_updated_at BEFORE UPDATE ON public.products FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4181 (class 2620 OID 84459)
-- Name: profiles trg_profiles_parent; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_profiles_parent BEFORE INSERT OR UPDATE ON public.profiles FOR EACH ROW EXECUTE FUNCTION public.enforce_profile_parent();


--
-- TOC entry 4182 (class 2620 OID 82726)
-- Name: profiles trg_profiles_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_profiles_updated_at BEFORE UPDATE ON public.profiles FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4189 (class 2620 OID 82924)
-- Name: shops trg_shops_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_shops_updated_at BEFORE UPDATE ON public.shops FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4186 (class 2620 OID 82921)
-- Name: product_subgroups trg_subgroups_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_subgroups_updated_at BEFORE UPDATE ON public.product_subgroups FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4174 (class 2620 OID 48029)
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- TOC entry 4175 (class 2620 OID 82195)
-- Name: objects objects_delete_delete_prefix; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER objects_delete_delete_prefix AFTER DELETE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.delete_prefix_hierarchy_trigger();


--
-- TOC entry 4176 (class 2620 OID 48015)
-- Name: objects objects_insert_create_prefix; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER objects_insert_create_prefix BEFORE INSERT ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.objects_insert_prefix_trigger();


--
-- TOC entry 4177 (class 2620 OID 82194)
-- Name: objects objects_update_create_prefix; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER objects_update_create_prefix BEFORE UPDATE ON storage.objects FOR EACH ROW WHEN (((new.name <> old.name) OR (new.bucket_id <> old.bucket_id))) EXECUTE FUNCTION storage.objects_update_prefix_trigger();


--
-- TOC entry 4179 (class 2620 OID 48025)
-- Name: prefixes prefixes_create_hierarchy; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER prefixes_create_hierarchy BEFORE INSERT ON storage.prefixes FOR EACH ROW WHEN ((pg_trigger_depth() < 1)) EXECUTE FUNCTION storage.prefixes_insert_trigger();


--
-- TOC entry 4180 (class 2620 OID 82196)
-- Name: prefixes prefixes_delete_hierarchy; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER prefixes_delete_hierarchy AFTER DELETE ON storage.prefixes FOR EACH ROW EXECUTE FUNCTION storage.delete_prefix_hierarchy_trigger();


--
-- TOC entry 4178 (class 2620 OID 17103)
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- TOC entry 4162 (class 2606 OID 82854)
-- Name: manufacturer_users manufacturer_users_manufacturer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manufacturer_users
    ADD CONSTRAINT manufacturer_users_manufacturer_id_fkey FOREIGN KEY (manufacturer_id) REFERENCES public.manufacturers(id) ON DELETE CASCADE;


--
-- TOC entry 4163 (class 2606 OID 82859)
-- Name: manufacturer_users manufacturer_users_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manufacturer_users
    ADD CONSTRAINT manufacturer_users_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4172 (class 2606 OID 83006)
-- Name: master_daerah master_daerah_negeri_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.master_daerah
    ADD CONSTRAINT master_daerah_negeri_id_fkey FOREIGN KEY (negeri_id) REFERENCES public.master_negeri(id) ON DELETE CASCADE;


--
-- TOC entry 4158 (class 2606 OID 82787)
-- Name: product_groups product_groups_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_groups
    ADD CONSTRAINT product_groups_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE RESTRICT;


--
-- TOC entry 4159 (class 2606 OID 82803)
-- Name: product_subgroups product_subgroups_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_subgroups
    ADD CONSTRAINT product_subgroups_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.product_groups(id) ON DELETE RESTRICT;


--
-- TOC entry 4171 (class 2606 OID 82960)
-- Name: product_variants product_variants_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT product_variants_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- TOC entry 4166 (class 2606 OID 82896)
-- Name: products products_brand_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_brand_id_fkey FOREIGN KEY (brand_id) REFERENCES public.brands(id) ON DELETE RESTRICT;


--
-- TOC entry 4167 (class 2606 OID 82891)
-- Name: products products_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE RESTRICT;


--
-- TOC entry 4168 (class 2606 OID 82901)
-- Name: products products_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.product_groups(id) ON DELETE RESTRICT;


--
-- TOC entry 4169 (class 2606 OID 82911)
-- Name: products products_manufacturer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_manufacturer_id_fkey FOREIGN KEY (manufacturer_id) REFERENCES public.manufacturers(id) ON DELETE RESTRICT;


--
-- TOC entry 4170 (class 2606 OID 82906)
-- Name: products products_sub_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_sub_group_id_fkey FOREIGN KEY (sub_group_id) REFERENCES public.product_subgroups(id) ON DELETE RESTRICT;


--
-- TOC entry 4155 (class 2606 OID 84446)
-- Name: profiles profiles_distributor_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_distributor_fk FOREIGN KEY (distributor_id) REFERENCES public.distributors(id) ON DELETE SET NULL;


--
-- TOC entry 4156 (class 2606 OID 82721)
-- Name: profiles profiles_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4157 (class 2606 OID 84451)
-- Name: profiles profiles_shop_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_shop_fk FOREIGN KEY (shop_id) REFERENCES public.shops(id) ON DELETE SET NULL;


--
-- TOC entry 4164 (class 2606 OID 82874)
-- Name: shop_distributors shop_distributors_distributor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shop_distributors
    ADD CONSTRAINT shop_distributors_distributor_id_fkey FOREIGN KEY (distributor_id) REFERENCES public.distributors(id) ON DELETE CASCADE;


--
-- TOC entry 4165 (class 2606 OID 82869)
-- Name: shop_distributors shop_distributors_shop_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shop_distributors
    ADD CONSTRAINT shop_distributors_shop_id_fkey FOREIGN KEY (shop_id) REFERENCES public.shops(id) ON DELETE CASCADE;


--
-- TOC entry 4173 (class 2606 OID 84526)
-- Name: shop_points_ledger shop_points_ledger_shop_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shop_points_ledger
    ADD CONSTRAINT shop_points_ledger_shop_fk FOREIGN KEY (shop_id) REFERENCES public.shops(id) ON DELETE CASCADE;


--
-- TOC entry 4160 (class 2606 OID 84411)
-- Name: shops shops_distributor_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shops
    ADD CONSTRAINT shops_distributor_fk FOREIGN KEY (distributor_id) REFERENCES public.distributors(id) ON DELETE CASCADE;


--
-- TOC entry 4161 (class 2606 OID 82841)
-- Name: shops shops_distributor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shops
    ADD CONSTRAINT shops_distributor_id_fkey FOREIGN KEY (distributor_id) REFERENCES public.distributors(id) ON DELETE SET NULL;


--
-- TOC entry 4150 (class 2606 OID 16570)
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 4154 (class 2606 OID 48002)
-- Name: prefixes prefixes_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.prefixes
    ADD CONSTRAINT "prefixes_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 4151 (class 2606 OID 17136)
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 4152 (class 2606 OID 17156)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 4153 (class 2606 OID 17151)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- TOC entry 4371 (class 3256 OID 84704)
-- Name: distributors dist_own_distributor; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY dist_own_distributor ON public.distributors USING ((id = ( SELECT v_current_profile.distributor_id
   FROM public.v_current_profile
  WHERE (v_current_profile.role = 'distributor_admin'::public.app_role)))) WITH CHECK ((id = ( SELECT v_current_profile.distributor_id
   FROM public.v_current_profile
  WHERE (v_current_profile.role = 'distributor_admin'::public.app_role))));


--
-- TOC entry 4372 (class 3256 OID 84706)
-- Name: shops dist_own_shops; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY dist_own_shops ON public.shops USING ((distributor_id = ( SELECT v_current_profile.distributor_id
   FROM public.v_current_profile
  WHERE (v_current_profile.role = ANY (ARRAY['distributor_admin'::public.app_role, 'shop_user'::public.app_role]))))) WITH CHECK ((distributor_id = ( SELECT v_current_profile.distributor_id
   FROM public.v_current_profile
  WHERE (v_current_profile.role = ANY (ARRAY['distributor_admin'::public.app_role, 'shop_user'::public.app_role])))));


--
-- TOC entry 4352 (class 0 OID 82819)
-- Dependencies: 405
-- Name: distributors; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.distributors ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4367 (class 3256 OID 84696)
-- Name: distributors hq_all_distributors; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY hq_all_distributors ON public.distributors USING ((EXISTS ( SELECT 1
   FROM public.v_current_profile
  WHERE (v_current_profile.role = 'hq_admin'::public.app_role)))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.v_current_profile
  WHERE (v_current_profile.role = 'hq_admin'::public.app_role))));


--
-- TOC entry 4370 (class 3256 OID 84702)
-- Name: shop_points_ledger hq_all_points; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY hq_all_points ON public.shop_points_ledger USING ((EXISTS ( SELECT 1
   FROM public.v_current_profile
  WHERE (v_current_profile.role = 'hq_admin'::public.app_role)))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.v_current_profile
  WHERE (v_current_profile.role = 'hq_admin'::public.app_role))));


--
-- TOC entry 4369 (class 3256 OID 84700)
-- Name: profiles hq_all_profiles; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY hq_all_profiles ON public.profiles USING ((EXISTS ( SELECT 1
   FROM public.v_current_profile
  WHERE (v_current_profile.role = 'hq_admin'::public.app_role)))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.v_current_profile
  WHERE (v_current_profile.role = 'hq_admin'::public.app_role))));


--
-- TOC entry 4368 (class 3256 OID 84698)
-- Name: shops hq_all_shops; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY hq_all_shops ON public.shops USING ((EXISTS ( SELECT 1
   FROM public.v_current_profile
  WHERE (v_current_profile.role = 'hq_admin'::public.app_role)))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.v_current_profile
  WHERE (v_current_profile.role = 'hq_admin'::public.app_role))));


--
-- TOC entry 4374 (class 3256 OID 84709)
-- Name: shop_points_ledger points_same_distributor; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY points_same_distributor ON public.shop_points_ledger USING ((EXISTS ( SELECT 1
   FROM (public.v_current_profile p
     JOIN public.shops s ON ((s.id = p.shop_id)))
  WHERE ((p.role = ANY (ARRAY['distributor_admin'::public.app_role, 'shop_user'::public.app_role])) AND (p.distributor_id = s.distributor_id))))) WITH CHECK (true);


--
-- TOC entry 4351 (class 0 OID 82712)
-- Dependencies: 399
-- Name: profiles; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4362 (class 3256 OID 82729)
-- Name: profiles profiles_admin_read_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY profiles_admin_read_all ON public.profiles FOR SELECT TO authenticated USING ((COALESCE(((current_setting('request.jwt.claims'::text, true))::jsonb ->> 'role'::text), ''::text) = ANY (ARRAY['hq_admin'::text, 'power_user'::text])));


--
-- TOC entry 4360 (class 3256 OID 82727)
-- Name: profiles profiles_self_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY profiles_self_select ON public.profiles FOR SELECT TO authenticated USING ((id = auth.uid()));


--
-- TOC entry 4361 (class 3256 OID 82728)
-- Name: profiles profiles_self_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY profiles_self_update ON public.profiles FOR UPDATE TO authenticated USING ((id = auth.uid())) WITH CHECK ((id = auth.uid()));


--
-- TOC entry 4373 (class 3256 OID 84708)
-- Name: profiles self_profile_rw; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY self_profile_rw ON public.profiles USING ((id = auth.uid())) WITH CHECK ((id = auth.uid()));


--
-- TOC entry 4354 (class 0 OID 84311)
-- Dependencies: 415
-- Name: shop_points_ledger; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.shop_points_ledger ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4353 (class 0 OID 82830)
-- Dependencies: 406
-- Name: shops; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.shops ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4363 (class 3256 OID 49854)
-- Name: objects Allow anonymous uploads to product-images; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Allow anonymous uploads to product-images" ON storage.objects FOR INSERT WITH CHECK ((bucket_id = 'product-images'::text));


--
-- TOC entry 4364 (class 3256 OID 49855)
-- Name: objects Allow public access to product-images; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Allow public access to product-images" ON storage.objects FOR SELECT USING ((bucket_id = 'product-images'::text));


--
-- TOC entry 4344 (class 0 OID 16544)
-- Dependencies: 361
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4350 (class 0 OID 48036)
-- Dependencies: 391
-- Name: buckets_analytics; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets_analytics ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4388 (class 3256 OID 70396)
-- Name: objects campaign_images_public_read; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY campaign_images_public_read ON storage.objects FOR SELECT USING ((bucket_id = 'campaign-images'::text));


--
-- TOC entry 4391 (class 3256 OID 70420)
-- Name: objects campaign_images_write_delete; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY campaign_images_write_delete ON storage.objects FOR DELETE TO authenticated USING (((bucket_id = 'campaign-images'::text) AND (app.is_hq_admin() OR app.is_power_user())));


--
-- TOC entry 4389 (class 3256 OID 70418)
-- Name: objects campaign_images_write_insert; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY campaign_images_write_insert ON storage.objects FOR INSERT TO authenticated WITH CHECK (((bucket_id = 'campaign-images'::text) AND (app.is_hq_admin() OR app.is_power_user())));


--
-- TOC entry 4390 (class 3256 OID 70419)
-- Name: objects campaign_images_write_update; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY campaign_images_write_update ON storage.objects FOR UPDATE TO authenticated USING (((bucket_id = 'campaign-images'::text) AND (app.is_hq_admin() OR app.is_power_user()))) WITH CHECK (((bucket_id = 'campaign-images'::text) AND (app.is_hq_admin() OR app.is_power_user())));


--
-- TOC entry 4346 (class 0 OID 16586)
-- Dependencies: 363
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4345 (class 0 OID 16559)
-- Dependencies: 362
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4349 (class 0 OID 47992)
-- Dependencies: 390
-- Name: prefixes; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.prefixes ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4356 (class 3256 OID 67241)
-- Name: objects prizes delete; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "prizes delete" ON storage.objects FOR DELETE TO authenticated USING (((bucket_id = 'prizes'::text) AND (app.is_hq_admin() OR app.is_power_user())));


--
-- TOC entry 4375 (class 3256 OID 67238)
-- Name: objects prizes read; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "prizes read" ON storage.objects FOR SELECT USING ((bucket_id = 'prizes'::text));


--
-- TOC entry 4377 (class 3256 OID 67240)
-- Name: objects prizes update; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "prizes update" ON storage.objects FOR UPDATE TO authenticated USING (((bucket_id = 'prizes'::text) AND (app.is_hq_admin() OR app.is_power_user()))) WITH CHECK (((bucket_id = 'prizes'::text) AND (app.is_hq_admin() OR app.is_power_user())));


--
-- TOC entry 4376 (class 3256 OID 67239)
-- Name: objects prizes write; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "prizes write" ON storage.objects FOR INSERT TO authenticated WITH CHECK (((bucket_id = 'prizes'::text) AND (app.is_hq_admin() OR app.is_power_user())));


--
-- TOC entry 4359 (class 3256 OID 67392)
-- Name: objects prizes_delete_auth; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY prizes_delete_auth ON storage.objects FOR DELETE TO authenticated USING ((bucket_id = 'prizes'::text));


--
-- TOC entry 4357 (class 3256 OID 67390)
-- Name: objects prizes_insert_auth; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY prizes_insert_auth ON storage.objects FOR INSERT TO authenticated WITH CHECK ((bucket_id = 'prizes'::text));


--
-- TOC entry 4378 (class 3256 OID 67388)
-- Name: objects prizes_read_anon; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY prizes_read_anon ON storage.objects FOR SELECT TO anon USING ((bucket_id = 'prizes'::text));


--
-- TOC entry 4355 (class 3256 OID 67389)
-- Name: objects prizes_read_auth; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY prizes_read_auth ON storage.objects FOR SELECT TO authenticated USING ((bucket_id = 'prizes'::text));


--
-- TOC entry 4358 (class 3256 OID 67391)
-- Name: objects prizes_update_auth; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY prizes_update_auth ON storage.objects FOR UPDATE TO authenticated USING ((bucket_id = 'prizes'::text)) WITH CHECK ((bucket_id = 'prizes'::text));


--
-- TOC entry 4365 (class 3256 OID 49879)
-- Name: objects product_images_authenticated_write; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY product_images_authenticated_write ON storage.objects FOR INSERT TO authenticated WITH CHECK ((bucket_id = 'product-images'::text));


--
-- TOC entry 4387 (class 3256 OID 70190)
-- Name: objects product_images_authenticated_write_delete; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY product_images_authenticated_write_delete ON storage.objects FOR DELETE TO authenticated USING (((bucket_id = 'product-images'::text) AND (app.is_hq_admin() OR app.is_power_user())));


--
-- TOC entry 4385 (class 3256 OID 70188)
-- Name: objects product_images_authenticated_write_insert; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY product_images_authenticated_write_insert ON storage.objects FOR INSERT TO authenticated WITH CHECK (((bucket_id = 'product-images'::text) AND (app.is_hq_admin() OR app.is_power_user())));


--
-- TOC entry 4386 (class 3256 OID 70189)
-- Name: objects product_images_authenticated_write_update; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY product_images_authenticated_write_update ON storage.objects FOR UPDATE TO authenticated USING (((bucket_id = 'product-images'::text) AND (app.is_hq_admin() OR app.is_power_user()))) WITH CHECK (((bucket_id = 'product-images'::text) AND (app.is_hq_admin() OR app.is_power_user())));


--
-- TOC entry 4384 (class 3256 OID 69976)
-- Name: objects product_images_hq_power_delete; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY product_images_hq_power_delete ON storage.objects FOR DELETE TO authenticated USING (((bucket_id = 'product-images'::text) AND (app.is_hq_admin() OR app.is_power_user())));


--
-- TOC entry 4382 (class 3256 OID 69974)
-- Name: objects product_images_hq_power_insert; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY product_images_hq_power_insert ON storage.objects FOR INSERT TO authenticated WITH CHECK (((bucket_id = 'product-images'::text) AND (app.is_hq_admin() OR app.is_power_user())));


--
-- TOC entry 4383 (class 3256 OID 69975)
-- Name: objects product_images_hq_power_update; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY product_images_hq_power_update ON storage.objects FOR UPDATE TO authenticated USING (((bucket_id = 'product-images'::text) AND (app.is_hq_admin() OR app.is_power_user()))) WITH CHECK (((bucket_id = 'product-images'::text) AND (app.is_hq_admin() OR app.is_power_user())));


--
-- TOC entry 4366 (class 3256 OID 49880)
-- Name: objects product_images_public_read; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY product_images_public_read ON storage.objects FOR SELECT USING ((bucket_id = 'product-images'::text));


--
-- TOC entry 4381 (class 3256 OID 69952)
-- Name: objects product_images_server_write_delete; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY product_images_server_write_delete ON storage.objects FOR DELETE TO authenticated USING (((bucket_id = 'product-images'::text) AND (app.is_hq_admin() OR app.is_power_user())));


--
-- TOC entry 4379 (class 3256 OID 69908)
-- Name: objects product_images_server_write_insert; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY product_images_server_write_insert ON storage.objects FOR INSERT TO authenticated WITH CHECK (((bucket_id = 'product-images'::text) AND (app.is_hq_admin() OR app.is_power_user())));


--
-- TOC entry 4380 (class 3256 OID 69930)
-- Name: objects product_images_server_write_update; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY product_images_server_write_update ON storage.objects FOR UPDATE TO authenticated USING (((bucket_id = 'product-images'::text) AND (app.is_hq_admin() OR app.is_power_user()))) WITH CHECK (((bucket_id = 'product-images'::text) AND (app.is_hq_admin() OR app.is_power_user())));


--
-- TOC entry 4347 (class 0 OID 17126)
-- Dependencies: 384
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4348 (class 0 OID 17141)
-- Dependencies: 385
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

-- Completed on 2025-09-26 23:28:26 +08

--
-- PostgreSQL database dump complete
--

\unrestrict QdMMvEieMDDxnrtn6rUkLGDJvWdDxIIOXWuNWdyGTSozIzgoVsCNjmwH5suV3Lm

