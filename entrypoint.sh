#!/bin/bash

set -e

DEBUG=${DEBUG:-stats}

set -x


# Start the server
trap 'cat -n /slapd.log' ERR
slapd \
	-u ldap \
	-d "$DEBUG" \
	-h 'ldapi:/// ldaps:/// ldap:///' \
	&> /slapd.log \
	&
sleep 0.5


# 'slapadd' doesn't seem to invoke overlays so load data with server running
ldapadd -f /workdir/data.ldif


# Tail logs or hand off to user command
if [[ -n "$*" ]]; then
	exec "$@"
else
	trap - ERR
	tail -n9999 -f /slapd.log
fi
