CREATE DATABASE IF NOT EXISTS university_exercise
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE university_exercise;

CREATE TABLE Students (
    student_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(254) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    major VARCHAR(100) NOT NULL,
    enrollment_year SMALLINT UNSIGNED NOT NULL
) ENGINE=InnoDB;

CREATE TABLE Courses (
    course_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    course_code VARCHAR(20) NOT NULL,
    credits TINYINT UNSIGNED NOT NULL,
    department VARCHAR(100) NOT NULL,
    CONSTRAINT chk_course_credits CHECK (credits BETWEEN 1 AND 6)
) ENGINE=InnoDB;

CREATE TABLE Instructors (
    instructor_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(254) NOT NULL UNIQUE,
    hire_date DATE NOT NULL,
    department VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE CourseAssignments (
    assignment_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    instructor_id INT UNSIGNED NOT NULL,
    course_id INT UNSIGNED NOT NULL,
    semester ENUM('Spring', 'Summer', 'Fall') NOT NULL,
    year SMALLINT UNSIGNED NOT NULL,
    capacity SMALLINT UNSIGNED NOT NULL DEFAULT 30,
    CONSTRAINT chk_capacity CHECK (capacity > 0),
    CONSTRAINT uq_course_term UNIQUE (course_id, semester, year),
    CONSTRAINT uq_assignment_course UNIQUE (assignment_id, course_id),
    CONSTRAINT fk_assignment_instructor
        FOREIGN KEY (instructor_id)
        REFERENCES Instructors(instructor_id),
    CONSTRAINT fk_assignment_course
        FOREIGN KEY (course_id)
        REFERENCES Courses(course_id)
) ENGINE=InnoDB;

CREATE TABLE Enrollments (
    enrollment_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    student_id INT UNSIGNED NOT NULL,
    course_id INT UNSIGNED NOT NULL,
    assignment_id INT UNSIGNED NOT NULL,
    grade ENUM('A', 'B', 'C', 'D', 'F', 'I') NULL DEFAULT NULL,
    CONSTRAINT uq_student_offering UNIQUE (student_id, assignment_id),
    CONSTRAINT fk_enrollment_student
        FOREIGN KEY (student_id)
        REFERENCES Students(student_id),
    CONSTRAINT fk_enrollment_offering
        FOREIGN KEY (assignment_id, course_id)
        REFERENCES CourseAssignments(assignment_id, course_id)
) ENGINE=InnoDB;

SET @current_year = YEAR(CURDATE());

SET @current_semester = CASE
    WHEN MONTH(CURDATE()) BETWEEN 1 AND 5 THEN 'Spring'
    WHEN MONTH(CURDATE()) BETWEEN 6 AND 8 THEN 'Summer'
    ELSE 'Fall'
END;

INSERT INTO Students (
    student_id,
    first_name,
    last_name,
    email,
    date_of_birth,
    gender,
    major,
    enrollment_year
)
VALUES
(1, 'Ahmad', 'Alhwari', 'ahmad@example.com', '2001-04-15', 'Male', 'Computer Science', 2023),
(2, 'Sara', 'Ali', 'sara@example.com', '2003-02-10', 'Female', 'Computer Science', 2023),
(3, 'Omar', 'Khaled', 'omar@example.com', '2002-08-22', 'Male', 'Mathematics', 2022),
(4, 'Lina', 'Hassan', 'lina@example.com', '2004-01-05', 'Female', 'English', 2024),
(5, 'Yousef', 'Saleh', 'yousef@example.com', '2001-11-14', 'Male', 'Business', 2022),
(6, 'Noor', 'Ahmad', 'noor@example.com', '2003-06-18', 'Female', 'Computer Science', 2023),
(7, 'Khaled', 'Sami', 'khaled@example.com', '2002-09-30', 'Male', 'Mathematics', 2022),
(8, 'Hana', 'Nasser', 'hana@example.com', '2004-03-12', 'Female', 'English', 2024),
(9, 'Zaid', 'Mahmoud', 'zaid@example.com', '2003-12-01', 'Male', 'Business', 2023),
(10, 'Rana', 'Adel', 'rana@example.com', '2004-07-20', 'Female', 'Computer Science', 2024);

INSERT INTO Instructors (
    instructor_id,
    first_name,
    last_name,
    email,
    hire_date,
    department
)
VALUES
(1, 'Rami', 'Hamdan', 'rami@example.com', '2015-09-01', 'Computer Science'),
(2, 'Dina', 'Mansour', 'dina@example.com', '2018-02-01', 'Computer Science'),
(3, 'Samer', 'Odeh', 'samer@example.com', '2012-09-01', 'Mathematics'),
(4, 'Maya', 'Salem', 'maya@example.com', '2017-09-01', 'English'),
(5, 'Fadi', 'Kareem', 'fadi@example.com', '2019-02-01', 'Business');

INSERT INTO Courses (
    course_id,
    course_name,
    course_code,
    credits,
    department
)
VALUES
(1, 'Introduction to Programming', 'CS101', 3, 'Computer Science'),
(2, 'Database Systems', 'CS201', 3, 'Computer Science'),
(3, 'Calculus I', 'MATH101', 4, 'Mathematics'),
(4, 'Academic English', 'ENG101', 2, 'English'),
(5, 'Introduction to Business', 'BUS101', 3, 'Business'),
(6, 'Computer Networks', 'CS301', 3, 'Computer Science');

INSERT INTO CourseAssignments (
    assignment_id,
    instructor_id,
    course_id,
    semester,
    year,
    capacity
)
VALUES
(1, 1, 1, @current_semester, @current_year, 30),
(2, 2, 2, @current_semester, @current_year, 30),
(3, 3, 3, @current_semester, @current_year, 30),
(4, 4, 4, @current_semester, @current_year, 30),
(5, 5, 5, @current_semester, @current_year, 30),
(6, 1, 6, @current_semester, @current_year, 1);

INSERT INTO Enrollments (
    student_id,
    course_id,
    assignment_id,
    grade
)
VALUES
(1, 1, 1, 'A'),
(1, 2, 2, 'A'),
(1, 3, 3, 'B'),
(1, 4, 4, 'A'),
(2, 1, 1, 'A'),
(2, 2, 2, 'B'),
(3, 1, 1, 'B'),
(3, 3, 3, 'A'),
(4, 4, 4, 'A'),
(4, 5, 5, 'B'),
(5, 2, 2, 'C'),
(5, 5, 5, 'B'),
(6, 1, 1, 'I'),
(6, 2, 2, 'A'),
(7, 3, 3, 'C'),
(7, 5, 5, 'D'),
(8, 2, 2, NULL),
(8, 4, 4, 'B'),
(9, 3, 3, 'F'),
(9, 5, 5, 'C'),
(10, 1, 1, 'A'),
(10, 2, 2, 'A');

CREATE VIEW EnrollmentGradePoints AS
SELECT
    e.*,
    CASE e.grade
        WHEN 'A' THEN 4.0
        WHEN 'B' THEN 3.0
        WHEN 'C' THEN 2.0
        WHEN 'D' THEN 1.0
        WHEN 'F' THEN 0.0
        ELSE NULL
    END AS grade_points
FROM Enrollments e;

SELECT *
FROM Students
ORDER BY student_id;

SELECT COUNT(*) AS total_courses
FROM Courses;

SET @course_code = 'CS101';

SELECT DISTINCT
    s.student_id,
    s.first_name,
    s.last_name
FROM Students s
JOIN Enrollments e ON e.student_id = s.student_id
JOIN Courses c ON c.course_id = e.course_id
WHERE c.course_code = @course_code
ORDER BY s.student_id;

SET @department = 'Computer Science';

SELECT first_name, last_name, email
FROM Instructors
WHERE department = @department;

SELECT
    c.course_id,
    c.course_name,
    COUNT(DISTINCT e.student_id) AS student_count
FROM Courses c
LEFT JOIN Enrollments e ON e.course_id = c.course_id
GROUP BY c.course_id, c.course_name
ORDER BY c.course_id;

SELECT DISTINCT
    s.student_id,
    s.first_name,
    s.last_name
FROM Students s
JOIN Enrollments e ON e.student_id = s.student_id
WHERE e.grade = 'A'
ORDER BY s.student_id;

SET @semester = @current_semester;
SET @year = @current_year;

SELECT
    c.course_code,
    c.course_name,
    CONCAT(i.first_name, ' ', i.last_name) AS instructor,
    a.semester,
    a.year
FROM CourseAssignments a
JOIN Courses c ON c.course_id = a.course_id
JOIN Instructors i ON i.instructor_id = a.instructor_id
WHERE a.semester = @semester
  AND a.year = @year
ORDER BY c.course_code;

SELECT
    c.course_code,
    ROUND(AVG(g.grade_points), 2) AS average_grade_points,
    COUNT(g.grade_points) AS graded_enrollments
FROM Courses c
LEFT JOIN EnrollmentGradePoints g ON g.course_id = c.course_id
WHERE c.course_code = @course_code
GROUP BY c.course_id, c.course_code;

SELECT
    s.student_id,
    s.first_name,
    s.last_name,
    COUNT(DISTINCT e.course_id) AS courses
FROM Students s
JOIN Enrollments e ON e.student_id = s.student_id
JOIN CourseAssignments a ON a.assignment_id = e.assignment_id
WHERE a.semester = @current_semester
  AND a.year = @current_year
GROUP BY s.student_id, s.first_name, s.last_name
HAVING COUNT(DISTINCT e.course_id) > 3;

SELECT
    s.student_id,
    CONCAT(s.first_name, ' ', s.last_name) AS student,
    c.course_name,
    a.semester,
    a.year,
    COALESCE(e.grade, 'Not graded') AS grade
FROM Students s
JOIN Enrollments e ON e.student_id = s.student_id
JOIN Courses c ON c.course_id = e.course_id
JOIN CourseAssignments a ON a.assignment_id = e.assignment_id
WHERE e.grade = 'I'
   OR e.grade IS NULL;

WITH averages AS (
    SELECT
        student_id,
        AVG(grade_points) AS average_points
    FROM EnrollmentGradePoints
    GROUP BY student_id
    HAVING COUNT(grade_points) > 0
)
SELECT
    s.student_id,
    CONCAT(s.first_name, ' ', s.last_name) AS student,
    ROUND(av.average_points, 2) AS average_grade_points
FROM averages av
JOIN Students s ON s.student_id = av.student_id
WHERE av.average_points = (
    SELECT MAX(average_points)
    FROM averages
);

WITH department_counts AS (
    SELECT
        c.department,
        COUNT(DISTINCT c.course_id) AS course_count
    FROM Courses c
    JOIN CourseAssignments a ON a.course_id = c.course_id
    WHERE a.year = @current_year
    GROUP BY c.department
)
SELECT *
FROM department_counts
WHERE course_count = (
    SELECT MAX(course_count)
    FROM department_counts
);

SELECT c.*
FROM Courses c
WHERE NOT EXISTS (
    SELECT 1
    FROM Enrollments e
    WHERE e.course_id = c.course_id
);

DELIMITER $$

CREATE FUNCTION StudentAge(p_date_of_birth DATE)
RETURNS INT
NOT DETERMINISTIC
NO SQL
BEGIN
    RETURN TIMESTAMPDIFF(YEAR, p_date_of_birth, CURDATE());
END$$

CREATE PROCEDURE EnrollStudent(
    IN p_student_id INT UNSIGNED,
    IN p_course_id INT UNSIGNED,
    IN p_semester VARCHAR(10),
    IN p_year SMALLINT UNSIGNED
)
BEGIN
    DECLARE v_assignment INT UNSIGNED DEFAULT NULL;
    DECLARE v_capacity INT DEFAULT 0;
    DECLARE v_count INT DEFAULT 0;
    DECLARE v_exists INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT assignment_id, capacity
    INTO v_assignment, v_capacity
    FROM CourseAssignments
    WHERE course_id = p_course_id
      AND semester = p_semester
      AND year = p_year
    FOR UPDATE;

    IF v_assignment IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Course offering not found';
    END IF;

    SELECT COUNT(*)
    INTO v_exists
    FROM Students
    WHERE student_id = p_student_id;

    IF v_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Student not found';
    END IF;

    SELECT COUNT(*)
    INTO v_exists
    FROM Enrollments
    WHERE assignment_id = v_assignment
      AND student_id = p_student_id;

    IF v_exists > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Student already enrolled';
    END IF;

    SELECT COUNT(*)
    INTO v_count
    FROM Enrollments
    WHERE assignment_id = v_assignment
    FOR UPDATE;

    IF v_count >= v_capacity THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Course capacity exceeded';
    END IF;

    INSERT INTO Enrollments (
        student_id,
        course_id,
        assignment_id,
        grade
    )
    VALUES (
        p_student_id,
        p_course_id,
        v_assignment,
        NULL
    );

    COMMIT;
END$$

DELIMITER ;

SELECT
    student_id,
    first_name,
    date_of_birth,
    StudentAge(date_of_birth) AS age
FROM Students;

SELECT
    c.department,
    ROUND(AVG(g.grade_points), 2) AS average_grade_points,
    COUNT(g.grade_points) AS graded_enrollments
FROM Courses c
LEFT JOIN EnrollmentGradePoints g ON g.course_id = c.course_id
GROUP BY c.department;

ALTER TABLE Students
ADD CONSTRAINT uq_student_email UNIQUE (email);

CALL EnrollStudent(
    10,
    3,
    @current_semester,
    @current_year
);

CREATE UNIQUE INDEX idx_course_code
ON Courses(course_code);

CREATE INDEX idx_enrollment_course_student
ON Enrollments(course_id, student_id);

CREATE INDEX idx_assignment_term
ON CourseAssignments(year, semester, course_id);

EXPLAIN
SELECT
    s.student_id,
    s.first_name,
    s.last_name,
    s.email
FROM Courses c
JOIN Enrollments e ON e.course_id = c.course_id
JOIN Students s ON s.student_id = e.student_id
WHERE c.course_code = 'CS101';

SELECT
    s.student_id,
    CONCAT(s.first_name, ' ', s.last_name) AS student,
    c.course_code,
    c.course_name,
    a.semester,
    a.year
FROM Students s
INNER JOIN Enrollments e ON e.student_id = s.student_id
INNER JOIN Courses c ON c.course_id = e.course_id
INNER JOIN CourseAssignments a ON a.assignment_id = e.assignment_id
ORDER BY s.student_id, c.course_code;

SELECT
    i.instructor_id,
    CONCAT(i.first_name, ' ', i.last_name) AS instructor,
    c.course_name,
    a.semester,
    a.year
FROM Instructors i
LEFT JOIN CourseAssignments a ON a.instructor_id = i.instructor_id
LEFT JOIN Courses c ON c.course_id = a.course_id
ORDER BY i.instructor_id;

SELECT
    student_id AS person_id,
    first_name,
    last_name,
    email,
    'Student' AS role
FROM Students

UNION

SELECT
    instructor_id AS person_id,
    first_name,
    last_name,
    email,
    'Instructor' AS role
FROM Instructors
ORDER BY role, person_id;

SELECT
    s.student_id,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    s.email,
    s.major,
    c.course_code,
    c.course_name AS course_enrolled,
    CONCAT(i.first_name, ' ', i.last_name) AS instructor,
    a.semester,
    a.year,
    e.grade,
    CASE
        WHEN e.enrollment_id IS NULL THEN 'No enrollment'
        WHEN e.grade IS NULL THEN 'Not graded'
        WHEN e.grade = 'I' THEN 'Incomplete'
        ELSE 'Graded'
    END AS grade_status,
    c.credits AS course_credits,
    COALESCE(t.total_credits, 0) AS total_enrolled_credits
FROM Students s
LEFT JOIN Enrollments e ON e.student_id = s.student_id
LEFT JOIN Courses c ON c.course_id = e.course_id
LEFT JOIN CourseAssignments a ON a.assignment_id = e.assignment_id
LEFT JOIN Instructors i ON i.instructor_id = a.instructor_id
LEFT JOIN (
    SELECT
        en.student_id,
        SUM(co.credits) AS total_credits
    FROM Enrollments en
    JOIN Courses co ON co.course_id = en.course_id
    GROUP BY en.student_id
) t ON t.student_id = s.student_id
ORDER BY s.student_id, a.year, a.semester, c.course_code;

SELECT
    (SELECT COUNT(*) FROM Students) AS students,
    (SELECT COUNT(*) FROM Instructors) AS instructors,
    (SELECT COUNT(*) FROM Courses) AS courses,
    (SELECT COUNT(*) FROM CourseAssignments) AS offerings,
    (SELECT COUNT(*) FROM Enrollments) AS enrollments;

SELECT
    s.student_id,
    COUNT(e.enrollment_id) AS enrollment_count
FROM Students s
LEFT JOIN Enrollments e ON e.student_id = s.student_id
GROUP BY s.student_id
HAVING COUNT(e.enrollment_id) < 2;

SELECT
    a.assignment_id,
    a.capacity,
    COUNT(e.enrollment_id) AS enrolled
FROM CourseAssignments a
LEFT JOIN Enrollments e ON e.assignment_id = a.assignment_id
GROUP BY a.assignment_id, a.capacity
HAVING COUNT(e.enrollment_id) > a.capacity;