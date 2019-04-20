SET GLOBAL log_bin_trust_function_creators = 1;
-- Screen 1: User Login (endpoint: '/validate_login')
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

-- Screen 3: Register User Only (endpoint: '/register_user')
DELIMITER //
DROP PROCEDURE IF EXISTS `register_user` //
CREATE PROCEDURE register_user(IN p_username VARCHAR(50),
IN p_fname VARCHAR(50), IN p_lname VARCHAR(50), IN p_pw VARCHAR(50),
IN p_status ENUM('Pending', 'Approved', 'Declined'),
IN p_user_type ENUM('Employee', 'Visitor', 'Employee, Visitor', 'User'))
BEGIN
INSERT INTO user VALUES (p_username, p_pw, p_fname, p_lname, p_status, p_user_type);
END//

DELIMITER //
DROP PROCEDURE IF EXISTS `insert_email` //
CREATE PROCEDURE insert_email(IN p_username VARCHAR(50), IN p_email VARCHAR(75))
BEGIN
INSERT INTO user_email VALUES (p_username, p_email);
END//

INSERT INTO visitor VALUES (?, ?);
INSERT INTO user_email VALUES(?, ?);


INSERT INTO employee VALUES (?, ?, ?, ?, ?, ?, ?);
INSERT INTO user_email VALUES(?, ?);


INSERT INTO visitor VALUES (?, ?);
INSERT INTO employee VALUES (?, ?, ?, ?, ?, ?, ?);
INSERT INTO user_email VALUES(?, ?);

INSERT INTO take_transit VALUES (?, ?, ?, ?);

-- Screen 16: Transit History (endpoint: '/transit_history')
DELIMITER //
DROP PROCEDURE IF EXISTS `transit_history` //
CREATE PROCEDURE transit_history(IN p_username varchar(50))
BEGIN
SELECT * FROM take_transit WHERE Username = p_username;
END//


-- Screen 17: Employee Manage Profile (endpoint: ‘/e_manage_profile’)
Delimiter //
DROP PROCEDURE IF EXISTS `manage_profile` //
CREATE PROCEDURE manage_profile(IN p_username varchar(50))
BEGIN
SELECT 
    first_name,
    last_name,
    uname1 AS username,
    email,
    emp_ID,
    phone,
    address,
    city,
    state,
    zip,
    site_name
FROM
    (SELECT 
        first_name, last_name, uname1, email
    FROM
        (SELECT 
        first_name, last_name, username AS uname1
    FROM
        user
    WHERE
        username = 'manager3') user_t
    JOIN (SELECT 
        email, username AS uname2
    FROM
        user_email
    WHERE
        username = 'manager3') email_t ON (user_t.uname1 = email_t.uname2)) t_1
        JOIN
    (SELECT 
        uname2, phone, address, city, state, zip, site_name, emp_ID
    FROM
        (SELECT 
        username AS uname1, phone, address, city, state, zip, emp_ID
    FROM
        employee
    WHERE
        username = 'manager3') emp_t
    JOIN (SELECT 
        manager_username AS uname2, name AS site_name
    FROM
        site
    WHERE
        manager_username = 'manager3') site_t ON (emp_t.uname1 = site_t.uname2)) t_2 ON (t_1.uname1 = t_2.uname2);
END//


