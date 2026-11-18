[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/livebook-1?utm_medium=integration&utm_source=button&utm_campaign=livebook)

# Livebook on Railway

One-click [Livebook](https://livebook.dev) for [Railway](https://railway.com): interactive, collaborative Elixir notebooks for code, data and automation. Notebooks are plain `.livemd` (Markdown) files, code cells run on demand, and Smart cells connect to databases, plot charts and call ML models.

## What this template deploys

| | |
|---|---|
| App | Livebook **0.19.10** |
| Image | official [`ghcr.io/livebook-dev/livebook:0.19.10`](https://github.com/livebook-dev/livebook/pkgs/container/livebook), pinned by digest `sha256:216af978b9300980117ae8a362f866c9414026d55f98f15fa6d35def0699a348` |
| Services | one, `Livebook`, with a public HTTPS domain |
| Storage | a Railway volume at `/data` (see below) |
| Health check | `GET /public/health` |
| Login | password, generated per deploy |

Everything Livebook keeps lives on the `/data` volume, so it survives redeploys, restarts and updates:

- `/data`: your notebooks and files (`LIVEBOOK_HOME`, the default folder in the file picker),
- `/data/.livebook`: Livebook's own settings (`LIVEBOOK_DATA_PATH`): secrets, hubs, file systems, environment variables,
- `/data/.mix`: the `Mix.install` cache, so notebook dependencies aren't downloaded and compiled again after each redeploy.

The wrapper is small: the Dockerfile pins the image and sets those paths, and `start.sh` maps Railway's `PORT` to `LIVEBOOK_PORT` before running upstream's `/app/bin/server`.

## Variables

| Variable | Default | What it does |
|---|---|---|
| `PORT` | `8080` | Port Livebook listens on. The public domain points at it. |
| `LIVEBOOK_PASSWORD` | generated, 24 characters | The password for the Livebook login page. Find it in the service's **Variables** tab. |
| `LIVEBOOK_SECRET_KEY_BASE` | generated, 64 characters | Signs and encrypts sessions. Fixed per deploy, so you stay logged in across redeploys. |

Nothing to fill in at deploy time. After the deploy, open the service's URL and log in with `LIVEBOOK_PASSWORD`. To change the password, edit the variable (at least 12 characters) and redeploy.

### Optional settings

Add these to the service's variables when you need them (full list: [Livebook environment variables](https://github.com/livebook-dev/livebook#environment-variables)):

- **Sign in with your identity provider instead of a password:** `LIVEBOOK_IDENTITY_PROVIDER` (for example Cloudflare Access, Google IAP, Tailscale or a custom one).
- **Deploy notebooks as apps on startup:** `LIVEBOOK_APPS_PATH` (for example `/data/apps`) and `LIVEBOOK_APPS_PATH_PASSWORD`.
- **More logging:** `LIVEBOOK_LOG_LEVEL=info` or `debug`.

Rich outputs (charts, tables, maps) load from Livebook's sandbox origin `livebookusercontent.com` when Livebook is served over HTTPS, as it is on Railway. That is upstream's normal behaviour; set `LIVEBOOK_IFRAME_URL` only if you host that page yourself.

Each notebook runs as its own Elixir node inside the same container, so give the service more memory if you run heavy notebooks (Nx, Explorer, ML models).

## How updates reach you

This template builds from this repository. When we bump the pinned Livebook version here, Railway shows an "update available" notice on your project, and you choose when to apply it. Read [CHANGELOG.md](CHANGELOG.md) first: breaking changes are listed first in each entry. Your notebooks and settings stay on the volume across updates and redeploys.

## Run it locally

```sh
LIVEBOOK_PASSWORD=$(openssl rand -hex 12) LIVEBOOK_SECRET_KEY_BASE=$(openssl rand -hex 32) docker compose up --build
```

Then open http://localhost:8080 and log in with the password you set.

## License

The wrapper files in this repository are MIT licensed. Livebook itself is under the [Apache 2.0 licence](https://github.com/livebook-dev/livebook/blob/main/LICENSE).
