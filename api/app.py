from flask import Flask
from flask import request
# import MySQLdb
import pymysql as mysql
import json
from api import queries
from api import register_queries
from flask_cors import CORS
from flask_api import status
from api import log_queries
from api import site_queries
app = Flask(__name__)
CORS(app)

conn = mysql.connect(host="localhost", user="cs4400user", passwd="password", db="atl_beltline")  # name of the database

# Create a Cursor object to execute queries.
cur = conn.cursor()


# EACH SCREEN SHOULD HAVE ITS OWN ROUTE
#
@app.route('/validate_login') #Screen 1
def validate_login():
    email = request.args.get('email')
    pw = request.args.get('password')
    query = queries.validate_user.format(email=email)
    cur.execute(query)
    data = cur.fetchall()
    username = data[0][2]
    if len(data) < 1:
        return json.dumps({
            'message': queries.email_not_exists,
        })
    if pw != data[0][1]:
        return json.dumps({
            'message': queries.wrong_pw
        })

    username = '' + data[0][1] + ''
    password = '' + data[0][2]
    user_type = '' + data[0][3]

    return json.dumps({
        'message': queries.account_exists,
        'username': username,
        'password': password,
        'user_type': user_type
    })


@app.route('/find_email')
def find_email():
    email = request.args.get('email')
    query = register_queries.find_email.format(email)
    cur.execute(query)
    exist = cur.fetchall()
    if len(exist) > 0:
        return queries.email_already_exists
    return "200"


@app.route('/register_user', methods=['POST']) #Screen 3
def register_user():
    data = request.get_json()
    username = data['username']
    email = data['email']
    fname = data['fname']
    lname = data['lname']
    pw = data['pw']
    query = register_queries.register_user.format(username, fname, lname, pw, email)
    print(query)
    check_exist = register_queries.check_exist.format(username)
    cur.execute(check_exist)
    exist = cur.fetchall()
    if len(exist) > 0:
        print('this shit exists')
        return queries.username_taken
    cur.execute(query)
    return queries.register_successfully


@app.route('/register_visitor', methods=['POST']) #Screen 4
def register_visitor():
    data = request.get_json()
    username = data['username']
    email = data['email']
    fname = data['fname']
    lname = data['lname']
    pw = data['pw']
    query = register_queries.register_visitor.format(username, fname, lname, pw, email)
    check_exist = register_queries.check_exist.format(username)
    print(query)
    cur.execute(check_exist)
    exist = cur.fetchall()
    if len(exist) > 0:
        return queries.username_taken
    cur.execute(query)
    return queries.register_successfully


@app.route('/register_employee', methods=['POST']) #Screen 5
def register_employee():
    data = request.get_json()
    print(data)
    username = data['username']
    fname = data['fname']
    lname = data['lname']
    pw = data['pw']
    phone = data['phone']
    address = data['address']
    city = data['city']
    state = data['state']
    zip = data['zip']
    emp_type = data['emp_type']
    emp_id = data['empID']
    emails = data['emails']
    query = register_queries.register_employee.format(username, fname, lname, pw, phone,
                                                      address, city, state, zip,
                                                      emp_type, emp_id, emails)
    check_exist = register_queries.check_exist.format(username)
    print(query)
    cur.execute(check_exist)
    exist = cur.fetchall()
    if len(exist) > 0:
        return queries.username_taken
    cur.execute(query)
    return queries.register_successfully


@app.route('/register_emp_visitor', methods=['POST']) #Screen 6
def register_employee_visitor():
    data = request.get_json()
    print(data)
    username = data['username']
    fname = data['fname']
    lname = data['lname']
    pw = data['pw']
    phone = data['phone']
    address = data['address']
    city = data['city']
    state = data['state']
    zip = data['zip']
    emp_type = data['emp_type']
    emp_id = data['empID']
    emails = data['emails']
    query = register_queries.register_employee_visitor.format(username, fname, lname, pw, phone,
                                                              address, city, state, zip,
                                                              emp_type, emp_id, emails)
    check_exist = register_queries.check_exist.format(username)
    print(query)
    cur.execute(check_exist)
    exist = cur.fetchall()
    if len(exist) > 0:
        return queries.username_taken
    cur.execute(query)
    return queries.register_successfully


