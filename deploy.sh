#!/bin/bash
#
# Creates a cluster with exposed port 8080


#k3d cluster create --config k3d-config.yaml

# Helm deploy a Gloo Edge 
#
set -e

export GLOO_VERSION="v1.15.12" # Using the latest version
export PORTAL_VERSION="1.4.0-beta4"
#GLOO_NAMESPACE="gloo-system"

set -x
helm repo update
helm install gloo \
	gloo-ee/gloo-ee \
	--version "${GLOO_VERSION}" \
	--namespace gloo-system \
	--create-namespace \
	--set-string license_key=$GQ \
	--set grafana.defaultInstallationEnabled=true \
	--set prometheus.enabled=true \
	-f value-overrides.yaml

sleep 5
helm upgrade --install --values gloo-values.yaml \
	gloo-portal gloo-portal/gloo-portal \
	--create-namespace  -n gloo-portal \
	--version ${PORTAL_VERSION}
