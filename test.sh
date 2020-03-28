#!/bin/bash

set -e


main() {
	cd "$(dirname $0)"

	_ldapsearch '[find user by DN] should return 1 user' \
		-b 'CN=UserA,OU=Org1,dc=test'

	_ldapsearch '[find user by CN] should return 1 user' \
		-b 'dc=test' 'CN=UserA'

	_ldapsearch '[find user by DN, nonexistent] should return nothing' \
		-b 'CN=TheGuyFromThatMovie,OU=Org1,dc=test'

	_ldapsearch '[find user by CN, nonexistent] should return nothing' \
		-b 'dc=test' 'CN=TheGuyFromThatMovie'

	_ldapsearch '[find user group memberships] should return 2 group dns' \
		-b 'CN=UserB,OU=Org1,dc=test' \
		'memberof'

	_ldapsearch '[enumerate orgs] should return 3 orgs' \
		-b 'dc=test' \
		'objectclass=organizationalUnit'

	_ldapsearch '[enumerate org members, #1] should return 3 users' \
		-b 'OU=Org1,dc=test' \
		'objectclass=user'

	_ldapsearch '[enumerate org members, #2] should return 1 user' \
		-b 'OU=Org2,dc=test' \
		'objectclass=user'

	_ldapsearch '[enumerate org members, #3] should return 1 user' \
		-b 'OU=Org3,dc=test' \
		'objectclass=user'

	_ldapsearch '[enumerate org members, nonexistent] should return nothing' \
		-b 'OU=Org4,dc=test' \
		'objectclass=user'
}


_ldapsearch() {
	printf '\033[33m%s\033[0m\n' "$1"

	if [[ ! -f /usr/bin/ldapsearch ]]; then
		cmd='podman exec ldap ldapsearch'
	else
		cmd=ldapsearch
	fi

	echo "---"
	trap 'echo "---"' ERR RETURN
	(
		set -x
		$cmd \
			-LLL \
			-x \
			-H 'ldap://localhost' \
			-D 'uid=test,ou=services,dc=test' \
			-w 'test' \
			"${@:2}" \
			| cat -n
	)
}


main "$@"
