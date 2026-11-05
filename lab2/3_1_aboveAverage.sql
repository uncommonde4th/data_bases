SELECT
s.student_id,
s.last_name,
s.first_name,
g.name AS group_name,
ROUND(AVG(gr.grade), 2) AS student_average,
ROUND((
SELECT AVG(gr2.grade)
FROM grades AS gr2
JOIN students AS s2 ON s2.student_id = gr2.student_id
WHERE s2.group_id = s.group_id
), 2) AS group_average
FROM students AS s
JOIN study_groups AS g ON g.group_id = s.group_id
JOIN grades AS gr ON gr.student_id = s.student_id
GROUP BY s.student_id, s.last_name, s.first_name, g.name, s.group_id
HAVING AVG(gr.grade) > (
SELECT AVG(gr2.grade)
FROM grades AS gr2
JOIN students AS s2 ON s2.student_id = gr2.student_id
WHERE s2.group_id = s.group_id
)
ORDER BY g.name, student_average DESC;