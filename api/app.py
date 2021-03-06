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
import hashlib
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
    # print(query)
    cur.execute(query)
    data = cur.fetchall()
    # print(data)
    if len(data) < 1:
        return json.dumps({
            'message': queries.email_not_exists,
        })

    query2 = queries.validate_user2.format(email, pw)
    print(query2)
    cur.execute(query2)
    passw = cur.fetchall()
    print(passw)
    # print("Data:" + data[0][1])
    # if pw != data[0][1]:
    if len(passw) < 1:
        return json.dumps({
            'message': queries.wrong_pw
        })

    username = '' + data[0][2] + ''
    password = '' + data[0][1]
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
    print(query)
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
    conn.commit()
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
    conn.commit()
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
    conn.commit()
    return queries.register_successfully

@app.route('/check_emp_id')
def check_emp_id():
    data = request.args.get('emp_id')
    query = queries.check_dup_emp_id.format(data)
    cur.execute(query)
    vals = cur.fetchall()
    if len(vals) > 0:
        return "EMP_ID_EXISTS"
    return "SAFE"

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
    emp_id = data['emp_id']
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
    conn.commit()
    return queries.register_successfully


@app.route('/takes_transit', methods=['GET', 'POST']) #Screen 15
def takes_transit():
    if request.method == 'POST':
        data = request.get_json()
        username = data['usernamea']
        _type = data['type']
        route = data['route']
        transit_date = data['log_date']
        query = log_queries.take_transit.format(username, _type, route, transit_date)
        try:
            cur.execute(query)
            conn.commit()
            return queries.register_successfully
        except mysql.err.IntegrityError:
            return log_queries.already_logged
    else:
        query = queries.get_transit
        cur.execute(query)
        data = cur.fetchall()

        transit_detail = []

        transitList = []

        for transits in data:
            transit = {}
            transit['route'] = transits[0]
            transit['type'] = transits[1]
            transit['price'] = str(transits[2])
            transit['connected_sites'] = str(transits[3])
            transitList.append(transit)

        query2 = queries.get_sites
        cur.execute(query2)
        data2 = cur.fetchall()

        siteList = []

        for sites in data2:
            site = {}
            site['name'] = sites[0]
            siteList.append(site)


        transit_detail.append(transitList)
        transit_detail.append(siteList)
        print(transit_detail)

        return json.dumps(
            transit_detail
        )

@app.route('/transit_history') #Screen 16
def transit_history():
    username = request.args.get('username')
    query = queries.get_transit_history.format(username=username)
    cur.execute(query)
    data = cur.fetchall()

    transit_details = []

    transitList = []

    for transit in data:
        tran = {}
        tran['date'] = str(transit[0])
        tran['route'] = transit[1]
        tran['transport_type'] = transit[2]
        tran['price'] = transit[3]
        transitList.append(tran)

    query2 = queries.get_sites
    cur.execute(query2)
    data2 = cur.fetchall()

    siteList = []

    for sites in data2:
        site = {}
        site['name'] = sites[0]
        siteList.append(site)

    transit_details.append(transitList)
    transit_details.append(siteList)

    return json.dumps(
        transit_details
    )

@app.route('/e_manage_profile', methods=['GET','POST']) #Screen 17
def e_manage_profile():
    if request.method == 'GET':
        username = request.args.get('username')
        username = request.args.get('username')
        query = queries.manage_profile.format(username)
        cur.execute(query)
        data = cur.fetchall()
        print(data)
        profile = []
        for users in data:
            user = {}
            user['first_name'] = users[0]
            user['last_name'] = users[1]
            user['username'] = users[2]
            user['site_name'] = users[3]
            user['emp_ID'] = str(users[4])
            user['phone'] = users[5]
            user['address'] = users[6]
            user['email'] = users[7]
            profile.append(user)

        return json.dumps(
            profile
        )

    else:
        data2 = request.get_json()
        fname = data2['fname']
        lname = data2['lname']
        phone = data2['phone']
        emails = data2['emails']
        emp_ID = data2['emp_id']
        query = queries.update_profile.format(emp_ID, fname, lname, phone, emails)
        print(query)
        try:
            cur.execute(query)
            conn.commit()
            return "UPDATE_SUCCESS"
        except:
            return "BIGFATERRO"