@app.route('/takes_transit', methods=['GET', 'POST']) #Screen 15
def takes_transit():
    if request.method == 'POST':
        data = request.get_json()
        username = data['username']
        _type = data['type']
        route = data['route']
        transit_date = data['log_date']
        query = log_queries.take_transit.format(username, _type, route, transit_date)
        try:
            cur.execute(query)
            return queries.register_successfully
        except mysql.err.IntegrityError:
            return log_queries.already_logged
    else:
        return ''

    if request.method == 'POST':
        data = request.get_json()

    else:
        query = queries.get_tranits
        cur.execute(query)
        data = cur.fetchall()

        transitList = []

        for transits in data:
            transit = {}
            transit['route'] = transits[0]
            transit['type'] = transits[1]
            transit['price'] = str(transits[2])
            transit['connected_sites'] = str(transits[3])
            transitList.append(transit)

        return json.dumps(
            transitList
        )




@app.route('/transit_history') #Screen 16
def transit_history():
    username = request.args.get('username')
    query = queries.get_transit_history.format(username=username)
    cur.execute(query)
    data = cur.fetchall()
    transitList = []

    for transit in data:
        tran = {}
        tran['date'] = str(transit[0])
        tran['route'] = transit[1]
        tran['transport_type'] = transit[2]
        tran['price'] = transit[3]
        transitList.append(tran)

    return json.dumps(
        transitList
    )

@app.route('/e_manage_profile') #Screen 17
def e_manage_profile():
    username = request.args.get('username')
    query = queries.manage_profile.format(username=username)
    cur.execute(query)
    data = cur.fetchall()

    profile = []

    for users in data:
        user = {}
        user['first_name'] = users[0]
        user['last_name'] = users[1]
        user['username'] = users[2]
        user['email'] = users[3]
        user['emp_ID'] = str(users[4])
        user['phone'] = users[5]
        user['address'] = users[6]
        user['city'] = users[7]
        user['state'] = users[8]
        user['zip'] = users[9]
        user['site_name'] = users[10]
        profile.append(user)

    return json.dumps(
        profile
    )

@app.route('/a_manage_user') #Screen 18
def a_manage_user():
    username = request.args.get('username')
    query = queries.manage_user.format(username)
    cur.execute(query)
    data = cur.fetchall()

    details = []

    for infos in data:
        info = {}
        info['username'] = infos[0]
        info['email_count'] = str(infos[1])
        info['user_type'] = infos[2]
        info['status'] = infos[3]
        details.append(info)

    return json.dumps(
        details
    )


@app.route('/a_manage_site') #Screen 19
def a_manage_site():
    query = queries.manage_site
    cur.execute(query)
    data = cur.fetchall()

    siteList = []

    for sites in data:
        site = {}
        site['site_name'] = sites[0]
        site['name'] = sites[1]
        site['open_everyday'] = sites[2]
        siteList.append(site)

    return json.dumps(
        siteList
    )



@app.route('/edit_site', methods=['GET', 'POST']) #Screen 20
def a_edit_site():
    if request.method == 'POST':
        data = request.get_json()
        new_name = data['new_name']
        new_zip = data['new_zip']
        new_address = data['new_address']
        new_manager = data['new_manager']
        new_open = data['new_open']
        old_name = data['old_name']
        query = log_queries.update_site.format(new_name, new_zip, new_address, new_manager, new_open, old_name)
        cur.execute(query)
        return log_queries.updated
    else:
        site_name = request.args.get('site_name')
        cur.execute(log_queries.get_manager)
        managers = cur.fetchall()
        query = log_queries.display_site.format(site_name)
        print(query)
        cur.execute(query)
        data = cur.fetchall()
        return json.dumps([
            {
                'manager': data[0][0],
                'manager_username': data[0][1],
                'address': data[0][2],
                'zipcode': data[0][3],
                'open': data[0][4]
            },
            managers
        ])


@app.route('/create_site', methods=['POST']) #Screen 21
@app.route('/a_create_site', methods=['GET', 'POST']) #Screen 21
def a_create_site():
    data = request.get_json()
    name = data['name']
    address = data['address']
    zip = data['zip']
    manager = data['manager']
    open = data['open']
    query = site_queries.create_site.format(name, address, zip, manager, open)
    print(query)
    try:
        cur.execute(query)
    except:
        print()
    if request.method == 'POST':
        data = request.get_json()


    else:
        query = queries.get_unassigned_managers
        cur.execute(query)
        data = cur.fetchall()

        managerList = []

        for managers in data:
            manager = {}
            manager['manager_name'] = managers[0]
            managerList.append(manager)

        return json.dumps(
            managerList
        )




