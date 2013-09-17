-- Convert schema 'db_upgrades/_source/deploy/9/001-auto.yml' to 'db_upgrades/_source/deploy/10/001-auto.yml':;

;
BEGIN;

;
CREATE TEMPORARY TABLE conditionals_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL,
  user integer(16),
  freshman integer(16),
  created date NOT NULL,
  status enum NOT NULL,
  deadline date NOT NULL,
  timestamp timestamp NOT NULL,
  FOREIGN KEY (freshman) REFERENCES freshmen(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (user) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
INSERT INTO conditionals_temp_alter( id, user, created, status, deadline, timestamp) SELECT id, user, created, status, deadline, timestamp FROM conditionals;

;
DROP TABLE conditionals;

;
CREATE TABLE conditionals (
  id INTEGER PRIMARY KEY NOT NULL,
  user integer(16),
  freshman integer(16),
  created date NOT NULL,
  status enum NOT NULL,
  deadline date NOT NULL,
  timestamp timestamp NOT NULL,
  FOREIGN KEY (freshman) REFERENCES freshmen(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (user) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX conditionals_idx_freshman02 ON conditionals (freshman);

;
CREATE INDEX conditionals_idx_user02 ON conditionals (user);

;
INSERT INTO conditionals SELECT id, user, freshman, created, status, deadline, timestamp FROM conditionals_temp_alter;

;
DROP TABLE conditionals_temp_alter;

;

COMMIT;

