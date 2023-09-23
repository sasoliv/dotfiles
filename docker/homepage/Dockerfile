FROM ghcr.io/benphelps/homepage:latest

COPY config/* /app/config/
COPY images/* /app/public/images/
COPY --chmod=765 custom-init.sh /

CMD ["/custom-init.sh"]
