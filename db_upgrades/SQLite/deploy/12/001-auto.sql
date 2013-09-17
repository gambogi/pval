-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Mon Sep 16 23:09:41 2013
-- 

;
BEGIN TRANSACTION;
--
-- Table: control_panel
--
CREATE TABLE control_panel (
  id INTEGER PRIMARY KEY NOT NULL,
  fall_form boolean NOT NULL DEFAULT 0,
  winter_form boolean NOT NULL DEFAULT 0,
  spring_form boolean NOT NULL DEFAULT 0
);
--
-- Table: freshmen
--
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
CREATE INDEX freshmen_name_idx ON freshmen (name);
CREATE INDEX freshmen_vote_date_idx ON freshmen (vote_date);
CREATE INDEX freshmen_ten_week_idx ON freshmen (ten_week);
CREATE INDEX freshmen_result_idx ON freshmen (result);
--
-- Table: users
--
CREATE TABLE users (
  id INTEGER PRIMARY KEY NOT NULL,
  UUID varchar(37) NOT NULL,
  freshman integer(16),
  timestamp timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (freshman) REFERENCES freshmen(id)
);
CREATE INDEX users_idx_freshman ON users (freshman);
CREATE INDEX user_uuid_idx ON users (UUID);
--
-- Table: conditionals
--
CREATE TABLE conditionals (
  id INTEGER PRIMARY KEY NOT NULL,
  user integer(16),
  freshman integer(16),
  created date NOT NULL,
  status enum NOT NULL,
  deadline date NOT NULL,
  description varchar(10240) NOT NULL DEFAULT '',
  timestamp timestamp NOT NULL,
  FOREIGN KEY (freshman) REFERENCES freshmen(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (user) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX conditionals_idx_freshman ON conditionals (freshman);
CREATE INDEX conditionals_idx_user ON conditionals (user);
CREATE INDEX conditional_created_idx ON conditionals (created);
CREATE INDEX conditional_deadline_idx ON conditionals (deadline);
CREATE INDEX conditional_status_idx ON conditionals (status);
--
-- Table: events
--
CREATE TABLE events (
  id INTEGER PRIMARY KEY NOT NULL,
  name varchar(1024) NOT NULL,
  date datetime,
  presenter integer(16),
  committee varchar(37) NOT NULL,
  type enum NOT NULL,
  timestamp timestamp NOT NULL,
  FOREIGN KEY (presenter) REFERENCES users(id)
);
CREATE INDEX events_idx_presenter ON events (presenter);
CREATE INDEX event_date_idx ON events (date);
CREATE INDEX event_committee_idx ON events (committee);
CREATE INDEX event_type_idx ON events (type);
--
-- Table: major_projects
--
CREATE TABLE major_projects (
  id INTEGER PRIMARY KEY NOT NULL,
  name varchar(1024) NOT NULL,
  description varchar(10240) NOT NULL,
  submitter integer(16) NOT NULL,
  date datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  comments varchar(10240),
  committee varchar(37) NOT NULL,
  status enum NOT NULL,
  timestamp timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (submitter) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX major_projects_idx_submitter ON major_projects (submitter);
CREATE INDEX major_projects_status_idx ON major_projects (status);
CREATE INDEX major_projects_committee_idx ON major_projects (committee);
CREATE INDEX major_projects_date_idx ON major_projects (date);
--
-- Table: packets
--
CREATE TABLE packets (
  id INTEGER PRIMARY KEY NOT NULL,
  user integer(16) NOT NULL,
  given date NOT NULL DEFAULT CURRENT_DATE,
  due date NOT NULL DEFAULT CURRENT_DATE,
  timestamp timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  missing_alumni integer(8),
  FOREIGN KEY (user) REFERENCES freshmen(id)
);
CREATE INDEX packets_idx_user ON packets (user);
CREATE INDEX packet_given_idx ON packets (given);
CREATE INDEX packet_due_idx ON packets (due);
--
-- Table: queue
--
CREATE TABLE queue (
  id INTEGER PRIMARY KEY NOT NULL,
  user integer(16) NOT NULL,
  date_added datetime NOT NULL DEFAULT CURRENT_DATE,
  filled tinyint NOT NULL,
  timestamp timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user) REFERENCES users(id)
);
CREATE INDEX queue_idx_user ON queue (user);
--
-- Table: roster
--
CREATE TABLE roster (
  id INTEGER PRIMARY KEY NOT NULL,
  user integer(16) NOT NULL,
  date date NOT NULL DEFAULT CURRENT_DATE,
  room integer(4) NOT NULL,
  timestamp timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX roster_idx_user ON roster (user);
CREATE INDEX roster_date_idx ON roster (date);
--
-- Table: spring_evals
--
CREATE TABLE spring_evals (
  id INTEGER PRIMARY KEY NOT NULL,
  date datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  user integer(16) NOT NULL,
  comments varchar(10240),
  result enum NOT NULL,
  timestamp timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX spring_evals_idx_user ON spring_evals (user);
CREATE INDEX spring_evals_date_idx ON spring_evals (date);
CREATE INDEX spring_evals_result_idx ON spring_evals (result);
--
-- Table: winter_evals
--
CREATE TABLE winter_evals (
  id INTEGER PRIMARY KEY NOT NULL,
  user integer(16) NOT NULL,
  projects varchar(10240),
  comments varchar(10240),
  date date NOT NULL DEFAULT CURRENT_DATE,
  timestamp timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX winter_evals_idx_user ON winter_evals (user);
CREATE INDEX winter_evals_date_idx ON winter_evals (date);
--
-- Table: event_attendee
--
CREATE TABLE event_attendee (
  event integer(16) NOT NULL,
  attendee integer(16) NOT NULL,
  FOREIGN KEY (attendee) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (event) REFERENCES events(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX event_attendee_idx_attendee ON event_attendee (attendee);
CREATE INDEX event_attendee_idx_event ON event_attendee (event);
--
-- Table: freshmen_event_attendee
--
CREATE TABLE freshmen_event_attendee (
  event integer(16) NOT NULL,
  attendee integer(16) NOT NULL,
  FOREIGN KEY (attendee) REFERENCES freshmen(id),
  FOREIGN KEY (event) REFERENCES events(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX freshmen_event_attendee_idx_attendee ON freshmen_event_attendee (attendee);
CREATE INDEX freshmen_event_attendee_idx_event ON freshmen_event_attendee (event);
--
-- Table: freshmen_missing_signatures
--
CREATE TABLE freshmen_missing_signatures (
  packet integer(16) NOT NULL,
  freshmen_missing_signature integer(16) NOT NULL,
  FOREIGN KEY (freshmen_missing_signature) REFERENCES freshmen(id),
  FOREIGN KEY (packet) REFERENCES packets(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX freshmen_missing_signatures_idx_freshmen_missing_signature ON freshmen_missing_signatures (freshmen_missing_signature);
CREATE INDEX freshmen_missing_signatures_idx_packet ON freshmen_missing_signatures (packet);
--
-- Table: packet_missing_signatures
--
CREATE TABLE packet_missing_signatures (
  packet integer(16) NOT NULL,
  missing_signature integer(16) NOT NULL,
  FOREIGN KEY (missing_signature) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (packet) REFERENCES packets(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX packet_missing_signatures_idx_missing_signature ON packet_missing_signatures (missing_signature);
CREATE INDEX packet_missing_signatures_idx_packet ON packet_missing_signatures (packet);
COMMIT;
