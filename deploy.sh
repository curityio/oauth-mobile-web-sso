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
# Use an ngrok base URL unless one is provided as an environment variable
#
if [ "$BASE_URL" == '' ]; then

  ngrok version
  if [ $? -ne 0 ]; then
    echo 'Please ensure that the ngrok tool is installed'
    exit 1
  fi

  if [ "$(pgrep ngrok)" == '' ]; then
    ngrok http 80 --log=stdout &
    sleep 5
  fi

  BASE_URL=$(curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[] | select(.proto == "https") | .public_url')
  if [ "$BASE_URL" == "" ]; then
    echo 'Problem encountered getting an NGROK URL'
    exit 1
  fi
fi

#
# Set environment variables
#
echo "The base URL is: $BASE_URL"
export BASE_URL

#
# Update mobile app configuration to use the base URL
#
envsubst < ./ios-app/mobile-config-template.json > ./ios-app/mobile-config.json
if [ $? -ne 0 ]; then
  echo 'Problem encountered using envsubst to update mobile configuration'
  exit 1
fi

#
# Supply OAuth agent environment variables
#
export SPA_COOKIE_DOMAIN="$(echo $BASE_URL | awk -F/ '{print $3}')"
export SPA_COOKIE_ENCRYPTION_KEY=$(openssl rand 32 | xxd -p -c 64)
export INTERNAL_IDVSR_BASE_URL='http://identityserver:8443'

#
# Clear leftover data on the Docker shared volume
#
rm -rf idsvr/data

#
# Run the docker deployment
#
docker compose --project-name mobileweb up --force-recreate --detach
if [ $? -ne 0 ]; then
  echo 'Problem encountered deploying components to Docker'
  exit 1
fi
