#!/bin/sh

export VAULT_ADDR='http://127.0.0.1:8200'

. /unseal-keys.properties

vault operator unseal "${UNSEAL_KEY_1}"
vault operator unseal "${UNSEAL_KEY_2}"
vault operator unseal "${UNSEAL_KEY_3}"
