# Copyright (C) 2017, Skyler.
# Use of this source code is governed by the MIT license that can be
# found in the LICENSE file.

typeset -g -i _histlite_search_index

function zshaddhistory {
  hlclient -a "${1%%$'\n'}"
}

function histlite-search-up {
  [[ -z $BUFFER ]] && return
  (( _histlite_search_index++ ))
  local ret=$(hlclient -q $BUFFER -n $_histlite_search_index)
  local cmd=${ret%:*}
  local idx=${ret##*:}
  if [[ -n $ret ]]; then
    zle kill-whole-line
    BUFFER=$ret
    zle end-of-line
  fi
}

function histlite-search-down {
  [[ -z $BUFFER ]] && return
  (( _histlite_search_index-- ))
  local ret=$(hlclient -q $BUFFER -n $_histlite_search_index)
  local cmd=${ret%:*}
  local idx=${ret##*:}
  if [[ -n $ret ]]; then
    zle kill-whole-line
    BUFFER=$ret
    zle end-of-line
  fi
}

zle -N histlite-search-up
zle -N histlite-search-down

bindkey "${terminfo[kcuu1]}" histlite-search-up
bindkey "${terminfo[kcud1]}" histlite-search-down
