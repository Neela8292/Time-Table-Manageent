-- Departments
INSERT INTO Departments (department_name, hod_name, contact_email)
VALUES 
('Computer Science', 'Dr. Smith', 'cs.hod@university.edu'),
('Mathematics', 'Dr. Johnson', 'math.hod@university.edu'),
('Physics', 'Dr. Williams', 'physics.hod@university.edu');

-- Faculty
INSERT INTO Faculty (first_name, last_name, email, department_id, specialization)
VALUES
('John', 'Doe', 'john.doe@university.edu', 1, 'Database Systems'),
('Jane', 'Smith', 'jane.smith@university.edu', 1, 'Artificial Intelligence'),
('Robert', 'Brown', 'robert.brown@university.edu', 2, 'Calculus'),
('Emily', 'Davis', 'emily.davis@university.edu', 3, 'Quantum Mechanics');

-- Courses
INSERT INTO Courses (course_code, course_name, credits, department_id)
VALUES
('CS101', 'Introduction to Programming', 4, 1),
('CS205', 'Database Systems', 4, 1),
('MATH201', 'Calculus I', 3, 2),
('PHYS301', 'Quantum Physics', 4, 3);

-- Classrooms
INSERT INTO Classrooms (room_number, building, capacity, room_type)
VALUES
('A101', 'Main Building', 50, 'Lecture Hall'),
('B205', 'Science Block', 30, 'Lab'),
('C302', 'Engineering Wing', 40, 'Lecture Hall');

-- TimeSlots
INSERT INTO TimeSlots (day_of_week, start_time, end_time)
VALUES
('Monday', '09:00:00', '10:30:00'),
('Monday', '11:00:00', '12:30:00'),
('Tuesday', '10:00:00', '11:30:00'),
('Wednesday', '14:00:00', '15:30:00');

-- Students
INSERT INTO Students (first_name, last_name, email, department_id, enrollment_year)
VALUES
('Alice', 'Johnson', 'alice.j@university.edu', 1, 2022),
('Bob', 'Williams', 'bob.w@university.edu', 1, 2022),
('Charlie', 'Brown', 'charlie.b@university.edu', 2, 2023);

-- Classes (timetable entries)
INSERT INTO Classes (course_id, faculty_id, classroom_id, timeslot_id, semester, academic_year)
VALUES
(1, 1, 1, 1, 'Spring', '2023-2024'),
(2, 2, 2, 2, 'Spring', '2023-2024'),
(3, 3, 3, 3, 'Spring', '2023-2024');

-- Student enrollments
INSERT INTO Student_Classes (student_id, class_id, enrollment_date)
VALUES
(1, 1, '2023-01-15'),
(2, 1, '2023-01-15'),
(1, 2, '2023-01-15'),
(3, 3, '2023-01-16');
