FROM redis

RUN apt-get update && apt-get install -y \
        procps \
        && rm -rf /var/lib/apt/lists/*
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
#ENTRYPOINT ["/tini", "--"]
