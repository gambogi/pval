-- Convert schema 'db_upgrades/_source/deploy/5/001-auto.yml' to 'db_upgrades/_source/deploy/6/001-auto.yml':;

;
BEGIN;

;
CREATE TEMPORARY TABLE freshmen_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL,
  name varchar(1024) NOT NULL,
  vote_date date NOT NULL DEFAULT CURRENT_DATE,
  comments varchar(10240),
  ten_week date NOT NULL DEFAULT CURRENT_DATE,
  passed_freshman_project integer(1) NOT NULL DEFAULT 0,
  freshman_project_comments varchar(10240),
  result enum NOT NULL DEFAULT 'pending',
  timestamp timestamp NOT NULL,
  FOREIGN KEY (id) REFERENCES users(freshman)
);

;
INSERT INTO freshmen_temp_alter( id, name, vote_date, comments, ten_week, passed_freshman_project, freshman_project_comments, result, timestamp) SELECT id, name, vote_date, comments, ten_week, passed_freshman_project, freshman_project_comments, result, timestamp FROM freshmen;

;
DROP TABLE freshmen;

;
CREATE TABLE freshmen (
  id INTEGER PRIMARY KEY NOT NULL,
  name varchar(1024) NOT NULL,
  vote_date date NOT NULL DEFAULT CURRENT_DATE,
  comments varchar(10240),
  ten_week date NOT NULL DEFAULT CURRENT_DATE,
  passed_freshman_project integer(1) NOT NULL DEFAULT 0,
  freshman_project_comments varchar(10240),
  result enum NOT NULL DEFAULT 'pending',
  timestamp timestamp NOT NULL,
  FOREIGN KEY (id) REFERENCES users(freshman)
);

;
CREATE INDEX freshmen_name_idx02 ON freshmen (name);

;
CREATE INDEX freshmen_vote_date_idx02 ON freshmen (vote_date);

;
CREATE INDEX freshmen_ten_week_idx02 ON freshmen (ten_week);

;
CREATE INDEX freshmen_result_idx02 ON freshmen (result);

;
INSERT INTO freshmen SELECT id, name, vote_date, comments, ten_week, passed_freshman_project, freshman_project_comments, result, timestamp FROM freshmen_temp_alter;

;
DROP TABLE freshmen_temp_alter;

;

COMMIT;

