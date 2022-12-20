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
file_env "MONGO_INITDB_ROOT_USERNAME"
file_env "MONGO_INITDB_ROOT_PASSWORD"

echo 'http://dl-cdn.alpinelinux.org/alpine/v3.9/main' >> /etc/apk/repositories
echo 'http://dl-cdn.alpinelinux.org/alpine/v3.9/community' >> /etc/apk/repositories
apk update
apk add mongodb=4.0.5-r0

echo "Wating until MongoDB is ready..."
echo "URI_MONGO=${URI_MONGO}"
until mongo ${URI_MONGO} --quiet  --eval "db.runCommand({\"ping\" : 1})" > /dev/null
  do
	echo "Mongo DB not ready yet. Trying again in 5 seconds."
    sleep 5s
  done
echo "Authentication to MongoDB successful"  

# Wait for additional 5 seconds so that there is enough time for concierge to initialize schema
sleep 5s

TREE_CACHE_DB_URI=mongodb://${MONGO_INITDB_ROOT_USERNAME}:${MONGO_INITDB_ROOT_PASSWORD}@treecache:$PORT_TREECACHE \
PROVENDB_VERIFY_BCTOKEN=$BLOCKCYPHER_TOKEN \
mongoUri=${URI_MONGO} \
TREE_DISABLE_OPENTRACING=true \
./tree &> tree.log &
tail -f tree.log