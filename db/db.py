import MySQLdb as mysql

# connect to server
conn = mysql.connect(host='localhost', user='root', password='root')

cur = conn.cursor()

# create database
create_db = 'CREATE DATABASE atl-beltline'
cur.execute(create_db)

# CREATE statements here
