#!/bin/sh

# Background Subshell: Monitor Vault server startup and execute automatic unsealing
(
    MAX_CHECKS=${VAULT_STARTUP_TIMEOUT:-10}
    count=0
    
    while ! ps aux | grep -q '[v]ault server'; do
        sleep 1
        count=$((count+1))
        if [ "$count" -ge "${MAX_CHECKS}" ]; then
            echo "[ERROR] Vault server process not found after ${MAX_CHECKS} seconds." >&2
            exit 1
        fi
    done

    echo "[INFO] Starting automatic Vault unsealing..."
    vault operator unseal "${UNSEAL_KEY_1}" \
      && vault operator unseal "${UNSEAL_KEY_2}" \
      && vault operator unseal "${UNSEAL_KEY_3}" \
      && echo "[INFO] Vault unsealing completed successfully!" \
      || echo "[ERROR] Vault unsealing failed. Server may still be sealed." >&2

    # Clear keys from subshell memory immediately after execution
    unset UNSEAL_KEY_1 UNSEAL_KEY_2 UNSEAL_KEY_3
) &

# Clear original keys from parent memory before transitioning process
unset UNSEAL_KEY_1 UNSEAL_KEY_2 UNSEAL_KEY_3

# Replace current shell and elevate Vault server to PID 1
exec docker-entrypoint.sh server