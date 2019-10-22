# Dockerized versions of ProvenDB

## 1. Quick start to starting ProvenDB (standalone container)

```

docker-compose pull && docker-compose -f docker-compose.yml -f docker-compose.standalone.yml up --build -d
```
Please check the status of the containers like this
```
docker ps
```
All the containers should be healthy

Then you can connect to ProvenDB (proxy service) in the following manner:

```
mongo mongodb://pdbuser:click123@localhost:27018/provendb
```
Please set the appropriate configuration values in `env/creds-standalone/provendb.env` file


# Errors and Debugging

1. If you get an error like 'no space left on device` on any of the container logs, you may try and run this
```
docker rm $(docker ps -q -f 'status=exited')
docker rmi $(docker images -q -f "dangling=true")
docker volume rm $(docker volume ls -qf dangling=true)
```

2. The Blockcypher token included in this repo is `62067971acd84dbf83d97739541ca77b`. This is a free token with a api limit of 200 calls per day. If you need more, you can create a account here https://accounts.blockcypher.com/, choose a plan and replace this token with your own token.

3. It's not possible to change existing passwords once provendb is started. If you want to change passwords, you will have to delete the MongoDB database.
You can do this for e.g.
```
docker volume rm provendb-data
```

NOTE: 
1. This proxy runs with ssl disabled. If you want to use ssl, you will need to place you certificate in `.p12` format in `ssl_cert/Cert.p12` and set `ENV_PROVENDB_SECURITY_SSL_ENABLE=true` in `common.env` file.
2. Anchoring to Ethereum is done on the `Rinkeby` testnet. You can change the endpoint and the private key in `env/creds-standalone/anchor.env`. A free endpoint to mainnet/testnet can be obtained by signing up on https://infura.io