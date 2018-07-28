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
		if cmd.Flag("query").Changed {
			fmt.Println(command)
		}
	},
}

func init() {
	mainCmd.Flags().StringVarP(&command, "query", "q", "", "command prefix for query")
}

func main() {
	if err := mainCmd.Execute(); err != nil {
		os.Exit(1)
	}
}
