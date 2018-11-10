# Copyright (C) 2018, Skyler.
# Use of this source code is governed by the MIT license that can be
# found in the LICENSE file.

BUILD_FLAGS := -ldflags "-s -w"

.PHONY: default

default: generate build

generate:
	go generate

build:
	go build -o bin/hlclient $(BUILD_FLAGS) ./cmd/...
	@echo "Build done"
