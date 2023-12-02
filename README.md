# OCI Images

## About

This repository contains a collection of [OCI Images](https://github.com/opencontainers/image-spec) I use in my clusters:

- Built on **STABLE** base images **ONLY**. Versions are specified in each Dockerfile via `OCI_BASE_IMAGE` ARG.

- Build weekly on Sundays and tagged as `YYYY.MM.DD` & `latest`.

- Lower attack surface & vulneralibities:
    - Based on `alpine` lightweight images whenever possible.
    - System updates are applied during build.
    - If missing from base image, it includes a non-root user named `rootless` (`uid:1000`, `gid:1000`).

- Available in my **Packages** section

## Apppendix

### Trigger workflow from remote

- Create `GITHUB_TOKEN` here: https://github.com/settings/tokens with `actions:write` permissions.

```bash
export GITHUB_TOKEN=<YOUR_TOKEN>
export GITHUB_REPO=<YOUR_REPO> # e.g. thomaschampagne/focale-images
```

- Get workflow id (https://docs.github.com/en/rest/actions/workflows?apiVersion=2022-11-28#list-repository-workflows)

```bash
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/$GITHUB_REPO/actions/workflows
```

- Create a workflow dispatch event (https://docs.github.com/en/rest/actions/workflows?apiVersion=2022-11-28#create-a-workflow-dispatch-event)

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