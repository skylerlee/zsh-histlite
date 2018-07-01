package main

import (
	"bufio"
	"fmt"
	"os"
)

func start() {
	scanner := bufio.NewScanner(os.Stdin)
	for scanner.Scan() {
		line := scanner.Text()
		fmt.Println(line)
	}
}

func main() {
	start()
}
