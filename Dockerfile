FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y \
    tzdata \
    nginx \
    tor \
    privoxy \
    curl

# Tor config
RUN echo 'SocksPort 9050' >> /etc/tor/torrc

# Privoxy config
RUN echo 'forward-socks5t / localhost:9050 .' >> /etc/privoxy/config
RUN echo 'accept-intercepted-requests 1' >> /etc/privoxy/config

# disable IPv6 Listen for Ubuntu 20.04 bug
RUN sed -i '/listen-address  \[::1\]:8118/d' /etc/privoxy/config

# Place holder for Nginx config, will be replaced by docker-entrypoint.sh
RUN echo 'server {\n\
    listen 80;\n\
    server_name _;\n\
    return 403;\n\
}\n\
server {\n\
    listen 80;\n\
    server_name SERVER_NAME;\n\
    location / {\n\
        proxy_pass http://localhost:8118;\n\
        proxy_set_header Host ONION_ADDRESS;\n\
        proxy_set_header X-Real-IP $remote_addr;\n\
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;\n\
    }\n\
}' > /etc/nginx/sites-available/default

# Create docker-entrypoint.sh
RUN echo '#!/bin/sh\n\
sed -i "s|SERVER_NAME|${SERVER_NAME}|g" /etc/nginx/sites-available/default\n\
sed -i "s|ONION_ADDRESS|${ONION_ADDRESS}|g" /etc/nginx/sites-available/default\n\
service tor start\n\
service privoxy start\n\
nginx -g "daemon off;"' > /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]