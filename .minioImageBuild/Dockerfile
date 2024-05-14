#ddev-generated

FROM minio/minio:latest

COPY ddev-entrypoint.sh /usr/bin/ddev-entrypoint.sh

RUN chmod +x /usr/bin/ddev-entrypoint.sh

ENTRYPOINT ["/usr/bin/ddev-entrypoint.sh"]
