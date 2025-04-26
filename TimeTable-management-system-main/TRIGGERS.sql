-- Trigger to prevent classroom overbooking beyond capacity
DELIMITER //
CREATE TRIGGER check_classroom_capacity
BEFORE INSERT ON Student_Classes
FOR EACH ROW
BEGIN
    DECLARE class_capacity INT;
    DECLARE current_enrollment INT;
    
    -- Get classroom capacity for the class
    SELECT cl.capacity INTO class_capacity
    FROM Classrooms cl
    JOIN Classes cla ON cl.classroom_id = cla.classroom_id
    WHERE cla.class_id = NEW.class_id;
    
    -- Get current enrollment for the class
    SELECT COUNT(*) INTO current_enrollment
    FROM Student_Classes
    WHERE class_id = NEW.class_id;
    
    -- Check if adding this student would exceed capacity
    IF current_enrollment >= class_capacity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Classroom capacity exceeded for this class';
    END IF;
END //
DELIMITER ;

-- Trigger to maintain faculty teaching load (max 4 classes per semester)
DELIMITER //
CREATE TRIGGER check_faculty_workload
BEFORE INSERT ON Classes
FOR EACH ROW
BEGIN
    DECLARE current_load INT;
    
    -- Count current classes for this faculty in the same semester/year
    SELECT COUNT(*) INTO current_load
    FROM Classes
    WHERE faculty_id = NEW.faculty_id
    AND semester = NEW.semester
    AND academic_year = NEW.academic_year;
    
    -- Check if adding this class would exceed maximum load
    IF current_load >= 4 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Faculty teaching load exceeded (maximum 4 classes per semester)';
    END IF;
END //
DELIMITER ;

-- Trigger to prevent time conflicts for faculty (alternative to unique constraint)
DELIMITER //
CREATE TRIGGER check_faculty_schedule_conflict
BEFORE INSERT ON Classes
FOR EACH ROW
BEGIN
    DECLARE conflict_count INT;
    
    -- Check for existing classes at the same time
    SELECT COUNT(*) INTO conflict_count
    FROM Classes
    WHERE faculty_id = NEW.faculty_id
    AND timeslot_id = NEW.timeslot_id
    AND semester = NEW.semester
    AND academic_year = NEW.academic_year;
    
    IF conflict_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Faculty already has a class scheduled at this time';
    END IF;
END //
DELIMITER ;

-- Trigger to prevent time conflicts for classrooms (alternative to unique constraint)
DELIMITER //
CREATE TRIGGER check_classroom_schedule_conflict
BEFORE INSERT ON Classes
FOR EACH ROW
BEGIN
    DECLARE conflict_count INT;
    
    -- Check for existing classes in the same room at the same time
    SELECT COUNT(*) INTO conflict_count
    FROM Classes
    WHERE classroom_id = NEW.classroom_id
    AND timeslot_id = NEW.timeslot_id
    AND semester = NEW.semester
    AND academic_year = NEW.academic_year;
    
    IF conflict_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Classroom already booked at this time';
    END IF;
END //
DELIMITER ;

-- Trigger to log timetable changes for audit purposes
CREATE TABLE Timetable_Audit_Log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    action_type VARCHAR(10) NOT NULL,
    class_id INT,
    course_id INT,
    faculty_id INT,
    classroom_id INT,
    timeslot_id INT,
    changed_by VARCHAR(100),
    change_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    semester VARCHAR(20),
    academic_year VARCHAR(20)
);

DELIMITER //
CREATE TRIGGER log_timetable_changes
AFTER INSERT OR UPDATE OR DELETE ON Classes
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO Timetable_Audit_Log (action_type, class_id, course_id, faculty_id, 
                                        classroom_id, timeslot_id, changed_by,
                                        semester, academic_year)
        VALUES ('INSERT', NEW.class_id, NEW.course_id, NEW.faculty_id, 
                NEW.classroom_id, NEW.timeslot_id, CURRENT_USER(),
                NEW.semester, NEW.academic_year);
    ELSEIF UPDATING THEN
        INSERT INTO Timetable_Audit_Log (action_type, class_id, course_id, faculty_id, 
                                        classroom_id, timeslot_id, changed_by,
                                        semester, academic_year)
        VALUES ('UPDATE', NEW.class_id, NEW.course_id, NEW.faculty_id, 
                NEW.classroom_id, NEW.timeslot_id, CURRENT_USER(),
                NEW.semester, NEW.academic_year);
    ELSEIF DELETING THEN
        INSERT INTO Timetable_Audit_Log (action_type, class_id, course_id, faculty_id, 
                                        classroom_id, timeslot_id, changed_by,
                                        semester, academic_year)
        VALUES ('DELETE', OLD.class_id, OLD.course_id, OLD.faculty_id, 
                OLD.classroom_id, OLD.timeslot_id, CURRENT_USER(),
                OLD.semester, OLD.academic_year);
    END IF;
END //
DELIMITER ;

-- Trigger to enforce prerequisites (example for a specific course)
DELIMITER //
CREATE TRIGGER check_course_prerequisites
BEFORE INSERT ON Student_Classes
FOR EACH ROW
BEGIN
    DECLARE prereq_met INT;
    DECLARE course_code VARCHAR(20);
    
    -- Get course code for the class being enrolled in
    SELECT c.course_code INTO course_code
    FROM Courses c
    JOIN Classes cl ON c.course_id = cl.course_id
    WHERE cl.class_id = NEW.class_id;
    
    -- Example: CS205 requires CS101
    IF course_code = 'CS205' THEN
        -- Check if student has taken CS101
        SELECT COUNT(*) INTO prereq_met
        FROM Student_Classes sc
        JOIN Classes cl ON sc.class_id = cl.class_id
        JOIN Courses c ON cl.course_id = c.course_id
        WHERE sc.student_id = NEW.student_id
        AND c.course_code = 'CS101';
        
        IF prereq_met = 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Prerequisite not met: CS101 required for CS205';
        END IF;
    END IF;
END //
DELIMITER ;

-- Trigger to update student email format consistency
DELIMITER //
CREATE TRIGGER format_student_email
BEFORE INSERT ON Students
FOR EACH ROW
BEGIN
    -- If email is not provided, generate one
    IF NEW.email IS NULL THEN
        SET NEW.email = CONCAT(LOWER(NEW.first_name), '.', LOWER(NEW.last_name), NEW.enrollment_year % 100, '@university.edu');
    ELSE
        -- Ensure email is lowercase
        SET NEW.email = LOWER(NEW.email);
    END IF;
END //
DELIMITER ;

-- Trigger to prevent deletion of departments with associated courses
DELIMITER //
CREATE TRIGGER prevent_department_deletion
BEFORE DELETE ON Departments
FOR EACH ROW
BEGIN
    DECLARE course_count INT;
    
    SELECT COUNT(*) INTO course_count
    FROM Courses
    WHERE department_id = OLD.department_id;
    
    IF course_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete department with associated courses';
    END IF;
END //
DELIMITER ;
