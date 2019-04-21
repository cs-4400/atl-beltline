# ERROR MESSAGES
wrong_pw = "WRONG_PASSWORD"
email_not_exists = "EMAIL_NOT_EXISTS"
username_taken = "USERNAME_TAKEN"
email_already_exists = "EMAIL_ALREADY_EXISTS"

# SUCCESS MESSAGES
account_exists = "LOGIN_SUCCESSFULLY"
register_successfully = "REGISTER_SUCCESSFULLY"

# QUERIES

# 1) LOGIN SCREEN
validate_user = """
call login_user(\"{email}\")"""

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
# Screen 16
get_transit_history = """
call transit_history(\"{username}\")
"""
# =================================================================
# Screen 17
e_manage_user = """
"""

# Screen 38
visit_history = """
call filter_visitor_visits(\"{}\")
"""


# =================================================================
#Screen 29
# get_site_report