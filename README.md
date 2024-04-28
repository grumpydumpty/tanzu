# Container Image for VMware tanzu on PowerShell Core

![](logo.png)

## Overview

Provides a container image for running VMware vSphere with Tanzu command line utilities.

This image includes the following components:

| Component                 | Version | Description                                                                 |
|---------------------------|---------|-----------------------------------------------------------------------------|
| VMware Photon OS          | x.y.z   | A Linux container host optimized for vSphere and cloud-computing platforms. |
| kubectl / kubectl-vsphere | x.y.z   |                                                                             |
| kubectx / kubens          | x.y.z   |                                                                             |
| Helm                      | 3.11.2  | Package manager for Kubernetes                                              |

## Get Started

Run the following to download the latest container from Docker Hub:

```bash
docker pull harbor.sydeng.vmware.com/rcroft/tanzu:latest
```

Run the following to download a specific version from Docker Hub:

```bash
docker pull harbor.sydeng.vmware.com/rcroft/tanzu:x.y.z
```

Open an interactive terminal:

```bash
docker run --rm -it harbor.sydeng.vmware.com/rcroft/tanzu
kubectl vsphere login --insecure-skip-tls-verify --server=10.109.195.151
kubectx
kubens
```

Run a local script:

```bash
docker run --rm -v /path/to/k8s/yaml:/tmp/shared -w /tmp/sharedharbor.sydeng.vmware.com/rcroft/tanzu
```

Where ` -w /path/to/k8s/yaml` is the local path for your Kubernetes YAML files.

## Variables

### Harbor Variables

These can be set at any level but we generally set them at the group or project level.

| Variable        | Value                                                                           |
|-----------------|---------------------------------------------------------------------------------|
| HARBOR_HOST     | hostname of harbor instance, no `http://` or `https://`                         |
| HARBOR_CERT     | PEM format certificate with each `\n` (actual char) replaced with `"\n"` string |
|                 | Run the following command:                                                      |
|                 | `cat harbor.crt \| sed -E '$!s/$/\\n/' \| tr -d '\n'`                           |
|                 | where `harbor.crt`                                                              |
| HARBOR_USER     | Username of harbor user with permissions to push images                         |
| HARBOR_EMAIL    | Email  of harbor user with permissions to push images                           |
| HARBOR_PASSWORD | Password of harbor user with permissions to push images                         |

### GitLab Variables

| GitLab Env Var            | Value |
|---------------------------|-------|
| CI_COMMIT_AUTHOR          |       |
| CI_COMMIT_BRANCH          |       |
| CI_COMMIT_SHA             |       |
| CI_COMMIT_SHORT_SHA       |       |
| CI_COMMIT_TIMESTAMP       |       |
| CI_PAGES_DOMAIN           |       |
| CI_PAGES_URL              |       |
| CI_PIPELINE_CREATED_AT    |       |
| CI_PROJECT_DIR            |       |
| CI_PROJECT_NAME           |       |
| CI_PROJECT_NAMESPACE      |       |
| CI_PROJECT_PATH           |       |
| CI_PROJECT_PATH_SLUG      |       |
| CI_PROJECT_ROOT_NAMESPACE |       |
| CI_PROJECT_TITLE          |       |
| CI_PROJECT_URL            |       |
| CI_SERVER_HOST            |       |
| CI_SERVER_PORT            |       |
| CI_SERVER_PROTOCOL        |       |
| CI_SERVER_URL             |       |
| CI_TEMPLATE_REGISTRY_HOST |       |
| GITLAB_USER_EMAIL         |       |
| GITLAB_USER_LOGIN         |       |
| GITLAB_USER_NAME          |       |

## Credits

_Originally based off:_

- _[tenthirtyam/container-powerclicore](https://github.com/tenthirtyam/container-powerclicore/)_
- _[tenthirtyam/container-terraform](https://github.com/tenthirtyam/container-terraform/)_

## Package Versions

<!-- snip -->
| Package | Version |
|---------|---------|
| HELM | v3.14.4 |
| KUBECTX | v0.9.5 |
| KUBENS | v0.9.5 |
