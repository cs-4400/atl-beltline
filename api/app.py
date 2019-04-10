from flask import Flask
from flask import request
import MySQLdb
import json
from api import queries

app = Flask(__name__)

conn = MySQLdb.connect(host="localhost", user="root", passwd="root", db="atl_beltline")  # name of the database

# Create a Cursor object to execute queries.
cur = conn.cursor()


# write all the SELECT statements here
# each statement should have its own method
# and route, and should always prefix with
# "/get/"
@app.route('/validate_login')
def validate_login():
    email = request.args.get('email')
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
