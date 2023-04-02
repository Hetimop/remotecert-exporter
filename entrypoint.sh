#!/bin/sh
set -e

if [ -n "$URLS" ]; then
  sed -i "s/^URLS=.*$/URLS=($URLS)/" /app/metrics.sh
fi

if [ -n "$METRICS_PORT" ]; then
  sed -i "s/port = .*$/port = ${METRICS_PORT}/" /etc/xinetd.d/pwn
fi

exec /usr/sbin/xinetd -dontfork