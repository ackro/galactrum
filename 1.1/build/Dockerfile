#
# Galactrum build environment for Alpine Linux
#
FROM ackro/libdb:4.8-dev-alpine as db
FROM ackro/alpine-build
ARG VERSION=1.1.6

COPY --from=db /usr/local /usr/local/
RUN apk add --no-cache boost-dev libevent-dev libressl-dev

WORKDIR /usr/local/src
RUN wget https://github.com/galactrum/galactrum/archive/v${VERSION}.tar.gz \
  && tar -xzf v$VERSION.tar.gz \
  && rm v$VERSION.tar.gz \
  && mv galactrum-${VERSION} galactrum

WORKDIR /usr/local/src/galactrum
COPY 1_1_6-fix.patch .
RUN patch -Np0 < 1_1_6-fix.patch \
  && sed -i '/AC_CONFIG_MACRO_DIR/a\AR_FLAGS=cr' configure.ac \
  && sed -i '/AX_PROG_CC_FOR_BUILD/a\AR_FLAGS=cr' src/secp256k1/configure.ac \
  && sed -i '/AC_PREREQ/a\AR_FLAGS=cr' src/univalue/configure.ac \
  && sed -i s:sys/fcntl.h:fcntl.h: src/compat.h \
  && mkdir build
RUN ./autogen.sh \
  && ./configure \
    --disable-bench \
    --disable-dependency-tracking \
    --disable-static \
    --disable-tests \
    --disable-zmq \
    --prefix=/usr/local/src/galactrum/build \
    --with-gui=no \
    --with-miniupnpc=no
RUN make -j3 \
  && make install \
  && strip \
    build/bin/galactrum-cli \
    build/bin/galactrum-tx \
    build/bin/galactrumd \
    build/lib/libgalactrumconsensus.so.0.0.0
