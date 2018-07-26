package main

import (
	"os"
	"github.com/spf13/cobra"
	"github.com/skylerlee/zsh-histlite"
)

var mainCmd = &cobra.Command{
	Use: "hlclient",
	Run: func(cmd *cobra.Command, args []string) {
	},
};

func main() {
	if err := mainCmd.Execute(); err != nil {
		os.Exit(1);
	}
}
