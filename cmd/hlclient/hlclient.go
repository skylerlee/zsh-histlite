package main

import (
	"os"
	"fmt"
	"time"
	"strings"
	"strconv"
	"github.com/spf13/cobra"
	"github.com/skylerlee/zsh-histlite"
)

var command string

var mainCmd = &cobra.Command{
	Use: "hlclient",
	Run: func(cmd *cobra.Command, args []string) {
		switch {
		case cmd.Flag("add").Changed:
			addCommand(command)
		case cmd.Flag("drop").Changed:
			dropCommand(command)
		case cmd.Flag("query").Changed:
			queryCommand(command)
		default:
			cmd.Help()
		}
	},
}

func init() {
	flags := mainCmd.Flags()
	flags.StringVarP(&command, "add", "a", "", "add command to history")
	flags.StringVarP(&command, "drop", "d", "", "drop command from history")
	flags.StringVarP(&command, "query", "q", "", "query command by prefix")
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
}

func queryCommand(line string) {
	ctx := histlite.NewContext()
	preflight(ctx)
	i := strings.LastIndex(line, ":")
	prefix := line[0:i]
	num, err := strconv.ParseInt(line[i + 1:], 10, 32)
	if err != nil {
		os.Exit(histlite.ERR_EXC)
	}
	offset := int(num)
	history := ctx.FindHistory(prefix, offset)
	ctx.Close()
	command := ""
	if history != nil {
		command = history.Command
	}
	fmt.Printf("%s:%d", command, offset)
}

func main() {
	if err := mainCmd.Execute(); err != nil {
		os.Exit(histlite.ERR_EXC)
	}
}
