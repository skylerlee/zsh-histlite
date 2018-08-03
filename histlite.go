package histlite

import (
	"os"
	"path/filepath"
	"database/sql"
	_ "github.com/mattn/go-sqlite3"
)

const (
	HistoryFile = ".zsh_history.db"
)

type History struct {
	command string
	retcode int
	timestamp int
}

type Context struct {
	db *sql.DB
}

func NewContext() *Context {
	homePath := os.Getenv("HOME")
	filePath := filepath.Join(homePath, HistoryFile)
	db, err := sql.Open("sqlite3", filePath)
	if err != nil {
		os.Exit(1)
	}
	return &Context{db}
}

func (ctx *Context) CreateTable() {
	ctx.db.Exec(`CREATE TABLE zsh_history (
		id INTEGER,
		command TEXT,
		retcode INTEGER,
		timestamp TEXT
	)`)
}

func (ctx *Context) IsTableCreated() bool {
	rows, _ := ctx.db.Query(`SELECT name FROM sqlite_master
	WHERE type='table' AND name='zsh_history'`)
	defer rows.Close()
	return rows.Next()
}

func (ctx *Context) InsertHistory(row History) {
	stmt, _ := ctx.db.Prepare(`INSERT INTO zsh_history (
		id, command, retcode, timestamp
	) VALUES (
		0, ?, ?, ?
	)`)
	defer stmt.Close()
	stmt.Exec(row.command, row.retcode, row.timestamp)
}

func (ctx *Context) FindHistory(prefix string) string {
	rows, _ := ctx.db.Query(`SELECT * FROM zsh_history
	WHERE command LIKE '?%'`, prefix)
	rows.Next()
	result, _ := rows.Columns()
	return result[1]
}
