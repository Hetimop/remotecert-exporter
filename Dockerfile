FROM debian:bullseye-20230320-slim

# Add image information
LABEL \
    category="shell-exporter" \
    maintainers="Hetimop"

COPY ./config/*.sh /app/scripts/
COPY ./config/pwn /etc/xinetd.d/pwn
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /app/scripts/* && \
    chmod +x /usr/local/bin/entrypoint.sh && \
    mkdir /app/metrics -p

WORKDIR /app

# Install requirements
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y --no-install-recommends  xinetd openssl curl nano && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

CMD [ "/usr/local/bin/entrypoint.sh"]