DROP TABLE IF EXISTS grades CASCADE;
DROP TABLE IF EXISTS course_offerings CASCADE;
DROP TABLE IF EXISTS courses CASCADE;
DROP TABLE IF EXISTS students CASCADE;
DROP TABLE IF EXISTS study_groups CASCADE;
DROP TABLE IF EXISTS teachers CASCADE;
DROP TABLE IF EXISTS departments CASCADE;
DROP TABLE IF EXISTS faculties CASCADE;


CREATE TABLE faculties (
    faculty_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(150) NOT NULL UNIQUE,
    short_name VARCHAR(20) UNIQUE
);

CREATE TABLE departments (
    department_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    faculty_id  INTEGER NOT NULL REFERENCES faculties(faculty_id) ON DELETE RESTRICT,
    name VARCHAR(150) NOT NULL,
    CONSTRAINT uq_department_faculty_name UNIQUE (faculty_id, name)
);

CREATE TABLE teachers (
    teacher_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    department_id INTEGER NOT NULL REFERENCES departments(department_id) ON DELETE RESTRICT,
    last_name VARCHAR(60) NOT NULL,
    first_name VARCHAR(60) NOT NULL,
    middle_name VARCHAR(60),
    email VARCHAR(120) NOT NULL UNIQUE,
    academic_position VARCHAR(30) NOT NULL,
    hire_data DATE NOT NULL,
    CONSTRAINT ck_teacher_position CHECK(academic_position IN ('ассистент', 'преподаватель', 'старший преподаватель', 'доцент', 'профессор', 'заведующий кафедрой')),
    CONSTRAINT ck_teacher_hire_data CHECK(hire_data >= DATE '1930-03-20'),
    CONSTRAINT ck_teacher_email CHECK (email LIKE '%_@_%.__%')
);

CREATE TABLE study_groups (
    group_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    department_id INTEGER NOT NULL REFERENCES departments(department_id) ON DELETE RESTRICT,
    name VARCHAR(20) NOT NULL UNIQUE,
    admission_year SMALLINT NOT NULL,
    study_form VARCHAR(20) NOT NULL DEFAULT 'очная',
    CONSTRAINT ck_group_year CHECK (admission_year BETWEEN 2000 AND 2100),
    CONSTRAINT ck_group_form CHECK (study_form IN ('очная', 'очно-заочная', 'заочная', 'заочная', 'дистанционная'))
);

CREATE TABLE students (
    student_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    group_id INTEGER NOT NULL REFERENCES study_groups(group_id) ON DELETE RESTRICT,
    last_name VARCHAR(60) NOT NULL,
    first_name VARCHAR(60) NOT NULL,
    middle_name VARCHAR(60),
    birth_date DATE NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    record_book_no VARCHAR(15) NOT NULL UNIQUE,
    enrollment_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'продолжает обучение',
    CONSTRAINT ck_student_status CHECK (status IN ('продолжает обучение', 'академический отпуск', 'отчислен', 'окончил обучение')),
    CONSTRAINT ck_student_email CHECK (email LIKE '%_@_%.__%')
);


CREATE TABLE courses (
    course_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    department_id INTEGER NOT NULL REFERENCES departments(department_id) ON DELETE RESTRICT,
    name VARCHAR(150) NOT NULL,
    lecture_hours SMALLINT NOT NULL DEFAULT 0,
    practice_hours SMALLINT NOT NULL DEFAULT 0,
    CONSTRAINT uq_course_department_name UNIQUE (department_id, name),
    CONSTRAINT ck_course_hours_nonneg CHECK (lecture_hours >= 0 AND practice_hours >= 0),
    CONSTRAINT ck_course_hours_total CHECK (lecture_hours + practice_hours > 0)
);

CREATE TABLE course_offerings (
    offering_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    course_id INTEGER NOT NULL REFERENCES courses(course_id) ON DELETE RESTRICT,
    group_id INTEGER NOT NULL REFERENCES study_groups(group_id) ON DELETE RESTRICT,
    teacher_id INTEGER NOT NULL REFERENCES teachers(teacher_id) ON DELETE RESTRICT,
    academic_year SMALLINT NOT NULL,
    semester SMALLINT NOT NULL,
    control_type VARCHAR(25) NOT NULL,
    CONSTRAINT ck_offering_year CHECK (academic_year BETWEEN 2000 AND 2100),
    CONSTRAINT ck_offering_semester CHECK (semester IN (1, 2)),
    CONSTRAINT ck_offering_control CHECK (control_type IN ('экзамен', 'зачет', 'зачет с оценкой')),
    CONSTRAINT uq_offering UNIQUE (course_id, group_id, academic_year, semester)
);

CREATE TABLE grades (
    student_id INTEGER NOT NULL REFERENCES students(student_id) ON DELETE CASCADE,
    offering_id INTEGER NOT NULL REFERENCES course_offerings(offering_id) ON DELETE RESTRICT,
    attempt_no SMALLINT NOT NULL DEFAULT 1,
    grade SMALLINT NOT NULL,
    grade_date DATE NOT NULL,
    PRIMARY KEY (student_id, offering_id, attempt_no),
    CONSTRAINT ck_grade_value CHECK (grade IN (2, 3, 4, 5)),
    CONSTRAINT ck_grade_attempt CHECK (attempt_no BETWEEN 1 AND 3)
);

CREATE INDEX idx_departments_faculty ON departments(faculty_id);
CREATE INDEX idx_teachers_department ON teachers(department_id);
CREATE INDEX idx_groups_department ON study_groups(department_id);
CREATE INDEX idx_students_group ON students(group_id);
CREATE INDEX idx_courses_department ON courses(department_id);
CREATE INDEX idx_offerings_group ON course_offerings(group_id);
CREATE INDEX idx_offerings_teacher ON course_offerings(teacher_id);
CREATE INDEX idx_grades_offering ON grades(offering_id);
