#!/bin/bash

#############################################################
# Build the code for deployable components into Docker images
#############################################################

cd "$(dirname "${BASH_SOURCE[0]}")"
rm -rf resources 2>/dev/null

#
# Prevent checkins of secrets
#
cp ./hooks/pre-commit ./.git/hooks

#
# Build the web host
#
docker build -f web-app/Dockerfile -t webhost:1.35 .

#
# Download the nonce authenticator
#
mkdir resources
cd resources
git clone https://github.com/curityio/nonce-authenticator
if [ $? -ne 0 ]; then
  echo 'Problem encountered downloading the nonce authenticator'
  exit 1
fi

#
# Build it and keep only the JAR files, so that we can deploy the target folder as a Docker volume
#
cd nonce-authenticator
mvn package
if [ $? -ne 0 ]; then
  echo 'Problem encountered building the nonce authenticator'
  exit 1
fi
rm -rf target/classes
rm -rf target/generated-sources
rm -rf target/maven-*
cd ../..

#
# Build the OAuth agent
#