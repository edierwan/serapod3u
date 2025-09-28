--
-- PostgreSQL database dump
--

\restrict SgTdZxUapFcpeuijmN6DP5WVmeLBu4Sqee7OCWspt21tntgT7vFR1gm4IdObLXJ

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.6

-- Started on 2025-09-28 21:57:47 +08

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
-- TOC entry 4910 (class 0 OID 0)
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
-- TOC entry 1548 (class 1247 OID 84439)
-- Name: app_role; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.app_role AS ENUM (
    'hq_admin',
    'distributor_admin',
    'shop_user'
);


--
-- TOC entry 1587 (class 1247 OID 57062)
-- Name: batch_priority_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.batch_priority_type AS ENUM (
    'normal',
    'high'
);


--
-- TOC entry 1584 (class 1247 OID 57053)
-- Name: batch_status_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.batch_status_type AS ENUM (
    'created',
    'in_progress',
    'quality_check',
    'completed'
);


--
-- TOC entry 1554 (class 1247 OID 57267)
-- Name: campaign_status_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.campaign_status_type AS ENUM (
    'draft',
    'pending_approval',
    'active',
    'inactive'
);


--
-- TOC entry 1527 (class 1247 OID 88386)
-- Name: case_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.case_status AS ENUM (
    'new',
    'packing',
    'packed'
);


--
-- TOC entry 1713 (class 1247 OID 67167)
-- Name: draw_selection_method; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.draw_selection_method AS ENUM (
    'random',
    'manual'
);


--
-- TOC entry 1396 (class 1247 OID 56931)
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
-- TOC entry 1572 (class 1247 OID 52114)
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
-- TOC entry 1674 (class 1247 OID 88773)
-- Name: ld_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.ld_status AS ENUM (
    'draft',
    'active',
    'ended',
    'archived'
);


--
-- TOC entry 1508 (class 1247 OID 88656)
-- Name: location_kind; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.location_kind AS ENUM (
    'manufacturer',
    'warehouse',
    'distributor',
    'shop'
);


--
-- TOC entry 1493 (class 1247 OID 84275)
-- Name: manufacturer_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.manufacturer_status AS ENUM (
    'active',
    'inactive',
    'blocked'
);


--
-- TOC entry 1695 (class 1247 OID 89221)
-- Name: notification_channel; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.notification_channel AS ENUM (
    'email',
    'sms',
    'whatsapp'
);


--
-- TOC entry 1539 (class 1247 OID 57196)
-- Name: notification_channel_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.notification_channel_type AS ENUM (
    'whatsapp',
    'email'
);


--
-- TOC entry 1536 (class 1247 OID 57169)
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
-- TOC entry 1542 (class 1247 OID 57202)
-- Name: notification_status_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.notification_status_type AS ENUM (
    'queued',
    'sent',
    'failed'
);


--
-- TOC entry 1481 (class 1247 OID 56946)
-- Name: order_priority_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.order_priority_type AS ENUM (
    'normal',
    'high'
);


--
-- TOC entry 1638 (class 1247 OID 88181)
-- Name: order_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.order_status AS ENUM (
    'draft',
    'submitted',
    'approved',
    'rejected',
    'cancelled'
);


--
-- TOC entry 1566 (class 1247 OID 52085)
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
-- TOC entry 1569 (class 1247 OID 52102)
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
-- TOC entry 1665 (class 1247 OID 61285)
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
-- TOC entry 1647 (class 1247 OID 88915)
-- Name: points_op; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.points_op AS ENUM (
    'earn',
    'redeem',
    'adjust'
);


--
-- TOC entry 1632 (class 1247 OID 48273)
-- Name: product_category_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.product_category_type AS ENUM (
    'vape',
    'nonvape'
);


--
-- TOC entry 1575 (class 1247 OID 49587)
-- Name: product_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.product_status AS ENUM (
    'draft',
    'active',
    'inactive',
    'discontinued'
);


--
-- TOC entry 1677 (class 1247 OID 88782)
-- Name: redeem_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.redeem_status AS ENUM (
    'pending',
    'fulfilled',
    'cancelled'
);


--
-- TOC entry 1478 (class 1247 OID 82219)
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
-- TOC entry 1740 (class 1247 OID 70693)
-- Name: royalty_activity_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.royalty_activity_type AS ENUM (
    'daily',
    'weekly',
    'one-time',
    'repeatable'
);


--
-- TOC entry 1749 (class 1247 OID 70718)
-- Name: royalty_redemption_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.royalty_redemption_status AS ENUM (
    'pending',
    'processing',
    'fulfilled',
    'cancelled'
);


--
-- TOC entry 1746 (class 1247 OID 70710)
-- Name: royalty_tx_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.royalty_tx_status AS ENUM (
    'completed',
    'pending',
    'cancelled'
);


--
-- TOC entry 1743 (class 1247 OID 70702)
-- Name: royalty_tx_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.royalty_tx_type AS ENUM (
    'earned',
    'redeemed',
    'adjustment'
);


--
-- TOC entry 1499 (class 1247 OID 88646)
-- Name: shipment_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.shipment_status AS ENUM (
    'draft',
    'shipped',
    'received',
    'cancelled'
);


--
-- TOC entry 1496 (class 1247 OID 88641)
-- Name: shipment_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.shipment_type AS ENUM (
    'mfr_to_wh',
    'wh_to_dist'
);


--
-- TOC entry 1635 (class 1247 OID 48278)
-- Name: status_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.status_type AS ENUM (
    'active',
    'inactive'
);


--
-- TOC entry 1521 (class 1247 OID 48031)
-- Name: buckettype; Type: TYPE; Schema: storage; Owner: -
--

CREATE TYPE storage.buckettype AS ENUM (
    'STANDARD',
    'ANALYTICS'
);


