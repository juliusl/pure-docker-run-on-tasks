#!/bin/sh

# Following this:
# https://github.com/oras-project/artifacts-spec/blob/main/docs/quick-start.md

curl https://raw.githubusercontent.com/juliusl/azorasrc/main/scripts/get-oras.sh | sh

if [ ! -f "./install-oras.sh" ]; then
    echo "oras did not install"
fi

# shellcheck disable=SC1091
. "./install-oras.sh"

PORT=5000
REGISTRY=localhost:${PORT}
REPO=net-monitor
IMAGE=${REGISTRY}/${REPO}:v1

wget https://golang.org/dl/go1.17.1.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.17.1.linux-amd64.tar.gz

alias go=/usr/local/go/bin/go

git clone https://github.com/oras-project/distribution
cd './distribution' || exit
git checkout artifacts 
ls
go build  /home/orasdiscover/scripts/distribution/registry/main.go
/home/orasdiscover/scripts/distribution/registry/main serve config-dev.yml &

docker build -t $IMAGE https://github.com/wabbit-networks/net-monitor.git#main
docker push $IMAGE

echo '{"version": "0.0.0.0", "artifact": "'${IMAGE}'", "contents": "good"}' >sbom.json
oras push $REGISTRY/$REPO \
    --artifact-type sbom/example \
    --subject $IMAGE \
    sbom.json:application/json

echo '{"version": "0.0.0.0", "artifact": "'${IMAGE}'", "signature": "signed"}' >signature.json
oras push $REGISTRY/$REPO \
    --artifact-type signature/example \
    --subject $IMAGE \
    signature.json:application/json

oras discover -o tree --artifact-type=sbom/example $IMAGE

oras pull -a "${REGISTRY}/${REPO}@$(oras discover -o json --artifact-type signature/example $IMAGE | jq -r .references[0].digest)"

tail -f /var/log/containers/* /var/log/docker.log | awk '{printf "\033[33m%s\033[39m", $0 }' 2>&1

