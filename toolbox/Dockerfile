FROM python:3-alpine

# versions to install
ARG JSON2HCL_VERSION=0.0.6
ARG TUVOK_VERSION=v0.0.4

# pre-reqs for toolbox & tuvok
RUN apk --update add bash git openssh openssl curl wget py-pip jq
RUN wget https://github.com/rackspace-infrastructure-automation/tfenv/archive/v0.6.0.zip -O - | unzip -d /var/opt - \
  && chmod +x /var/opt/tfenv-0.6.0/bin/* /var/opt/tfenv-0.6.0/libexec/* \
  && ln -s /var/opt/tfenv-0.6.0/bin/* /usr/local/bin
RUN pip install --upgrade pip && pip install --progress-bar=off awscli

# tuvok and json2hcl, then run tuvok once to be sure it loads correctly
ADD https://github.com/kvz/json2hcl/releases/download/v${JSON2HCL_VERSION}/json2hcl_v${JSON2HCL_VERSION}_linux_amd64 /usr/local/bin/json2hcl
RUN chmod +x /usr/local/bin/json2hcl
RUN pip install git+https://github.com/rackerlabs/tuvok.git@$TUVOK_VERSION

# recent terraform versions
RUN tfenv install 0.11.13
RUN tfenv install 0.11.11
RUN tfenv install 0.11.8
RUN tfenv install 0.11.7
RUN tfenv install 0.11.4

RUN tfenv use 0.11.8

# Google SDK
# https://github.com/GoogleCloudPlatform/cloud-sdk-docker/blob/master/alpine/Dockerfile
ARG CLOUD_SDK_VERSION="264.0.0"
ARG PACKER_VERSION="1.4.3"
ARG VAULT_VERSION="1.2.3"
ARG KUBECTL_VERSION="v1.16.0"

ENV CLOUD_SDK_VERSION=$CLOUD_SDK_VERSION
ENV PATH /google-cloud-sdk/bin:$PATH
RUN apk --no-cache add \
        unzip \
        py3-crcmod \
        bash \
        libc6-compat \
        openssh-client \
        gnupg \
    && curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true && \
    gcloud config set metrics/environment github_docker_image && \
    gcloud --version && \
    ## Packer + Vault + Kubectl
    curl -LO https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl && chmod +x ./kubectl && mv ./kubectl /usr/local/bin && \
    curl https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip  -o /tmp/packer.zip && \
    curl https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip -o /tmp/vault.zip && \
    cd /tmp && unzip '*.zip' && \
    mv packer vault /usr/local/bin && rm -rf /tmp/* && \
    pip install yamllint pylint


# scripts from toolbox
COPY ./bin/* /var/opt/rackspace/bin/
RUN ln -s /var/opt/rackspace/bin/* /usr/local/bin/
WORKDIR /rackspace
