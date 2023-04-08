#!/bin/bash

function get_version {
    local tag_filter="$1"
    curl -s https://api.github.com/repos/moby/moby/releases | grep "tag_name" | grep "$tag_filter" | head -n1 | cut -d'"' -f4
}

# Supprime le fichier curl.metrics s'il existe
rm -f /app/metrics/curl.metrics
touch /app/metrics/curl.metrics

# Parcourt la liste des filtres de version
for tag_filter in "" "beta" "rc"; do
    version=$(get_version "$tag_filter")
    metric_name="moby_docker_engine_version_${tag_filter:-stable}"
    echo "${metric_name}{version=\"$version\"} 1" >> /app/metrics/curl.metrics
done
