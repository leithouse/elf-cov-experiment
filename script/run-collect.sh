#!/bin/bash
RUN_DIR="$( cd "$(dirname "$0")" && pwd )"

if [ -z $OUTPUT ]; then
  echo Must specify OUTPUT env var
  exit 1
fi

docker run --rm -it -w /work -v "$RUN_DIR"/..:/work my/afl sh -c "OUTPUT=$OUTPUT /work/script/collect.sh"
