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
@app.route('/validate_login')
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


@app.route('/register_user', methods=['POST'])
def register_user():
    data = request.get_json()
    username = data['username']
    email = data['email']
    fname = data['fname']
    lname = data['lname']
    pw = data['pw']
    user_type = data['user_type']
    query = register_queries.register_user.format(
            username,
            email,
            fname,
            lname,
            pw,
            user_type)
    check_exist = register_queries.check_exist.format(email)
    cur.execute(check_exist)
    exist = cur.fetchall()
    if len(exist) > 0:
        return queries.email_already_exists + " or " + queries.username_taken
    cur.execute(query)
    return str(status.HTTP_200_OK)


@app.route('/')
def main():
    # user = request.args.get('username')
    # query = queries.get_transit.format(username=user)
    # cur.execute(query)
    # data = cur.fetchall()
    # print(data[0][0])
    # transitList = []
    #
    # for dat in data:
    #     transit = {}
    #     transit['date'] = str(dat[0])
    #     transit['route'] = dat[1]
    #     transit['type'] = dat[2]
    #     transit['price'] = dat[3]
    #     transitList.append(transit)
    return json.dumps({
        "test": 'pass'
    })


if __name__ == "__main__":
    app.run()
