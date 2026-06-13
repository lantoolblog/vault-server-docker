#!/bin/sh
nohup docker-entrypoint.sh server &

MAX_CHECKS=${VAULT_STARTUP_TIMEOUT:-10}
count=0
while ! ps aux | grep -q '[v]ault server'; do
  sleep 1
  count=$((count+1))
  if [ $count -ge ${MAX_CHECKS} ]; then
    echo "Error: vault server process not found after ${MAX_CHECKS} seconds"
    exit 1
  fi
done

. ./unseal-keys.properties
vault operator unseal "${UNSEAL_KEY_1}"
vault operator unseal "${UNSEAL_KEY_2}"
vault operator unseal "${UNSEAL_KEY_3}"

tail -f /dev/null
