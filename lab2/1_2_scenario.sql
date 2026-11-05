BEGIN;

INSERT INTO study_groups (department_id, name, admission_year, study_form)
VALUES (
(SELECT department_id FROM departments WHERE name = 'Информатика и вычислительная техника'),
'М3О-311БВ-25',
2025,
'очная'
)
RETURNING group_id, name, admission_year;

INSERT INTO students (group_id, last_name, first_name, middle_name, birth_date, email, record_book_no, enrollment_date, status)
VALUES (
(SELECT group_id FROM study_groups WHERE name = 'М3О-311БВ-25'),
'Ковалёв',
'Руслан',
'Антонович',
'2007-02-14',
'kovalev@mai.ru',
'ПИ25-001',
'2025-09-01',
'продолжает обучение'
)
RETURNING student_id, last_name, first_name, email;

INSERT INTO courses (department_id, name, lecture_hours, practice_hours)
VALUES (
(SELECT department_id FROM departments WHERE name = 'Программная инженерия'),
'Машинное обучение',
32,
32
)
RETURNING course_id, name;

INSERT INTO course_offerings (course_id, group_id, teacher_id, academic_year, semester, control_type)
VALUES (
(SELECT course_id FROM courses WHERE name = 'Машинное обучение'),
(SELECT group_id FROM study_groups WHERE name = 'М3О-311БВ-25'),
(SELECT teacher_id FROM teachers WHERE email = 'morozov@mai.ru'),
2026,
1,
'экзамен'
)
RETURNING offering_id, academic_year, semester, control_type;

INSERT INTO grades (student_id, offering_id, attempt_no, grade, grade_date, status)
VALUES (
(SELECT student_id FROM students WHERE email = 'kovalev@mai.ru'),
(SELECT offering_id FROM course_offerings WHERE course_id = (SELECT course_id FROM courses WHERE name = 'Машинное обучение')),
1,
NULL,
'2026-12-28',
'назначена'
)
RETURNING student_id, offering_id, attempt_no, grade, status;

UPDATE grades
SET status = 'сдано',
grade = 3
WHERE student_id = (SELECT student_id FROM students WHERE email = 'nikitina@mai.ru')
AND offering_id = (
SELECT o.offering_id
FROM course_offerings AS o
JOIN courses AS c ON c.course_id = o.course_id
JOIN study_groups AS g ON g.group_id = o.group_id
WHERE c.name = 'Базы данных'
AND g.name = 'М3О-412БВ-23'
AND o.academic_year = 2025
AND o.semester = 2
)
AND attempt_no = 2
AND status = 'назначена'
RETURNING student_id, offering_id, attempt_no, grade, grade_date, status;

UPDATE grades
SET status = 'не явился'
WHERE status = 'назначена'
AND grade_date < '2026-11-01'
RETURNING student_id, offering_id, attempt_no, grade_date, status;

DELETE FROM students
WHERE email = 'romanov@mai.ru'
RETURNING student_id, last_name, first_name, status;

COMMIT;

BEGIN;

DELETE FROM grades
WHERE status = 'не сдано'
RETURNING student_id, offering_id, attempt_no, grade_date;

SELECT COUNT(*) AS failed_attempts_inside_transaction
FROM grades
WHERE status = 'не сдано';

ROLLBACK;

SELECT COUNT(*) AS failed_attempts_after_rollback
FROM grades
WHERE status = 'не сдано';