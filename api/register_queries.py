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
call register_visitor(\'{}\', \'{}\', \'{}\', \'{}\', \'{}\')
"""

register_employee = """call register_employee( \'{}\',  \'{}\',  \'{}\',  \'{}\',  \'{}\',  \'{}\',  \'{}\',  \'{}\', \'{}\',  \'{}\', \'{}\', \'{}\')"""

register_employee_visitor = """call register_employee_visitor( \'{}\',  \'{}\',  \'{}\',  \'{}\',  \'{}\',  \'{}\',  \'{}\',  \'{}\', \'{}\',  \'{}\', \'{}\', \'{}\')"""
