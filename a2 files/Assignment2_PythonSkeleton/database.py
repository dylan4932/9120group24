#!/usr/bin/env python3
import psycopg2

#####################################################
##  Database Connection
#####################################################

'''
Connect to the database using the connection string
'''
def openConnection():
    # connection parameters - ENTER YOUR LOGIN AND PASSWORD HERE
    userid = "y21s2c9120_yuji0713"
    passwd = "1997"
    myHost = "soit-db-pro-2.ucc.usyd.edu.au"

    # Create a connection to the database
    conn = None
    try:
        # Parses the config file and connects using the connect string
        conn = psycopg2.connect(database=userid,
                                    user=userid,
                                    password=passwd,
                                    host=myHost)
        print('SQL DataBase Connected successfully!')
    except psycopg2.Error as sqle:
        print("psycopg2.Error : " + sqle.pgerror)
    
    # return the connection to use
    return conn

'''
Validate user login request based on username and password
'''
def checkUserCredentials(username, password):


    # User '-' should not be allowed to login.
    # Check user input validation process
    try:
        conn = openConnection()

        cursor = conn.cursor()
        cursor.execute("SELECT * from official where username=%(user)s and password=%(passwd)s", 
                    {'user': username, 'passwd': password})
        userInfo = cursor.fetchone()
        
    except Exception as e:
        print('Execution Error')
    finally:
        if conn != None:
            cursor.close()
            conn.close()
    # still need to validate the login process

    # userInfo = ['3', 'ChrisP', 'Christopher', 'Putin', '888']

    return userInfo


'''
List all the associated events in the database for a given official
'''
def findEventsByOfficial(official_id):
    event_db = []
    event_list = []
    # the check user input validation process


    try:
        conn = openConnection()
        cursor = conn.cursor()
        cursor.execute("SELECT DISTINCT eventid, eventname as Name, sportname as Sport, referee, judge, medalgiver\r\n" +
                        "FROM event NATURAL JOIN sport\r\n" +
                        "WHERE referee=%(official)s or judge=%(official)s or medalgiver=%(official)s\r\n"+
                        "ORDER BY sportname;", {'official': official_id})
        event_db = cursor.fetchall()
        cursor.execute("SELECT officialid, username FROM official")
        official_list = cursor.fetchall()
        
    except psycopg2.Error as sqle:
        print("psycopg2.Error : " + sqle.pgerror)       # sqle.pgerror should be deleted
    finally:
        event_list = [{
            'event_id': row[0],
            'event_name': row[1],
            'sport': row[2],
            'referee': official_list[row[3]-1][1] if isinstance(row[3], int) else '-',
            'judge': official_list[row[4]-1][1] if isinstance(row[4], int) else '-',
            'medal_giver': official_list[row[5]-1][1] if isinstance(row[5], int) else '-'
        } for row in event_db]
        if conn != None:
            cursor.close()
            conn.close()
    return event_list       
            
'''
Find a list of events based on the searchString provided as parameter
See assignment description for search specification
'''
def findEventsByCriteria(searchString):
    events = []
    event_list = []
    # searching with a blank/empty keyword field will show all of the logged in user’s associated events.
    # multiple search
    try:
        conn = openConnection()
        cursor = conn.cursor()
        # problem with check official name
        cursor.execute("SELECT DISTINCT eventid, eventname as Name, sportname as Sport, referee, judge, medalgiver\r\n" +
                        "FROM event NATURAL JOIN sport NATURAL JOIN official\r\n" +
                        "WHERE LOWER(eventname) LIKE LOWER('%%"+searchString+"%%')\r\n"+
                        "OR LOWER(sportname) LIKE LOWER('%%"+searchString+"%%')\r\n"+
                        "OR LOWER(username) LIKE LOWER('%%"+searchString+"%%')\r\n"+
                        "ORDER BY sportname;")
        events = cursor.fetchall()
        cursor.execute("SELECT officialid, username FROM official")
        official_list = cursor.fetchall()
        event_list = [{
            'event_id': row[0],
            'event_name': row[1],
            'sport': row[2],
            'referee': official_list[row[3]-1][1] if isinstance(row[3], int) else '-',
            'judge': official_list[row[4]-1][1] if isinstance(row[4], int) else '-',
            'medal_giver': official_list[row[5]-1][1] if isinstance(row[5], int) else '-'
        } for row in events]   
    except psycopg2.Error as sqle:
        print("psycopg2.Error : " + sqle.pgerror)       # sqle.pgerror should be deleted
    finally:
        
        if conn != None:
            cursor.close()
            conn.close()
    return event_list


'''
Add a new event
'''
def addEvent(event_name, sport, referee, judge, medal_giver):
    
    # It needs to support updating event associated with the user as the minimum.
    try:
        conn = openConnection()
        cursor = conn.cursor()
        get_stmt = ("SELECT count(*) from event")
        cursor.execute(get_stmt)
        res = cursor.fetchone()
        print(int(count[0]) for count in res)
        # cursor.execute("SELECT DISTINCT eventid, eventname as Name, sportname as Sport, referee, judge, medalgiver\r\n" +
        #                 "FROM event NATURAL JOIN sport NATURAL JOIN official\r\n" +
        #                 "WHERE LOWER(eventname) LIKE LOWER('%%"+searchString+"%%')\r\n"+
        #                 "OR LOWER(sportname) LIKE LOWER('%%"+searchString+"%%')\r\n"+
        #                 "OR LOWER(username) LIKE LOWER('%%"+searchString+"%%')\r\n"+
        #                 "ORDER BY sportname;")
    except psycopg2.Error as sqle:
        print("psycopg2.Error : " + sqle.pgerror)       # sqle.pgerror should be deleted
    finally:
        if conn != None:
            cursor.close()
            conn.close()

    return True


'''
Update an existing event
'''
def updateEvent(event_id, event_name, sport, referee, judge, medal_giver):


    return True