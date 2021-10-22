FROM python:3-alpine

# versions to install
ARG TUVOK_VERSION=v0.1.3

# pre-reqs for toolbox & tuvok
RUN apk --update add bash git openssh openssl curl wget py-pip jq
RUN wget https://github.com/rackspace-infrastructure-automation/tfenv/archive/v0.6.0.zip -O - | unzip -d /var/opt - \
  && chmod +x /var/opt/tfenv-0.6.0/bin/* /var/opt/tfenv-0.6.0/libexec/* \
  && ln -s /var/opt/tfenv-0.6.0/bin/* /usr/local/bin
RUN pip install --upgrade pip && pip install --progress-bar=off awscli

# install tuvok
RUN pip install git+https://github.com/rackerlabs/tuvok.git@$TUVOK_VERSION

# recent terraform versions
RUN tfenv install 0.14.11
RUN tfenv install 0.12.20
RUN tfenv install 0.12.17
RUN tfenv install 0.11.14
RUN tfenv install 0.11.13
RUN tfenv install 0.11.11
RUN tfenv install 0.11.8
RUN tfenv install 0.11.7
RUN tfenv install 0.11.4

RUN tfenv use 0.14.11

# scripts from toolbox
COPY ./bin/* /var/opt/rackspace/bin/
RUN ln -s /var/opt/rackspace/bin/* /usr/local/bin/
WORKDIR /rackspace
