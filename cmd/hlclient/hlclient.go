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
			fmt.Println("add", command)
		case cmd.Flag("drop").Changed:
			fmt.Println("drop", command)
		case cmd.Flag("query").Changed:
			fmt.Println("query", command)
		}
	},
}

func init() {
	mainCmd.Flags().StringVarP(&command, "add", "a", "", "command to add to history")
	mainCmd.Flags().StringVarP(&command, "drop", "d", "", "command to drop from history")
	mainCmd.Flags().StringVarP(&command, "query", "q", "", "command prefix for query")
}

func main() {
	if err := mainCmd.Execute(); err != nil {
		os.Exit(1)
	}
}
