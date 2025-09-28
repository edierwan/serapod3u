--
-- PostgreSQL database dump
--

\restrict WNhD5PLjM0fhVOSgW47uNqVhUhgrG58sZnSVqPJWuwtGy1PzSrF7J8Wav6cmdnD

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

-- Started on 2025-09-28 14:05:08 +08

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
-- TOC entry 51 (class 2615 OID 21304)
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- TOC entry 32 (class 2615 OID 16542)
-- Name: storage; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA storage;


--
-- TOC entry 1289 (class 1247 OID 17678)
-- Name: buckettype; Type: TYPE; Schema: storage; Owner: -
--

CREATE TYPE storage.buckettype AS ENUM (
    'STANDARD',
    'ANALYTICS'
);


--
-- TOC entry 453 (class 1255 OID 21427)
-- Name: _upsert_daerah(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public._upsert_daerah(negeri_code text, daerah_name text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE n_id uuid; BEGIN
  SELECT id INTO n_id FROM public.master_negeri WHERE code = negeri_code;
  IF n_id IS NULL THEN RAISE EXCEPTION 'Negeri code % not found', negeri_code; END IF;
  INSERT INTO public.master_daerah (negeri_id, name)
  VALUES (n_id, daerah_name)
  ON CONFLICT (negeri_id, name_ci) DO NOTHING;
END $$;


--
-- TOC entry 417 (class 1255 OID 25074)
-- Name: _upsert_daerah_v2(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public._upsert_daerah_v2(p_negeri_code text, p_daerah_name text) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
declare
  v_negeri_id integer;
  v_daerah_id integer;
begin
  -- validate input
  if coalesce(trim(p_negeri_code), '') = '' then
    raise exception 'p_negeri_code is required';
  end if;
  if coalesce(trim(p_daerah_name), '') = '' then
    raise exception 'p_daerah_name is required';
  end if;

  -- find negeri by code
  select id into v_negeri_id
  from public.master_negeri
  where code = p_negeri_code
  limit 1;

  if v_negeri_id is null then
    raise exception 'Negeri with code % not found', p_negeri_code using errcode = '22023';
  end if;

  -- upsert daerah (dedup by negeri_id + name_ci)
  insert into public.master_daerah (negeri_id, name)
  values (v_negeri_id, p_daerah_name)
  on conflict (negeri_id, name_ci) do update
     set name = excluded.name
  returning id into v_daerah_id;

  return v_daerah_id;
end
$$;


--
-- TOC entry 452 (class 1255 OID 23704)
-- Name: add_shop_and_link(text, text, uuid, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.add_shop_and_link(p_code text, p_name text, p_negeri_id uuid DEFAULT NULL::uuid, p_daerah_id uuid DEFAULT NULL::uuid) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_shop_id uuid := gen_random_uuid();
  v_distributor_id uuid := app.claim_uuid('distributor_id');
BEGIN
  IF v_distributor_id IS NULL THEN
    RAISE EXCEPTION 'Only distributor users can create shops (missing distributor_id claim)';
  END IF;

  -- Create the shop (adjust columns if your schema has more fields)
  INSERT INTO public.shops(id, code, name, negeri_id, daerah_id)
  VALUES (v_shop_id, p_code, p_name, p_negeri_id, p_daerah_id);

  -- Link new shop to current distributor
  INSERT INTO public.shop_distributors(shop_id, distributor_id)
  VALUES (v_shop_id, v_distributor_id)
  ON CONFLICT DO NOTHING;

  RETURN v_shop_id;
END;
$$;


--
-- TOC entry 399 (class 1255 OID 24891)
-- Name: add_shop_and_link_admin(text, text, uuid, uuid, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.add_shop_and_link_admin(p_code text, p_name text, p_negeri_id uuid DEFAULT NULL::uuid, p_daerah_id uuid DEFAULT NULL::uuid, p_distributor_id uuid DEFAULT NULL::uuid) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
declare
  v_shop_id uuid := gen_random_uuid();
begin
  if not (public.is_role('hq_admin') or public.is_role('power_user')) then
    raise exception 'Not permitted: HQ Admin / Power User only' using errcode = '42501';
  end if;

  if p_distributor_id is null then
    raise exception 'p_distributor_id is required for admin assignment' using errcode = '22023';
  end if;

  insert into public.shops(id, code, name, negeri_id, daerah_id)
  values (v_shop_id, p_code, p_name, p_negeri_id, p_daerah_id)
  on conflict (id) do nothing;

  insert into public.shop_distributors(shop_id, distributor_id)
  values (v_shop_id, p_distributor_id)
  on conflict do nothing;

  return v_shop_id;
end;
$$;


--
-- TOC entry 4287 (class 0 OID 0)
-- Dependencies: 399
-- Name: FUNCTION add_shop_and_link_admin(p_code text, p_name text, p_negeri_id uuid, p_daerah_id uuid, p_distributor_id uuid); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.add_shop_and_link_admin(p_code text, p_name text, p_negeri_id uuid, p_daerah_id uuid, p_distributor_id uuid) IS 'HQ/Power User: create shop and link to any distributor (assignment override).';


--
-- TOC entry 432 (class 1255 OID 21390)
-- Name: current_user_id(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.current_user_id() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  SELECT auth.uid()
$$;


--
-- TOC entry 401 (class 1255 OID 21674)
-- Name: delete_all_master_data(boolean, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.delete_all_master_data(_force boolean, _confirm text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  counts_before jsonb;
  rc int;
  deleted jsonb := '{}'::jsonb;
BEGIN
  -- Authorization: only HQ_ADMIN may execute
  IF NOT public.is_role('hq_admin') THEN
    RAISE EXCEPTION 'Not permitted: HQ_ADMIN only' USING ERRCODE = '42501';
  END IF;

  -- Safety: require explicit force + exact phrase
  IF NOT _force OR _confirm IS DISTINCT FROM 'DELETE ALL MASTER DATA' THEN
    RAISE EXCEPTION 'Confirmation required: set force=true and type "DELETE ALL MASTER DATA"' USING ERRCODE = '22023';
  END IF;

  -- Snapshot counts before (optional, for return payload)
  counts_before := public.master_data_counts();

  -- Delete in dependency-safe order
  DELETE FROM public.product_variants;        GET DIAGNOSTICS rc = ROW_COUNT; deleted := deleted || jsonb_build_object('product_variants', rc);
  DELETE FROM public.products;                GET DIAGNOSTICS rc = ROW_COUNT; deleted := deleted || jsonb_build_object('products', rc);
  DELETE FROM public.manufacturer_users;      GET DIAGNOSTICS rc = ROW_COUNT; deleted := deleted || jsonb_build_object('manufacturer_users', rc);
  DELETE FROM public.manufacturers;           GET DIAGNOSTICS rc = ROW_COUNT; deleted := deleted || jsonb_build_object('manufacturers', rc);
  DELETE FROM public.product_subgroups;       GET DIAGNOSTICS rc = ROW_COUNT; deleted := deleted || jsonb_build_object('product_subgroups', rc);
  DELETE FROM public.product_groups;          GET DIAGNOSTICS rc = ROW_COUNT; deleted := deleted || jsonb_build_object('product_groups', rc);
  DELETE FROM public.brands;                  GET DIAGNOSTICS rc = ROW_COUNT; deleted := deleted || jsonb_build_object('brands', rc);

  -- Keep categories but normalize to exactly Vape/Non-Vape
  DELETE FROM public.categories WHERE code NOT IN ('vape','non_vape');
  INSERT INTO public.categories(code, name) VALUES ('vape','Vape')
    ON CONFLICT (code) DO UPDATE SET name = EXCLUDED.name;
  INSERT INTO public.categories(code, name) VALUES ('non_vape','Non-Vape')
    ON CONFLICT (code) DO UPDATE SET name = EXCLUDED.name;

  -- Return summary
  RETURN jsonb_build_object(
    'ok', true,
    'deleted', deleted,
    'before', counts_before,
    'note', 'Negeri/Daerah preserved; Categories normalized to Vape/Non-Vape'
  );
END;
$$;


--
-- TOC entry 444 (class 1255 OID 21391)
-- Name: generate_sku(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.generate_sku() RETURNS text
    LANGUAGE sql
    AS $$
  SELECT 'SKU-' || substring(encode(digest(gen_random_uuid()::text, 'sha256'), 'hex') FROM 1 FOR 12)
$$;


--
-- TOC entry 392 (class 1255 OID 21389)
-- Name: has_any_role(text[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.has_any_role(targets text[]) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  select lower(
           coalesce(
             (auth.jwt() -> 'app_metadata' ->> 'role'),
             (auth.jwt() ->> 'role'),
             ''
           )
         ) = any (select lower(t) from unnest(targets) t);
$$;


--
-- TOC entry 504 (class 1255 OID 21388)
-- Name: is_role(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.is_role(target text) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  select public.jwt_role() = lower(target);
$$;


--
-- TOC entry 487 (class 1255 OID 21387)
-- Name: jwt_role(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.jwt_role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select lower(
           coalesce(
             (auth.jwt() -> 'app_metadata' ->> 'role'),
             (auth.jwt() ->> 'role'),
             ''
           )
         );
$$;


--
-- TOC entry 450 (class 1255 OID 23354)
-- Name: link_user_to_manufacturer(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.link_user_to_manufacturer(p_manufacturer_id uuid) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
  -- Optional: ensure the manufacturer exists
  IF NOT EXISTS (SELECT 1 FROM public.manufacturers m WHERE m.id = p_manufacturer_id) THEN
    RAISE EXCEPTION 'Manufacturer % not found', p_manufacturer_id USING ERRCODE = '22023';
  END IF;

  INSERT INTO public.manufacturer_users (manufacturer_id, user_id)
  VALUES (p_manufacturer_id, auth.uid())
  ON CONFLICT (manufacturer_id, user_id) DO NOTHING;
END;
$$;


--
-- TOC entry 478 (class 1255 OID 21673)
-- Name: master_data_counts(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.master_data_counts() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  SELECT jsonb_build_object(
    'brands',              (SELECT count(*) FROM public.brands),
    'product_groups',      (SELECT count(*) FROM public.product_groups),
    'product_subgroups',   (SELECT count(*) FROM public.product_subgroups),
    'manufacturers',       (SELECT count(*) FROM public.manufacturers),
    'manufacturer_users',  (SELECT count(*) FROM public.manufacturer_users),
    'products',            (SELECT count(*) FROM public.products),
    'product_variants',    (SELECT count(*) FROM public.product_variants),
    'categories',          (SELECT count(*) FROM public.categories)
  );
$$;


--
-- TOC entry 530 (class 1255 OID 24864)
-- Name: product_hard_delete(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.product_hard_delete(p_product_id uuid) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
  IF NOT (public.is_role('hq_admin') OR public.is_role('power_user')) THEN
    RAISE EXCEPTION 'Only HQ Admin / Power User may hard delete products';
  END IF;

  IF public.product_has_transactions(p_product_id) THEN
    RAISE EXCEPTION 'Cannot hard delete: product has transactions (orders exist)';
  END IF;

  DELETE FROM public.products WHERE id = p_product_id;
END; $$;


--
-- TOC entry 421 (class 1255 OID 23662)
-- Name: product_has_transactions(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.product_has_transactions(p_product_id uuid) RETURNS boolean
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
  rel_exists boolean;
  has_tx boolean := false;
BEGIN
  SELECT EXISTS (
    SELECT 1 FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE n.nspname = 'public' AND c.relname = 'order_items'
  ) INTO rel_exists;

  IF rel_exists THEN
    SELECT EXISTS (
      SELECT 1 FROM public.order_items oi WHERE oi.product_id = p_product_id
      UNION ALL
      SELECT 1 FROM public.order_items oi
      JOIN public.product_variants v ON v.id = oi.variant_id
      WHERE v.product_id = p_product_id
      LIMIT 1
    ) INTO has_tx;
  END IF;

  RETURN has_tx;
END;
$$;


--
-- TOC entry 460 (class 1255 OID 24863)
-- Name: product_restore(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.product_restore(p_product_id uuid) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
  IF NOT (public.is_role('hq_admin') OR public.is_role('power_user')) THEN
    RAISE EXCEPTION 'Only HQ Admin / Power User may restore products';
  END IF;

  UPDATE public.products
  SET is_active = true
  WHERE id = p_product_id;
END; $$;


--
-- TOC entry 430 (class 1255 OID 24862)
-- Name: product_soft_delete(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.product_soft_delete(p_product_id uuid) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
  IF NOT (public.is_role('hq_admin') OR public.is_role('power_user')) THEN
    RAISE EXCEPTION 'Only HQ Admin / Power User may soft delete products';
  END IF;

  UPDATE public.products
  SET is_active = false
  WHERE id = p_product_id;
END; $$;


--
-- TOC entry 467 (class 1255 OID 21386)
-- Name: set_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.set_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at := now();
  RETURN NEW;
END $$;


--
-- TOC entry 495 (class 1255 OID 22920)
-- Name: set_updated_by(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.set_updated_by() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
  new.updated_by := auth.uid();  -- uses Supabase auth uid
  return new;
end$$;


--
-- TOC entry 393 (class 1255 OID 24867)
-- Name: variant_hard_delete(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.variant_hard_delete(p_variant_id uuid) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
  IF NOT (public.is_role('hq_admin') OR public.is_role('power_user')) THEN
    RAISE EXCEPTION 'Only HQ Admin / Power User may hard delete variants';
  END IF;

  IF public.variant_has_transactions(p_variant_id) THEN
    RAISE EXCEPTION 'Cannot hard delete: variant has transactions (orders exist)';
  END IF;

  DELETE FROM public.product_variants WHERE id = p_variant_id;
END; $$;


--
-- TOC entry 519 (class 1255 OID 23663)
-- Name: variant_has_transactions(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.variant_has_transactions(p_variant_id uuid) RETURNS boolean
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
  rel_exists boolean;
  has_tx boolean := false;
BEGIN
  SELECT EXISTS (
    SELECT 1 FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE n.nspname = 'public' AND c.relname = 'order_items'
  ) INTO rel_exists;

  IF rel_exists THEN
    SELECT EXISTS (
      SELECT 1 FROM public.order_items oi WHERE oi.variant_id = p_variant_id
      LIMIT 1
    ) INTO has_tx;
  END IF;

  RETURN has_tx;
END;
$$;


--
-- TOC entry 503 (class 1255 OID 24866)
-- Name: variant_restore(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.variant_restore(p_variant_id uuid) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
  IF NOT (public.is_role('hq_admin') OR public.is_role('power_user')) THEN
    RAISE EXCEPTION 'Only HQ Admin / Power User may restore variants';
  END IF;

  UPDATE public.product_variants
  SET is_active = true
  WHERE id = p_variant_id;
END; $$;


--
-- TOC entry 466 (class 1255 OID 24865)
-- Name: variant_soft_delete(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.variant_soft_delete(p_variant_id uuid) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
  IF NOT (public.is_role('hq_admin') OR public.is_role('power_user')) THEN
    RAISE EXCEPTION 'Only HQ Admin / Power User may soft delete variants';
  END IF;

  UPDATE public.product_variants
  SET is_active = false
  WHERE id = p_variant_id;
END; $$;


--
-- TOC entry 555 (class 1255 OID 17656)
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
-- TOC entry 396 (class 1255 OID 17161)
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
-- TOC entry 536 (class 1255 OID 18944)
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
            SELECT DISTINCT t.bucket_id,
                unnest(storage.get_prefixes(t.name)) AS name
            FROM unnest(bucket_ids, names) AS t(bucket_id, name)
        ),
        uniq AS (
            SELECT bucket_id,
                   name,
                   storage.get_level(name) AS level
             FROM candidates
             WHERE name <> ''
             GROUP BY bucket_id, name
        ),
        leaf AS (
            SELECT p.bucket_id, p.name, p.level
            FROM storage.prefixes AS p
            JOIN uniq AS u
              ON u.bucket_id = p.bucket_id
                  AND u.name = p.name
                  AND u.level = p.level
            WHERE NOT EXISTS (
                SELECT 1
                FROM storage.objects AS o
                WHERE o.bucket_id = p.bucket_id
                  AND storage.get_level(o.name) = p.level + 1
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
        DELETE FROM storage.prefixes AS p
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
-- TOC entry 464 (class 1255 OID 17657)
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
-- TOC entry 435 (class 1255 OID 17660)
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
-- TOC entry 543 (class 1255 OID 17675)
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
-- TOC entry 455 (class 1255 OID 17124)
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
-- TOC entry 436 (class 1255 OID 17123)
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
-- TOC entry 550 (class 1255 OID 17122)
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
-- TOC entry 415 (class 1255 OID 17638)
-- Name: get_level(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_level(name text) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
SELECT array_length(string_to_array("name", '/'), 1);
$$;


--
-- TOC entry 434 (class 1255 OID 17654)
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
-- TOC entry 469 (class 1255 OID 17655)
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
-- TOC entry 508 (class 1255 OID 17673)
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
-- TOC entry 479 (class 1255 OID 17202)
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
-- TOC entry 527 (class 1255 OID 17165)
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
-- TOC entry 531 (class 1255 OID 18943)
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
-- TOC entry 470 (class 1255 OID 18945)
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
-- TOC entry 438 (class 1255 OID 17659)
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
-- TOC entry 524 (class 1255 OID 18946)
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
-- TOC entry 457 (class 1255 OID 17674)
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
-- TOC entry 488 (class 1255 OID 17219)
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
-- TOC entry 566 (class 1255 OID 18947)
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
-- TOC entry 475 (class 1255 OID 17658)
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
-- TOC entry 510 (class 1255 OID 17141)
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
-- TOC entry 449 (class 1255 OID 17671)
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
-- TOC entry 560 (class 1255 OID 17670)
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
-- TOC entry 511 (class 1255 OID 18942)
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
-- TOC entry 439 (class 1255 OID 17143)
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


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 374 (class 1259 OID 21448)
-- Name: brands; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.brands (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    code text,
    name text NOT NULL,
    name_ci text GENERATED ALWAYS AS (lower(name)) STORED,
    description text,
    image_key text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid DEFAULT public.current_user_id(),
    updated_by uuid
);


--
-- TOC entry 373 (class 1259 OID 21433)
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categories (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    code text NOT NULL,
    name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid DEFAULT public.current_user_id(),
    updated_by uuid,
    name_ci text NOT NULL
);


--
-- TOC entry 384 (class 1259 OID 22414)
-- Name: distributors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.distributors (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    code text NOT NULL,
    name text NOT NULL,
    email text,
    phone text,
    address text,
    negeri_id integer,
    daerah_id integer,
    logo_url text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid DEFAULT public.current_user_id(),
    updated_by uuid
);


--
-- TOC entry 378 (class 1259 OID 21521)
-- Name: manufacturer_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.manufacturer_users (
    manufacturer_id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid DEFAULT public.current_user_id(),
    updated_by uuid
);


--
-- TOC entry 377 (class 1259 OID 21504)
-- Name: manufacturers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.manufacturers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    code text,
    name text NOT NULL,
    name_ci text GENERATED ALWAYS AS (lower(name)) STORED,
    description text,
    email text,
    phone text,
    website text,
    address text,
    address_line2 text,
    city text,
    state_province text,
    country_code text,
    postcode text,
    registration_no text,
    tax_id text,
    notes text,
    image_key text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid DEFAULT public.current_user_id(),
    updated_by uuid
);


--
-- TOC entry 383 (class 1259 OID 22150)
-- Name: master_daerah; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.master_daerah (
    id integer NOT NULL,
    negeri_id integer NOT NULL,
    name text NOT NULL,
    created_by uuid DEFAULT public.current_user_id(),
    updated_by uuid,
    name_ci text GENERATED ALWAYS AS (lower(name)) STORED,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 382 (class 1259 OID 22149)
-- Name: master_daerah_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.master_daerah ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.master_daerah_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 381 (class 1259 OID 22139)
-- Name: master_negeri; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.master_negeri (
    id integer NOT NULL,
    code text NOT NULL,
    name text NOT NULL,
    created_by uuid DEFAULT public.current_user_id(),
    updated_by uuid
);


--
-- TOC entry 375 (class 1259 OID 21465)
-- Name: product_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_groups (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    code text,
    name text NOT NULL,
    name_ci text GENERATED ALWAYS AS (lower(name)) STORED,
    description text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid DEFAULT public.current_user_id(),
    updated_by uuid,
    category_id uuid NOT NULL
);


--
-- TOC entry 376 (class 1259 OID 21482)
-- Name: product_subgroups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_subgroups (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    code text,
    group_id uuid NOT NULL,
    name text NOT NULL,
    name_ci text GENERATED ALWAYS AS (lower(name)) STORED,
    description text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid DEFAULT public.current_user_id(),
    updated_by uuid
);


--
-- TOC entry 380 (class 1259 OID 21574)
-- Name: product_variants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_variants (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    sku text DEFAULT public.generate_sku() NOT NULL,
    flavor_name text NOT NULL,
    flavor_name_ci text GENERATED ALWAYS AS (lower(flavor_name)) STORED,
    nic_strength text,
    nic_strength_ci text GENERATED ALWAYS AS (lower(COALESCE(nic_strength, ''::text))) STORED,
    packaging text,
    packaging_ci text GENERATED ALWAYS AS (lower(COALESCE(packaging, ''::text))) STORED,
    barcode text,
    image_key text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid DEFAULT public.current_user_id(),
    updated_by uuid,
    flavor text,
    flavor_ci text GENERATED ALWAYS AS (lower(btrim(flavor))) STORED
);


--
-- TOC entry 379 (class 1259 OID 21532)
-- Name: products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    category_id uuid NOT NULL,
    brand_id uuid NOT NULL,
    group_id uuid NOT NULL,
    sub_group_id uuid NOT NULL,
    manufacturer_id uuid NOT NULL,
    code text,
    name text NOT NULL,
    name_ci text GENERATED ALWAYS AS (lower(name)) STORED,
    description text,
    image_key text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid DEFAULT public.current_user_id(),
    updated_by uuid
);


--
-- TOC entry 386 (class 1259 OID 22468)
-- Name: shop_distributors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shop_distributors (
    shop_id uuid NOT NULL,
    distributor_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid DEFAULT public.current_user_id(),
    updated_by uuid
);


--
-- TOC entry 385 (class 1259 OID 22441)
-- Name: shops; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shops (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    code text NOT NULL,
    name text NOT NULL,
    email text,
    phone text,
    address text,
    negeri_id integer,
    daerah_id integer,
    latitude numeric(9,6),
    longitude numeric(9,6),
    image_key text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid DEFAULT public.current_user_id(),
    updated_by uuid
);


--
-- TOC entry 343 (class 1259 OID 16546)
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
-- TOC entry 4288 (class 0 OID 0)
-- Dependencies: 343
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- TOC entry 372 (class 1259 OID 17684)
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
-- TOC entry 345 (class 1259 OID 16588)
-- Name: migrations; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- TOC entry 344 (class 1259 OID 16561)
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
-- TOC entry 4289 (class 0 OID 0)
-- Dependencies: 344
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- TOC entry 371 (class 1259 OID 17639)
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
-- TOC entry 367 (class 1259 OID 17167)
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
-- TOC entry 368 (class 1259 OID 17181)
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
-- TOC entry 3839 (class 2606 OID 21461)
-- Name: brands brands_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.brands
    ADD CONSTRAINT brands_code_key UNIQUE (code);


--
-- TOC entry 3841 (class 2606 OID 21463)
-- Name: brands brands_name_ci_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.brands
    ADD CONSTRAINT brands_name_ci_key UNIQUE (name_ci);


--
-- TOC entry 3843 (class 2606 OID 21459)
-- Name: brands brands_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.brands
    ADD CONSTRAINT brands_pkey PRIMARY KEY (id);


--
-- TOC entry 3831 (class 2606 OID 21444)
-- Name: categories categories_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_code_key UNIQUE (code);


--
-- TOC entry 3835 (class 2606 OID 21446)
-- Name: categories categories_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_name_key UNIQUE (name);


--
-- TOC entry 3837 (class 2606 OID 21442)
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- TOC entry 3906 (class 2606 OID 22426)
-- Name: distributors distributors_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.distributors
    ADD CONSTRAINT distributors_code_key UNIQUE (code);


--
-- TOC entry 3912 (class 2606 OID 22424)
-- Name: distributors distributors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.distributors
    ADD CONSTRAINT distributors_pkey PRIMARY KEY (id);


--
-- TOC entry 3872 (class 2606 OID 21526)
-- Name: manufacturer_users manufacturer_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manufacturer_users
    ADD CONSTRAINT manufacturer_users_pkey PRIMARY KEY (manufacturer_id, user_id);


--
-- TOC entry 3866 (class 2606 OID 21517)
-- Name: manufacturers manufacturers_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manufacturers
    ADD CONSTRAINT manufacturers_code_key UNIQUE (code);


--
-- TOC entry 3868 (class 2606 OID 21519)
-- Name: manufacturers manufacturers_name_ci_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manufacturers
    ADD CONSTRAINT manufacturers_name_ci_key UNIQUE (name_ci);


--
-- TOC entry 3870 (class 2606 OID 21515)
-- Name: manufacturers manufacturers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manufacturers
    ADD CONSTRAINT manufacturers_pkey PRIMARY KEY (id);


--
-- TOC entry 3904 (class 2606 OID 22156)
-- Name: master_daerah master_daerah_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.master_daerah
    ADD CONSTRAINT master_daerah_pkey PRIMARY KEY (id);


--
-- TOC entry 3896 (class 2606 OID 22147)
-- Name: master_negeri master_negeri_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.master_negeri
    ADD CONSTRAINT master_negeri_code_key UNIQUE (code);


--
-- TOC entry 3899 (class 2606 OID 22145)
-- Name: master_negeri master_negeri_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.master_negeri
    ADD CONSTRAINT master_negeri_pkey PRIMARY KEY (id);


--
-- TOC entry 3850 (class 2606 OID 23126)
-- Name: product_groups product_groups_category_name_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_groups
    ADD CONSTRAINT product_groups_category_name_uniq UNIQUE (category_id, name_ci);


--
-- TOC entry 3852 (class 2606 OID 21478)
-- Name: product_groups product_groups_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_groups
    ADD CONSTRAINT product_groups_code_key UNIQUE (code);


--
-- TOC entry 3854 (class 2606 OID 21476)
-- Name: product_groups product_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_groups
    ADD CONSTRAINT product_groups_pkey PRIMARY KEY (id);


--
-- TOC entry 3858 (class 2606 OID 21495)
-- Name: product_subgroups product_subgroups_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_subgroups
    ADD CONSTRAINT product_subgroups_code_key UNIQUE (code);


--
-- TOC entry 3860 (class 2606 OID 21497)
-- Name: product_subgroups product_subgroups_group_id_name_ci_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_subgroups
    ADD CONSTRAINT product_subgroups_group_id_name_ci_key UNIQUE (group_id, name_ci);


--
-- TOC entry 3862 (class 2606 OID 21493)
-- Name: product_subgroups product_subgroups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_subgroups
    ADD CONSTRAINT product_subgroups_pkey PRIMARY KEY (id);


--
-- TOC entry 3888 (class 2606 OID 21588)
-- Name: product_variants product_variants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT product_variants_pkey PRIMARY KEY (id);


--
-- TOC entry 3890 (class 2606 OID 21592)
-- Name: product_variants product_variants_product_id_flavor_name_ci_nic_strength_ci__key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT product_variants_product_id_flavor_name_ci_nic_strength_ci__key UNIQUE (product_id, flavor_name_ci, nic_strength_ci, packaging_ci);


--
-- TOC entry 3892 (class 2606 OID 21590)
-- Name: product_variants product_variants_sku_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT product_variants_sku_key UNIQUE (sku);


--
-- TOC entry 3894 (class 2606 OID 23486)
-- Name: product_variants product_variants_unique_flavor_per_product; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT product_variants_unique_flavor_per_product UNIQUE (product_id, flavor_ci);


--
-- TOC entry 3877 (class 2606 OID 23484)
-- Name: products products_brand_group_subgroup_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_brand_group_subgroup_unique UNIQUE (brand_id, group_id, sub_group_id);


--
-- TOC entry 3879 (class 2606 OID 21547)
-- Name: products products_category_id_brand_id_group_id_sub_group_id_manufac_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_brand_id_group_id_sub_group_id_manufac_key UNIQUE (category_id, brand_id, group_id, sub_group_id, manufacturer_id, name_ci);


--
-- TOC entry 3881 (class 2606 OID 21545)
-- Name: products products_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_code_key UNIQUE (code);


--
-- TOC entry 3884 (class 2606 OID 21543)
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- TOC entry 3925 (class 2606 OID 22473)
-- Name: shop_distributors shop_distributors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shop_distributors
    ADD CONSTRAINT shop_distributors_pkey PRIMARY KEY (shop_id, distributor_id);


--
-- TOC entry 3914 (class 2606 OID 22453)
-- Name: shops shops_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shops
    ADD CONSTRAINT shops_code_key UNIQUE (code);


--
-- TOC entry 3921 (class 2606 OID 22451)
-- Name: shops shops_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shops
    ADD CONSTRAINT shops_pkey PRIMARY KEY (id);


--
-- TOC entry 3829 (class 2606 OID 17694)
-- Name: buckets_analytics buckets_analytics_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets_analytics
    ADD CONSTRAINT buckets_analytics_pkey PRIMARY KEY (id);


--
-- TOC entry 3807 (class 2606 OID 16554)
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- TOC entry 3817 (class 2606 OID 16595)
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- TOC entry 3819 (class 2606 OID 16593)
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 3815 (class 2606 OID 16571)
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- TOC entry 3827 (class 2606 OID 17648)
-- Name: prefixes prefixes_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.prefixes
    ADD CONSTRAINT prefixes_pkey PRIMARY KEY (bucket_id, level, name);


--
-- TOC entry 3824 (class 2606 OID 17190)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- TOC entry 3822 (class 2606 OID 17175)
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- TOC entry 3832 (class 1259 OID 23076)
-- Name: categories_code_uniq; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX categories_code_uniq ON public.categories USING btree (code);


--
-- TOC entry 3833 (class 1259 OID 23053)
-- Name: categories_name_ci_uniq; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX categories_name_ci_uniq ON public.categories USING btree (name_ci);


--
-- TOC entry 3907 (class 1259 OID 22439)
-- Name: distributors_daerah_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX distributors_daerah_idx ON public.distributors USING btree (daerah_id);


--
-- TOC entry 3908 (class 1259 OID 22960)
-- Name: distributors_email_uq; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX distributors_email_uq ON public.distributors USING btree (lower(email)) WHERE (email IS NOT NULL);


--
-- TOC entry 3909 (class 1259 OID 22437)
-- Name: distributors_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX distributors_name_idx ON public.distributors USING btree (lower(name));


--
-- TOC entry 3910 (class 1259 OID 22438)
-- Name: distributors_negeri_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX distributors_negeri_idx ON public.distributors USING btree (negeri_id);


--
-- TOC entry 3844 (class 1259 OID 21599)
-- Name: idx_brands_name_ci; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_brands_name_ci ON public.brands USING btree (name_ci);


--
-- TOC entry 3845 (class 1259 OID 21605)
-- Name: idx_brands_name_trgm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_brands_name_trgm ON public.brands USING gin (name public.gin_trgm_ops);


--
-- TOC entry 3846 (class 1259 OID 21600)
-- Name: idx_groups_name_ci; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_groups_name_ci ON public.product_groups USING btree (name_ci);


--
-- TOC entry 3847 (class 1259 OID 21606)
-- Name: idx_groups_name_trgm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_groups_name_trgm ON public.product_groups USING gin (name public.gin_trgm_ops);


--
-- TOC entry 3863 (class 1259 OID 21602)
-- Name: idx_manufacturers_name_ci; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_manufacturers_name_ci ON public.manufacturers USING btree (name_ci);


--
-- TOC entry 3864 (class 1259 OID 21608)
-- Name: idx_manufacturers_name_trgm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_manufacturers_name_trgm ON public.manufacturers USING gin (name public.gin_trgm_ops);


--
-- TOC entry 3874 (class 1259 OID 21603)
-- Name: idx_products_name_ci; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_products_name_ci ON public.products USING btree (name_ci);


--
-- TOC entry 3875 (class 1259 OID 21609)
-- Name: idx_products_name_trgm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_products_name_trgm ON public.products USING gin (name public.gin_trgm_ops);


--
-- TOC entry 3855 (class 1259 OID 21601)
-- Name: idx_subgroups_name_ci; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_subgroups_name_ci ON public.product_subgroups USING btree (name_ci);


--
-- TOC entry 3856 (class 1259 OID 21607)
-- Name: idx_subgroups_name_trgm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_subgroups_name_trgm ON public.product_subgroups USING gin (name public.gin_trgm_ops);


--
-- TOC entry 3885 (class 1259 OID 21604)
-- Name: idx_variants_flavor_ci; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_variants_flavor_ci ON public.product_variants USING btree (flavor_name_ci);


--
-- TOC entry 3873 (class 1259 OID 23322)
-- Name: manufacturer_users_user_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX manufacturer_users_user_idx ON public.manufacturer_users USING btree (user_id);


--
-- TOC entry 3900 (class 1259 OID 22163)
-- Name: master_daerah_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX master_daerah_name_idx ON public.master_daerah USING btree (lower(name));


--
-- TOC entry 3901 (class 1259 OID 22162)
-- Name: master_daerah_negeri_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX master_daerah_negeri_idx ON public.master_daerah USING btree (negeri_id);


--
-- TOC entry 3902 (class 1259 OID 25073)
-- Name: master_daerah_negeri_name_ci_uniq; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX master_daerah_negeri_name_ci_uniq ON public.master_daerah USING btree (negeri_id, name_ci);


--
-- TOC entry 3897 (class 1259 OID 22148)
-- Name: master_negeri_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX master_negeri_name_idx ON public.master_negeri USING btree (lower(name));


--
-- TOC entry 3848 (class 1259 OID 23127)
-- Name: product_groups_category_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX product_groups_category_idx ON public.product_groups USING btree (category_id);


--
-- TOC entry 3886 (class 1259 OID 24850)
-- Name: product_variants_is_active_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX product_variants_is_active_idx ON public.product_variants USING btree (is_active);


--
-- TOC entry 3882 (class 1259 OID 24849)
-- Name: products_is_active_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX products_is_active_idx ON public.products USING btree (is_active);


--
-- TOC entry 3922 (class 1259 OID 22485)
-- Name: sd_dist_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sd_dist_idx ON public.shop_distributors USING btree (distributor_id);


--
-- TOC entry 3923 (class 1259 OID 22484)
-- Name: sd_shop_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sd_shop_idx ON public.shop_distributors USING btree (shop_id);


--
-- TOC entry 3915 (class 1259 OID 23701)
-- Name: shops_code_uniq; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX shops_code_uniq ON public.shops USING btree (code);


--
-- TOC entry 3916 (class 1259 OID 22466)
-- Name: shops_daerah_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX shops_daerah_idx ON public.shops USING btree (daerah_id);


--
-- TOC entry 3917 (class 1259 OID 22961)
-- Name: shops_email_uq; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX shops_email_uq ON public.shops USING btree (lower(email)) WHERE (email IS NOT NULL);


--
-- TOC entry 3918 (class 1259 OID 22464)
-- Name: shops_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX shops_name_idx ON public.shops USING btree (lower(name));


--
-- TOC entry 3919 (class 1259 OID 22465)
-- Name: shops_negeri_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX shops_negeri_idx ON public.shops USING btree (negeri_id);


--
-- TOC entry 3805 (class 1259 OID 16560)
-- Name: bname; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- TOC entry 3808 (class 1259 OID 16582)
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- TOC entry 3820 (class 1259 OID 17201)
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- TOC entry 3809 (class 1259 OID 17666)
-- Name: idx_name_bucket_level_unique; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX idx_name_bucket_level_unique ON storage.objects USING btree (name COLLATE "C", bucket_id, level);


--
-- TOC entry 3810 (class 1259 OID 17166)
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- TOC entry 3811 (class 1259 OID 17668)
-- Name: idx_objects_lower_name; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_lower_name ON storage.objects USING btree ((path_tokens[level]), lower(name) text_pattern_ops, bucket_id, level);


--
-- TOC entry 3825 (class 1259 OID 17669)
-- Name: idx_prefixes_lower_name; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_prefixes_lower_name ON storage.prefixes USING btree (bucket_id, level, ((string_to_array(name, '/'::text))[level]), lower(name) text_pattern_ops);


--
-- TOC entry 3812 (class 1259 OID 16583)
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- TOC entry 3813 (class 1259 OID 17667)
-- Name: objects_bucket_id_level_idx; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX objects_bucket_id_level_idx ON storage.objects USING btree (bucket_id, level, name COLLATE "C");


--
-- TOC entry 3961 (class 2620 OID 22925)
-- Name: brands set_updated_at_trg; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER set_updated_at_trg BEFORE UPDATE ON public.brands FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 3958 (class 2620 OID 22922)
-- Name: categories set_updated_at_trg; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER set_updated_at_trg BEFORE UPDATE ON public.categories FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 3985 (class 2620 OID 22946)
-- Name: distributors set_updated_at_trg; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER set_updated_at_trg BEFORE UPDATE ON public.distributors FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 3973 (class 2620 OID 22937)
-- Name: manufacturer_users set_updated_at_trg; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER set_updated_at_trg BEFORE UPDATE ON public.manufacturer_users FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 3970 (class 2620 OID 22934)
-- Name: manufacturers set_updated_at_trg; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER set_updated_at_trg BEFORE UPDATE ON public.manufacturers FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 3983 (class 2620 OID 22958)
-- Name: master_daerah set_updated_at_trg; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER set_updated_at_trg BEFORE UPDATE ON public.master_daerah FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 3981 (class 2620 OID 22955)
-- Name: master_negeri set_updated_at_trg; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER set_updated_at_trg BEFORE UPDATE ON public.master_negeri FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 3964 (class 2620 OID 22928)
-- Name: product_groups set_updated_at_trg; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER set_updated_at_trg BEFORE UPDATE ON public.product_groups FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 3967 (class 2620 OID 22931)
-- Name: product_subgroups set_updated_at_trg; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER set_updated_at_trg BEFORE UPDATE ON public.product_subgroups FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 3978 (class 2620 OID 22943)
-- Name: product_variants set_updated_at_trg; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER set_updated_at_trg BEFORE UPDATE ON public.product_variants FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 3975 (class 2620 OID 22940)
-- Name: products set_updated_at_trg; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER set_updated_at_trg BEFORE UPDATE ON public.products FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 3991 (class 2620 OID 22952)
-- Name: shop_distributors set_updated_at_trg; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER set_updated_at_trg BEFORE UPDATE ON public.shop_distributors FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 3988 (class 2620 OID 22949)
-- Name: shops set_updated_at_trg; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER set_updated_at_trg BEFORE UPDATE ON public.shops FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 3962 (class 2620 OID 22926)
-- Name: brands set_updated_by_trg; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER set_updated_by_trg BEFORE UPDATE ON public.brands FOR EACH ROW EXECUTE FUNCTION public.set_updated_by();


--
-- TOC entry 3959 (class 2620 OID 22923)
-- Name: categories set_updated_by_trg; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER set_updated_by_trg BEFORE UPDATE ON public.categories FOR EACH ROW EXECUTE FUNCTION public.set_updated_by();


--
-- TOC entry 3986 (class 2620 OID 22947)
-- Name: distributors set_updated_by_trg; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER set_updated_by_trg BEFORE UPDATE ON public.distributors FOR EACH ROW EXECUTE FUNCTION public.set_updated_by();


--
-- TOC entry 3974 (class 2620 OID 22938)
-- Name: manufacturer_users set_updated_by_trg; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER set_updated_by_trg BEFORE UPDATE ON public.manufacturer_users FOR EACH ROW EXECUTE FUNCTION public.set_updated_by();


--
-- TOC entry 3971 (class 2620 OID 22935)
-- Name: manufacturers set_updated_by_trg; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER set_updated_by_trg BEFORE UPDATE ON public.manufacturers FOR EACH ROW EXECUTE FUNCTION public.set_updated_by();


--
-- TOC entry 3984 (class 2620 OID 22959)
-- Name: master_daerah set_updated_by_trg; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER set_updated_by_trg BEFORE UPDATE ON public.master_daerah FOR EACH ROW EXECUTE FUNCTION public.set_updated_by();


--
-- TOC entry 3982 (class 2620 OID 22956)
-- Name: master_negeri set_updated_by_trg; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER set_updated_by_trg BEFORE UPDATE ON public.master_negeri FOR EACH ROW EXECUTE FUNCTION public.set_updated_by();


--
-- TOC entry 3965 (class 2620 OID 22929)
-- Name: product_groups set_updated_by_trg; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER set_updated_by_trg BEFORE UPDATE ON public.product_groups FOR EACH ROW EXECUTE FUNCTION public.set_updated_by();


--
-- TOC entry 3968 (class 2620 OID 22932)
-- Name: product_subgroups set_updated_by_trg; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER set_updated_by_trg BEFORE UPDATE ON public.product_subgroups FOR EACH ROW EXECUTE FUNCTION public.set_updated_by();


--
-- TOC entry 3979 (class 2620 OID 22944)
-- Name: product_variants set_updated_by_trg; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER set_updated_by_trg BEFORE UPDATE ON public.product_variants FOR EACH ROW EXECUTE FUNCTION public.set_updated_by();


--
-- TOC entry 3976 (class 2620 OID 22941)
-- Name: products set_updated_by_trg; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER set_updated_by_trg BEFORE UPDATE ON public.products FOR EACH ROW EXECUTE FUNCTION public.set_updated_by();


--
-- TOC entry 3992 (class 2620 OID 22953)
-- Name: shop_distributors set_updated_by_trg; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER set_updated_by_trg BEFORE UPDATE ON public.shop_distributors FOR EACH ROW EXECUTE FUNCTION public.set_updated_by();


--
-- TOC entry 3989 (class 2620 OID 22950)
-- Name: shops set_updated_by_trg; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER set_updated_by_trg BEFORE UPDATE ON public.shops FOR EACH ROW EXECUTE FUNCTION public.set_updated_by();


--
-- TOC entry 3963 (class 2620 OID 21464)
-- Name: brands trg_brands_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_brands_updated_at BEFORE UPDATE ON public.brands FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 3960 (class 2620 OID 21447)
-- Name: categories trg_categories_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_categories_updated_at BEFORE UPDATE ON public.categories FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 3987 (class 2620 OID 24912)
-- Name: distributors trg_distributors_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_distributors_updated_at BEFORE UPDATE ON public.distributors FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 3966 (class 2620 OID 21481)
-- Name: product_groups trg_groups_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_groups_updated_at BEFORE UPDATE ON public.product_groups FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 3972 (class 2620 OID 21520)
-- Name: manufacturers trg_manufacturers_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_manufacturers_updated_at BEFORE UPDATE ON public.manufacturers FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 3977 (class 2620 OID 21573)
-- Name: products trg_products_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_products_updated_at BEFORE UPDATE ON public.products FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 3990 (class 2620 OID 24913)
-- Name: shops trg_shops_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_shops_updated_at BEFORE UPDATE ON public.shops FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 3969 (class 2620 OID 21503)
-- Name: product_subgroups trg_subgroups_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_subgroups_updated_at BEFORE UPDATE ON public.product_subgroups FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 3980 (class 2620 OID 21598)
-- Name: product_variants trg_variants_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_variants_updated_at BEFORE UPDATE ON public.product_variants FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 3951 (class 2620 OID 17676)
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- TOC entry 3952 (class 2620 OID 18948)
-- Name: objects objects_delete_cleanup; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER objects_delete_cleanup AFTER DELETE ON storage.objects REFERENCING OLD TABLE AS deleted FOR EACH STATEMENT EXECUTE FUNCTION storage.objects_delete_cleanup();


--
-- TOC entry 3953 (class 2620 OID 17662)
-- Name: objects objects_insert_create_prefix; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER objects_insert_create_prefix BEFORE INSERT ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.objects_insert_prefix_trigger();


--
-- TOC entry 3954 (class 2620 OID 18950)
-- Name: objects objects_update_cleanup; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER objects_update_cleanup AFTER UPDATE ON storage.objects REFERENCING OLD TABLE AS old_rows NEW TABLE AS new_rows FOR EACH STATEMENT EXECUTE FUNCTION storage.objects_update_cleanup();


--
-- TOC entry 3956 (class 2620 OID 17672)
-- Name: prefixes prefixes_create_hierarchy; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER prefixes_create_hierarchy BEFORE INSERT ON storage.prefixes FOR EACH ROW WHEN ((pg_trigger_depth() < 1)) EXECUTE FUNCTION storage.prefixes_insert_trigger();


--
-- TOC entry 3957 (class 2620 OID 18949)
-- Name: prefixes prefixes_delete_cleanup; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER prefixes_delete_cleanup AFTER DELETE ON storage.prefixes REFERENCING OLD TABLE AS deleted FOR EACH STATEMENT EXECUTE FUNCTION storage.prefixes_delete_cleanup();


--
-- TOC entry 3955 (class 2620 OID 17144)
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- TOC entry 3941 (class 2606 OID 22967)
-- Name: distributors distributors_daerah_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.distributors
    ADD CONSTRAINT distributors_daerah_fk FOREIGN KEY (daerah_id) REFERENCES public.master_daerah(id);


--
-- TOC entry 3942 (class 2606 OID 22432)
-- Name: distributors distributors_daerah_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.distributors
    ADD CONSTRAINT distributors_daerah_id_fkey FOREIGN KEY (daerah_id) REFERENCES public.master_daerah(id) ON DELETE SET NULL;


--
-- TOC entry 3943 (class 2606 OID 22962)
-- Name: distributors distributors_negeri_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.distributors
    ADD CONSTRAINT distributors_negeri_fk FOREIGN KEY (negeri_id) REFERENCES public.master_negeri(id);


--
-- TOC entry 3944 (class 2606 OID 22427)
-- Name: distributors distributors_negeri_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.distributors
    ADD CONSTRAINT distributors_negeri_id_fkey FOREIGN KEY (negeri_id) REFERENCES public.master_negeri(id) ON DELETE SET NULL;


--
-- TOC entry 3933 (class 2606 OID 21527)
-- Name: manufacturer_users manufacturer_users_manufacturer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manufacturer_users
    ADD CONSTRAINT manufacturer_users_manufacturer_id_fkey FOREIGN KEY (manufacturer_id) REFERENCES public.manufacturers(id) ON DELETE CASCADE;


--
-- TOC entry 3940 (class 2606 OID 22157)
-- Name: master_daerah master_daerah_negeri_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.master_daerah
    ADD CONSTRAINT master_daerah_negeri_id_fkey FOREIGN KEY (negeri_id) REFERENCES public.master_negeri(id) ON DELETE CASCADE;


--
-- TOC entry 3931 (class 2606 OID 23120)
-- Name: product_groups product_groups_category_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_groups
    ADD CONSTRAINT product_groups_category_fk FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE RESTRICT;


--
-- TOC entry 3932 (class 2606 OID 21498)
-- Name: product_subgroups product_subgroups_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_subgroups
    ADD CONSTRAINT product_subgroups_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.product_groups(id) ON DELETE RESTRICT;


--
-- TOC entry 3939 (class 2606 OID 21593)
-- Name: product_variants product_variants_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT product_variants_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- TOC entry 3934 (class 2606 OID 21553)
-- Name: products products_brand_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_brand_id_fkey FOREIGN KEY (brand_id) REFERENCES public.brands(id) ON DELETE RESTRICT;


--
-- TOC entry 3935 (class 2606 OID 21548)
-- Name: products products_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE RESTRICT;


--
-- TOC entry 3936 (class 2606 OID 21558)
-- Name: products products_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.product_groups(id) ON DELETE RESTRICT;


--
-- TOC entry 3937 (class 2606 OID 21568)
-- Name: products products_manufacturer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_manufacturer_id_fkey FOREIGN KEY (manufacturer_id) REFERENCES public.manufacturers(id) ON DELETE RESTRICT;


--
-- TOC entry 3938 (class 2606 OID 21563)
-- Name: products products_sub_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_sub_group_id_fkey FOREIGN KEY (sub_group_id) REFERENCES public.product_subgroups(id) ON DELETE RESTRICT;


--
-- TOC entry 3949 (class 2606 OID 22479)
-- Name: shop_distributors shop_distributors_distributor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shop_distributors
    ADD CONSTRAINT shop_distributors_distributor_id_fkey FOREIGN KEY (distributor_id) REFERENCES public.distributors(id) ON DELETE CASCADE;


--
-- TOC entry 3950 (class 2606 OID 22474)
-- Name: shop_distributors shop_distributors_shop_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shop_distributors
    ADD CONSTRAINT shop_distributors_shop_id_fkey FOREIGN KEY (shop_id) REFERENCES public.shops(id) ON DELETE CASCADE;


--
-- TOC entry 3945 (class 2606 OID 22977)
-- Name: shops shops_daerah_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shops
    ADD CONSTRAINT shops_daerah_fk FOREIGN KEY (daerah_id) REFERENCES public.master_daerah(id);


--
-- TOC entry 3946 (class 2606 OID 22459)
-- Name: shops shops_daerah_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shops
    ADD CONSTRAINT shops_daerah_id_fkey FOREIGN KEY (daerah_id) REFERENCES public.master_daerah(id) ON DELETE SET NULL;


--
-- TOC entry 3947 (class 2606 OID 22972)
-- Name: shops shops_negeri_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shops
    ADD CONSTRAINT shops_negeri_fk FOREIGN KEY (negeri_id) REFERENCES public.master_negeri(id);


--
-- TOC entry 3948 (class 2606 OID 22454)
-- Name: shops shops_negeri_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shops
    ADD CONSTRAINT shops_negeri_id_fkey FOREIGN KEY (negeri_id) REFERENCES public.master_negeri(id) ON DELETE SET NULL;


--
-- TOC entry 3926 (class 2606 OID 16572)
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 3930 (class 2606 OID 17649)
-- Name: prefixes prefixes_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.prefixes
    ADD CONSTRAINT "prefixes_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 3927 (class 2606 OID 17176)
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 3928 (class 2606 OID 17196)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 3929 (class 2606 OID 17191)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- TOC entry 4191 (class 3256 OID 21948)
-- Name: brands admin_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY admin_all ON public.brands TO authenticated USING (app.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text])) WITH CHECK (app.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text]));


--
-- TOC entry 4190 (class 3256 OID 21947)
-- Name: categories admin_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY admin_all ON public.categories TO authenticated USING (app.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text])) WITH CHECK (app.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text]));


--
-- TOC entry 4189 (class 3256 OID 21946)
-- Name: manufacturers admin_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY admin_all ON public.manufacturers TO authenticated USING (app.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text])) WITH CHECK (app.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text]));


--
-- TOC entry 4192 (class 3256 OID 21949)
-- Name: products admin_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY admin_all ON public.products TO authenticated USING (app.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text])) WITH CHECK (app.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text]));


--
-- TOC entry 4168 (class 3256 OID 21701)
-- Name: brands admin_all_hq_power; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY admin_all_hq_power ON public.brands TO authenticated USING (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text])) WITH CHECK (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text]));


--
-- TOC entry 4167 (class 3256 OID 21700)
-- Name: categories admin_all_hq_power; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY admin_all_hq_power ON public.categories TO authenticated USING (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text])) WITH CHECK (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text]));


--
-- TOC entry 4172 (class 3256 OID 21705)
-- Name: manufacturer_users admin_all_hq_power; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY admin_all_hq_power ON public.manufacturer_users TO authenticated USING (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text])) WITH CHECK (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text]));