--
-- TOC entry 750 (class 1255 OID 88973)
-- Name: _compute_points_for_unique(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public._compute_points_for_unique(p_unique_id uuid) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_points   integer;
  v_prod     uuid;
  v_var      uuid;
  v_poi      uuid;
  v_override integer;
  v_default  integer;
BEGIN
  SELECT uc.product_id, uc.variant_id, uc.po_item_id INTO v_prod, v_var, v_poi
  FROM public.unique_codes uc
  WHERE uc.id = p_unique_id;

  IF v_prod IS NULL THEN
    RETURN 0;
  END IF;

  SELECT points_per_unit_override INTO v_override
  FROM public.purchase_order_items
  WHERE id = v_poi;

  SELECT COALESCE(default_points_per_unit, 1) INTO v_default
  FROM public.points_config WHERE id = TRUE;

  SELECT pr.points_per_unit
  INTO v_points
  FROM public.points_rules pr
  WHERE pr.active
    AND pr.product_id = v_prod
    AND (pr.variant_id IS NULL OR pr.variant_id = v_var)
    AND (pr.valid_from IS NULL OR now() >= pr.valid_from)
    AND (pr.valid_to   IS NULL OR now() <= pr.valid_to)
  ORDER BY (pr.variant_id IS NOT NULL) DESC, pr.valid_from NULLS FIRST
  LIMIT 1;

  RETURN COALESCE(v_override, v_points, v_default, 1);
END
$$;


--
-- TOC entry 483 (class 1255 OID 88459)
-- Name: _mint_code(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public._mint_code(prefix text, bytes integer DEFAULT 8) RETURNS text
    LANGUAGE sql
    AS $$
  SELECT upper(prefix || '-' || substr(encode(gen_random_bytes(bytes), 'hex'), 1, bytes*2));
$$;


--
-- TOC entry 489 (class 1255 OID 88748)
-- Name: add_case_to_shipment(uuid, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.add_case_to_shipment(p_shipment_id uuid, p_case_identifier text) RETURNS TABLE(shipment_id uuid, case_code text, rfid_uid text)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_shp record;
  v_case record;
  v_assigned_count int;
BEGIN
  SELECT * INTO v_shp FROM public.shipments WHERE id = p_shipment_id;
  IF NOT FOUND THEN RAISE EXCEPTION 'Shipment not found'; END IF;
  IF v_shp.status <> 'draft' THEN RAISE EXCEPTION 'Shipment must be in DRAFT to add lines'; END IF;

  SELECT c.*, poi.po_id
  INTO v_case
  FROM public.cases c
  JOIN public.purchase_order_items poi ON poi.id = c.po_item_id
  WHERE c.code = p_case_identifier OR c.rfid_uid = p_case_identifier;
  IF NOT FOUND THEN RAISE EXCEPTION 'Case not found for identifier %', p_case_identifier; END IF;

  IF v_shp.type = 'mfr_to_wh' THEN
    IF v_case.status <> 'packed' THEN
      RAISE EXCEPTION 'Case % is not PACKED', v_case.code;
    END IF;
    IF v_case.location_kind <> 'manufacturer' OR v_case.in_transit THEN
      RAISE EXCEPTION 'Case % not available at Manufacturer', v_case.code;
    END IF;
  END IF;

  IF v_shp.type = 'wh_to_dist' THEN
    IF v_case.location_kind <> 'warehouse' OR v_case.in_transit THEN
      RAISE EXCEPTION 'Case % not available at Warehouse', v_case.code;
    END IF;

    SELECT COUNT(*) INTO v_assigned_count FROM public.unique_codes u WHERE u.case_id = v_case.id;
    IF v_assigned_count <> v_case.units_per_case THEN
      RAISE EXCEPTION 'Case % is not full (%/%). Use partial by scanning uniques.', v_case.code, v_assigned_count, v_case.units_per_case;
    END IF;
    IF EXISTS (SELECT 1 FROM public.unique_codes u
               WHERE u.case_id = v_case.id AND (u.location_kind <> 'warehouse' OR u.in_transit)) THEN
      RAISE EXCEPTION 'Case % has units not on-hand at warehouse', v_case.code;
    END IF;
  END IF;

  INSERT INTO public.shipment_cases (shipment_id, case_id)
  VALUES (v_shp.id, v_case.id)
  ON CONFLICT (shipment_id, case_id) DO NOTHING;

  RETURN QUERY SELECT v_shp.id, v_case.code, v_case.rfid_uid;
END
$$;


--
-- TOC entry 540 (class 1255 OID 88749)
-- Name: add_unique_to_shipment(uuid, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.add_unique_to_shipment(p_shipment_id uuid, p_unique_code text) RETURNS TABLE(shipment_id uuid, unique_code text)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_shp record;
  v_u   record;
BEGIN
  SELECT * INTO v_shp FROM public.shipments WHERE id = p_shipment_id;
  IF NOT FOUND THEN RAISE EXCEPTION 'Shipment not found'; END IF;
  IF v_shp.status <> 'draft' THEN RAISE EXCEPTION 'Shipment must be in DRAFT to add lines'; END IF;
  IF v_shp.type <> 'wh_to_dist' THEN RAISE EXCEPTION 'Unique-level lines allowed only for wh_to_dist'; END IF;

  SELECT * INTO v_u FROM public.unique_codes WHERE code = p_unique_code;
  IF NOT FOUND THEN RAISE EXCEPTION 'Unique % not found', p_unique_code; END IF;

  IF v_u.location_kind <> 'warehouse' OR v_u.in_transit THEN
    RAISE EXCEPTION 'Unique % not available at Warehouse', p_unique_code;
  END IF;

  INSERT INTO public.shipment_uniques (shipment_id, unique_id)
  VALUES (v_shp.id, v_u.id)
  ON CONFLICT (shipment_id, unique_id) DO NOTHING;

  RETURN QUERY SELECT v_shp.id, v_u.code;
END
$$;


--
-- TOC entry 620 (class 1255 OID 70854)
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
-- TOC entry 667 (class 1255 OID 55414)
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
-- TOC entry 529 (class 1255 OID 55415)
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
-- TOC entry 460 (class 1255 OID 55413)
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
-- TOC entry 659 (class 1255 OID 57336)
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
-- TOC entry 522 (class 1255 OID 67552)
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
-- TOC entry 707 (class 1255 OID 67550)
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
-- TOC entry 551 (class 1255 OID 57672)
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
-- TOC entry 722 (class 1255 OID 88507)
-- Name: assign_unique_to_case(text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.assign_unique_to_case(p_case_identifier text, p_unique_code text, p_source text DEFAULT 'scan'::text) RETURNS TABLE(case_code text, rfid_uid text, unique_code text, assigned_count integer, capacity integer, case_status public.case_status)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_case record;
  v_u    record;
  v_assigned int;
BEGIN
  -- resolve case by master code OR RFID
  SELECT c.*, poi.po_id
  INTO v_case
  FROM public.cases c
  JOIN public.purchase_order_items poi ON poi.id = c.po_item_id
  WHERE c.code = p_case_identifier OR c.rfid_uid = p_case_identifier;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Case not found for identifier % (master or RFID)', p_case_identifier;
  END IF;

  -- load unique
  SELECT u.*
  INTO v_u
  FROM public.unique_codes u
  WHERE u.code = p_unique_code;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Unique code % not found', p_unique_code;
  END IF;

  -- basic validations (fast-fail)
  IF v_u.case_id IS NOT NULL THEN
    RAISE EXCEPTION 'Unique % is already assigned to another case', p_unique_code;
  END IF;

  IF v_u.po_item_id IS DISTINCT FROM v_case.po_item_id THEN
    RAISE EXCEPTION 'Unique % does not belong to the same PO line as the case', p_unique_code;
  END IF;

  IF v_case.status NOT IN ('new','packing') THEN
    RAISE EXCEPTION 'Case is not open for packing';
  END IF;

  -- do the assignment (trigger will also enforce capacity & batch)
  UPDATE public.unique_codes
  SET case_id = v_case.id, updated_at = now()
  WHERE id = v_u.id;

  -- mark case as packing if it was new
  IF v_case.status = 'new' THEN
    UPDATE public.cases SET status = 'packing', updated_at = now() WHERE id = v_case.id;
  END IF;

  -- log event
  INSERT INTO public.pack_events (po_id, po_item_id, case_id, unique_id, event_type, source, actor_user_id, meta)
  VALUES (v_case.po_id, v_case.po_item_id, v_case.id, v_u.id, 'assign', COALESCE(p_source,'scan'), auth.uid(), jsonb_build_object('unique_code', p_unique_code));

  -- compute current count
  SELECT COUNT(*) INTO v_assigned FROM public.unique_codes WHERE case_id = v_case.id;

  -- if full, mark packed & log
  IF v_assigned >= v_case.units_per_case THEN
    UPDATE public.cases SET status = 'packed', updated_at = now() WHERE id = v_case.id;
    INSERT INTO public.pack_events (po_id, po_item_id, case_id, unique_id, event_type, source, actor_user_id)
    VALUES (v_case.po_id, v_case.po_item_id, v_case.id, NULL, 'case_packed', 'system', auth.uid());
  END IF;

  RETURN QUERY
  SELECT v_case.code, v_case.rfid_uid, v_u.code, v_assigned, v_case.units_per_case,
         (SELECT status FROM public.cases WHERE id = v_case.id);
END
$$;


--
-- TOC entry 595 (class 1255 OID 57756)
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
-- TOC entry 572 (class 1255 OID 67192)
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
-- TOC entry 739 (class 1255 OID 89199)
-- Name: award_shop_points(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.award_shop_points(p_order_id uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  RAISE EXCEPTION
    'DEPRECATED: award_shop_points(order_id) removed. Use award_shop_points(unique_code text, shop_id uuid) per-unique.';
END
$$;


--
-- TOC entry 513 (class 1255 OID 88974)
-- Name: award_shop_points(text, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.award_shop_points(p_unique_code text, p_shop_id uuid) RETURNS TABLE(ledger_id uuid, points_awarded integer, new_balance bigint, unique_code text, product_id uuid, po_item_id uuid)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_u   public.unique_codes%ROWTYPE;
  v_pts integer;
  v_id  uuid;
BEGIN
  IF p_shop_id IS NULL THEN
    RAISE EXCEPTION 'shop_id is required';
  END IF;

  SELECT * INTO v_u FROM public.unique_codes WHERE code = p_unique_code;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Unique code not found';
  END IF;

  IF v_u.points_eligible IS NOT TRUE THEN
    RAISE EXCEPTION 'This code is not eligible for points';
  END IF;

  IF EXISTS (SELECT 1 FROM public.shop_points_ledger WHERE unique_id = v_u.id AND operation='earn') THEN
    RAISE EXCEPTION 'Points already awarded for this code';
  END IF;

  IF v_u.owned_by_shop_id IS NOT NULL AND v_u.owned_by_shop_id <> p_shop_id THEN
    RAISE EXCEPTION 'This code has already been credited to another shop';
  END IF;

  v_pts := public._compute_points_for_unique(v_u.id);
  IF v_pts <= 0 THEN
    RAISE EXCEPTION 'Configured points per unit is zero; check rules or defaults';
  END IF;

  INSERT INTO public.shop_points_ledger (shop_id, operation, points, unique_id, po_item_id, product_id, variant_id, created_by, meta)
  VALUES (p_shop_id, 'earn', v_pts, v_u.id, v_u.po_item_id, v_u.product_id, v_u.variant_id, auth.uid(),
          jsonb_build_object('unique_code', p_unique_code, 'source', 'shop_scan'))
  RETURNING id INTO v_id;

  UPDATE public.unique_codes
  SET owned_by_shop_id = COALESCE(owned_by_shop_id, p_shop_id),
      points_earned_at = COALESCE(points_earned_at, now()),
      updated_at = now()
  WHERE id = v_u.id;

  RETURN QUERY
  SELECT
    v_id,
    v_pts,
    (SELECT COALESCE(SUM(points),0) FROM public.shop_points_ledger WHERE shop_id = p_shop_id),
    v_u.code,
    v_u.product_id,
    v_u.po_item_id;
END
$$;


--
-- TOC entry 719 (class 1255 OID 63422)
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
-- TOC entry 660 (class 1255 OID 63302)
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
-- TOC entry 488 (class 1255 OID 70855)
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
-- TOC entry 519 (class 1255 OID 59255)
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
-- TOC entry 698 (class 1255 OID 57489)
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
-- TOC entry 639 (class 1255 OID 63400)
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
-- TOC entry 640 (class 1255 OID 63650)
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
-- TOC entry 566 (class 1255 OID 63740)
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
-- TOC entry 505 (class 1255 OID 88844)
-- Name: claim_redeem(text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.claim_redeem(p_unique_code text, p_claimant_name text, p_claimant_phone text) RETURNS TABLE(claim_id uuid, status public.redeem_status, claimed_at timestamp with time zone)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_unique public.unique_codes%ROWTYPE;
  v_id     uuid;
BEGIN
  SELECT * INTO v_unique FROM public.unique_codes WHERE code = p_unique_code;
  IF NOT FOUND THEN RAISE EXCEPTION 'Unique code not found'; END IF;

  IF v_unique.redeem_on IS NOT TRUE THEN
    RAISE EXCEPTION 'This code is not eligible for Redeem';
  END IF;

  -- insert if not exists
  INSERT INTO public.redeem_claims (unique_id, claimant_name, claimant_phone)
  VALUES (v_unique.id, p_claimant_name, p_claimant_phone)
  ON CONFLICT (unique_id) DO NOTHING;

  SELECT id INTO v_id FROM public.redeem_claims WHERE unique_id = v_unique.id;

  RETURN QUERY
  SELECT v_id, (SELECT status FROM public.redeem_claims WHERE id=v_id), (SELECT claimed_at FROM public.redeem_claims WHERE id=v_id);
END
$$;


--
-- TOC entry 688 (class 1255 OID 52167)
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
-- TOC entry 738 (class 1255 OID 70852)
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
-- TOC entry 571 (class 1255 OID 50629)
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
-- TOC entry 466 (class 1255 OID 48327)
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
-- TOC entry 711 (class 1255 OID 89390)
-- Name: create_order_from_first_item(uuid, integer, numeric, numeric, numeric, numeric, numeric); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.create_order_from_first_item(p_product_id uuid, p_quantity integer, p_unit_price numeric, p_discount_rate numeric, p_tax_rate numeric, p_shipping_cost numeric DEFAULT 0, p_order_discount numeric DEFAULT 0) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_order_id         uuid;
  v_manufacturer_id  uuid;
  v_active           boolean;

  -- HQ snapshot fields
  v_hq_name   text;
  v_hq_email  text;
  v_hq_phone  text;
  v_hq_addr   text;
BEGIN
  -- validate inputs
  IF p_quantity IS NULL OR p_quantity <= 0 THEN
    RAISE EXCEPTION 'quantity must be > 0';
  END IF;
  IF p_unit_price IS NULL OR p_unit_price < 0 THEN
    RAISE EXCEPTION 'unit_price must be >= 0';
  END IF;
  IF p_discount_rate < 0 OR p_discount_rate > 1 THEN
    RAISE EXCEPTION 'discount_rate must be between 0 and 1';
  END IF;
  IF p_tax_rate < 0 OR p_tax_rate > 1 THEN
    RAISE EXCEPTION 'tax_rate must be between 0 and 1';
  END IF;

  -- product -> manufacturer, ensure active
  SELECT manufacturer_id, active
    INTO v_manufacturer_id, v_active
  FROM public.products
  WHERE id = p_product_id;

  IF v_manufacturer_id IS NULL THEN
    RAISE EXCEPTION 'Product % not found', p_product_id;
  END IF;
  IF v_active IS DISTINCT FROM TRUE THEN
    RAISE EXCEPTION 'Product % is not active', p_product_id;
  END IF;

  -- read HQ info singleton (may be null if not set yet)
  SELECT customer_name, customer_email, customer_contact_no, delivery_address
    INTO v_hq_name, v_hq_email, v_hq_phone, v_hq_addr
  FROM public.hq_info
  LIMIT 1;

  -- insert order header (draft) + snapshot HQ fields
  INSERT INTO public.orders (
    manufacturer_id, status, shipping_cost, discount_amount,
    customer_name, customer_email, customer_contact_no, delivery_address
  )
  VALUES (
    v_manufacturer_id, 'draft', COALESCE(p_shipping_cost,0), COALESCE(p_order_discount,0),
    v_hq_name, v_hq_email, v_hq_phone, v_hq_addr
  )
  RETURNING id INTO v_order_id;

  -- insert first item (triggers will recalc totals)
  INSERT INTO public.order_items (
    order_id, product_id, quantity, unit_price, discount_rate, tax_rate
  )
  VALUES (
    v_order_id, p_product_id, p_quantity, p_unit_price,
    COALESCE(p_discount_rate,0), COALESCE(p_tax_rate,0)
  );

  RETURN v_order_id;
END
$$;


--
-- TOC entry 689 (class 1255 OID 59458)
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
-- TOC entry 539 (class 1255 OID 52932)
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
-- TOC entry 465 (class 1255 OID 65828)
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
-- TOC entry 482 (class 1255 OID 88505)
-- Name: enforce_case_assignment(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.enforce_case_assignment() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_units_per_case int;
  v_po_item_case   uuid;
  v_count_assigned int;
  v_old_case       uuid;
BEGIN
  -- only when assigning or changing the case_id
  IF TG_OP = 'UPDATE' AND NEW.case_id IS NOT DISTINCT FROM OLD.case_id THEN
    RETURN NEW;
  END IF;

  IF NEW.case_id IS NULL THEN
    RETURN NEW; -- unassign allowed by app rules later if needed
  END IF;

  -- load case row & capacity
  SELECT units_per_case, po_item_id INTO v_units_per_case, v_po_item_case
  FROM public.cases
  WHERE id = NEW.case_id
  FOR UPDATE; -- lock case to serialize concurrent assignments

  IF v_units_per_case IS NULL THEN
    RAISE EXCEPTION 'Target case % not found', NEW.case_id;
  END IF;

  -- same PO line?
  IF NEW.po_item_id IS DISTINCT FROM v_po_item_case THEN
    RAISE EXCEPTION 'Unique % (po_item_id=%) does not belong to target case (po_item_id=%)',
      NEW.id, NEW.po_item_id, v_po_item_case;
  END IF;

  -- case status must be new/packing
  IF (SELECT status FROM public.cases WHERE id = NEW.case_id) NOT IN ('new','packing') THEN
    RAISE EXCEPTION 'Case is not open for packing';
  END IF;

  -- compute count including this row
  SELECT COUNT(*) INTO v_count_assigned
  FROM public.unique_codes
  WHERE case_id = NEW.case_id
  AND id <> NEW.id; -- current row not yet counted

  IF v_count_assigned + 1 > v_units_per_case THEN
    RAISE EXCEPTION 'Case capacity exceeded (%/%). Scan a different case.',
      v_count_assigned + 1, v_units_per_case;
  END IF;

  RETURN NEW;
END
$$;


--
-- TOC entry 619 (class 1255 OID 84458)
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
-- TOC entry 627 (class 1255 OID 57237)
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
-- TOC entry 609 (class 1255 OID 64144)
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
-- TOC entry 663 (class 1255 OID 63672)
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
-- TOC entry 574 (class 1255 OID 85992)
-- Name: factory_reset_master_data(boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.factory_reset_master_data(keep_categories boolean DEFAULT false) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    result JSONB := '{}';
    start_time TIMESTAMP := clock_timestamp();
BEGIN
    -- Environment check
    IF current_setting('app.environment', TRUE) = 'production' THEN
        RAISE EXCEPTION 'Factory reset not allowed in production environment';
    END IF;

    BEGIN
        -- Use TRUNCATE instead of DELETE to avoid WHERE clause requirements
        TRUNCATE TABLE product_variants CASCADE;
        TRUNCATE TABLE products CASCADE;
        TRUNCATE TABLE product_subgroups CASCADE;
        TRUNCATE TABLE product_groups CASCADE;
        TRUNCATE TABLE brands CASCADE;
        
        IF NOT keep_categories THEN
            TRUNCATE TABLE categories CASCADE;
        END IF;
        
        TRUNCATE TABLE shops CASCADE;
        TRUNCATE TABLE distributors CASCADE;
        TRUNCATE TABLE manufacturers CASCADE;

        -- Reset sequences
        PERFORM setval('sku_seq_vape', 1, FALSE);
        PERFORM setval('sku_seq_nonvape', 1, FALSE);
        PERFORM setval('manufacturer_batch_seq', 1, FALSE);
        PERFORM setval('order_no_seq', 1, FALSE);
        PERFORM setval('hq_order_seq', 1, FALSE);

        result := result || jsonb_build_object('sequences_reset', TRUE);

        -- Log the operation
        INSERT INTO audit_log (
            operation,
            entity_type,
            entity_id,
            details,
            performed_by
        ) VALUES (
            'factory_reset',
            'system',
            NULL,
            jsonb_build_object(
                'operation', 'factory_reset_master_data',
                'keep_categories', keep_categories,
                'results', result,
                'duration_ms', EXTRACT(EPOCH FROM (clock_timestamp() - start_time)) * 1000
            ),
            auth.uid()
        );

        RETURN result || jsonb_build_object(
            'success', TRUE,
            'duration_ms', EXTRACT(EPOCH FROM (clock_timestamp() - start_time)) * 1000,
            'timestamp', clock_timestamp()
        );

    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Factory reset failed: %', SQLERRM;
    END;
END;
$$;


--
-- TOC entry 647 (class 1255 OID 88845)
-- Name: fulfill_redeem_claim(text, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fulfill_redeem_claim(p_unique_code text, p_fulfilled_by_shop uuid) RETURNS TABLE(claim_id uuid, status public.redeem_status, fulfilled_at timestamp with time zone)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_unique public.unique_codes%ROWTYPE;
  v_claim  public.redeem_claims%ROWTYPE;
BEGIN
  SELECT * INTO v_unique FROM public.unique_codes WHERE code = p_unique_code;
  IF NOT FOUND THEN RAISE EXCEPTION 'Unique code not found'; END IF;

  SELECT * INTO v_claim FROM public.redeem_claims WHERE unique_id = v_unique.id;
  IF NOT FOUND THEN RAISE EXCEPTION 'No pending claim found for this code'; END IF;

  IF v_claim.status <> 'pending' THEN
    RAISE EXCEPTION 'Claim is not pending';
  END IF;

  UPDATE public.redeem_claims
  SET status='fulfilled', fulfilled_by_shop_id = p_fulfilled_by_shop, fulfilled_at = now()
  WHERE id = v_claim.id;

  RETURN QUERY
  SELECT v_claim.id, 'fulfilled'::public.redeem_status, (SELECT fulfilled_at FROM public.redeem_claims WHERE id=v_claim.id);
END
$$;


--
-- TOC entry 478 (class 1255 OID 56969)
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
-- TOC entry 567 (class 1255 OID 57125)
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
-- TOC entry 690 (class 1255 OID 52126)
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
-- TOC entry 516 (class 1255 OID 88460)
-- Name: generate_qr_pool_for_po(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.generate_qr_pool_for_po(p_po_id uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_exists int;
  r record;
  i int;
  case_count int;
  uniq_count int;
  v_case_id uuid;
BEGIN
  -- guard: prevent double-generation
  SELECT COUNT(*) INTO v_exists
  FROM public.cases c
  JOIN public.purchase_order_items poi ON poi.id = c.po_item_id
  WHERE poi.po_id = p_po_id;

  IF v_exists > 0 THEN
    RAISE EXCEPTION 'QR pool already generated for PO %', p_po_id USING ERRCODE = 'unique_violation';
  END IF;

  -- loop PO lines and generate pools
  FOR r IN
    SELECT
      poi.id               AS po_item_id,
      poi.product_id,
      poi.variant_id,
      poi.units_per_case,
      poi.lucky_draw_on,
      poi.redeem_on,
      poi.rfid_enabled,
      CEIL(poi.quantity_units::numeric / poi.units_per_case)::int    AS planned_case_count,
      (poi.quantity_units + CEIL(poi.quantity_units::numeric * poi.buffer_pct))::int AS planned_unique_count
    FROM public.purchase_order_items poi
    WHERE poi.po_id = p_po_id
  LOOP
    -- A) Cases
    case_count := r.planned_case_count;
    FOR i IN 1..case_count LOOP
      INSERT INTO public.cases (po_item_id, code, rfid_required, units_per_case, status)
      VALUES (
        r.po_item_id,
        public._mint_code('C'),
        COALESCE(r.rfid_enabled, false),
        r.units_per_case,
        'new'
      )
      RETURNING id INTO v_case_id;
      -- we do NOT set rfid_uid here; it will be recorded during tagging/packing
    END LOOP;

    -- B) Unique codes (incl. 10% buffer)
    uniq_count := r.planned_unique_count;
    FOR i IN 1..uniq_count LOOP
      INSERT INTO public.unique_codes (
        po_item_id, code, product_id, variant_id,
        lucky_draw_on, redeem_on, points_eligible
      ) VALUES (
        r.po_item_id,
        public._mint_code('U'),
        r.product_id, r.variant_id,
        COALESCE(r.lucky_draw_on, false),
        COALESCE(r.redeem_on, false),
        true
      );
    END LOOP;

  END LOOP;
END
$$;


--
-- TOC entry 655 (class 1255 OID 50098)
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
-- TOC entry 637 (class 1255 OID 49597)
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
-- TOC entry 581 (class 1255 OID 82501)
-- Name: generate_sku(uuid, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.generate_sku(p_product_id uuid, p_serial integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
begin
  return 'SKU-' || replace(p_product_id::text,'-','') || '-' || lpad(p_serial::text,6,'0');
end $$;


--
-- TOC entry 710 (class 1255 OID 57671)
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
-- TOC entry 606 (class 1255 OID 59254)
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
-- TOC entry 697 (class 1255 OID 57238)
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
-- TOC entry 646 (class 1255 OID 57670)
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
-- TOC entry 585 (class 1255 OID 53024)
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
-- TOC entry 597 (class 1255 OID 57542)
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
-- TOC entry 772 (class 1255 OID 57368)
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
-- TOC entry 596 (class 1255 OID 66989)
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
-- TOC entry 504 (class 1255 OID 67655)
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
-- TOC entry 487 (class 1255 OID 67654)
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
-- TOC entry 561 (class 1255 OID 62928)
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
-- TOC entry 496 (class 1255 OID 57370)
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
-- TOC entry 563 (class 1255 OID 57369)
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
-- TOC entry 692 (class 1255 OID 67214)
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
-- TOC entry 765 (class 1255 OID 63280)
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
-- TOC entry 670 (class 1255 OID 57018)
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
-- TOC entry 498 (class 1255 OID 89174)
-- Name: recalc_order_totals(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.recalc_order_totals(p_order_id uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_subtotal   numeric := 0;
  v_line_disc  numeric := 0;
  v_tax        numeric := 0;
  v_ship       numeric := 0;
  v_ord_disc   numeric := 0;
BEGIN
  -- read header numbers (may be 0)
  SELECT shipping_cost, discount_amount
    INTO v_ship, v_ord_disc
  FROM public.orders
  WHERE id = p_order_id;

  -- compute from items
  WITH li AS (
    SELECT
      (oi.quantity::numeric * oi.unit_price)                                   AS line_subtotal,
      (oi.quantity::numeric * oi.unit_price) * COALESCE(oi.discount_rate,0)    AS line_discount,
      ((oi.quantity::numeric * oi.unit_price)
        - ((oi.quantity::numeric * oi.unit_price) * COALESCE(oi.discount_rate,0))) * COALESCE(oi.tax_rate,0) AS line_tax
    FROM public.order_items oi
    WHERE oi.order_id = p_order_id
  )
  SELECT
    COALESCE(SUM(line_subtotal),0),
    COALESCE(SUM(line_discount),0),
    COALESCE(SUM(line_tax),0)
  INTO v_subtotal, v_line_disc, v_tax
  FROM li;

  -- round to 2dp for money
  v_subtotal := round(v_subtotal, 2);
  v_line_disc := round(v_line_disc, 2);
  v_tax := round(v_tax, 2);
  v_ship := round(COALESCE(v_ship,0), 2);
  v_ord_disc := round(COALESCE(v_ord_disc,0), 2);

  UPDATE public.orders
  SET
    subtotal        = v_subtotal,
    tax_amount      = v_tax,
    discount_amount = v_ord_disc,                          -- keep whatever header set
    shipping_cost   = v_ship,                              -- keep whatever header set
    total           = round(v_subtotal - v_line_disc - v_ord_disc + v_tax + v_ship, 2),
    updated_at      = now()
  WHERE id = p_order_id;
END
$$;


--
-- TOC entry 721 (class 1255 OID 89175)
-- Name: recalc_order_totals_details(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.recalc_order_totals_details(p_order_id uuid) RETURNS TABLE(order_id uuid, subtotal numeric, line_discount_amount numeric, order_discount_amount numeric, tax_amount numeric, shipping_cost numeric, total numeric)
    LANGUAGE sql
    AS $$
WITH lines AS (
  SELECT
    round(COALESCE(SUM((oi.quantity::numeric * oi.unit_price) * COALESCE(oi.discount_rate,0)),0), 2) AS line_discount_amount
  FROM public.order_items oi
  WHERE oi.order_id = p_order_id
)
SELECT
  o.id,
  o.subtotal,
  l.line_discount_amount,
  o.discount_amount,
  o.tax_amount,
  o.shipping_cost,
  o.total
FROM public.orders o
CROSS JOIN lines l
WHERE o.id = p_order_id
$$;


--
-- TOC entry 584 (class 1255 OID 89036)
-- Name: recalc_order_totals_void(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.recalc_order_totals_void(p_order_id uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM public.recalc_order_totals(p_order_id);
END$$;


--
-- TOC entry 467 (class 1255 OID 88751)
-- Name: receive_shipment(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.receive_shipment(p_shipment_id uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_shp record;
  r_case record;
  r_uni  record;
  v_dest public.location_kind;
BEGIN
  SELECT * INTO v_shp FROM public.shipments WHERE id = p_shipment_id;
  IF NOT FOUND THEN RAISE EXCEPTION 'Shipment not found'; END IF;
  IF v_shp.status <> 'shipped' THEN RAISE EXCEPTION 'Only SHIPPED shipments can be received'; END IF;

  v_dest := CASE WHEN v_shp.type='mfr_to_wh' THEN 'warehouse' ELSE 'distributor' END;

  FOR r_case IN
    SELECT c.* FROM public.cases c
    JOIN public.shipment_cases sc ON sc.case_id = c.id
    WHERE sc.shipment_id = v_shp.id
  LOOP
    INSERT INTO public.movement_events (level, case_id, shipment_id, action, from_kind, to_kind, actor_user_id)
    VALUES ('case', r_case.id, v_shp.id, 'receive', r_case.location_kind, v_dest, auth.uid());

    UPDATE public.cases
    SET location_kind = v_dest, in_transit = false, updated_at = now()
    WHERE id = r_case.id;

    INSERT INTO public.movement_events (level, unique_id, shipment_id, action, from_kind, to_kind, actor_user_id)
    SELECT 'unique', u.id, v_shp.id, 'receive', u.location_kind, v_dest, auth.uid()
    FROM public.unique_codes u
    WHERE u.case_id = r_case.id;

    UPDATE public.unique_codes
    SET location_kind = v_dest, in_transit = false, updated_at = now()
    WHERE case_id = r_case.id;
  END LOOP;

  FOR r_uni IN
    SELECT u.* FROM public.unique_codes u
    JOIN public.shipment_uniques su ON su.unique_id = u.id
    WHERE su.shipment_id = v_shp.id
  LOOP
    INSERT INTO public.movement_events (level, unique_id, shipment_id, action, from_kind, to_kind, actor_user_id)
    VALUES ('unique', r_uni.id, v_shp.id, 'receive', r_uni.location_kind, v_dest, auth.uid());

    UPDATE public.unique_codes
    SET location_kind = v_dest, in_transit = false, updated_at = now()
    WHERE id = r_uni.id;
  END LOOP;

  UPDATE public.shipments SET status='received', updated_at=now() WHERE id=v_shp.id;
END
$$;


--
-- TOC entry 569 (class 1255 OID 50630)
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
-- TOC entry 545 (class 1255 OID 70853)
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
-- TOC entry 669 (class 1255 OID 67551)
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
-- TOC entry 683 (class 1255 OID 50213)
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
-- TOC entry 4911 (class 0 OID 0)
-- Dependencies: 683
-- Name: FUNCTION reject_product(product_id_param uuid, reason_param text, comment_param text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.reject_product(product_id_param uuid, reason_param text, comment_param text) IS 'Reject product with reason (HQ admin only)';


--
-- TOC entry 586 (class 1255 OID 89198)
-- Name: release_stock(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.release_stock(p_order_id uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  RAISE EXCEPTION
    'DEPRECATED: release_stock(order_id) is removed. Use shipments workflow (add_case_to_shipment/add_unique_to_shipment, ship_shipment, receive_shipment) and movement_events.';
END
$$;


--
-- TOC entry 602 (class 1255 OID 57673)
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
-- TOC entry 594 (class 1255 OID 49602)
-- Name: reserve_sku(public.product_category_type); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.reserve_sku(p_product_category public.product_category_type) RETURNS text
    LANGUAGE sql SECURITY DEFINER
    AS $$
  select generate_sku(p_product_category);
$$;


--
-- TOC entry 560 (class 1255 OID 52165)
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
-- TOC entry 701 (class 1255 OID 65754)
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
-- TOC entry 708 (class 1255 OID 88504)
-- Name: set_case_rfid(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.set_case_rfid(p_case_code text, p_rfid_uid text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_case_id uuid;
BEGIN
  IF p_rfid_uid IS NULL OR length(trim(p_rfid_uid)) = 0 THEN
    RAISE EXCEPTION 'RFID UID cannot be empty';
  END IF;

  SELECT id INTO v_case_id FROM public.cases WHERE code = p_case_code;
  IF v_case_id IS NULL THEN
    RAISE EXCEPTION 'Case with code % not found', p_case_code;
  END IF;

  UPDATE public.cases
  SET rfid_uid = p_rfid_uid, updated_at = now()
  WHERE id = v_case_id;
END
$$;


--
-- TOC entry 497 (class 1255 OID 88158)
-- Name: set_created_by(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.set_created_by() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_uid uuid;
BEGIN
  SELECT auth.uid() INTO v_uid;
  IF v_uid IS NOT NULL THEN
    NEW.created_by := v_uid;
  END IF;
  RETURN NEW;
END;
$$;


--
-- TOC entry 715 (class 1255 OID 48362)
-- Name: set_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.set_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at := now();
  RETURN NEW;
END
$$;


--
-- TOC entry 675 (class 1255 OID 88157)
-- Name: set_updated_by(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.set_updated_by() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_uid uuid;
BEGIN
  SELECT auth.uid() INTO v_uid;           -- Supabase: current JWT user id (uuid) or NULL
  IF v_uid IS NOT NULL THEN
    NEW.updated_by := v_uid;
  END IF;
  RETURN NEW;
END;
$$;


--
-- TOC entry 526 (class 1255 OID 88750)
-- Name: ship_shipment(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.ship_shipment(p_shipment_id uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_shp record;
  r_case record;
  r_uni  record;
BEGIN
  SELECT * INTO v_shp FROM public.shipments WHERE id = p_shipment_id;
  IF NOT FOUND THEN RAISE EXCEPTION 'Shipment not found'; END IF;
  IF v_shp.status <> 'draft' THEN RAISE EXCEPTION 'Only DRAFT shipments can be shipped'; END IF;

  IF NOT EXISTS (SELECT 1 FROM public.shipment_cases WHERE shipment_id = v_shp.id)
     AND NOT EXISTS (SELECT 1 FROM public.shipment_uniques WHERE shipment_id = v_shp.id)
  THEN
    RAISE EXCEPTION 'Shipment has no lines';
  END IF;

  FOR r_case IN
    SELECT c.* FROM public.cases c
    JOIN public.shipment_cases sc ON sc.case_id = c.id
    WHERE sc.shipment_id = v_shp.id
  LOOP
    IF r_case.in_transit THEN RAISE EXCEPTION 'Case % already in transit', r_case.code; END IF;

    UPDATE public.cases SET in_transit = true WHERE id = r_case.id;

    INSERT INTO public.movement_events (level, case_id, shipment_id, action, from_kind, to_kind, actor_user_id)
    VALUES ('case', r_case.id, v_shp.id, 'ship',
            r_case.location_kind,
            CASE WHEN v_shp.type='mfr_to_wh' THEN 'warehouse' ELSE 'distributor' END,
            auth.uid());

    UPDATE public.unique_codes SET in_transit = true WHERE case_id = r_case.id;

    INSERT INTO public.movement_events (level, unique_id, shipment_id, action, from_kind, to_kind, actor_user_id)
    SELECT 'unique', u.id, v_shp.id, 'ship', u.location_kind,
           CASE WHEN v_shp.type='mfr_to_wh' THEN 'warehouse' ELSE 'distributor' END,
           auth.uid()
    FROM public.unique_codes u
    WHERE u.case_id = r_case.id;
  END LOOP;

  FOR r_uni IN
    SELECT u.* FROM public.unique_codes u
    JOIN public.shipment_uniques su ON su.unique_id = u.id
    WHERE su.shipment_id = v_shp.id
  LOOP
    IF r_uni.in_transit THEN RAISE EXCEPTION 'Unique % already in transit', r_uni.code; END IF;

    UPDATE public.unique_codes SET in_transit = true WHERE id = r_uni.id;

    INSERT INTO public.movement_events (level, unique_id, shipment_id, action, from_kind, to_kind, actor_user_id)
    VALUES ('unique', r_uni.id, v_shp.id, 'ship', r_uni.location_kind, 'distributor', auth.uid());
  END LOOP;

  UPDATE public.shipments SET status='shipped', updated_at=now() WHERE id=v_shp.id;
END
$$;


--
-- TOC entry 645 (class 1255 OID 89152)
-- Name: spend_shop_points(uuid, integer, text, jsonb); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.spend_shop_points(p_shop_id uuid, p_points integer, p_source text DEFAULT 'redeem'::text, p_meta jsonb DEFAULT '{}'::jsonb) RETURNS TABLE(new_balance bigint)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_bal bigint := 0;
  v_k1  int;
  v_k2  int;
BEGIN
  IF p_shop_id IS NULL OR p_points IS NULL OR p_points <= 0 THEN
    RAISE EXCEPTION 'shop_id and positive points are required';
  END IF;

  -- Per-shop advisory lock (prevents two spends racing)
  SELECT ('x' || substr(md5(p_shop_id::text),1,8))::bit(32)::int,
         ('x' || substr(md5(p_shop_id::text),9,8))::bit(32)::int
    INTO v_k1, v_k2;
  PERFORM pg_advisory_xact_lock(v_k1, v_k2);

  -- Current balance = earn (+) + adjust (+/-) - redeem
  SELECT COALESCE(SUM(
           CASE operation
             WHEN 'earn'   THEN points
             WHEN 'redeem' THEN -points
             WHEN 'adjust' THEN points
           END
         ), 0)
    INTO v_bal
  FROM public.shop_points_ledger
  WHERE shop_id = p_shop_id;

  IF v_bal < p_points THEN
    RAISE EXCEPTION 'insufficient points (have %, need %)', v_bal, p_points;
  END IF;

  INSERT INTO public.shop_points_ledger (shop_id, operation, points, source, meta, created_by)
  VALUES (p_shop_id, 'redeem', p_points, COALESCE(p_source,'redeem'), COALESCE(p_meta,'{}'::jsonb), auth.uid());

  -- Return fresh balance
  SELECT COALESCE(SUM(
           CASE operation
             WHEN 'earn'   THEN points
             WHEN 'redeem' THEN -points
             WHEN 'adjust' THEN points
           END
         ), 0)
    INTO v_bal
  FROM public.shop_points_ledger
  WHERE shop_id = p_shop_id;

  RETURN QUERY SELECT v_bal;
END
$$;


--
-- TOC entry 766 (class 1255 OID 57335)
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
-- TOC entry 532 (class 1255 OID 88843)
-- Name: submit_lucky_draw_participation(text, text, text, text, text, inet, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.submit_lucky_draw_participation(p_campaign_code text, p_unique_code text, p_name text, p_email text, p_phone text, p_ip inet DEFAULT NULL::inet, p_ua text DEFAULT NULL::text) RETURNS TABLE(campaign_id uuid, participant_id uuid, submitted_at timestamp with time zone)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_campaign   public.lucky_draw_campaigns%ROWTYPE;
  v_unique     public.unique_codes%ROWTYPE;
BEGIN
  -- find campaign
  SELECT * INTO v_campaign
  FROM public.lucky_draw_campaigns
  WHERE code = p_campaign_code;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Campaign % not found', p_campaign_code;
  END IF;

  -- status / validity
  IF v_campaign.status <> 'active' THEN
    RAISE EXCEPTION 'Campaign % is not active', p_campaign_code;
  END IF;
  IF v_campaign.valid_from IS NOT NULL AND now() < v_campaign.valid_from THEN
    RAISE EXCEPTION 'Campaign not started yet';
  END IF;
  IF v_campaign.valid_to IS NOT NULL AND now() > v_campaign.valid_to THEN
    RAISE EXCEPTION 'Campaign has ended';
  END IF;

  -- find unique code & eligibility
  SELECT * INTO v_unique
  FROM public.unique_codes
  WHERE code = p_unique_code;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Unique code not found';
  END IF;

  IF v_unique.lucky_draw_on IS NOT TRUE THEN
    RAISE EXCEPTION 'This code is not eligible for Lucky Draw';
  END IF;

  -- insert (unique per (campaign, unique))
  INSERT INTO public.lucky_draw_participants (campaign_id, unique_id, name, email, phone, ip_addr, user_agent)
  VALUES (v_campaign.id, v_unique.id, p_name, p_email, p_phone, p_ip, p_ua)
  ON CONFLICT (campaign_id, unique_id) DO NOTHING;

  RETURN QUERY
  SELECT v_campaign.id, ldp.id, ldp.submitted_at
  FROM public.lucky_draw_participants ldp
  WHERE ldp.campaign_id = v_campaign.id AND ldp.unique_id = v_unique.id;
END
$$;


--
-- TOC entry 579 (class 1255 OID 50211)
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
-- TOC entry 4912 (class 0 OID 0)
-- Dependencies: 579
-- Name: FUNCTION submit_product_for_approval(product_id_param uuid, comment_param text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.submit_product_for_approval(product_id_param uuid, comment_param text) IS 'Submit product for HQ admin approval';


--
-- TOC entry 565 (class 1255 OID 89302)
-- Name: tg_check_product_active_on_item(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.tg_check_product_active_on_item() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE v_active boolean;
BEGIN
  SELECT active INTO v_active
  FROM public.products
  WHERE id = NEW.product_id;

  IF v_active IS DISTINCT FROM TRUE THEN
    RAISE EXCEPTION 'Product % is not active', NEW.product_id;
  END IF;

  RETURN NEW;
END
$$;


--
-- TOC entry 758 (class 1255 OID 89304)
-- Name: tg_enforce_same_manufacturer(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.tg_enforce_same_manufacturer() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_order_mfr   uuid;
  v_product_mfr uuid;
BEGIN
  SELECT manufacturer_id INTO v_order_mfr
  FROM public.orders
  WHERE id = COALESCE(NEW.order_id, OLD.order_id);

  SELECT manufacturer_id INTO v_product_mfr
  FROM public.products
  WHERE id = COALESCE(NEW.product_id, OLD.product_id);

  IF v_order_mfr IS NULL THEN
    RAISE EXCEPTION 'Order % has no manufacturer; cannot add items', COALESCE(NEW.order_id, OLD.order_id);
  END IF;

  IF v_product_mfr IS DISTINCT FROM v_order_mfr THEN
    RAISE EXCEPTION 'Product manufacturer % does not match order manufacturer %',
      v_product_mfr, v_order_mfr;
  END IF;

  RETURN NEW;
END
$$;


--
-- TOC entry 507 (class 1255 OID 89423)
-- Name: tg_hq_info_singleton(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.tg_hq_info_singleton() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF TG_OP = 'INSERT' AND EXISTS (SELECT 1 FROM public.hq_info) THEN
    RAISE EXCEPTION 'Only one HQ info record is allowed';
  END IF;
  RETURN NEW;
END
$$;


--
-- TOC entry 613 (class 1255 OID 65710)
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
-- TOC entry 685 (class 1255 OID 89109)
-- Name: tg_recalc_from_items_del(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.tg_recalc_from_items_del() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE r record;
BEGIN
  FOR r IN
    SELECT DISTINCT order_id FROM old_rows WHERE order_id IS NOT NULL
  LOOP
    PERFORM public.recalc_order_totals(r.order_id);
  END LOOP;
  RETURN NULL;
END
$$;


--
-- TOC entry 661 (class 1255 OID 89105)
-- Name: tg_recalc_from_items_ins(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.tg_recalc_from_items_ins() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE r record;
BEGIN
  FOR r IN
    SELECT DISTINCT order_id FROM new_rows WHERE order_id IS NOT NULL
  LOOP
    PERFORM public.recalc_order_totals(r.order_id);
  END LOOP;
  RETURN NULL;
END
$$;


--
-- TOC entry 770 (class 1255 OID 89107)
-- Name: tg_recalc_from_items_upd(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.tg_recalc_from_items_upd() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  r record;
  v_changed boolean := false;
BEGIN
  SELECT EXISTS (
    SELECT 1
    FROM new_rows n
    JOIN old_rows o ON n.id = o.id
    WHERE n.quantity      IS DISTINCT FROM o.quantity
       OR n.unit_price    IS DISTINCT FROM o.unit_price
       OR n.discount_rate IS DISTINCT FROM o.discount_rate
       OR n.tax_rate      IS DISTINCT FROM o.tax_rate
  ) INTO v_changed;

  IF NOT v_changed THEN
    RETURN NULL;
  END IF;

  FOR r IN
    SELECT DISTINCT order_id
    FROM (
      SELECT order_id FROM new_rows
      UNION
      SELECT order_id FROM old_rows
    ) x
    WHERE order_id IS NOT NULL
  LOOP
    PERFORM public.recalc_order_totals(r.order_id);
  END LOOP;

  RETURN NULL;
END
$$;


--
-- TOC entry 521 (class 1255 OID 57019)
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
-- TOC entry 662 (class 1255 OID 52161)
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
-- TOC entry 624 (class 1255 OID 69535)
-- Name: tg_set_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.tg_set_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN NEW.updated_at = now(); RETURN NEW; END $$;


--
-- TOC entry 494 (class 1255 OID 59789)
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
-- TOC entry 511 (class 1255 OID 46841)
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
-- TOC entry 628 (class 1255 OID 82502)
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
-- TOC entry 547 (class 1255 OID 49598)
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
-- TOC entry 515 (class 1255 OID 50019)
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


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 454 (class 1259 OID 89412)
-- Name: hq_info; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hq_info (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    customer_name text NOT NULL,
    customer_email text,
    customer_contact_no text,
    delivery_address text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 520 (class 1255 OID 89447)
-- Name: upsert_hq_info(text, text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.upsert_hq_info(p_customer_name text, p_customer_email text, p_customer_contact_no text, p_delivery_address text) RETURNS public.hq_info
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_id uuid;
BEGIN
  -- Find existing singleton row (if any)
  SELECT id INTO v_id FROM public.hq_info LIMIT 1;

  IF v_id IS NULL THEN
    -- Insert first/only row
    INSERT INTO public.hq_info (
      customer_name, customer_email, customer_contact_no, delivery_address
    )
    VALUES (
      COALESCE(p_customer_name, ''),  -- enforce non-null name
      p_customer_email,
      p_customer_contact_no,
      p_delivery_address
    )
    RETURNING id INTO v_id;
  ELSE
    -- Update existing row
    UPDATE public.hq_info
    SET
      customer_name        = COALESCE(p_customer_name, customer_name),
      customer_email       = p_customer_email,
      customer_contact_no  = p_customer_contact_no,
      delivery_address     = p_delivery_address
    WHERE id = v_id;
  END IF;

  -- Return the resulting row
  RETURN (SELECT * FROM public.hq_info WHERE id = v_id);
END
$$;


--
-- TOC entry 4913 (class 0 OID 0)
-- Dependencies: 520
-- Name: FUNCTION upsert_hq_info(p_customer_name text, p_customer_email text, p_customer_contact_no text, p_delivery_address text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.upsert_hq_info(p_customer_name text, p_customer_email text, p_customer_contact_no text, p_delivery_address text) IS 'Insert or update the singleton HQ info row and return it.';


--
-- TOC entry 629 (class 1255 OID 57333)
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
-- TOC entry 658 (class 1255 OID 57375)
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
-- TOC entry 671 (class 1255 OID 63564)
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
-- TOC entry 600 (class 1255 OID 63834)
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
-- TOC entry 754 (class 1255 OID 48009)
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
-- TOC entry 583 (class 1255 OID 17119)
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
-- TOC entry 626 (class 1255 OID 82185)
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
-- TOC entry 472 (class 1255 OID 48010)
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
-- TOC entry 512 (class 1255 OID 48013)
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
-- TOC entry 684 (class 1255 OID 48028)
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
-- TOC entry 638 (class 1255 OID 17044)
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
-- TOC entry 535 (class 1255 OID 17043)
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
-- TOC entry 557 (class 1255 OID 17039)
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
-- TOC entry 650 (class 1255 OID 47991)
-- Name: get_level(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_level(name text) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
SELECT array_length(string_to_array("name", '/'), 1);
$$;


--
-- TOC entry 696 (class 1255 OID 48007)
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
-- TOC entry 544 (class 1255 OID 48008)
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
-- TOC entry 457 (class 1255 OID 48026)
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
-- TOC entry 634 (class 1255 OID 17162)
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
-- TOC entry 517 (class 1255 OID 17123)
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
-- TOC entry 480 (class 1255 OID 82184)
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
-- TOC entry 541 (class 1255 OID 82186)
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
-- TOC entry 751 (class 1255 OID 48012)
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
-- TOC entry 668 (class 1255 OID 82187)
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
-- TOC entry 737 (class 1255 OID 82192)
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
-- TOC entry 632 (class 1255 OID 48027)
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
-- TOC entry 718 (class 1255 OID 17179)
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
-- TOC entry 534 (class 1255 OID 82188)
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
-- TOC entry 712 (class 1255 OID 48011)
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
-- TOC entry 769 (class 1255 OID 17101)
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
-- TOC entry 590 (class 1255 OID 48024)
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
-- TOC entry 455 (class 1255 OID 48023)
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
-- TOC entry 591 (class 1255 OID 82183)
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
-- TOC entry 527 (class 1255 OID 17102)
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
-- TOC entry 425 (class 1259 OID 85967)
-- Name: audit_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.audit_log (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    operation text NOT NULL,
    entity_type text NOT NULL,
    entity_id uuid,
    details jsonb,
    performed_by uuid,
    performed_at timestamp with time zone DEFAULT now(),
    ip_address inet,
    user_agent text
);


--
-- TOC entry 4914 (class 0 OID 0)
-- Dependencies: 425
-- Name: TABLE audit_log; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.audit_log IS 'System audit log for tracking all data operations and system events';


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


--
-- TOC entry 401 (class 1259 OID 82763)
-- Name: brands; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.brands (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    category_id uuid
);


--
-- TOC entry 433 (class 1259 OID 88393)
-- Name: cases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cases (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    po_item_id uuid NOT NULL,
    code text NOT NULL,
    rfid_uid text,
    rfid_required boolean DEFAULT false NOT NULL,
    units_per_case integer NOT NULL,
    status public.case_status DEFAULT 'new'::public.case_status NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    location_kind public.location_kind DEFAULT 'manufacturer'::public.location_kind NOT NULL,
    in_transit boolean DEFAULT false NOT NULL,
    CONSTRAINT cases_units_per_case_check CHECK ((units_per_case = ANY (ARRAY[100, 200])))
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
    active boolean DEFAULT true NOT NULL,
    category_id uuid,
    contact_person text,
    phone text,
    email text,
    whatsapp text,
    address_line1 text,
    address_line2 text,
    city text,
    state_region text,
    postal_code text,
    country_code character(2),
    website_url text,
    notes text,
    logo_url text
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
-- TOC entry 442 (class 1259 OID 88789)
-- Name: lucky_draw_campaigns; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lucky_draw_campaigns (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    code text,
    name text NOT NULL,
    description text,
    status public.ld_status DEFAULT 'draft'::public.ld_status NOT NULL,
    valid_from timestamp with time zone,
    valid_to timestamp with time zone,
    created_by uuid,
    updated_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 443 (class 1259 OID 88803)
-- Name: lucky_draw_participants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lucky_draw_participants (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    campaign_id uuid NOT NULL,
    unique_id uuid NOT NULL,
    name text NOT NULL,
    email text,
    phone text,
    submitted_at timestamp with time zone DEFAULT now() NOT NULL,
    ip_addr inet,
    user_agent text
);


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
    category_id uuid,
    CONSTRAINT manufacturers_country_len_chk CHECK (((country_code IS NULL) OR (length(country_code) = 2))),
    CONSTRAINT manufacturers_currency_len_chk CHECK (((currency_code IS NULL) OR (length(currency_code) = 3))),
    CONSTRAINT manufacturers_lang_len_chk CHECK (((language_code IS NULL) OR (length(language_code) = 2)))
);


--
-- TOC entry 4915 (class 0 OID 0)
-- Dependencies: 404
-- Name: COLUMN manufacturers.legal_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.manufacturers.legal_name IS 'Registered legal name';


--
-- TOC entry 4916 (class 0 OID 0)
-- Dependencies: 404
-- Name: COLUMN manufacturers.brand_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.manufacturers.brand_name IS 'Marketing/brand display name';


--
-- TOC entry 4917 (class 0 OID 0)
-- Dependencies: 404
-- Name: COLUMN manufacturers.registration_number; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.manufacturers.registration_number IS 'Company/business registration number';


--
-- TOC entry 4918 (class 0 OID 0)
-- Dependencies: 404
-- Name: COLUMN manufacturers.tax_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.manufacturers.tax_id IS 'Tax/VAT/GST identifier';


--
-- TOC entry 4919 (class 0 OID 0)
-- Dependencies: 404
-- Name: COLUMN manufacturers.country_code; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.manufacturers.country_code IS 'ISO-3166-1 alpha-2';


--
-- TOC entry 4920 (class 0 OID 0)
-- Dependencies: 404
-- Name: COLUMN manufacturers.language_code; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.manufacturers.language_code IS 'ISO-639-1';


--
-- TOC entry 4921 (class 0 OID 0)
-- Dependencies: 404
-- Name: COLUMN manufacturers.currency_code; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.manufacturers.currency_code IS 'ISO-4217';


--
-- TOC entry 4922 (class 0 OID 0)
-- Dependencies: 404
-- Name: COLUMN manufacturers.support_email; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.manufacturers.support_email IS 'Support contact email';


--
-- TOC entry 4923 (class 0 OID 0)
-- Dependencies: 404
-- Name: COLUMN manufacturers.support_phone; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.manufacturers.support_phone IS 'Support phone';


--
-- TOC entry 4924 (class 0 OID 0)
-- Dependencies: 404
-- Name: COLUMN manufacturers.whatsapp; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.manufacturers.whatsapp IS 'WhatsApp contact';


--
-- TOC entry 4925 (class 0 OID 0)
-- Dependencies: 404
-- Name: COLUMN manufacturers.address_line1; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.manufacturers.address_line1 IS 'Address line 1';


--
-- TOC entry 4926 (class 0 OID 0)
-- Dependencies: 404
-- Name: COLUMN manufacturers.address_line2; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.manufacturers.address_line2 IS 'Address line 2';


--
-- TOC entry 4927 (class 0 OID 0)
-- Dependencies: 404
-- Name: COLUMN manufacturers.state_region; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.manufacturers.state_region IS 'State/Region';


--
-- TOC entry 4928 (class 0 OID 0)
-- Dependencies: 404
-- Name: COLUMN manufacturers.social_links; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.manufacturers.social_links IS 'JSON of social links';


--
-- TOC entry 4929 (class 0 OID 0)
-- Dependencies: 404
-- Name: COLUMN manufacturers.certifications; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.manufacturers.certifications IS 'JSON array of certification objects';


--
-- TOC entry 4930 (class 0 OID 0)
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
-- TOC entry 441 (class 1259 OID 88703)
-- Name: movement_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.movement_events (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    level text NOT NULL,
    case_id uuid,
    unique_id uuid,
    shipment_id uuid,
    action text NOT NULL,
    from_kind public.location_kind,
    to_kind public.location_kind,
    actor_user_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    meta jsonb,
    CONSTRAINT movement_events_action_check CHECK ((action = ANY (ARRAY['ship'::text, 'receive'::text, 'remove'::text, 'cancel'::text]))),
    CONSTRAINT movement_events_level_check CHECK ((level = ANY (ARRAY['case'::text, 'unique'::text])))
);


--
-- TOC entry 451 (class 1259 OID 89227)
-- Name: notification_outbox; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notification_outbox (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    event_type text NOT NULL,
    entity_table text NOT NULL,
    entity_id uuid NOT NULL,
    payload jsonb DEFAULT '{}'::jsonb NOT NULL,
    audience_hint jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    processed_at timestamp with time zone,
    attempts integer DEFAULT 0 NOT NULL,
    last_error text
);


--
-- TOC entry 453 (class 1259 OID 89248)
-- Name: notification_preferences_user; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notification_preferences_user (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    channel public.notification_channel NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    overrides jsonb
);


--
-- TOC entry 452 (class 1259 OID 89239)
-- Name: notification_settings_org; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notification_settings_org (
    org_id uuid NOT NULL,
    email_enabled boolean DEFAULT false NOT NULL,
    sms_enabled boolean DEFAULT false NOT NULL,
    whatsapp_enabled boolean DEFAULT false NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_by uuid
);


--
-- TOC entry 427 (class 1259 OID 88204)
-- Name: order_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    order_id uuid NOT NULL,
    product_id uuid NOT NULL,
    variant_id uuid,
    quantity_units integer NOT NULL,
    units_per_case integer NOT NULL,
    buffer_pct numeric(5,2) DEFAULT 0.10 NOT NULL,
    lucky_draw_on boolean DEFAULT false NOT NULL,
    redeem_on boolean DEFAULT false NOT NULL,
    rfid_enabled boolean DEFAULT false NOT NULL,
    points_per_unit_override integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    quantity integer NOT NULL,
    unit_price numeric(14,4) DEFAULT 0 NOT NULL,
    discount_rate numeric(6,4) DEFAULT 0 NOT NULL,
    tax_rate numeric(6,4) DEFAULT 0 NOT NULL,
    CONSTRAINT chk_order_items_discount_rate CHECK (((discount_rate >= (0)::numeric) AND (discount_rate <= (1)::numeric))),
    CONSTRAINT chk_order_items_quantity_pos CHECK ((quantity > 0)),
    CONSTRAINT chk_order_items_tax_rate CHECK (((tax_rate >= (0)::numeric) AND (tax_rate <= (1)::numeric))),
    CONSTRAINT chk_order_items_unit_price_nonneg CHECK ((unit_price >= (0)::numeric)),
    CONSTRAINT order_items_buffer_pct_check CHECK (((buffer_pct >= (0)::numeric) AND (buffer_pct <= (1)::numeric))),
    CONSTRAINT order_items_quantity_units_check CHECK ((quantity_units > 0)),
    CONSTRAINT order_items_units_per_case_check CHECK ((units_per_case = ANY (ARRAY[100, 200])))
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
-- TOC entry 426 (class 1259 OID 88191)
-- Name: orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.orders (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    order_no text,
    status public.order_status DEFAULT 'draft'::public.order_status NOT NULL,
    manufacturer_id uuid NOT NULL,
    created_by uuid,
    submitted_by uuid,
    approved_by uuid,
    approved_at timestamp with time zone,
    notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    subtotal numeric(14,2) DEFAULT 0 NOT NULL,
    discount_amount numeric(14,2) DEFAULT 0 NOT NULL,
    tax_amount numeric(14,2) DEFAULT 0 NOT NULL,
    shipping_cost numeric(14,2) DEFAULT 0 NOT NULL,
    total numeric(14,2) DEFAULT 0 NOT NULL,
    customer_name text,
    customer_email text,
    customer_contact_no text,
    delivery_address text,
    CONSTRAINT chk_orders_customer_email_at CHECK (((customer_email IS NULL) OR (POSITION(('@'::text) IN (customer_email)) > 1))),
    CONSTRAINT chk_orders_discount_nonneg CHECK ((discount_amount >= (0)::numeric)),
    CONSTRAINT chk_orders_shipping_nonneg CHECK ((shipping_cost >= (0)::numeric)),
    CONSTRAINT chk_orders_subtotal_nonneg CHECK ((subtotal >= (0)::numeric)),
    CONSTRAINT chk_orders_tax_nonneg CHECK ((tax_amount >= (0)::numeric))
);


--
-- TOC entry 437 (class 1259 OID 88490)
-- Name: pack_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pack_events (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    po_id uuid,
    po_item_id uuid,
    case_id uuid,
    unique_id uuid,
    event_type text NOT NULL,
    source text DEFAULT 'scan'::text NOT NULL,
    actor_user_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    meta jsonb,
    CONSTRAINT pack_events_event_type_check CHECK ((event_type = ANY (ARRAY['assign'::text, 'case_packed'::text, 'unassign'::text])))
);


--
-- TOC entry 430 (class 1259 OID 88304)
-- Name: po_status_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.po_status_history (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    po_id uuid NOT NULL,
    status public.po_status NOT NULL,
    note text,
    changed_by uuid,
    changed_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 447 (class 1259 OID 88921)
-- Name: points_config; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.points_config (
    id boolean DEFAULT true NOT NULL,
    default_points_per_unit integer DEFAULT 1 NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_by uuid
);


--
-- TOC entry 448 (class 1259 OID 88929)
-- Name: points_rules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.points_rules (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    variant_id uuid,
    points_per_unit integer NOT NULL,
    valid_from timestamp with time zone,
    valid_to timestamp with time zone,
    active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT points_rules_points_per_unit_check CHECK ((points_per_unit >= 0))
);


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
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    sku text,
    price numeric(10,2),
    status text DEFAULT 'active'::text,
    image_url text,
    CONSTRAINT products_status_check CHECK ((status = ANY (ARRAY['active'::text, 'inactive'::text])))
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
-- TOC entry 429 (class 1259 OID 88289)
-- Name: purchase_order_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.purchase_order_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    po_id uuid NOT NULL,
    order_item_id uuid NOT NULL,
    product_id uuid NOT NULL,
    variant_id uuid,
    quantity_units integer NOT NULL,
    units_per_case integer NOT NULL,
    buffer_pct numeric(5,2) NOT NULL,
    lucky_draw_on boolean DEFAULT false NOT NULL,
    redeem_on boolean DEFAULT false NOT NULL,
    rfid_enabled boolean DEFAULT false NOT NULL,
    points_per_unit_override integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT purchase_order_items_buffer_pct_check CHECK (((buffer_pct >= (0)::numeric) AND (buffer_pct <= (1)::numeric))),
    CONSTRAINT purchase_order_items_quantity_units_check CHECK ((quantity_units > 0)),
    CONSTRAINT purchase_order_items_units_per_case_check CHECK ((units_per_case = ANY (ARRAY[100, 200])))
);


--
-- TOC entry 428 (class 1259 OID 88274)
-- Name: purchase_orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.purchase_orders (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    po_no text,
    order_id uuid NOT NULL,
    manufacturer_id uuid NOT NULL,
    status public.po_status DEFAULT 'draft'::public.po_status NOT NULL,
    created_by uuid,
    updated_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 444 (class 1259 OID 88814)
-- Name: redeem_claims; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.redeem_claims (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    unique_id uuid NOT NULL,
    claimant_name text,
    claimant_phone text,
    claimed_at timestamp with time zone DEFAULT now() NOT NULL,
    status public.redeem_status DEFAULT 'pending'::public.redeem_status NOT NULL,
    fulfilled_by_shop_id uuid,
    fulfilled_at timestamp with time zone
);


--
-- TOC entry 439 (class 1259 OID 88683)
-- Name: shipment_cases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shipment_cases (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    shipment_id uuid NOT NULL,
    case_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 440 (class 1259 OID 88693)
-- Name: shipment_uniques; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shipment_uniques (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    shipment_id uuid NOT NULL,
    unique_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 438 (class 1259 OID 88669)
-- Name: shipments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shipments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    shipment_no text,
    type public.shipment_type NOT NULL,
    status public.shipment_status DEFAULT 'draft'::public.shipment_status NOT NULL,
    po_id uuid,
    from_label text,
    to_label text,
    to_distributor_id uuid,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


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
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    operation public.points_op NOT NULL,
    points integer NOT NULL,
    source text DEFAULT 'shop_scan'::text NOT NULL,
    unique_id uuid,
    po_item_id uuid,
    product_id uuid,
    variant_id uuid,
    created_by uuid,
    meta jsonb,
    CONSTRAINT chk_points_nonzero CHECK ((points <> 0))
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
-- TOC entry 4931 (class 0 OID 0)
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
    country_code character(2),
    category_id uuid
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
-- TOC entry 434 (class 1259 OID 88411)
-- Name: unique_codes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.unique_codes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    po_item_id uuid NOT NULL,
    case_id uuid,
    code text NOT NULL,
    product_id uuid NOT NULL,
    variant_id uuid,
    lucky_draw_on boolean DEFAULT false NOT NULL,
    redeem_on boolean DEFAULT false NOT NULL,
    points_eligible boolean DEFAULT true NOT NULL,
    owned_by_shop_id uuid,
    claimed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    location_kind public.location_kind DEFAULT 'manufacturer'::public.location_kind NOT NULL,
    in_transit boolean DEFAULT false NOT NULL,
    points_earned_at timestamp with time zone
);


--
-- TOC entry 419 (class 1259 OID 85889)
-- Name: users_profile; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.users_profile AS
 SELECT p.id AS user_id,
    p.id,
    p.role_code,
    p.full_name,
    p.avatar_url,
    p.created_at,
    p.updated_at,
    p.role,
    p.distributor_id,
    p.shop_id,
    u.email,
    u.created_at AS user_created_at,
    u.updated_at AS user_updated_at
   FROM (public.profiles p
     JOIN auth.users u ON ((p.id = u.id)));


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
-- TOC entry 435 (class 1259 OID 88461)
-- Name: v_export_cases; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_export_cases AS
 SELECT code AS case_code,
    rfid_uid,
    po_item_id AS po_line,
    units_per_case
   FROM public.cases c
  ORDER BY po_item_id, code;


--
-- TOC entry 436 (class 1259 OID 88465)
-- Name: v_export_uniques; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_export_uniques AS
 SELECT code AS unique_code,
    po_item_id AS po_line
   FROM public.unique_codes u
  ORDER BY po_item_id, code;


--
-- TOC entry 445 (class 1259 OID 88846)
-- Name: v_lucky_draw_participants; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_lucky_draw_participants AS
 SELECT ldp.id AS participant_id,
    ldp.submitted_at,
    ldp.name AS participant_name,
    ldp.phone AS contact_no,
    ldp.email,
    uc.code AS unique_code,
    poi.po_id,
    po.po_no,
    ldp.campaign_id,
    ldc.code AS campaign_code,
    ldc.name AS campaign_name,
    uc.product_id,
    p.name AS product_name,
    uc.variant_id
   FROM (((((public.lucky_draw_participants ldp
     JOIN public.unique_codes uc ON ((uc.id = ldp.unique_id)))
     LEFT JOIN public.purchase_order_items poi ON ((poi.id = uc.po_item_id)))
     LEFT JOIN public.purchase_orders po ON ((po.id = poi.po_id)))
     LEFT JOIN public.lucky_draw_campaigns ldc ON ((ldc.id = ldp.campaign_id)))
     LEFT JOIN public.products p ON ((p.id = uc.product_id)))
  ORDER BY ldp.submitted_at DESC;


--
-- TOC entry 431 (class 1259 OID 88354)
-- Name: v_po_qr_plan_lines; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_po_qr_plan_lines AS
 SELECT id AS po_item_id,
    po_id,
    order_item_id,
    product_id,
    variant_id,
    quantity_units,
    units_per_case,
    buffer_pct,
    (ceil(((quantity_units)::numeric / (units_per_case)::numeric)))::integer AS planned_case_count,
    (((quantity_units)::numeric + ceil(((quantity_units)::numeric * buffer_pct))))::integer AS planned_unique_count,
    lucky_draw_on,
    redeem_on,
    rfid_enabled,
    points_per_unit_override
   FROM public.purchase_order_items poi;


--
-- TOC entry 432 (class 1259 OID 88358)
-- Name: v_po_qr_plan_totals; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_po_qr_plan_totals AS
 SELECT po.id AS po_id,
    (sum(ceil(((poi.quantity_units)::numeric / (poi.units_per_case)::numeric))))::integer AS total_planned_cases,
    (sum(((poi.quantity_units)::numeric + ceil(((poi.quantity_units)::numeric * poi.buffer_pct)))))::integer AS total_planned_uniques
   FROM (public.purchase_orders po
     JOIN public.purchase_order_items poi ON ((poi.po_id = po.id)))
  GROUP BY po.id;


--
-- TOC entry 446 (class 1259 OID 88851)
-- Name: v_redeem_claims; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_redeem_claims AS
 SELECT rc.id AS claim_id,
    rc.claimed_at,
    rc.status,
    rc.claimant_name,
    rc.claimant_phone,
    uc.code AS unique_code,
    poi.po_id,
    po.po_no,
    uc.product_id,
    p.name AS product_name,
    rc.fulfilled_by_shop_id,
    rc.fulfilled_at
   FROM ((((public.redeem_claims rc
     JOIN public.unique_codes uc ON ((uc.id = rc.unique_id)))
     LEFT JOIN public.purchase_order_items poi ON ((poi.id = uc.po_item_id)))
     LEFT JOIN public.purchase_orders po ON ((po.id = poi.po_id)))
     LEFT JOIN public.products p ON ((p.id = uc.product_id)))
  ORDER BY rc.claimed_at DESC;


--
-- TOC entry 449 (class 1259 OID 88975)
-- Name: v_shop_points_balances; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_shop_points_balances AS
 SELECT shop_id,
    COALESCE(sum(points), (0)::bigint) AS balance
   FROM public.shop_points_ledger
  GROUP BY shop_id;


--
-- TOC entry 450 (class 1259 OID 88979)
-- Name: v_shop_points_ledger; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_shop_points_ledger AS
 SELECT spl.id AS ledger_id,
    spl.created_at,
    spl.shop_id,
    spl.operation,
    spl.points,
    spl.source,
    uc.code AS unique_code,
    uc.product_id,
    p.name AS product_name,
    uc.variant_id,
    spl.po_item_id,
    poi.po_id,
    po.po_no
   FROM ((((public.shop_points_ledger spl
     LEFT JOIN public.unique_codes uc ON ((uc.id = spl.unique_id)))
     LEFT JOIN public.products p ON ((p.id = uc.product_id)))
     LEFT JOIN public.purchase_order_items poi ON ((poi.id = spl.po_item_id)))
     LEFT JOIN public.purchase_orders po ON ((po.id = poi.po_id)))
  ORDER BY spl.created_at DESC;


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
-- TOC entry 4932 (class 0 OID 0)
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
-- TOC entry 4933 (class 0 OID 0)
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
-- TOC entry 4259 (class 2604 OID 84314)
-- Name: shop_points_ledger id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shop_points_ledger ALTER COLUMN id SET DEFAULT nextval('public.shop_points_ledger_id_seq'::regclass);


--
-- TOC entry 4472 (class 2606 OID 85975)
-- Name: audit_log audit_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_pkey PRIMARY KEY (id);


--
-- TOC entry 4411 (class 2606 OID 82775)
-- Name: brands brands_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.brands
    ADD CONSTRAINT brands_name_key UNIQUE (name);


--
-- TOC entry 4413 (class 2606 OID 82773)
-- Name: brands brands_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.brands
    ADD CONSTRAINT brands_pkey PRIMARY KEY (id);


--
-- TOC entry 4503 (class 2606 OID 88407)
-- Name: cases cases_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cases
    ADD CONSTRAINT cases_code_key UNIQUE (code);


--
-- TOC entry 4505 (class 2606 OID 88405)
-- Name: cases cases_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cases
    ADD CONSTRAINT cases_pkey PRIMARY KEY (id);


--
-- TOC entry 4507 (class 2606 OID 88409)
-- Name: cases cases_rfid_uid_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cases
    ADD CONSTRAINT cases_rfid_uid_key UNIQUE (rfid_uid);


--
-- TOC entry 4407 (class 2606 OID 82762)
-- Name: categories categories_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_name_key UNIQUE (name);


--
-- TOC entry 4409 (class 2606 OID 82760)
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- TOC entry 4465 (class 2606 OID 83101)
-- Name: dev_fastlogin_accounts dev_fastlogin_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dev_fastlogin_accounts
    ADD CONSTRAINT dev_fastlogin_accounts_pkey PRIMARY KEY (email);


--
-- TOC entry 4428 (class 2606 OID 82829)
-- Name: distributors distributors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.distributors
    ADD CONSTRAINT distributors_pkey PRIMARY KEY (id);


--
-- TOC entry 4566 (class 2606 OID 89421)
-- Name: hq_info hq_info_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hq_info
    ADD CONSTRAINT hq_info_pkey PRIMARY KEY (id);


--
-- TOC entry 4542 (class 2606 OID 88801)
-- Name: lucky_draw_campaigns lucky_draw_campaigns_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lucky_draw_campaigns
    ADD CONSTRAINT lucky_draw_campaigns_code_key UNIQUE (code);


--
-- TOC entry 4544 (class 2606 OID 88799)
-- Name: lucky_draw_campaigns lucky_draw_campaigns_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lucky_draw_campaigns
    ADD CONSTRAINT lucky_draw_campaigns_pkey PRIMARY KEY (id);


--
-- TOC entry 4547 (class 2606 OID 88811)
-- Name: lucky_draw_participants lucky_draw_participants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lucky_draw_participants
    ADD CONSTRAINT lucky_draw_participants_pkey PRIMARY KEY (id);


--
-- TOC entry 4441 (class 2606 OID 82853)
-- Name: manufacturer_users manufacturer_users_manufacturer_id_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manufacturer_users
    ADD CONSTRAINT manufacturer_users_manufacturer_id_user_id_key UNIQUE (manufacturer_id, user_id);


--
-- TOC entry 4443 (class 2606 OID 82851)
-- Name: manufacturer_users manufacturer_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manufacturer_users
    ADD CONSTRAINT manufacturer_users_pkey PRIMARY KEY (id);


--
-- TOC entry 4423 (class 2606 OID 82818)
-- Name: manufacturers manufacturers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manufacturers
    ADD CONSTRAINT manufacturers_pkey PRIMARY KEY (id);


--
-- TOC entry 4425 (class 2606 OID 84283)
-- Name: manufacturers manufacturers_reg_country_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manufacturers
    ADD CONSTRAINT manufacturers_reg_country_uniq UNIQUE (registration_number, country_code) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4461 (class 2606 OID 83005)
-- Name: master_daerah master_daerah_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.master_daerah
    ADD CONSTRAINT master_daerah_pkey PRIMARY KEY (id);


--
-- TOC entry 4457 (class 2606 OID 82998)
-- Name: master_negeri master_negeri_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.master_negeri
    ADD CONSTRAINT master_negeri_code_key UNIQUE (code);


--
-- TOC entry 4459 (class 2606 OID 82996)
-- Name: master_negeri master_negeri_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.master_negeri
    ADD CONSTRAINT master_negeri_pkey PRIMARY KEY (id);


--
-- TOC entry 4539 (class 2606 OID 88713)
-- Name: movement_events movement_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.movement_events
    ADD CONSTRAINT movement_events_pkey PRIMARY KEY (id);


--
-- TOC entry 4558 (class 2606 OID 89237)
-- Name: notification_outbox notification_outbox_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_outbox
    ADD CONSTRAINT notification_outbox_pkey PRIMARY KEY (id);


--
-- TOC entry 4562 (class 2606 OID 89256)
-- Name: notification_preferences_user notification_preferences_user_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_preferences_user
    ADD CONSTRAINT notification_preferences_user_pkey PRIMARY KEY (id);


--
-- TOC entry 4564 (class 2606 OID 89258)
-- Name: notification_preferences_user notification_preferences_user_user_id_channel_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_preferences_user
    ADD CONSTRAINT notification_preferences_user_user_id_channel_key UNIQUE (user_id, channel);


--
-- TOC entry 4560 (class 2606 OID 89247)
-- Name: notification_settings_org notification_settings_org_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_settings_org
    ADD CONSTRAINT notification_settings_org_pkey PRIMARY KEY (org_id);


--
-- TOC entry 4487 (class 2606 OID 88218)
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- TOC entry 4481 (class 2606 OID 88203)
-- Name: orders orders_order_no_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_order_no_key UNIQUE (order_no);


--
-- TOC entry 4483 (class 2606 OID 88201)
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- TOC entry 4519 (class 2606 OID 88500)
-- Name: pack_events pack_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pack_events
    ADD CONSTRAINT pack_events_pkey PRIMARY KEY (id);


--
-- TOC entry 4501 (class 2606 OID 88312)
-- Name: po_status_history po_status_history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.po_status_history
    ADD CONSTRAINT po_status_history_pkey PRIMARY KEY (id);


--
-- TOC entry 4553 (class 2606 OID 88928)
-- Name: points_config points_config_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.points_config
    ADD CONSTRAINT points_config_pkey PRIMARY KEY (id);


--
-- TOC entry 4555 (class 2606 OID 88938)
-- Name: points_rules points_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.points_rules
    ADD CONSTRAINT points_rules_pkey PRIMARY KEY (id);


--
-- TOC entry 4416 (class 2606 OID 82786)
-- Name: product_groups product_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_groups
    ADD CONSTRAINT product_groups_pkey PRIMARY KEY (id);


--
-- TOC entry 4418 (class 2606 OID 82802)
-- Name: product_subgroups product_subgroups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_subgroups
    ADD CONSTRAINT product_subgroups_pkey PRIMARY KEY (id);


--
-- TOC entry 4453 (class 2606 OID 82959)
-- Name: product_variants product_variants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT product_variants_pkey PRIMARY KEY (id);


--
-- TOC entry 4447 (class 2606 OID 82890)
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- TOC entry 4449 (class 2606 OID 85878)
-- Name: products products_sku_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_sku_key UNIQUE (sku);


--
-- TOC entry 4405 (class 2606 OID 82720)
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- TOC entry 4498 (class 2606 OID 88302)
-- Name: purchase_order_items purchase_order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_order_items
    ADD CONSTRAINT purchase_order_items_pkey PRIMARY KEY (id);


--
-- TOC entry 4493 (class 2606 OID 88283)
-- Name: purchase_orders purchase_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_pkey PRIMARY KEY (id);


--
-- TOC entry 4495 (class 2606 OID 88285)
-- Name: purchase_orders purchase_orders_po_no_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_po_no_key UNIQUE (po_no);


--
-- TOC entry 4550 (class 2606 OID 88823)
-- Name: redeem_claims redeem_claims_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.redeem_claims
    ADD CONSTRAINT redeem_claims_pkey PRIMARY KEY (id);


--
-- TOC entry 4527 (class 2606 OID 88689)
-- Name: shipment_cases shipment_cases_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipment_cases
    ADD CONSTRAINT shipment_cases_pkey PRIMARY KEY (id);


--
-- TOC entry 4529 (class 2606 OID 88691)
-- Name: shipment_cases shipment_cases_shipment_id_case_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipment_cases
    ADD CONSTRAINT shipment_cases_shipment_id_case_id_key UNIQUE (shipment_id, case_id);


--
-- TOC entry 4532 (class 2606 OID 88699)
-- Name: shipment_uniques shipment_uniques_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipment_uniques
    ADD CONSTRAINT shipment_uniques_pkey PRIMARY KEY (id);


--
-- TOC entry 4534 (class 2606 OID 88701)
-- Name: shipment_uniques shipment_uniques_shipment_id_unique_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipment_uniques
    ADD CONSTRAINT shipment_uniques_shipment_id_unique_id_key UNIQUE (shipment_id, unique_id);


--
-- TOC entry 4522 (class 2606 OID 88679)
-- Name: shipments shipments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipments
    ADD CONSTRAINT shipments_pkey PRIMARY KEY (id);


--
-- TOC entry 4524 (class 2606 OID 88681)
-- Name: shipments shipments_shipment_no_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipments
    ADD CONSTRAINT shipments_shipment_no_key UNIQUE (shipment_no);


--
-- TOC entry 4445 (class 2606 OID 82868)
-- Name: shop_distributors shop_distributors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shop_distributors
    ADD CONSTRAINT shop_distributors_pkey PRIMARY KEY (shop_id, distributor_id);


--
-- TOC entry 4469 (class 2606 OID 84319)
-- Name: shop_points_ledger shop_points_ledger_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shop_points_ledger
    ADD CONSTRAINT shop_points_ledger_pkey PRIMARY KEY (id);


--
-- TOC entry 4439 (class 2606 OID 82840)
-- Name: shops shops_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shops
    ADD CONSTRAINT shops_pkey PRIMARY KEY (id);


--
-- TOC entry 4512 (class 2606 OID 88425)
-- Name: unique_codes unique_codes_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.unique_codes
    ADD CONSTRAINT unique_codes_code_key UNIQUE (code);


--
-- TOC entry 4514 (class 2606 OID 88423)
-- Name: unique_codes unique_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.unique_codes
    ADD CONSTRAINT unique_codes_pkey PRIMARY KEY (id);


--
-- TOC entry 4463 (class 2606 OID 83012)
-- Name: master_daerah uq_daerah_per_negeri; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.master_daerah
    ADD CONSTRAINT uq_daerah_per_negeri UNIQUE (negeri_id, name);


--
-- TOC entry 4451 (class 2606 OID 82917)
-- Name: products uq_product_tuple; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT uq_product_tuple UNIQUE (category_id, brand_id, group_id, sub_group_id, manufacturer_id, name_ci);


--
-- TOC entry 4455 (class 2606 OID 82966)
-- Name: product_variants uq_variant_tuple; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT uq_variant_tuple UNIQUE (product_id, flavor_name_ci, nic_strength_ci, packaging_ci);


--
-- TOC entry 4401 (class 2606 OID 48046)
-- Name: buckets_analytics buckets_analytics_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets_analytics
    ADD CONSTRAINT buckets_analytics_pkey PRIMARY KEY (id);


--
-- TOC entry 4379 (class 2606 OID 16552)
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- TOC entry 4389 (class 2606 OID 16593)
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- TOC entry 4391 (class 2606 OID 16591)
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 4387 (class 2606 OID 16569)
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- TOC entry 4399 (class 2606 OID 48001)
-- Name: prefixes prefixes_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.prefixes
    ADD CONSTRAINT prefixes_pkey PRIMARY KEY (bucket_id, level, name);


--
-- TOC entry 4396 (class 2606 OID 17150)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- TOC entry 4394 (class 2606 OID 17135)
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- TOC entry 4426 (class 1259 OID 87230)
-- Name: distributors_name_ci_uidx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX distributors_name_ci_uidx ON public.distributors USING btree (lower(name));


--
-- TOC entry 4473 (class 1259 OID 85983)
-- Name: idx_audit_log_entity_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_audit_log_entity_id ON public.audit_log USING btree (entity_id);


--
-- TOC entry 4474 (class 1259 OID 85982)
-- Name: idx_audit_log_entity_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_audit_log_entity_type ON public.audit_log USING btree (entity_type);


--
-- TOC entry 4475 (class 1259 OID 85981)
-- Name: idx_audit_log_operation; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_audit_log_operation ON public.audit_log USING btree (operation);


--
-- TOC entry 4476 (class 1259 OID 85985)
-- Name: idx_audit_log_performed_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_audit_log_performed_at ON public.audit_log USING btree (performed_at);


--
-- TOC entry 4477 (class 1259 OID 85984)
-- Name: idx_audit_log_performed_by; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_audit_log_performed_by ON public.audit_log USING btree (performed_by);


--
-- TOC entry 4414 (class 1259 OID 85899)
-- Name: idx_brands_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_brands_category_id ON public.brands USING btree (category_id);


--
-- TOC entry 4508 (class 1259 OID 88410)
-- Name: idx_cases_po_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cases_po_item_id ON public.cases USING btree (po_item_id);


--
-- TOC entry 4429 (class 1259 OID 84389)
-- Name: idx_distributors_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_distributors_active ON public.distributors USING btree (active);


--
-- TOC entry 4430 (class 1259 OID 87231)
-- Name: idx_distributors_category; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_distributors_category ON public.distributors USING btree (category_id);


--
-- TOC entry 4431 (class 1259 OID 87241)
-- Name: idx_distributors_country; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_distributors_country ON public.distributors USING btree (country_code);


--
-- TOC entry 4432 (class 1259 OID 87239)
-- Name: idx_distributors_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_distributors_email ON public.distributors USING btree (email);


--
-- TOC entry 4433 (class 1259 OID 87240)
-- Name: idx_distributors_phone; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_distributors_phone ON public.distributors USING btree (phone);


--
-- TOC entry 4540 (class 1259 OID 88802)
-- Name: idx_ldc_status_dates; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ldc_status_dates ON public.lucky_draw_campaigns USING btree (status, COALESCE(valid_from, '-infinity'::timestamp with time zone), COALESCE(valid_to, 'infinity'::timestamp with time zone));


--
-- TOC entry 4545 (class 1259 OID 88813)
-- Name: idx_ldp_campaign_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ldp_campaign_time ON public.lucky_draw_participants USING btree (campaign_id, submitted_at DESC);


--
-- TOC entry 4419 (class 1259 OID 86121)
-- Name: idx_manufacturers_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_manufacturers_category_id ON public.manufacturers USING btree (category_id);


--
-- TOC entry 4420 (class 1259 OID 84285)
-- Name: idx_manufacturers_country; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_manufacturers_country ON public.manufacturers USING btree (country_code);


--
-- TOC entry 4421 (class 1259 OID 84286)
-- Name: idx_manufacturers_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_manufacturers_status ON public.manufacturers USING btree (status);


--
-- TOC entry 4535 (class 1259 OID 88714)
-- Name: idx_move_events_case; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_move_events_case ON public.movement_events USING btree (case_id, created_at DESC);


--
-- TOC entry 4536 (class 1259 OID 88716)
-- Name: idx_move_events_ship; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_move_events_ship ON public.movement_events USING btree (shipment_id, created_at DESC);


--
-- TOC entry 4537 (class 1259 OID 88715)
-- Name: idx_move_events_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_move_events_unique ON public.movement_events USING btree (unique_id, created_at DESC);


--
-- TOC entry 4484 (class 1259 OID 88222)
-- Name: idx_order_items_order; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_order_items_order ON public.order_items USING btree (order_id);


--
-- TOC entry 4485 (class 1259 OID 89326)
-- Name: idx_order_items_order_id_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_order_items_order_id_created_at ON public.order_items USING btree (order_id, created_at);


--
-- TOC entry 4478 (class 1259 OID 88221)
-- Name: idx_orders_mfr; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_orders_mfr ON public.orders USING btree (manufacturer_id);


--
-- TOC entry 4479 (class 1259 OID 88220)
-- Name: idx_orders_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_orders_status ON public.orders USING btree (status);


--
-- TOC entry 4556 (class 1259 OID 89238)
-- Name: idx_outbox_unprocessed; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_outbox_unprocessed ON public.notification_outbox USING btree (processed_at NULLS FIRST, created_at);


--
-- TOC entry 4515 (class 1259 OID 88501)
-- Name: idx_pack_events_case; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pack_events_case ON public.pack_events USING btree (case_id, created_at DESC);


--
-- TOC entry 4516 (class 1259 OID 88503)
-- Name: idx_pack_events_po_item; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pack_events_po_item ON public.pack_events USING btree (po_item_id, created_at DESC);


--
-- TOC entry 4517 (class 1259 OID 88502)
-- Name: idx_pack_events_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pack_events_unique ON public.pack_events USING btree (unique_id, created_at DESC);


--
-- TOC entry 4499 (class 1259 OID 88313)
-- Name: idx_po_status_hist_po; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_po_status_hist_po ON public.po_status_history USING btree (po_id, changed_at DESC);


--
-- TOC entry 4496 (class 1259 OID 88303)
-- Name: idx_poi_po_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_poi_po_id ON public.purchase_order_items USING btree (po_id);


--
-- TOC entry 4466 (class 1259 OID 88951)
-- Name: idx_points_ledger_shop_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_points_ledger_shop_time ON public.shop_points_ledger USING btree (shop_id, created_at DESC);


--
-- TOC entry 4402 (class 1259 OID 84456)
-- Name: idx_profiles_distributor; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_profiles_distributor ON public.profiles USING btree (distributor_id);


--
-- TOC entry 4403 (class 1259 OID 84457)
-- Name: idx_profiles_shop; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_profiles_shop ON public.profiles USING btree (shop_id);


--
-- TOC entry 4489 (class 1259 OID 88287)
-- Name: idx_purchase_orders_mfr; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_purchase_orders_mfr ON public.purchase_orders USING btree (manufacturer_id);


--
-- TOC entry 4490 (class 1259 OID 88288)
-- Name: idx_purchase_orders_order; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_purchase_orders_order ON public.purchase_orders USING btree (order_id);


--
-- TOC entry 4491 (class 1259 OID 88286)
-- Name: idx_purchase_orders_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_purchase_orders_status ON public.purchase_orders USING btree (status);


--
-- TOC entry 4520 (class 1259 OID 88682)
-- Name: idx_shipments_type_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_shipments_type_status ON public.shipments USING btree (type, status);


--
-- TOC entry 4467 (class 1259 OID 84320)
-- Name: idx_shop_points_ledger_shop_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_shop_points_ledger_shop_id ON public.shop_points_ledger USING btree (shop_id);


--
-- TOC entry 4434 (class 1259 OID 84417)
-- Name: idx_shops_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_shops_active ON public.shops USING btree (active);


--
-- TOC entry 4435 (class 1259 OID 87238)
-- Name: idx_shops_category; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_shops_category ON public.shops USING btree (category_id);


--
-- TOC entry 4436 (class 1259 OID 84416)
-- Name: idx_shops_distributor; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_shops_distributor ON public.shops USING btree (distributor_id);


--
-- TOC entry 4525 (class 1259 OID 88692)
-- Name: idx_shp_cases_shipment; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_shp_cases_shipment ON public.shipment_cases USING btree (shipment_id);


--
-- TOC entry 4530 (class 1259 OID 88702)
-- Name: idx_shp_uniques_shipment; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_shp_uniques_shipment ON public.shipment_uniques USING btree (shipment_id);


--
-- TOC entry 4509 (class 1259 OID 88427)
-- Name: idx_unique_codes_case_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_unique_codes_case_id ON public.unique_codes USING btree (case_id);


--
-- TOC entry 4510 (class 1259 OID 88426)
-- Name: idx_unique_codes_po_item; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_unique_codes_po_item ON public.unique_codes USING btree (po_item_id);


--
-- TOC entry 4437 (class 1259 OID 87237)
-- Name: shops_distributor_name_ci_uidx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX shops_distributor_name_ci_uidx ON public.shops USING btree (distributor_id, lower(name));


--
-- TOC entry 4548 (class 1259 OID 88812)
-- Name: uq_ld_participant_per_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_ld_participant_per_unique ON public.lucky_draw_participants USING btree (campaign_id, unique_id);


--
-- TOC entry 4488 (class 1259 OID 88219)
-- Name: uq_order_items_line; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_order_items_line ON public.order_items USING btree (order_id, product_id, COALESCE(variant_id, '00000000-0000-0000-0000-000000000000'::uuid));


--
-- TOC entry 4470 (class 1259 OID 88952)
-- Name: uq_points_one_earn_per_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_points_one_earn_per_unique ON public.shop_points_ledger USING btree (unique_id) WHERE (operation = 'earn'::public.points_op);


--
-- TOC entry 4551 (class 1259 OID 88824)
-- Name: uq_redeem_one_per_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_redeem_one_per_unique ON public.redeem_claims USING btree (unique_id);


--
-- TOC entry 4377 (class 1259 OID 16558)
-- Name: bname; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- TOC entry 4380 (class 1259 OID 16580)
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- TOC entry 4392 (class 1259 OID 17161)
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- TOC entry 4381 (class 1259 OID 48019)
-- Name: idx_name_bucket_level_unique; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX idx_name_bucket_level_unique ON storage.objects USING btree (name COLLATE "C", bucket_id, level);


--
-- TOC entry 4382 (class 1259 OID 17124)
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- TOC entry 4383 (class 1259 OID 48021)
-- Name: idx_objects_lower_name; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_lower_name ON storage.objects USING btree ((path_tokens[level]), lower(name) text_pattern_ops, bucket_id, level);


--
-- TOC entry 4397 (class 1259 OID 48022)
-- Name: idx_prefixes_lower_name; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_prefixes_lower_name ON storage.prefixes USING btree (bucket_id, level, ((string_to_array(name, '/'::text))[level]), lower(name) text_pattern_ops);


--
-- TOC entry 4384 (class 1259 OID 16581)
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- TOC entry 4385 (class 1259 OID 48020)
-- Name: objects_bucket_id_level_idx; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX objects_bucket_id_level_idx ON storage.objects USING btree (bucket_id, level, name COLLATE "C");


--
-- TOC entry 4662 (class 2620 OID 88457)
-- Name: cases cases_set_created_by; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER cases_set_created_by BEFORE INSERT ON public.cases FOR EACH ROW EXECUTE FUNCTION public.set_created_by();


--
-- TOC entry 4663 (class 2620 OID 88453)
-- Name: cases cases_set_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER cases_set_updated_at BEFORE UPDATE ON public.cases FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4664 (class 2620 OID 88455)
-- Name: cases cases_set_updated_by; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER cases_set_updated_by BEFORE UPDATE ON public.cases FOR EACH ROW EXECUTE FUNCTION public.set_updated_by();


--
-- TOC entry 4650 (class 2620 OID 89303)
-- Name: order_items check_product_active_on_item_insupd; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER check_product_active_on_item_insupd BEFORE INSERT OR UPDATE OF product_id ON public.order_items FOR EACH ROW EXECUTE FUNCTION public.tg_check_product_active_on_item();


--
-- TOC entry 4651 (class 2620 OID 89305)
-- Name: order_items enforce_same_manufacturer_on_item; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER enforce_same_manufacturer_on_item BEFORE INSERT OR UPDATE OF product_id, order_id ON public.order_items FOR EACH ROW EXECUTE FUNCTION public.tg_enforce_same_manufacturer();


--
-- TOC entry 4670 (class 2620 OID 88842)
-- Name: lucky_draw_campaigns ldc_set_created_by; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER ldc_set_created_by BEFORE INSERT ON public.lucky_draw_campaigns FOR EACH ROW EXECUTE FUNCTION public.set_created_by();


--
-- TOC entry 4671 (class 2620 OID 88840)
-- Name: lucky_draw_campaigns ldc_set_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER ldc_set_updated_at BEFORE UPDATE ON public.lucky_draw_campaigns FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4672 (class 2620 OID 88841)
-- Name: lucky_draw_campaigns ldc_set_updated_by; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER ldc_set_updated_by BEFORE UPDATE ON public.lucky_draw_campaigns FOR EACH ROW EXECUTE FUNCTION public.set_updated_by();


--
-- TOC entry 4652 (class 2620 OID 89110)
-- Name: order_items order_items_recalc_del; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER order_items_recalc_del AFTER DELETE ON public.order_items REFERENCING OLD TABLE AS old_rows FOR EACH STATEMENT EXECUTE FUNCTION public.tg_recalc_from_items_del();


--
-- TOC entry 4653 (class 2620 OID 89106)
-- Name: order_items order_items_recalc_ins; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER order_items_recalc_ins AFTER INSERT ON public.order_items REFERENCING NEW TABLE AS new_rows FOR EACH STATEMENT EXECUTE FUNCTION public.tg_recalc_from_items_ins();


--
-- TOC entry 4654 (class 2620 OID 89108)
-- Name: order_items order_items_recalc_upd; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER order_items_recalc_upd AFTER UPDATE ON public.order_items REFERENCING OLD TABLE AS old_rows NEW TABLE AS new_rows FOR EACH STATEMENT EXECUTE FUNCTION public.tg_recalc_from_items_upd();


--
-- TOC entry 4655 (class 2620 OID 88248)
-- Name: order_items order_items_set_created_by; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER order_items_set_created_by BEFORE INSERT ON public.order_items FOR EACH ROW EXECUTE FUNCTION public.set_created_by();


--
-- TOC entry 4656 (class 2620 OID 88246)
-- Name: order_items order_items_set_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER order_items_set_updated_at BEFORE UPDATE ON public.order_items FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4657 (class 2620 OID 88247)
-- Name: order_items order_items_set_updated_by; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER order_items_set_updated_by BEFORE UPDATE ON public.order_items FOR EACH ROW EXECUTE FUNCTION public.set_updated_by();


--
-- TOC entry 4647 (class 2620 OID 88245)
-- Name: orders orders_set_created_by; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER orders_set_created_by BEFORE INSERT ON public.orders FOR EACH ROW EXECUTE FUNCTION public.set_created_by();


--
-- TOC entry 4648 (class 2620 OID 88243)
-- Name: orders orders_set_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER orders_set_updated_at BEFORE UPDATE ON public.orders FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4649 (class 2620 OID 88244)
-- Name: orders orders_set_updated_by; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER orders_set_updated_by BEFORE UPDATE ON public.orders FOR EACH ROW EXECUTE FUNCTION public.set_updated_by();


--
-- TOC entry 4658 (class 2620 OID 88351)
-- Name: purchase_orders po_set_created_by; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER po_set_created_by BEFORE INSERT ON public.purchase_orders FOR EACH ROW EXECUTE FUNCTION public.set_created_by();


--
-- TOC entry 4659 (class 2620 OID 88349)
-- Name: purchase_orders po_set_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER po_set_updated_at BEFORE UPDATE ON public.purchase_orders FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4660 (class 2620 OID 88350)
-- Name: purchase_orders po_set_updated_by; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER po_set_updated_by BEFORE UPDATE ON public.purchase_orders FOR EACH ROW EXECUTE FUNCTION public.set_updated_by();


--
-- TOC entry 4661 (class 2620 OID 88352)
-- Name: purchase_order_items poi_set_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER poi_set_updated_at BEFORE UPDATE ON public.purchase_order_items FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4669 (class 2620 OID 88747)
-- Name: shipments shipments_set_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER shipments_set_updated_at BEFORE UPDATE ON public.shipments FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4673 (class 2620 OID 89424)
-- Name: hq_info tg_hq_info_singleton; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_hq_info_singleton BEFORE INSERT ON public.hq_info FOR EACH ROW EXECUTE FUNCTION public.tg_hq_info_singleton();


--
-- TOC entry 4674 (class 2620 OID 89422)
-- Name: hq_info tg_hq_info_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_hq_info_updated_at BEFORE UPDATE ON public.hq_info FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4646 (class 2620 OID 85988)
-- Name: audit_log trg_audit_log_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_audit_log_updated_at BEFORE UPDATE ON public.audit_log FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4637 (class 2620 OID 82919)
-- Name: brands trg_brands_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_brands_updated_at BEFORE UPDATE ON public.brands FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4636 (class 2620 OID 82918)
-- Name: categories trg_categories_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_categories_updated_at BEFORE UPDATE ON public.categories FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4641 (class 2620 OID 82923)
-- Name: distributors trg_distributors_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_distributors_updated_at BEFORE UPDATE ON public.distributors FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4665 (class 2620 OID 88506)
-- Name: unique_codes trg_enforce_case_assignment; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_enforce_case_assignment BEFORE INSERT OR UPDATE OF case_id ON public.unique_codes FOR EACH ROW EXECUTE FUNCTION public.enforce_case_assignment();


--
-- TOC entry 4638 (class 2620 OID 82920)
-- Name: product_groups trg_groups_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_groups_updated_at BEFORE UPDATE ON public.product_groups FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4640 (class 2620 OID 82922)
-- Name: manufacturers trg_manufacturers_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_manufacturers_updated_at BEFORE UPDATE ON public.manufacturers FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4644 (class 2620 OID 82967)
-- Name: product_variants trg_product_variants_assign_sku; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_product_variants_assign_sku BEFORE INSERT ON public.product_variants FOR EACH ROW EXECUTE FUNCTION public.trg_assign_sku();


--
-- TOC entry 4645 (class 2620 OID 82968)
-- Name: product_variants trg_product_variants_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_product_variants_updated_at BEFORE UPDATE ON public.product_variants FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4643 (class 2620 OID 82925)
-- Name: products trg_products_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_products_updated_at BEFORE UPDATE ON public.products FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4634 (class 2620 OID 84459)
-- Name: profiles trg_profiles_parent; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_profiles_parent BEFORE INSERT OR UPDATE ON public.profiles FOR EACH ROW EXECUTE FUNCTION public.enforce_profile_parent();


--
-- TOC entry 4635 (class 2620 OID 82726)
-- Name: profiles trg_profiles_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_profiles_updated_at BEFORE UPDATE ON public.profiles FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4642 (class 2620 OID 82924)
-- Name: shops trg_shops_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_shops_updated_at BEFORE UPDATE ON public.shops FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4639 (class 2620 OID 82921)
-- Name: product_subgroups trg_subgroups_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_subgroups_updated_at BEFORE UPDATE ON public.product_subgroups FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4666 (class 2620 OID 88458)
-- Name: unique_codes unique_codes_set_created_by; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER unique_codes_set_created_by BEFORE INSERT ON public.unique_codes FOR EACH ROW EXECUTE FUNCTION public.set_created_by();


--
-- TOC entry 4667 (class 2620 OID 88454)
-- Name: unique_codes unique_codes_set_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER unique_codes_set_updated_at BEFORE UPDATE ON public.unique_codes FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 4668 (class 2620 OID 88456)
-- Name: unique_codes unique_codes_set_updated_by; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER unique_codes_set_updated_by BEFORE UPDATE ON public.unique_codes FOR EACH ROW EXECUTE FUNCTION public.set_updated_by();


--
-- TOC entry 4627 (class 2620 OID 48029)
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- TOC entry 4628 (class 2620 OID 82195)
-- Name: objects objects_delete_delete_prefix; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER objects_delete_delete_prefix AFTER DELETE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.delete_prefix_hierarchy_trigger();


--
-- TOC entry 4629 (class 2620 OID 48015)
-- Name: objects objects_insert_create_prefix; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER objects_insert_create_prefix BEFORE INSERT ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.objects_insert_prefix_trigger();


--
-- TOC entry 4630 (class 2620 OID 82194)
-- Name: objects objects_update_create_prefix; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER objects_update_create_prefix BEFORE UPDATE ON storage.objects FOR EACH ROW WHEN (((new.name <> old.name) OR (new.bucket_id <> old.bucket_id))) EXECUTE FUNCTION storage.objects_update_prefix_trigger();


--
-- TOC entry 4632 (class 2620 OID 48025)
-- Name: prefixes prefixes_create_hierarchy; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER prefixes_create_hierarchy BEFORE INSERT ON storage.prefixes FOR EACH ROW WHEN ((pg_trigger_depth() < 1)) EXECUTE FUNCTION storage.prefixes_insert_trigger();


--
-- TOC entry 4633 (class 2620 OID 82196)
-- Name: prefixes prefixes_delete_hierarchy; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER prefixes_delete_hierarchy AFTER DELETE ON storage.prefixes FOR EACH ROW EXECUTE FUNCTION storage.delete_prefix_hierarchy_trigger();


--
-- TOC entry 4631 (class 2620 OID 17103)
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- TOC entry 4599 (class 2606 OID 85976)
-- Name: audit_log audit_log_performed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_performed_by_fkey FOREIGN KEY (performed_by) REFERENCES auth.users(id);


--
-- TOC entry 4575 (class 2606 OID 85894)
-- Name: brands brands_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.brands
    ADD CONSTRAINT brands_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE RESTRICT;


--
-- TOC entry 4611 (class 2606 OID 88428)
-- Name: cases cases_po_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cases
    ADD CONSTRAINT cases_po_item_id_fkey FOREIGN KEY (po_item_id) REFERENCES public.purchase_order_items(id) ON DELETE CASCADE;


--
-- TOC entry 4579 (class 2606 OID 87225)
-- Name: distributors distributors_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.distributors
    ADD CONSTRAINT distributors_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4622 (class 2606 OID 88835)
-- Name: lucky_draw_participants ldp_campaign_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lucky_draw_participants
    ADD CONSTRAINT ldp_campaign_id_fkey FOREIGN KEY (campaign_id) REFERENCES public.lucky_draw_campaigns(id) ON DELETE CASCADE;


--
-- TOC entry 4623 (class 2606 OID 88825)
-- Name: lucky_draw_participants ldp_unique_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lucky_draw_participants
    ADD CONSTRAINT ldp_unique_id_fkey FOREIGN KEY (unique_id) REFERENCES public.unique_codes(id) ON DELETE RESTRICT;


--
-- TOC entry 4583 (class 2606 OID 82854)
-- Name: manufacturer_users manufacturer_users_manufacturer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manufacturer_users
    ADD CONSTRAINT manufacturer_users_manufacturer_id_fkey FOREIGN KEY (manufacturer_id) REFERENCES public.manufacturers(id) ON DELETE CASCADE;


--
-- TOC entry 4584 (class 2606 OID 82859)
-- Name: manufacturer_users manufacturer_users_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manufacturer_users
    ADD CONSTRAINT manufacturer_users_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4578 (class 2606 OID 86116)
-- Name: manufacturers manufacturers_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manufacturers
    ADD CONSTRAINT manufacturers_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE SET NULL;


--
-- TOC entry 4593 (class 2606 OID 83006)
-- Name: master_daerah master_daerah_negeri_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.master_daerah
    ADD CONSTRAINT master_daerah_negeri_id_fkey FOREIGN KEY (negeri_id) REFERENCES public.master_negeri(id) ON DELETE CASCADE;


--
-- TOC entry 4601 (class 2606 OID 88238)
-- Name: order_items order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- TOC entry 4602 (class 2606 OID 88228)
-- Name: order_items order_items_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE RESTRICT;


--
-- TOC entry 4603 (class 2606 OID 88233)
-- Name: order_items order_items_variant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_variant_id_fkey FOREIGN KEY (variant_id) REFERENCES public.product_variants(id) ON DELETE SET NULL;


--
-- TOC entry 4600 (class 2606 OID 88223)
-- Name: orders orders_manufacturer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_manufacturer_id_fkey FOREIGN KEY (manufacturer_id) REFERENCES public.manufacturers(id) ON DELETE RESTRICT;


--
-- TOC entry 4610 (class 2606 OID 88329)
-- Name: po_status_history po_status_history_po_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.po_status_history
    ADD CONSTRAINT po_status_history_po_id_fkey FOREIGN KEY (po_id) REFERENCES public.purchase_orders(id) ON DELETE CASCADE;


--
-- TOC entry 4606 (class 2606 OID 88334)
-- Name: purchase_order_items poi_order_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_order_items
    ADD CONSTRAINT poi_order_item_id_fkey FOREIGN KEY (order_item_id) REFERENCES public.order_items(id) ON DELETE RESTRICT;


--
-- TOC entry 4607 (class 2606 OID 88324)
-- Name: purchase_order_items poi_po_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_order_items
    ADD CONSTRAINT poi_po_id_fkey FOREIGN KEY (po_id) REFERENCES public.purchase_orders(id) ON DELETE CASCADE;


--
-- TOC entry 4608 (class 2606 OID 88339)
-- Name: purchase_order_items poi_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_order_items
    ADD CONSTRAINT poi_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE RESTRICT;


--
-- TOC entry 4609 (class 2606 OID 88344)
-- Name: purchase_order_items poi_variant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_order_items
    ADD CONSTRAINT poi_variant_id_fkey FOREIGN KEY (variant_id) REFERENCES public.product_variants(id) ON DELETE SET NULL;


--
-- TOC entry 4625 (class 2606 OID 88939)
-- Name: points_rules points_rules_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.points_rules
    ADD CONSTRAINT points_rules_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE RESTRICT;


--
-- TOC entry 4626 (class 2606 OID 88944)
-- Name: points_rules points_rules_variant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.points_rules
    ADD CONSTRAINT points_rules_variant_id_fkey FOREIGN KEY (variant_id) REFERENCES public.product_variants(id) ON DELETE SET NULL;


--
-- TOC entry 4576 (class 2606 OID 82787)
-- Name: product_groups product_groups_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_groups
    ADD CONSTRAINT product_groups_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE RESTRICT;


--
-- TOC entry 4577 (class 2606 OID 82803)
-- Name: product_subgroups product_subgroups_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_subgroups
    ADD CONSTRAINT product_subgroups_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.product_groups(id) ON DELETE RESTRICT;


--
-- TOC entry 4592 (class 2606 OID 82960)
-- Name: product_variants product_variants_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT product_variants_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- TOC entry 4587 (class 2606 OID 82896)
-- Name: products products_brand_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_brand_id_fkey FOREIGN KEY (brand_id) REFERENCES public.brands(id) ON DELETE RESTRICT;


--
-- TOC entry 4588 (class 2606 OID 82891)
-- Name: products products_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE RESTRICT;


--
-- TOC entry 4589 (class 2606 OID 82901)
-- Name: products products_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.product_groups(id) ON DELETE RESTRICT;


--
-- TOC entry 4590 (class 2606 OID 82911)
-- Name: products products_manufacturer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_manufacturer_id_fkey FOREIGN KEY (manufacturer_id) REFERENCES public.manufacturers(id) ON DELETE RESTRICT;


--
-- TOC entry 4591 (class 2606 OID 82906)
-- Name: products products_sub_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_sub_group_id_fkey FOREIGN KEY (sub_group_id) REFERENCES public.product_subgroups(id) ON DELETE RESTRICT;


--
-- TOC entry 4572 (class 2606 OID 84446)
-- Name: profiles profiles_distributor_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_distributor_fk FOREIGN KEY (distributor_id) REFERENCES public.distributors(id) ON DELETE SET NULL;


--
-- TOC entry 4573 (class 2606 OID 82721)
-- Name: profiles profiles_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4574 (class 2606 OID 84451)
-- Name: profiles profiles_shop_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_shop_fk FOREIGN KEY (shop_id) REFERENCES public.shops(id) ON DELETE SET NULL;


--
-- TOC entry 4604 (class 2606 OID 88319)
-- Name: purchase_orders purchase_orders_manufacturer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_manufacturer_id_fkey FOREIGN KEY (manufacturer_id) REFERENCES public.manufacturers(id) ON DELETE RESTRICT;


--
-- TOC entry 4605 (class 2606 OID 88314)
-- Name: purchase_orders purchase_orders_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE RESTRICT;


--
-- TOC entry 4624 (class 2606 OID 88830)
-- Name: redeem_claims redeem_unique_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.redeem_claims
    ADD CONSTRAINT redeem_unique_id_fkey FOREIGN KEY (unique_id) REFERENCES public.unique_codes(id) ON DELETE RESTRICT;


--
-- TOC entry 4618 (class 2606 OID 88722)
-- Name: shipment_cases shipment_cases_case_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipment_cases
    ADD CONSTRAINT shipment_cases_case_id_fkey FOREIGN KEY (case_id) REFERENCES public.cases(id) ON DELETE RESTRICT;


--
-- TOC entry 4619 (class 2606 OID 88727)
-- Name: shipment_cases shipment_cases_shipment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipment_cases
    ADD CONSTRAINT shipment_cases_shipment_id_fkey FOREIGN KEY (shipment_id) REFERENCES public.shipments(id) ON DELETE CASCADE;


--
-- TOC entry 4620 (class 2606 OID 88732)
-- Name: shipment_uniques shipment_uniques_shipment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipment_uniques
    ADD CONSTRAINT shipment_uniques_shipment_id_fkey FOREIGN KEY (shipment_id) REFERENCES public.shipments(id) ON DELETE CASCADE;


--
-- TOC entry 4621 (class 2606 OID 88737)
-- Name: shipment_uniques shipment_uniques_unique_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipment_uniques
    ADD CONSTRAINT shipment_uniques_unique_id_fkey FOREIGN KEY (unique_id) REFERENCES public.unique_codes(id) ON DELETE RESTRICT;


--
-- TOC entry 4616 (class 2606 OID 88717)
-- Name: shipments shipments_po_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipments
    ADD CONSTRAINT shipments_po_id_fkey FOREIGN KEY (po_id) REFERENCES public.purchase_orders(id) ON DELETE SET NULL;


--
-- TOC entry 4617 (class 2606 OID 88742)
-- Name: shipments shipments_to_distributor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipments
    ADD CONSTRAINT shipments_to_distributor_id_fkey FOREIGN KEY (to_distributor_id) REFERENCES public.distributors(id) ON DELETE SET NULL;


--
-- TOC entry 4585 (class 2606 OID 82874)
-- Name: shop_distributors shop_distributors_distributor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shop_distributors
    ADD CONSTRAINT shop_distributors_distributor_id_fkey FOREIGN KEY (distributor_id) REFERENCES public.distributors(id) ON DELETE CASCADE;


--
-- TOC entry 4586 (class 2606 OID 82869)
-- Name: shop_distributors shop_distributors_shop_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shop_distributors
    ADD CONSTRAINT shop_distributors_shop_id_fkey FOREIGN KEY (shop_id) REFERENCES public.shops(id) ON DELETE CASCADE;


--
-- TOC entry 4594 (class 2606 OID 84526)
-- Name: shop_points_ledger shop_points_ledger_shop_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shop_points_ledger
    ADD CONSTRAINT shop_points_ledger_shop_fk FOREIGN KEY (shop_id) REFERENCES public.shops(id) ON DELETE CASCADE;


--
-- TOC entry 4580 (class 2606 OID 87232)
-- Name: shops shops_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shops
    ADD CONSTRAINT shops_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4581 (class 2606 OID 84411)
-- Name: shops shops_distributor_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shops
    ADD CONSTRAINT shops_distributor_fk FOREIGN KEY (distributor_id) REFERENCES public.distributors(id) ON DELETE CASCADE;


--
-- TOC entry 4582 (class 2606 OID 82841)
-- Name: shops shops_distributor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shops
    ADD CONSTRAINT shops_distributor_id_fkey FOREIGN KEY (distributor_id) REFERENCES public.distributors(id) ON DELETE SET NULL;


--
-- TOC entry 4595 (class 2606 OID 88958)
-- Name: shop_points_ledger spl_po_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shop_points_ledger
    ADD CONSTRAINT spl_po_item_id_fkey FOREIGN KEY (po_item_id) REFERENCES public.purchase_order_items(id) ON DELETE SET NULL;


--
-- TOC entry 4596 (class 2606 OID 88963)
-- Name: shop_points_ledger spl_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shop_points_ledger
    ADD CONSTRAINT spl_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE SET NULL;


--
-- TOC entry 4597 (class 2606 OID 88953)
-- Name: shop_points_ledger spl_unique_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shop_points_ledger
    ADD CONSTRAINT spl_unique_id_fkey FOREIGN KEY (unique_id) REFERENCES public.unique_codes(id) ON DELETE SET NULL;


--
-- TOC entry 4598 (class 2606 OID 88968)
-- Name: shop_points_ledger spl_variant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shop_points_ledger
    ADD CONSTRAINT spl_variant_id_fkey FOREIGN KEY (variant_id) REFERENCES public.product_variants(id) ON DELETE SET NULL;


--
-- TOC entry 4612 (class 2606 OID 88438)
-- Name: unique_codes unique_codes_case_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.unique_codes
    ADD CONSTRAINT unique_codes_case_id_fkey FOREIGN KEY (case_id) REFERENCES public.cases(id) ON DELETE SET NULL;


--
-- TOC entry 4613 (class 2606 OID 88433)
-- Name: unique_codes unique_codes_po_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.unique_codes
    ADD CONSTRAINT unique_codes_po_item_id_fkey FOREIGN KEY (po_item_id) REFERENCES public.purchase_order_items(id) ON DELETE CASCADE;


--
-- TOC entry 4614 (class 2606 OID 88443)
-- Name: unique_codes unique_codes_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.unique_codes
    ADD CONSTRAINT unique_codes_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE RESTRICT;


--
-- TOC entry 4615 (class 2606 OID 88448)
-- Name: unique_codes unique_codes_variant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.unique_codes
    ADD CONSTRAINT unique_codes_variant_id_fkey FOREIGN KEY (variant_id) REFERENCES public.product_variants(id) ON DELETE SET NULL;


--
-- TOC entry 4567 (class 2606 OID 16570)
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 4571 (class 2606 OID 48002)
-- Name: prefixes prefixes_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.prefixes
    ADD CONSTRAINT "prefixes_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 4568 (class 2606 OID 17136)
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 4569 (class 2606 OID 17156)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 4570 (class 2606 OID 17151)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- TOC entry 4844 (class 0 OID 85967)
-- Dependencies: 425
-- Name: audit_log; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.audit_log ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4884 (class 3256 OID 85986)
-- Name: audit_log audit_log_admin_read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY audit_log_admin_read ON public.audit_log FOR SELECT TO authenticated USING ((app.is_hq_admin() OR app.is_power_user()));


--
-- TOC entry 4885 (class 3256 OID 85987)
-- Name: audit_log audit_log_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY audit_log_insert ON public.audit_log FOR INSERT TO authenticated WITH CHECK ((performed_by = auth.uid()));


--
-- TOC entry 4850 (class 0 OID 88393)
-- Dependencies: 433
-- Name: cases; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.cases ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4876 (class 3256 OID 84704)
-- Name: distributors dist_own_distributor; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY dist_own_distributor ON public.distributors USING ((id = ( SELECT v_current_profile.distributor_id
   FROM public.v_current_profile
  WHERE (v_current_profile.role = 'distributor_admin'::public.app_role)))) WITH CHECK ((id = ( SELECT v_current_profile.distributor_id
   FROM public.v_current_profile
  WHERE (v_current_profile.role = 'distributor_admin'::public.app_role))));


--
-- TOC entry 4877 (class 3256 OID 84706)
-- Name: shops dist_own_shops; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY dist_own_shops ON public.shops USING ((distributor_id = ( SELECT v_current_profile.distributor_id
   FROM public.v_current_profile
  WHERE (v_current_profile.role = ANY (ARRAY['distributor_admin'::public.app_role, 'shop_user'::public.app_role]))))) WITH CHECK ((distributor_id = ( SELECT v_current_profile.distributor_id
   FROM public.v_current_profile
  WHERE (v_current_profile.role = ANY (ARRAY['distributor_admin'::public.app_role, 'shop_user'::public.app_role])))));


--
-- TOC entry 4883 (class 3256 OID 84755)
-- Name: distributors distributors_admin_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY distributors_admin_delete ON public.distributors FOR DELETE TO authenticated USING ((app.is_hq_admin() OR app.is_power_user()));


--
-- TOC entry 4881 (class 3256 OID 84753)
-- Name: distributors distributors_admin_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY distributors_admin_insert ON public.distributors FOR INSERT TO authenticated WITH CHECK ((app.is_hq_admin() OR app.is_power_user()));


--
-- TOC entry 4880 (class 3256 OID 84752)
-- Name: distributors distributors_admin_read_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY distributors_admin_read_all ON public.distributors FOR SELECT TO authenticated USING ((app.is_hq_admin() OR app.is_power_user()));


--
-- TOC entry 4882 (class 3256 OID 84754)
-- Name: distributors distributors_admin_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY distributors_admin_update ON public.distributors FOR UPDATE TO authenticated USING ((app.is_hq_admin() OR app.is_power_user())) WITH CHECK ((app.is_hq_admin() OR app.is_power_user()));


--
-- TOC entry 4875 (class 3256 OID 84702)
-- Name: shop_points_ledger hq_all_points; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY hq_all_points ON public.shop_points_ledger USING ((EXISTS ( SELECT 1
   FROM public.v_current_profile
  WHERE (v_current_profile.role = 'hq_admin'::public.app_role)))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.v_current_profile
  WHERE (v_current_profile.role = 'hq_admin'::public.app_role))));


--
-- TOC entry 4874 (class 3256 OID 84700)
-- Name: profiles hq_all_profiles; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY hq_all_profiles ON public.profiles USING ((EXISTS ( SELECT 1
   FROM public.v_current_profile
  WHERE (v_current_profile.role = 'hq_admin'::public.app_role)))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.v_current_profile
  WHERE (v_current_profile.role = 'hq_admin'::public.app_role))));


--
-- TOC entry 4873 (class 3256 OID 84698)
-- Name: shops hq_all_shops; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY hq_all_shops ON public.shops USING ((EXISTS ( SELECT 1
   FROM public.v_current_profile
  WHERE (v_current_profile.role = 'hq_admin'::public.app_role)))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.v_current_profile
  WHERE (v_current_profile.role = 'hq_admin'::public.app_role))));


--
-- TOC entry 4856 (class 0 OID 88789)
-- Dependencies: 442
-- Name: lucky_draw_campaigns; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.lucky_draw_campaigns ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4857 (class 0 OID 88803)
-- Dependencies: 443
-- Name: lucky_draw_participants; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.lucky_draw_participants ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4855 (class 0 OID 88703)
-- Dependencies: 441
-- Name: movement_events; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.movement_events ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4846 (class 0 OID 88204)
-- Dependencies: 427
-- Name: order_items; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.order_items ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4845 (class 0 OID 88191)
-- Dependencies: 426
-- Name: orders; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4849 (class 0 OID 88304)
-- Dependencies: 430
-- Name: po_status_history; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.po_status_history ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4859 (class 0 OID 88921)
-- Dependencies: 447
-- Name: points_config; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.points_config ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4860 (class 0 OID 88929)
-- Dependencies: 448
-- Name: points_rules; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.points_rules ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4879 (class 3256 OID 84709)
-- Name: shop_points_ledger points_same_distributor; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY points_same_distributor ON public.shop_points_ledger USING ((EXISTS ( SELECT 1
   FROM (public.v_current_profile p
     JOIN public.shops s ON ((s.id = p.shop_id)))
  WHERE ((p.role = ANY (ARRAY['distributor_admin'::public.app_role, 'shop_user'::public.app_role])) AND (p.distributor_id = s.distributor_id))))) WITH CHECK (true);


--
-- TOC entry 4842 (class 0 OID 82712)
-- Dependencies: 399
-- Name: profiles; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4868 (class 3256 OID 82729)
-- Name: profiles profiles_admin_read_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY profiles_admin_read_all ON public.profiles FOR SELECT TO authenticated USING ((COALESCE(((current_setting('request.jwt.claims'::text, true))::jsonb ->> 'role'::text), ''::text) = ANY (ARRAY['hq_admin'::text, 'power_user'::text])));


--
-- TOC entry 4866 (class 3256 OID 82727)
-- Name: profiles profiles_self_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY profiles_self_select ON public.profiles FOR SELECT TO authenticated USING ((id = auth.uid()));


--
-- TOC entry 4867 (class 3256 OID 82728)
-- Name: profiles profiles_self_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY profiles_self_update ON public.profiles FOR UPDATE TO authenticated USING ((id = auth.uid())) WITH CHECK ((id = auth.uid()));


--
-- TOC entry 4848 (class 0 OID 88289)
-- Dependencies: 429
-- Name: purchase_order_items; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.purchase_order_items ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4847 (class 0 OID 88274)
-- Dependencies: 428
-- Name: purchase_orders; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.purchase_orders ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4858 (class 0 OID 88814)
-- Dependencies: 444
-- Name: redeem_claims; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.redeem_claims ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4878 (class 3256 OID 84708)
-- Name: profiles self_profile_rw; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY self_profile_rw ON public.profiles USING ((id = auth.uid())) WITH CHECK ((id = auth.uid()));


--
-- TOC entry 4853 (class 0 OID 88683)
-- Dependencies: 439
-- Name: shipment_cases; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.shipment_cases ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4854 (class 0 OID 88693)
-- Dependencies: 440
-- Name: shipment_uniques; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.shipment_uniques ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4852 (class 0 OID 88669)
-- Dependencies: 438
-- Name: shipments; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.shipments ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4843 (class 0 OID 84311)
-- Dependencies: 415
-- Name: shop_points_ledger; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.shop_points_ledger ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4851 (class 0 OID 88411)
-- Dependencies: 434
-- Name: unique_codes; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.unique_codes ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4869 (class 3256 OID 49854)
-- Name: objects Allow anonymous uploads to product-images; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Allow anonymous uploads to product-images" ON storage.objects FOR INSERT WITH CHECK ((bucket_id = 'product-images'::text));


--
-- TOC entry 4870 (class 3256 OID 49855)
-- Name: objects Allow public access to product-images; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Allow public access to product-images" ON storage.objects FOR SELECT USING ((bucket_id = 'product-images'::text));


--
-- TOC entry 4835 (class 0 OID 16544)
-- Dependencies: 361
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4841 (class 0 OID 48036)
-- Dependencies: 391
-- Name: buckets_analytics; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets_analytics ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4899 (class 3256 OID 70396)
-- Name: objects campaign_images_public_read; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY campaign_images_public_read ON storage.objects FOR SELECT USING ((bucket_id = 'campaign-images'::text));


--
-- TOC entry 4902 (class 3256 OID 70420)
-- Name: objects campaign_images_write_delete; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY campaign_images_write_delete ON storage.objects FOR DELETE TO authenticated USING (((bucket_id = 'campaign-images'::text) AND (app.is_hq_admin() OR app.is_power_user())));


--
-- TOC entry 4900 (class 3256 OID 70418)
-- Name: objects campaign_images_write_insert; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY campaign_images_write_insert ON storage.objects FOR INSERT TO authenticated WITH CHECK (((bucket_id = 'campaign-images'::text) AND (app.is_hq_admin() OR app.is_power_user())));


--
-- TOC entry 4901 (class 3256 OID 70419)
-- Name: objects campaign_images_write_update; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY campaign_images_write_update ON storage.objects FOR UPDATE TO authenticated USING (((bucket_id = 'campaign-images'::text) AND (app.is_hq_admin() OR app.is_power_user()))) WITH CHECK (((bucket_id = 'campaign-images'::text) AND (app.is_hq_admin() OR app.is_power_user())));


--
-- TOC entry 4837 (class 0 OID 16586)
-- Dependencies: 363
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4836 (class 0 OID 16559)
-- Dependencies: 362
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4840 (class 0 OID 47992)
-- Dependencies: 390
-- Name: prefixes; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.prefixes ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4862 (class 3256 OID 67241)
-- Name: objects prizes delete; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "prizes delete" ON storage.objects FOR DELETE TO authenticated USING (((bucket_id = 'prizes'::text) AND (app.is_hq_admin() OR app.is_power_user())));


--
-- TOC entry 4886 (class 3256 OID 67238)
-- Name: objects prizes read; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "prizes read" ON storage.objects FOR SELECT USING ((bucket_id = 'prizes'::text));


--
-- TOC entry 4888 (class 3256 OID 67240)
-- Name: objects prizes update; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "prizes update" ON storage.objects FOR UPDATE TO authenticated USING (((bucket_id = 'prizes'::text) AND (app.is_hq_admin() OR app.is_power_user()))) WITH CHECK (((bucket_id = 'prizes'::text) AND (app.is_hq_admin() OR app.is_power_user())));


--
-- TOC entry 4887 (class 3256 OID 67239)
-- Name: objects prizes write; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "prizes write" ON storage.objects FOR INSERT TO authenticated WITH CHECK (((bucket_id = 'prizes'::text) AND (app.is_hq_admin() OR app.is_power_user())));


--
-- TOC entry 4865 (class 3256 OID 67392)
-- Name: objects prizes_delete_auth; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY prizes_delete_auth ON storage.objects FOR DELETE TO authenticated USING ((bucket_id = 'prizes'::text));


--
-- TOC entry 4863 (class 3256 OID 67390)
-- Name: objects prizes_insert_auth; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY prizes_insert_auth ON storage.objects FOR INSERT TO authenticated WITH CHECK ((bucket_id = 'prizes'::text));


--
-- TOC entry 4889 (class 3256 OID 67388)
-- Name: objects prizes_read_anon; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY prizes_read_anon ON storage.objects FOR SELECT TO anon USING ((bucket_id = 'prizes'::text));


--
-- TOC entry 4861 (class 3256 OID 67389)
-- Name: objects prizes_read_auth; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY prizes_read_auth ON storage.objects FOR SELECT TO authenticated USING ((bucket_id = 'prizes'::text));


--
-- TOC entry 4864 (class 3256 OID 67391)
-- Name: objects prizes_update_auth; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY prizes_update_auth ON storage.objects FOR UPDATE TO authenticated USING ((bucket_id = 'prizes'::text)) WITH CHECK ((bucket_id = 'prizes'::text));


--
-- TOC entry 4871 (class 3256 OID 49879)
-- Name: objects product_images_authenticated_write; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY product_images_authenticated_write ON storage.objects FOR INSERT TO authenticated WITH CHECK ((bucket_id = 'product-images'::text));


--
-- TOC entry 4898 (class 3256 OID 70190)
-- Name: objects product_images_authenticated_write_delete; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY product_images_authenticated_write_delete ON storage.objects FOR DELETE TO authenticated USING (((bucket_id = 'product-images'::text) AND (app.is_hq_admin() OR app.is_power_user())));


--
-- TOC entry 4896 (class 3256 OID 70188)
-- Name: objects product_images_authenticated_write_insert; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY product_images_authenticated_write_insert ON storage.objects FOR INSERT TO authenticated WITH CHECK (((bucket_id = 'product-images'::text) AND (app.is_hq_admin() OR app.is_power_user())));


--
-- TOC entry 4897 (class 3256 OID 70189)
-- Name: objects product_images_authenticated_write_update; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY product_images_authenticated_write_update ON storage.objects FOR UPDATE TO authenticated USING (((bucket_id = 'product-images'::text) AND (app.is_hq_admin() OR app.is_power_user()))) WITH CHECK (((bucket_id = 'product-images'::text) AND (app.is_hq_admin() OR app.is_power_user())));


--
-- TOC entry 4895 (class 3256 OID 69976)
-- Name: objects product_images_hq_power_delete; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY product_images_hq_power_delete ON storage.objects FOR DELETE TO authenticated USING (((bucket_id = 'product-images'::text) AND (app.is_hq_admin() OR app.is_power_user())));


--
-- TOC entry 4893 (class 3256 OID 69974)
-- Name: objects product_images_hq_power_insert; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY product_images_hq_power_insert ON storage.objects FOR INSERT TO authenticated WITH CHECK (((bucket_id = 'product-images'::text) AND (app.is_hq_admin() OR app.is_power_user())));


--
-- TOC entry 4894 (class 3256 OID 69975)
-- Name: objects product_images_hq_power_update; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY product_images_hq_power_update ON storage.objects FOR UPDATE TO authenticated USING (((bucket_id = 'product-images'::text) AND (app.is_hq_admin() OR app.is_power_user()))) WITH CHECK (((bucket_id = 'product-images'::text) AND (app.is_hq_admin() OR app.is_power_user())));


--
-- TOC entry 4872 (class 3256 OID 49880)
-- Name: objects product_images_public_read; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY product_images_public_read ON storage.objects FOR SELECT USING ((bucket_id = 'product-images'::text));


--
-- TOC entry 4892 (class 3256 OID 69952)
-- Name: objects product_images_server_write_delete; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY product_images_server_write_delete ON storage.objects FOR DELETE TO authenticated USING (((bucket_id = 'product-images'::text) AND (app.is_hq_admin() OR app.is_power_user())));


--
-- TOC entry 4890 (class 3256 OID 69908)
-- Name: objects product_images_server_write_insert; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY product_images_server_write_insert ON storage.objects FOR INSERT TO authenticated WITH CHECK (((bucket_id = 'product-images'::text) AND (app.is_hq_admin() OR app.is_power_user())));


--
-- TOC entry 4891 (class 3256 OID 69930)
-- Name: objects product_images_server_write_update; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY product_images_server_write_update ON storage.objects FOR UPDATE TO authenticated USING (((bucket_id = 'product-images'::text) AND (app.is_hq_admin() OR app.is_power_user()))) WITH CHECK (((bucket_id = 'product-images'::text) AND (app.is_hq_admin() OR app.is_power_user())));


--
-- TOC entry 4838 (class 0 OID 17126)
-- Dependencies: 384
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4839 (class 0 OID 17141)
-- Dependencies: 385
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

-- Completed on 2025-09-28 21:57:59 +08

--
-- PostgreSQL database dump complete
--

\unrestrict SgTdZxUapFcpeuijmN6DP5WVmeLBu4Sqee7OCWspt21tntgT7vFR1gm4IdObLXJ

