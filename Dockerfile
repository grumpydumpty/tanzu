FROM photon:5.0

# set argument defaults
ARG OS_ARCH="amd64"
ARG OS_ARCH2="x86_64"
ARG TANZU=10.109.195.161
ARG USER=vlabs
ARG USER_ID=1280
ARG GROUP=users
ARG GROUP_ID=100
#ARG LABEL_PREFIX=com.vmware.eocto

# add metadata via labels
#LABEL ${LABEL_PREFIX}.version="0.0.1"
#LABEL ${LABEL_PREFIX}.git.repo="git@gitlab.eng.vmware.com:sydney/containers/tanzu.git"
#LABEL ${LABEL_PREFIX}.git.commit="DEADBEEF"
#LABEL ${LABEL_PREFIX}.maintainer.name="Richard Croft"
#LABEL ${LABEL_PREFIX}.maintainer.email="rcroft@vmware.com"
#LABEL ${LABEL_PREFIX}.maintainer.url="https://gitlab.eng.vmware.com/rcroft/"
#LABEL ${LABEL_PREFIX}.released="9999-99-99"
#LABEL ${LABEL_PREFIX}.based-on="photon:5.0"
#LABEL ${LABEL_PREFIX}.project="containers"

# update repositories, install packages, and then clean up
RUN tdnf update -y && \
    # grab what we can via standard packages
    tdnf install -y bash ca-certificates coreutils curl diffutils git jq ncurses shadow tar unzip && \
    # add user/group
    # groupadd -g ${GROUP_ID} ${GROUP} && \
    useradd -u ${USER_ID} -g ${GROUP} -m ${USER} && \
    chown -R ${USER}:${GROUP} /home/${USER} && \
    # add /workspace and give user permissions
    mkdir -p /workspace && \
    chown -R ${USER_ID}:${GROUP_ID} /workspace && \
    # set git config
    echo -e "[safe]\n\tdirectory=/workspace" > /etc/gitconfig && \
    # grab kubectl vsphere plugins
    curl -skSLo vsphere-plugin.zip https://${TANZU}/wcp/plugin/linux-${OS_ARCH}/vsphere-plugin.zip && \
    unzip -d /usr/local vsphere-plugin.zip && \
    rm -f vsphere-plugin.zip && \
    # grab helm
    HELM_VERSION=$(curl -H 'Accept: application/json' -sSL https://github.com/helm/helm/releases/latest | jq -r '.tag_name') && \
    curl -skSLo helm.tar.gz https://get.helm.sh/helm-${HELM_VERSION}-linux-${OS_ARCH}.tar.gz && \
    tar xzf helm.tar.gz linux-${OS_ARCH}/helm && \
    mv linux-${OS_ARCH}/helm /usr/local/bin/ && \
    chmod 0755 /usr/local/bin/helm && \
    rm -rf helm.tar.gz linux-${OS_ARCH} && \
    # grab kubectx
    KUBECTX_VERSION=$(curl -H 'Accept: application/json' -sSL https://github.com/ahmetb/kubectx/releases/latest | jq -r '.tag_name') && \
    curl -skSLo kubectx.tar.gz https://github.com/ahmetb/kubectx/releases/download/${KUBECTX_VERSION}/kubectx_${KUBECTX_VERSION}_linux_${OS_ARCH2}.tar.gz && \
    tar xzf kubectx.tar.gz kubectx && \    
    mv kubectx /usr/local/bin && \
    chmod 0755 /usr/local/bin/kubectx && \
    rm -rf kubectx.tar.gz && \
    # grab kubens
    KUBENS_VERSION=$(curl -H 'Accept: application/json' -sSL https://github.com/ahmetb/kubectx/releases/latest | jq -r '.tag_name') && \
    curl -skSLo kubens.tar.gz https://github.com/ahmetb/kubectx/releases/download/${KUBENS_VERSION}/kubens_${KUBENS_VERSION}_linux_${OS_ARCH2}.tar.gz && \
    tar xzf kubens.tar.gz kubens && \    
    mv kubens /usr/local/bin && \
    chmod 0755 /usr/local/bin/kubens && \
    rm -rf kubens.tar.gz && \
    # clean up
    tdnf erase -y unzip shadow && \
    tdnf clean all

# set user
USER ${USER}

# set working directory
WORKDIR /workspace

# set entrypoint to a shell
CMD [ "bash" ]

#############################################################################
# vim: ft=unix sync=dockerfile ts=4 sw=4 et tw=78:
