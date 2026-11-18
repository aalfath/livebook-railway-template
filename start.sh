#!/bin/sh
# Railway wrapper for Livebook: listen on Railway's PORT and keep all state on
# the /data volume, then hand over to the upstream start command.
set -e

# Livebook reads LIVEBOOK_PORT, Railway sets PORT. An explicit LIVEBOOK_PORT wins.
export LIVEBOOK_PORT="${LIVEBOOK_PORT:-${PORT:-8080}}"

# The volume is mounted empty on the first deploy.
mkdir -p "${LIVEBOOK_HOME:-/data}" "${LIVEBOOK_DATA_PATH:-/data/.livebook}"
if [ -n "${MIX_INSTALL_DIR}" ]; then mkdir -p "${MIX_INSTALL_DIR}"; fi

exec /app/bin/server "$@"
