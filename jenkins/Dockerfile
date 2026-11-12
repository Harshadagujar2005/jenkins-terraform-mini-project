FROM jenkins/jenkins:lts-jdk17

USER root

# Docker CLI, curl, unzip
RUN apt-get update && \
    (apt-get install -y --no-install-recommends docker-cli || apt-get install -y --no-install-recommends docker.io) && \
    apt-get install -y --no-install-recommends curl unzip ca-certificates gnupg && \
    rm -rf /var/lib/apt/lists/*

# Node.js 20
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Terraform
ARG TF_VERSION=1.9.8
RUN ARCH=$(dpkg --print-architecture) && \
    curl -fsSL -o /tmp/tf.zip https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_${ARCH}.zip && \
    unzip /tmp/tf.zip -d /usr/local/bin && rm /tmp/tf.zip && \
    terraform version

RUN docker --version

# Runs as root so Jenkins can use the mounted Docker socket (fine for a local learning setup)
USER root
