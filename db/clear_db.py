# import the mysql client for python

import pymysql as mySql

# Create a connection object

dbIP = "localhost"  # IP address of the MySQL database server

dbUserName = "cs4400user"  # User name of the database server

dbUserPassword = "password"  # Password for the database user

databaseForDeletion = "atl_beltline"  # Name of the database that is to be deleted


connection = mySql.connect(host=dbIP, user=dbUserName, password=dbUserPassword)


try:

    # Create a cursor object

    dbCursor = connection.cursor()

    # SQL Statement to delete a database

    sql = "DROP DATABASE " + databaseForDeletion

    # Execute the create database SQL statment through the cursor instance

    dbCursor.execute(sql)

    # SQL query string

    sqlQuery = "SHOW DATABASES"

    # Execute the sqlQuery

    dbCursor.execute(sqlQuery)

    # Fetch all the rows

    databaseCollection = dbCursor.fetchall()

    for database in databaseCollection:
        print(database)


except Exception as e:

    print("Exception occurred:{}".format(e))

finally:

    connection.close()
