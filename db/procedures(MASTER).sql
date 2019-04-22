#CS 4400 Phase 3 Task List

#SQL Statement Calls:

# TODO
#
#
#
#

#General usage procedures

DROP PROCEDURE IF EXISTS `get_user_info`;
DELIMITER //
CREATE PROCEDURE get_user_info(IN p_username VARCHAR(50))
BEGIN
SELECT user.username, user.user_type, COALESCE(employee.emp_type, "") AS emp_type FROM (user LEFT JOIN employee USING (username)) WHERE user.username = p_username;
END //


DROP PROCEDURE IF EXISTS `get_sites` //
CREATE PROCEDURE get_sites()
BEGIN
SELECT DISTINCT name FROM site;
END //

DELIMITER ;

#Screen 1: User Login (endpoint: '/validate_login')
	#Task 1: Login
#user_login:
DELIMITER //
DROP PROCEDURE IF EXISTS `login_user` //
CREATE PROCEDURE login_user(IN p_email VARCHAR(75))
BEGIN
SELECT
    email, password, uname1, user_type
FROM
    (SELECT
        username AS uname1, email
    FROM
        user_email) email_t
        JOIN
    (SELECT
        username AS uname2, user_type, password
    FROM
        user) user_t ON (email_t.uname1 = user_t.uname2)
WHERE
    email = p_email;
END//

DROP PROCEDURE IF EXISTS `login_user2` //
CREATE PROCEDURE login_user2(IN p_email VARCHAR(75), IN pw varchar(50))
BEGIN
SELECT
    email, password, uname1, user_type
FROM
    (SELECT
        username AS uname1, email
    FROM
        user_email) email_t
        JOIN
    (SELECT
        username AS uname2, user_type, password
    FROM
        user) user_t ON (email_t.uname1 = user_t.uname2)
WHERE
    email = p_email AND password = SHA(pw);

END//





#Screen 3: Register User Only (endpoint: ‘/register_user’)
	#Task 1: Register User
#register_user
DELIMITER //

DROP PROCEDURE IF EXISTS `enter_emails` //
CREATE PROCEDURE enter_emails(
IN p_username VARCHAR(50),
IN p_emails VARCHAR(255))
BEGIN
DECLARE big_len INT;
DECLARE small_len INT;

IF p_emails IS NULL THEN
SET p_emails = "";
END IF;

WHILE p_emails != '' DO
SET big_len = LENGTH(p_emails);

INSERT IGNORE INTO user_email (username, email) VALUES (p_username, SUBSTRING_INDEX(p_emails, ',', 1));
SET small_len = LENGTH(SUBSTRING_INDEX(p_emails, ',', 1));
SET p_emails = MID(p_emails, small_len + 2, big_len);

END WHILE;

END //

DROP PROCEDURE IF EXISTS `register_helper_1` //
CREATE PROCEDURE register_helper_1(
IN p_username VARCHAR(50),
IN p_fname VARCHAR(50),
IN p_lname VARCHAR(50),
IN p_pw VARCHAR(50),
IN p_user_type ENUM('Visitor', 'User'),
IN p_emails VARCHAR(255))
BEGIN
INSERT INTO user VALUES (p_username, SHA(p_pw), p_fname, p_lname, "Pending", p_user_type);

CALL enter_emails(p_username, p_emails);
END //

DROP PROCEDURE IF EXISTS `register_user`//
CREATE PROCEDURE register_user(
IN p_username VARCHAR(50),
IN p_fname VARCHAR(50),
IN p_lname VARCHAR(50),
IN p_pw VARCHAR(50),
IN p_emails VARCHAR(255))
BEGIN
CALL register_helper_1(p_username, p_fname, p_lname, p_pw, "User", p_emails);
END //

DELIMITER ;



#Screen 4: Register Visitor Only (endpoint: ‘/register_visitor’)
	#Task 1: Register Visitor
#register_visitor:
	DELIMITER //
DROP PROCEDURE IF EXISTS `register_visitor`//
CREATE PROCEDURE register_visitor(
IN p_username VARCHAR(50),
IN p_fname VARCHAR(50),
IN p_lname VARCHAR(50),
IN p_pw VARCHAR(50),
IN p_emails VARCHAR(255))
BEGIN
CALL register_helper_1(p_username, p_fname, p_lname, p_pw, "Visitor", p_emails);
END //

DELIMITER ;


#Screen 5: Register Employee Only (endpoint: ‘/register_employee’)
	#Task 1: Register Employee
