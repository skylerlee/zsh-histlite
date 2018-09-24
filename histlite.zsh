# Copyright (C) 2017, Skyler.
# Use of this source code is governed by the MIT license that can be
# found in the LICENSE file.

declare -g  _histlite_search_query=''
declare -gi _histlite_search_index=0
declare -ga _histlite_search_result=()

function zshaddhistory {
  hlclient -a "${1%%$'\n'}"
  histlite-reset
}

function histlite-search {
  local out=$(hlclient -q "$_histlite_search_query" -n $_histlite_search_index)
  _histlite_search_result=("${(@f)out}")
}

function histlite-reset {
  _histlite_search_index=0
  _histlite_search_query=''
}

function histlite-search-up {
  [[ -z $_histlite_search_query ]] && _histlite_search_query=$BUFFER
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
  [[ -z $_histlite_search_query ]] && _histlite_search_query=$BUFFER
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

zle -N histlite-search-up
zle -N histlite-search-down

bindkey "${terminfo[kcuu1]}" histlite-search-up
bindkey "${terminfo[kcud1]}" histlite-search-down
