# Stateless OpenSRE. The process keeps no durable volume: gateway records
# that must survive a restart go to Postgres through DATABASE_URL.
# https://github.com/Tracer-Cloud/opensre
FROM python:3.12-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
        ca-certificates \
        curl \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd --gid 1000 opensre \
    && useradd --uid 1000 --gid 1000 --create-home --shell /usr/sbin/nologin opensre \
    && mkdir -p /home/opensre/.local/bin /tmp/opensre \
    && chown -R opensre:opensre /home/opensre /tmp/opensre

COPY entrypoint.sh /usr/local/bin/opensre-entrypoint
RUN chmod 755 /usr/local/bin/opensre-entrypoint

USER opensre

ENV HOME=/home/opensre \
    PATH=/home/opensre/.local/bin:${PATH} \
    OPENSRE_INSTALL_DIR=/home/opensre/.local/bin \
    OPENSRE_HOME=/tmp/opensre \
    OPENSRE_AUTO_LAUNCH=0 \
    OPENSRE_SKIP_GH_INSTALL=1 \
    MODE=web \
    PORT=8000 \
    PYTHONDONTWRITEBYTECODE=1

# Main-channel binary at build time. Rebuild to pick up a newer build.
RUN curl -fsSL https://install.opensre.com | bash -s -- --main --install-dir /home/opensre/.local/bin

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD if [ "$MODE" = "web" ]; then curl -fsS "http://127.0.0.1:${PORT:-8000}/health" || exit 1; else exit 0; fi

ENTRYPOINT ["opensre-entrypoint"]
