#!/bin/bash
set -e

REPOSITORY="hub.ackro.net"
PACKAGE="galactrum"
PACKAGE_SUFFIX="-alpine"
LATEST="1.1"

function docker_build {
  TAG=${1}
  ADDITIONAL_TAG=""

  if [ -z "${2}" ]; then
    BUILD=""
  else
    BUILD="-${2}"
  fi
  if [ "${TAG}" = "${LATEST}" ]; then
    ADDITIONAL_TAG=" -t$REPOSITORY/$PACKAGE:latest"
  fi

  eval "docker build -t${REPOSITORY}/${PACKAGE}:${TAG}${BUILD}${PACKAGE_SUFFIX} ${ADDITIONAL_TAG} ."
}

for tag in *; do
  if [ -d "${tag}" ]; then
    (
      cd "${tag}"
      for build in *; do
        if [ -d "${build}" ]; then
          if [ -f "${build}/Dockerfile" ]; then
            (
              cd "${build}"
              docker_build "${tag}" "${build}"
            )
          fi
        fi
      done
      if [ -f Dockerfile ]; then
        docker_build ${tag}
      fi
    )
  fi
done
