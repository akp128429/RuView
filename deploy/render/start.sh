#!/bin/sh
set -eu
case "${PORT:-10000}" in ''|*[!0-9]*) echo "Invalid PORT" >&2; exit 1;; esac
export PORT="${PORT:-10000}"
# Ephemeral internal credential. Never returned to the browser or committed.
export RUVIEW_API_TOKEN="$(openssl rand -hex 32)"
envsubst '${PORT} ${RUVIEW_API_TOKEN}' < /app/render-nginx.conf.template > /tmp/render-nginx.conf
chmod 600 /tmp/render-nginx.conf
/app/sensing-server --source simulated --bind-addr 127.0.0.1 --http-port 3000 --ws-port 3001 --tick-ms 250 --ui-path /app/ui &
sensing_pid=$!
nginx -c /tmp/render-nginx.conf -g 'daemon off;' &
proxy_pid=$!
cleanup() {
  kill -TERM "$proxy_pid" "$sensing_pid" 2>/dev/null || true
  wait "$proxy_pid" "$sensing_pid" 2>/dev/null || true
}
trap cleanup EXIT
trap 'exit 0' TERM INT
while kill -0 "$sensing_pid" 2>/dev/null && kill -0 "$proxy_pid" 2>/dev/null; do
  sleep 2
done
exit 1
