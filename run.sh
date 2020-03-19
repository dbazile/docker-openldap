#!/bin/bash

set -e

IMAGE_ID=openldap
CONTAINER_ID=openldap


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
