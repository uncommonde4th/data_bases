INSERT INTO students (group_id, last_name, first_name, birth_date, email, record_book_no, enrollment_date) VALUES 
(1, 'Тестов', 'Тест', '2006-01-01', 'alekseev@mai.ru', 'ПИ24-900', '2024-09-01');

INSERT INTO students (group_id, last_name, first_name, birth_date, email, record_book_no, enrollment_date) VALUES
(1, 'Тестов', 'Тест', '2006-01-01', 'new@mai.ru', 'ПИ24-001', '2024-09-01');

INSERT INTO grades (student_id, offering_id, attempt_no, grade, grade_date) VALUES (2, 4, 1, 6, '2026-01-20');

UPDATE course_offerings SET semester = 3 WHERE offering_id = 1;
UPDATE students SET status = 'на каникулах' WHERE student_id = 1;

INSERT INTO courses (department_id, name, lecture_hours, practice_hours) VALUES (1, 'Пустая дисциплина', 0, 0);

INSERT INTO course_offerings (course_id, group_id, teacher_id, academic_year, semester, control_type) VALUES (1, 1, 2, 2025, 1, 'экзамен');

INSERT INTO grades (student_id, offering_id, attempt_no, grade, grade_date) VALUES (1, 1, 1, 3, '2026-02-01');
INSERT INTO students (group_id, last_name, first_name, birth_date, email, record_book_no, enrollment_date) VALUES 
(1, NULL, 'Имя', '2006-01-01', 'nolast@mai.ru', 'ПИ24-902', '2024-09-01');
INSERT INTO students (group_id, last_name, first_name, birth_date, email, record_book_no, enrollment_date) VALUES 
(999, 'Фантом', 'Иван', '2006-01-01', 'ghost@mai.ru', 'ПИ24-903', '2024-09-01');

DELETE FROM faculties WHERE faculty_id = 1;
DELETE FROM teachers WHERE teacher_id = 1;

UPDATE teachers SET email = 'not-an-email' WHERE teacher_id = 1;
UPDATE study_groups SET study_form = 'вечерняя' WHERE group_id = 1;
UPDATE teachers SET hire_data = '1900-01-01' WHERE teacher_id = 1;
UPDATE teachers SET academic_position = 'академик' WHERE teacher_id = 2;

BEGIN;
SELECT count(*) AS grades_before FROM grades WHERE student_id = 3;
DELETE FROM students WHERE student_id = 3;
SELECT count(*) AS grades_after FROM grades WHERE student_id = 3;
ROLLBACK;