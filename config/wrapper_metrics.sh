#!/bin/bash

# root='/opt/scripts'
mime='text/plain'

# Concatenate url.metrics and curl.metrics into final.metrics
awk 'NR>1 && FNR==1{print ""};1' /app/metrics/curl.metrics /app/metrics/url.metrics > /app/metrics/final.metrics

size=$(stat -c "%s" "/app/metrics/final.metrics")
printf 'HTTP/1.1 200 OK\r\nDate: %s\r\nContent-Length: %s\r\nContent-Type: %s\r\nConnection: close\r\n\r\n' "$(date)" "$size" "$mime"
cat /app/metrics/final.metrics
echo -en "\r\n"
sleep 0.5
exit 0