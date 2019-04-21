register_user = """
call register_user(\'{}\', \'{}\', \'{}\', \'{}\', \'{}\')
"""
check_exist = """
select * from user_email where username=\'{}\'
"""

find_email = """
select * from user_email where email=\'()\'
"""

register_visitor = """
CALL register_helper_1(p_username, p_fname, p_lname, p_pw, “Visitor”, p_emails);
"""