--
-- TOC entry 4171 (class 3256 OID 21704)
-- Name: manufacturers admin_all_hq_power; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY admin_all_hq_power ON public.manufacturers TO authenticated USING (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text])) WITH CHECK (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text]));


--
-- TOC entry 4169 (class 3256 OID 21702)
-- Name: product_groups admin_all_hq_power; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY admin_all_hq_power ON public.product_groups TO authenticated USING (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text])) WITH CHECK (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text]));


--
-- TOC entry 4170 (class 3256 OID 21703)
-- Name: product_subgroups admin_all_hq_power; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY admin_all_hq_power ON public.product_subgroups TO authenticated USING (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text])) WITH CHECK (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text]));


--
-- TOC entry 4174 (class 3256 OID 21707)
-- Name: product_variants admin_all_hq_power; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY admin_all_hq_power ON public.product_variants TO authenticated USING (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text])) WITH CHECK (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text]));


--
-- TOC entry 4173 (class 3256 OID 21706)
-- Name: products admin_all_hq_power; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY admin_all_hq_power ON public.products TO authenticated USING (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text])) WITH CHECK (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text]));


--
-- TOC entry 4149 (class 0 OID 21448)
-- Dependencies: 374
-- Name: brands; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.brands ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4232 (class 3256 OID 22874)
-- Name: brands brands_read_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY brands_read_all ON public.brands FOR SELECT TO authenticated USING (true);


