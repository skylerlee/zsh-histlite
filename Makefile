# Copyright (C) 2018, Skyler.
# Use of this source code is governed by the MIT license that can be
# found in the LICENSE file.

BUILD_FLAGS := -ldflags "-s -w"

.PHONY: default

default: build

build:
	go build $(BUILD_FLAGS) ./cmd/...
	@echo "Build done"
