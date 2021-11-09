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
        print('connected successfully!')
    except psycopg2.Error as sqle:
        print("psycopg2.Error : " + sqle.pgerror)
    
    # return the connection to use
    return conn

'''
Validate user login request based on username and password
'''
def checkUserCredentials(username, password):

    #User '-' should not be allowed to login.
    conn = None 
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
    # if conn:
    #     try:
    #         cursor = conn.cursor()
    #         print('SQL server information')
    #         print(conn.get_dsn_parameters())
            
    #         userInfo = cursor.fetchall()
    #     except (Exception, psycopg2.DatabaseError) as error:
    #         print('Error in excute the SQL query:', error)
    #     finally:
    #             try:
    #                 cursor.close()
    #                 conn.close()
    #             except (Exception, Error):
    #                 print('Error in close')


    # userInfo = ['3', 'ChrisP', 'Christopher', 'Putin', '888']

    return userInfo


'''
List all the associated events in the database for a given official
'''
def findEventsByOfficial(official_id):
    event_list = []
    conn = None
    try:
        conn = openConnection()
        cursor = conn.cursor()
        cursor.execute("SELECT DISTINCT eventid, eventname as Name, sportname as Sport, referee, judge, medalgiver\r\n" +
                        "FROM event e NATURAL JOIN sport NATURAL JOIN official\r\n" +
                        "WHERE e.referee=%(r_id)s or e.judge=%(j_id)s or e.medalgiver=%(m_id)s\r\n"+
                        "ORDER BY sportname;",	
                        {'r_id': official_id, 'j_id': official_id, 'm_id': official_id})
        event_db = cursor.fetchall()
        cursor.execute("SELECT officialid, username FROM official")
        official_list = cursor.fetchall()
        print(event_db)
        print(official_list)
    except psycopg2.Error as sqle:
        print("psycopg2.Error : " + sqle.pgerror)
    finally:
        for i in range(len(event_db)):
            for j in [3, 4, 5]:
                for official in official_list:
                    if official[0] == event_db[i][j]:
                        print('found!')
                        event_db[i][j] == official[1]
        print(event_db)
        event_list = [{
            'event_id': row[0],
            'event_name': row[1],
            'sport': row[2],
            'referee': row[3],
            'judge': row[4],
            'medal_giver': row[5]
        } for row in event_db]
        if conn != None:
            cursor.close()
            conn.close()
            
            

    # event_db = [
    #     ['3', 'Men''\'s Team Semifinal', 'Archery', 'ChrisP', 'GuoZ', 'JulieA'],
    #     ['1', 'Men''\'s Singles Semifinal', 'Badminton', 'JohnW', 'ChrisP', 'GuoZ']
    # ]

    # event_list = [{
    #     'event_id': row[0],
    #     'event_name': row[1],
    #     'sport': row[2],
    #     'referee': row[3],
    #     'judge': row[4],
    #     'medal_giver': row[5]
    # } for row in event_db]

    return event_list


'''
Find a list of events based on the searchString provided as parameter
See assignment description for search specification
'''
def findEventsByCriteria(searchString):

    event_db = [
        ['3', 'Men''\'s Team Semifinal', 'Archery', 'ChrisP', 'GuoZ', 'JulieA'],
        ['1', 'Men''\'s Singles Semifinal', 'Badminton', 'JohnW', 'ChrisP', 'GuoZ'],
        ['4', 'Men''\'s Tournament Semifinal', 'Basketball', '-', 'JohnW', 'MaksimS']
    ]

    event_list = [{
        'event_id': row[0],
        'event_name': row[1],
        'sport': row[2],
        'referee': row[3],
        'judge': row[4],
        'medal_giver': row[5]
    } for row in event_db]

    return event_list


'''
Add a new event
'''
def addEvent(event_name, sport, referee, judge, medal_giver):


    return True


'''
Update an existing event
'''
def updateEvent(event_id, event_name, sport, referee, judge, medal_giver):


    return True