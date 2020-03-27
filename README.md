# docker-openldap

> Test/Development LDAP server in a container.

This is a containerized test/development OpenLDAP server designed for
portability. It comes prepopulated with people and groups suitable for
testing.

## Usage

```bash
# edit configurations as appropriate
vim -o config.ldif data.ldif

# start container
./run.sh

# run test queries
./test.sh

# administrator's credentials
# dn       : uid=root,dc=test
# password : secret
```
