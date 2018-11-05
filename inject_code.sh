#!/usr/bin/env bash

src=$1
dat=$2
out=$3

# scan file for keys
function scan_keys {
  grep -Po '(?<={{)\w+(?=}})' $src
}

# find line number by pattern
function find_line {
  local ret=$(grep -Pon "\-\-\s*$1:\s*$2\s*\-\-" $dat)
  echo ${ret%%:*}
}

# clip code block by key
function clip_code {
  local key=$1
  local begin=$(find_line BEGIN $key)
  local end=$(find_line END $key)
  sed -n "$((begin + 1)),$((end - 1))p" $dat
}

function truncate_code {
  echo ${1//\n/}
}

function inject_code_blocks {
  local opts=''
  for key in ${!code_blocks[@]}; do
    local code=${code_blocks[$key]}
    code=$(truncate_code "$code")
    opts+="-e s/{{$key}}/'$code'/g "
  done
  eval "sed $opts$src"
}

function main {
  declare -gA code_blocks=()
  for key in $(scan_keys); do
    local code=$(clip_code $key)
    code_blocks[$key]="$code"
  done
  inject_code_blocks > $out
}

main
