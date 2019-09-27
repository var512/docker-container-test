#!/usr/bin/env bash
set -o errexit # exit on fail
set -o errtrace # err trap inheritance
set -o nounset # exit on uninitialized variables
set -o pipefail # exit on any pipeline command failure

if [[ ! -f /etc/nginx/ssl/default.crt ]]; then
    CERT_PATH="/etc/nginx/ssl"

    # create a 2048 bit private key
    openssl genrsa -out "${CERT_PATH}/default.key" 2048

    # generate a Certificate Signing Request
    openssl req \
        -new -key "${CERT_PATH}/default.key" \
        -out "${CERT_PATH}/default.csr" \
        -subj "/CN=default/O=default/C=US"

    # create a self-signed certificate
    openssl x509 \
        -req -days 3000 \
        -CA "${CERT_PATH}/RootCA.crt" -CAkey "${CERT_PATH}/RootCA.key" \
        -in "${CERT_PATH}/default.csr" \
        -signkey "${CERT_PATH}/default.key" \
        -out "${CERT_PATH}/default.crt"
fi

# exec nginx -g "env PHPFPM_XDEBUG_PORT=${PHPFPM_XDEBUG_PORT};"
exec nginx
