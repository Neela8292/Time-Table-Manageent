
-- View: All Courses in Computer Science Department
CREATE VIEW CS_Courses AS
SELECT c.course_code, c.course_name, c.credits 
FROM Courses c
JOIN Departments d ON c.department_id = d.department_id
WHERE d.department_name = 'Computer Science';

-- View: Faculty Schedule
CREATE VIEW Faculty_Schedule AS
SELECT f.faculty_id, f.first_name, f.last_name,
       ts.day_of_week, ts.start_time, ts.end_time,
       cr.course_name, cl.room_number, cl.building
FROM Classes cla
JOIN TimeSlots ts ON cla.timeslot_id = ts.timeslot_id
JOIN Courses cr ON cla.course_id = cr.course_id
JOIN Classrooms cl ON cla.classroom_id = cl.classroom_id
JOIN Faculty f ON cla.faculty_id = f.faculty_id;

-- View: Classroom Utilization
CREATE VIEW Classroom_Utilization AS
SELECT c.room_number, c.building, 
       COUNT(cl.class_id) AS scheduled_classes,
       (COUNT(cl.class_id) * 100.0 / 20) AS utilization_percentage
FROM Classrooms c
LEFT JOIN Classes cl ON c.classroom_id = cl.classroom_id
GROUP BY c.classroom_id;

-- View: Classroom Conflict Detection
CREATE VIEW Classroom_Conflicts AS
SELECT c1.class_id AS class1_id, c2.class_id AS class2_id, 
       cr.course_name AS course1, cr2.course_name AS course2,
       cl.room_number, cl.building, ts.day_of_week, ts.start_time, ts.end_time
FROM Classes c1
JOIN Classes c2 ON c1.classroom_id = c2.classroom_id 
                AND c1.timeslot_id = c2.timeslot_id
                AND c1.semester = c2.semester
                AND c1.academic_year = c2.academic_year
                AND c1.class_id < c2.class_id
JOIN TimeSlots ts ON c1.timeslot_id = ts.timeslot_id
JOIN Classrooms cl ON c1.classroom_id = cl.classroom_id
JOIN Courses cr ON c1.course_id = cr.course_id
JOIN Courses cr2 ON c2.course_id = cr2.course_id;

-- View: Faculty Conflict Detection
CREATE VIEW Faculty_Conflicts AS
SELECT f.first_name, f.last_name, 
       cr1.course_name AS course1, cr2.course_name AS course2,
       ts.day_of_week, ts.start_time, ts.end_time
FROM Classes c1
JOIN Classes c2 ON c1.faculty_id = c2.faculty_id
                AND c1.timeslot_id = c2.timeslot_id
                AND c1.semester = c2.semester
                AND c1.academic_year = c2.academic_year
                AND c1.class_id < c2.class_id
JOIN TimeSlots ts ON c1.timeslot_id = ts.timeslot_id
JOIN Faculty f ON c1.faculty_id = f.faculty_id
JOIN Courses cr1 ON c1.course_id = cr1.course_id
JOIN Courses cr2 ON c2.course_id = cr2.course_id;

-- View: Full Student Schedule
CREATE VIEW Student_Schedule AS
SELECT s.student_id, s.first_name, s.last_name, 
       ts.day_of_week, ts.start_time, ts.end_time,
       cr.course_code, cr.course_name,
       cl.room_number, cl.building,
       CONCAT(f.first_name, ' ', f.last_name) AS faculty_name
FROM Student_Classes sc
JOIN Students s ON sc.student_id = s.student_id
JOIN Classes cla ON sc.class_id = cla.class_id
JOIN TimeSlots ts ON cla.timeslot_id = ts.timeslot_id
JOIN Courses cr ON cla.course_id = cr.course_id
JOIN Classrooms cl ON cla.classroom_id = cl.classroom_id
JOIN Faculty f ON cla.faculty_id = f.faculty_id;

-- View: Department-wise Course Load
CREATE VIEW Department_Course_Load AS
SELECT d.department_name, 
       COUNT(DISTINCT cla.course_id) AS courses_offered,
       COUNT(cla.class_id) AS total_sections,
       COUNT(DISTINCT cla.faculty_id) AS faculty_involved
FROM Classes cla
JOIN Courses c ON cla.course_id = c.course_id
JOIN Departments d ON c.department_id = d.department_id
GROUP BY d.department_id;

-- View: Faculty Workload
CREATE VIEW Faculty_Workload AS
SELECT f.first_name, f.last_name, d.department_name,
       COUNT(cla.class_id) AS classes_teaching,
       GROUP_CONCAT(DISTINCT cr.course_name SEPARATOR ', ') AS courses_teaching
FROM Faculty f
LEFT JOIN Classes cla ON f.faculty_id = cla.faculty_id
LEFT JOIN Courses cr ON cla.course_id = cr.course_id
LEFT JOIN Departments d ON f.department_id = d.department_id
GROUP BY f.faculty_id;