#register_employee
DELIMITER //
DROP PROCEDURE IF EXISTS `register_helper_2` //
CREATE PROCEDURE register_helper_2(
IN p_username VARCHAR(50),
IN p_fname VARCHAR(50),
IN p_lname VARCHAR(50),
IN p_pw VARCHAR(50),
IN p_phone VARCHAR(10),
IN p_address VARCHAR(95),
IN p_city VARCHAR(50),
IN p_state VARCHAR(3),
IN p_zip INT,
IN p_emp_type ENUM('Admin', 'Manager', 'Staff'),
IN p_user_type ENUM('Employee', 'Employee, Visitor'),
IN p_empID INT,
IN p_emails VARCHAR(255))
BEGIN
INSERT INTO user VALUES (p_username, SHA(p_pw), p_fname, p_lname, "Pending", p_user_type);
INSERT INTO employee VALUES (p_username, p_empID, p_phone, p_address, p_city, p_state, p_zip, p_emp_type);

CALL enter_emails(p_emails);
END //

DROP PROCEDURE IF EXISTS `register_employee`//
CREATE PROCEDURE register_employee(
IN p_username VARCHAR(50),
IN p_fname VARCHAR(50),
IN p_lname VARCHAR(50),
IN p_pw VARCHAR(50),
IN p_phone VARCHAR(10),
IN p_address VARCHAR(95),
IN p_city VARCHAR(50),
IN p_state VARCHAR(3),
IN p_zip INT,
IN p_emp_type ENUM('Admin', 'Manager', 'Staff'),
IN p_empID INT,
IN p_emails VARCHAR(255))
BEGIN
CALL register_helper_2(p_username, p_fname, p_lname, p_pw, p_phone, p_address, p_city, p_state, p_zip, p_emp_type, "Employee", p_empID, p_emails);
END //

DELIMITER ;
#Screen 6: Register Employee-Visitor (endpoint: ‘/register_employee-visitor’)
	#Task 1: Register Employee Visitor
#Register_employee_visitor:
	DELIMITER //
			DROP PROCEDURE IF EXISTS `register_employee_visitor` //
CREATE PROCEDURE register_employee_visitor(
IN p_username VARCHAR(50),
IN p_fname VARCHAR(50),
IN p_lname VARCHAR(50),
IN p_pw VARCHAR(50),
IN p_phone VARCHAR(10),
IN p_address VARCHAR(95),
IN p_city VARCHAR(50),
IN p_state VARCHAR(3),
IN p_zip INT,
IN p_emp_type ENUM('Admin', 'Manager', 'Staff'),
IN p_empID INT,
IN p_emails VARCHAR(255))
BEGIN
CALL register_helper_2(p_username, p_fname, p_lname, p_pw, p_phone, p_address, p_city, p_state, p_zip, p_emp_type, "Employee, Visitor", p_empID, p_emails);
END //
			DELIMITER ;

#Screen 15: User Take Transit (endpoint: ‘/take_transit’)
#Task 1: Show Transits
#get_transits:
DELIMITER //
DROP PROCEDURE IF EXISTS `get_transits`//
CREATE PROCEDURE get_transits()
BEGIN
SELECT transit.route, transit.type, transit.price, COUNT(*) AS connected_sites FROM (transit JOIN connects ON transit.type = connects.transit_type AND transit.route = connects.transit_route) GROUP BY route, type;
END //
DELIMITER ;


#Task 2: Log Transit
#log_transit:
	DELIMITER //
DROP PROCEDURE IF EXISTS `log_transit`//
CREATE PROCEDURE log_transit(
IN p_username varchar(50),
IN p_type varchar(25),
IN p_route varchar(25),
IN p_date date)
BEGIN
IF NOT EXISTS (SELECT * FROM take_transit WHERE username = p_username AND type = p_type AND route = p_route AND date = p_date) THEN
INSERT INTO take_transit VALUES (p_username, p_type, p_route, p_date);
END IF;
END //


#Screen 16: User Transit History (endpoint: ‘/transit_history’)
	#Task 1: View Transit History
#User_View_History:
DROP PROCEDURE IF EXISTS `transit_history`;
DELIMITER //
CREATE PROCEDURE transit_history(IN p_username varchar(50))
BEGIN
SELECT take_transit.date as date, take_transit.route as route, take_transit.type as transport_type, transit.price as price FROM take_transit, transit WHERE username = p_username and transit.type = take_transit.type and transit.route = take_transit.route;
END//

#Screen 17: Employee Manage Profile (endpoint: ‘/e_manage_profile’)
	#Task 1: #Manage Profile
DELIMITER //


DROP PROCEDURE IF EXISTS `manage_profile` //
CREATE PROCEDURE manage_profile(IN p_username varchar(50))
begin


