# docker-openldap

> Test/Development LDAP server in a container.

This is a containerized test/development OpenLDAP server designed for
portability. On startup, it is already provisioned with some entries
suitable for testing.

## Usage

```bash
# edit configurations as appropriate
vim -o config.ldif schema.ldif data.ldif

# start container
./run.sh

# run test queries
./test.sh
```
