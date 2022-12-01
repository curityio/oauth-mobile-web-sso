#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"
docker compose --project-name mobileweb logs -f