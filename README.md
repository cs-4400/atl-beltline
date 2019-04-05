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
 
