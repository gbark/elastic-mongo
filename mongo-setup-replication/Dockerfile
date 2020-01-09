FROM mongo:3.6

# ENV DEBIAN_FRONTEND noninteractive
# ENV TZ Asia/Shanghai

COPY docker-entrypoint.sh /tmp/

ENTRYPOINT ["/bin/bash", "/tmp/docker-entrypoint.sh"]