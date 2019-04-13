# ERROR MESSAGES
wrong_pw = "WRONG_PASSWORD"
email_not_exists = "EMAIL_NOT_EXISTS"
username_taken = "USERNAME_TAKEN"
email_already_exists = "EMAIL_ALREADY_EXISTS"


# SUCCESS MESSAGES
account_exists = "ACCOUNT_EXISTS"
register_successfully = "REGISTER_SUCCESSFULLY"


# QUERIES

# 1) LOGIN SCREEN
validate_user = """
SELECT email, pword, username1
    FROM (SELECT username as username1, email FROM user_email) email_t 
    JOIN 
    (SELECT username, pword FROM user) user_t ON (user_t.username = email_t.username1) where email=\"{email}\""""
