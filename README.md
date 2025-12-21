# OCI Images

## About

This repository contains a collection of [OCI Images](https://github.com/opencontainers/image-spec) I use in my clusters. Images are:

- Built on **STABLE** base images **ONLY**. Versions are specified in each Dockerfile via `OCI_BASE_IMAGE` ARG.

- Build weekly on Sundays and tagged as `YYYY.MM.DD` & `latest`.

- Exposed to lower attack surface & vulnerabilities:
  - Based on `alpine` lightweight images whenever possible.
  - System updates are applied during build.
  - If missing from base image, it includes a `non-root` user named `oci` (`uid:1000`, `gid:1000`).

- Available in my **Packages** section.

## Images Status

| Service         | Image Name / Build Status                                                                                     | OS     | Description                                      |
|-----------------|---------------------------------------------------------------------------------------------------------------|--------|--------------------------------------------------|
| **FileBrowser** | [![oci-filebrowser-build](https://github.com/thomaschampagne/oci-images/actions/workflows/filebrowser.yaml/badge.svg?branch=main)](https://github.com/thomaschampagne/oci-images/actions/workflows/filebrowser.yaml) | Alpine | Web-based file manager.                         |
| **HomeAssistant** | [![oci-homeassistant-build](https://github.com/thomaschampagne/oci-images/actions/workflows/homeassistant.yaml/badge.svg?branch=main)](https://github.com/thomaschampagne/oci-images/actions/workflows/homeassistant.yaml) | Alpine | Home automation platform.                      |
| **Mosquitto**   | [![oci-mosquitto-build](https://github.com/thomaschampagne/oci-images/actions/workflows/mosquitto.yaml/badge.svg?branch=main)](https://github.com/thomaschampagne/oci-images/actions/workflows/mosquitto.yaml) | Alpine | MQTT broker for IoT.                            |
| **Navidrome**   | [![oci-navidrome-build](https://github.com/thomaschampagne/oci-images/actions/workflows/navidrome.yaml/badge.svg?branch=main)](https://github.com/thomaschampagne/oci-images/actions/workflows/navidrome.yaml) | Alpine | Self-hosted music server.                       |
| **MinIO**       | [![oci-minio-build](https://github.com/thomaschampagne/oci-images/actions/workflows/minio.yaml/badge.svg?branch=main)](https://github.com/thomaschampagne/oci-images/actions/workflows/minio.yaml) | Alpine | S3-compatible object storage.                   |
| **Transmission**| [![oci-transmission-build](https://github.com/thomaschampagne/oci-images/actions/workflows/transmission.yaml/badge.svg?branch=main)](https://github.com/thomaschampagne/oci-images/actions/workflows/transmission.yaml) | Alpine | BitTorrent client.                             |
| **Zigbee2MQTT** | [![oci-zigbee2mqtt-build](https://github.com/thomaschampagne/oci-images/actions/workflows/zigbee2mqtt.yaml/badge.svg?branch=main)](https://github.com/thomaschampagne/oci-images/actions/workflows/zigbee2mqtt.yaml) | Alpine | Zigbee to MQTT bridge.                         |
| **Authelia**    | [![oci-authelia-build](https://github.com/thomaschampagne/oci-images/actions/workflows/authelia.yaml/badge.svg?branch=main)](https://github.com/thomaschampagne/oci-images/actions/workflows/authelia.yaml) | Ubuntu Chisel | Multi-factor authentication server.             |
| **Cloud Domain**| [![oci-cloud-domain-build](https://github.com/thomaschampagne/oci-images/actions/workflows/cloud-domain.yaml/badge.svg?branch=main)](https://github.com/thomaschampagne/oci-images/actions/workflows/cloud-domain.yaml) | Alpine | Domain services for homes and small businesses. |
| **Vault**       | [![oci-vault-build](https://github.com/thomaschampagne/oci-images/actions/workflows/vault.yaml/badge.svg?branch=main)](https://github.com/thomaschampagne/oci-images/actions/workflows/vault.yaml) | Alpine | Vaultwarden password manager. |
| **Minikit**     | [![oci-minikit-build](https://github.com/thomaschampagne/oci-images/actions/workflows/minikit.yaml/badge.svg?branch=main)](https://github.com/thomaschampagne/oci-images/actions/workflows/minikit.yaml) | Alpine | A minimalist BusyBox-style image based on Alpine Linux. |
| **PostgreSQL**  | [![oci-postgres-build](https://github.com/thomaschampagne/oci-images/actions/workflows/postgres.yaml/badge.svg?branch=main)](https://github.com/thomaschampagne/oci-images/actions/workflows/postgres.yaml) | Alpine | Relational database.                           |
| **Tools**       | [![oci-tools-build](https://github.com/thomaschampagne/oci-images/actions/workflows/tools.yaml/badge.svg?branch=main)](https://github.com/thomaschampagne/oci-images/actions/workflows/tools.yaml) | Alpine | Collection of developers handy tools.                           |

## Appendix

### Trigger workflow from remote

- Create `GITHUB_TOKEN` here: <https://github.com/settings/tokens> with `actions:write` permissions.

```bash
export GITHUB_TOKEN=<YOUR_TOKEN>
export GITHUB_REPO=<YOUR_REPO> # e.g. thomaschampagne/focale-images
```

- Get workflow id (<https://docs.github.com/en/rest/actions/workflows?apiVersion=2022-11-28#list-repository-workflows>)

```bash
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/$GITHUB_REPO/actions/workflows
```

- Create a workflow dispatch event (<https://docs.github.com/en/rest/actions/workflows?apiVersion=2022-11-28#create-a-workflow-dispatch-event>)

```bash
export WORKFLOW_ID=<WORKFLOW_ID>
```

```bash
curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/$GITHUB_REPO/actions/workflows/$WORKFLOW_ID/dispatches \
  -d '{"ref":"main"}'
```
