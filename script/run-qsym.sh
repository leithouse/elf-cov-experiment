#!/bin/bash
RUN_DIR="$( cd "$(dirname "$0")" && pwd )"
export FUZZER=qsym
export TSTAMP=$(date +%s)
if [[ -z "$CORPUS_REPO" ]]; then
  echo Must supply CORPUS_REPO env variable
  exit 1
fi
if [[ -z "$CORPUS" ]]; then
  echo Must supply CORPUS env variable
  exit 2
fi

INPUT=$CORPUS_REPO/$CORPUS
export OUTPUT=/work/output/$FUZZER/$CORPUS-$TSTAMP

docker run --rm -w /work --cpus 2 -it -v "$RUN_DIR/..":/work -v "$INPUT":/corpus --privileged my/qsym sh -c "OUTPUT=$OUTPUT /work/script/campaign-qsym.sh"

$RUN_DIR/run-collect.sh
