#
# Sentinel for Endorphin Core on Alpine Linux
#
FROM ackro/python:2.7-alpine as build
ARG NAME=sentinel
ENV LC_ALL="en_US.UTF-8"
ENV LC_TYPE="en_US.UTF-8"

WORKDIR /opt
RUN wget https://github.com/galactrum/sentinel/archive/master.zip \
  && unzip master.zip \
  && rm master.zip \
  && mv sentinel-master sentinel

WORKDIR /opt/sentinel
COPY sentinel_host_connect.patch ./
RUN patch lib/galactrum_config.py < sentinel_host_connect.patch \
  && virtualenv ./venv \
  && ./venv/bin/pip install -r requirements.txt \
  && adduser -D -g '' -s /sbin/nologin $NAME \
  && chown -R $NAME:$NAME /opt/sentinel/database
COPY sentinel.conf ./
COPY entrypoint.sh /

USER $NAME
VOLUME /etc/galactrum /opt/sentinel/database
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/sh"]
