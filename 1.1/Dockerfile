#
# Galactrum for Alpine Linux
#
FROM hub.ackro.net/galactrum:1.1-build-alpine as build
FROM ackro/bitcoin:0.16-base-alpine
ARG NAME=galactrum
ARG DAEMON=galactrumd
ARG PORT=6270
ARG VERSION=1.1.6

COPY --from=build /usr/local/src/${NAME}/build /usr/local/
COPY entrypoint.sh /entrypoint.sh
RUN adduser -D -g '' -s /sbin/nologin ${NAME} \
  && mkdir -p /etc/galactrum \
  && chown -R $NAME /etc/galactrum
WORKDIR /home/${NAME}
USER ${NAME}

EXPOSE $PORT
VOLUME ["/home/${NAME}"]
ENTRYPOINT ["/entrypoint.sh"]
CMD ["galactrumd"]
