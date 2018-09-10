FROM alpine:3.8

RUN apk --update add bash git openssh curl \
  && wget https://github.com/rackspace-infrastructure-automation/tfenv/archive/v0.6.0.zip -O - | unzip -d /var/opt - \
  && chmod +x /var/opt/tfenv-0.6.0/bin/* /var/opt/tfenv-0.6.0/libexec/* \
  && ln -s /var/opt/tfenv-0.6.0/bin/* /usr/local/bin

RUN tfenv install 0.11.8
RUN tfenv install 0.11.7
RUN tfenv install 0.11.4

RUN tfenv use 0.11.8

COPY repository_template/bin/* /var/opt/rackspace/bin/
RUN ln -s /var/opt/rackspace/bin/* /usr/local/bin/
WORKDIR /rackspace
