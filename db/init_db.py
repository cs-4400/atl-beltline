import pymysql as mysql

# connect to server to create DB
db = mysql.connect(host='localhost', user='root', password='root')
cur = db.cursor()

# IF the database already exists, DROP
cur.execute("DROP DATABASE IF EXISTS atl_beltline")

# create database
create_db = """CREATE DATABASE atl_beltline"""
cur.execute(create_db)

# connect to server to DB to create TABLES
table = mysql.connect(host='localhost', user='root', password='root', db='atl_beltline')
cur = table.cursor()

# CREATE statements here

# USER TABLE
cur.execute("DROP TABLE IF EXISTS user")
user_table = """
CREATE TABLE user (
    username varchar(255) NOT NULL,
    lname varchar(255) NOT NULL,
    fname varchar(255) NOT NULL,
    password varchar(255) NOT NULL,
    status ENUM('Approved','Pending', 'Declined'),
    usertype ENUM('Employee','Visitor'),
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
