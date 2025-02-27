FROM base:dev

# set argument defaults
ARG OS_ARCH="amd64"
ARG OS_ARCH2="x86_64"
ARG VCENTER=10.109.195.161
ARG USER=vlabs
ARG GROUP=users

# Switch to root to install OS packages
USER root:root

# update repositories, install packages, and then clean up
RUN tdnf update -y && \
    # grab what we can via standard packages
    # tdnf install -y \
    #     package-1 \
    #     package-2 && \
    # clean up
    tdnf clean all

# # grab kubectl vsphere plugins
# RUN curl -skSLo vsphere-plugin.zip https://${VCENTER}/wcp/plugin/linux-${OS_ARCH}/vsphere-plugin.zip && \
#     unzip -d /usr/local vsphere-plugin.zip && \
#     chown root:root /usr/local/bin/kubectl-vsphere && \
#     chmod 0755 /usr/local/bin/kubectl-vsphere && \
#     rm -f vsphere-plugin.zip

# grab helm
RUN HELM_VERSION=$(curl -H 'Accept: application/json' -sSL https://github.com/helm/helm/releases/latest | jq -r '.tag_name') && \
    curl -skSLo helm.tar.gz https://get.helm.sh/helm-${HELM_VERSION}-linux-${OS_ARCH}.tar.gz && \
    tar xzf helm.tar.gz linux-${OS_ARCH}/helm && \
    mv linux-${OS_ARCH}/helm /usr/local/bin/ && \
    chown root:root /usr/local/bin/helm && \
    chmod 0755 /usr/local/bin/helm && \
    rm -rf helm.tar.gz linux-${OS_ARCH}

# grab kubectx
RUN KUBECTX_VERSION=$(curl -H 'Accept: application/json' -sSL https://github.com/ahmetb/kubectx/releases/latest | jq -r '.tag_name') && \
    curl -skSLo kubectx.tar.gz https://github.com/ahmetb/kubectx/releases/download/${KUBECTX_VERSION}/kubectx_${KUBECTX_VERSION}_linux_${OS_ARCH2}.tar.gz && \
    tar xzf kubectx.tar.gz kubectx && \
    mv kubectx /usr/local/bin && \
    chown root:root /usr/local/bin/kubectx && \
    chmod 0755 /usr/local/bin/kubectx && \
    rm -rf kubectx.tar.gz

# grab kubens
RUN KUBENS_VERSION=$(curl -H 'Accept: application/json' -sSL https://github.com/ahmetb/kubectx/releases/latest | jq -r '.tag_name') && \
    curl -skSLo kubens.tar.gz https://github.com/ahmetb/kubectx/releases/download/${KUBENS_VERSION}/kubens_${KUBENS_VERSION}_linux_${OS_ARCH2}.tar.gz && \
    tar xzf kubens.tar.gz kubens && \
    mv kubens /usr/local/bin && \
    chown root:root /usr/local/bin/kubens && \
    chmod 0755 /usr/local/bin/kubens && \
    rm -rf kubens.tar.gz

# grab clusterctl
RUN CLUSTERCTL_VERSION=$(curl -H 'Accept: application/json' -sSL https://github.com/kubernetes-sigs/cluster-api/releases/latest  | jq -r '.tag_name' | tr -d 'v') && \
    curl -skSLo clusterctl https://github.com/kubernetes-sigs/cluster-api/releases/download/v${CLUSTERCTL_VERSION}/clusterctl-linux-${OS_ARCH} && \
    mv clusterctl /usr/local/bin/clusterctl && \
    chown root:root /usr/local/bin/clusterctl && \
    chmod 0755 /usr/local/bin/clusterctl

# grab k9s
RUN K9S_VERSION=$(curl -H 'Accept: application/json' -sSL https://github.com/derailed/k9s/releases/latest | jq -r '.tag_name') && \
    curl -skSLo k9s.tar.gz https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_${OS_ARCH}.tar.gz && \
    tar xzf k9s.tar.gz k9s && \
    mv k9s /usr/local/bin && \
    chown root:root /usr/local/bin/k9s && \
    chmod 0755 /usr/local/bin/k9s && \
    rm -f k9s.tar.gz

# switch back to non-root user
USER ${USER}:${GROUP}

#############################################################################
# vim: ft=unix sync=dockerfile ts=4 sw=4 et tw=78:
