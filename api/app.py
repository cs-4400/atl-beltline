from flask import Flask
from flask import request
# import MySQLdb
import pymysql as mysql
import json
from api import queries
from api import register_queries
from flask_cors import CORS

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



# @app.route('/register_vistor')
# def register_visitor():
#     pass

@app.route('/transit_history')
def transit_history():
    username = request.args.get('username')
    query = queries.transit_history.format(username=username)
    cur.execute(query)
    data = cur.fetchall()


    # if len(data) < 1:
    #     return json.dumps({
    #         'message': queries.email_not_exists,
    #     })

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


@app.route('/e_manage_profile')
def e_manage_profile():
    pass


@app.route('/')
def main():
    return json.dumps({
        "test": "pass"
    })


if __name__ == "__main__":
    app.run()
