FROM debian:stable-slim

RUN apt-get -q update && \
    apt-get -yq install automake autoconf pkg-config libtool software-properties-common gnupg && \
    apt-get -yq install git curl netcat wget net-tools vim && \
    apt-get -y autoclean && apt-get -y clean

ENV BITCOIN_VERSION=0.20.1
ENV PATH=/opt/bitcoin-${BITCOIN_VERSION}/bin:$PATH
ENV TARGETPLATFORM=x86_64-linux-gnu

RUN gpg --keyserver keyserver.ubuntu.com --recv-keys 01EA5486DE18A882D4C2684590C8019E36C2E964 \
  && curl -SLO https://bitcoin.org/bin/bitcoin-core-${BITCOIN_VERSION}/bitcoin-${BITCOIN_VERSION}-${TARGETPLATFORM}.tar.gz \
  && curl -SLO https://bitcoin.org/bin/bitcoin-core-${BITCOIN_VERSION}/SHA256SUMS.asc \
  && gpg --verify SHA256SUMS.asc \
  && grep " bitcoin-${BITCOIN_VERSION}-${TARGETPLATFORM}.tar.gz\$" SHA256SUMS.asc | sha256sum -c - \
  && tar -xzf *.tar.gz -C /opt \
  && rm *.tar.gz *.asc \
  && rm -rf /opt/bitcoin-${BITCOIN_VERSION}/bin/bitcoin-qt

ADD bitcoin.conf /.config/bitcoin.conf
RUN mkdir -p /.config/bitcoin-data

ENTRYPOINT ["/opt/bitcoin-0.20.1/bin/bitcoind", "-conf=/.config/bitcoin.conf"]