SELECT first_name, last_name, uname1 AS username, email, emp_ID, phone, address, city, state, zip, site_name
FROM
    (SELECT
        first_name, last_name, uname1, email
    FROM
        (SELECT
        first_name, last_name, username AS uname1
    FROM
        user
    WHERE
        username = p_username) user_t
    JOIN (SELECT
        email, username AS uname2
    FROM
        user_email
    WHERE
        username = p_username) email_t ON (user_t.uname1 = email_t.uname2)) t_1
        JOIN
    (SELECT
        uname2, phone, address, city, state, zip, site_name, emp_ID
    FROM
        (SELECT
        username AS uname1, phone, address, city, state, zip, emp_ID
    FROM
        employee
    WHERE
        username = p_username) emp_t
    JOIN (SELECT
        manager_username AS uname2, name AS site_name
    FROM
        site
    WHERE
        manager_username = p_username) site_t ON (emp_t.uname1 = site_t.uname2)) t_2 ON (t_1.uname1 = t_2.uname2);
END//




#Screen 18: Administrator Manage User(endpoint: ‘/a_manage_user’)
	#Task 1:  #Manage User
    DELIMITER //
    DROP PROCEDURE IF EXISTS `manage_user` //
    CREATE PROCEDURE manage_user()
    begin
    SELECT
        uname1 AS username, email_count, user_type, status
    FROM
        (SELECT
            username AS uname1, COUNT(*) AS email_count
        FROM
            user_email
        GROUP BY username) email_t
            JOIN
        (SELECT
            user_type, status, username AS uname2
        FROM
            user) user_t ON (email_t.uname1 = user_t.uname2);
    END//
	# approve user

	#Task 2:
		#change_user_status:
			DROP PROCEDURE IF EXISTS `change_user_status`;
			DELIMITER //
			CREATE PROCEDURE change_user_status(
			IN p_username varchar(50),
			IN p_status ENUM("Approved", "Declined"))
			BEGIN
			UPDATE user SET status = p_status WHERE username = p_username;
			END //
			DELIMITER ;

#Screen 19: Administrator Manage Site(endpoint: ‘/a_manage_site’)
	#Task 1: #Manage Site
		DELIMITER //
		DROP PROCEDURE IF EXISTS `manage_site`//
		CREATE PROCEDURE manage_site()
		BEGIN
SELECT
    site_name, name, open_everyday
FROM
    (SELECT
        name AS site_name, manager_username AS uname1, open_everyday
    FROM
        site) site_t
        JOIN
    (SELECT
        CONCAT(first_name, ' ', last_name) AS name,
            username AS uname2
    FROM
        user) user_t ON (site_t.uname1 = user_t.uname2);
END//


#Screen 20: Administrator Edit Site (endpoint: ‘/a_edit_site’)
	#Task 1: #Edit Site
		#Display current site info:
	#SELECT * FROM site where name='';   #<= gets all info of this site
#SELECT * FROM employee where emp_type='Manager';    #<= gets all the manager #for the admin to choose

DELIMITER //
DROP PROCEDURE IF EXISTS `update_site`//
CREATE PROCEDURE update_site(IN new_name varchar(50),
IN new_zipcode INT, IN new_address varchar(95), IN new_manager varchar(55),
IN new_open VARCHAR(55), IN old_name varchar(50))
BEGIN
UPDATE site set name=new_name, zipcode=new_zipcode, address=new_address, manager_username=new_manager, open_everyday=new_open where name=old_name;
END//


#Screen 21: Administrator Create Site (endpoint: ‘/a_create_site)
	#Task 1: Get Unassigned Managers
#get_unassigned_mangers:
DELIMITER //
DROP PROCEDURE IF EXISTS `get_unassigned_managers` //
CREATE PROCEDURE get_unassigned_managers()
BEGIN
SELECT CONCAT(first_name, " ", last_name) AS manager_name FROM (user JOIN (SELECT username FROM employee WHERE emp_type = "Manager") a USING (username)) WHERE NOT EXISTS (SELECT * FROM site WHERE manager_username = a.username);
END //
DELIMITER ;
#Task 2: Create Site
#create_site:
DELIMITER //
DROP PROCEDURE IF EXISTS `create_site` //
CREATE PROCEDURE create_site(IN p_name VARCHAR(50), IN p_address VARCHAR(95), IN p_zip INT, IN p_manager VARCHAR(55), IN p_open VARCHAR(50))
BEGIN
INSERT INTO site VALUES (p_name, p_address, p_zip, p_open, p_manager);
END//
#Screen 22: Administrator Manage Transit (endpoint: ‘/a_manage_transit’)
	#Task 1: #Manage Transit
		#manage_transit:
