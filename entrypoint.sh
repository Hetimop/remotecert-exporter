#!/bin/sh
set -e

# Créer l'utilisateur pwn
useradd --shell /bin/false pwn 


# Démarrer le service xinetd
echo "Starting xinetd service..."
/usr/sbin/xinetd -dontfork &

# Lancer le script url_cert_exporter.sh toutes les 10 minutes
while true; do
  /app/scripts/url_cert_exporter.sh & /app/scripts/curl_cert_exporter.sh &
  sleep 120

done