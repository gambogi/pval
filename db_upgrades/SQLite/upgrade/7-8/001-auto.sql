-- Convert schema 'db_upgrades/_source/deploy/7/001-auto.yml' to 'db_upgrades/_source/deploy/8/001-auto.yml':;

;
BEGIN;

;
CREATE TABLE control_panel (
  id INTEGER PRIMARY KEY NOT NULL,
  fall_form boolean NOT NULL,
  winter_form boolean NOT NULL,
  spring_form boolean NOT NULL
);

;

COMMIT;

