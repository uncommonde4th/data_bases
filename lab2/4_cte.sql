WITH offering_results AS (
SELECT
gr.student_id,
gr.offering_id,
COUNT(*) AS attempts_count,
MAX(CASE WHEN gr.status = 'сдано' THEN 1 ELSE 0 END) AS is_passed,
MAX(gr.grade) AS best_grade
FROM grades AS gr
WHERE gr.status <> 'назначена'
GROUP BY gr.student_id, gr.offering_id
),

student_results AS (
SELECT
s.student_id,
s.group_id,
COUNT(r.offering_id) AS disciplines_count,
COALESCE(SUM(1 - r.is_passed), 0) AS debts_count,
COALESCE(SUM(r.attempts_count), 0) AS attempts_count,
AVG(r.best_grade) AS average_best_grade
FROM students AS s
LEFT JOIN offering_results AS r ON r.student_id = s.student_id
GROUP BY s.student_id, s.group_id
),

department_statistics AS (
SELECT
g.department_id,
COUNT(*) AS students_count,
SUM(CASE WHEN sr.debts_count > 0 THEN 1 ELSE 0 END) AS students_with_debts,
SUM(sr.disciplines_count) AS disciplines_count,
SUM(sr.debts_count) AS debts_count,
SUM(sr.attempts_count) AS attempts_count,
ROUND(AVG(sr.average_best_grade), 2) AS average_grade
FROM student_results AS sr
JOIN study_groups AS g ON g.group_id = sr.group_id
GROUP BY g.department_id
)

SELECT
f.short_name AS "Институт",
d.name AS "Кафедра",
ds.students_count AS "Студентов",
ds.students_with_debts AS "Из них с долгами",
ROUND(100.0 * ds.students_with_debts / ds.students_count, 1) AS "Доля студентов с долгами, %",
ds.debts_count AS "Долгов всего",
ROUND(100.0 * ds.debts_count / NULLIF(ds.disciplines_count, 0), 1) AS "Доля несданных дисциплин, %",
ROUND(1.0 * ds.attempts_count / NULLIF(ds.disciplines_count, 0), 2) AS "Попыток на дисциплину",
ds.average_grade AS "Средний балл"
FROM department_statistics AS ds
JOIN departments AS d ON d.department_id = ds.department_id
JOIN faculties AS f ON f.faculty_id = d.faculty_id
ORDER BY "Доля несданных дисциплин, %" DESC NULLS LAST;