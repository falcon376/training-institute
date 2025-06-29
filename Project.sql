
USE training_institute;
CREATE TABLE Trainee (
    trainee_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    gender VARCHAR(10) CHECK (gender IN ('Male', 'Female')),
    email VARCHAR(100) UNIQUE,
    background VARCHAR(100)
);


CREATE TABLE Trainer (
    trainer_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    specialty VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100) UNIQUE
);

CREATE TABLE Course (
    course_id INT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    duration_hours INT,
    level VARCHAR(20) CHECK (level IN ('Beginner', 'Intermediate', 'Advanced'))
);

CREATE TABLE Schedule (
    schedule_id INT PRIMARY KEY,
    course_id INT FOREIGN KEY REFERENCES Course(course_id),
    trainer_id INT FOREIGN KEY REFERENCES Trainer(trainer_id),
    start_date DATE,
    end_date DATE,
    time_slot VARCHAR(20) CHECK (time_slot IN ('Morning', 'Evening', 'Weekend'))
);

CREATE TABLE Enrollment (
    enrollment_id INT PRIMARY KEY,
    trainee_id INT FOREIGN KEY REFERENCES Trainee(trainee_id),
    course_id INT FOREIGN KEY REFERENCES Course(course_id),
    enrollment_date DATE
);
INSERT INTO Trainee VALUES
(1, 'Aisha Al-Harthy', 'Female', 'aisha@example.com', 'Engineering'),
(2, 'Sultan Al-Farsi', 'Male', 'sultan@example.com', 'Business'),
(3, 'Mariam Al-Saadi', 'Female', 'mariam@example.com', 'Marketing'),
(4, 'Omar Al-Balushi', 'Male', 'omar@example.com', 'Computer Science'),
(5, 'Fatma Al-Hinai', 'Female', 'fatma@example.com', 'Data Science');

INSERT INTO Trainer VALUES
(1, 'Khalid Al-Maawali', 'Databases', '96891234567', 'khalid@example.com'),
(2, 'Noura Al-Kindi', 'Web Development', '96892345678', 'noura@example.com'),
(3, 'Salim Al-Harthy', 'Data Science', '96893456789', 'salim@example.com');


INSERT INTO Course VALUES
(1, 'Database Fundamentals', 'Databases', 20, 'Beginner'),
(2, 'Web Development Basics', 'Web', 30, 'Beginner'),
(3, 'Data Science Introduction', 'Data Science', 25, 'Intermediate'),
(4, 'Advanced SQL Queries', 'Databases', 15, 'Advanced');
INSERT INTO Schedule VALUES
(1, 1, 1, '2025-07-01', '2025-07-10', 'Morning'),
(2, 2, 2, '2025-07-05', '2025-07-20', 'Evening'),
(3, 3, 3, '2025-07-10', '2025-07-25', 'Weekend'),
(4, 4, 1, '2025-07-15', '2025-07-22', 'Morning');

INSERT INTO Enrollment VALUES
(1, 1, 1, '2025-06-01'),
(2, 2, 1, '2025-06-02'),
(3, 3, 2, '2025-06-03'),
(4, 4, 3, '2025-06-04'),
(5, 5, 3, '2025-06-05'),
(6, 1, 4, '2025-06-06');


---Query Challenges--
--Trainee Perspective --
--one--
-- Retrieve all courses with title, level, and category
SELECT c.title, c.level, c.category
FROM Course c;
-- List only beginner-level courses in the Data Science category
SELECT c.title, c.level, c.category
FROM Course c
WHERE c.level = 'Beginner'
  or c.category = 'Data Science';
--three
SELECT
    c.title
FROM Enrollment e
JOIN Course c ON e.course_id = c.course_id
WHERE e.trainee_id = 1;
--four
SELECT
    s.start_date,
    s.time_slot
FROM Enrollment e
JOIN Schedule s ON e.course_id = s.course_id
WHERE e.trainee_id = 1;
-- Count the number of courses trainee 1 is enrolled in
SELECT
    COUNT(*) AS enrolled_courses
FROM Enrollment e
WHERE e.trainee_id = 1;
-- Show course titles, trainer names, and time slots for trainee 1
SELECT
    c.title,
    t.name AS trainer_name,
    s.time_slot
