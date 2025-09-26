#!/usr/bin/env bash
set -euo pipefail

# =========================
# Serapod2u DB Backup Tool
# =========================
# Prasyarat:
# - pg_dump, psql terpasang (Postgres client)
# - Set env PGPASSWORD (atau guna prompt)
#
# Default target:
#   SCHEMAS: public,storage,auth,graphql_public,extensions
#   DATA TABLES (contoh, ubah ikut skema anda): product_categories, product_groups, product_subtypes, manufacturers, flavours, points_rules, auth.users, auth.identities, storage.buckets, storage.objects
#
# Contoh:
#   export PGPASSWORD='Turun_2020-'
#   ./db-backup.sh --host db.opbesretiesctwpdqikl.supabase.co --user postgres.opbesretiesctwpdqikl --db postgres --schema
#   ./db-backup.sh --host db.opbesretiesctwpdqikl.supabase.co --user postgres.opbesretiesctwpdqikl --db postgres --data
#   ./db-backup.sh --host db.opbesretiesctwpdqikl.supabase.co --user postgres.opbesretiesctwpdqikl --db postgres --full
#
# Nota: Guna host "db....supabase.co" (direct DB) lebih stabil berbanding pooler untuk dump besar.

PORT=5432
DB=""
USER=""
HOST=""
OUTDIR="supabase/backups"
SCHEMA_MODE=false
DATA_MODE=false
FULL_MODE=false
TABLE_LIST_FILE=""
# Default schemas
SCHEMAS=(public storage auth graphql_public extensions)
# Default tables (EDIT ikut skema sebenar anda)
DEFAULT_TABLES=( \
  public.product_categories public.product_groups public.product_subtypes \
  public.manufacturers public.flavours public.points_rules \
  auth.users auth.identities storage.buckets storage.objects \
)

usage() {
  cat <<EOF
Usage: $0 --host HOST --user USER --db DB [--port 5432] (--schema | --data | --full) [--tables-file path]

Modes:
  --schema       : Schema-only dump untuk schemas: ${SCHEMAS[*]}
  --data         : Data-only dump untuk tables (default list atau dari --tables-file)
  --full         : Full dump (custom format .dump) untuk keseluruhan database
Options:
  --tables-file  : Fail teks dengan senarai table (satu per baris) untuk --data
  --outdir       : Folder output (default: ${OUTDIR})

Contoh:
  export PGPASSWORD='…'
  $0 --host db.PROJ.supabase.co --user postgres.PROJ --db postgres --schema
  $0 --host db.PROJ.supabase.co --user postgres.PROJ --db postgres --data --tables-file supabase/tables.txt
  $0 --host db.PROJ.supabase.co --user postgres.PROJ --db postgres --full
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

if [[ -z "${HOST}" || -z "${USER}" || -z "${DB}" ]]; then
  echo "ERROR: --host, --user, --db diperlukan."; usage; exit 1
fi

mkdir -p "${OUTDIR}"

TS="$(date +%Y%m%dT%H%M%S)"

if $SCHEMA_MODE; then
  OUT="${OUTDIR}/${TS}_schema.sql"
  echo ">> Dump SCHEMA to ${OUT}.gz"
  pg_dump -h "$HOST" -p "$PORT" -U "$USER" -d "$DB" \
    $(printf -- "-n %s " "${SCHEMAS[@]}") \
    -s -v --no-owner --no-privileges \
    -f "$OUT"
  gzip -f "$OUT"
  echo "OK: ${OUT}.gz"
  exit 0
fi

if $DATA_MODE; then
  OUT="${OUTDIR}/${TS}_seed_and_meta.sql"
  echo ">> Dump DATA to ${OUT}.gz"
  declare -a TABLES
  if [[ -n "$TABLE_LIST_FILE" ]]; then
    mapfile -t TABLES < <(grep -v '^\s*$' "$TABLE_LIST_FILE" | sed 's/#.*$//' )
  else
    TABLES=("${DEFAULT_TABLES[@]}")
  fi
  if [[ ${#TABLES[@]} -eq 0 ]]; then
    echo "ERROR: Tiada tables untuk --data. Guna --tables-file atau set DEFAULT_TABLES."; exit 1
  fi
  pg_dump -h "$HOST" -p "$PORT" -U "$USER" -d "$DB" \
    -a -v --no-owner --no-privileges \
    $(printf -- "-t %s " "${TABLES[@]}") \
    -f "$OUT"
  gzip -f "$OUT"
  echo "OK: ${OUT}.gz"
  exit 0
fi

if $FULL_MODE; then
  OUT="${OUTDIR}/${TS}.dump"
  echo ">> Full dump (custom format) to ${OUT}"
  pg_dump -h "$HOST" -p "$PORT" -U "$USER" -d "$DB" \
    -Fc -v --no-owner --no-privileges \
    -f "$OUT"
  echo "OK: ${OUT}"
  exit 0
fi

echo "ERROR: Pilih satu mode --schema | --data | --full"
usage
exit 1
