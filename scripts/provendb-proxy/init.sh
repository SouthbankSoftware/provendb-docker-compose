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

apt-get update 
apt-get install -y curl  wget gnupg 
wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" |  tee /etc/apt/sources.list.d/mongodb-org-4.4.list
apt-get update 
apt-get install -y mongodb-org

echo "Wating until MongoDB is ready..."
echo "URI_MONGO=${URI_MONGO}"
 
until mongo ${URI_MONGO} --quiet  --eval "db.runCommand({\"ping\" : 1})" > /dev/null
  do
	echo "Mongo DB not ready yet. Trying again in 5 seconds."
    sleep 5s
  done
echo "Authentication to MongoDB successful"  

cat /app/proxy-server.sh

ENV_PROVENDB_MONGO_URI=${URI_MONGO} \
/bin/bash /app/proxy-server.sh

