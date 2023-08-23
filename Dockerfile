### Build Stage
FROM python:slim-buster AS build

ARG IPFSGO=v0.13.0
ARG TARGETARCH=amd64
ENV IPFS_PODCASTING_PATH /ipfs-podcasting
ENV IPFS_PATH /ipfs-podcasting/ipfs
ENV USERID 1000

WORKDIR $IPFS_PODCASTING_PATH

RUN apt-get update; \
    apt-get install -y --no-install-recommends wget net-tools procps\
    && wget -q https://dist.ipfs.io/go-ipfs/${IPFSGO}/go-ipfs_${IPFSGO}_linux-${TARGETARCH}.tar.gz \
    && wget -q https://dist.ipfs.io/go-ipfs/${IPFSGO}/go-ipfs_${IPFSGO}_linux-${TARGETARCH}.tar.gz.sha512 \
    && cat ./go-ipfs_${IPFSGO}_linux-${TARGETARCH}.tar.gz.sha512 | sha512sum -c \
    && tar xzf go-ipfs_${IPFSGO}_linux-${TARGETARCH}.tar.gz \
    && cp go-ipfs/ipfs /usr/local/bin \
    && rm -rf go-ipfs_${IPFSGO}_linux-${TARGETARCH}.tar.gz go-ipfs ./go-ipfs_${IPFSGO}_linux-${TARGETARCH}.tar.gz.sha512 \
    && rm -rf /var/lib/apt/lists/* \
    && pip3 install --no-cache-dir requests thread6 bottle beaker \
    && mkdir ${IPFS_PODCASTING_PATH}/cfg ${IPFS_PODCASTING_PATH}/ipfs \
    && adduser -D -h $IPFS_PATH -u ${USERID} -G users ipfs \
    && chown -R ${USERID}:users $IPFS_PODCASTING_PATH

COPY *.py *.png ./


USER ${USERID}
ENTRYPOINT ["python", "ipfspodcastnode.py"]
EXPOSE 4001/tcp 5001/tcp 8675/tcp