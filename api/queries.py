# ERROR MESSAGES
wrong_pw = "WRONG_PASSWORD"
email_not_exists = "EMAIL_NOT_EXISTS"
username_taken = "USERNAME_TAKEN"
email_already_exists = "EMAIL_ALREADY_EXISTS"

# SUCCESS MESSAGES
account_exists = "LOGIN_SUCCESSFULLY"
register_successfully = "REGISTER_SUCCESSFULLY"

# \"{}\"
# QUERIES

# =================================================================
# Screen 1
validate_user = """
call login_user(\"{}\")"""

get_users = """
SELECT 
    email, password, uname1, user_type,
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
"""

# =================================================================
# Screen 15
get_transit = """
call get_transits()
"""
log_transit = """
call log_transit(\"{}\", \"{}\", \"{}\", \"{}\")
"""
# log_transit(IN p_username varchar(50), IN p_type varchar(25), IN p_route varchar(25),
#                              IN p_transit_date date)


# =================================================================
# Screen 16
get_transit_history = """
call transit_history(\"{username}\")
"""
# =================================================================
# Screen 17
manage_profile = """
call manage_profile(\"{username}\")
"""
# manage_profile(IN p_username varchar(50))

# =================================================================
# Screen 18
manage_user = """
call manage_user()
"""

approve = """
UPDATE user set status=\'{}\' where username = \'{}\'
"""
# manage_user(IN p_username varchar(50))
# =================================================================
# Screen 19
manage_site = """
call manage_site()
"""
# =================================================================
# Screen 20
# TODO

# =================================================================
# Screen 21
get_unassigned_managers = """
call get_unassigned_managers()
"""

create_site = """
call create_site(\"{site_name}\", \"{site_address}\", \"{site_zip}\", \"{manager_username}\", \"{open}\")
"""
# create_site(IN p_name varchar(50), IN p_address varchar(95), IN p_zip int, IN p_manager varchar(55),
#                              IN p_open varchar(50))

# =================================================================
# Screen 22
manage_transit = """
call manage_transit()
"""

# =================================================================
# Screen 23
display_transit = """
call display_transit(\"{type}\", \"{route}\")
"""
# display_transit(IN p_type varchar(25), IN p_route varchar(25))

update_transit = """
call update_transit(\"{}\", \"{}\", \"{}\", \"{}\", \"{}\", \"{}\")
"""
# update_transit(IN p_old_type varchar(25), IN p_old_route varchar(25), IN p_type varchar(25),
#                                 IN p_route varchar(25), IN p_price float, IN p_connected_sites varchar(255))

# =================================================================
# Screen 24
create_transit = """
call create_transit(\"{}\", \"{}\", \"{}\", \"{}\")
"""
# create_transit(IN p_type varchar(25), IN p_route varchar(25), IN p_price float,
#                                 IN p_connected_sites varchar(255))

# =================================================================
# Screen 25
manage_event = """
call manage_event()
"""

# =================================================================
# Screen 26
m_edit_event = """
call m_edit_event(\"{}\",\"{}\")
"""
# m_edit_event(IN e_name varchar(50), IN s_date date)

event_staffs = """
call event_staffs(\"{}\",\"{}\")
"""
# event_staffs(IN e_name varchar(50), IN s_date date)

event_report = """
call event_report(\"{}\",\"{}\",\"{}\")
"""
# event_report(IN e_name varchar(50), IN s_date date, IN price decimal(10, 2))

update_event = """
call update_event(\"{}\",\"{}\", \"{}\",\"{}\")
"""
# update_event(IN e_name varchar(50), IN s_date date, IN new_description varchar(255),
#                               IN staff_assigned varchar(255))


# =================================================================
# Screen 27
get_available_staff = """
call get_available_staff(\"{start_date}\",\"{end_date}\")
"""
# get_available_staff(IN p_start_date date, IN p_end_date date)

create_event = """
call create_event(\"{}\",\"{}\",\"{}\",\"{}\",\"{}\",\"{}\",\"{}\",\"{}\",\"{}\")
"""
# create_event(IN p_event_name varchar(50), IN p_event_start date, IN p_end_date date,
#                               IN p_min_staff int, IN p_site_name varchar(50), IN p_price float, IN p_capacity int,
#                               IN p_description varchar(255), IN staff_assigned varchar(255))

# =================================================================
# Screen 28
filter_staff = """
call filter_staff(\"{site_name}\")
"""
# filter_staff(IN p_site_name varchar(50))

# =================================================================
# Screen 29
get_site_report = """
call get_site_report(\"{site_name}\",\"{start_date}\",\"{end_date}\")
"""
# get_site_report(IN p_site_name varchar(50), IN p_start_date date, IN p_end_date date)

# =================================================================
# Screen 30
get_daily_detail = """
call get_daily_detail(\"{manager_username}\",\"{site}\",\"{date}\")
"""
# get_daily_detail(IN p_manager_username varchar(50), IN p_site varchar(50), IN p_date date)
# =================================================================
# Screen 31
get_schedule = """
call get_schedule(\"{}\")
"""
# get_schedule(IN p_staff_username varchar(50))

# =================================================================
# Screen 32 #WARNING IF DIDN'T WORK MAKE SURE THE RIGHT VERSION OF SQL SCRIPT IS RUN
get_event_staff_detail = """
call get_event_staff_detail(\'{}\', \'{}\', \'{}\')
"""
# get_event_staff_detail(IN p_event_name varchar(50), IN p_site_name varchar(50), IN p_start_date date)
# =================================================================
# Screen 33
explore_event = """
call explore_event(\"{username}\")
"""
# explore_event(IN p_username varchar(50))

# =================================================================
# Screen 34
get_event_detail = """
call get_event_detail(\'{}\', \'{}\', \'{}\')
"""
# get_event_detail(IN p_name varchar(50), IN p_site_name varchar(50), IN p_start_date date)

log_event_visit = """
call log_event_visit(\"{}\",\"{}\",\"{}\", \"{}\, \"{}\)
"""
# log_event_visit(
#     IN p_username varchar(50),
#     IN p_event_name varchar(50),
#     IN p_event_start varchar(50),
#     IN p_site_name varchar(50),
#     IN p_visit_date date)
# =================================================================
# Screen 35
explore_site = """
call explore_site(\"{username}\")
"""
# explore_site(IN p_username varchar(50))

# =================================================================
# Screen 36
get_transit_detail = """
call get_transit_detail(\"{}\",\"{}\")
"""
# get_transit_detail(IN p_type varchar(25), IN p_route varchar(25))

#NOTE log_transit is created TWICE
# log_transit = """
# call log_transit(\"{username}\", \"{type}\", \"{route}\", \"{date}\")
# """
# =================================================================
# Screen 37
get_site_detail = """
call get_site_detail(\"{site_name}\")
"""
# get_site_detail(IN p_name varchar(50))

log_site_visit = """
call log_site_visit(\"{username}\", \"{site_name}\", \"{visit_date}\")
"""
# log_site_visit(IN p_username varchar(50), IN p_site_name varchar(50), IN p_visit_date date)

# =================================================================
# Screen 38
visit_history = """
call filter_visitor_visits(\"{}\")
"""