-- Screen 18: Administrator Manage User(endpoint: ‘/a_manage_user’
DELIMITER //
DROP PROCEDURE IF EXISTS `manage_user` //
CREATE PROCEDURE manage_user(IN p_username varchar(50))
begin
SELECT 
    uname1 AS username, email_count, user_type, status
FROM
    (SELECT 
        username AS uname1, COUNT(*) AS email_count
    FROM
        user_email
    WHERE
        username = p_username
    GROUP BY username) email_t
        JOIN
    (SELECT 
        user_type, status, username AS uname2
    FROM
        user
    WHERE
        username = p_username) user_t ON (email_t.uname1 = user_t.uname2);
end//


-- Screen 19: Administrator Manage Site(endpoint: ‘/a_manage_site’)
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

# Screen 20: Administrator Edit Site (endpoint: ‘/a_edit_site’)
SELECT * FROM site where name='Westview Cemetery';
SELECT * FROM employee where emp_type='Manager';

DELIMITER //

DROP PROCEDURE IF EXISTS `update_site`//
CREATE PROCEDURE update_site(IN new_name varchar(50),
IN new_zipcode INT, IN new_address varchar(95), IN new_manager varchar(55),
IN new_open VARCHAR(55), IN old_name varchar(50))
BEGIN
UPDATE site set name=new_name, zipcode=new_zipcode, address=new_address, manager_username=new_manager, open_everyday=new_open where name=old_name;
END//

# Screen 21: Administrator Create Site (endpoint: ‘/a_create_site)
DELIMITER //
DROP PROCEDURE IF EXISTS `new_site` //
CREATE PROCEDURE new_site(IN p_name VARCHAR(50), IN p_address VARCHAR(95), IN p_zip INT, IN p_manager VARCHAR(55), IN p_open VARCHAR(50))
BEGIN
INSERT INTO site VALUES (p_name, p_address, p_zip, p_open, p_manager);
END//

-- Screen 22: Administrator Manage Transit (endpoint: ‘/a_manage_transit’)
DELIMITER //
DROP PROCEDURE IF EXISTS `manage_transit`//
CREATE PROCEDURE manage_transit()
BEGIN
Select type, route, price, num_sites, num_log from
(Select type, route, price, num_sites from
(Select * from transit) transit_t
join
(select transit_type, transit_route, count(*) as num_sites from connects group by transit_type, transit_route) connect_t
on (transit_t.type = connect_t.transit_type and transit_t.route = connect_t.transit_route)) t_1

join
(select type as t_type, route as t_route, count(*) as num_log from take_transit group by type, route) t_2
on (t_1.type = t_2.t_type and t_1.route = t_2.t_route);
END//

-- Screen 23: Administrator Edit Transit (endpoint: ’/a_edit_transit’)
DELIMITER //
DROP PROCEDURE IF EXISTS `display_transit` //
CREATE PROCEDURE display_transit(IN p_type VARCHAR(25), IN p_route VARCHAR(25))
BEGIN
Select type, route, price, connected_sites from
(SELECT transit_type, transit_route, group_concat(site_name SEPARATOR ', ') as connected_sites from connects where transit_type = "Bus" and transit_route = 152) connects_t
join
(select price, type, route from transit where type = "Bus" and route = 152)
transit_t
on (connects_t.transit_type = transit_t.type and connects_t.transit_route = transit_t.route);
END//

DELIMITER //
DROP PROCEDURE IF EXISTS `update_transit` //
CREATE PROCEDURE edit_transit(
IN p_type VARCHAR(25),
IN update_route VARCHAR(25),
IN old_route VARCHAR(25),
IN update_price float,
IN update_sites VARCHAR(255)
)
BEGIN
UPDATE transit SET
	route=update_route,
    price=update_price
    where type = p_type and route=old_route;
END//

# Screen 24: Administrator Create Transit (endpoint: ‘/a_create_transit’)
INSERT INTO Transit VALUES (?, ?, ?);
# Screen 25: Manager Manage Event (endpoint: ‘/m_manage_event’)
DELIMITER //
DROP PROCEDURE IF EXISTS `manage_event` //
CREATE PROCEDURE manage_event(IN manager VARCHAR(25))
BEGIN
select event_name,
description,
event_price,
event_staff_count(event_name, event_start) as staff_count,
event_duration(event_start, end_date) as duration,
event_total_visits(event_name, event_start) as visits,
event_revenue(event_price, event_name, event_start) as revenue
from event where site_name in 
(select name from site where manager_username = manager);
END//

DELIMITER //
DROP FUNCTION IF EXISTS `event_revenue`//
CREATE FUNCTION event_revenue
(price DECIMAL(10, 2), e_name VARCHAR(50), s_date DATE)
RETURNS DECIMAL(10, 2)
BEGIN
DECLARE revenue DOUBLE DEFAULT 0.0;
DECLARE c_visits INTEGER DEFAULT 0;
select count(*) into c_visits
from visit_event
where event_name = e_name
and event_start = s_date;

SET revenue = price * CAST(c_visits as DECIMAL(10, 2));
RETURN revenue;
END //


DELIMITER //
DROP FUNCTION IF EXISTS `event_staff_count` //
CREATE FUNCTION event_staff_count
(e_name VARCHAR(50), s_date DATE) RETURNS INTEGER
BEGIN
DECLARE staff_count INTEGER default 0;
select count(*) into staff_count from assign_to where
event_name = e_name and event_start = s_date;
RETURN staff_count;
END//

DELIMITER //
DROP FUNCTION IF EXISTS `event_duration` //
CREATE FUNCTION event_duration
(s_date DATE, e_date DATE) RETURNS INTEGER
BEGIN
DECLARE duration INTEGER default 0;
select DATEDIFF(e_date, s_date) into duration;
RETURN duration;
END // 

DELIMITER //
DROP FUNCTION IF EXISTS `event_total_visits` //
CREATE FUNCTION event_total_visits
(e_name VARCHAR(50), s_date DATE) RETURNS INTEGER
BEGIN
DECLARE c_visits INTEGER default 0;
select count(*) into c_visits from visit_event where event_name = e_name
and event_start = s_date;
RETURN c_visits;
END//

# Screen 26: Manager View/Edit Event (endpoint: ‘/m_edit_event’)
# View_Event:
DELIMITER //
DROP PROCEDURE IF EXISTS `m_edit_event`//
CREATE PROCEDURE m_edit_event
(IN e_name VARCHAR(50), IN s_date DATE)
BEGIN
SELECT event_name, event_price, event_start, end_date, min_staff, capacity, description
from event where event_name = e_name and event_start = s_start;
END//

DELIMITER //
DROP PROCEDURE IF EXISTS `event_staffs`//
CREATE PROCEDURE event_staffs
(IN e_name VARCHAR(50), IN s_date DATE)
BEGIN
select CONCAT(first_name, ' ', last_name) as staff, username
from user where username in (SELECT staff_username from assign_to
where event_name = e_name and event_start = s_date);
END//


DELIMITER //
DROP PROCEDURE IF EXISTS `event_report` //
CREATE PROCEDURE event_report
(IN e_name VARCHAR(50), IN s_date DATE, IN price DECIMAL(10, 2))
BEGIN
SELECT visit_date, count(*) visits, count(*) * price
from visit_event where event_name = e_name and event_start = s_date
GROUP BY visit_date order by visit_date;
END//


# Update_Event:
-- UPDATE EVENT TABLE --
DELIMITER //
DROP PROCEDURE IF EXISTS `update_event` //
CREATE PROCEDURE update_event
(IN e_name VARCHAR(50), IN s_date DATE, IN new_decription VARCHAR(255))
BEGIN
UPDATE event
SET description = new_description
where event_name = e_name and event_start = s_date;
END//

-- UPDATE ASSIGN_TO TABLE --
DELIMITER //

DROP PROCEDURE IF EXISTS `update_assign_to`//
CREATE PROCEDURE update_assign_to
(IN e_name VARCHAR(50), IN s_date DATE, IN staffs VARCHAR(255))
BEGIN
DECLARE prev_staffs VARCHAR(255);
SELECT GROUP_CONCAT(staff_username SEPARATOR ',') into prev_staffs
from assign_to where event_name = e_name and event_start = s_date;
delete from assign_to 
where event_name = e_name 
and event_start = s_date 
and not find_in_set(staff_username, staffs);

END//



# Screen 27: Manager Create Event (endpoint: ‘/m_create_event’)
-- INSERT INTO event VALUES (?, ?, ?, ?, ?, ?, ?, ?);"""
# Screen 28: Manager Manage Staff (endpoint: ‘/m_manage_staff’)
# Screen 29: Manager Site Report (endpoint: ‘/m_site_report’)

DELIMITER //
DROP PROCEDURE IF EXISTS `site_report`//
CREATE PROCEDURE site_report
(IN manager VARCHAR(25), IN s_date Date, IN e_date Date)
BEGIN
select name from site where manager_username = manager;
select visit_date, count(*) from visit_site
where site_name = 'Inman Park' group by visit_date;

select visit_date, count(*) as e_visits from visit_event
where site_name = 'Inman Park' group by visit_date order by visit_date;

END//

# Screen 30: Manager Daily Detail (endpoint: ‘/m_daily_detail’)
# Screen 31: Staff View Schedule (endpoint: ‘/s_view_schedule’)
# Screen 32: Staff Event Detail (endpoint: ‘/s_event_detail’)
# Screen 33: Visitor Explore Event (endpoint: ‘/v_explore_event’)
# Screen 34: Visitor Event Detail (endpoint: ‘/v_event_detail’)
# view_event_detail:
# Screen 35: Visitor Explore Site (endpoint: ‘/v_explore_site’)
# Screen 36: Visitor Transit Detail (endpoint: ‘/v_transit_detail’)
# get_transit_detail:
# Screen 37: Visitor Site Detail (endpoint: ‘/v_site_detail’)
#	Task 1: View Site Detail
SELECT SiteName AS Site, SiteAddress, SiteZipCode, OpenEveryday FROM Site WHERE SiteName = ?;"""
#	Task 2: Log Visit
CREATE PROCEDURE log_visit
	@username varchar(50),
	@site_name varchar(50),
	@visit_date date
	AS
	INSERT INTO visit_site 
	VALUES (@username, @site_name, @visit_date)
	GO;

# Screen 38: Visitor Visit History (endpoint: ‘/v_visit_history’)
#	Task 1: Filter Visit History
"""CREATE PROCEDURE filter_visitor_visits
	AS
	SELECT visit_event.visit_date AS Date, visit_event.event_name AS Name, visit_event.site_name AS Site, event.event_price AS Price FROM visit_event, event
UNION ALL
SELECT visit_site.visit_date AS Date, NULL AS Name, visit_site.site_name AS Site, 0 AS Price FROM visit_site
GO;
"""


# Views: 什么哎呀

