FROM golang:1.21.6-alpine3.18 AS evmosd-builder
WORKDIR /root

ENV PACKAGES curl make git libc-dev bash gcc linux-headers eudev-dev python3 wget aria2 jq lz4 gcompat
RUN apk add --no-cache $PACKAGES

# pass version from pipeline 
ARG VERSION=1.0
RUN echo "Building version: $VERSION"

RUN wget -O evmosd https://github.com/evmos/releases/download/v$VERSION/evmos-$VERSION-Linux_amd64 && chmod +x evmosd && cp evmosd /usr/local/bin/

RUN evmosd version
 
EXPOSE 26656 26657 1317 9090 8545 8546

CMD ["evmosd"]
