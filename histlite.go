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

func InsertHistory(db *sql.DB) {
	db.Exec(`INSERT INTO hl_history (
		id, command, retcode, timestamp
	) VALUES (
		0, "test", 0, 0
	)`);
}

func Test(line string) {
}