--
-- TOC entry 4233 (class 3256 OID 22875)
-- Name: brands brands_write_admins; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY brands_write_admins ON public.brands TO authenticated USING (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text])) WITH CHECK (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text]));


--
-- TOC entry 4148 (class 0 OID 21433)
-- Dependencies: 373
-- Name: categories; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4219 (class 3256 OID 22872)
-- Name: categories categories_read_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY categories_read_all ON public.categories FOR SELECT TO authenticated USING (true);


--
-- TOC entry 4165 (class 3256 OID 25138)
-- Name: categories categories_read_public; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY categories_read_public ON public.categories FOR SELECT TO anon USING (true);


--
-- TOC entry 4231 (class 3256 OID 22873)
-- Name: categories categories_write_admins; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY categories_write_admins ON public.categories TO authenticated USING (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text])) WITH CHECK (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text]));


--
-- TOC entry 4204 (class 3256 OID 22167)
-- Name: master_daerah daerah_admin_write; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY daerah_admin_write ON public.master_daerah TO authenticated USING (app.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text])) WITH CHECK (app.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text]));


--
-- TOC entry 4202 (class 3256 OID 22165)
-- Name: master_daerah daerah_read_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY daerah_read_all ON public.master_daerah FOR SELECT TO authenticated, anon USING (true);


