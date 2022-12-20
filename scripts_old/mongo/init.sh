# By default, the initscript will only bind to localhost, in order to add a replset member other than localhost
# https://gist.github.com/zhangyoufu/d1d43ac0fa268cda4dd2dfe55a8c834e

#!/bin/bash
: "${FORKED:=}"

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

if [ -z "${FORKED}" ]; then
	echo >&2 'mongod for initdb is going to shutdown'
	mongod --pidfilepath /tmp/docker-entrypoint-temp-mongod.pid --shutdown
	echo >&2 'replica set will be initialized later'
    echo "\${BASH_SOURCE[0]} = '${BASH_SOURCE[0]}'"
	FORKED=1 /bin/bash ${BASH_SOURCE[0]} &
	unset FORKED
	mongodHackedArgs=(:) # bypass mongod --shutdown in docker-entrypoint.sh
	return
fi

file_env "PROVENDB_USER"
file_env "PROVENDB_PASS"
file_env "MONGO_INITDB_ROOT_USERNAME"
file_env "MONGO_INITDB_ROOT_PASSWORD"

# [  -z "$PROVENDB_USER" ] && echo "Empty: Yes" || file_env "PROVENDB_USER"
# [  -z "$PROVENDB_PASS" ] && echo "Empty: Yes" || file_env "PROVENDB_PASS"

MONGODB_PORT=${MONGODB_PORT:=27017}
mongo=( mongo --host 127.0.0.1 --port $MONGODB_PORT --quiet )
tries=30
while true; do
	sleep 1
	if "${mongo[@]}" --eval 'quit(0)' &> /dev/null; then
		# success!
		break
	fi
	(( tries-- ))
	if [ "$tries" -le 0 ]; then
		echo >&2
		echo >&2 'error: unable to initialize replica set'
		echo >&2
		kill -STOP 1 # initdb won't be executed twice, so fail loudly
		exit 1
	fi
done

echo 'about to initialize replica set'
"${mongo[@]}" -u $MONGO_INITDB_ROOT_USERNAME  -p  $MONGO_INITDB_ROOT_PASSWORD   --eval  "var RS_HOST = '$RS_HOST',
																	PROVENDB_USER = '$PROVENDB_USER', 
																	PROVENDB_PASS = '$PROVENDB_PASS'
																	PROVENDB_DB = '$PROVENDB_DB'" /docker-entrypoint-initdb.d/init.js
