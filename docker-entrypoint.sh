#!/usr/bin/env bash

if [ "$1" == "" ]; then
  bash
else
  exec "$@"
fi