--
-- TOC entry 4208 (class 3256 OID 22489)
-- Name: distributors distributor_self_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY distributor_self_select ON public.distributors FOR SELECT TO authenticated USING ((id = app.claim_uuid('distributor_id'::text)));


--
-- TOC entry 4209 (class 3256 OID 22490)
-- Name: distributors distributor_self_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY distributor_self_update ON public.distributors FOR UPDATE TO authenticated USING ((id = app.claim_uuid('distributor_id'::text))) WITH CHECK ((id = app.claim_uuid('distributor_id'::text)));


--
-- TOC entry 4158 (class 0 OID 22414)
-- Dependencies: 384
-- Name: distributors; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.distributors ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4205 (class 3256 OID 22486)
-- Name: distributors distributors_admin_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY distributors_admin_all ON public.distributors TO authenticated USING (app.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text])) WITH CHECK (app.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text]));


--
-- TOC entry 4241 (class 3256 OID 22888)
-- Name: distributors distributors_read_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY distributors_read_all ON public.distributors FOR SELECT TO authenticated USING (true);


--
-- TOC entry 4242 (class 3256 OID 22889)
-- Name: distributors distributors_write_admins; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY distributors_write_admins ON public.distributors TO authenticated USING (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text])) WITH CHECK (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text]));


