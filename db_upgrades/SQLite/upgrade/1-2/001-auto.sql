-- Convert schema 'db_upgrades/_source/deploy/1/001-auto.yml' to 'db_upgrades/_source/deploy/2/001-auto.yml':;

;
BEGIN;

;
CREATE TEMPORARY TABLE freshmen_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL,
  user integer(16),
  name varchar(1024) NOT NULL,
  vote_date date NOT NULL DEFAULT CURRENT_DATE,
  comments varchar(10240),
  ten_week date NOT NULL DEFAULT CURRENT_DATE,
  passed_freshman_project integer(1) NOT NULL DEFAULT 0,
  freshman_project_comments varchar(10240),
  result enum NOT NULL DEFAULT 'pending',
  timestamp timestamp NOT NULL,
  FOREIGN KEY (user) REFERENCES users(id)
);

;
INSERT INTO freshmen_temp_alter( id, user, name, vote_date, comments, ten_week, passed_freshman_project, freshman_project_comments, result, timestamp) SELECT id, user, name, vote_date, comments, ten_week, passed_freshman_project, freshman_project_comments, result, timestamp FROM freshmen;

;
DROP TABLE freshmen;

;
CREATE TABLE freshmen (
  id INTEGER PRIMARY KEY NOT NULL,
  user integer(16),
  name varchar(1024) NOT NULL,
  vote_date date NOT NULL DEFAULT CURRENT_DATE,
  comments varchar(10240),
  ten_week date NOT NULL DEFAULT CURRENT_DATE,
  passed_freshman_project integer(1) NOT NULL DEFAULT 0,
  freshman_project_comments varchar(10240),
  result enum NOT NULL DEFAULT 'pending',
  timestamp timestamp NOT NULL,
  FOREIGN KEY (user) REFERENCES users(id)
);

;
CREATE INDEX freshmen_idx_user02 ON freshmen (user);

;
INSERT INTO freshmen SELECT id, user, name, vote_date, comments, ten_week, passed_freshman_project, freshman_project_comments, result, timestamp FROM freshmen_temp_alter;

;
DROP TABLE freshmen_temp_alter;

;
CREATE TEMPORARY TABLE major_projects_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL,
  name varchar(1024) NOT NULL,
  description varchar(10240) NOT NULL,
  submitter integer(16) NOT NULL,
  date datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  comments varchar(10240),
  committee binary(16) NOT NULL,
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
  committee binary(16) NOT NULL,
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
CREATE TEMPORARY TABLE packets_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL,
  user integer(16) NOT NULL,
  given date NOT NULL DEFAULT CURRENT_DATE,
  due date NOT NULL DEFAULT CURRENT_DATE,
  timestamp timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user) REFERENCES freshmen(id)
);

;
INSERT INTO packets_temp_alter( id, user, given, due, timestamp) SELECT id, user, given, due, timestamp FROM packets;

;
DROP TABLE packets;

;
CREATE TABLE packets (
  id INTEGER PRIMARY KEY NOT NULL,
  user integer(16) NOT NULL,
  given date NOT NULL DEFAULT CURRENT_DATE,
  due date NOT NULL DEFAULT CURRENT_DATE,
  timestamp timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user) REFERENCES freshmen(id)
);

;
CREATE INDEX packets_idx_user02 ON packets (user);

;
INSERT INTO packets SELECT id, user, given, due, timestamp FROM packets_temp_alter;

;
DROP TABLE packets_temp_alter;

;
CREATE TEMPORARY TABLE queue_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL,
  user integer(16) NOT NULL,
  date_added datetime NOT NULL DEFAULT CURRENT_DATE,
  filled tinyint NOT NULL,
  timestamp timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user) REFERENCES users(id)
);

;
INSERT INTO queue_temp_alter( id, user, date_added, filled, timestamp) SELECT id, user, date_added, filled, timestamp FROM queue;

;
DROP TABLE queue;

;
CREATE TABLE queue (
  id INTEGER PRIMARY KEY NOT NULL,
  user integer(16) NOT NULL,
  date_added datetime NOT NULL DEFAULT CURRENT_DATE,
  filled tinyint NOT NULL,
  timestamp timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user) REFERENCES users(id)
);

;
CREATE INDEX queue_idx_user02 ON queue (user);

;
INSERT INTO queue SELECT id, user, date_added, filled, timestamp FROM queue_temp_alter;

;
DROP TABLE queue_temp_alter;

;
CREATE TEMPORARY TABLE roster_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL,
  user integer(16) NOT NULL,
  date date NOT NULL DEFAULT CURRENT_DATE,
  room integer(4) NOT NULL,
  timestamp timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
INSERT INTO roster_temp_alter( id, user, date, room, timestamp) SELECT id, user, date, room, timestamp FROM roster;

;
DROP TABLE roster;

;
CREATE TABLE roster (
  id INTEGER PRIMARY KEY NOT NULL,
  user integer(16) NOT NULL,
  date date NOT NULL DEFAULT CURRENT_DATE,
  room integer(4) NOT NULL,
  timestamp timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX roster_idx_user02 ON roster (user);

;
INSERT INTO roster SELECT id, user, date, room, timestamp FROM roster_temp_alter;

;
DROP TABLE roster_temp_alter;

;
CREATE TEMPORARY TABLE spring_evals_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL,
  date datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  user integer(16) NOT NULL,
  comments varchar(10240),
  result enum NOT NULL,
  timestamp timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
INSERT INTO spring_evals_temp_alter( id, date, user, comments, result, timestamp) SELECT id, date, user, comments, result, timestamp FROM spring_evals;

;
DROP TABLE spring_evals;

;
CREATE TABLE spring_evals (
  id INTEGER PRIMARY KEY NOT NULL,
  date datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  user integer(16) NOT NULL,
  comments varchar(10240),
  result enum NOT NULL,
  timestamp timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX spring_evals_idx_user02 ON spring_evals (user);

;
INSERT INTO spring_evals SELECT id, date, user, comments, result, timestamp FROM spring_evals_temp_alter;

;
DROP TABLE spring_evals_temp_alter;

;
CREATE TEMPORARY TABLE users_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL,
  UUID binary(16) NOT NULL,
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
  UUID binary(16) NOT NULL,
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
CREATE TEMPORARY TABLE winter_evals_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL,
  user integer(16) NOT NULL,
  projects varchar(10240),
  comments varchar(10240),
  date date NOT NULL DEFAULT CURRENT_DATE,
  timestamp timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
INSERT INTO winter_evals_temp_alter( id, user, projects, comments, date, timestamp) SELECT id, user, projects, comments, date, timestamp FROM winter_evals;

;
DROP TABLE winter_evals;

;
CREATE TABLE winter_evals (
  id INTEGER PRIMARY KEY NOT NULL,
  user integer(16) NOT NULL,
  projects varchar(10240),
  comments varchar(10240),
  date date NOT NULL DEFAULT CURRENT_DATE,
  timestamp timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX winter_evals_idx_user02 ON winter_evals (user);

;
INSERT INTO winter_evals SELECT id, user, projects, comments, date, timestamp FROM winter_evals_temp_alter;

;
DROP TABLE winter_evals_temp_alter;

;

COMMIT;

