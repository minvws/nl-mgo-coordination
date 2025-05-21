FROM alpine:3.21

RUN apk add --no-cache openssl bash jq

COPY max/clients.json .

COPY --chmod=0755 secrets-manager/scripts/generate_zmodules_certs.sh /scripts/generate_zmodules_certs.sh
COPY --chmod=0755 secrets-manager/scripts/setup_secrets.sh /scripts/setup_secrets.sh
COPY --chmod=0755 secrets-manager/entrypoint.sh /entrypoint.sh

ENTRYPOINT /entrypoint.sh
