# Getting Started

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
