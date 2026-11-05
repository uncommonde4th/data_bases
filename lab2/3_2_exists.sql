SELECT
t.teacher_id,
t.last_name,
t.first_name,
t.academic_position,
t.email
FROM teachers AS t
WHERE EXISTS (
SELECT 1
FROM course_offerings AS o
JOIN grades AS gr ON gr.offering_id = o.offering_id
WHERE o.teacher_id = t.teacher_id
AND gr.status = 'не сдано'
)
ORDER BY t.last_name;