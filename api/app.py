from flask import Flask
from flask import request
# import MySQLdb
import pymysql as mysql
import json
from api import queries

app = Flask(__name__)

conn = mysql.connect(host="localhost", user="cs4400user", passwd="password", db="atl_beltline")  # name of the database

# Create a Cursor object to execute queries.
cur = conn.cursor()


# EACH SCREEN SHOULD HAVE ITS OWN ROUTE
#
@app.route('/validate_login')
def validate_login():
    email = request.args.get('email') #
    pw = request.args.get('password')
    query = queries.validate_user.format(email=email)
    cur.execute(query)
    data = cur.fetchall()
    username = ''
    if len(data) < 1:
        return json.dumps({
            'message': queries.email_not_exists,
            'username': username
        })

    if pw != data[0][1]:
        return json.dumps({
            'message': queries.wrong_pw,
            'username': username
        })

    username = '' + data[0][2] + ''
    return json.dumps({
        'message': queries.account_exists,
        'username': username
    })


@app.route('/')
def main():
    return json.dumps({
        "test": "pass"
    })


if __name__ == "__main__":
    app.run()
