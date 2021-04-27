#!/bin/bash

export CORES=8
export WHATSUP=afl-whatsup
export AFL_NO_AFFINITY=1

INPUT=/corpus
AFL=afl-fuzz
READELF='/work/bin/readelf-2.36-afl'
ARGS='-atcw -x 1 -p 1 -R 1'           
CMD='@@'
AFL_ARGS="-L 0"
PROGRAM="$READELF $ARGS"

if [ -z "$OUTPUT" ]; then
    echo No OUTPUT specified
      exit 1
fi
mkdir -p $OUTPUT

echo "Launching master"
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
