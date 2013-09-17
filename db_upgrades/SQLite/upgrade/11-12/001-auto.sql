-- Convert schema 'db_upgrades/_source/deploy/11/001-auto.yml' to 'db_upgrades/_source/deploy/12/001-auto.yml':;

;
BEGIN;

;
CREATE INDEX conditional_created_idx ON conditionals (created);

;
CREATE INDEX conditional_deadline_idx ON conditionals (deadline);

;
CREATE INDEX conditional_status_idx ON conditionals (status);

;
CREATE INDEX event_date_idx ON events (date);

;
CREATE INDEX event_committee_idx ON events (committee);

;
CREATE INDEX event_type_idx ON events (type);

;
CREATE INDEX major_projects_date_idx ON major_projects (date);

;
CREATE INDEX roster_date_idx ON roster (date);

;

COMMIT;

