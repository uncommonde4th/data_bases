SELECT
s.student_id,
s.last_name,
s.first_name,
g.name AS group_name,
c.name AS course,
o.academic_year,
o.semester,
o.control_type
FROM students AS s
JOIN study_groups AS g ON g.group_id = s.group_id
JOIN course_offerings AS o ON o.group_id = s.group_id
JOIN courses AS c ON c.course_id = o.course_id
WHERE s.status = 'продолжает обучение'
AND NOT EXISTS (
SELECT 1
FROM grades AS gr
WHERE gr.student_id = s.student_id
AND gr.offering_id = o.offering_id
)
ORDER BY g.name, s.last_name, o.academic_year, o.semester;