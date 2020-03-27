# docker-openldap

> Containerized test/development LDAP server, prepopulated with people and groups.

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
