# Ansible UI Dockerfile

# Pull base image.
FROM ubuntu:18.04

SHELL ["/bin/bash", "-c"]

# Install.
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get install -y build-essential && \
  apt-get install -y software-properties-common && \
  apt-get install -y git curl python-pip nodejs npm && \
  apt-add-repository --yes --update ppa:ansible/ansible && \
  apt-get install -y ansible && \
  rm -rf /var/lib/apt/lists/*

# Set environment variables.
ENV HOME /root

# Define working directory.
WORKDIR /root

# Setup python environment
RUN \
  pip install pywinrm[credssp] requests-credssp boto3 boto botocore

# Install nci-ansible-io
RUN \
  git clone https://github.com/avishayil/ansible-ui-example /srv/nci-ansible-ui && \
  cd /srv/nci-ansible-ui/ansible-ui && \
  npm install && \
  sed -i -e 's/host: 127.0.0.1/host: ""/g' data/config.yaml

# Define working directory
WORKDIR /srv/nci-ansible-ui/ansible-ui

# Run nci server

EXPOSE 3000
CMD [ "node_modules/.bin/nci" ]