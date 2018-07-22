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

func InitStorage() (*sql.DB, error) {
	basePath := os.Getenv("HOME");
	dbFile := filepath.Join(basePath, HistoryFile);
	return sql.Open("sqlite3", dbFile);
}

func CreateTable(db *sql.DB) {
	db.Exec(`CREATE TABLE hl_history (
		id INTEGER,
		command TEXT,
		retcode INTEGER,
		timestamp TEXT
	)`);
}

func IsTableCreated(db *sql.DB) bool {
	rows, _ := db.Query(`SELECT name FROM sqlite_master
	WHERE type='table' AND name='hl_history'`);
	defer rows.Close();
	return rows.Next();
}

func InsertHistory(db *sql.DB, row History) {
	stmt, _ := db.Prepare(`INSERT INTO hl_history (
		id, command, retcode, timestamp
	) VALUES (
		0, ?, ?, ?
	)`);
	defer stmt.Close();
	stmt.Exec(row.command, row.retcode, row.timestamp);
}

func Test(line string) {
}
