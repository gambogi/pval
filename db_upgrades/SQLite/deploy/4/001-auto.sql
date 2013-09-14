-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Sat Sep 14 03:00:59 2013
-- 

;
BEGIN TRANSACTION;
--
-- Table: freshmen
--
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
CREATE INDEX freshmen_idx_user ON freshmen (user);
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
--
-- Table: conditionals
--
CREATE TABLE conditionals (
  id INTEGER PRIMARY KEY NOT NULL,
  user integer(16) NOT NULL,
  created date NOT NULL,
  status enum NOT NULL,
  deadline date NOT NULL,
  timestamp timestamp NOT NULL,
  FOREIGN KEY (user) REFERENCES users(id)
);
CREATE INDEX conditionals_idx_user ON conditionals (user);
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
--
-- Table: packets
--
CREATE TABLE packets (
  id INTEGER PRIMARY KEY NOT NULL,
  user integer(16) NOT NULL,
  given date NOT NULL DEFAULT CURRENT_DATE,
  due date NOT NULL DEFAULT CURRENT_DATE,
  timestamp timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user) REFERENCES freshmen(id)
);
CREATE INDEX packets_idx_user ON packets (user);
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
