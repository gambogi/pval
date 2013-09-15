-- Convert schema 'db_upgrades/_source/deploy/6/001-auto.yml' to 'db_upgrades/_source/deploy/7/001-auto.yml':;

;
BEGIN;

;
CREATE TABLE freshmen_missing_signatures (
  packet integer(16) NOT NULL,
  freshmen_missing_signature integer(16) NOT NULL,
  FOREIGN KEY (freshmen_missing_signature) REFERENCES freshmen(id),
  FOREIGN KEY (packet) REFERENCES packets(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX freshmen_missing_signatures_idx_freshmen_missing_signature ON freshmen_missing_signatures (freshmen_missing_signature);

;
CREATE INDEX freshmen_missing_signatures_idx_packet ON freshmen_missing_signatures (packet);

;
ALTER TABLE packets ADD COLUMN missing_alumni integer(8);

;
CREATE INDEX packet_given_idx ON packets (given);

;
CREATE INDEX packet_due_idx ON packets (due);

;

COMMIT;

