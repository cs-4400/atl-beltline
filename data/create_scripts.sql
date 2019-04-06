CREATE TABLE atl_beltline.user (
  username varchar(255) NOT NULL,
  pword varchar(255) NOT NULL,
  ustatus ENUM('Approved','Pending', 'Declined'),
  fname varchar(255) NOT NULL,
  lname varchar(255) NOT NULL,
  utype ENUM('Employee','Visitor'),
  PRIMARY KEY (username)
);

CREATE TABLE atl_beltline.user_email (
   username varchar(255) NOT NULL,
   email varchar(255) NOT NULL,
   PRIMARY KEY (email),
   UNIQUE (email),
   FOREIGN KEY (username) REFERENCES user (username)
   ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE atl_beltline.employee (
  username varchar(255) NOT NULL,
  emp_id varchar(255) NOT NULL,
  phone char(10) NOT NULL,
  address varchar(255) NOT NULL,
  city varchar(255) NOT NULL,
  state char(3) NOT NULL,
  zipcode int NOT NULL,
  emp_type ENUM('Administrator', 'Manager', 'Staff'),
  PRIMARY KEY (emp_id),
  FOREIGN KEY (username) REFERENCES user (username)
  ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE atl_beltline.site (
 site_name varchar(255) NOT NULL,
 site_address varchar(255),
 zipcode int NOT NULL,
 opening ENUM('Yes', 'No'),
 site_manager varchar(255) NOT NULL,
 PRIMARY KEY (site_name),
 FOREIGN KEY (site_manager) REFERENCES employee (emp_id)
 ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE atl_beltline.visit_site (
  username varchar(255) NOT NULL,
  sname varchar(255) NOT NULL,
  visit_date date NOT NULL,
  price int NOT NULL,
  PRIMARY KEY (username, sname, visit_date),
  FOREIGN KEY (username) REFERENCES user (username)
  ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (sname) REFERENCES site (site_name)
  ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE atl_beltline.event (
 ename varchar(255) NOT NULL,
 start_date date NOT NULL,
 sname varchar(255) NOT NULL,
 end_date date NOT NULL,
 price int NOT NULL,
 capacity int NOT NULL,
 min_staff int NOT NULL,
 edescription TEXT NOT NULL,
 PRIMARY KEY (ename, start_date),
 FOREIGN KEY (sname) REFERENCES site (site_name)
 ON DELETE CASCADE ON UPDATE CASCADE
);

 CREATE TABLE atl_beltline.visit_event (
  vname varchar(255) NOT NULL,
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
  ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE atl_beltline.transit (
  transit_type varchar(255) NOT NULL,
  route varchar(255) NOT NULL,
  price int NOT NULL,
  PRIMARY KEY (transit_type, route)
);

CREATE TABLE atl_beltline.connect (
   site_name varchar(255) NOT NULL,
   t_type varchar(255) NOT NULL,
   route varchar(255) NOT NULL,
   PRIMARY KEY (site_name, t_type, route),
   FOREIGN KEY (site_name) REFERENCES site (site_name)
   ON DELETE CASCADE ON UPDATE CASCADE,
   FOREIGN KEY (t_type, route) REFERENCES transit (transit_type, route)
   ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE atl_beltline.take (
  username varchar(255) NOT NULL,
  t_type varchar(255) NOT NULL,
  route varchar(255) NOT NULL,
  take_date date NOT NULL,
  PRIMARY KEY (route, t_type, take_date, username),
  FOREIGN KEY (t_type, route) REFERENCES transit (transit_type, route)
  ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (username) REFERENCES user (username)
  ON DELETE CASCADE ON UPDATE CASCADE 
);


CREATE TABLE atl_beltline.assign_to (
   emp_id varchar(255) NOT NULL,
   event_name varchar(255) NOT NULL,
   start_date date NOT NULL,
   site_name varchar(255) NOT NULL,
   PRIMARY KEY (emp_id, event_name, start_date),
   FOREIGN KEY (emp_id) REFERENCES employee (emp_id)
   ON DELETE CASCADE ON UPDATE CASCADE,
   FOREIGN KEY (event_name, start_date) REFERENCES event (ename, start_date)
   ON DELETE CASCADE ON UPDATE CASCADE
);
