-- Convert schema 'db_upgrades/_source/deploy/10/001-auto.yml' to 'db_upgrades/_source/deploy/11/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE conditionals ADD COLUMN description varchar(10240) NOT NULL DEFAULT '';

;

COMMIT;

