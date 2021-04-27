#!/bin/bash

# Runs afl-cov on a campaign

ARGS="-atcw -x 1 -p 1 -R 1"
READELF=/work/bin/readelf-2.36-gcov
COV_CMD="${READELF}-gcov"

afl-cov -d $OUTPUT --coverage-cmd "$READELF $ARGS AFL_FILE" --code-dir /git-repos/binutils-gdb/binutils
