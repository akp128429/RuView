# Render demo deployment

This deployment runs the published RuView sensing-server image pinned by digest, with this repository's dashboard assets. Nginx routes HTTP and WebSocket traffic over Render's single public port.

The source is explicitly **SYNTHETIC** (`--source simulated`). It does not access visitor Wi-Fi, local ESP32 devices, or real people. It is not hardware validation.

The backend binds only to loopback and uses a random ephemeral bearer credential generated at startup. The public proxy permits GET/HEAD only, so recording, training, configuration changes, and other mutation APIs are unavailable. A persistent banner labels the dashboard as synthetic. Restarting regenerates the internal credential; no external credentials or database are required.

Render settings:
- Runtime: Docker
- Dockerfile: `deploy/render/Dockerfile`
- Build context: repository root
- Plan: free
- Region: Singapore
- Public port: `PORT`, default 10000
- Health endpoint: `/health`

Verify `/health`, `/api/v1/sensing/latest`, `/ui/index.html`, and a WebSocket connection to `/ws/sensing`. POST requests should return 405.
