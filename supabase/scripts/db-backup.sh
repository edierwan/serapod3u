#!/usr/bin/env bash
set -euo pipefail

# === Serapod2u DB Backup (mac/linux) ===
# Requires: pg_dump, gzip
#
# Quick use (uses your defaults below):
#   ./supabase/scripts/db-backup.sh --schema
#   ./supabase/scripts/db-backup.sh --full
#   ./supabase/scripts/db-backup.sh --data --tables-file supabase/scripts/tables.txt
#
# Override example:
#   ./supabase/scripts/db-backup.sh --schema --host other-host --user other-user --db otherdb

# ---- Defaults from your project ----
export PGPASSWORD="${PGPASSWORD:-Turun_2020-}"
HOST="${HOST_OVERRIDE:-aws-0-ap-southeast-1.pooler.supabase.com}"
PORT="${PORT_OVERRIDE:-5432}"
USER="${USER_OVERRIDE:-postgres.opbesretiesctwpdqikl}"
DB="${DB_OVERRIDE:-postgres}"

OUTDIR="supabase/backups"
SCHEMA_MODE=false
DATA_MODE=false
FULL_MODE=false
TABLE_LIST_FILE=""

SCHEMAS=(public storage)
DEFAULT_TABLES=( \
  public.product_categories public.product_groups public.product_subtypes \
  public.manufacturers public.products public.product_variants \
)

usage() {
  cat <<EOF
Usage: $0 (--schema | --data | --full) [--tables-file path] [--outdir DIR] [--host H] [--user U] [--db D] [--port P]

Modes:
  --schema     : schema-only for schemas: ${SCHEMAS[*]}
  --data       : data-only for selected tables (default list or --tables-file)
  --full       : full dump (.dump) for entire DB

Defaults:
  HOST=${HOST}  PORT=${PORT}  USER=${USER}  DB=${DB}
  OUTDIR=${OUTDIR}

Examples:
  $0 --schema
  $0 --full
  $0 --data --tables-file supabase/scripts/tables.txt
EOF
}

# parse args
while [[ $# -gt 0 ]]; do
  case "$1" in
    --host) HOST="$2"; shift 2 ;;
    --user) USER="$2"; shift 2 ;;
    --db) DB="$2"; shift 2 ;;
    --port) PORT="$2"; shift 2 ;;
    --outdir) OUTDIR="$2"; shift 2 ;;
    --schema) SCHEMA_MODE=true; shift ;;
    --data) DATA_MODE=true; shift ;;
    --full) FULL_MODE=true; shift ;;
    --tables-file) TABLE_LIST_FILE="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown arg: $1"; usage; exit 1 ;;
  esac
done

command -v pg_dump >/dev/null || { echo "pg_dump not found. On mac: brew install libpq && brew link --force libpq"; exit 1; }
mkdir -p "$OUTDIR"
TS="$(date +%Y%m%dT%H%M%S)"

if $SCHEMA_MODE; then
  OUT="${OUTDIR}/${TS}_schema.sql"
  echo ">> SCHEMA backup -> ${OUT}.gz"
  pg_dump -h "$HOST" -p "$PORT" -U "$USER" -d "$DB" \
    $(printf -- "-n %s " "${SCHEMAS[@]}") \
    -s -v --no-owner --no-privileges -f "$OUT"
  gzip -f "$OUT"
  echo "OK: ${OUT}.gz"; exit 0
fi

if $DATA_MODE; then
  OUT="${OUTDIR}/${TS}_data.sql"
  echo ">> DATA backup -> ${OUT}.gz"
  declare -a TABLES
  if [[ -n "$TABLE_LIST_FILE" ]]; then
    mapfile -t TABLES < <(grep -v '^\s*$' "$TABLE_LIST_FILE" | sed 's/#.*$//')
  else
    TABLES=("${DEFAULT_TABLES[@]}")
  fi
  [[ ${#TABLES[@]} -eq 0 ]] && { echo "ERROR: no tables specified for --data"; exit 1; }
  pg_dump -h "$HOST" -p "$PORT" -U "$USER" -d "$DB" \
    -a -v --no-owner --no-privileges \
    $(printf -- "-t %s " "${TABLES[@]}") \
    -f "$OUT"
  gzip -f "$OUT"
  echo "OK: ${OUT}.gz"; exit 0
fi

if $FULL_MODE; then
  OUT="${OUTDIR}/${TS}.dump"
  echo ">> FULL backup -> ${OUT}"
  pg_dump -h "$HOST" -p "$PORT" -U "$USER" -d "$DB" -Fc -v --no-owner --no-privileges -f "$OUT"
  echo "OK: ${OUT}"; exit 0
fi

echo "ERROR: pick one mode: --schema | --data | --full"; usage; exit 1
