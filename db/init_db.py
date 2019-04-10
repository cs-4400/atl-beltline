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
CREATE TABLE atl_beltline.user (
  username varchar(255) NOT NULL,
  pword varchar(255) NOT NULL,
  ustatus ENUM('Approved','Pending', 'Declined'),
  fname varchar(255) NOT NULL,
  lname varchar(255) NOT NULL,
  utype ENUM('Employee','Visitor'),
  PRIMARY KEY (username)
)
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

# EMPLOYEE TABLE
cur.execute("DROP TABLE IF EXISTS employee")
employee_table = """
CREATE TABLE employee (
 username varchar(100) NOT NULL,
 emp_id char(15) NOT NULL,
 phone char(10) NOT NULL,
 address varchar(255) NOT NULL,
 city varchar(255) NOT NULL,
 state char(2) NOT NULL,
 zipcode char(5) NOT NULL,
 emp_type ENUM('Admin', 'Manager', 'Staff'),
 PRIMARY KEY (emp_id),
 FOREIGN KEY (username) REFERENCES user (username)
 ON DELETE CASCADE ON UPDATE CASCADE)
"""
cur.execute(employee_table)

# SITE TABLE
cur.execute("DROP TABLE IF EXISTS site")
site_table = """
CREATE TABLE site (
site_name varchar(255) NOT NULL,
site_address varchar(255),
zipcode int NOT NULL,
opening ENUM('Yes', 'No'),
site_manager char(15) NOT NULL,
PRIMARY KEY (site_name),
FOREIGN KEY (site_manager) REFERENCES user (username)
ON DELETE CASCADE ON UPDATE CASCADE)
"""
cur.execute(site_table)

# VISIT_SITE TABLE
cur.execute("DROP TABLE IF EXISTS visit_site")
visit_site_table = """
CREATE TABLE atl_beltline.visit_site (
 username varchar(100) NOT NULL,
 sname varchar(255) NOT NULL,
 visit_date date NOT NULL,
 PRIMARY KEY (username, sname, visit_date),
 FOREIGN KEY (username) REFERENCES user (username)
 ON DELETE CASCADE ON UPDATE CASCADE,
 FOREIGN KEY (sname) REFERENCES site (site_name)
 ON DELETE CASCADE ON UPDATE CASCADE)
"""
cur.execute(visit_site_table)

# EVENT TABLE
cur.execute("DROP TABLE IF EXISTS event")
event_table = """
CREATE TABLE event (
ename varchar(255) NOT NULL,
start_date date NOT NULL,
sname varchar(255) NOT NULL,
end_date date NOT NULL,
price double NOT NULL,
capacity int NOT NULL,
min_staff int NOT NULL,
edescription TEXT NOT NULL,
PRIMARY KEY (ename, start_date),
FOREIGN KEY (sname) REFERENCES site (site_name)
ON DELETE CASCADE ON UPDATE CASCADE)
"""
cur.execute(event_table)

# VISIT_EVENT TABLE
cur.execute("DROP TABLE IF EXISTS visit_event")
visit_event_table = """
CREATE TABLE visit_event (
 vname varchar(100) NOT NULL,
 ename varchar(255) NOT NULL,
 estart_date date NOT NULL,
 sname varchar(255) NOT NULL,
 visit_date date NOT NULL,
 PRIMARY KEY (visit_date, vname, estart_date, ename),
 FOREIGN KEY (vname) REFERENCES user (username)
 ON DELETE CASCADE ON UPDATE CASCADE,
 FOREIGN KEY (ename, estart_date) REFERENCES event (ename, start_date)
 ON DELETE CASCADE ON UPDATE CASCADE,
 FOREIGN KEY (sname) REFERENCES site (site_name)
 ON DELETE CASCADE ON UPDATE CASCADE)
"""
cur.execute(visit_event_table)

# TRANSIT TABLE
cur.execute("DROP TABLE IF EXISTS transit")
transit_table = """
CREATE TABLE transit (
 transit_type varchar(100) NOT NULL,
 route1 varchar(50) NOT NULL,
 price double NOT NULL,
 PRIMARY KEY (transit_type, route1))
"""
cur.execute(transit_table)

# CONNECT TABLE
cur.execute("DROP TABLE IF EXISTS connect")
connect_table = """
CREATE TABLE atl_beltline.connect (
site_name varchar(255) NOT NULL,
t_type varchar(100) NOT NULL,
route varchar(50) NOT NULL,
PRIMARY KEY (site_name, t_type, route),
FOREIGN KEY (site_name) REFERENCES site (site_name)
ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (t_type, route) REFERENCES transit (transit_type, route1)
ON DELETE CASCADE ON UPDATE CASCADE)
"""
cur.execute(connect_table)

# TAKE TABLE
cur.execute("DROP TABLE IF EXISTS take")
take_table = """
CREATE TABLE atl_beltline.take (
username varchar(100) NOT NULL,
t_type varchar(100) NOT NULL,
route varchar(50) NOT NULL,
take_date date NOT NULL,
PRIMARY KEY (route, t_type, take_date, username),
FOREIGN KEY (t_type, route) REFERENCES transit (transit_type, route1)
ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (username) REFERENCES user (username)
ON DELETE CASCADE ON UPDATE CASCADE)
"""
cur.execute(take_table)

# ASSIGN_TO TABLE
cur.execute("DROP TABLE IF EXISTS assign_to")
assign_to_table = """
CREATE TABLE atl_beltline.assign_to (
emp_id char(15) NOT NULL,
event_name varchar(255) NOT NULL,
start_date date NOT NULL,
site_name varchar(255) NOT NULL,
PRIMARY KEY (emp_id, event_name, start_date),
FOREIGN KEY (emp_id) REFERENCES user (username)
ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (event_name, start_date) REFERENCES event (ename, start_date)
ON DELETE CASCADE ON UPDATE CASCADE)
"""
cur.execute(assign_to_table)
