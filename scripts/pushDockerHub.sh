docker tag ghcr.io/southbanksoftware/provendb-anchor southbanksoftware/provendb-anchor:dockerCompose
docker push southbanksoftware/provendb-anchor:dockerCompose

docker tag ghcr.io/southbanksoftware/provendb-concierge southbanksoftware/provendb-concierge-dc:dockerCompose
docker push southbanksoftware/provendb-concierge:dockerCompose-dc

docker tag ghcr.io/southbanksoftware/provendb-proxy southbanksoftware/provendb-proxy:dockerCompose
docker push southbanksoftware/provendb-proxy:dockerCompose

docker tag ghcr.io/southbanksoftware/provendb-tree southbanksoftware/provendb-tree:dockerCompose
docker push southbanksoftware/provendb-tree:dockerCompose