# Copyright (C) 2018, Skyler.
# Use of this source code is governed by the MIT license that can be
# found in the LICENSE file.

.PHONY: default

default: build

build:
	go build ./cmd/...
	@echo "Build done"
