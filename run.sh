#!/bin/bash

set -e

IMAGE_ID=ldap
CONTAINER_ID=ldap


cd "$(dirname $0)"

set -x

podman build \
	-t "$IMAGE_ID" \
	.

podman run \
	--rm \
	--name "$CONTAINER_ID" \
	-it \
	"$@" \
	"$IMAGE_ID"
