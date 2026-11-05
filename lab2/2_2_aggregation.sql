SELECT
c.course_id,
c.name AS course,
COUNT(gr.student_id) AS attempts_count,
COUNT(gr.grade) AS graded_count,
ROUND(AVG(gr.grade), 2) AS average_grade,
MIN(gr.grade) AS minimum_grade,
MAX(gr.grade) AS maximum_grade
FROM courses AS c
LEFT JOIN course_offerings AS o ON o.course_id = c.course_id
LEFT JOIN grades AS gr ON gr.offering_id = o.offering_id
GROUP BY c.course_id, c.name
ORDER BY average_grade DESC NULLS LAST, c.name;

SELECT
g.group_id,
g.name AS group_name,
COUNT(DISTINCT s.student_id) AS students_count,
COUNT(gr.grade) AS graded_count,
ROUND(AVG(gr.grade), 2) AS average_grade,
SUM(CASE WHEN gr.status = 'не сдано' THEN 1 ELSE 0 END) AS failed_count
FROM study_groups AS g
JOIN students AS s ON s.group_id = g.group_id
JOIN grades AS gr ON gr.student_id = s.student_id
WHERE gr.status IN ('сдано', 'не сдано')
GROUP BY g.group_id, g.name
HAVING AVG(gr.grade) >= 3.75
AND COUNT(gr.grade) >= 10
ORDER BY average_grade DESC;

SELECT
DATE_TRUNC('month', gr.grade_date)::DATE AS month,
COUNT(*) AS attempts_count,
SUM(CASE WHEN gr.status = 'сдано' THEN 1 ELSE 0 END) AS passed_count,
SUM(CASE WHEN gr.status = 'не сдано' THEN 1 ELSE 0 END) AS failed_count,
SUM(CASE WHEN gr.status = 'не явился' THEN 1 ELSE 0 END) AS no_show_count,
ROUND(AVG(gr.grade), 2) AS average_grade,
MIN(gr.grade) AS minimum_grade,
MAX(gr.grade) AS maximum_grade
FROM grades AS gr
WHERE gr.status <> 'назначена'
GROUP BY DATE_TRUNC('month', gr.grade_date)::DATE
ORDER BY month;