# Changelog

Breaking changes are listed first in each entry.

## 0.19.10 (2026-11-18)

- First release of this template: Livebook 0.19.10 on the official `ghcr.io/livebook-dev/livebook` image, pinned by digest `sha256:216af978b9300980117ae8a362f866c9414026d55f98f15fa6d35def0699a348`.
- Notebooks (`/data`), Livebook's settings (`/data/.livebook`) and the `Mix.install` cache (`/data/.mix`) live on a Railway volume at `/data`.
- Listens on `PORT` (8080), health check `GET /public/health`.
- `LIVEBOOK_PASSWORD` and `LIVEBOOK_SECRET_KEY_BASE` are generated per deploy.
- Deploy on Railway button in the README.