DELIMITER //
DROP PROCEDURE IF EXISTS `manage_transit`//
CREATE PROCEDURE manage_transit()
BEGIN
Select type, route, price, coalesce(num_sites, 0) as num_sites, coalesce(num_log, 0) as num_log from
(Select type, route, price, num_sites from
(Select * from transit) transit_t
left join
(select transit_type, transit_route, count(*) as num_sites from connects group by transit_type, transit_route) connect_t
on (transit_t.type = connect_t.transit_type and transit_t.route = connect_t.transit_route)) t_1

left join
(select type as t_type, route as t_route, count(*) as num_log from take_transit group by type, route) t_2
on (t_1.type = t_2.t_type and t_1.route = t_2.t_route);
END//
	#Task 2: Delete Transit
		#delete_transit:
		DELIMITER //
		DROP PROCEDURE IF EXISTS `delete_transit` //
		CREATE PROCEDURE delete_transit(
IN p_type VARCHAR(25),
IN p_route VARCHAR(25))
BEGIN
DELETE FROM transit WHERE type = p_type AND route = p_route;
END //
#Screen 23: Administrator Edit Transit (endpoint: ’/a_edit_transit’)
#Task 1: Display Transit
#display_transit:
DELIMITER //
DROP PROCEDURE IF EXISTS `display_transit` //
CREATE PROCEDURE display_transit(IN p_type VARCHAR(25), IN p_route VARCHAR(25))
BEGIN
Select type, route, price, connected_sites from
(SELECT transit_type, transit_route, group_concat(site_name SEPARATOR ', ') as connected_sites from connects where transit_type = p_type and transit_route =p_route) connects_t
join
(select price, type, route from transit where type = p_type and route =p_route)
transit_t
on (connects_t.transit_type = transit_t.type and connects_t.transit_route = transit_t.route);
END//
DELIMITER ;

#Task 2: update_transit
#update_transit:
DELIMITER //
DROP PROCEDURE IF EXISTS `update_transit` //
CREATE PROCEDURE update_transit(
IN p_old_type varchar(25),
IN p_old_route varchar(25),
IN p_type varchar(25),
IN p_route varchar(25),
IN p_price float,
IN p_connected_sites varchar(255))
BEGIN
Declare big_len INT;
Declare small_len INT;

UPDATE transit SET type = p_type, route = p_route, price = p_price WHERE type = p_old_type AND route = p_old_route;

IF p_connected_sites IS NULL THEN
SET p_connected_sites = "";
END IF;

WHILE p_connected_sites != '' DO
SET big_len = LENGTH(p_connected_sites);

INSERT IGNORE INTO connects (site_name, transit_type, transit_route) VALUES (SUBSTRING_INDEX(p_connected_sites, ',', 1), p_type, p_route);
SET small_len = LENGTH(SUBSTRING_INDEX(p_connected_sites, ',', 1));
SET p_connected_sites = MID(p_connected_sites, small_len + 2, big_len);

END WHILE;
END //

DELIMITER ;



#Screen 24: Administrator Create Transit (endpoint: ‘/a_create_transit’)
	#Task 1: Create Transit
#create_transit:
DELIMITER //

DROP PROCEDURE IF EXISTS `create_transit` //
CREATE PROCEDURE create_transit(
IN p_type varchar(25),
IN p_route varchar(25),
IN p_price float,
IN p_connected_sites varchar(255))
BEGIN
Declare big_len INT;
Declare small_len INT;

IF NOT EXISTS (select * from transit where type = p_type and route = p_route) then
INSERT IGNORE INTO transit VALUES (p_type, p_route, p_price);

IF p_connected_sites IS NULL THEN
SET p_connected_sites = "";
END IF;

WHILE p_connected_sites != '' DO
SET big_len = LENGTH(p_connected_sites);

INSERT IGNORE INTO connects (site_name, transit_type, transit_route) VALUES (SUBSTRING_INDEX(p_connected_sites, ',', 1), p_type, p_route);
SET small_len = LENGTH(SUBSTRING_INDEX(p_connected_sites, ',', 1));
SET p_connected_sites = MID(p_connected_sites, small_len + 2, big_len);

END WHILE;

end  if;

END //
DELIMITER ;
#Screen 25: Manager Manage Event (endpoint: ‘/m_manage_event’)
#Task 1: Manage Event
#manage_event:
DROP PROCEDURE IF EXISTS `manage_event`;
DELIMITER //
CREATE PROCEDURE manage_event()
BEGIN
SELECT event.event_name, c.staff_count, b.duration, COALESCE(a.total_visits, 0) AS total_visits, COALESCE(a.total_revenue, 0) AS total_revenue FROM
event LEFT JOIN (SELECT event_name, event_start, site_name, COUNT(*) AS total_visits, SUM(event_price) AS total_revenue FROM (visit_event JOIN event USING (event_name, event_start, site_name)) GROUP BY event_name, event_start, site_name) a USING (event_name, event_start, site_name)
LEFT JOIN (SELECT event_name, event_start, site_name, DATEDIFF(end_date, event_start) + 1 AS duration FROM event) b USING (event_name, event_start, site_name)
LEFT JOIN (SELECT event_name, event_start, site_name, COUNT(*) AS staff_count FROM assign_to GROUP BY event_name, event_start, site_name) c USING (event_name, event_start, site_name);
END //
DELIMITER ;

