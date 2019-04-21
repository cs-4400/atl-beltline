already_logged = "TRANSIT_ALREADY_LOGGED"
updated = "UPDATED"

take_transit = """
call log_transit(\'{}\', \'{}\', \'{}\', \'{}\')
"""

check_transit_log_exists = """
select * from take_transit
where username = \'{}\'
and date = \'{}\'
and type = \'{}\'
and route = \'{}\'
"""

update_site = """
call update_site(\'{}\', \'{}\', \'{}\', \'{}\', \'{}\', \'{}\')
"""

display_site = """
call display_edit_site(\'{}\')
"""

get_manager = """
call get_managers()
"""

log_site = """
call log_site_visit(\'{}\', \'{}\', \'{}\')
"""

log_event = """
call log_event_visit(\'{}\', \'{}\', \'{}\', \'{}\', \'{}\')
"""