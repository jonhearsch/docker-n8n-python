# Use a more recent and stable Node.js/Python base image if possible, or verify 'nikolaik/python-nodejs:python3.13-nodejs24' is Debian-based for apt.
# Based on search results, nikolaik/python-nodejs is likely Debian-based (bookworm).
FROM nikolaik/python-nodejs:python3.13-nodejs24

# --- User Setup (Keep as you have it, good for security) ---
# Changing user `pn` to `node`
RUN usermod --login node --move-home --home /home/node pn
RUN groupmod --new-name node pn

ARG N8N_VERSION

RUN if [ -z "$N8N_VERSION" ] ; then echo "The N8N_VERSION argument is missing!" ; exit 1; fi

# --- System Dependencies (Add FFmpeg, potentially ImageMagick) ---
# Using `apt-get` as it's likely Debian-based
RUN \
    apt-get update && \
    # Added ffmpeg for video conversion and general media handling
    # Added imagemagick for image processing (often works well with HEIF libs)
    # libheif-examples includes heif-convert, useful for direct HEIC conversion
    apt-get -y install \
        ffmpeg \
        imagemagick \
        gosu \
        git \
        libheif-dev \
        libde265-dev \
        libjpeg-dev \
        libpng-dev \
        libtiff-dev \
        libheif-examples \
        && rm -rf /var/lib/apt/lists/*

# --- Python Environment Setup ---
# Switch to root temporarily for system-wide Python installs if needed,
# though pip install is usually fine under non-root when paths are handled.
# Set a custom user to not have n8n run as root (n8n will switch back to 'node' user)
USER root

# Create a dedicated directory for Python requirements to keep things clean
RUN mkdir -p /opt/python_deps

# Copy requirements.txt FIRST to leverage Docker caching
COPY requirements.txt /opt/python_deps/requirements.txt

# --- IMPORTANT: Ensure Python dependencies are installed in a way accessible to 'node' user ---
# Using a virtual environment is the most robust way in Docker.
# This creates a venv, activates it implicitly for the pip install,
# and makes the venv's binaries available via a PATH adjustment later.
RUN python3 -m venv /opt/venv \
    && /opt/venv/bin/pip install --upgrade pip setuptools wheel \
    && /opt/venv/bin/pip install -r /opt/python_deps/requirements.txt

# --- Node.js/n8n Installation ---
# Ensure npm's global install path is accessible and the correct user runs it
# npm_config_user=root is good here for global installs
# Adding --unsafe-perm for potential issues with certain npm packages
RUN npm_config_user=root npm install -g --unsafe-perm full-icu n8n@${N8N_VERSION}

# --- Optional: Install n8n-nodes-python module ---
# This line is correct if you are using the n8n-nodes-python module specifically.
# If you are just calling Python scripts via 'Execute Command' or 'Execute Command Batch',
# you don't necessarily need this node module.
# RUN cd /usr/lib/node_modules/n8n && npm install n8n-nodes-python

ENV NODE_ICU_DATA /usr/lib/node_modules/full-icu

# Set PATH to include the Python virtual environment's bin directory
# This ensures that when n8n (running as 'node' user) executes commands,
# it can find Python and your installed packages.
ENV PATH="/opt/venv/bin:${PATH}"

WORKDIR /data

COPY docker-entrypoint.sh /docker-entrypoint.sh
# Ensure the entrypoint script is executable
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 5678/tcp

# Switch back to the 'node' user for security best practices for the running container
USER node
