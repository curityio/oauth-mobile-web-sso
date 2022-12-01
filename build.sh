#!/bin/bash

#############################################################
# Build the code for deployable components into Docker images
#############################################################

#
# Build the web host
#
docker build -f web-app/Dockerfile -t webhost:1.35 .

#
# Build the nonce authenticator
#

#
# Build the OAuth agent
#