#!/bin/sh
set -e

SLEEP_TIME=60

cd /opt/sentinel
while true; do
  sleep ${SLEEP_TIME}
  date
  ./venv/bin/python bin/sentinel.py
done
