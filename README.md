### Coverage Experiment

Campaign outputs are written to output/$fuzzer/$corpus-$timestamp

Designed for use with the corpi here: https://github.com/leithouse/elf-corpi

### Scripts

*collect.js*
  - Collects coverage results with afl-cov
  - Intended to be run in docker via _run-collect.sh_
  - Expects env variables OUTPUT

*monitor.js*
  - Runs fuzzing campaign for set number of hours
  - Expects env variables CORPUS, OUTPUT, WHATSUP

*campaign-X.sh*
  - Executes a fuzzing campaign. Intended to be run within docker instances launched by _run-X_ scripts

*run-X.sh*
  - Executes fuzzing campaign in a docker, then collects results
  - Expects env variables CORPUS\_REPO and CORPUS

*run-collect.sh*
  - Run _collect.js_ inside docker container
  - Expects env variables OUTPUT


### Dockers

Docker container names are hardcoded in and expected to be _my/$fuzzer_. The same docker images are used in the bug hunt experiment.

Docker containers are just additions of nodeJS to zjuchenyuan's Unifuzz images (https://github.com/unifuzz/dockerized_fuzzing)

The AFL container also adds gdb, exploitable, afl-utils, afl-collect, and compiles gcov binutils

```
[sudo] docker build --network=host -t my/afl docker/afl
[sudo] docker build --network=host -t my/mopt docker/mopt
[sudo] docker build --network=host -t my/qsym docker/qsym
[sudo] docker build --network=host -t my/learnafl docker/learnafl
[sudo] docker build --network=host -t my/aflfast docker/aflfast

```


### Run experiment

```
# May need sudo depending on docker permissions

declare -a fuzzers=('afl','mopt','qsym','learnafl','aflfast')
declare -a corpi=('standard','brute-force','engineered')
for FUZZER in ${fuzzers[@]}; do
  for CORPUS in ${corpi[@]}; do
    [sudo] CORPUS_REPO=/path/to/corpi_repo CORPUS=$CORPUS script/run-$FUZZER.sh
  done
done
```
