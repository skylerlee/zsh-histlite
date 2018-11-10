# Copyright (C) 2018, Skyler.
# Use of this source code is governed by the MIT license that can be
# found in the LICENSE file.

BUILD_FLAGS := -ldflags "-s -w"
OUTPUT_PATH := $(PWD)/bin

.PHONY: default

default: generate build

generate:
	go generate

build: export GOBIN = $(OUTPUT_PATH)
build:
	go install $(BUILD_FLAGS) ./cmd/...
	@echo "Build done"
