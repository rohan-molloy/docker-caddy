FROM golang:1.12-alpine
ENV ACME_AGREE="false"
ENV ENABLE_TELEMETRY="false"
RUN apk add --no-cache git ca-certificates tzdata wget
COPY builder.sh /usr/bin/builder.sh
RUN VERSION='1.0.3' PLUGINS='jwt,login' ENABLE_TELEMETRY=false /bin/sh /usr/bin/builder.sh
RUN cp /install/caddy /usr/bin/caddy
RUN /usr/bin/caddy -version
RUN /usr/bin/caddy -plugins
RUN apk del git wget
EXPOSE 2015
VOLUME /root/.caddy /srv
WORKDIR /srv
COPY Caddyfile /etc/Caddyfile
COPY index.html /srv/index.html
USER nobody
CMD /usr/bin/caddy -conf /etc/Caddyfile -log stdout
