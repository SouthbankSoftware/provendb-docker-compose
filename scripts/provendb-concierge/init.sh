echo "Waiting for mongoDB to start"
sleep 10 #Wait for mongoDB to bootup

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

while :
do
    a=$(concierge schema --uri mongodb://${PROVENDB_USER}:${PROVENDB_PASS}@mongo:${PORT_MONGO}/${PROVENDB_DB} 2>&1)
    if [[ "$a" == *"successfully initialized schema for database \`${PROVENDB_DB}\`" ]]; then
        echo "Schema successfully initialized.. Just going to hang around."
    elif [[ "$a" == *"Error: failed to init collection \`_${PROVENDB_DB}_"*"(NamespaceExists) a collection '${PROVENDB_DB}._"*"already exists"* ]]; then
        echo "Init Collection already exists, just going to hang around."
    else
        echo "The following error occurred"
        echo $a
        echo "Now quitting. Docker will automatically retry."
        sleep 5
        exit 1
    fi
    break;
done

tail -f /dev/null