FROM alpine:3.19

WORKDIR /root

ENV PACKAGES curl make git libc-dev bash gcc linux-headers eudev-dev python3 wget aria2 jq lz4 gcompat

RUN apk add --no-cache $PACKAGES

# Download and extract the Evmos release
RUN wget https://github.com/evmos/evmos/releases/download/v16.0.0-rc5/evmos_16.0.0-rc5_Linux_amd64.tar.gz \
    && tar -xzvf evmos_16.0.0-rc5_Linux_amd64.tar.gz \
    && mv bin/evmosd /usr/local/bin/ \
    && chmod +x /usr/local/bin/evmosd


# Display version information
RUN evmosd version

EXPOSE 26656 26657 1317 9090 8545 8546

CMD ["evmosd"]