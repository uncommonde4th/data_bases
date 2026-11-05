SELECT
gr.student_id,
s.last_name || ' ' || s.first_name AS student,
g.name AS group_name,
c.name AS course,
t.last_name AS teacher,
o.academic_year,
o.semester,
o.control_type,
gr.attempt_no,
gr.status,
gr.grade,
gr.grade_date
FROM grades AS gr
JOIN students AS s ON s.student_id = gr.student_id
JOIN study_groups AS g ON g.group_id = s.group_id
JOIN course_offerings AS o ON o.offering_id = gr.offering_id
JOIN courses AS c ON c.course_id = o.course_id
JOIN teachers AS t ON t.teacher_id = o.teacher_id
ORDER BY gr.grade_date, g.name, s.last_name, gr.attempt_no;

SELECT
s.student_id,
s.last_name,
s.first_name,
s.status AS student_status,
g.name AS group_name,
d.name AS department
FROM students AS s
JOIN study_groups AS g ON g.group_id = s.group_id
JOIN departments AS d ON d.department_id = g.department_id
LEFT JOIN grades AS gr ON gr.student_id = s.student_id
WHERE gr.student_id IS NULL
ORDER BY g.name, s.last_name;

SELECT
s.student_id,
s.last_name,
s.first_name,
g.name AS group_name,
c.name AS course,
f.attempt_no AS failed_attempt,
f.grade_date AS failed_date,
p.attempt_no AS passed_attempt,
p.grade_date AS passed_date,
p.grade AS final_grade
FROM grades AS f
JOIN grades AS p ON p.student_id = f.student_id
AND p.offering_id = f.offering_id
AND p.attempt_no > f.attempt_no
JOIN students AS s ON s.student_id = f.student_id
JOIN study_groups AS g ON g.group_id = s.group_id
JOIN course_offerings AS o ON o.offering_id = f.offering_id
JOIN courses AS c ON c.course_id = o.course_id
WHERE f.status = 'не сдано'
AND p.status = 'сдано'
ORDER BY s.last_name, c.name;