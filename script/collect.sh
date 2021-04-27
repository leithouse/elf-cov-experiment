#!/bin/bash

# Runs afl-cov on a campaign

TMP=/tmp/$OUTPUT
mkdir -p $TMP
cp -r /binutils-gcov/binutils/* $TMP/
ARGS="-atcw -x 1 -p 1 -R 1"
READELF=$TMP/readelf

echo Running afl-cov...
afl-cov -d $OUTPUT --coverage-cmd "$READELF $ARGS AFL_FILE" -O --code-dir /binutils-gcov/binutils --enable-branch-coverage --coverage-at-exit 

