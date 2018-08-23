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
	Command   string
	Retcode   int
	Timestamp int64
}

type Context struct {
	db *sql.DB
}

func NewContext() *Context {
	homePath := os.Getenv("HOME")
	filePath := filepath.Join(homePath, HistoryFile)
	db, err := sql.Open("sqlite3", filePath)
	if err != nil {
		os.Exit(ERR_EXC)
	}
	return &Context{db}
}

func (ctx *Context) Close() {
	ctx.db.Close()
}

func (ctx *Context) CreateTable() {
	ctx.db.Exec(`CREATE TABLE zsh_history (
		id INTEGER,
		command TEXT,
		retcode INTEGER,
		timestamp INTEGER
	)`)
}

func (ctx *Context) IsTableCreated() bool {
	rows, err := ctx.db.Query(`SELECT name FROM sqlite_master
	WHERE type='table' AND name='zsh_history'`)
	if err != nil {
		os.Exit(ERR_EXC)
	}
	defer rows.Close()
	return rows.Next()
}

func (ctx *Context) InsertHistory(row History) {
	stmt, err := ctx.db.Prepare(`INSERT INTO zsh_history (
		id, command, retcode, timestamp
	) VALUES (
		0, ?, ?, ?
	)`)
	if err != nil {
		os.Exit(ERR_EXC)
	}
	defer stmt.Close()
	stmt.Exec(row.Command, row.Retcode, row.Timestamp)
}

func (ctx *Context) FindHistory(prefix string) *History {
	rows, err := ctx.db.Query(`SELECT command, retcode, timestamp FROM zsh_history
	WHERE command LIKE ?`, prefix + "%")
	if err != nil {
		os.Exit(ERR_EXC)
	}
	defer rows.Close()
	if !rows.Next() {
		return nil
	}
	var history History
	err = rows.Scan(&history.Command, &history.Retcode, &history.Timestamp)
	if err != nil {
		os.Exit(ERR_EXC)
	}
	return &history
}
