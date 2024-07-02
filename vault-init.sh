#!/usr/bin/env sh

set -ex

unseal () {
vault operator unseal $(grep 'Key 1:' /vault/file/keys | awk '{print $NF}')
vault operator unseal $(grep 'Key 2:' /vault/file/keys | awk '{print $NF}')
vault operator unseal $(grep 'Key 3:' /vault/file/keys | awk '{print $NF}')
}

init () {
vault operator init > /vault/file/keys
}

log_in () {
   export ROOT_TOKEN=$(grep 'Initial Root Token:' /vault/file/keys | awk '{print $NF}')
   vault login $ROOT_TOKEN
}

create_engine () {
   vault secrets enable -path=secret kv
}

create_token () {
   vault token create -id $VAULT_ROOT_TOKEN
}

if [ -s /vault/file/keys ]; then
   unseal
else
   init
   unseal
   log_in
   create_engine
   create_token
fi

vault status > /vault/file/status