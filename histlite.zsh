# Copyright (C) 2017, Skyler.
# Use of this source code is governed by the MIT license that can be
# found in the LICENSE file.

function zshaddhistory {
  hlfc "${1%%$'\n'}"
}
