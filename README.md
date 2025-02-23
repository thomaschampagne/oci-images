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

- [![oci-filebrowser-build](https://github.com/thomaschampagne/oci-images/actions/workflows/filebrowser.yaml/badge.svg?branch=main)](https://github.com/thomaschampagne/oci-images/actions/workflows/filebrowser.yaml)
- [![oci-homeassistant-build](https://github.com/thomaschampagne/oci-images/actions/workflows/homeassistant.yaml/badge.svg?branch=main)](https://github.com/thomaschampagne/oci-images/actions/workflows/homeassistant.yaml)
- [![oci-mosquitto-build](https://github.com/thomaschampagne/oci-images/actions/workflows/mosquitto.yaml/badge.svg?branch=main)](https://github.com/thomaschampagne/oci-images/actions/workflows/mosquitto.yaml)
- [![oci-navidrome-build](https://github.com/thomaschampagne/oci-images/actions/workflows/navidrome.yaml/badge.svg?branch=main)](https://github.com/thomaschampagne/oci-images/actions/workflows/navidrome.yaml)
- [![oci-minio-build](https://github.com/thomaschampagne/oci-images/actions/workflows/minio.yaml/badge.svg?branch=main)](https://github.com/thomaschampagne/oci-images/actions/workflows/minio.yaml)
- [![oci-pydav-build](https://github.com/thomaschampagne/oci-images/actions/workflows/pydav.yaml/badge.svg?branch=main)](https://github.com/thomaschampagne/oci-images/actions/workflows/pydav.yaml)
- [![oci-transmission-build](https://github.com/thomaschampagne/oci-images/actions/workflows/transmission.yaml/badge.svg?branch=main)](https://github.com/thomaschampagne/oci-images/actions/workflows/transmission.yaml)
- [![oci-zigbee2mqtt-build](https://github.com/thomaschampagne/oci-images/actions/workflows/zigbee2mqtt.yaml/badge.svg?branch=main)](https://github.com/thomaschampagne/oci-images/actions/workflows/zigbee2mqtt.yaml)
- [![oci-authelia-build](https://github.com/thomaschampagne/oci-images/actions/workflows/authelia.yaml/badge.svg?branch=main)](https://github.com/thomaschampagne/oci-images/actions/workflows/authelia.yaml)
- [![oci-cloud-domain-build](https://github.com/thomaschampagne/oci-images/actions/workflows/cloud-domain.yaml/badge.svg?branch=main)](https://github.com/thomaschampagne/oci-images/actions/workflows/cloud-domain.yaml)
- [![oci-postgres-build](https://github.com/thomaschampagne/oci-images/actions/workflows/postgres.yaml/badge.svg?branch=main)](https://github.com/thomaschampagne/oci-images/actions/workflows/postgres.yaml)

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
