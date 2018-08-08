package main

import (
	"os"
	"time"
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
	mainCmd.Flags().StringVarP(&command, "add", "a", "", "add command to history")
	mainCmd.Flags().StringVarP(&command, "drop", "d", "", "drop command from history")
	mainCmd.Flags().StringVarP(&command, "query", "q", "", "query command by prefix")
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
	ctx.FindHistory(line)
	ctx.Close()
}

func main() {
	if err := mainCmd.Execute(); err != nil {
		os.Exit(1)
	}
}
