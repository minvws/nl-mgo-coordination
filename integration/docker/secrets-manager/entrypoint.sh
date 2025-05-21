#!/bin/sh

./scripts/setup_secrets.sh
./scripts/generate_zmodules_certs.sh

chmod -R 755 /prs-secrets
chmod -R 755 /secrets
