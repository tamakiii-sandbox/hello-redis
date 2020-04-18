#!/usr/bin/env bash

DIR_ROOT=$(cd $(dirname $0)/..; pwd)

source ${DIR_ROOT}/lib/redis-bash-lib.sh 2> /dev/null

usage() {
  echo "subscribe.sh requires at least 1 argument."
  echo
  echo "Usage:  subscribe.sh [OPTIONS] COMMAND CHANNEL"
  echo
  echo "Options:"
  echo "  -h, --host <host>    Server hostname (default: 127.0.0.1)."
  echo "  -p, --port <port>    Server port (default: 6379)."
  echo
}

declare -A ARGS=()
declare -A OPTIONS=(
  [host]="127.0.0.1"
  [port]=6379
)

while (( "$#" )); do
  case "$1" in
    -h|--host)
      OPTIONS[host]=$2
      shift 2
      ;;
    -p|--port)
      OPTIONS[port]=$2
      shift 2
      ;;
    -c|--cmd)
      OPTIONS[cmd]=$2
      shift 2
      ;;
    --) # end argument parsing
      shift
      break
      ;;
    -*|--*=)
      echo "Error: Unsupported flag $1" >&2
      exit 1
      ;;
    *)
      ARGS[${#ARGS[@]}]=$1
      shift
      ;;
  esac
done

if \
  [ "${ARGS[0]}" == "" ] || \
  [ "${ARGS[1]}" == "" ] || \
  [ "${OPTIONS[host]}" == "" ] || \
  [ "${OPTIONS[port]}" == "" ]
then
  usage && exit 255
fi

while true
do
  exec 5>&-
  exec 5<>/dev/tcp/${OPTIONS[host]}/${OPTIONS[port]}

  redis-client 5 ${ARGS[0]} ${ARGS[1]} > /dev/null

  while true
  do
    unset ARGV
    OFS=${IFS};IFS=$'\n'
    ARGV=($(redis-client 5))
    IFS=${OFS}
    if [ "${ARGV[0]}" = "message" ] && [ "${ARGV[1]}" = "${ARGS[1]}" ]
    then
      echo ${ARGV[2]}
    elif [ -z ${ARGV} ]
    then
      sleep 1
      break
    fi
  done
done
