FROM python:slim-trixie AS build

ARG USERID
ARG KUBOV
ARG TARGETARCH

ENV KUBOV ${KUBOV}
ENV USERID ${USERID}
ENV TARGETARCH ${TARGETARCH}

ENV IPFS_PODCASTING_PATH /ipfs-podcasting
ENV IPFS_PATH /ipfs-podcasting/data/ipfs

WORKDIR $IPFS_PODCASTING_PATH

RUN apt-get update; \
    apt-get install -y --no-install-recommends wget net-tools procps \
    && wget -q https://dist.ipfs.tech/kubo/${KUBOV}/kubo_${KUBOV}_linux-amd64.tar.gz \
    && wget -q https://dist.ipfs.tech/kubo/${KUBOV}/kubo_${KUBOV}_linux-amd64.tar.gz.sha512 \
    && cat ./kubo_${KUBOV}_linux-${TARGETARCH}.tar.gz.sha512 | sha512sum -c \
    && tar xzf kubo_${KUBOV}_linux-${TARGETARCH}.tar.gz \
    && cp kubo/ipfs /usr/local/bin \
    && rm -rf kubo_${KUBOV}_linux-${TARGETARCH}.tar.gz kubo ./kubo_${KUBOV}_linux-${TARGETARCH}.tar.gz.sha512 \
    && rm -rf /var/lib/apt/lists/* \
    && pip3 install --no-cache-dir requests thread6 bottle beaker \
    && mkdir ${IPFS_PODCASTING_PATH}/data  \
    && chown -R ${USERID} $IPFS_PODCASTING_PATH/data \
    && addgroup --system --gid ${USERID} ipfs \
    && adduser --system --home ${IPFS_PODCASTING_PATH} -uid ${USERID} -gid ${USERID} ipfs

COPY *.py *.png ./


USER ${USERID}
ENTRYPOINT ["python", "ipfspodcastnode.py"]
EXPOSE 4001/tcp 5001/tcp 8675/tcp
