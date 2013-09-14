-- Convert schema 'db_upgrades/_source/deploy/2/001-auto.yml' to 'db_upgrades/_source/deploy/3/001-auto.yml':;

;
BEGIN;

;
CREATE TEMPORARY TABLE events_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL,
  name varchar(1024) NOT NULL,
  date datetime,
  presenter integer(16),
  committee varchar(32) NOT NULL,
  type enum NOT NULL,
  timestamp timestamp NOT NULL,
  FOREIGN KEY (presenter) REFERENCES users(id)
);

;
INSERT INTO events_temp_alter( id, name, date, presenter, committee, type, timestamp) SELECT id, name, date, presenter, committee, type, timestamp FROM events;

;
DROP TABLE events;

;
CREATE TABLE events (
  id INTEGER PRIMARY KEY NOT NULL,
  name varchar(1024) NOT NULL,
  date datetime,
  presenter integer(16),
  committee varchar(32) NOT NULL,
  type enum NOT NULL,
  timestamp timestamp NOT NULL,
  FOREIGN KEY (presenter) REFERENCES users(id)
);

;
CREATE INDEX events_idx_presenter02 ON events (presenter);

;
INSERT INTO events SELECT id, name, date, presenter, committee, type, timestamp FROM events_temp_alter;

;
DROP TABLE events_temp_alter;

;
CREATE TEMPORARY TABLE major_projects_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL,
  name varchar(1024) NOT NULL,
  description varchar(10240) NOT NULL,
  submitter integer(16) NOT NULL,
  date datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  comments varchar(10240),
  committee varchar(32) NOT NULL,
  status enum NOT NULL,
  timestamp timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (submitter) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
INSERT INTO major_projects_temp_alter( id, name, description, submitter, date, comments, committee, status, timestamp) SELECT id, name, description, submitter, date, comments, committee, status, timestamp FROM major_projects;

;
DROP TABLE major_projects;

;
CREATE TABLE major_projects (
  id INTEGER PRIMARY KEY NOT NULL,
  name varchar(1024) NOT NULL,
  description varchar(10240) NOT NULL,
  submitter integer(16) NOT NULL,
  date datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  comments varchar(10240),
  committee varchar(32) NOT NULL,
  status enum NOT NULL,
  timestamp timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (submitter) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX major_projects_idx_submitter02 ON major_projects (submitter);

;
INSERT INTO major_projects SELECT id, name, description, submitter, date, comments, committee, status, timestamp FROM major_projects_temp_alter;

;
DROP TABLE major_projects_temp_alter;

;
CREATE TEMPORARY TABLE users_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL,
  UUID varchar(32) NOT NULL,
  freshman integer(16),
  timestamp timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (freshman) REFERENCES freshmen(id)
);

;
INSERT INTO users_temp_alter( id, UUID, freshman, timestamp) SELECT id, UUID, freshman, timestamp FROM users;

;
DROP TABLE users;

;
CREATE TABLE users (
  id INTEGER PRIMARY KEY NOT NULL,
  UUID varchar(32) NOT NULL,
  freshman integer(16),
  timestamp timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (freshman) REFERENCES freshmen(id)
);

;
CREATE INDEX users_idx_freshman02 ON users (freshman);

;
INSERT INTO users SELECT id, UUID, freshman, timestamp FROM users_temp_alter;

;
DROP TABLE users_temp_alter;

;

COMMIT;

