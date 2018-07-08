package main

import (
	"fmt"
	"os"
)

func main() {
	args := os.Args
	fmt.Printf("'%s'", args[1])
}
