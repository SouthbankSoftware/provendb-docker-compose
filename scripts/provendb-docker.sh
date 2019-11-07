# Startup script for running provenDB from docker compose 
# usage: provendb-docker.sh [reset|load|stop]
#
# With no arguments, launches docker compose
# Reset removes persistent volume forcing a database reset
# load will load the back data then start the containers
export PROVENDB_DB='provendb'
export MONGOADMIN_URI=mongodb://pdbroot:click123@localhost:27027/provendb?authSource=admin
export PROVENDB_URI=mongodb://pdbuser:click123@localhost:27018/provendb

cd ~/git/provendb-docker-compose
. .env
if [ "$1" = "reset" ];then 
  docker-compose -f docker-compose.yml -f docker-compose.standalone.yml stop && docker-compose -f docker-compose.yml -f docker-compose.standalone.yml down
  docker volume rm `docker volume ls | grep provendb-data|awk '{print $2}'`
fi
if [ "$1" = "load" ];then 
  docker-compose -f docker-compose.yml -f docker-compose.standalone.yml stop && docker-compose -f docker-compose.yml -f docker-compose.standalone.yml down
  docker volume rm `docker volume ls | grep provendb-data|awk '{print $2}'`
  docker-compose -f docker-compose.yml -f docker-compose.standalone.yml up -d mongo
  sleep 60
  echo "Dropping database"
  echo "db.getSiblingDB(\"$PROVENDB_DB\").dropDatabase();"|mongo $MONGOADMIN_URI
	mongorestore --uri $MONGOADMIN_URI --nsFrom '$prefix$.$suffix$' --nsTo "$PROVENDB_DB.\$suffix\$" --numParallelCollections 4 --gzip  --drop --archive=$HOME/git/provendb-tests/data/testDB/dump.gz

fi 
if [ "$1" = "stop" ];then
    docker-compose -f docker-compose.yml -f docker-compose.standalone.yml stop && docker-compose -f docker-compose.yml -f docker-compose.standalone.yml down
else
   docker-compose pull && docker-compose -f docker-compose.yml -f docker-compose.standalone.yml up --build -d
   sleep 120
   provendbShell.sh mongodb://pdbuser:click123@localhost:${PORT_PROXY}/${PROVENDB_DB}
fi
