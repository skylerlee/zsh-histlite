-- BEGIN CREATE_TABLE --
CREATE TABLE zsh_history (
  id INTEGER PRIMARY KEY,
  command TEXT,
  retcode INTEGER,
  timestamp INTEGER
)
-- END CREATE_TABLE --