#Screen 26: Manager View/Edit Event (endpoint: ‘/m_edit_event’)
#Task 1: View/Edit Event
#view_event:
DELIMITER //
DROP PROCEDURE IF EXISTS `m_edit_event`;
CREATE PROCEDURE m_edit_event(
IN p_event_name varchar(50),
IN p_event_start date,
IN p_site_name varchar(50))
BEGIN
SELECT event.event_name, event.event_price, event.event_start AS start_date, event.end_date, event.min_staff, event.capacity, b.staff_names, event.description
FROM event JOIN (SELECT event_name, event_start, site_name, GROUP_CONCAT(staff_name ORDER BY staff_name ASC) AS staff_names FROM
(SELECT event_name, event_start, site_name, CONCAT(first_name, " ", last_name) AS staff_name FROM (user JOIN assign_to ON assign_to.staff_username = user.username)) a GROUP BY event_name, event_start, site_name) b USING (event_name, event_start, site_name)
WHERE event_name = p_event_name AND event_start = p_event_start AND site_name = p_site_name;
END //
DELIMITER ;


DELIMITER //
DROP PROCEDURE IF EXISTS `event_report` //
CREATE PROCEDURE event_report
(IN e_name VARCHAR(50), IN s_date DATE, IN price DECIMAL(10, 2))
BEGIN
SELECT visit_date, count(*) visits, count(*) * price
from visit_event where event_name = e_name and event_start = s_date
GROUP BY visit_date order by visit_date;
END//

#Task 2: Update Event
#update_event:
DELIMITER //
DROP PROCEDURE IF EXISTS `update_event` //
CREATE PROCEDURE update_event(
IN e_name VARCHAR(50),
IN s_date DATE,
IN new_description VARCHAR(255),
IN staff_assigned VARCHAR(255))
BEGIN
Declare big_len INT;
Declare small_len INT;
Declare v_site_name varchar(50);

UPDATE event
SET description = new_description
where event_name = e_name and event_start = s_date;

SELECT site_name INTO v_site_name FROM event WHERE event_name = e_name AND event_start = s_date;

IF staff_assigned IS NULL THEN
SET staff_assigned = "";
END IF;

WHILE staff_assigned != '' DO
SET big_len = LENGTH(staff_assigned);

INSERT IGNORE INTO assign_to (staff_username, event_name, event_start, site_name) VALUES (SUBSTRING_INDEX(staff_assigned, ',', 1), e_name, s_date, v_site_name);
SET small_len = LENGTH(SUBSTRING_INDEX(staff_assigned, ',', 1));
SET staff_assigned = MID(staff_assigned, small_len + 2, big_len);

END WHILE;


END //
DELIMITER ;

#Screen 27: Manager Create Event (endpoint: ‘/m_create_event’)
	#Task 1: Create Event
#get_available_staff:
	DROP PROCEDURE IF EXISTS `get_available_staff`;
DELIMITER //
CREATE PROCEDURE get_available_staff(
IN p_start_date DATE,
IN p_end_date DATE)
BEGIN
SELECT CONCAT(first_name, " ", last_name) AS staff_name FROM (user JOIN (SELECT username FROM employee WHERE emp_type = "Staff") a USING (username)) WHERE NOT EXISTS (SELECT * FROM (event JOIN assign_to USING (event_name, event_start, site_name)) WHERE user.username = assign_to.staff_username AND assign_to.event_start <= p_end_date AND event.end_date >= p_start_date);
END //
DELIMITER ;

#create_event:
DROP PROCEDURE IF EXISTS `create_event`;

DELIMITER //
CREATE PROCEDURE create_event(
IN p_event_name varchar(50),
IN p_event_start date,
IN p_end_date date,
IN p_min_staff INT,
IN p_site_name varchar(50),
IN p_price float,
IN p_capacity INT,
IN p_description varchar(255),
IN staff_assigned varchar(255))
BEGIN
Declare big_len INT;
Declare small_len INT;

INSERT INTO EVENT VALUES (p_event_name, p_event_start, p_site_name, p_end_date, p_price, p_capacity, p_min_staff, p_description);

IF staff_assigned IS NULL THEN
SET staff_assigned = "";
END IF;

WHILE staff_assigned != '' DO
SET big_len = LENGTH(staff_assigned);