--
-- TOC entry 4188 (class 3256 OID 21630)
-- Name: manufacturers manu_update_self; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY manu_update_self ON public.manufacturers FOR UPDATE TO authenticated USING ((public.is_role('manufacturer'::text) AND (id IN ( SELECT manufacturer_users.manufacturer_id
   FROM public.manufacturer_users
  WHERE (manufacturer_users.user_id = auth.uid()))))) WITH CHECK ((public.is_role('manufacturer'::text) AND (id IN ( SELECT manufacturer_users.manufacturer_id
   FROM public.manufacturer_users
  WHERE (manufacturer_users.user_id = auth.uid())))));


--
-- TOC entry 4153 (class 0 OID 21521)
-- Dependencies: 378
-- Name: manufacturer_users; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.manufacturer_users ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4227 (class 3256 OID 23333)
-- Name: manufacturer_users manufacturer_users_admin_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY manufacturer_users_admin_delete ON public.manufacturer_users FOR DELETE TO authenticated USING ((public.is_role('hq_admin'::text) OR public.is_role('power_user'::text)));


--
-- TOC entry 4262 (class 3256 OID 23331)
-- Name: manufacturer_users manufacturer_users_admin_read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY manufacturer_users_admin_read ON public.manufacturer_users FOR SELECT TO authenticated USING ((public.is_role('hq_admin'::text) OR public.is_role('power_user'::text)));


