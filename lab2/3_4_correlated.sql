SELECT
s.student_id,
s.last_name,
s.first_name,
s.status,
(
SELECT COUNT(*)
FROM grades AS gr
WHERE gr.student_id = s.student_id
AND gr.status = 'не сдано'
) AS failed_attempts,
(
SELECT COUNT(*)
FROM grades AS gr
WHERE gr.student_id = s.student_id
AND gr.status = 'не явился'
) AS no_shows,
(
SELECT ROUND(AVG(gr.grade), 2)
FROM grades AS gr
WHERE gr.student_id = s.student_id
) AS average_grade,
(
SELECT MAX(gr.grade_date)
FROM grades AS gr
WHERE gr.student_id = s.student_id
AND gr.status <> 'назначена'
) AS last_attempt_date
FROM students AS s
ORDER BY failed_attempts DESC, no_shows DESC, s.student_id;