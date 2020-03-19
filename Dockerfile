FROM centos:7

RUN set -ex \
	&& yum install -y \
		bash-completion \
		net-tools \
		nmap-ncat \
		openldap \
		openldap-clients \
		openldap-servers \
		openssl \
		tree \
		vim-enhanced \
	&& yum clean all \
	&& echo "alias tree='tree -AC'" > /etc/profile.d/tree.sh

WORKDIR /workdir

ADD certs/ /etc/openldap/certs/
ADD config.ldif .
ADD schema.ldif .
ADD data.ldif .
ADD entrypoint.sh /

RUN set -ex \
	&& rm -rf /etc/openldap/slapd.d/* \
	&& slapadd -F /etc/openldap/slapd.d/ -n 0 -l /workdir/config.ldif \
	&& slapadd -F /etc/openldap/slapd.d/ -n 2 -l /workdir/data.ldif \
	&& cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG \
	&& chown -R ldap:ldap \
		/etc/openldap/certs/ca.crt \
		/etc/openldap/certs/server.crt \
		/etc/openldap/certs/server.key \
		/etc/openldap/slapd.d/ \
		/var/lib/ldap

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 389 636