--
-- TOC entry 4211 (class 3256 OID 23332)
-- Name: manufacturer_users manufacturer_users_admin_write; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY manufacturer_users_admin_write ON public.manufacturer_users FOR INSERT TO authenticated WITH CHECK ((public.is_role('hq_admin'::text) OR public.is_role('power_user'::text)));


--
-- TOC entry 4224 (class 3256 OID 22882)
-- Name: manufacturer_users manufacturer_users_read_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY manufacturer_users_read_all ON public.manufacturer_users FOR SELECT TO authenticated USING (true);


--
-- TOC entry 4225 (class 3256 OID 22883)
-- Name: manufacturer_users manufacturer_users_write_admins; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY manufacturer_users_write_admins ON public.manufacturer_users TO authenticated USING (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text])) WITH CHECK (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text]));


--
-- TOC entry 4152 (class 0 OID 21504)
-- Dependencies: 377
-- Name: manufacturers; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.manufacturers ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4238 (class 3256 OID 22880)
-- Name: manufacturers manufacturers_read_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY manufacturers_read_all ON public.manufacturers FOR SELECT TO authenticated USING (true);


--
-- TOC entry 4254 (class 3256 OID 23323)
-- Name: manufacturers manufacturers_update_self; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY manufacturers_update_self ON public.manufacturers FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.manufacturer_users mu
  WHERE ((mu.user_id = auth.uid()) AND (mu.manufacturer_id = manufacturers.id))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.manufacturer_users mu
  WHERE ((mu.user_id = auth.uid()) AND (mu.manufacturer_id = manufacturers.id)))));


--
-- TOC entry 4239 (class 3256 OID 22881)
-- Name: manufacturers manufacturers_write_admins; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY manufacturers_write_admins ON public.manufacturers TO authenticated USING (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text])) WITH CHECK (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text]));


--
-- TOC entry 4157 (class 0 OID 22150)
-- Dependencies: 383
-- Name: master_daerah; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.master_daerah ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4228 (class 3256 OID 22896)
-- Name: master_daerah master_daerah_read_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY master_daerah_read_all ON public.master_daerah FOR SELECT TO authenticated USING (true);


--
-- TOC entry 4166 (class 3256 OID 25139)
-- Name: master_daerah master_daerah_read_public; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY master_daerah_read_public ON public.master_daerah FOR SELECT TO anon USING (true);


--
-- TOC entry 4229 (class 3256 OID 22897)
-- Name: master_daerah master_daerah_write_admins; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY master_daerah_write_admins ON public.master_daerah TO authenticated USING (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text])) WITH CHECK (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text]));


--
-- TOC entry 4156 (class 0 OID 22139)
-- Dependencies: 381
-- Name: master_negeri; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.master_negeri ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4247 (class 3256 OID 22894)
-- Name: master_negeri master_negeri_read_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY master_negeri_read_all ON public.master_negeri FOR SELECT TO authenticated USING (true);


--
-- TOC entry 4248 (class 3256 OID 22895)
-- Name: master_negeri master_negeri_write_admins; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY master_negeri_write_admins ON public.master_negeri TO authenticated USING (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text])) WITH CHECK (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text]));


--
-- TOC entry 4181 (class 3256 OID 21623)
-- Name: brands md_admin_all_brands; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY md_admin_all_brands ON public.brands TO authenticated USING (public.is_role('hq_admin'::text)) WITH CHECK (public.is_role('hq_admin'::text));


--
-- TOC entry 4180 (class 3256 OID 21622)
-- Name: categories md_admin_all_categories; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY md_admin_all_categories ON public.categories TO authenticated USING (public.is_role('hq_admin'::text)) WITH CHECK (public.is_role('hq_admin'::text));


--
-- TOC entry 4185 (class 3256 OID 21627)
-- Name: manufacturer_users md_admin_all_manufacturer_users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY md_admin_all_manufacturer_users ON public.manufacturer_users TO authenticated USING (public.is_role('hq_admin'::text)) WITH CHECK (public.is_role('hq_admin'::text));


--
-- TOC entry 4184 (class 3256 OID 21626)
-- Name: manufacturers md_admin_all_manufacturers; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY md_admin_all_manufacturers ON public.manufacturers TO authenticated USING (public.is_role('hq_admin'::text)) WITH CHECK (public.is_role('hq_admin'::text));


--
-- TOC entry 4182 (class 3256 OID 21624)
-- Name: product_groups md_admin_all_product_groups; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY md_admin_all_product_groups ON public.product_groups TO authenticated USING (public.is_role('hq_admin'::text)) WITH CHECK (public.is_role('hq_admin'::text));


--
-- TOC entry 4183 (class 3256 OID 21625)
-- Name: product_subgroups md_admin_all_product_subgroups; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY md_admin_all_product_subgroups ON public.product_subgroups TO authenticated USING (public.is_role('hq_admin'::text)) WITH CHECK (public.is_role('hq_admin'::text));


--
-- TOC entry 4187 (class 3256 OID 21629)
-- Name: product_variants md_admin_all_product_variants; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY md_admin_all_product_variants ON public.product_variants TO authenticated USING (public.is_role('hq_admin'::text)) WITH CHECK (public.is_role('hq_admin'::text));


--
-- TOC entry 4186 (class 3256 OID 21628)
-- Name: products md_admin_all_products; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY md_admin_all_products ON public.products TO authenticated USING (public.is_role('hq_admin'::text)) WITH CHECK (public.is_role('hq_admin'::text));


--
-- TOC entry 4163 (class 3256 OID 21613)
-- Name: brands md_read_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY md_read_all ON public.brands FOR SELECT TO authenticated USING (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text, 'manufacturer'::text, 'distributor'::text, 'shop'::text]));


--
-- TOC entry 4162 (class 3256 OID 21612)
-- Name: categories md_read_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY md_read_all ON public.categories FOR SELECT TO authenticated USING (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text, 'manufacturer'::text, 'distributor'::text, 'shop'::text]));


--
-- TOC entry 4177 (class 3256 OID 21617)
-- Name: manufacturer_users md_read_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY md_read_all ON public.manufacturer_users FOR SELECT TO authenticated USING (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text, 'manufacturer'::text, 'distributor'::text, 'shop'::text]));


--
-- TOC entry 4176 (class 3256 OID 21616)
-- Name: manufacturers md_read_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY md_read_all ON public.manufacturers FOR SELECT TO authenticated USING (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text, 'manufacturer'::text, 'distributor'::text, 'shop'::text]));


--
-- TOC entry 4164 (class 3256 OID 21614)
-- Name: product_groups md_read_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY md_read_all ON public.product_groups FOR SELECT TO authenticated USING (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text, 'manufacturer'::text, 'distributor'::text, 'shop'::text]));


