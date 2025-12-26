SELECT s.full_name AS student_name,
       sub.title   AS subject_title
FROM students s
JOIN grades g      ON g.student_id = s.student_id
JOIN subjects sub  ON sub.subject_id = g.subject_id
WHERE sub.title = 'Математический анализ';


SELECT t.full_name AS teacher_name,
       sub.title   AS subject_title
FROM teachers t
JOIN teacher_subjects ts ON ts.teacher_id = t.teacher_id
JOIN subjects sub        ON sub.subject_id = ts.subject_id
WHERE t.full_name = 'Иванов Иван Иванович';


SELECT s.full_name AS student_name,
       ROUND(AVG(g.grade_value), 2) AS avg_grade
FROM students s
JOIN grades g ON g.student_id = s.student_id
GROUP BY s.full_name;


SELECT t.full_name AS teacher_name,
       ROUND(AVG(g.grade_value), 2) AS avg_grade
FROM teachers t
JOIN grades g ON g.teacher_id = t.teacher_id
GROUP BY t.teacher_id, t.full_name
ORDER BY avg_grade DESC;


SELECT t.full_name AS teacher_name,
       COUNT(DISTINCT g.subject_id) AS subject_count
FROM teachers t
JOIN grades g ON g.teacher_id = t.teacher_id
WHERE g.grade_date >= (CURRENT_DATE - INTERVAL '1 year')
GROUP BY t.teacher_id, t.full_name
HAVING COUNT(DISTINCT g.subject_id) > 3;


SELECT s.full_name AS student_name
FROM students s
JOIN grades g ON g.student_id = s.student_id
JOIN subjects sub ON sub.subject_id = g.subject_id
GROUP BY s.student_id, s.full_name
HAVING AVG(CASE WHEN sub.category = 'математический' THEN g.grade_value END) > 4
   AND AVG(CASE WHEN sub.category = 'гуманитарный' THEN g.grade_value END) < 3;


WITH twos AS (
    SELECT g.subject_id, COUNT(*) AS two_count
    FROM grades g
    WHERE g.grade_value = 2
      AND EXTRACT(YEAR FROM g.grade_date) = EXTRACT(YEAR FROM CURRENT_DATE)
      AND (
          (EXTRACT(MONTH FROM CURRENT_DATE) BETWEEN 1 AND 6
           AND EXTRACT(MONTH FROM g.grade_date) BETWEEN 1 AND 6)
       OR (EXTRACT(MONTH FROM CURRENT_DATE) BETWEEN 7 AND 12
           AND EXTRACT(MONTH FROM g.grade_date) BETWEEN 7 AND 12)
      )
    GROUP BY g.subject_id
),
max_twos AS (
    SELECT MAX(two_count) AS max_count FROM twos
)
SELECT sub.title AS subject_title,
       t.two_count
FROM twos t
JOIN max_twos m ON m.max_count = t.two_count
JOIN subjects sub ON sub.subject_id = t.subject_id;


SELECT DISTINCT s.full_name AS student_name,
                t.full_name AS teacher_name
FROM students s
JOIN grades g ON g.student_id = s.student_id
JOIN teachers t ON t.teacher_id = g.teacher_id
WHERE s.student_id IN (
    SELECT student_id
    FROM grades
    GROUP BY student_id
    HAVING MIN(grade_value) = 5
);


SELECT s.full_name AS student_name,
       EXTRACT(YEAR FROM g.grade_date) AS year,
       ROUND(AVG(g.grade_value), 2) AS avg_grade
FROM students s
JOIN grades g ON g.student_id = s.student_id
GROUP BY s.full_name, EXTRACT(YEAR FROM g.grade_date)
ORDER BY s.full_name, year;


WITH group_subject_avg AS (
    SELECT st.group_id,
           g.subject_id,
           AVG(g.grade_value) AS avg_grade
    FROM grades g
    JOIN students st ON st.student_id = g.student_id
    GROUP BY st.group_id, g.subject_id
),
max_by_subject AS (
    SELECT subject_id,
           MAX(avg_grade) AS max_avg
    FROM group_subject_avg
    GROUP BY subject_id
)
SELECT subj.title AS subject_title,
       gr.group_name,
       ROUND(gsa.avg_grade, 2) AS avg_grade
FROM group_subject_avg gsa
JOIN max_by_subject m ON m.subject_id = gsa.subject_id
                     AND m.max_avg = gsa.avg_grade
JOIN groups gr   ON gr.group_id = gsa.group_id
JOIN subjects subj ON subj.subject_id = gsa.subject_id
ORDER BY subj.title, gr.group_name;


INSERT INTO students (full_name, birth_date, email, phone, group_id)
VALUES ('Петров Петр Петрович', '2005-03-12', 'p.petrov@example.com', '+7-900-123-45-67', 1);


UPDATE teachers
SET email = 'new.email@example.com',
    phone = '+7-900-000-00-00'
WHERE teacher_id = 1;


DELETE FROM subjects
WHERE title = 'История России';


INSERT INTO grades (student_id, subject_id, teacher_id, grade_value, grade_date, comment)
VALUES (1, 2, 1, 5, '2025-12-20', 'Экзамен');
