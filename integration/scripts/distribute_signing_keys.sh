#!/bin/bash

set -e

LOAD_SECRETS_DIR="$(pwd)/submodules/load/secrets"
DVP_PROXY_SECRETS_DIR="$(pwd)/submodules/dvp-proxy/services/proxy/secrets"
TMP_SECRETS_DIR="$(pwd)/tmp_secrets"

echo "Using load secrets directory: $LOAD_SECRETS_DIR"
echo "Using dvp-proxy secrets directory: $DVP_PROXY_SECRETS_DIR"
mkdir -p "$LOAD_SECRETS_DIR"
mkdir -p "$DVP_PROXY_SECRETS_DIR"
mkdir -p "$TMP_SECRETS_DIR"

echo "Generating signing keys in temporary directory"
./submodules/load/tools/generate-sign-key.sh "$TMP_SECRETS_DIR"

echo "Moving keys to their final destinations"
mv "$TMP_SECRETS_DIR/private_signing.pem" "$LOAD_SECRETS_DIR/"
mv "$TMP_SECRETS_DIR/public_signing.pem" "$DVP_PROXY_SECRETS_DIR/"

echo "Cleaning up temporary directory"
rmdir "$TMP_SECRETS_DIR"

echo "Generated private key in $LOAD_SECRETS_DIR and public key in $DVP_PROXY_SECRETS_DIR"

cp ./submodules/load/app.conf.example ./submodules/load/app.conf