--
-- TOC entry 4175 (class 3256 OID 21615)
-- Name: product_subgroups md_read_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY md_read_all ON public.product_subgroups FOR SELECT TO authenticated USING (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text, 'manufacturer'::text, 'distributor'::text, 'shop'::text]));


--
-- TOC entry 4179 (class 3256 OID 21619)
-- Name: product_variants md_read_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY md_read_all ON public.product_variants FOR SELECT TO authenticated USING (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text, 'manufacturer'::text, 'distributor'::text, 'shop'::text]));


--
-- TOC entry 4178 (class 3256 OID 21618)
-- Name: products md_read_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY md_read_all ON public.products FOR SELECT TO authenticated USING (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text, 'manufacturer'::text, 'distributor'::text, 'shop'::text]));


--
-- TOC entry 4200 (class 3256 OID 21959)
-- Name: products mfg_products_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY mfg_products_delete ON public.products FOR DELETE TO authenticated USING ((manufacturer_id = app.jwt_claim_uuid('manufacturer_id'::text)));


--
-- TOC entry 4198 (class 3256 OID 21957)
-- Name: products mfg_products_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY mfg_products_insert ON public.products FOR INSERT TO authenticated WITH CHECK ((manufacturer_id = app.jwt_claim_uuid('manufacturer_id'::text)));


--
-- TOC entry 4197 (class 3256 OID 21956)
-- Name: products mfg_products_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY mfg_products_select ON public.products FOR SELECT TO authenticated USING ((manufacturer_id = app.jwt_claim_uuid('manufacturer_id'::text)));


--
-- TOC entry 4199 (class 3256 OID 21958)
-- Name: products mfg_products_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY mfg_products_update ON public.products FOR UPDATE TO authenticated USING ((manufacturer_id = app.jwt_claim_uuid('manufacturer_id'::text))) WITH CHECK ((manufacturer_id = app.jwt_claim_uuid('manufacturer_id'::text)));


--
-- TOC entry 4195 (class 3256 OID 21954)
-- Name: manufacturers mfg_self_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY mfg_self_select ON public.manufacturers FOR SELECT TO authenticated USING ((id = app.jwt_claim_uuid('manufacturer_id'::text)));


--
-- TOC entry 4196 (class 3256 OID 21955)
-- Name: manufacturers mfg_self_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY mfg_self_update ON public.manufacturers FOR UPDATE TO authenticated USING ((id = app.jwt_claim_uuid('manufacturer_id'::text))) WITH CHECK ((id = app.jwt_claim_uuid('manufacturer_id'::text)));


--
-- TOC entry 4203 (class 3256 OID 22166)
-- Name: master_negeri negeri_admin_write; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY negeri_admin_write ON public.master_negeri TO authenticated USING (app.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text])) WITH CHECK (app.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text]));


--
-- TOC entry 4201 (class 3256 OID 22164)
-- Name: master_negeri negeri_read_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY negeri_read_all ON public.master_negeri FOR SELECT TO authenticated, anon USING (true);


--
-- TOC entry 4220 (class 3256 OID 21632)
-- Name: products prod_insert_manu; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY prod_insert_manu ON public.products FOR INSERT TO authenticated WITH CHECK ((public.is_role('manufacturer'::text) AND (manufacturer_id IN ( SELECT manufacturer_users.manufacturer_id
   FROM public.manufacturer_users
  WHERE (manufacturer_users.user_id = auth.uid())))));


--
-- TOC entry 4221 (class 3256 OID 21633)
-- Name: products prod_update_manu; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY prod_update_manu ON public.products FOR UPDATE TO authenticated USING ((public.is_role('manufacturer'::text) AND (manufacturer_id IN ( SELECT manufacturer_users.manufacturer_id
   FROM public.manufacturer_users
  WHERE (manufacturer_users.user_id = auth.uid()))))) WITH CHECK ((public.is_role('manufacturer'::text) AND (manufacturer_id IN ( SELECT manufacturer_users.manufacturer_id
   FROM public.manufacturer_users
  WHERE (manufacturer_users.user_id = auth.uid())))));


--
-- TOC entry 4150 (class 0 OID 21465)
-- Dependencies: 375
-- Name: product_groups; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.product_groups ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4234 (class 3256 OID 22876)
-- Name: product_groups product_groups_read_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY product_groups_read_all ON public.product_groups FOR SELECT TO authenticated USING (true);


--
-- TOC entry 4235 (class 3256 OID 22877)
-- Name: product_groups product_groups_write_admins; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY product_groups_write_admins ON public.product_groups TO authenticated USING (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text])) WITH CHECK (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text]));


--
-- TOC entry 4151 (class 0 OID 21482)
-- Dependencies: 376
-- Name: product_subgroups; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.product_subgroups ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4236 (class 3256 OID 22878)
-- Name: product_subgroups product_subgroups_read_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY product_subgroups_read_all ON public.product_subgroups FOR SELECT TO authenticated USING (true);


--
-- TOC entry 4237 (class 3256 OID 22879)
-- Name: product_subgroups product_subgroups_write_admins; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY product_subgroups_write_admins ON public.product_subgroups TO authenticated USING (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text])) WITH CHECK (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text]));


--
-- TOC entry 4155 (class 0 OID 21574)
-- Dependencies: 380
-- Name: product_variants; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.product_variants ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4240 (class 3256 OID 22887)
-- Name: product_variants product_variants_write_admins; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY product_variants_write_admins ON public.product_variants TO authenticated USING (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text])) WITH CHECK (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text]));


--
-- TOC entry 4154 (class 0 OID 21532)
-- Dependencies: 379
-- Name: products; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4267 (class 3256 OID 23676)
-- Name: products products_admin_delete_guard; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY products_admin_delete_guard ON public.products FOR DELETE TO authenticated USING (((public.is_role('hq_admin'::text) OR public.is_role('power_user'::text)) AND (NOT public.product_has_transactions(id))));


--
-- TOC entry 4265 (class 3256 OID 23674)
-- Name: products products_admin_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY products_admin_insert ON public.products FOR INSERT TO authenticated WITH CHECK ((public.is_role('hq_admin'::text) OR public.is_role('power_user'::text)));


--
-- TOC entry 4266 (class 3256 OID 23675)
-- Name: products products_admin_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY products_admin_update ON public.products FOR UPDATE TO authenticated USING ((public.is_role('hq_admin'::text) OR public.is_role('power_user'::text))) WITH CHECK ((public.is_role('hq_admin'::text) OR public.is_role('power_user'::text)));


--
-- TOC entry 4258 (class 3256 OID 23325)
-- Name: products products_insert_by_mapped_manufacturer; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY products_insert_by_mapped_manufacturer ON public.products FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM public.manufacturer_users mu
  WHERE ((mu.user_id = auth.uid()) AND (mu.manufacturer_id = products.manufacturer_id)))));


--
-- TOC entry 4230 (class 3256 OID 24851)
-- Name: products products_read_admin; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY products_read_admin ON public.products FOR SELECT TO authenticated USING ((public.is_role('hq_admin'::text) OR public.is_role('power_user'::text)));


--
-- TOC entry 4275 (class 3256 OID 24855)
-- Name: products products_read_anon; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY products_read_anon ON public.products FOR SELECT TO anon USING ((is_active = true));


--
-- TOC entry 4274 (class 3256 OID 24854)
-- Name: products products_read_by_manufacturer; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY products_read_by_manufacturer ON public.products FOR SELECT TO authenticated USING (((is_active = true) AND (EXISTS ( SELECT 1
   FROM public.manufacturer_users mu
  WHERE ((mu.user_id = auth.uid()) AND (mu.manufacturer_id = products.manufacturer_id))))));


--
-- TOC entry 4264 (class 3256 OID 24852)
-- Name: products products_read_distributor_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY products_read_distributor_all ON public.products FOR SELECT TO authenticated USING ((public.is_role('distributor_user'::text) AND (is_active = true)));


--
-- TOC entry 4273 (class 3256 OID 24853)
-- Name: products products_read_shop_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY products_read_shop_all ON public.products FOR SELECT TO authenticated USING ((public.is_role('shop_user'::text) AND (is_active = true)));


--
-- TOC entry 4259 (class 3256 OID 23326)
-- Name: products products_update_by_mapped_manufacturer; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY products_update_by_mapped_manufacturer ON public.products FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.manufacturer_users mu
  WHERE ((mu.user_id = auth.uid()) AND (mu.manufacturer_id = products.manufacturer_id))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.manufacturer_users mu
  WHERE ((mu.user_id = auth.uid()) AND (mu.manufacturer_id = products.manufacturer_id)))));


--
-- TOC entry 4226 (class 3256 OID 22885)
-- Name: products products_write_admins; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY products_write_admins ON public.products TO authenticated USING (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text])) WITH CHECK (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text]));


--
-- TOC entry 4194 (class 3256 OID 21953)
-- Name: brands read_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY read_all ON public.brands FOR SELECT TO authenticated USING (true);


--
-- TOC entry 4193 (class 3256 OID 21952)
-- Name: categories read_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY read_all ON public.categories FOR SELECT TO authenticated USING (true);


--
-- TOC entry 4207 (class 3256 OID 22488)
-- Name: shop_distributors sd_admin_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY sd_admin_all ON public.shop_distributors TO authenticated USING (app.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text])) WITH CHECK (app.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text]));


--
-- TOC entry 4217 (class 3256 OID 22497)
-- Name: shop_distributors sd_mine_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY sd_mine_delete ON public.shop_distributors FOR DELETE TO authenticated USING ((distributor_id = app.claim_uuid('distributor_id'::text)));


--
-- TOC entry 4215 (class 3256 OID 22495)
-- Name: shop_distributors sd_mine_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY sd_mine_insert ON public.shop_distributors FOR INSERT TO authenticated WITH CHECK ((distributor_id = app.claim_uuid('distributor_id'::text)));


--
-- TOC entry 4214 (class 3256 OID 22494)
-- Name: shop_distributors sd_mine_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY sd_mine_select ON public.shop_distributors FOR SELECT TO authenticated USING ((distributor_id = app.claim_uuid('distributor_id'::text)));


--
-- TOC entry 4216 (class 3256 OID 22496)
-- Name: shop_distributors sd_mine_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY sd_mine_update ON public.shop_distributors FOR UPDATE TO authenticated USING ((distributor_id = app.claim_uuid('distributor_id'::text))) WITH CHECK ((distributor_id = app.claim_uuid('distributor_id'::text)));


--
-- TOC entry 4161 (class 3256 OID 24976)
-- Name: master_negeri select_master_negeri_anon; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY select_master_negeri_anon ON public.master_negeri FOR SELECT TO anon USING (true);


