
-- SQL Project: Timetable Management System

-- Create database
CREATE DATABASE TimetableManagementSystem;
USE TimetableManagementSystem;

-- Departments table
CREATE TABLE Departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL,
    hod_name VARCHAR(100),
    contact_email VARCHAR(100)
);

-- Faculty table
CREATE TABLE Faculty (
    faculty_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    department_id INT,
    specialization VARCHAR(100),
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

-- Courses table
CREATE TABLE Courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(20) UNIQUE NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    credits INT NOT NULL,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

-- Classrooms table
CREATE TABLE Classrooms (
    classroom_id INT PRIMARY KEY AUTO_INCREMENT,
    room_number VARCHAR(20) NOT NULL,
    building VARCHAR(50) NOT NULL,
    capacity INT NOT NULL,
    room_type ENUM('Lecture Hall', 'Lab', 'Seminar Room') NOT NULL
);

-- TimeSlots table
CREATE TABLE TimeSlots (
    timeslot_id INT PRIMARY KEY AUTO_INCREMENT,
    day_of_week ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday') NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL
);

-- Classes table (timetable entries)
CREATE TABLE Classes (
    class_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT NOT NULL,
    faculty_id INT NOT NULL,
    classroom_id INT NOT NULL,
    timeslot_id INT NOT NULL,
    semester VARCHAR(20) NOT NULL,
    academic_year VARCHAR(20) NOT NULL,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    FOREIGN KEY (faculty_id) REFERENCES Faculty(faculty_id),
    FOREIGN KEY (classroom_id) REFERENCES Classrooms(classroom_id),
    FOREIGN KEY (timeslot_id) REFERENCES TimeSlots(timeslot_id),
    CONSTRAINT unique_schedule UNIQUE (classroom_id, timeslot_id, semester, academic_year),
    CONSTRAINT unique_faculty_schedule UNIQUE (faculty_id, timeslot_id, semester, academic_year)
);

-- Students table
CREATE TABLE Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    department_id INT,
    enrollment_year INT NOT NULL,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

-- Student_Classes (enrollment)
CREATE TABLE Student_Classes (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    class_id INT NOT NULL,
    enrollment_date DATE NOT NULL,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (class_id) REFERENCES Classes(class_id),
    CONSTRAINT unique_enrollment UNIQUE (student_id, class_id)
);

-- Sample Data
INSERT INTO Departments (department_name, hod_name, contact_email) VALUES 
('Computer Science', 'Dr. Smith', 'cs.hod@university.edu'),
('Mathematics', 'Dr. Johnson', 'math.hod@university.edu'),
('Physics', 'Dr. Williams', 'physics.hod@university.edu');

INSERT INTO Faculty (first_name, last_name, email, department_id, specialization) VALUES
('John', 'Doe', 'john.doe@university.edu', 1, 'Database Systems'),
('Jane', 'Smith', 'jane.smith@university.edu', 1, 'Artificial Intelligence'),
('Robert', 'Brown', 'robert.brown@university.edu', 2, 'Calculus'),
('Emily', 'Davis', 'emily.davis@university.edu', 3, 'Quantum Mechanics');

INSERT INTO Courses (course_code, course_name, credits, department_id) VALUES
('CS101', 'Introduction to Programming', 4, 1),
('CS205', 'Database Systems', 4, 1),
('MATH201', 'Calculus I', 3, 2),
('PHYS301', 'Quantum Physics', 4, 3);

INSERT INTO Classrooms (room_number, building, capacity, room_type) VALUES
('A101', 'Main Building', 50, 'Lecture Hall'),
('B205', 'Science Block', 30, 'Lab'),
('C302', 'Engineering Wing', 40, 'Lecture Hall');

INSERT INTO TimeSlots (day_of_week, start_time, end_time) VALUES
('Monday', '09:00:00', '10:30:00'),
('Monday', '11:00:00', '12:30:00'),
('Tuesday', '10:00:00', '11:30:00'),
('Wednesday', '14:00:00', '15:30:00');

INSERT INTO Students (first_name, last_name, email, department_id, enrollment_year) VALUES
('Alice', 'Johnson', 'alice.j@university.edu', 1, 2022),
('Bob', 'Williams', 'bob.w@university.edu', 1, 2022),
('Charlie', 'Brown', 'charlie.b@university.edu', 2, 2023);

INSERT INTO Classes (course_id, faculty_id, classroom_id, timeslot_id, semester, academic_year) VALUES
(1, 1, 1, 1, 'Spring', '2023-2024'),
(2, 2, 2, 2, 'Spring', '2023-2024'),
(3, 3, 3, 3, 'Spring', '2023-2024');

INSERT INTO Student_Classes (student_id, class_id, enrollment_date) VALUES
(1, 1, '2023-01-15'),
(2, 1, '2023-01-15'),
(1, 2, '2023-01-15'),
(3, 3, '2023-01-16');
