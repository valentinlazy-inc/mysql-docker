#!/bin/bash
# Copyright (c) 2021, Oracle and/or its affiliates.
#
set -e
source VERSION

MAJOR_VERSIONS=("${!MYSQL_ROUTER_VERSIONS[@]}"); [ -n "$1" ] && MAJOR_VERSIONS=("${@:1}")

for MAJOR_VERSION in "${MAJOR_VERSIONS[@]}"; do
  if [[ "$MAJOR_VERSION" == "$LATEST" ]]; then
    echo "$MAJOR_VERSION ${MYSQL_ROUTER_VERSIONS["$MAJOR_VERSION"]} ${FULL_ROUTER_VERSIONS["$MAJOR_VERSION"]} latest"
  else
    echo "$MAJOR_VERSION ${MYSQL_ROUTER_VERSIONS["$MAJOR_VERSION"]} ${FULL_ROUTER_VERSIONS["$MAJOR_VERSION"]}"
  fi
done