@app.route('/a_manage_user', methods=['GET', 'POST']) #Screen 18
def a_manage_user():
    if request.method == 'POST':
        data = request.get_json()
        username = data['username']
        status = data['status']
        # query = queries.approve.format(status, username)
        query = queries.change_user_status.format(username, status)
        print(query)
        try:
            cur.execute(query)
            conn.commit()
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

    all_siteLists = []

    siteList = []

    for sites in data:
        site = {}
        site['site_name'] = sites[0]
        site['name'] = sites[1]
        site['open_everyday'] = sites[2]
        siteList.append(site)

    query2 = queries.get_sites
    cur.execute(query2)
    data2 = cur.fetchall()

    siteList2 = []

    for sites in data2:
        site = {}
        site['name'] = sites[0]
        siteList2.append(site)

    query3 = queries.get_unassigned_managers
    cur.execute(query3)
    data3 = cur.fetchall()

    managers_list = []

    for managers in data3:
        manager = {}
        manager['manager_name'] = managers[0]
        managers_list.append(manager)

    all_siteLists.append(siteList)
    all_siteLists.append(siteList2)
    all_siteLists.append(managers_list)

    return json.dumps(
        all_siteLists
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
        conn.commit()
        return log_queries.updated
    else:
        site_name = request.args.get('site_name')
        cur.execute(log_queries.get_manager)
        managers = cur.fetchall()
        query = log_queries.display_site.format(site_name)
        print(query)
        cur.execute(query)
        data = cur.fetchall()

        query2 = queries.get_unassigned_managers
        cur.execute(query2)
        data2 = cur.fetchall()

        unassignedList = []

        for managers in data2:
            manager = {}
            manager['manager_name'] = managers[0]
            manager['username'] = managers[1]
            unassignedList.append(manager)

        return json.dumps([
            {
                'manager': data[0][0],
                'manager_username': data[0][1],
                'address': data[0][2],
                'zipcode': data[0][3],
                'open': data[0][4]
            },
            managers,
            unassignedList
        ])


@app.route('/delete_site', methods=['DELETE'])
def del_site():
    site_name = request.args.get('site_name')
    query = queries.delete_site.format(site_name)
    print(query)
    try:
        cur.execute(query)
        conn.commit()
        return "DELETE SUCCESSFUL"
    except:
        return "DELETE FAILED"


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
            conn.commit()
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

            manager['username'] = managers[1]
            managerList.append(manager)

        return json.dumps(
            managerList
        )

# Screen 22
@app.route('/manage_transit', methods=['GET', 'DELETE'])
def a_manage_transit():
    if request.method == 'DELETE':
        type = request.args.get('type')
        route = request.args.get('route')
        query = queries.delete_transit.format(type=type, route=route)
        cur.execute(query)
        conn.commit()
        print("DELETED TRANSIT")
        return "ITSALLDELETED"
    else:
        query = queries.manage_transit
        cur.execute(query)
        # conn.commit()
        data = cur.fetchall()

        all_data = []

        transitList = []

        for transits in data:
            transit = {}
            transit['type'] = transits[0]
            transit['route'] = transits[1]
            transit['price'] = str(transits[2])
            transit['num_sites'] = str(transits[3])
            transit['num_log'] = str(transits[4])
            transitList.append(transit)

        query2 = queries.get_sites
        cur.execute(query2)
        data2 = cur.fetchall()

        siteList = []

        for sites in data2:
            site = {}
            site['name'] = sites[0]
            siteList.append(site)

        all_data.append(transitList)
        all_data.append(siteList)

        return json.dumps(
            all_data
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
            conn.commit()
            return "ITSALLGOOD"
        except:
            print("ITAINTGOOD, YOUGOTERROR")

    else:
        type = request.args.get('type')
        route = request.args.get('route')

        query = queries.display_transit.format(type=type, route=route)
        print(query)
        cur.execute(query)
        data = cur.fetchall()

        transit_data = []
        print("IM IN COMPLETE")
        for transits in data:
            transit = {}
            transit['type'] = transits[0]
            transit['route'] = transits[1]
            transit['price'] = transits[2]
            transit['connected_sites'] = [x.strip() for x in transits[3].split(',')]
            transit_data.append(transit)

        return json.dumps(
            transit_data
        )


@app.route('/a_create_transit', methods=['POST', 'GET']) #Screen 24
def a_create_transit():
    if request.method == 'POST':
        data = request.get_json()
        type = data['type']
        route = data['route']
        price = data['price']
        connected_sites = data['sites']
        query = queries.create_transit.format(type, route, price, connected_sites)
        try:
            cur.execute(query)
            conn.commit()
            return "ITSALLGOOD"
        except:
            return "YOUHAVEFAILEDME"
    else:
        query = """
            SELECT name from site
        """
        cur.execute(query)
        data = cur.fetchall()
        sites = []
        for site in data:
            sites.append(site[0])
        return json.dumps(sites)


@app.route('/m_manage_event', methods=['GET', 'DELETE']) #Screen 25
def m_manage_event():
    if request.method == 'DELETE':
        event_name = request.args.get('event_name')
        event_start = request.args.get('event_start')
        query = queries.delete_event.format(event_name, event_start)
        print(query)
        try:
            cur.execute(query)
            conn.commit()
            return "DELETE SUCCESSFUL"
        except:
            return "DELETE FAILED"

    query = queries.manage_event
    cur.execute(query)
    data = cur.fetchall()

    eventList = []

    for events in data:
        print(events)
        event = {}
        event['event_name'] = events[0]
        event['staff_count'] = str(events[1])
        event['duration'] = str(events[2])
        event['total_visits'] = str(events[3])
        event['total_revenue'] = str(events[4])
        event['start_date'] = str(events[5])
        event['site_name'] = events[6]
        eventList.append(event)

    return json.dumps(
        eventList
    )

@app.route('/m_edit_event', methods=['GET', 'POST', 'DELETE']) #Screen 26
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
            conn.commit()
            return "ITSALLGOOD"
        except:
            print("BIGFATERROR")

    else:
        event_name = request.args.get('event_name')
        event_date = request.args.get('event_start')
        query1 = queries.m_edit_event.format(event_name, event_date)
        print(query1)
        cur.execute(query1)
        data1 = cur.fetchall()
        # print(data1)

        event_report = []

        event_detail = []
        print(data1)
        for details in data1:
            detail = {}
            detail['event_name'] = details[0]
            detail['event_price'] = str(details[1])
            detail['event_start'] = str(details[2])
            detail['end_date'] = str(details[3])
            detail['min_staff'] = str(details[4])
            detail['capacity'] = str(details[5])
            detail['staff_names'] = [x.strip() for x in details[6].split(',')]
            detail['staff_usernames'] = details[7]
            detail['description'] = details[8]
            event_detail.append(detail)

        event_price = data1[0][1]
        query2 = queries.event_report.format(event_name, event_date, event_price)
        cur.execute(query2)
        data3 = cur.fetchall()
        revenue = []
        for days in data3:
            day = {}
            day['visit_date'] = str(days[0])
            day['visits'] = str(days[1])
            day['price'] = str(days[2])
            revenue.append(day)

        print(data3)
        event_report.append(event_detail)
        event_report.append(revenue)

        return json.dumps(
            event_report
        )


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
        conn.commit()
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
            staff['username'] = staffs[1]
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

    all_details = []

    staffList = []

    for staffs in data:
        staff = {}
        staff['staff_name'] = staffs[0]
        staff['event_shifts'] = str(staffs[1])
        staffList.append(staff)

    query2 = queries.get_sites
    cur.execute(query2)
    data2 = cur.fetchall()

    siteList2 = []

    for sites in data2:
        site = {}
        site['name'] = sites[0]
        siteList2.append(site)

    all_details.append(staffList)
    all_details.append(siteList2)

    return json.dumps(
        all_details
    )

# Screen 29
@app.route('/m_site_report')
def m_site_report():
    manager_name = request.args.get('username')
    start_date = request.args.get('start_date')
    end_date = request.args.get('end_date')
    cur.execute(queries.get_site_name.format(manager_name))
    site_name = cur.fetchall()[0][0]

    query = queries.get_site_report.format(site_name, start_date, end_date)
    cur.execute(query)
    report = []
    data = cur.fetchall()
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
    cur.execute(queries.get_site_name.format(manager_username))
    site_name = cur.fetchall()[0][0]
    date = request.args.get('date')
    query = queries.get_daily_detail.format(manager_username, site_name, date)
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


# Screen 32
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

    all_details = []

    eventList = []
    print(data)

    for events in data:
        event = {}
        event['event_name'] = events[0]
        event['site_name'] = events[1]
        event['ticket_price'] = str(events[2])
        event['event_start'] = str(events[3])
        event['tickets_remaining'] = events[6]
        event['total_visits'] = str(events[4])
        event['my_visits'] = str(events[5])
        eventList.append(event)

    query2 = queries.get_sites
    cur.execute(query2)
    data2 = cur.fetchall()

    siteList2 = []

    for sites in data2:
        site = {}
        site['name'] = sites[0]
        siteList2.append(site)


    all_details.append(eventList)
    all_details.append(siteList2)

    return json.dumps(
        all_details
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
        query = queries.log_event_visit.format(username, event_name, event_start, site_name, visit_date)
        print(query)
        try:
            cur.execute(query)
            conn.commit()
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
        print(data)

        for events in data:
            event = {}
            event['event_name'] = events[0]
            event['site_name'] = events[1]
            event['start_date'] = str(events[2])
            event['description'] = events[3]
            event['end_date'] = str(events[4])
            event['ticket_price'] = str(events[5])
            event['event_start'] = str(events[6])
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

    all_siteLists = []

    siteList = []

    for sites in data:
        site = {}
        site['site_name'] = sites[0]
        site['event_count'] = str(sites[1])
        site['total_visits'] = str(sites[2])
        site['my_visits'] = str(sites[3])
        siteList.append(site)

    query2 = queries.get_sites
    cur.execute(query2)
    data2 = cur.fetchall()

    siteList2 = []

    for sites in data2:
        site = {}
        site['name'] = sites[0]
        siteList2.append(site)

    all_siteLists.append(siteList)
    all_siteLists.append(siteList2)

    return json.dumps(
        all_siteLists
    )

# Screen 36
@app.route('/v_transit_detail', methods=['GET', 'POST']) #Screen 36
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
            conn.commit()
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
            conn.commit()
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

    full_history = []

    history = []
    for row in data:
        visit = {}
        visit['date'] = str(row[0])
        visit['event'] = row[1]
        visit['site'] = row[2]
        visit['price'] = row[3]
        history.append(visit)

    query2 = queries.get_sites
    cur.execute(query2)
    data2 = cur.fetchall()

    siteList = []

    for sites in data2:
        site = {}
        site['name'] = sites[0]
        siteList.append(site)

    full_history.append(history)
    full_history.append(siteList)

    return json.dumps(
        full_history
    )



@app.route('/')
def main():
    return json.dumps({
        "test": "cAn We PlEaSe HiT 50 lIkEs????????"
    })


if __name__ == "__main__":
    app.run()
