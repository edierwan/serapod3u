#!/usr/bin/env bash
set -euo pipefail

# === Serapod2u DB Restore (mac/linux) ===
# Requires: psql, pg_restore, gunzip (if .gz)

# Defaults from your project
export PGPASSWORD="${PGPASSWORD:-Turun_2020-}"
HOST="${HOST_OVERRIDE:-aws-0-ap-southeast-1.pooler.supabase.com}"
PORT="${PORT_OVERRIDE:-5432}"
USER="${USER_OVERRIDE:-postgres.opbesretiesctwpdqikl}"
DB="${DB_OVERRIDE:-postgres}"

usage() {
  cat <<EOF
Usage: $0 <backup-file>

Examples:
  $0 supabase/backups/20250101T120000_schema.sql.gz
  $0 supabase/backups/20250101T120000_data.sql.gz
  $0 supabase/backups/20250101T120000.dump

Defaults:
  HOST=${HOST}  PORT=${PORT}  USER=${USER}  DB=${DB}
EOF
}

[[ $# -lt 1 ]] && { usage; exit 1; }
FILE="$1"

if [[ "$FILE" == *.dump ]]; then
  echo ">> Restoring FULL custom dump: $FILE"
  pg_restore -h "$HOST" -p "$PORT" -U "$USER" -d "$DB" -v "$FILE"
  echo "OK"
  exit 0
fi

# .sql or .sql.gz
if [[ "$FILE" == *.gz ]]; then
  echo ">> Decompressing: $FILE"
  TMP="$(mktemp).sql"
  gunzip -c "$FILE" > "$TMP"
  SQL="$TMP"
else
  SQL="$FILE"
fi

echo ">> Restoring SQL: $SQL"
psql "host=$HOST port=$PORT user=$USER dbname=$DB" -v ON_ERROR_STOP=1 -f "$SQL"
echo "OK"
