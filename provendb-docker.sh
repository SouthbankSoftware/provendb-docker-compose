# Startup script for running provenDB from docker compose 
# usage: provendb-docker.sh [reset|load|stop]
#

#
#
#
export PROVENDB_DB='provendb'
export MONGOADMIN_URI=mongodb://pdbroot:click123@localhost:27027/provendb?authSource=admin
export PROVENDB_URI=mongodb://pdbuser:click123@localhost:27018/provendb

 
. .env
if [ "$#" -eq 0 ];then
  echo "Usage: $0 start|stop|load|reset|pull|reset"
  exit 1
fi

pdreset() {
  docker volume rm `docker volume ls | grep provendb-data|awk '{print $2}'`
}
pdpull() {
   docker compose pull
   #docker pull asia.gcr.io/provendb/provendb-verify:latest
   #az login
   #az acr login --name provendbDev
   #docker pull provendbdev.azurecr.io/provendb-verify:latest   
   #docker pull provendbdev.azurecr.io/provendb-verify:latest
}

pdpullVerify() {
   az login
   az acr login --name provendbDev
   docker pull provendbdev.azurecr.io/provendb-verify:latest    
}

pdstop() {
    docker compose -f docker-compose.yml -f docker-compose.standalone.yml stop && docker compose -f docker-compose.yml -f docker-compose.standalone.yml down
}
pdquickStart() {
  docker compose -f docker-compose.yml -f docker-compose.standalone.yml up  -d
}

pdstart() {
   docker compose -f docker-compose.yml -f docker-compose.standalone.yml up  -d
   connect
}

connect () {
  echo "Waiting 60s for services to start"
  sleep 60
  docker exec -it $(docker ps|grep proxy|cut -f1 -d' ') mongo mongodb://pdbuser:click123@localhost:27018/provendb
}

while [ $# -gt 0 ];do
  if [ "$1" = "reset" ];then 
    pdstop
    pdstop
    pdreset
    pdquickStart
    sleep 60
    pdstop
    pdstart

  elif [ "$1" = "pull" ];then 
    pdpull
  elif [ "$1" = "load" ];then 
    pdstop
    pdreset
    docker compose -f docker-compose.yml -f docker-compose.standalone.yml up -d mongo
    sleep 60
    echo "Dropping database"
    echo "db.getSiblingDB(\"$PROVENDB_DB\").dropDatabase();"|mongo $MONGOADMIN_URI
    mongorestore --uri $MONGOADMIN_URI --nsFrom '$prefix$.$suffix$' --nsTo "$PROVENDB_DB.\$suffix\$" --numParallelCollections 4 --gzip  --drop --archive=$HOME/git/provendb-tests/data/testDB/dump.gz
    pdstart
  elif [ "$1" = "stop" ];then
    pdstop
  elif [ "$1" = "start" ];then
    pdstart
    elif [ "$1" = "restart" ];then
    pdstop
    pdstart
  fi
  shift
done



