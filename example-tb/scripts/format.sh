#!/bin/bash

HDL_PRETTY_ARGS=--vhdl-basic-offset=2

SCRIPT_PATH=$(realpath $(dirname $BASH_SOURCE))
cd $SCRIPT_PATH

find ../src -name '*.vhd' -print0 | while IFS= read -d '' -r file; do
  if [[ $(echo "$file" | grep "memory_axilite.vhd") || \
        $(echo "$file" | grep "memory_av_mm.vhd") ]]; then
    # Skip these files, since they are auto-generated anyway
    printf '(MWURM) Skipped %s\n' "$file"
    continue
  fi

  printf '(MWURM) Linting %s\n' "$file"
  ../../hdl-pretty/vhdl-pretty $HDL_PRETTY_ARGS <"$file" >lint.vhd
  mv lint.vhd "$file"
done
