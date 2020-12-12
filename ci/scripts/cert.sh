#!/usr/bin/env bash

mkdir ./certs
cd ./certs
openssl genrsa -out tls.key 2048
openssl rsa -in tls.key -out tls.key
openssl req -sha256 -new -key tls.key -out tls.csr -subj '/CN=35.228.146.46'
openssl x509 -req -sha256 -days 365 -in tls.csr -signkey tls.key -out tls.crt
