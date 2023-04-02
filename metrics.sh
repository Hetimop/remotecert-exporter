#!/bin/bash
set +e

# Exemple domaine
URLS=("hub.docker.com" "prometheus.io" "grafana.com" "quay.io" "debian.org" "github.com" "dontworks.com")

# Parcourt la liste des noms de domaine
for domain in "${URLS[@]}"; do
    url="$domain:443"
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
        echo "remote_cert_not_before{url=\"$url\",serial=\"$serial\"} $not_before"
        echo "remote_cert_expiration_date{url=\"$url\",serial=\"$serial\"} $not_after"
        echo "remote_cert_valide{url=\"$url\",serial=\"$serial\",issuer=\"$issuer\",subject=\"$subject\",days_remaining=\"$remaining_days\"} 1"

    fi

done