@app.route('/manage_transit') #Screen 22
def a_manage_transit():


    query = queries.manage_transit
    cur.execute(query)
    data = cur.fetchall()

    transitList = []

    for transits in data:
        transit = {}
        transit['type'] = transits[0]
        transit['route'] = transits[1]
        transit['price'] = str(transits[2])
        transit['num_sites'] = str(transits[3])
        transit['num_log'] = str(transits[4])
        transitList.append(transit)

    return json.dumps(
        transitList
    )

@app.route('/a_edit_transit', methods=['GET', 'POST']) #Screen 23
def a_edit_transit():
    pass

@app.route('/a_create_transit', methods=['POST']) #Screen 24
def a_create_transit():
    pass

@app.route('/m_manage_event') #Screen 25
def m_manage_event():
    query = queries.manage_event
    cur.execute(query)
    data = cur.fetchall()

    eventList = []

    for events in data:
        event = {}
        event['event_name'] = events[0]
        event['staff_count'] = str(events[1])
        event['duration'] = str(events[2])
        event['total_visits'] = str(events[3])
        event['total_revenue'] = str(events[4])
        eventList.append(event)

    return json.dumps(
        eventList
    )

@app.route('/m_edit_event') #Screen 26 --Come back to later...  may need multiple urls or extensions
def m_edit_event():
    pass

@app.route('/m_create_event', methods=['GET', 'POST']) #Screen 27
def m_create_event():
    if request.method == 'POST':
        data = request.get_json()

    else:
        start_date = request.args.get('start_date')
        end_date = request.args.get('end_date')
        query = queries.get_available_staff.format(start_date=start_date, end_date=end_date)
        cur.execute(query)
        data = cur.fetchall()

        staffList = []

        for staffs in data:
            staff = {}
            staff['staff_name'] = staffs[0]
            staffList.append(staff)

        return json.dumps(
            staffList
        )


@app.route('/m_manage_staff') #Screen 28 - DONE
def m_manage_staff():
    site_name = request.args.get('site_name')
    query = queries.filter_staff.format(site_name=site_name)
    cur.execute(query)
    data = cur.fetchall()

    staffList = []

    for staffs in data:
        staff = {}
        staff['staff_name'] = staffs[0]
        staff['event_shifts'] = str(staffs[1])
        staffList.append(staff)

    return json.dumps(
        staffList
    )

@app.route('/m_site_report') #Screen 29
def m_site_report():
    site_name = request.args.get('site_name')
    start_date = request.args.get('start_date')
    end_date = request.args.get('end_date')
    query = queries.get_site_report.format(site_name=site_name, start_date=start_date, end_date=end_date)
    cur.execute(query)
    data = cur.fetchall()

    report = []

    for sites in data:
        site = {}
        site['date'] = str(sites[0])
        site['event_count'] = str(sites[1])
        site['staff_count'] = str(sites[2])
        site['total_visits'] = str(sites[3])
        site['total_revenue'] = str(sites[4])
        report.append(site)

    return json.dumps(
        report
    )


@app.route('/m_daily_detail') #Screen 30
def m_daily_detail():
    manager_username = request.args.get('manager_username')
    site = request.args.get('site')
    date = request.args.get('date')
    query = queries.get_daily_detail.format(manager_username=manager_username, site=site, date=date)
    cur.execute(query)
    data = cur.fetchall()

    detail = []

    for days in data:
        day = {}
        day['event_name'] = days[0]
        day['staff_names'] = [x.strip() for x in days[1].split(',')]
        day['visits'] = str(days[2])
        day['revenue'] = str(days[3])
        detail.append(day)

    return json.dumps(
        detail
    )



@app.route('/s_view_schedule') #Screen 31 - DONE
def s_view_schedule():
    staff_username = request.args.get('staff_username')
    query = queries.get_schedule.format(staff_username)
    cur.execute(query)
    data = cur.fetchall()

    siteList = []

    for sites in data:
        site = {}
        site['event_name'] = sites[0]
        site['site_name'] = sites[1]
        site['start_date'] = str(sites[2])
        site['end_date'] = str(sites[3])
        site['staff_count'] = str(sites[4])
        siteList.append(site)

    return json.dumps(
        siteList
    )


