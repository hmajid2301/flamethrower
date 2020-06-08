FROM ubuntu:20.04 AS build

<<<<<<< HEAD
ENV BUILD_DEPS "g++ cmake make libldns-dev libnghttp2-dev libuv1-dev libgnutls28-dev pkgconf"
=======
ENV BUILD_DEPS "g++ cmake make libldns-dev libuv1-dev libgnutls28-dev pkgconf"
ENV DEBIAN_FRONTEND=noninteractive
>>>>>>> 3e51fff428c7ecbbf9e365846895a0a86ce743b3

RUN \
    apt-get update && \
    apt-get install --yes --no-install-recommends ${BUILD_DEPS}

COPY . /src

RUN \
    mkdir /tmp/build && \
    cd /tmp/build && \
    cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo /src && \
    make all tests && \
    ./tests

FROM ubuntu:20.04 AS runtime

ENV RUNTIME_DEPS "libldns2 libuv1 nghttp2"

RUN \
    apt-get update && \
    apt-get install --yes --no-install-recommends ${RUNTIME_DEPS} && \
    rm -rf /var/lib/apt

COPY --from=build /tmp/build/flame /usr/local/bin/flame

ENTRYPOINT [ "/usr/local/bin/flame" ]
