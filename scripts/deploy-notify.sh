#!/usr/bin/env bash
# Runs at the end of `make deploy` on the VPS: records this deploy's version in Plexivia,
# so every project's running version is kept in one place. Plexivia adds 1 to minor
# (rolls into major after 99), keeps the history and sends the dashboard notification.
# Cares runs on its own server, so it calls Plexivia's public API with its own deploy key
# (Plexivia checks it, it only bumps CARES). Never fails the deploy.
set -u
cd "$(dirname "$0")/.."

URL='https://api.plexivia.com/api/deploy/bump?key=71f5258ce40c5e04e0884e47132a5c4beb417b42234d05878ef1799a57c43d7e'

json_escape() { printf '%s' "$1" | sed 's/\/\\/g; s/"/\\"/g'; }

COMMIT="$(json_escape "$(git log -1 --format='%h %s' 2>/dev/null)")"
BRANCH="$(json_escape "$(git rev-parse --abbrev-ref HEAD 2>/dev/null)")"
HOST="$(json_escape "$(hostname)")"
BODY="{\"name\":\"Cares Bangladesh\",\"commit\":\"$COMMIT\",\"branch\":\"$BRANCH\",\"host\":\"$HOST\"}"

# A few quiet tries in case of a network blip
for _ in 1 2 3; do
  if OUT="$(curl -fsS --max-time 15 -X POST "$URL" -H 'Content-Type: application/json' -d "$BODY" 2>/dev/null)"; then
    echo "🏷️  $OUT"
    exit 0
  fi
  sleep 3
done
echo "⚠️  Could not record the deploy version in Plexivia"
exit 0
