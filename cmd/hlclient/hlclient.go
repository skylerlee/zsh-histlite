package main

import (
	"os"
	"github.com/skylerlee/zsh-histlite"
)

func main() {
	args := os.Args
	line := args[1]
	histlite.Test(line)
}
