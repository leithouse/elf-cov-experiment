#!/bin/bash
cd /LearnAFL

export CORES=1
export WHATSUP=/afl/afl-whatsup
export AFL_NO_AFFINITY=1

INPUT=/corpus
AFL=./afl-fuzz
PROGRAM='/work/bin/readelf-2.36-afl -atcw -x 1 -p 1 -R 1'
CMD='@@'

mkdir -p $OUTPUT

echo "Launching master"
$AFL -t 500 -m 2048 -M afl-master -i $INPUT -o $OUTPUT -- $PROGRAM $CMD &>/dev/null &
echo Waiting for fuzzing stats
while [[ ! -f $OUTPUT/afl-master/fuzzer_stats ]]; do
  sleep 1
done
echo Beginning monitoring
/work/script/monitor.js