@app.route('/s_event_detail') #Screen 32 -ALMOST DONE FIGURE OUT HOW TO LOOP THROUGH EMPLOYEE LIST
def s_event_detail():
    event_name = request.args.get('event_name')
    site_name = request.args.get('site_name')
    start_date = request.args.get('start_date')
    query = queries.get_event_staff_detail.format(event_name, site_name, start_date)
    cur.execute(query)
    data = cur.fetchall()

    eventList = []

    for events in data:
        event = {}
        event['event'] = events[0]
        event['site'] = events[1]
        event['start_date'] = str(events[2])
        event['end_date'] = str(events[3])
        event['duration'] = str(events[4])
        event['staff_assigned'] = [x.strip() for x in events[5].split(',')]
        event['capacity'] = str(events[6])
        event['ticket_price'] = str(events[7])
        event['description'] = events[8]
        eventList.append(event)

    return json.dumps(
        eventList
    )


@app.route('/v_explore_event') #Screen 33 - DONE
def v_explore_event():
    username = request.args.get('username')
    query = queries.explore_event.format(username=username)
    cur.execute(query)
    data = cur.fetchall()

    eventList = []

    for events in data:
        event = {}
        event['event_name'] = events[0]
        event['site_name'] = events[1]
        event['ticket_price'] = str(events[2])
        event['tickets_remaining'] = str(events[3])
        event['total_visits'] = str(events[4])
        event['my_visits'] = str(events[5])
        eventList.append(event)

    return json.dumps(
        eventList
    )

@app.route('/v_event_detail', methods=['GET', 'POST']) #Screen 34 - GET DONE, POST NOT DONE
def v_event_detail():
    if request.method == 'POST':
        data = request.get_json()
        username = request.args.get('username')
        event_name = request.args.get('event_name')
        event_start = request.args.get('event_start')
        site_name = request.args.get('site_name')
        visit_date = request.args.get('visit_date')
        query = queries.log_event_visit(username=username, event_name=event_name, event_start=event_start, site_name=site_name, visit_date=visit_date)



    else:
        event_name = request.args.get('event_name')
        site_name = request.args.get('site_name')
        start_date = request.args.get('start_date')

        query = queries.get_event_detail.format(event_name, site_name, start_date)
        print(query)
        cur.execute(query)
        data = cur.fetchall()
        print(data)
        eventDetail = []

        for events in data:
            event = {}
            event['event_name'] = events[0]
            event['site_name'] = events[1]
            event['start_date'] = str(events[2])
            eventDetail.append(event)

        return json.dumps(
            eventDetail
        )



@app.route('/v_explore_site') #Screen 35 - DONE
def v_explore_site():
    username = request.args.get('username')
    query = queries.explore_site.format(username=username)
    cur.execute(query)
    data = cur.fetchall()

    siteList = []

    for sites in data:
        site = {}
        site['site_name'] = sites[0]
        site['event_count'] = str(sites[1])
        site['total_visits'] = str(sites[2])
        site['my_visits'] = str(sites[3])
        siteList.append(site)


    return json.dumps(
        siteList
    )


@app.route('/v_transit_detail', methods=['GET', 'POST']) #Screen 36- GET DONE, POST NOT DONE
def v_transit_tranit():
    if request.method == 'POST':
        data = request.get_json()



    else:
        type = request.args.get('type')
        route = request.args.get('route')
        query = queries.get_transit_detail.format(type, route)
        cur.execute(query)
        data = cur.fetchall()

        transitList = []

        for transits in data:

            transit = {}
            transit['route'] = transits[0]
            transit['type'] = transits[1]
            transit['price'] = transits[2]
            transit['connected_sites'] = str(transits[3])
            transitList.append(transit)

        return json.dumps(

            transitList
        )




@app.route('/v_site_detail', methods=['GET', 'POST']) #Screen 37 - GET DONE, POST NOT DONE
def v_site_detail():
    if request.method == 'POST':
        data = request.get_json()

    else:
        site_name = request.args.get('site_name')
        query = queries.get_site_detail.format(site_name=site_name)
        cur.execute(query)
        data = cur.fetchall()

        siteList = []

        for sites in data:
            site = {}
            site['site_name'] = sites[0]
            site['address'] = sites[1]
            site['open'] = sites[2]
            siteList.append(site)

        return json.dumps(
            siteList
        )


@app.route('/v_visit_history') #Screen 38 - DONE?
def v_visit_history():
    username = request.args.get('username')
    query = queries.visit_history.format(username)
    cur.execute(query)
    data = cur.fetchall()
    history = []
    for row in data:
        visit = {}
        visit['date'] = str(row[0])
        visit['event'] = row[1]
        visit['site'] = row[2]
        visit['price'] = row[3]
        history.append(visit)

    return json.dumps(history)



@app.route('/')
def main():
    return json.dumps({
        "test": "cAn We PlEaSe HiT 50 lIkEs????????"
    })


if __name__ == "__main__":
    app.run()
