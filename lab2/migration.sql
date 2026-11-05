BEGIN;

ALTER TABLE grades
ADD COLUMN status VARCHAR(20);

UPDATE grades
SET status = CASE
WHEN grade = 2 THEN 'не сдано'
ELSE 'сдано'
END
WHERE status IS NULL;

ALTER TABLE grades
ALTER COLUMN status SET DEFAULT 'назначена';

ALTER TABLE grades
ALTER COLUMN status SET NOT NULL;

ALTER TABLE grades
ALTER COLUMN grade DROP NOT NULL;

ALTER TABLE grades
ADD CONSTRAINT ck_grade_status
CHECK (status IN ('назначена', 'сдано', 'не сдано', 'не явился'));

ALTER TABLE grades
ADD CONSTRAINT ck_grade_status_value
CHECK (
(status IN ('назначена', 'не явился') AND grade IS NULL)
OR (status = 'сдано' AND grade IN (3, 4, 5))
OR (status = 'не сдано' AND grade = 2)
);

CREATE INDEX idx_grades_status ON grades(status);

COMMIT;