from flask import Flask
from flask import request
# import MySQLdb
import pymysql as mysql
import json
from api import queries
from api import register_queries
from flask_cors import CORS
from flask_api import status

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

# ===========================================================================================================================

# @app.route('/register_user', methods=['POST']) #Screen 3
# def register_user():
#     data = request.get_json()
#     username = data['username']
#     email = data['email']
#     fname = data['fname']
#     lname = data['lname']
#     pw = data['pw']
#     query = register_queries.register_user.format(username, email, fname, lname, pw)
#     check_exist = register_queries.check_exist.format(username)
#     cur.execute(check_exist)
#     exist = cur.fetchall()
#     if len(exist) > 0:
#         return queries.username_taken
#     cur.execute(query)
#     return queries.register_successfully



@app.route('/register_vistor') #Screen 4
def register_visitor():
    data = request.get_json()
    # query = register_queries.
    pass

@app.route('/register_employee') #Screen 5
def register_employee():
    pass

@app.route('/register_employee-visitor') #Screen 6
def register_employee_visitor():
    pass

# ===========================================================================================================================

@app.route('/takes_transit') #Screen 15
def takes_transit():
    pass


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
    pass

@app.route('/a_manage_user') #Screen 18
def a_manage_user():
    pass

@app.route('/a_manage_site') #Screen 19
def a_manage_site():
    pass

@app.route('/a_edit_site') #Screen 20
def a_edit_site():
    pass

@app.route('/a_create_site') #Screen 21
def a_create_site():
    pass

@app.route('/a_manage_transit') #Screen 22
def a_manage_transit():
    pass

@app.route('/a_edit_transit') #Screen 23
def a_edit_transit():
    pass

@app.route('/a_create_transit') #Screen 24
def a_create_transit():
    pass

@app.route('/m_manage_event') #Screen 25
def m_manage_event():
    pass

@app.route('/m_edit_event') #Screen 26
def m_edit_event():
    pass

@app.route('/m_create_event') #Screen 27
def m_create_event():
    pass

@app.route('/m_manage_staff') #Screen 28
def m_manage_staff():
    pass

@app.route('/m_daily_detail') #Screen 30
def m_daily_detail():
    pass

@app.route('/s_view_schedule') #Screen 31
def s_view_schedule():
    pass

@app.route('/s_event_detail') #Screen 32
def s_event_detail():
    pass

@app.route('/v_explore_event') #Screen 33
def v_explore_event():
    pass

@app.route('/v_event_detail') #Screen 34
def v_event_detail():
    pass

@app.route('/v_explore_site') #Screen 35
def v_explore_site():
    pass

@app.route('/v_transit_detail') #Screen 36
def v_transit_tranit():
    pass

@app.route('/v_site_detail') #Screen 37
def v_site_detail():
    username = request.args.get('username')
    site_name = request.args.get('site_name')
    visit_date = request.args.get('visit_date')
    # query =
    pass


@app.route('/v_visit_history') #Screen 38
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
        "test": "pass"
    })


if __name__ == "__main__":
    app.run()
