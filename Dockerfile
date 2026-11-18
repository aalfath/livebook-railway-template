# Livebook for Railway: the official image, pinned by version and digest.
# Bump both together; see CHANGELOG.md.
FROM ghcr.io/livebook-dev/livebook:0.19.10@sha256:216af978b9300980117ae8a362f866c9414026d55f98f15fa6d35def0699a348

# Everything Livebook keeps goes under /data, which the template mounts as a
# Railway volume:
#   /data            notebooks and files (LIVEBOOK_HOME, the default folder in the UI)
#   /data/.livebook  Livebook's own settings: hubs, secrets, file systems, env vars
#   /data/.mix       Mix.install cache, so notebook dependencies survive a redeploy
# Override any of these as service variables.
ENV LIVEBOOK_HOME=/data \
    LIVEBOOK_DATA_PATH=/data/.livebook \
    MIX_INSTALL_DIR=/data/.mix/install \
    LIVEBOOK_IP=:: \
    LIVEBOOK_UPDATE_INSTRUCTIONS_URL=https://github.com/aalfath/livebook-railway-template#how-updates-reach-you

COPY start.sh /usr/local/bin/livebook-railway-start
RUN chmod 755 /usr/local/bin/livebook-railway-start

WORKDIR /data
EXPOSE 8080

# Maps Railway's PORT to LIVEBOOK_PORT, then runs upstream's /app/bin/server.
CMD ["/usr/local/bin/livebook-railway-start"]
