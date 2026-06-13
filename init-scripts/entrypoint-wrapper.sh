#!/bin/sh
nohup docker-entrypoint.sh server &
count=0
while ! ps aux | grep -q '[v]ault server'; do
  sleep 1
  count=$((count+1))
  if [ $count -ge 10 ]; then
    echo "Error: vault server process not found after 10 seconds"
    exit 1
  fi
done

sh /vaultUnseal.sh
tail -f /dev/null
