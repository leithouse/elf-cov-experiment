#!/bin/bash

export CORES=8
export WHATSUP=afl-whatsup
export AFL_NO_AFFINITY=1

INPUT=/corpus
AFL=afl-fuzz
PROGRAM='/work/bin/readelf-2.36-afl -atcw -x 1 -p 1 -R 1'
CMD='@@'

mkdir -p $OUTPUT

echo "Launching master"
$AFL -p exploit -t 500 -m 2048 -M afl-master -i $INPUT -o $OUTPUT -- $PROGRAM $CMD #&>/dev/null &
echo Waiting for fuzzing stats
while [[ ! -f $OUTPUT/afl-master/fuzzer_stats ]]; do
  sleep 1
done
counter=1
schedules=(coe fast explore)
while [ $counter -lt $CORES ]; do
  sched=${schedules[((counter % 3))]}
  echo Launching follower $counter with scheduler: $sched
  $AFL -p $sched -t 500 -m 2048 -S afl-follower-$counter -i $INPUT -o $OUTPUT -- $PROGRAM $CMD #&>/dev/null &
  STATS=$OUTPUT/afl-follower-$counter/fuzzer_stats
  echo Waiting for fuzzing stats
  while [[ ! -f $STATS ]]; do
    sleep 1
  done
  ((counter++))
done
echo Beginning monitoring
/work/script/monitor.js
