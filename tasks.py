"""CS 4400 Phase 3 Task List"""

# Screen 1: User Login (endpoint: '/validate_login')
"""
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
    email = \"{email}\"
"""



# Screen 3: Register User Only (endpoint: ‘/register_user’)
"""INSERT INTO user VALUES (?, ?, ?, ?, ?)"""
"""INSERT INTO user_email VALUES (?, ?)"""

#Screen 4: Register Visitor Only (endpoint: ‘/register_visitor’)
"""INSERT INTO visitor VALUES (?, ?)"""
"""INSERT INTO user_email VALUES(?, ?)"""

# Screen 5: Register Employee Only (endpoint: ‘/register_employee’)
#	Task 1: Register Employee
"""INSERT INTO employee VALUES (?, ?, ?, ?, ?, ?, ?)"""
"""INSERT INTO user_email VALUES(?, ?)"""


# Screen 6: Register Employee-Visitor (endpoint: ‘/register_employee-visitor’)
"""INSERT INTO visitor VALUES (?, ?)"""
"""INSERT INTO employee VALUES (?, ?, ?, ?, ?, ?, ?)"""
"""INSERT INTO user_email VALUES(?, ?)"""

# Screen 15: User Take Transit (endpoint: ‘/take_transit’)
"""INSERT INTO take_transit VALUES (?, ?, ?, ?)"""

# Screen 16: User Transit History (endpoint: ‘/transit_history’)
"""SELECT * FROM take_transit WHERE username = ?"""


# Screen 17: Employee Manage Profile (endpoint: ‘/e_manage_profile’)
"""
DELIMITER //
DROP PROCEDURE IF EXISTS `manage_profile` //
CREATE PROCEDURE manage_profile(IN p_username varchar(50))
begin
SELECT first_name, last_name, uname1 AS username, email, emp_ID, phone, address, city, state, zip, site_name
FROM
    (SELECT first_name, last_name, uname1, email
    FROM
        (SELECT first_name, last_name, username AS uname1
    FROM
        user
    WHERE
        username = p_username) user_t
    JOIN (SELECT email, username AS uname2
    FROM
        user_email
    WHERE
        username = p_username) email_t ON (user_t.uname1 = email_t.uname2)) t_1
        JOIN
    (SELECT uname2, phone, address, city, state, zip, site_name, emp_ID
    FROM
        (SELECT username AS uname1, phone, address, city, state, zip, emp_ID
    FROM
        employee
    WHERE
        username = p_username) emp_t
    JOIN (SELECT manager_username AS uname2, name AS site_name
    FROM
        site
    WHERE
        manager_username = p_username) site_t ON (emp_t.uname1 = site_t.uname2)) t_2 ON (t_1.uname1 = t_2.uname2);
end//
"""
# Screen 18: Administrator Manage User(endpoint: ‘/a_manage_user’)
"""
SELECT 
    uname1 AS username, email_count, user_type, status
FROM
    (SELECT 
        username AS uname1, COUNT(*) AS email_count
    FROM
        user_email
    WHERE
        username = 'manager1'
    GROUP BY username) email_t
        JOIN
    (SELECT 
        user_type, status, username AS uname2
    FROM
        user
    WHERE
        username = 'manager1') user_t ON (email_t.uname1 = user_t.uname2)
"""
# Screen 19: Administrator Manage Site(endpoint: ‘/a_manage_site’)
"""
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
        user) user_t ON (site_t.uname1 = user_t.uname2)
"""
# Screen 20: Administrator Edit Site (endpoint: ‘/a_edit_site’)
# Screen 21: Administrator Create Site (endpoint: ‘/a_create_site)
# Screen 22: Administrator Manage Transit (endpoint: ‘/a_manage_transit’)
# Screen 23: Administrator Edit Transit (endpoint: ’/a_edit_transit’)
# Screen 24: Administrator Create Transit (endpoint: ‘/a_create_transit’)
"""INSERT INTO transit VALUES (?, ?, ?);"""
# Screen 25: Manager Manage Event (endpoint: ‘/m_manage_event’)
# Screen 26: Manager View/Edit Event (endpoint: ‘/m_edit_event’)
# View_Event:
# Update_Event:
# Screen 27: Manager Create Event (endpoint: ‘/m_create_event’)
"""INSERT INTO event VALUES (?, ?, ?, ?, ?, ?, ?, ?);"""
# Screen 28: Manager Manage Staff (endpoint: ‘/m_manage_staff’)
# Screen 29: Manager Site Report (endpoint: ‘/m_site_report’)
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
"""SELECT name AS site, address, zipcode, open_everyday FROM site WHERE name = ?;"""
#	Task 2: Log Visit
"""CREATE PROCEDURE log_visit
	@username varchar(50),
	@site_name varchar(50),
	@visit_date date
	AS
	INSERT INTO visit_site 
	VALUES (@username, @site_name, @visit_date)
	GO;"""

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


