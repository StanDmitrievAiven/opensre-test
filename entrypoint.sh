#!/bin/sh
set -eu

mkdir -p "${OPENSRE_HOME:-/tmp/opensre}"

case "${MODE:-web}" in
  web)
    exec opensre gateway web
    ;;
  gateway)
    exec opensre gateway start --foreground
    ;;
  scheduler)
    exec opensre cron start --service
    ;;
  *)
    echo "unsupported MODE=${MODE}" >&2
    exit 1
    ;;
esac
