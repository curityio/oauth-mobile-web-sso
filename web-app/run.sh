#!/bin/bash

############################################################
# Run a development host to allow files to be edited locally
############################################################

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# Build the custom Docker image
#
docker build -t webhost:1.35 .
if [ $? -ne 0 ]; then
  echo 'Problem encountered building the webhost development container'
  exit 1
fi

#
# Run the HTTP server in Docker
#
echo 'Running web host on port 80 ...'
docker compose up
if [ $? -ne 0 ]; then
  echo 'Problem encountered running the webhost development container'
  exit 1
fi
