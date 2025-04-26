
-- Query: Get all courses in CS
SELECT * FROM CS_Courses;

-- Query: Get John Doe’s teaching schedule
SELECT * 
FROM Faculty_Schedule
WHERE first_name = 'John' AND last_name = 'Doe'
ORDER BY day_of_week, start_time;

-- Query: Classroom Utilization
SELECT * FROM Classroom_Utilization;

-- Query: Detect Classroom Conflicts
SELECT * FROM Classroom_Conflicts;

-- Query: Detect Faculty Conflicts
SELECT * FROM Faculty_Conflicts;

-- Query: Get Student Schedule (student_id = 1)
SELECT * FROM Student_Schedule
WHERE student_id = 1
ORDER BY day_of_week, start_time;

-- Query: Available Time Slots for a Student (student_id = 1)
SELECT ts.day_of_week, ts.start_time, ts.end_time
FROM TimeSlots ts
WHERE ts.timeslot_id NOT IN (
    SELECT cla.timeslot_id
    FROM Student_Classes sc
    JOIN Classes cla ON sc.class_id = cla.class_id
    WHERE sc.student_id = 1
)
ORDER BY ts.day_of_week, ts.start_time;

-- Query: Department-wise Course Load
SELECT * FROM Department_Course_Load;

-- Query: Faculty Workload
SELECT * FROM Faculty_Workload
ORDER BY department_name, last_name;
