# Copyright (C) 2017, Skyler.
# Use of this source code is governed by the MIT license that can be
# found in the LICENSE file.

declare -gi _histlite_search_index=0
declare -g  _histlite_search_query=''

function zshaddhistory {
  hlclient -a "${1%%$'\n'}"
  histlite-reset
}

function histlite-reset {
  _histlite_search_index=0
  _histlite_search_query=''
}

function histlite-search-up {
  [[ -z $BUFFER ]] && return
  [[ -z $_histlite_search_query ]] && _histlite_search_query=$BUFFER
  (( _histlite_search_index++ ))
  local ret=$(hlclient -q $_histlite_search_query -n $_histlite_search_index)
  local arr=("${(@f)ret}")
  local cmd=${arr[1]}
  local idx=${arr[2]}
  if [[ idx -gt -1 ]]; then
    zle kill-whole-line
    BUFFER=$cmd
    zle end-of-line
  else
    BUFFER=$_histlite_search_query
  fi
}

function histlite-search-down {
  [[ -z $BUFFER ]] && return
  [[ -z $_histlite_search_query ]] && _histlite_search_query=$BUFFER
  (( _histlite_search_index-- ))
  local ret=$(hlclient -q $_histlite_search_query -n $_histlite_search_index)
  local arr=("${(@f)ret}")
  local cmd=${arr[1]}
  local idx=${arr[2]}
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
