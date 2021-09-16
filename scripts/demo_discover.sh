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

# It's actually easier to just clone distribution then it is to install docker and pull/run an image
docker run -d -p ${PORT}:5000 ghcr.io/oras-project/registry:v0.0.3-alpha
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

oras pull -a "${REGISTRY}/${REPO}@$(oras discover -o json --artifact-type scan-result/example $IMAGE | jq -r .references[0].digest)"
