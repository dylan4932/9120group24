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

    conn = None
    userInfo = []
    # User '-' should not be allowed to login.
    # Check user input validation process
    # still need to validate the login process (check)
    if not username.isalnum():
        return
    try:
        conn = openConnection()

        cursor = conn.cursor()
        cursor.execute("SELECT * from official where username=%(user)s and password=%(passwd)s", 
                    {'user': username, 'passwd': password})
        userInfo = cursor.fetchone()
    except Exception as e:      # need to check the connection while excute
        print('Execution Error')
    finally:
        if conn != None:
            cursor.close()
            conn.close()
            print('SQL connection closed.')
        # did not match
        # if len(userInfo) == 0:
        #     print('Invalidate user and password')
        #     return
    
    # userInfo = ['3', 'ChrisP', 'Christopher', 'Putin', '888']
    
    return userInfo


'''
List all the associated events in the database for a given official
'''
def findEventsByOfficial(official_id):
    event_db = []
    event_list = []
    try:
        conn = openConnection()
        cursor = conn.cursor()
        cursor.execute("SELECT e.eventid, e.eventname, s.sportname, r.username, j.username, m.username\r\n" +
                        "FROM event e NATURAL JOIN sport s\r\n" +
                        "JOIN official r ON (e.referee = r.officialid)\r\n" +
                        "JOIN official j ON (e.judge = j.officialid)\r\n" +
                        "JOIN official m ON (e.medalgiver = m.officialid)\r\n" +
                        "WHERE e.referee=%(official)s or e.judge=%(official)s or e.medalgiver=%(official)s\r\n"+
                        "ORDER BY s.sportname;", {'official': int(official_id)})
        event_db = cursor.fetchall()
        
    except psycopg2.Error as sqle:
        print("psycopg2.Error : " + sqle.pgerror)       # sqle.pgerror should be deleted
    finally:
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
            print('SQL connection closed.')
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
        cursor.execute("SELECT e.eventid, e.eventname, s.sportname, r.username, j.username, m.username\r\n" +
                        "FROM event e NATURAL JOIN sport s\r\n" +
                        "JOIN official r ON (e.referee = r.officialid)\r\n" +
                        "JOIN official j ON (e.judge = j.officialid)\r\n" +
                        "JOIN official m ON (e.medalgiver = m.officialid)\r\n" +
                        "WHERE LOWER(e.eventname) LIKE LOWER('%%"+searchString+"%%')\r\n"+
                        "OR LOWER(s.sportname) LIKE LOWER('%%"+searchString+"%%')\r\n"+
                        "OR LOWER(r.username) LIKE LOWER('%%"+searchString+"%%')\r\n"+
                        "OR LOWER(j.username) LIKE LOWER('%%"+searchString+"%%')\r\n"+
                        "OR LOWER(m.username) LIKE LOWER('%%"+searchString+"%%')\r\n"+
                        "ORDER BY s.sportname;")
        events = cursor.fetchall()
        event_list = [{
            'event_id': row[0],
            'event_name': row[1],
            'sport': row[2],
            'referee': row[3],
            'judge': row[4],
            'medal_giver': row[5]
        } for row in events]   
    except psycopg2.Error as sqle:
        print("psycopg2.Error : " + sqle.pgerror)       # sqle.pgerror should be deleted
    finally:
        if conn != None:
            cursor.close()
            conn.close()
            print('SQL connection closed.')
    return event_list


