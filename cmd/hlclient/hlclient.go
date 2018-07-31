package main

import (
	"os"
	"fmt"
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

func addCommand(line string) {
}

func dropCommand(line string) {
}

func queryCommand(line string) {
}

func main() {
	if err := mainCmd.Execute(); err != nil {
		os.Exit(1)
	}
}
