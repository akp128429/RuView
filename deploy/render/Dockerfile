FROM ruvnet/wifi-densepose@sha256:3e98fa4f9c937b2c6e12ca8b3cc83e2a7f494dbaeb110aaeaa8ca1ef12809b10
USER root
RUN apt-get update && apt-get install -y --no-install-recommends nginx gettext-base openssl && rm -rf /var/lib/apt/lists/*
COPY ui/ /app/ui/
COPY deploy/render/nginx.conf.template /app/render-nginx.conf.template
COPY deploy/render/start.sh /app/render-start.sh
RUN chmod 755 /app/render-start.sh && test -x /app/sensing-server
ENV PORT=10000
EXPOSE 10000
ENTRYPOINT ["/app/render-start.sh"]
