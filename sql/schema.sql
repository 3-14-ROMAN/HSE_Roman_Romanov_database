CREATE TABLE groups (
    group_id        SERIAL PRIMARY KEY,
    group_name      TEXT NOT NULL UNIQUE,
    enrollment_year INTEGER,
    specialty       TEXT
);

CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    full_name  TEXT NOT NULL,
    birth_date DATE,
    email      TEXT NOT NULL UNIQUE,
    phone      TEXT,
    group_id   INTEGER NOT NULL,
    CONSTRAINT fk_students_group
        FOREIGN KEY (group_id) REFERENCES groups(group_id)
        ON DELETE RESTRICT
);

CREATE TABLE teachers (
    teacher_id SERIAL PRIMARY KEY,
    full_name  TEXT NOT NULL,
    birth_date DATE,
    email      TEXT NOT NULL UNIQUE,
    phone      TEXT,
    department TEXT
);

CREATE TABLE subjects (
    subject_id  SERIAL PRIMARY KEY,
    title       TEXT NOT NULL UNIQUE,
    category    TEXT,
    credits     INTEGER,
    description TEXT
);

CREATE TABLE teacher_subjects (
    teacher_id  INTEGER NOT NULL,
    subject_id  INTEGER NOT NULL,
    assign_year INTEGER,
    PRIMARY KEY (teacher_id, subject_id),
    CONSTRAINT fk_ts_teacher
        FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_ts_subject
        FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
        ON DELETE CASCADE
);

CREATE TABLE grades (
    grade_id    SERIAL PRIMARY KEY,
    student_id  INTEGER NOT NULL,
    subject_id  INTEGER NOT NULL,
    teacher_id  INTEGER NOT NULL,
    grade_value INTEGER NOT NULL CHECK (grade_value BETWEEN 1 AND 5),
    grade_date  DATE NOT NULL,
    comment     TEXT,
    CONSTRAINT fk_grades_student
        FOREIGN KEY (student_id) REFERENCES students(student_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_grades_subject
        FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_grades_teacher
        FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id)
        ON DELETE RESTRICT
);