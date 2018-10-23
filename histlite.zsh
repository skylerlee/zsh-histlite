# Copyright (C) 2018, Skyler.
# Use of this source code is governed by the MIT license that can be
# found in the LICENSE file.

setopt RE_MATCH_PCRE

declare -g  _histlite_search_query=''
declare -gi _histlite_search_index=0
declare -gi _histlite_state_locked=0
declare -gr _histlite_widget_prefix=hl-orig
declare -ga _histlite_ignore_widgets=(
  beep
  run-help
  set-local-history
  which-command
  yank
  yank-pop
)

function zshaddhistory {
  hlclient -a "${1%%$'\n'}"
}

function _histlite-state-lock {
  _histlite_state_locked=1
}

function _histlite-state-unlock {
  _histlite_state_locked=0
}

function _histlite-action-sync {
  (( $_histlite_state_locked )) && return
  # Sync current state
  _histlite_search_index=0
  _histlite_search_query=$BUFFER
}

function _histlite-do-search {
  hlclient -q "$_histlite_search_query" -n $_histlite_search_index
}

function _histlite-bind-widget {
  local widget=$1
  local action=$2
  local prefix=$_histlite_widget_prefix
  local widget_info=(${(s.:.)widgets[$widget]})
  local widget_type=${widget_info[1]}
  local widget_func=${widget_info[2]}
  local widget_ext=${widget_info[3]}

  case $widget_type in
    user)
      zle -N $prefix-$widget $widget_func
    ;;
    completion)
      zle -C $prefix-$widget $widget_func $widget_ext
    ;;
    builtin)
      eval "function $prefix-${(q)widget} {
        zle .${(q)widget} -- \$@
      }"
      zle -N $prefix-$widget
    ;;
    *)
      echo "zsh-histlite: unhandled ZLE widget '$widget'"
    ;;
  esac

  eval "function _hl_bound_${(q)widget} {
    zle $prefix-${(q)widget} -- \$@ && _histlite-action-$action
  }"

  # Rebind target widget
  zle -N $widget _hl_bound_$widget
}

function _histlite-bind-widgets {
  for widget in ${(f)"$(builtin zle -la)"}; do
    if [[ $widget =~ '^[\._]' ]]; then
      continue
    elif [[ -n ${_histlite_ignore_widgets[(r)$widget]} ]]; then
      continue
    else
      _histlite-bind-widget $widget sync
    fi
  done
}

function histlite-search-up {
  _histlite-state-lock
  local result=$(_histlite-do-search)
  local errcode=${result%%:*}
  local command=${result#*:}
  zle kill-whole-line
  if (( errcode > -1 )); then
    BUFFER=$command
    (( _histlite_search_index++ ))
  else
    BUFFER=$_histlite_search_query
  fi
  zle end-of-line
  _histlite-state-unlock
}

function histlite-search-down {
  _histlite-state-lock
  zle kill-whole-line
  if (( _histlite_search_index > 0 )); then
    (( _histlite_search_index-- ))
    local result=$(_histlite-do-search)
    local errcode=${result%%:*}
    local command=${result#*:}
    if (( errcode > -1 )); then
      BUFFER=$command
    fi
  else
    BUFFER=$_histlite_search_query
  fi
  zle end-of-line
  _histlite-state-unlock
}

_histlite-bind-widgets

zle -N up-line-or-beginning-search histlite-search-up
zle -N down-line-or-beginning-search histlite-search-down
