#!/bin/bash

mongod  --fork --logpath /var/log/mongod.log --port ${MONGODB_PORT} --bind_ip_all --nojournal
echo "waiting for MongoDB to startup..."
until mongo --host mongoauth --port ${MONGODB_PORT} --eval "print(\"waited for connection\")" > /dev/null 2>&1;
do
    sleep 1
done
echo "MongoDB has now started."

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

echo "now creating user ${PROVENDB_USER} with role 'superadmin' on ${USER_DATABASES}"
mongo "mongodb://mongoauth:${MONGODB_PORT}" --eval "var USER_DATABASES='$USER_DATABASES',
                                                        PROVENDB_USER='$PROVENDB_USER',
                                                        PROVENDB_PASS='$PROVENDB_PASS'
                                                        " /scripts/init.js

tail -f /var/log/mongod.log
