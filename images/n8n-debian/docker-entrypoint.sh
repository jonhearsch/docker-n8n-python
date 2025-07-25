#!/bin/sh
# This script is used to start the n8n service in a Docker container.
if [ "$#" -gt 0 ]; then
  # Got started with arguments
  exec n8n "$@"
else
  # Got started without arguments
  exec n8n
fi
