FROM ubuntu:24.04

LABEL maintainer="jon@hearsch.net"
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies and Node.js 22.x
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gnupg \
    build-essential \
    git \
    ffmpeg \
    intel-media-va-driver \
    vainfo \
    imagemagick \
    libheif-dev \
    libde265-dev \
    tzdata \
    jq \
    && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set up environment variables for n8n
ENV N8N_PORT=5678 \
    N8N_BASIC_AUTH_ACTIVE=false \
    NODE_ICU_DATA=/usr/local/lib/node_modules/full-icu \
    HOME=/home/node \
    N8N_USER_FOLDER=/home/node/.n8n

# Install n8n (latest)
RUN npm install -g full-icu n8n@latest

# Create non-root user and set up home
RUN useradd -ms /bin/bash node && mkdir -p /home/node/.n8n && chown -R node:node /home/node
USER node
WORKDIR /home/node

EXPOSE 5678

# Entry point for n8n
CMD ["n8n"]
