FROM python:3-alpine

# versions to install
ARG JSON2HCL_VERSION=0.0.6
ARG TUVOK_VERSION=v0.0.2

# pre-reqs for toolbox & tuvok
RUN apk --update add bash git openssh curl py-pip jq
Run wget https://github.com/rackspace-infrastructure-automation/tfenv/archive/v0.6.0.zip -O - | unzip -d /var/opt - \
  && chmod +x /var/opt/tfenv-0.6.0/bin/* /var/opt/tfenv-0.6.0/libexec/* \
  && ln -s /var/opt/tfenv-0.6.0/bin/* /usr/local/bin
RUN pip install --upgrade pip && pip install --progress-bar=off awscli

# tuvok and json2hcl
ADD https://github.com/kvz/json2hcl/releases/download/v${JSON2HCL_VERSION}/json2hcl_v${JSON2HCL_VERSION}_linux_amd64 /json2hcl
RUN chmod +x /json2hcl
RUN pip install git+https://github.com/rackerlabs/tuvok.git@$TUVOK_VERSION

# recent terraform versions
RUN tfenv install 0.11.9
RUN tfenv install 0.11.8
RUN tfenv install 0.11.7
RUN tfenv install 0.11.4

RUN tfenv use 0.11.8

# scripts from toolbox
COPY ./bin/* /var/opt/rackspace/bin/
RUN ln -s /var/opt/rackspace/bin/* /usr/local/bin/
WORKDIR /rackspace