INSERT IGNORE INTO assign_to (staff_username, event_name, event_start, site_name) VALUES (SUBSTRING_INDEX(staff_assigned, ',', 1), e_name, s_date, v_site_name);
SET small_len = LENGTH(SUBSTRING_INDEX(staff_assigned, ',', 1));
SET staff_assigned = MID(staff_assigned, small_len + 2, big_len);

END WHILE;

END //
			DELIMITER ;

#Screen 28: Manager Manage Staff (endpoint: ‘/m_manage_staff’)
	#Task 1: Filter Staff
#filter_staff:
	DROP PROCEDURE IF EXISTS `filter_staff`;

DELIMITER //
CREATE PROCEDURE filter_staff(
IN p_site_name varchar(50))
BEGIN
SELECT b.staff_name, a.event_shifts FROM
(SELECT staff_username as username, COUNT(*) AS event_shifts FROM assign_to WHERE site_name = p_site_name GROUP BY username) a join (SELECT username, CONCAT(first_name, " ", last_name) AS staff_name FROM user) b USING (username);
END //

DELIMITER ;

#Screen 29: Manager Site Report (endpoint: ‘/m_site_report’)
	#Task 1: View Site Report
#get_site_report:
	DROP PROCEDURE IF EXISTS `get_site_report`;
