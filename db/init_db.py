import pymysql as mysql
import MySQLdb

# connect to server to create DB
db = mysql.connect(host='localhost', user='root', password='root')
cur = db.cursor()

# IF the database already exists, DROP
cur.execute("DROP DATABASE IF EXISTS atl_beltline")

# create database
create_db = """CREATE DATABASE atl_beltline"""
cur.execute(create_db)

# connect to server to DB to create TABLES
# table = db.connect(host='localhost', user='root', password='root', db='atl_beltline')
table = MySQLdb.connect('localhost', 'root', 'root', 'atl_beltline', local_infile=True)
cur = table.cursor()

# CREATE statements here

# USER TABLE
cur.execute("DROP TABLE IF EXISTS user")
user_table = """
CREATE TABLE user (
    username varchar(255) NOT NULL,
    password varchar(255) NOT NULL,
    status varchar(255) NOT NULL,
    fname varchar(255) NOT NULL,
    lname varchar(255) NOT NULL,
    usertype varchar(255) NOT NULL,
    PRIMARY KEY (username))
"""

cur.execute(user_table)

# USER_EMAIL TABLE
cur.execute("DROP TABLE IF EXISTS user_email")
email_table = """
CREATE TABLE user_email (
    username varchar(255) NOT NULL,
    email varchar(255) NOT NULL,
    PRIMARY KEY (email),
    UNIQUE (email),
    FOREIGN KEY (username) REFERENCES user (username)
    ON DELETE CASCADE ON UPDATE CASCADE)
"""

cur.execute(email_table)

# load_user = """
# LOAD DATA LOCAL INFILE 'User.csv'
# INTO TABLE atl_beltline.user
# FIELDS TERMINATED BY ','
# LINES TERMINATED BY '\n'
# IGNORE 1 ROWS"""
#
# cur.execute(load_user)
