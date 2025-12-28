ARG DEBIAN_VERSION=bookworm
ARG FPC_VERSION=trunk

FROM freepascal/fpc:${FPC_VERSION}-${DEBIAN_VERSION}-full AS build
ARG TARGETPLATFORM
ARG BUILDPLATFORM

RUN apt update \
    && apt-get install -y git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Clone pas2js and the compiler repos
WORKDIR /build
RUN git clone https://gitlab.com/freepascal.org/fpc/pas2js.git pas2js
WORKDIR /build/pas2js
RUN git config --local pull.rebase true && \
    git clone https://gitlab.com/freepascal.org/fpc/source.git compiler
WORKDIR /build/pas2js/compiler
RUN git config --local pull.rebase true
WORKDIR /build/pas2js

# Build pas2js
RUN set -eux \
    echo "Generating single archive installation for ${TARGETPLATFORM} on ${BUILDPLATFORM}." \
    && make zipinstall \
    && mkdir /export \
    && mv pas2js*.tar.gz /export/pas2js-archive.tar.gz

FROM debian:13-slim AS final
COPY --from=build /export/pas2js-archive.tar.gz /opt/pas2js/pas2js-archive.tar.gz 

# Extract the package before copying to the final image
WORKDIR /opt/pas2js
RUN tar -xzf pas2js-archive.tar.gz && \
    ln -s /opt/pas2js/bin/pas2js /usr/bin/pas2js

CMD ["/usr/bin/pas2js", "-h"]
