#!/bin/bash
# Copyright (c) 2021, 2023 Oracle and/or its affiliates.
#
set -e
source VERSION

SUFFIX='' [ -n "$1" ] && SUFFIX=$1
MAJOR_VERSIONS=("${!MYSQL_ROUTER_VERSIONS[@]}"); [ -n "$2" ] && MAJOR_VERSIONS=("${@:2}")

for MAJOR_VERSION in "${MAJOR_VERSIONS[@]}"; do
  for MULTIARCH_VERSION in ${MULTIARCH_VERSIONS}; do
    if [[ "$MULTIARCH_VERSION" == "$MAJOR_VERSION" ]]; then
      if [[ "$MAJOR_VERSION" == "$LATEST" ]]; then
        echo "$MAJOR_VERSION$SUFFIX ${MYSQL_ROUTER_VERSIONS["$MAJOR_VERSION"]}$SUFFIX ${FULL_ROUTER_VERSIONS["$MAJOR_VERSION"]}$SUFFIX latest$SUFFIX"
      else
        echo "$MAJOR_VERSION$SUFFIX ${MYSQL_ROUTER_VERSIONS["$MAJOR_VERSION"]}$SUFFIX ${FULL_ROUTER_VERSIONS["$MAJOR_VERSION"]}$SUFFIX"
      fi
    fi
  done
done
