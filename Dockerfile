FROM debian:10.3

RUN apt-get update && \
    apt-get install -y \
      make \
      bash \
      less \
      curl \
      redis-tools \
      && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY docker-entrypoint.sh /usr/local/sbin/
ENTRYPOINT ["docker-entrypoint.sh"]
