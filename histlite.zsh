# Copyright (C) 2018, Skyler.
# Use of this source code is governed by the MIT license that can be
# found in the LICENSE file.

setopt RE_MATCH_PCRE

declare -g  _histlite_search_query=''
declare -gi _histlite_search_index=0
declare -ga _histlite_search_result=()
declare -gr _histlite_widget_prefix='hl-'
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

function histlite-action-sync {
  _histlite_search_index=0
  _histlite_search_query=$BUFFER
}

function histlite-start-search {
  local out=$(hlclient -q "$_histlite_search_query" -n $_histlite_search_index)
  _histlite_search_result=("${(@f)out}")
}

function histlite-search-up {
  histlite-start-search
  local cmd=${_histlite_search_result[1]}
  local idx=${_histlite_search_result[2]}
  zle kill-whole-line
  if [[ idx -gt -1 ]]; then
    BUFFER=$cmd
    (( _histlite_search_index++ ))
  else
    BUFFER=$_histlite_search_query
  fi
  zle end-of-line
}

function histlite-search-down {
  histlite-start-search
  local cmd=${_histlite_search_result[1]}
  local idx=${_histlite_search_result[2]}
  zle kill-whole-line
  if [[ idx -gt -1 ]]; then
    BUFFER=$cmd
    (( _histlite_search_index-- ))
  else
    BUFFER=$_histlite_search_query
  fi
  zle end-of-line
}

function histlite-call-widget {
  local widget=$1
  if [[ ${+widgets[$widget]} -ne 1 ]]; then
    return 1
  fi
  zle $@
  return $?
}

function histlite-bind-widget {
  local widget=$1
  local action=$2
  local widget_info=$widgets[$widget]

  case $widget_info in
    user:*)
      zle -N $_histlite_widget_prefix-$widget ${widget_info#*:}
    ;;
    completion:*)
    # TODO:(implement)
    ;;
    builtin)
      eval "function $_histlite_widget_prefix-${(q)widget} {
        zle .${(q)widget} -- \$@
      }"
      zle -N $_histlite_widget_prefix-$widget
    ;;
    *)
    # TODO:(implement)
    ;;
  esac

  eval "function _histlite_widget_${(q)widget} {
    zle $_histlite_widget_prefix-${(q)widget} -- \$@ && histlite-action-$action
  }"

  zle -N $widget _histlite_widget_$widget
}

function histlite-bind-widgets {
  for widget in ${(f)"$(builtin zle -la)"}; do
    if [[ $widget =~ '^[\._]' ]]; then
      continue
    elif [[ -n ${_histlite_ignore_widgets[(r)$widget]} ]]; then
      continue
    else
      histlite-bind-widget $widget sync
    fi
  done
}

zle -N up-line-or-beginning-search histlite-search-up
zle -N down-line-or-beginning-search histlite-search-down
histlite-bind-widgets
