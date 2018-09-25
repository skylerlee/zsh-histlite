# Copyright (C) 2017, Skyler.
# Use of this source code is governed by the MIT license that can be
# found in the LICENSE file.

declare -g  _histlite_search_query=''
declare -gi _histlite_search_index=0
declare -ga _histlite_search_result=()

function zshaddhistory {
  hlclient -a "${1%%$'\n'}"
}

function histlite-sync-input {
  zle .self-insert
  _histlite_search_index=0
  _histlite_search_query=$BUFFER
}

function histlite-search {
  local out=$(hlclient -q "$_histlite_search_query" -n $_histlite_search_index)
  _histlite_search_result=("${(@f)out}")
}

function histlite-search-up {
  (( _histlite_search_index++ ))
  histlite-search
  local cmd=${_histlite_search_result[1]}
  local idx=${_histlite_search_result[2]}
  if [[ idx -gt -1 ]]; then
    zle kill-whole-line
    BUFFER=$cmd
    zle end-of-line
  else
    BUFFER=$_histlite_search_query
  fi
}

function histlite-search-down {
  (( _histlite_search_index-- ))
  histlite-search
  local cmd=${_histlite_search_result[1]}
  local idx=${_histlite_search_result[2]}
  if [[ idx -gt -1 ]]; then
    zle kill-whole-line
    BUFFER=$cmd
    zle end-of-line
  else
    BUFFER=$_histlite_search_query
  fi
}

zle -N self-insert histlite-sync-input
zle -N up-line-or-beginning-search histlite-search-up
zle -N down-line-or-beginning-search histlite-search-down
