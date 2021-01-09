FROM debian:buster

RUN set -xe && \
	rm /etc/localtime && \
	ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
	echo 'Asia/Tokyo' > /etc/timezone

RUN set -xe && \
	export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get install -y --no-install-recommends \
		openssl \
		curl \
		ca-certificates

RUN set -xe && \
	mv /usr/lib/ssl/openssl.cnf /usr/lib/ssl/openssl.cnf.orig

COPY assets/openssl.cnf /usr/lib/ssl/openssl.cnf
COPY assets/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
