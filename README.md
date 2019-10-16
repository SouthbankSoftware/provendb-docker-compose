# Dockerized versions of ProvenDB

PREREQUISITE: To gain access to the private repos, you need to do this

```
cat keyfile.json | docker login -u _json_key --password-stdin https://asia.gcr.io
```

## 1. Quick start to starting ProvenDB (standalone container)

```

docker-compose pull && docker-compose -f docker-compose.yml -f docker-compose.standalone.yml up --build -d
```
Then you can connect to ProvenDB (proxy service) in the following manner:

```
mongo mongodb://pdbuser:click123@localhost:27018/provendbTest
```

## 2. Running ProvenDB using docker stack on docker swarm

You need to be running in swarm mode
```
docker swarm init
```

Docker swarm mode allows the use of docker `secrets`. The current setup already has secret files where you can change values and the secrets will be automatically created when you do `docker stack deploy`.
However, you can easily manage your own secrets by creating them like this

```
echo "pdbroot" | docker secret create mongo-root-user -
```
You can refer [here](https://docs.docker.com/engine/swarm/secrets/) for more details

You can create your docker stack with this command
```
docker-compose config | docker stack deploy   --orchestrator swarm --compose-file - -c docker-compose.cluster.yml  provendb
```
Then you can connect to ProvenDB (proxy service) in the following manner:

```
mongo mongodb://pdbuser:click123@localhost:27018/provendb
```


## 3. Running ProvenDB using docker stack on kubernetes

You need to be running in swarm mode
```
docker swarm init
```

You need to the docker etcd operator set up on kubernetes to use this implementation. `docker-desktop` for mac comes with kubernetes and also has this operator. You need to simply enable the cluster `Docker -> Kubernetes -> Enable local cluster`.
For minikube or elsewhere, you may want to refer [this](https://github.com/docker/compose-on-kubernetes/blob/master/docs/deploy-etcd.md)

The secrets will automatically be translated to kubernetes secrets even though the structure is slightly different, they will be automatically created. More information on the mapping [here](https://github.com/docker/compose-on-kubernetes/blob/master/docs/mapping.md)


Because most of the services in docker stack are stored on a private registry, `k8s` will need permissions to fetch it. This can be achieved by adding `imagePullSecrets` to each of the pods. However, there is no direct mapping from `docker-compose`. So, this secret has to created separately and attach this to the default service account. This will make sure that each of the pods will have the credentials to pull the docker image.

```
kubectl create secret docker-registry regcred --docker-server https://asia.gcr.io  --docker-username _json_key --docker-password <json key> --docker-email=developer@southbanksoftware.com

# Add this on the default service account that is attached to each pod
kubectl patch serviceaccount default -p '{"imagePullSecrets": [{"name": "regcred"}]}'
```
The json key here is obtained from the Container Registry, in this case GCR. A key with `read only` access is already placed in this repo `keyfile.json`.


You can create your docker stack in the same way as in swarm except you provide a different orchestrator. 
```
docker-compose config | docker stack deploy   --orchestrator kubernetes --compose-file - -c docker-compose.cluster.yml  provendb
```
Then you can connect to ProvenDB (proxy service) in the following manner:

```
mongo mongodb://pdbuser:click123@localhost:27018/provendb
```

# Docker app and CNAB

[Docker app](https://github.com/docker/app) is a tool which implements the [CNAB](https://cnab.io/) spec and it allows to easily package and share your `docker-compose` implementation.
This tool needs to be installed from the [here](https://github.com/docker/app/releases/tag/v0.8.0)

You can create a `docker-app` by running the `create_docker_app.sh` script. It will create a folder called `provendb.dockerapp` which basically is the docker app.
This app has already been packaged and pushed on dockerhub. So, you don't need to use this script.

You can set up provendb on `swarm` like this

```
# Start docker swarm mode
docker swarm init

# Make sure you enable kubernetes cluster on docker desktop
curl -s https://storage.googleapis.com/provendb-app/scripts.tar.gz  | tar xvz -C .

docker-app install southbanksoftware/provendb-stack:0.2.0 --orchestrator=swarm --name=provendb \
--set CONCIERGE_SCRIPTS_PATH=$(pwd)/scripts/provendb-concierge \
--set AUTH_SCRIPTS_PATH=$(pwd)/scripts/provendb-auth \
--set MONGO_SCRIPTS_PATH=$(pwd)/scripts/mongo \
--set TREE_SCRIPTS_PATH=$(pwd)/scripts/provendb-tree \
--set PROXY_SCRIPTS_PATH=$(pwd)/scripts/provendb-proxy


# Delete the provendb docker stack
docker-app uninstall provendb
```

and on `kubernetes` like this

```
# Start docker swarm mode
docker swarm init

# Make sure you enable kubernetes cluster on docker desktop
curl -s https://storage.googleapis.com/provendb-app/scripts.tar.gz  | tar xvz -C .

docker-app install southbanksoftware/provendb-stack:0.2.0 --orchestrator=kubernetes --name=provendb \
--set CONCIERGE_SCRIPTS_PATH=$(pwd)/scripts/provendb-concierge \
--set AUTH_SCRIPTS_PATH=$(pwd)/scripts/provendb-auth \
--set MONGO_SCRIPTS_PATH=$(pwd)/scripts/mongo \
--set TREE_SCRIPTS_PATH=$(pwd)/scripts/provendb-tree \
--set PROXY_SCRIPTS_PATH=$(pwd)/scripts/provendb-proxy


# Delete the provendb docker stack
docker-app uninstall provendb
```

You can also override some of the parameters like `image tags` and `port numbers`
e.g. 
```
docker-app install southbanksoftware/provendb-stack:0.2.0 --orchestrator=swarm --name=provendb  --set PORT_PROXY=12000
```
Please refer the section `Parameters you can override in docker-app` in `.env` file 

# Errors and Debugging

1. If you get an error like 'no space left on device` on any of the container logs, you may try and run this
```
docker rm $(docker ps -q -f 'status=exited')
docker rmi $(docker images -q -f "dangling=true")
docker volume rm $(docker volume ls -qf dangling=true)
```

2. If you see this error in tree service
```
"severity":"ERROR","time":"2019-09-04T00:44:00.6020533Z","caller":"tracing/init.go:71","message":"error when flushing the buffer: write udp 127.0.0.1:49739->127.0.0.1:6831: write: connection refused","service":"tree","stacktrace":"github.com/SouthbankSoftware/provendb-tree/pkg/log.logger.Error\n\t/app/pkg/log/logger.go:49\ngithub.com/SouthbankSoftware/provendb-tree/pkg/tracing.jaegerLoggerAdapter.Error\n\t/app/pkg/tracing/init.go:71\ngithub.com/uber/jaeger-client-go.(*remoteReporter).processQueue.func1\n\t/go/pkg/mod/github.com/uber/jaeger-client-go@v2.15.1-0.20181221163149-281650436f3c+incompatible/reporter.go:257\ngithub.com/uber/jaeger-client-go.(*remoteReporter).processQueue\n\t/go/pkg/mod/github.com/uber/jaeger-client-go@v2.15.1-0.20181221163149-281650436f3c+incompatible/reporter.go:267"}
```
you can safely ignore it and this does docker-compose does not contain jaeger server running

3. The Blockcypher token included in this repo is `62067971acd84dbf83d97739541ca77b`. This is a free token with a api limit of 200 calls per day. If you need more, you can create a account here https://accounts.blockcypher.com/, choose a plan and replace this token with your own token.

4. It's not possible to change existing passwords once provendb is started. If you want to change passwords, you will have to delete the MongoDB database.
You can do this for e.g.
```
docker volume rm provendb-data
```

NOTE: 
1. You can also refer the `demo.sh` command for specific commands
2. This proxy runs with ssl disabled. If you want to use ssl, you will need to place you certificate in `.p12` format in `ssl_cert/Cert.p12` and set `ENV_PROVENDB_SECURITY_SSL_ENABLE=true` in `common.env` file.


