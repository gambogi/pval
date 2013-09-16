-- Convert schema 'db_upgrades/_source/deploy/8/001-auto.yml' to 'db_upgrades/_source/deploy/9/001-auto.yml':;

;
BEGIN;

;
CREATE TABLE freshmen_event_attendee (
  event integer(16) NOT NULL,
  attendee integer(16) NOT NULL,
  FOREIGN KEY (attendee) REFERENCES freshmen(id),
  FOREIGN KEY (event) REFERENCES events(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX freshmen_event_attendee_idx_attendee ON freshmen_event_attendee (attendee);

;
CREATE INDEX freshmen_event_attendee_idx_event ON freshmen_event_attendee (event);

;

COMMIT;

