-- 
-- Created by SQL::Translator::Producer::PostgreSQL
-- Created on Sat Sep 14 01:38:42 2013
-- 
;
--
-- Table: freshmen.
--
CREATE TABLE "freshmen" (
  "id" bigserial NOT NULL,
  "user" bigint,
  "name" character varying(1024) NOT NULL,
  "vote_date" date DEFAULT CURRENT_DATE NOT NULL,
  "comments" character varying(10240),
  "ten_week" date DEFAULT CURRENT_DATE NOT NULL,
  "passed_freshman_project" smallint DEFAULT 0 NOT NULL,
  "freshman_project_comments" character varying(10240),
  "result" character varying DEFAULT 'pending' NOT NULL,
  "timestamp" timestamp NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "freshmen_idx_user" on "freshmen" ("user");

;
--
-- Table: users.
--
CREATE TABLE "users" (
  "id" bigserial NOT NULL,
  "UUID" binary NOT NULL,
  "freshman" bigint,
  "timestamp" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "users_idx_freshman" on "users" ("freshman");

;
--
-- Table: conditionals.
--
CREATE TABLE "conditionals" (
  "id" bigserial NOT NULL,
  "user" bigint NOT NULL,
  "created" date NOT NULL,
  "status" character varying NOT NULL,
  "deadline" date NOT NULL,
  "timestamp" timestamp NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "conditionals_idx_user" on "conditionals" ("user");

;
--
-- Table: events.
--
CREATE TABLE "events" (
  "id" bigserial NOT NULL,
  "name" character varying(1024) NOT NULL,
  "date" timestamp,
  "presenter" bigint,
  "committee" binary NOT NULL,
  "type" character varying NOT NULL,
  "timestamp" timestamp NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "events_idx_presenter" on "events" ("presenter");

;
--
-- Table: major_projects.
--
CREATE TABLE "major_projects" (
  "id" bigserial NOT NULL,
  "name" character varying(1024) NOT NULL,
  "description" character varying(10240) NOT NULL,
  "submitter" bigint NOT NULL,
  "date" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
  "comments" character varying(10240),
  "committee" binary NOT NULL,
  "status" character varying NOT NULL,
  "timestamp" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "major_projects_idx_submitter" on "major_projects" ("submitter");

;
--
-- Table: packets.
--
CREATE TABLE "packets" (
  "id" bigserial NOT NULL,
  "user" bigint NOT NULL,
  "given" date DEFAULT CURRENT_DATE NOT NULL,
  "due" date DEFAULT CURRENT_DATE NOT NULL,
  "timestamp" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "packets_idx_user" on "packets" ("user");

;
--
-- Table: queue.
--
CREATE TABLE "queue" (
  "id" bigserial NOT NULL,
  "user" bigint NOT NULL,
  "date_added" timestamp DEFAULT CURRENT_DATE NOT NULL,
  "filled" smallint NOT NULL,
  "timestamp" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "queue_idx_user" on "queue" ("user");

;
--
-- Table: roster.
--
CREATE TABLE "roster" (
  "id" bigserial NOT NULL,
  "user" bigint NOT NULL,
  "date" date DEFAULT CURRENT_DATE NOT NULL,
  "room" smallint NOT NULL,
  "timestamp" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "roster_idx_user" on "roster" ("user");

;
--
-- Table: spring_evals.
--
CREATE TABLE "spring_evals" (
  "id" bigserial NOT NULL,
  "date" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
  "user" bigint NOT NULL,
  "comments" character varying(10240),
  "result" character varying NOT NULL,
  "timestamp" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "spring_evals_idx_user" on "spring_evals" ("user");

;
--
-- Table: winter_evals.
--
CREATE TABLE "winter_evals" (
  "id" bigserial NOT NULL,
  "user" bigint NOT NULL,
  "projects" character varying(10240),
  "comments" character varying(10240),
  "date" date DEFAULT CURRENT_DATE NOT NULL,
  "timestamp" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "winter_evals_idx_user" on "winter_evals" ("user");

;
--
-- Table: event_attendee.
--
CREATE TABLE "event_attendee" (
  "event" bigint NOT NULL,
  "attendee" bigint NOT NULL
);
CREATE INDEX "event_attendee_idx_attendee" on "event_attendee" ("attendee");
CREATE INDEX "event_attendee_idx_event" on "event_attendee" ("event");

;
--
-- Table: packet_missing_signatures.
--
CREATE TABLE "packet_missing_signatures" (
  "packet" bigint NOT NULL,
  "missing_signature" bigint NOT NULL
);
CREATE INDEX "packet_missing_signatures_idx_missing_signature" on "packet_missing_signatures" ("missing_signature");
CREATE INDEX "packet_missing_signatures_idx_packet" on "packet_missing_signatures" ("packet");

;
--
-- Foreign Key Definitions
--

;
ALTER TABLE "freshmen" ADD CONSTRAINT "freshmen_fk_user" FOREIGN KEY ("user")
  REFERENCES "users" ("id") DEFERRABLE;

;
ALTER TABLE "users" ADD CONSTRAINT "users_fk_freshman" FOREIGN KEY ("freshman")
  REFERENCES "freshmen" ("id") DEFERRABLE;

;
ALTER TABLE "conditionals" ADD CONSTRAINT "conditionals_fk_user" FOREIGN KEY ("user")
  REFERENCES "users" ("id") DEFERRABLE;

;
ALTER TABLE "events" ADD CONSTRAINT "events_fk_presenter" FOREIGN KEY ("presenter")
  REFERENCES "users" ("id") DEFERRABLE;

;
ALTER TABLE "major_projects" ADD CONSTRAINT "major_projects_fk_submitter" FOREIGN KEY ("submitter")
  REFERENCES "users" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "packets" ADD CONSTRAINT "packets_fk_user" FOREIGN KEY ("user")
  REFERENCES "freshmen" ("id") DEFERRABLE;

;
ALTER TABLE "queue" ADD CONSTRAINT "queue_fk_user" FOREIGN KEY ("user")
  REFERENCES "users" ("id") DEFERRABLE;

;
ALTER TABLE "roster" ADD CONSTRAINT "roster_fk_user" FOREIGN KEY ("user")
  REFERENCES "users" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "spring_evals" ADD CONSTRAINT "spring_evals_fk_user" FOREIGN KEY ("user")
  REFERENCES "users" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "winter_evals" ADD CONSTRAINT "winter_evals_fk_user" FOREIGN KEY ("user")
  REFERENCES "users" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "event_attendee" ADD CONSTRAINT "event_attendee_fk_attendee" FOREIGN KEY ("attendee")
  REFERENCES "users" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "event_attendee" ADD CONSTRAINT "event_attendee_fk_event" FOREIGN KEY ("event")
  REFERENCES "events" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "packet_missing_signatures" ADD CONSTRAINT "packet_missing_signatures_fk_missing_signature" FOREIGN KEY ("missing_signature")
  REFERENCES "users" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "packet_missing_signatures" ADD CONSTRAINT "packet_missing_signatures_fk_packet" FOREIGN KEY ("packet")
  REFERENCES "packets" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
