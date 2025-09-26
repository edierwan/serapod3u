#!/usr/bin/env bash
set -euo pipefail

# ==========================
# Serapod2u DB Restore Tool
# ==========================
# Prasyarat:
# - psql, pg_restore tersedia
# - Set env PGPASSWORD
#
# Contoh:
#   export PGPASSWORD='Turun_2020-'
#   ./db-restore.sh --host db.PROJ.supabase.co --user postgres.PROJ --db postgres --schema supabase/backups/20250926T100500_schema.sql.gz
#   ./db-restore.sh --host db.PROJ.supabase.co --user postgres.PROJ --db postgres --data supabase/backups/20250926T100700_seed_and_meta.sql.gz
#   ./db-restore.sh --host db.PROJ.supabase.co --user postgres.PROJ --db postgres --full supabase/backups/20250926T101000.dump
#   ./db-restore.sh --host ... --user ... --db ... --full supabase/backups/xxx.dump --list-only

PORT=5432
DB=""
USER=""
HOST=""

SCHEMA_FILE=""
DATA_FILE=""
FULL_FILE=""
LIST_ONLY=false

usage() {
  cat <<EOF
Usage: $0 --host HOST --user USER --db DB [--port 5432] [--schema file.sql[.gz] | --data file.sql[.gz] | --full file.dump] [--list-only]

Options:
  --schema FILE   : Restore schema SQL (akan jalankan psql -f FILE)
  --data FILE     : Restore data-only SQL
  --full FILE     : Restore dari custom dump (.dump) guna pg_restore
  --list-only     : Untuk --full, hanya papar kandungan (tidak restore)

Amaran:
  - Uji di DB 'shadow' dahulu.
  - Pastikan anda faham impak overwrite terhadap struktur/data sedia ada.

EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --host) HOST="$2"; shift 2 ;;
    --user) USER="$2"; shift 2 ;;
    --db) DB="$2"; shift 2 ;;
    --port) PORT="$2"; shift 2 ;;
    --schema) SCHEMA_FILE="$2"; shift 2 ;;
    --data) DATA_FILE="$2"; shift 2 ;;
    --full) FULL_FILE="$2"; shift 2 ;;
    --list-only) LIST_ONLY=true; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown arg: $1"; usage; exit 1 ;;
  esac
done

if [[ -z "${HOST}" || -z "${USER}" || -z "${DB}" ]]; then
  echo "ERROR: --host, --user, --db diperlukan."; usage; exit 1
fi

one_mode_count=0
[[ -n "$SCHEMA_FILE" ]] && ((one_mode_count++))
[[ -n "$DATA_FILE" ]] && ((one_mode_count++))
[[ -n "$FULL_FILE" ]] && ((one_mode_count++))
if [[ $one_mode_count -ne 1 ]]; then
  echo "ERROR: Pilih tepat satu: --schema | --data | --full"; usage; exit 1
fi

run_psql_file () {
  local FILE="$1"
  local TMP=""
  if [[ "$FILE" == *.gz ]]; then
    echo ">> Decompress temp: $FILE"
    TMP="$(mktemp /tmp/restore.XXXXXX.sql)"
    gunzip -c "$FILE" > "$TMP"
  else
    TMP="$FILE"
  fi
  echo ">> Restoring via psql: $TMP"
  psql -h "$HOST" -p "$PORT" -U "$USER" -d "$DB" -v ON_ERROR_STOP=1 -f "$TMP"
  [[ "$TMP" == /tmp/restore.*.sql ]] && rm -f "$TMP"
  echo "OK."
}

if [[ -n "$SCHEMA_FILE" ]]; then
  run_psql_file "$SCHEMA_FILE"
  exit 0
fi

if [[ -n "$DATA_FILE" ]]; then
  run_psql_file "$DATA_FILE"
  exit 0
fi

if [[ -n "$FULL_FILE" ]]; then
  if $LIST_ONLY; then
    echo ">> Listing dump contents:"
    pg_restore -l "$FULL_FILE"
    exit 0
  fi
  echo ">> Restoring FULL dump (custom format) to ${DB} @ ${HOST}"
  # Contoh: hanya structure schema public
  # pg_restore -h "$HOST" -p "$PORT" -U "$USER" -d "$DB" -n public -s -v "$FULL_FILE"
  #
  # Default: restore semua (hati-hati)
  pg_restore -h "$HOST" -p "$PORT" -U "$USER" -d "$DB" -v "$FULL_FILE"
  echo "OK."
  exit 0
fi
