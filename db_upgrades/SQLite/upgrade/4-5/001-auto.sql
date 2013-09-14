-- Convert schema 'db_upgrades/_source/deploy/4/001-auto.yml' to 'db_upgrades/_source/deploy/5/001-auto.yml':;

;
BEGIN;

;
CREATE INDEX freshmen_name_idx ON freshmen (name);

;
CREATE INDEX freshmen_vote_date_idx ON freshmen (vote_date);

;
CREATE INDEX freshmen_ten_week_idx ON freshmen (ten_week);

;
CREATE INDEX freshmen_result_idx ON freshmen (result);

;
CREATE INDEX major_projects_status_idx ON major_projects (status);

;
CREATE INDEX major_projects_committee_idx ON major_projects (committee);

;
CREATE INDEX spring_evals_date_idx ON spring_evals (date);

;
CREATE INDEX spring_evals_result_idx ON spring_evals (result);

;
CREATE INDEX user_uuid_idx ON users (UUID);

;
CREATE INDEX winter_evals_date_idx ON winter_evals (date);

;

COMMIT;

