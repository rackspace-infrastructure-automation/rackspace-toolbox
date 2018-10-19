FROM python:3-alpine

RUN apk --update add bash git openssh curl py-pip
Run wget https://github.com/rackspace-infrastructure-automation/tfenv/archive/v0.6.0.zip -O - | unzip -d /var/opt - \
  && chmod +x /var/opt/tfenv-0.6.0/bin/* /var/opt/tfenv-0.6.0/libexec/* \
  && ln -s /var/opt/tfenv-0.6.0/bin/* /usr/local/bin
RUN pip install --upgrade pip && pip install --progress-bar=off awscli

ARG TUVOK_VERSION=0.0.1
RUN wget https://github.com/rackerlabs/tuvok/archive/v$TUVOK_VERSION.zip -O /var/opt/tuvok.zip
RUN unzip /var/opt/tuvok.zip -d /var/opt
RUN cd /var/opt/tuvok-$TUVOK_VERSION && pip install -e .

RUN tfenv install 0.11.9
RUN tfenv install 0.11.8
RUN tfenv install 0.11.7
RUN tfenv install 0.11.4

RUN tfenv use 0.11.8

COPY ./bin/* /var/opt/rackspace/bin/
RUN ln -s /var/opt/rackspace/bin/* /usr/local/bin/
WORKDIR /rackspace
