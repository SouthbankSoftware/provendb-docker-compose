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

file_env "PROVENDB_USER"
file_env "PROVENDB_PASS"
file_env "BLOCKCYPHER_TOKEN"


apk add curl mongodb # this is for the health check
echo "Wating until MongoDB is ready..."
until mongo mongodb://$PROVENDB_USER:$PROVENDB_PASS@mongo:$PORT_MONGO/$USER_DATABASES --quiet  --eval "db.runCommand({\"ping\" : 1})" > /dev/null
  do
	echo "Mongo DB not ready yet. Trying again in 5 seconds."
    sleep 5s
  done
echo "Authentication to MongoDB successful"  

ENV_PROVENDB_MONGO_URI=mongodb://$PROVENDB_USER:$PROVENDB_PASS@mongo:$PORT_MONGO/$USER_DATABASES?replicaSet=rs0 \
/app/proxy-server.sh

