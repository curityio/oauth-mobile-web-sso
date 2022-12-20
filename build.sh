#!/bin/bash

#############################################################
# Build the code for deployable components into Docker images
#############################################################

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# Prevent checkins of secrets
#
cp ./hooks/pre-commit ./.git/hooks

#
# Build the web content
#
cd web-app
if [ ! -d 'node_modules' ]; then
  npm install
  if [ $? -ne 0 ]; then
    echo 'Problem encountered installing SPA dependencies'
    exit 1
  fi
fi

npm run build
if [ $? -ne 0 ]; then
  echo 'Problem encountered building the SPA'
  exit 1
fi

#
# Build the Dockerfile for the web host
#
docker build -t webhost:1.35 .
if [ $? -ne 0 ]; then
  echo 'Problem encountered building the nonce authenticator'
  exit 1
fi
cd ..

#
# Build the nonce authenticator and keep only JAR files in the target folder
#
rm -rf resources 2>/dev/null
mkdir resources
cd resources
git clone https://github.com/curityio/nonce-authenticator
if [ $? -ne 0 ]; then
  echo 'Problem encountered downloading the nonce authenticator'
  exit 1
fi

cd nonce-authenticator

#
# TODO: remove after merging the nonce authenticator
#
git checkout feature/resources

mvn package
if [ $? -ne 0 ]; then
  echo 'Problem encountered building the nonce authenticator'
  exit 1
fi
rm -rf target/classes
rm -rf target/generated-sources
rm -rf target/maven-*

#
# Build the OAuth agent
#
git clone https://github.com/curityio/oauth-agent-node-express oauthagent
if [ $? -ne 0 ]; then
  echo 'Problem encountered downloading the OAuth agent'
  exit 1
fi

cd oauthagent
npm install
if [ $? -ne 0 ]; then
  echo "Problem encountered installing the OAuth Agent dependencies"
  exit 1
fi

npm run build
if [ $? -ne 0 ]; then
  echo "Problem encountered building the OAuth Agent code"
  exit 1
fi

docker build -t oauthagent:1.0 .
if [ $? -ne 0 ]; then
  echo "Problem encountered building the OAuth Agent Docker image"
  exit 1
fi
cd ..