'''
Add a new event
'''
def addEvent(event_name, sport, referee, judge, medal_giver):
    
    # It needs to support updating event associated with the user as the minimum.
    conn = None
    try:
        conn = openConnection()
        cursor = conn.cursor()
        # # get event_id
        # event_stmt = ("SELECT count(*) from event;")
        # cursor.execute(event_stmt)
        # event_id = cursor.fetchone()[0]+1

        # get sport_id
        sname_list = []
        sport_stmt = ("SELECT * from sport;")
        cursor.execute(sport_stmt)
        sport_list = cursor.fetchall()
        for row in sport_list:
            sname_list.append(row[1])
        
        # check whether the input sport are in the list
        if sport not in sname_list:
            cursor.close()
            conn.close()
            print('SQL connection closed.')
            print('Sport name not in the database')
            return False
        
        for row in sport_list:
            if row[1] == sport:
                sport_id = row[0]

        # get official_id for referee/ judge/ medal giver
        username_list = []                             
        official_stmt = ("SELECT officialid, username from official;")
        cursor.execute(official_stmt)
        official_list = cursor.fetchall()
        for row in official_list:
            username_list.append(row[1])
        
        # check whether the referee/ judge/ medal_giver in the official list
        if referee not in username_list and judge not in username_list and medal_giver not in username_list:
            cursor.close()
            conn.close()
            print('Username not in the database')
            return False

        for official in official_list:
            if official[1] == referee:
                referee_id = official[0]

        for official in official_list:
            if official[1] == judge:
                judge_id = official[0]

        for official in official_list:
            if official[1] == medal_giver:
                medalGiver_id = official[0]

        cursor.execute("INSERT INTO event(eventname, sportid, referee, judge, medalgiver)\r\n"+
                        "VALUES (%(ename)s, %(sid)s, %(rid)s, %(jid)s, %(mid)s)", 
                        {'ename': event_name, 'sid': int(sport_id),
                        'rid': int(referee_id), 'jid': int(judge_id), 'mid': int(medalGiver_id)})
        print([event_name, sport_id, referee_id, judge_id, medalGiver_id])
        conn.commit()
    except psycopg2.Error as sqle:
        print("psycopg2.Error : ", sqle.pgerror)       # sqle.pgerror should be deleted
    finally:
        if conn != None:
            cursor.close()
            conn.close()
            print('SQL connection closed.')

    return True


'''
Update an existing event
'''
def updateEvent(event_id, event_name, sport, referee, judge, medal_giver):
    # It needs to support updating event associated with the user as the minimum.
    conn = None
    try:
        conn = openConnection()
        cursor = conn.cursor()
        # # get event_id
        # event_stmt = ("SELECT count(*) from event;")
        # cursor.execute(event_stmt)
        # event_id = cursor.fetchone()[0]+1

        # get sport_id
        sname_list = []
        sport_stmt = ("SELECT * from sport;")
        cursor.execute(sport_stmt)
        sport_list = cursor.fetchall()
        for row in sport_list:
            sname_list.append(row[1])
        
        # check whether the input sport are in the list
        if sport not in sname_list:
            cursor.close()
            conn.close()
            print('SQL connection closed.')
            print('Sport name not in the database')
            return False
        
        for row in sport_list:
            if row[1] == sport:
                sport_id = row[0]

        # get official_id for referee/ judge/ medal giver
        username_list = []                             
        official_stmt = ("SELECT officialid, username from official;")
        cursor.execute(official_stmt)
        official_list = cursor.fetchall()
        for row in official_list:
            username_list.append(row[1])
        
        # check whether the referee/ judge/ medal_giver in the official list
        if referee not in username_list and judge not in username_list and medal_giver not in username_list:
            cursor.close()
            conn.close()
            print('Username not in the database')
            return False

        # should check the referee/ judge/medal_giver are the same
        for official in official_list:
            if official[1] == referee:
                referee_id = official[0]

        for official in official_list:
            if official[1] == judge:
                judge_id = official[0]

        for official in official_list:
            if official[1] == medal_giver:
                medalGiver_id = official[0]

        cursor.execute("UPDATE event SET eventname = %(ename)s, sportid=%(sid)s, %(rid)s,\r\n"+
                        " judge=%(jid)s, medalgiver=%(mid)s \r\n"+
                        "WHERE eventid=%(eid)s;", 
                        {'ename': event_name, 'sid': int(sport_id), 'rid': int(referee_id),
                         'jid': int(judge_id), 'mid': int(medalGiver_id), 'eid':int(event_id)})
        print([event_name, sport_id, referee_id, judge_id, medalGiver_id])
        conn.commit()
    except psycopg2.Error as sqle:
        print("psycopg2.Error : ", sqle.pgerror)       # sqle.pgerror should be deleted
    finally:
        if conn != None:
            cursor.close()
            conn.close()
            print('SQL connection closed.')

    return True