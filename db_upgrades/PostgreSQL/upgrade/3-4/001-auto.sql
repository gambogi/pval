-- Convert schema 'db_upgrades/_source/deploy/3/001-auto.yml' to 'db_upgrades/_source/deploy/4/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE events ALTER COLUMN committee TYPE character varying(37);

;
ALTER TABLE major_projects ALTER COLUMN committee TYPE character varying(37);

;
ALTER TABLE users ALTER COLUMN UUID TYPE character varying(37);

;

COMMIT;

