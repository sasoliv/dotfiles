#!/usr/bin/env bash
set -eu
org=saso
domain=pi

openssl genpkey -algorithm RSA -out "$org".key
openssl req -x509 -key "$org".key -days 3650 -out "$org".crt \
    -subj "/CN=$org/O=$org"

openssl genpkey -algorithm RSA -out "$domain".key
openssl req -new -key "$domain".key -out "$domain".csr \
    -subj "/CN=$domain/O=$org"

openssl x509 -req -in "$domain".csr -days 3650 -out "$domain".crt \
    -CA "$org".crt -CAkey "$org".key -CAcreateserial \
    -extfile <(cat <<END
basicConstraints = CA:FALSE
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer
subjectAltName = DNS:$domain
END
    )

