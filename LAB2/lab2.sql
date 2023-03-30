/*
    CSCI 403 Lab 2: Schedule
    
    Name: Nathan Oliver
*/

-- do not put SET SEARCH_PATH in this file
-- add your statements after the appropriate Step item
-- it's fine to add additional comments as well

/* Step 1: Create the table */

DROP TABLE IF EXISTS schedule;
CREATE TABLE schedule(
    department TEXT,
    course INT,
    title TEXT NOT NULL,
    credits NUMERIC(3,1) NOT NULL,
    semester TEXT CHECK (semester = 'Fall' OR semester = 'Spring' OR semester = 'Summer'),
    year INT DEFAULT EXTRACT(year FROM current_date), 
    PRIMARY KEY (department, course)
);

/* Step 2: Insert the data */

INSERT INTO schedule
VALUES ('MATH', 300, 'FOUNDATAIONS OF ADVANCED MATHEMATICS', 3.0, 'Fall'),
    ('MATH', 335, 'INTRODUCTION TO MATHEMATICAL STATISTICS', 3.0, 'Fall'),
    ('MATH', 424, 'INTRODUCTION TO APPLIED STATISTICS', 3.0, 'Fall');
    
INSERT INTO schedule
SELECT department, course_number, course_title, semester_hours,
    CASE
        WHEN fall = 't' THEN ('Fall')  
    END 
FROM cs_courses
WHERE course_number = 403;

/* Step 3: Fix errors */

UPDATE schedule
SET title = 'DATABASE MANAGEMENT'
WHERE course = 403;

/* Step 4: Add more constraints */

ALTER TABLE schedule
ADD UNIQUE (title);

ALTER TABLE schedule
ADD CHECK (credits >= 0.5 AND credits <= 15);

/* Step 5: Create another table */

DROP TABLE IF EXISTS assumed_grades;
CREATE TABLE assumed_grades(
    term TEXT CHECK (term = 'Fall' OR term = 'Spring' OR term = 'Summer'),
    year INT DEFAULT EXTRACT(year FROM current_date),
    department TEXT,
    course INT,
    title TEXT NOT NULL,
    grade CHAR(3), 
    credits NUMERIC(3,1) NOT NULL
);

ALTER TABLE assumed_grades
ADD FOREIGN KEY (department, course) REFERENCES schedule(department, course);

/* Step 6: Add the data */

INSERT INTO assumed_grades
SELECT semester, year, department, course, title, NULL, credits
FROM schedule;

/* Step 7: Enter grades */

UPDATE assumed_grades
SET grade = 'A+';

/* Step 8: cleaning up the table */

ALTER TABLE assumed_grades
RENAME COLUMN term TO semester;

/* Step 9 (Extra Credit): Play */

/* Step 10: Make a new table by copying */

CREATE TABLE transcript AS 
    (SELECT * FROM assumed_grades);

ALTER TABLE transcript
ADD FOREIGN KEY (department, course) REFERENCES schedule(department, course);

UPDATE transcript
SET grade = 'A++'
WHERE course = 403;

/* Step 11 (Extra Credit): Re-examining the schema */
