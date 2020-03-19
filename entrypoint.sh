#!/bin/bash

set -e

DEBUG=${DEBUG:-stats}
LDAP_ROOT_DN=${LDAP_ROOT_DN:-uid=root,dc=test}
LDAP_ROOT_PASSWORD=${LDAP_ROOT_PASSWORD:-secret}

set -x

# Start the server
trap 'cat -n /slapd.log' ERR
slapd \
	-u ldap \
	-d "$DEBUG" \
	-h 'ldapi:/// ldaps:/// ldap:///' \
	&> /slapd.log \
	&

# Apply credentials
sleep 1
ldapmodify -Y EXTERNAL -H ldapi:/// <<< "
	dn: olcDatabase={2}mdb,cn=config
	changetype: modify
	replace: olcRootPW
	olcRootPW: $LDAP_ROOT_PASSWORD
"

# Hand off to specified command if any
if [[ -n "$*" ]]; then
	exec "$@"
else
	trap - ERR
	tail -n9999 -f /slapd.log
fi
