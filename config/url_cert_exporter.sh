#!/bin/bash
set +e

# Exemple domaine
URLS=("dontworks.com:443" "hub.docker.com:443" "prometheus.io:443" "grafana.com:443" "quay.io:443" "debian.org:443" "github.com:443")

# Parcourt la liste des noms de domaine
for domain in "${URLS[@]}"; do
    url="$domain"
    output=$(echo | openssl s_client -connect "$url" 2> /dev/null | openssl x509 -noout -serial -issuer -subject -dates 2>&1)
    if [[ $output == *"unable to load certificate"* ]]; then
        echo "remote_cert_invalid{url=\"$url\"} 1"
    else
        serial=$(echo "$output" | awk -F= '/serial/ {print $NF}')
        issuer=$(echo "$output" | awk -F= '/issuer/ {print $NF}')
        subject=$(echo "$output" | awk -F= '/subject/ {print $NF}')
        not_before=$(date -d "$(echo "$output" | awk -F= '/notBefore/ {print $NF}')" +%s)
        not_after=$(date -d "$(echo "$output" | awk -F= '/notAfter/ {print $NF}')" +%s)
        remaining_days=$(( ($not_after - $(date +%s)) / 86400 ))
        echo "remote_cert_info{url=\"$url\",serial=\"$serial\",issuer=\"$issuer\",subject=\"$subject\",not_before=\"$not_before\",not_after=\"$not_after\",days_remaining=\"$remaining_days\"} 1"
    fi
done