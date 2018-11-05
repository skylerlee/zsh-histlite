package main

import (
	"flag"
	"fmt"
	"time"

	"github.com/skylerlee/zsh-histlite"
)

var (
	addString   string
	dropString  string
	queryString string
	offset      int
)

func init() {
	flag.StringVar(&addString, "a", "", "add command to history")
	flag.StringVar(&dropString, "d", "", "drop command from history")
	flag.StringVar(&queryString, "q", "", "query command by prefix")
	flag.IntVar(&offset, "n", 0, "command offset")
}

func preflight(ctx *histlite.Context) {
	if !ctx.IsTableCreated() {
		ctx.CreateTable()
	}
}

func addCommand(line string) {
	ctx := histlite.NewContext()
	preflight(ctx)
	ctx.InsertHistory(histlite.History{
		Command:   line,
		Retcode:   0,
		Timestamp: time.Now().Unix(),
	})
	ctx.Close()
}

func dropCommand(line string) {
	ctx := histlite.NewContext()
	preflight(ctx)
	// TODO: add drop code
	ctx.Close()
}

func queryCommand(line string) {
	ctx := histlite.NewContext()
	preflight(ctx)
	history := ctx.FindHistory(line, offset)
	ctx.Close()
	if history != nil {
		fmt.Printf("%d:%s", 0, history.Command)
	} else {
		fmt.Printf("%d:%s", -1, "")
	}
}

func main() {
	flag.Parse()
	switch {
	case addString != "":
		addCommand(addString)
	case dropString != "":
		dropCommand(dropString)
	case queryString != "":
		queryCommand(queryString)
	}
}
