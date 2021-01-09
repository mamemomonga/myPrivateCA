#!/bin/bash
set -eu

DCR_IMAGE=myca
DCR_CONT=myca

docker build -t $DCR_IMAGE .
exec docker run --rm -it \
	--name $DCR_CONT \
	--env-file ./env \
	-v $(pwd)/var:/work \
	-w /work $DCR_IMAGE $@