DELIMITER //
CREATE PROCEDURE get_site_report(
IN p_site_name varchar(50),
IN p_start_date date,
IN p_end_date date)
BEGIN
DROP TABLE IF EXISTS dates;
CREATE TABLE dates AS select * from
(select adddate('1970-01-01',t4.i*10000 + t3.i*1000 + t2.i*100 + t1.i*10 + t0.i) date from
 (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t0,
 (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t1,
 (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t2,
 (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t3,
 (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t4) v
where date between p_start_date and p_end_date;

SELECT dates.date, COALESCE(c.event_count, 0) AS event_count, COALESCE(d.staff_count, 0) AS staff_count, COALESCE(a.event_visits, 0) + COALESCE(b.site_visits, 0) AS total_visits, COALESCE(a.total_revenue, 0) AS total_revenue FROM
dates
LEFT JOIN (SELECT visit_date AS date, COUNT(*) AS event_visits, SUM(event_price) AS total_revenue FROM (visit_event JOIN event USING (event_name, event_start, site_name)) WHERE site_name = p_site_name GROUP BY visit_date) a USING (date)
LEFT JOIN (SELECT visit_date AS date, COUNT(*) AS site_visits FROM visit_site WHERE site_name = p_site_name GROUP BY visit_date) b USING (date)
LEFT JOIN (SELECT dates.date, COUNT(event.event_name) AS event_count FROM dates, event WHERE site_name = p_site_name AND dates.date BETWEEN event.event_start AND event.end_date GROUP BY date) c USING (date)
LEFT JOIN (SELECT dates.date, COUNT(assign_to.staff_username) AS staff_count FROM dates, (event JOIN assign_to USING (event_name, event_start, site_name)) WHERE site_name = p_site_name AND dates.date BETWEEN event.event_start AND event.end_date GROUP BY date) d USING (date)
ORDER BY date ASC;

DROP TABLE dates;
END //
DELIMITER ;

#Screen 30: Manager Daily Detail (endpoint: ‘/m_daily_detail’)
	#Task 1: View Daily Detail
#get_daily_detail:
	DROP PROCEDURE IF EXISTS `get_daily_detail`;
DELIMITER //

CREATE PROCEDURE get_daily_detail(
IN p_manager_username varchar(50),
IN p_site varchar(50),
IN p_date DATE)
BEGIN
SELECT event.event_name, a.staff_names, b.visits, b.visits * event.event_price AS revenue FROM
event JOIN (SELECT event_name, site_name, event_start, GROUP_CONCAT(staff_name ORDER BY staff_name ASC SEPARATOR ", ") AS staff_names FROM (SELECT assign_to.event_name, assign_to.site_name, assign_to.event_start, CONCAT(user.first_name, " ", user.last_name) as staff_name FROM assign_to, user WHERE assign_to.staff_username = user.username) d GROUP BY event_name, site_name, event_start) a USING (event_name, site_name, event_start)
JOIN (SELECT event_name, site_name, event_start, COUNT(*) AS visits FROM visit_event WHERE visit_date = p_date GROUP BY event_name, site_name, event_start) b USING (event_name, site_name, event_start)
WHERE event.site_name = p_site AND p_date BETWEEN event.event_start AND event.end_date;
END //

DELIMITER ;


#Screen 31: Staff View Schedule (endpoint: ‘/s_view_schedule’)
	#Task 1: View Schedule
#get_schedule:
	DROP PROCEDURE IF EXISTS `get_schedule`;
DELIMITER //

CREATE PROCEDURE get_schedule(IN p_staff_username varchar(50))
BEGIN
SELECT event.event_name, event.site_name, event.event_start AS start_date, event.end_date, a.staff_count
FROM event JOIN (SELECT event_name, site_name, event_start, COUNT(event_name) AS staff_count FROM assign_to GROUP BY event_name, site_name, event_start) a USING (event_name, site_name, event_start)
JOIN (SELECT event_name, site_name, event_start FROM assign_to WHERE staff_username = p_staff_username) b USING (event_name, site_name, event_start);
END //

DELIMITER ;

#Screen 32: Staff Event Detail (endpoint: ‘/s_event_detail’)
	#Task 1: View Event Detail
#get_event_staff_detail:
	DROP PROCEDURE IF EXISTS `get_event_staff_detail`;
DELIMITER //

CREATE PROCEDURE get_event_staff_detail(
IN p_event_name varchar(50),
IN p_site_name varchar(50),
IN p_start_date DATE)
BEGIN
SELECT event.event_name AS event,
event.site_name AS site,
event.event_start AS start_date,
event.end_date,
DATEDIFF(event.end_date, event.event_start) + 1AS duration,
(SELECT GROUP_CONCAT(CONCAT(user.first_name, " ", user.last_name) ORDER BY user.first_name ASC SEPARATOR ", ") FROM user, (SELECT staff_username FROM assign_to WHERE event_name = p_event_name AND site_name = p_site_name AND event_start = p_start_date) a WHERE a.staff_username = user.username) AS staff_assigned,
event.capacity,
event.event_price AS ticket_price,
event.description
FROM event, visit_event WHERE event.event_name = p_event_name AND event.site_name = p_site_name AND event.event_start = p_start_date GROUP BY event.event_name, event.site_name, event.event_start;
END //

DELIMITER ;

#Screen 33: Visitor Explore Event (endpoint: ‘/v_explore_event’)
	#Task 1: Explore Event
#explore_event:
DROP PROCEDURE IF EXISTS `explore_event`;
DELIMITER //

CREATE PROCEDURE explore_event(IN p_username varchar(50))
BEGIN
SELECT event.event_name AS event_name, event.site_name as site_name, event.event_price as ticket_price, event.capacity - COALESCE(a.tickets_bought, 0) AS tickets_remaining, COALESCE(b.total_visits, 0) AS total_visits, COALESCE(c.my_visits, 0) AS my_visits FROM event
LEFT JOIN (SELECT event_name, site_name, event_start, COUNT(*) AS tickets_bought FROM visit_event GROUP BY event_name, site_name, event_start) a USING (event_name, site_name, event_start)
LEFT JOIN (SELECT event_name, site_name, event_start, COUNT(*) AS total_visits FROM visit_event GROUP BY event_name, site_name, event_start) b USING (event_name, site_name, event_start)
LEFT JOIN (SELECT event_name, site_name, event_start, COUNT(*) AS my_visits FROM visit_event WHERE username = p_username GROUP BY event_name, site_name, event_start) c USING (event_name, site_name, event_start);
END //

DELIMITER ;

#Screen 34: Visitor Event Detail (endpoint: ‘/v_event_detail’) #TODO: FIX
	#Task 1: View Event Detail
#get_event_detail:
    DROP PROCEDURE IF EXISTS `get_event_detail`;
    DELIMITER //

    CREATE PROCEDURE get_event_detail(
    IN p_name varchar(50),
    IN p_site_name varchar(50),
    IN p_start_date DATE)
    BEGIN
    SELECT event.event_name AS event, event.site_name AS site, event.event_start AS start_date, event.description, event.end_date AS end_date, event.event_price AS ticket_price, event.capacity - (SELECT COUNT(*) FROM visit_event WHERE event_name = p_name AND event_start = p_start_date AND site_name = p_site_name) AS tickets_remaining FROM event, visit_event WHERE event.event_name = p_name GROUP BY event.event_name;
    END //

    DELIMITER ;


#Task 2: Log Visit
  #log_event_visit:
      DROP PROCEDURE IF EXISTS `log_event_visit`;
    DELIMITER //

    CREATE PROCEDURE log_event_visit(
    IN p_username varchar(50),
    IN p_event_name varchar(50),
    IN p_event_start varchar(50),
    IN p_site_name varchar(50),
    IN p_visit_date date)
    BEGIN
    DECLARE v_end_date DATE;

    SELECT end_date INTO v_end_date FROM event WHERE event_name = p_event_name AND event_start = p_event_start AND site_name = p_site_name;

    IF NOT EXISTS (SELECT * FROM visit_event WHERE username = p_username AND event_name = p_event_name AND event_start = p_event_start AND site_name = p_site_name AND visit_date = p_visit_date)
    AND p_visit_date BETWEEN p_event_start AND v_end_date THEN
    INSERT INTO visit_event (username, event_name, event_start, site_name, visit_date) VALUES (p_username, p_event_name, p_event_start, p_site_name, p_visit_date);
    END IF;
    END //

    DELIMITER ;


#Screen 35: Visitor Explore Site (endpoint: ‘/v_explore_site’)
	#Task 1: Explore Site
#explore_site:
	DROP PROCEDURE IF EXISTS `explore_site`;
DELIMITER //

CREATE PROCEDURE explore_site(IN p_username varchar(50))
BEGIN
SELECT site.name AS site_name, COALESCE(a.event_count, 0) AS event_count, COALESCE(b.total_event_visits, 0) + COALESCE(c.total_site_visits, 0) AS total_visits, COALESCE(d.my_event_visits, 0) + COALESCE(e.my_site_visits, 0) AS my_visits FROM site
LEFT JOIN (SELECT site_name AS name, COUNT(*) AS event_count FROM event GROUP BY name) a USING (name)
LEFT JOIN (SELECT site_name as name, COUNT(*) AS total_event_visits FROM visit_event GROUP BY name) b USING (name)
LEFT JOIN (SELECT site_name as name, COUNT(*) AS total_site_visits FROM visit_site GROUP BY name) c USING (name)
LEFT JOIN (SELECT site_name as name, COUNT(*) AS my_event_visits FROM visit_event WHERE username = p_username GROUP BY name) d USING (name)
LEFT JOIN (SELECT site_name as name, COUNT(*) AS my_site_visits FROM visit_site WHERE username = p_username GROUP BY name) e USING (name);
END //

DELIMITER ;



#Screen 36: Visitor Transit Detail (endpoint: ‘/v_transit_detail’)
	#Task 1: View Transit Detail
#get_transit_detail:
	DROP PROCEDURE IF EXISTS `get_transit_detail`;
DELIMITER //

CREATE PROCEDURE get_transit_detail(IN p_type varchar(25), IN p_route varchar(25))
BEGIN
SELECT transit.route AS route, transit.type AS type, transit.price AS price, COUNT(connects.site_name) AS connected_sites FROM transit, connects WHERE transit.route = connects.transit_route AND transit.type = connects.transit_type;
END //

DELIMITER ;

#Task 2: Log Transit
#log_transit:
	DROP PROCEDURE IF EXISTS `log_transit`;
DELIMITER //

CREATE PROCEDURE log_transit(
IN p_username varchar(50),
IN p_type varchar(25),
IN p_route varchar(25),
IN p_transit_date date)
BEGIN
INSERT INTO take_transit (username, type, route, date) VALUES (p_username, p_type, p_route, p_transit_date);
END //

DELIMITER ;

#Screen 37: Visitor Site Detail (endpoint: ‘/v_site_detail’)
	#Task 1: View Site Detail
#get_site_detail:
DROP PROCEDURE IF EXISTS `get_site_detail`;
DELIMITER //

CREATE PROCEDURE get_site_detail(IN p_name varchar(50))
BEGIN
SELECT name, CONCAT(address, ", Atlanta, GA ", zipcode) AS address, open_everyday FROM site WHERE name = p_name;
END //

DELIMITER ;


	#Task 2: Log Visit
#log_visit:
	DROP PROCEDURE IF EXISTS `log_visit`;
DELIMITER //

CREATE PROCEDURE log_visit(
IN p_username varchar(50),
IN p_site_name varchar(50),
IN p_visit_date date)
BEGIN
IF NOT EXISTS (SELECT * FROM visit_site WHERE username = p_username AND site_name = p_site_name AND visit_date = p_visit_date) THEN
INSERT INTO visit_site (username, site_name, visit_date) VALUES (p_username, p_site_name, p_visit_date);
END IF;
END //

DELIMITER ;

#Screen 38: Visitor Visit History (endpoint: ‘/v_visit_history’)
	#Task 1: Filter Visit History
#filter_visitor_visits

DELIMITER //
			DROP PROCEDURE IF EXISTS `filter_visitor_visits`//
CREATE PROCEDURE filter_visitor_visits(IN p_username varchar(50))
BEGIN
SELECT visit_event.visit_date as date, visit_event.event_name as event, visit_event.site_name as site, event.event_price as price FROM visit_event, event WHERE visit_event.username = p_username
UNION ALL
SELECT visit_site.visit_date as date, NULL as event, visit_site.site_name as site, 0 as price FROM visit_site WHERE visit_site.username = p_username;
END //

DELIMITER ;







