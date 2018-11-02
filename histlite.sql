-- BEGIN: CREATE_TABLE --
CREATE TABLE zsh_history (
  id INTEGER PRIMARY KEY,
  command TEXT,
  retcode INTEGER,
  timestamp INTEGER
)
-- END: CREATE_TABLE --

-- BEGIN: TEST_TABLE --
SELECT name FROM sqlite_master WHERE type='table' AND name='zsh_history'
-- END: TEST_TABLE --

-- BEGIN: INSERT_ITEM --
INSERT INTO zsh_history (command, retcode, timestamp) VALUES (?, ?, ?)
-- END: INSERT_ITEM --

-- BEGIN: QUERY_ITEM --
SELECT command, retcode, timestamp FROM zsh_history
WHERE command LIKE ? ORDER BY timestamp DESC LIMIT ?, 1
-- END: QUERY_ITEM --
