#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# Free Docker resources
#
docker compose --project-name mobileweb down

#
# Free ngrok resources if required
#
NGROK_PID="$(pgrep ngrok)"
if [ "$NGROK_PID" != '' ]; then
    kill -9 $NGROK_PID 2>/dev/null
fi