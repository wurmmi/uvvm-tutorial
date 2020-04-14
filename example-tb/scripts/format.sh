#!/bin/bash

HDL_PRETTY_ARGS=--vhdl-basic-offset=2

SCRIPT_PATH=$(realpath $(dirname $BASH_SOURCE))
cd $SCRIPT_PATH

find ../src -name '*.vhd' -print0 | while IFS= read -d '' -r file; do
  printf '(MWURM) Linting %s\n' "$file"
  ../../hdl-pretty/vhdl-pretty $HDL_PRETTY_ARGS <"$file" >lint.vhd
  mv lint.vhd "$file"
done
