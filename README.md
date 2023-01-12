# Dockerized Deployment of ProvenDB

<div align="center">

[![Powered by ProvenDB](https://img.shields.io/static/v1.svg?label=Powered%20By&message=ProvenDB&color=35b3d4&labelColor=1c4d6b&link=https:/provendb.com&link=https:/provendb.com&logo=data:image/png;base64,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)](https://img.shields.io/static/v1.svg?label=Powered%20By&message=ProvenDB&color=35b3d4&labelColor=1c4d6b&link=https:/provendb.com&link=https:/provendb.com&logo=data:image/png;base64,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)

</div>

_**Please Note**: The Docker-Compose deployment of ProvenDB in this repository is to demonstrate the capabilities of both the cloud and on-premise implementations of ProvenDB, if you are looking for a complete production-ready deployment of ProvenDB, please contact us at support@southbanksoftware.com._

---

A Docker-Compose configuration for deploying [ProvenDB](https://provendb.com) on your chosen system, perfect for testing out whether the application is a good fit for your blockchain project, or just to send some local data to the blockchain without using our cloud provided services.

## Table of Contents

- [Dockerized Deployment of ProvenDB](#dockerized-deployment-of-provendb)
  - [Table of Contents](#table-of-contents)
  - [Prerequisities](#prerequisities)
  - [Quick Start Guide](#quick-start-guide)
    - [1. Clone the Repository](#1-clone-the-repository)
    - [2. Navigate to the root directory of the repository.](#2-navigate-to-the-root-directory-of-the-repository)
    - [3. Ensure Docker images are up to date (run this regularly to get the latest features and bug fixes).](#3-ensure-docker-images-are-up-to-date-run-this-regularly-to-get-the-latest-features-and-bug-fixes)
    - [4. Run the Docker containers.](#4-run-the-docker-containers)
    - [5. Check container status](#5-check-container-status)
    - [6. Connect to ProvenDB.](#6-connect-to-provendb)
    - [7. Next Steps](#7-next-steps)
- [Configuration](#configuration)
- [Using an external MongoDB](#Using-an-external-MongoDB-Server)
- [Troubleshooting](#troubleshooting)
    - [**No Space Left on Device** in container logs.](#no-space-left-on-device-in-container-logs)
    - [**Drive sharing failed for an unknown reason** error on Windows](#drive-sharing-failed-for-an-unknown-reason-error-on-windows)
    - [Blockcypher API Limit Reached.](#blockcypher-api-limit-reached)
    - [Can't change MongoDB password](#cant-change-mongodb-password)
- [Compatibility](#compatibility)
- [Branch Information](#branch-information)
- [Contact](#contact)

## Prerequisities

Check [Compatibility](#compatibility) section for versions that are known to work.

- `git`
- `docker`
- `docker-compose`

Make sure you can log into github container registry:

`docker login ghcr.io -u YOUR_USERNAME`
## Quick Start Guide

Either watch the video below, or follow the written steps to get started with ProvenDB as a standalone container.

[![](thumbnail.jpg)](https://youtu.be/7yGjJ9Bfb44)

### 1. Clone the Repository

```sh
git clone https://github.com/SouthbankSoftware/provendb-docker-compose.git
```

### 2. Navigate to the root directory of the repository.

```sh
cd provendb-docker-compose
```

### 3. Copy `sample.env` to `.env` and edit as appropriate

You might also need to edit the files in `env/creds-standalone`. Particularly `anchor.env` which has the blockchain keys

### 4. Ensure Docker images are up to date (run this regularly to get the latest features and bug fixes).

```sh
docker-compose pull
```

### 5. Run the Docker containers.

_On Unix operating systems:_

```sh
docker-compose pull && docker-compose -f docker-compose.yml -f docker-compose.standalone.yml up --build -d
```

_On Windows operating systems:_

```powershell
sed -i 's/\r$//' scripts/*/*.sh && docker-compose pull && docker-compose -f docker-compose.yml -f docker-compose.standalone.yml up --build -d
```

### 6. Check container status

```
docker ps
```

_All the containers should be healthy_

### 7. Connect to ProvenDB.

```sh
mongo mongodb://pdbuser:click123@localhost:27018/provendb
```

### 8. Next Steps

- _Customize your configuration by modifying the `env/creds-standalone/provendb.env` file._
- _Complete the database tutorial [here](https://provendb.readme.io/docs/provendb-quickstart-tutorial)._

### Other notes

The script `provendb-docker.sh` automates many of the start/stop and reset operations.
The script `provendbShell.sh` is a shell helper wrapper around the mongo command - see [https://provendb.readme.io/docs/shell-helper-commands](https://provendb.readme.io/docs/shell-helper-commands)

# Configuration

- This ProvenDB service runs with ssl **disabled** by default. If you wish to use ssl, you will need to place your certificate (_in `.p12` format_) in `ssl_cert/certificate.p12` and set `ENV_PROVENDB_SECURITY_SSL_ENABLE=true` in the `common.env` file.
- Because this is a demo version of the product, anchoring proofs to [Ethereum](https://www.google.com/search?q=ethereum&oq=ethereum&aqs=chrome..69i57j69i59j69i60l2j69i65j69i61.888j0j7&sourceid=chrome&ie=UTF-8) is accomplished on the [Rinkeby](https://www.rinkeby.io/#stats) Testnet by default. However, you can change this configuration if you wish to connect to a different Ethereum compatible endpoint.

  For example, if you would like to use a private blockchain such as [Quorum](https://www.goquorum.com/), you will need to make the following changes.

        1. Set `ANCHOR_ETH_ENDPOINT` in `env/creds-standalone/anchor.env` to point to the Quorum node.

        2. Set `ANCHOR_ETH_PRIVATE_KEY` to the value of the private key of the account address which will be used for signing transactions.

  A free endpoint for anchoring transactions on the [Ethereum](https://www.google.com/search?q=ethereum&oq=ethereum&aqs=chrome..69i57j69i59j69i60l2j69i65j69i61.888j0j7&sourceid=chrome&ie=UTF-8) mainnet or testnet can be obtained from [Infura.io](https://infura.io/).

# Using an external MongoDB Server

If you want to use a MongoDB server outside of Docker (for HA and long term persistence reasons) you need to do the following:

1. Change the URI_MONGO variable in .env to point to the host of the server.  The default value of points to a mongodb insstance created inside of docker. 

2. In that DB, make sure that an empty database exists that can be accessed using URI_MONGO from the `.env` file.  This database will be initialized with the appropriate schemas if they are not already there.

These commands are suitable for the defaults: 

```javascript
use provendb;
db.dummy_pdbignore.insertOne({});

db.getSiblingDB("provendb").createUser({
    user: "pdbuser",
    pwd: "click123", 
      roles: [ 
              {role:"readWrite", db: "provendb" }     
             ]
     },
     {  w: "majority" }
 );
```
The hostname must be reachable from within the docker container.  This is where things typically go wrong:  `localhost` URIs cannot be used. 

3.  Make sure that the `URI_MONGO` variable is consistent with the   `PROVENDB_USER` and `PROVENDB_PASS` and `PROVENDB_DB` settings in the various environmant files.  Safest path is to use `pdbuser`, `click123` and `provendb`, at least for testing. 



# Troubleshooting

### **No Space Left on Device** in container logs.

If you get an error like `no space left on device` in any of the container logs, you may try and run this

```sh
docker rm $(docker ps -q -f 'status=exited')
docker rmi $(docker images -q -f "dangling=true")
docker volume rm $(docker volume ls -qf dangling=true)
```

### **Drive sharing failed for an unknown reason** error on Windows

On Windows if you encounter the following error:

```sh
ERROR: for provendb-tree-cache  Cannot create container for service treecache: b'Drive sharing failed for an unknown reason'
```

Please refer to [this docker issue](https://github.com/docker/for-win/issues/3174#issuecomment-477417558).

### Blockcypher API Limit Reached.

The [Blockcypher](https://www.blockcypher.com/) token included in this repo is `62067971acd84dbf83d97739541ca77b`. This is a free token with a api limit of **200 calls per day** and is **shared** among all running public docker instances of ProvenDB. If you need more, you can create a account at [Blockcypher](https://accounts.blockcypher.com/), choose a plan and replace this token with your own token in the `env/creds-standalone/provendb.env` file.

### Can't change MongoDB password

It's not possible to change existing passwords once provendb is started. If you want to change passwords, you will have to delete the MongoDB database.

You can do this by removing the volume containing that database, for example:

```sh
docker volume rm $(docker volume ls -q | grep provendb-data)
```

# Compatibility

This specific deployment of ProvenDB has been tested on the following configurations:

| OS                      |                            Docker version                            |
| ----------------------- | :------------------------------------------------------------------: |
| **macOS Catalina**      | Docker Desktop: 2.1.0.1, Docker Engine: 19.03.1, Docker Compose: 3.4 |
| **Windows 10 Pro**      |           Docker Desktop: 2.1.0.4, Docker Engine: 19.03.4            |
| **Ubuntu 18.04 Server** |             Docker Engine: 18.09.7, Docker Compose: 3.4              |

This deloyment works best with **8GB** of memory available for Docker Engine.

# Branch Information

This repository contains the following branches:

1. **dev**: Contains the latest versions of the ProvenDB services. These is cuttent edge code, and may not yet be 100% bug free.
2. **master**: Contains `stable` versions of all ProvenDB services.

# Contact

If you run into any issues, or wish to discuss a custom deployment of ProvenDB for your blockchain project, please email us at **support@southbanksoftware.com**

_Copyright © 2022 Southbank Software. All rights reserved._
