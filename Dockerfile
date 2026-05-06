FROM python:3.12-slim

ARG TF_VERSION=1.10.3

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    wget \
    unzip \
    git \
    bash \
    ca-certificates \
    jq && \
    pip install --no-cache-dir awscli && \
    wget -q https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip && \
    unzip -q terraform_${TF_VERSION}_linux_amd64.zip -d /usr/local/bin/ && \
    rm terraform_${TF_VERSION}_linux_amd64.zip && \
    terraform version && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
ENTRYPOINT ["/bin/bash"]
