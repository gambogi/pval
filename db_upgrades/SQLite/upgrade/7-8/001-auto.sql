-- Convert schema 'db_upgrades/_source/deploy/7/001-auto.yml' to 'db_upgrades/_source/deploy/8/001-auto.yml':;

;
BEGIN;

;
CREATE TABLE control_panel (
  id INTEGER PRIMARY KEY NOT NULL,
  fall_form boolean,
  winter_form boolean,
  spring_form boolean
);

;

COMMIT;

