# Copyright (C) 2017, Skyler.
# Use of this source code is governed by the MIT license that can be
# found in the LICENSE file.

function zshaddhistory {
  hlclient -a "${1%%$'\n'}"
}

function histlite-search-up {
}

function histlite-search-down {
}

zle -N histlite-search-up
zle -N histlite-search-down

bindkey "${terminfo[kcuu1]}" histlite-search-up
bindkey "${terminfo[kcud1]}" histlite-search-down
