# atl-beltline

Alright guys, please refer to this when you do your tasks

### Always use LOWERCASE and UNDERCORE for table names and attributes

# table names: 

assign_to  
connect  
employee  
event  
site  
take_transit  
transit  
user  
user_email  
visit_event  
visit_site  

# example:  

CREATE TABLE user_email (  
    username varchar(255) NOT NULL,  
    email varchar(255) NOT NULL,  
    PRIMARY KEY (email),  
    UNIQUE (email),  
    FOREIGN KEY (username) REFERENCES user (username)  
    ON DELETE CASCADE ON UPDATE CASCADE)  
 
 To load data into the tables for testing select and insert statements, do the following steps for each table.
 
 1. right click on the table name
 ![image](https://user-images.githubusercontent.com/34165109/55602483-e1843f80-5733-11e9-8ab6-1633bcf25371.png)

1. choose "Table Data Import Wizard", and a window pops up

Locate the data file in the data directory 
![image](https://user-images.githubusercontent.com/34165109/55602356-2491e300-5733-11e9-8f01-fc9b6d63caf0.png)

and keep click "NEXT" until finish, and that's how you load data into the tables.