FROM Enrollment e
JOIN Course c ON e.course_id = c.course_id
JOIN Schedule s ON c.course_id = s.course_id
JOIN Trainer t ON s.trainer_id = t.trainer_id
WHERE e.trainee_id = 1;

----part trainer perspective--

-- one
SELECT
    t.trainer_id,
    t.name AS trainer_name,
    c.title AS course_title
FROM Schedule s
JOIN Trainer t ON s.trainer_id = t.trainer_id
JOIN Course c ON s.course_id = c.course_id
ORDER BY t.trainer_id, c.title;
--two
SELECT t.name, c.title, s.start_date, s.end_date, s.time_slot
FROM Schedule s
JOIN Trainer t ON s.trainer_id = t.trainer_id
JOIN Course c ON s.course_id = c.course_id
WHERE s.start_date > GETDATE();
--see how many trainees are enrolled in each of your courses 
SELECT
    t.name AS trainer_name,
    c.title AS course_title,
    COUNT(e.enrollment_id) AS num_trainees
FROM Schedule s
JOIN Trainer t ON s.trainer_id = t.trainer_id
JOIN Course c ON s.course_id = c.course_id
LEFT JOIN Enrollment e ON c.course_id = e.course_id
GROUP BY t.name, c.title
ORDER BY t.name, c.title;
-- List trainee names and emails for each trainer's courses
SELECT
    t.name AS trainer_name,
    c.title AS course_title,
    tr.name AS trainee_name,
    tr.email
FROM Schedule s
JOIN Trainer t ON s.trainer_id = t.trainer_id
JOIN Course c ON s.course_id = c.course_id
JOIN Enrollment e ON c.course_id = e.course_id
JOIN Trainee tr ON e.trainee_id = tr.trainee_id;
-- Show trainer phone, email, and each assigned course
SELECT
    t.trainer_id,
    t.name AS trainer_name,
    t.phone,
    t.email,
    c.title AS course_title
FROM Schedule s
JOIN Trainer t ON s.trainer_id = t.trainer_id
JOIN Course c ON s.course_id = c.course_id
ORDER BY t.trainer_id, c.title;
-- Count how many distinct courses each trainer teaches
SELECT
    t.trainer_id,
    t.name AS trainer_name,
    COUNT(DISTINCT s.course_id) AS num_courses
FROM Schedule s
JOIN Trainer t ON s.trainer_id = t.trainer_id
GROUP BY t.trainer_id, t.name
ORDER BY t.trainer_id;
---part admin perspective

-- Add a new course to the Course table
INSERT INTO Course (course_id, title, category, duration_hours, level)
VALUES (5, 'Python for Data Science', 'Data Science', 40, 'Intermediate');
-- Add a new schedule for a trainer
INSERT INTO Schedule (schedule_id, course_id, trainer_id, start_date, end_date, time_slot)
VALUES (5, 5, 3, '2025-08-01', '2025-08-15', 'Evening');
-- List trainee enrollments with course and schedule details
SELECT
    trn.name AS trainee_name,
    c.title AS course_title,
    s.start_date,
    s.end_date,
    s.time_slot
FROM Enrollment e
JOIN Trainee trn ON e.trainee_id = trn.trainee_id
JOIN Course c ON e.course_id = c.course_id
JOIN Schedule s ON c.course_id = s.course_id
ORDER BY trn.name, c.title;
-- Count number of distinct courses assigned to each trainer
SELECT
    t.trainer_id,
    t.name AS trainer_name,
    COUNT(DISTINCT s.course_id) AS num_courses
FROM Trainer t
LEFT JOIN Schedule s ON t.trainer_id = s.trainer_id
GROUP BY t.trainer_id, t.name
ORDER BY t.trainer_id;

-- List trainees enrolled in "Database Fundamentals"
SELECT trn.name, trn.email
FROM Enrollment e
JOIN Trainee trn ON e.trainee_id = trn.trainee_id
JOIN Course c ON e.course_id = c.course_id
WHERE c.title = 'Database Fundamentals';
-- Find the course with the highest enrollments
SELECT TOP 1
    c.title,
    COUNT(e.enrollment_id) AS enrollments
FROM Course c
JOIN Enrollment e ON c.course_id = e.course_id
GROUP BY c.title
ORDER BY enrollments DESC;
-- Show all schedules ordered by start date
SELECT *
FROM Schedule
ORDER BY start_date ;









