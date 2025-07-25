FROM node:18-bullseye-slim

LABEL maintainer="jon@hearsch.net"
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
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
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user for n8n
RUN useradd --system --user-group --create-home node

# Set up environment variables for n8n
ENV N8N_PORT=5678 \
    N8N_BASIC_AUTH_ACTIVE=false \
    NODE_ICU_DATA=/usr/local/lib/node_modules/full-icu \
    HOME=/home/node \
    N8N_USER_FOLDER=/home/node/.n8n

# Install n8n (latest)
RUN npm install -g full-icu n8n@latest

# Switch to non-root user
USER node
WORKDIR /home/node

# Ensure persistent folder for workflows, credentials, etc.
RUN mkdir -p /home/node/.n8n

EXPOSE 5678

# Entry point for n8n
CMD ["n8n"]
