from flask import Flask
import MySQLdb
import json

app = Flask(__name__)

conn = MySQLdb.connect(host="localhost", user="root", passwd="root", db="company")  # name of the database

# Create a Cursor object to execute queries.
cur = conn.cursor()


# write all the SELECT statements here
# each statement should have its own method
# and route, and should always prefix with
# "/get/"
@app.route('/get/<username>')
def user(username):
    query = """SELECT * FROM user WHERE username = '%s'""" + username
    cur.execute(query)


# write all the INSERT Statements here
# @app.route('/insert/')


@app.route('/')
def main():
    # Select data from table using SQL query.
    dno = '1'
    sql = """SELECT * FROM department WHERE dnumber = '%s'""" % (dno)

    cur.execute(sql)

    # print the first and second columns
    data = []
    for row in cur.fetchall():
        value = {}
        value[row[0]] = int(row[1])
        data.append(value)
        print(row[0], " ", row[1])
    print(data)
    return json.dumps({"data": data})



if __name__ == "__main__":
    app.run()
