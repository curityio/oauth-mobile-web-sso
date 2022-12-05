#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# Free Docker resources
#
docker compose --project-name mobileweb down

#
# Free ngrok resources if required
#
if [ "$BASE_URL" == '' ]; then
    kill -9 $(pgrep ngrok) 2>/dev/null
fi