--
-- TOC entry 4160 (class 0 OID 22468)
-- Dependencies: 386
-- Name: shop_distributors; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.shop_distributors ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4245 (class 3256 OID 22892)
-- Name: shop_distributors shop_distributors_read_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY shop_distributors_read_all ON public.shop_distributors FOR SELECT TO authenticated USING (true);


--
-- TOC entry 4246 (class 3256 OID 22893)
-- Name: shop_distributors shop_distributors_write_admins; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY shop_distributors_write_admins ON public.shop_distributors TO authenticated USING (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text])) WITH CHECK (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text]));


--
-- TOC entry 4218 (class 3256 OID 22498)
-- Name: shop_distributors shop_read_own_links; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY shop_read_own_links ON public.shop_distributors FOR SELECT TO authenticated USING ((shop_id = app.claim_uuid('shop_id'::text)));


--
-- TOC entry 4210 (class 3256 OID 22491)
-- Name: shops shop_self_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY shop_self_select ON public.shops FOR SELECT TO authenticated USING ((id = app.claim_uuid('shop_id'::text)));


--
-- TOC entry 4212 (class 3256 OID 22492)
-- Name: shops shop_self_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY shop_self_update ON public.shops FOR UPDATE TO authenticated USING ((id = app.claim_uuid('shop_id'::text))) WITH CHECK ((id = app.claim_uuid('shop_id'::text)));


--
-- TOC entry 4213 (class 3256 OID 22493)
-- Name: shops shop_visible_to_linked_distributor; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY shop_visible_to_linked_distributor ON public.shops FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.shop_distributors sd
  WHERE ((sd.shop_id = shops.id) AND (sd.distributor_id = app.claim_uuid('distributor_id'::text))))));


--
-- TOC entry 4253 (class 3256 OID 23219)
-- Name: shop_distributors shopd_distributor_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY shopd_distributor_delete ON public.shop_distributors FOR DELETE TO authenticated USING ((distributor_id = app.claim_uuid('distributor_id'::text)));


--
-- TOC entry 4270 (class 3256 OID 23703)
-- Name: shop_distributors shopd_distributor_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY shopd_distributor_insert ON public.shop_distributors FOR INSERT TO authenticated WITH CHECK ((distributor_id = app.claim_uuid('distributor_id'::text)));


--
-- TOC entry 4252 (class 3256 OID 23217)
-- Name: shop_distributors shopd_distributor_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY shopd_distributor_select ON public.shop_distributors FOR SELECT TO authenticated USING ((distributor_id = app.claim_uuid('distributor_id'::text)));


--
-- TOC entry 4251 (class 3256 OID 23216)
-- Name: shop_distributors shopd_shop_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY shopd_shop_delete ON public.shop_distributors FOR DELETE TO authenticated USING ((shop_id = app.claim_uuid('shop_id'::text)));


--
-- TOC entry 4250 (class 3256 OID 23215)
-- Name: shop_distributors shopd_shop_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY shopd_shop_insert ON public.shop_distributors FOR INSERT TO authenticated WITH CHECK ((shop_id = app.claim_uuid('shop_id'::text)));


--
-- TOC entry 4249 (class 3256 OID 23214)
-- Name: shop_distributors shopd_shop_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY shopd_shop_select ON public.shop_distributors FOR SELECT TO authenticated USING ((shop_id = app.claim_uuid('shop_id'::text)));


--
-- TOC entry 4159 (class 0 OID 22441)
-- Dependencies: 385
-- Name: shops; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.shops ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4206 (class 3256 OID 22487)
-- Name: shops shops_admin_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY shops_admin_all ON public.shops TO authenticated USING (app.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text])) WITH CHECK (app.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text]));


--
-- TOC entry 4269 (class 3256 OID 23702)
-- Name: shops shops_insert_by_distributor; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY shops_insert_by_distributor ON public.shops FOR INSERT TO authenticated WITH CHECK (public.is_role('distributor_user'::text));


--
-- TOC entry 4243 (class 3256 OID 22890)
-- Name: shops shops_read_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY shops_read_all ON public.shops FOR SELECT TO authenticated USING (true);


--
-- TOC entry 4244 (class 3256 OID 22891)
-- Name: shops shops_write_admins; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY shops_write_admins ON public.shops TO authenticated USING (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text])) WITH CHECK (public.has_any_role(ARRAY['hq_admin'::text, 'power_user'::text]));


--
-- TOC entry 4222 (class 3256 OID 21635)
-- Name: product_variants var_insert_manu; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY var_insert_manu ON public.product_variants FOR INSERT TO authenticated WITH CHECK ((public.is_role('manufacturer'::text) AND (product_id IN ( SELECT p.id
   FROM (public.products p
     JOIN public.manufacturer_users mu ON ((mu.manufacturer_id = p.manufacturer_id)))
  WHERE (mu.user_id = auth.uid())))));


--
-- TOC entry 4223 (class 3256 OID 21637)
-- Name: product_variants var_update_manu; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY var_update_manu ON public.product_variants FOR UPDATE TO authenticated USING ((public.is_role('manufacturer'::text) AND (product_id IN ( SELECT p.id
   FROM (public.products p
     JOIN public.manufacturer_users mu ON ((mu.manufacturer_id = p.manufacturer_id)))
  WHERE (mu.user_id = auth.uid()))))) WITH CHECK ((public.is_role('manufacturer'::text) AND (product_id IN ( SELECT p.id
   FROM (public.products p
     JOIN public.manufacturer_users mu ON ((mu.manufacturer_id = p.manufacturer_id)))
  WHERE (mu.user_id = auth.uid())))));


--
-- TOC entry 4272 (class 3256 OID 23679)
-- Name: product_variants variants_admin_delete_guard; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY variants_admin_delete_guard ON public.product_variants FOR DELETE TO authenticated USING (((public.is_role('hq_admin'::text) OR public.is_role('power_user'::text)) AND (NOT public.variant_has_transactions(id))));


--
-- TOC entry 4268 (class 3256 OID 23677)
-- Name: product_variants variants_admin_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY variants_admin_insert ON public.product_variants FOR INSERT TO authenticated WITH CHECK ((public.is_role('hq_admin'::text) OR public.is_role('power_user'::text)));


--
-- TOC entry 4271 (class 3256 OID 23678)
-- Name: product_variants variants_admin_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY variants_admin_update ON public.product_variants FOR UPDATE TO authenticated USING ((public.is_role('hq_admin'::text) OR public.is_role('power_user'::text))) WITH CHECK ((public.is_role('hq_admin'::text) OR public.is_role('power_user'::text)));


--
-- TOC entry 4260 (class 3256 OID 23328)
-- Name: product_variants variants_insert_by_mapped_manufacturer; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY variants_insert_by_mapped_manufacturer ON public.product_variants FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM (public.products p
     JOIN public.manufacturer_users mu ON ((mu.manufacturer_id = p.manufacturer_id)))
  WHERE ((p.id = product_variants.product_id) AND (mu.user_id = auth.uid())))));


--
-- TOC entry 4276 (class 3256 OID 24856)
-- Name: product_variants variants_read_admin; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY variants_read_admin ON public.product_variants FOR SELECT TO authenticated USING ((public.is_role('hq_admin'::text) OR public.is_role('power_user'::text)));


--
-- TOC entry 4280 (class 3256 OID 24861)
-- Name: product_variants variants_read_anon; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY variants_read_anon ON public.product_variants FOR SELECT TO anon USING ((is_active = true));


--
-- TOC entry 4279 (class 3256 OID 24859)
-- Name: product_variants variants_read_by_manufacturer; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY variants_read_by_manufacturer ON public.product_variants FOR SELECT TO authenticated USING (((is_active = true) AND (EXISTS ( SELECT 1
   FROM (public.products p
     JOIN public.manufacturer_users mu ON ((mu.manufacturer_id = p.manufacturer_id)))
  WHERE ((p.id = product_variants.product_id) AND (mu.user_id = auth.uid()))))));


--
-- TOC entry 4277 (class 3256 OID 24857)
-- Name: product_variants variants_read_distributor_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY variants_read_distributor_all ON public.product_variants FOR SELECT TO authenticated USING ((public.is_role('distributor_user'::text) AND (is_active = true)));


--
-- TOC entry 4278 (class 3256 OID 24858)
-- Name: product_variants variants_read_shop_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY variants_read_shop_all ON public.product_variants FOR SELECT TO authenticated USING ((public.is_role('shop_user'::text) AND (is_active = true)));


--
-- TOC entry 4261 (class 3256 OID 23329)
-- Name: product_variants variants_update_by_mapped_manufacturer; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY variants_update_by_mapped_manufacturer ON public.product_variants FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM (public.products p
     JOIN public.manufacturer_users mu ON ((mu.manufacturer_id = p.manufacturer_id)))
  WHERE ((p.id = product_variants.product_id) AND (mu.user_id = auth.uid()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM (public.products p
     JOIN public.manufacturer_users mu ON ((mu.manufacturer_id = p.manufacturer_id)))
  WHERE ((p.id = product_variants.product_id) AND (mu.user_id = auth.uid())))));


--
-- TOC entry 4141 (class 0 OID 16546)
-- Dependencies: 343
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4147 (class 0 OID 17684)
-- Dependencies: 372
-- Name: buckets_analytics; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets_analytics ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4263 (class 3256 OID 23617)
-- Name: objects images_authenticated_delete; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY images_authenticated_delete ON storage.objects FOR DELETE TO authenticated USING ((bucket_id = 'images'::text));


--
-- TOC entry 4256 (class 3256 OID 23615)
-- Name: objects images_authenticated_insert; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY images_authenticated_insert ON storage.objects FOR INSERT TO authenticated WITH CHECK ((bucket_id = 'images'::text));


--
-- TOC entry 4257 (class 3256 OID 23616)
-- Name: objects images_authenticated_update; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY images_authenticated_update ON storage.objects FOR UPDATE TO authenticated USING ((bucket_id = 'images'::text)) WITH CHECK ((bucket_id = 'images'::text));


--
-- TOC entry 4255 (class 3256 OID 23614)
-- Name: objects images_public_read; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY images_public_read ON storage.objects FOR SELECT TO authenticated, anon USING ((bucket_id = 'images'::text));


--
-- TOC entry 4143 (class 0 OID 16588)
-- Dependencies: 345
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4142 (class 0 OID 16561)
-- Dependencies: 344
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4146 (class 0 OID 17639)
-- Dependencies: 371
-- Name: prefixes; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.prefixes ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4144 (class 0 OID 17167)
-- Dependencies: 367
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4145 (class 0 OID 17181)
-- Dependencies: 368
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

-- Completed on 2025-09-28 14:05:11 +08

--
-- PostgreSQL database dump complete
--

\unrestrict WNhD5PLjM0fhVOSgW47uNqVhUhgrG58sZnSVqPJWuwtGy1PzSrF7J8Wav6cmdnD

