FROM photon:4.0

# set argument defaults
ARG TANZU=10.109.195.161
ARG LABEL_PREFIX=com.vmware.eocto

# add metadata via labels
LABEL ${LABEL_PREFIX}.version="0.0.1"
LABEL ${LABEL_PREFIX}.git.repo="git@gitlab.eng.vmware.com:sydney/containers/tanzu.git"
LABEL ${LABEL_PREFIX}.git.commit="DEADBEEF"
LABEL ${LABEL_PREFIX}.maintainer.name="Richard Croft"
LABEL ${LABEL_PREFIX}.maintainer.email="rcroft@vmware.com"
LABEL ${LABEL_PREFIX}.released="9999-99-99"
LABEL ${LABEL_PREFIX}.based-on="photon:4.0"
LABEL ${LABEL_PREFIX}.project="commonpool"

# set working directory
WORKDIR /root

# update repositories, install packages, and then clean up
RUN tdnf update -y && \
    tdnf install -y jq ncurses unzip && \
    # grab vsphere kubectl plugins
    curl -skSLo vsphere-plugin.zip https://${TANZU}/wcp/plugin/linux-amd64/vsphere-plugin.zip && \
    unzip -d /usr/local vsphere-plugin.zip && \
    rm -f vsphere-plugin.zip && \
    # grab helm
    curl -skSL https://get.helm.sh/helm-v3.11.2-linux-amd64.tar.gz -o helm-v3.11.2-linux-amd64.tar.gz && \
    tar xzf helm-v3.11.2-linux-amd64.tar.gz linux-amd64/helm && \
    mv linux-amd64/helm /usr/local/bin/ && \
    rm -rf helm-v3.11.2-linux-amd64.tar.gz linux-amd64 && \
    # grab kubectx/kubens
    curl -o kubens https://raw.githubusercontent.com/ahmetb/kubectx/master/kubens && \
    curl -o kubectx https://raw.githubusercontent.com/ahmetb/kubectx/master/kubectx && \
    mv kubens kubectx /usr/local/bin && \
    chmod 0755 /usr/local/bin/kubectx && \
    chmod 0755 /usr/local/bin/kubens && \
    # clean up
    tdnf erase -y unzip && \
    tdnf clean all

CMD [ "bash" ]

#############################################################################
# vim: ft=unix sync=dockerfile ts=4 sw=4 et tw=78:
