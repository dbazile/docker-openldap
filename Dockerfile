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

ENTRYPOINT ["/entrypoint.sh"]

ADD certs/ /etc/openldap/certs/
ADD ldap.conf /etc/openldap/
ADD entrypoint.sh /

WORKDIR /workdir
ADD *.ldif .
RUN set -ex \
	&& rm -rf /etc/openldap/slapd.d/* \
	&& slapadd -F /etc/openldap/slapd.d -b cn=config -l /workdir/config.ldif \
	&& cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG \
	&& chown -R ldap:ldap \
		/etc/openldap/certs/ca.crt \
		/etc/openldap/certs/server.crt \
		/etc/openldap/certs/server.key \
		/etc/openldap/slapd.d/ \
		/var/lib/ldap

EXPOSE 389 636
