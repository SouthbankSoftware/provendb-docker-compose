#!/bin/bash

file_env() {
	local var="$1"
	local fileVar="${var}_FILE"
	local def="${2:-}"
	if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
		echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
		exit 1
	fi
	local val="$def"
	if [ "${!var:-}" ]; then
		val="${!var}"
	elif [ "${!fileVar:-}" ]; then
		val="$(< "${!fileVar}")"
	fi
	export "$var"="$val"
	unset "$fileVar"
}

file_env "ANCHOR_ETH_ENDPOINT"
file_env "ANCHOR_ETH_PRIVATE_KEY"
file_env "ANCHOR_ETH_MAINNET_ENDPOINT"
file_env "ANCHOR_ETH_MAINNET_PRIVATE_KEY"

echo "$ANCHOR_ETH_ENDPOINT .  $ANCHOR_ETH_PRIVATE_KEY  . $ANCHOR_ETH_MAINNET_ENDPOINT . $ANCHOR_ETH_MAINNET_PRIVATE_KEY"
#anchor --eth.zero-gas-price.enabled=true  --auth-enabled=false
anchor