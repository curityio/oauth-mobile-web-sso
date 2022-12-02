#!/bin/bash

############################################################################
# Deploy components and expose the entry point reverse proxy to the internet
############################################################################

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# Check we have a license file
#
if [ ! -f './idsvr/license.json' ]; then
  echo "Please provide a license.json file in the idsvr folder in order to deploy the system"
  exit 1
fi

#
# Prevent accidental checkins of license files
#

#
# Use an ngrok base URL unless one is provided as an environment variables
#
if [ "$RUNTIME_BASE_URL" == '' ]; then

  ngrok version
  if [ $? -ne 0 ]; then
    echo 'Please ensure that the ngrok tool is installed'
    exit 1
  fi

  if [ "$(pgrep ngrok)" == '' ]; then
    ngrok http 80 --log=stdout &
    sleep 5
  fi

  RUNTIME_BASE_URL=$(curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[] | select(.proto == "https") | .public_url')
  if [ "$RUNTIME_BASE_URL" == "" ]; then
    echo 'Problem encountered getting an NGROK URL'
    exit 1
  fi
fi

#
# Clear leftover data on the Docker shared volume
#
rm -rf idsvr/data

#
# Set the final base URL
#
echo "The internet base URL is: $RUNTIME_BASE_URL"
export RUNTIME_BASE_URL

#
# Update mobile app configuration to use the base URL
#
envsubst < ./ios-app/mobile-config-template.json > ./ios-app/mobile-config.json

#
# Run the docker deployment
#
docker compose --project-name mobileweb up --force-recreate --detach
if [ $? -ne 0 ]; then
  echo 'Problem encountered deploying components to Docker'
  exit 1
fi

#
# View logs in a child window
#
open -a Terminal ./logs.sh
