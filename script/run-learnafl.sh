#!/bin/bash
RUN_DIR="$( cd "$(dirname "$0")" && pwd )"
export FUZZER=afl
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

docker run --rm -w /work -it -v "$RUN_DIR/..":/work -v "$INPUT":/corpus my/learnafl sh -c "OUTPUT=$OUTPUT /work/script/campaign-learnafl.sh"

$RUN_DIR/run-collect.sh
