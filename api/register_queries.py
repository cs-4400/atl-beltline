# not done ==========
register_user = """
call register_user(\'{}\', \'{}\', \'{}\', \'{}\', \'{}\', \'{}\')
"""
check_exist = """
select * from user_email where username=\'{}\' or email=\'{}\' 
"""
