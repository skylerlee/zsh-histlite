package histlite

import (
	"database/sql"
	_ "github.com/mattn/go-sqlite3"
)

const (
	HistoryFile = ".zsh_history.db"
)

func Test(line string) {
}
