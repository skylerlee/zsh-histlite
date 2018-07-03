package main

import (
	"bufio"
	"fmt"
	"os"
)

func start() {
	fp, err := os.Open("histlite.pipe")
	if err != nil {
		fmt.Println("fifo pipe not exists")
		os.Exit(1)
	}
	scanner := bufio.NewScanner(fp)
	for scanner.Scan() {
		line := scanner.Text()
		fmt.Println(line)
	}
}

func main() {
	start()
}
