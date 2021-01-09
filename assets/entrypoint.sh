#!/bin/bash
set -eu

usage() {
	echo "-----------------------------"
	echo "COMMANDS:"
	echo "  shell"
	echo "  dhparam"
	echo "  ca COMMON_NAME"
	echo "  cert COMMON_NAME"
	echo "-----------------------------"
}

case "${1:-}" in
	"shell" )
		exec bash
		;;

	"ca" )
		if [ -z "${2:-}" ]; then usage; exit 1; fi
		COMMON_NAME=$2
		cd /work

		mkdir -p ./CA/{certs,private,crl,newcerts}
		mkdir certs
		chmod 700 ./CA/private
		echo "01" > ./CA/serial
		touch ./CA/index.txt

		openssl genrsa 2048 > ./CA/private/cakey.pem

		openssl req -new -x509 -days 3650 \
		-key ./CA/private/cakey.pem \
		-out ./CA/cacert.pem \
		-subj "/CN=$COMMON_NAME/C=$SSL_C/ST=$SSL_ST/L=$SSL_L/O=$SSL_OR"

		openssl x509 -inform PEM -outform DER \
		  -in ./CA/cacert.pem -out ./CA/cacert.der

		openssl x509 -in ./CA/cacert.pem -text
		;;

	"cert" )
		if [ -z "${2:-}" ]; then usage; exit 1; fi
		COMMON_NAME=$2
		cd /work
		mkdir -p /work/certs/$COMMON_NAME

		cat /usr/lib/ssl/openssl.cnf > /tmp/openssl.cnf
		cat >> /tmp/openssl.cnf << EOS

[alt_names]
DNS.1 = $COMMON_NAME

EOS
		openssl genrsa 2048 > certs/$COMMON_NAME/privkey.pem

		openssl req -config /tmp/openssl.cnf -new \
		  -key certs/$COMMON_NAME/privkey.pem \
		  -out certs/$COMMON_NAME/req.pem \
		  -subj "/CN=$COMMON_NAME/C=$SSL_C/ST=$SSL_ST/L=$SSL_L/O=$SSL_OR"

		openssl ca -config /tmp/openssl.cnf \
		  -out ./certs/$COMMON_NAME/cert.pem \
		  -infiles ./certs/$COMMON_NAME/req.pem

		openssl x509 -in ./certs/$COMMON_NAME/cert.pem -text

		;;

	"dhparam" )
		cd /work
		# openssl dhparam -out certs/dhparam.pem 4096
		curl https://2ton.com.au/getprimes/random/dhparam/4096 > certs/dhparam.pem
		;;

	* )
		usage
		;;
esac

