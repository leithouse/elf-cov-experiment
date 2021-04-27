#!/bin/bash

export CORES=8
export WHATSUP=/afl/afl-whatsup
export AFL_NO_AFFINITY=1

INPUT=/corpus
AFL=/afl/afl-fuzz
READELF='/work/bin/readelf-2.36-afl'
ARGS='-atcw -x 1 -p 1 -R 1'             # binutils 2.28 doesn't have LTO syms
CMD='@@'
AFL_ARGS='-t 500 -m 2048'
PROGRAM="$READELF $ARGS"

if [ -z "$OUTPUT" ]; then
  echo No OUTPUT specified
  exit 1
fi
mkdir -p "$OUTPUT"

echo "Launching leader"
$AFL $AFL_ARGS -M afl-leader -i $INPUT -o $OUTPUT -- $PROGRAM $CMD &>/dev/null &
echo Waiting for fuzzing stats
while [[ ! -f $OUTPUT/afl-leader/fuzzer_stats ]]; do
  sleep 1
done
counter=1
while [ $counter -lt $CORES ]; do
  echo Launching follower $counter
  $AFL $AFL_ARGS -S afl-follower-$counter -i $INPUT -o $OUTPUT -- $PROGRAM $CMD &>/dev/null &
  STATS=$OUTPUT/afl-follower-$counter/fuzzer_stats
  echo Waiting for fuzzing stats
  while [[ ! -f $STATS ]]; do
    sleep 1
  done
  ((counter++))
done
echo Beginning monitoring
/work/script/monitor.js
