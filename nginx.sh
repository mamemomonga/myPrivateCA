#!/bin/bash
set -eu

exec docker run --rm \
	-p 127.0.0.1:443:443 \
	-v $(pwd)/assets/nginx.conf:/etc/nginx/nginx.conf:ro \
	-v $(pwd)/var/certs/localhost:/etc/nginx/certs:ro \
	-v $(pwd)/var/certs/dhparam.pem:/etc/nginx/dhparam.pem:ro \
	nginx
