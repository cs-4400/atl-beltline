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
    query = queries.validate_user.format(email)
    print(query)
    cur.execute(query)
    data = cur.fetchall()
    print(data)
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

@app.route('/get_user_info')
def get_user_info():
    username = request.args.get('username')
    query = queries.get_user_info.format(username)
    cur.execute(query)
    data = cur.fetchall()
    return json.dumps(data)

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
        query = queries.get_transit
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

@app.route('/a_manage_user', methods=['GET', 'POST']) #Screen 18
def a_manage_user():
    if request.method == 'POST':
        data = request.get_json()
        username = data['username']
        status = data['status']
        query = queries.approve.format(status, username)
        print(query)
        try:
            cur.execute(query)
            return "UPDATE_SUCCESS"
        except:
            return "BIGFATERRO"

    else:
        query = queries.manage_user
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


@app.route('/a_create_site', methods=['GET', 'POST']) #Screen 21
def a_create_site():
    if request.method == 'POST':
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
            return "ITSALLGOOD"
        except:
            return "ITS BROKEN"

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

# Screen 22
@app.route('/manage_transit')
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

# Screen 23 : POST DONE, GET NOT DONE
@app.route('/a_edit_transit', methods=['GET', 'POST'])
def a_edit_transit():
    if request.method == 'POST':
        data = request.get_json()
        old_type = data['old_type']
        old_route = data['old_route']
        new_type = data['type']
        new_route = data['route']
        new_price = data['price']
        sites = data['sites']
        query = queries.update_transit.format(old_type, old_route, new_type,
                                              new_route, new_price, sites)
        try:
            cur.execute(query)
            return "ITSALLGOOD"
        except:
            print("ITAINTGOOD, YOUGOTERROR")

    else:
        print("IM IN COMPLETE")

@app.route('/a_create_transit', methods=['POST']) #Screen 24
def a_create_transit():
    data = request.get_json()
    type = data['type']
    route = data['route']
    price = data['price']
    connected_sites = data['sites']
    query = queries.create_transit.format(type, route, price, connected_sites)
    try:
        cur.execute(query)
        return "ITSALLGOOD"
    except:
        return "YOUHAVEFAILEDME"

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

@app.route('/m_edit_event', methods=['GET', 'POST']) #Screen 26 --Come back to later...  may need multiple urls or extensions
def m_edit_event():
    if request.method == 'POST':
        data = request.get_json()
        event_name = data['event_name']
        event_start = data['event_start']
        description = data['new_descr']
        staffs = data['staffs']
        query = queries.update_event.format(event_name, event_start, description, staffs)
        print(query)
        try:
            cur.execute(query)
            return "ITSALLGOOD"
        except:
            print("BIGFATERROR")

    else:
        print('FINISH ME')


# Screen 27
@app.route('/m_create_event', methods=['GET', 'POST'])
def m_create_event():
    if request.method == 'POST':
        data = request.get_json()
        event_name = data['event_name']
        event_start = data['event_start']
        site_name = data['site_name']
        end_date = data['end_date']
        min_staff = data['min_staff']
        price = data['price']
        capacity = data['capacity']
        description = data['description']
        staffs = data['staffs']
        query = queries.create_event.format(event_name, event_start,
                                     end_date, min_staff, site_name,
                                     price, capacity, description, staffs)
        cur.execute(query)
        return "ITSALLGOOD"

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


# Screen 28
@app.route('/m_manage_staff')
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

# Screen 29
@app.route('/m_site_report')
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


# Screen 30
@app.route('/m_daily_detail')
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


# Screen 31
@app.route('/s_view_schedule')
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


# Screen 32 -----------FRANK MARKED NOT DONE
@app.route('/s_event_detail')
def s_event_detail():
    event_name = request.args.get('event_name')
    site_name = request.args.get('site_name')
    start_date = request.args.get('start_date')
    query = queries.get_event_staff_detail.format(event_name, site_name, start_date)
    print(query)
    cur.execute(query)
    staffs = cur.fetchall()

    print(staffs)
    eventList = []

    for events in staffs:
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

# Screen 33
@app.route('/v_explore_event')
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

# Screen 34
@app.route('/v_event_detail', methods=['GET', 'POST'])
def v_event_detail():
    if request.method == 'POST':
        data = request.get_json()
        username = data['username']
        event_name = data['event_name']
        event_start = data['event_start']
        site_name = data['site_name']
        visit_date = data['visit_date']
        query = queries.log_event_visit(username, event_name, event_start, site_name, visit_date)
        try:
            cur.execute(query)
            return "IT'SALLGOOD"
        except:
            print()
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


# Screen 35
@app.route('/v_explore_site')
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

# Screen 36
@app.route('/v_transit_detail', methods=['GET', 'POST']) #Screen 36- GET DONE, POST NOT DONE
def v_transit_tranit():
    if request.method == 'POST':
        data = request.get_json()
        username = data['username']
        t_type = data['type']
        route = data['route']
        transit_date = data['transit_date']
        query = queries.log_transit.format(username, t_type, route, transit_date)
        print(query)
        try:
            cur.execute(query)
            return "ITSALLGOOD"
        except:
            print()
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

# Screen 37
@app.route('/v_site_detail', methods=['GET', 'POST'])
def v_site_detail():
    if request.method == 'POST':
        data = request.get_json()
        date = data['date']
        username = data['username']
        site_name = data['site_name']
        query = log_queries.log_site.format(username, site_name, date)
        print(query)
        try:
            cur.execute(query)
            return log_queries.updated
        except:
            print()
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

# Screen 38
@app.route('/v_visit_history')
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
