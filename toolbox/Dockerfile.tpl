FROM hashicorp/terraform:{{ version }}
COPY repository_template/bin/* /opt/rackspace/bin/
RUN ln -s /opt/rackspace/bin/* /usr/bin/
WORKDIR /rackspace
ENTRYPOINT []
