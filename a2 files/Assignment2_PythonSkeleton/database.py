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
    userid = "y21s2c9120_unikey"
    passwd = "password"
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
    # Check user input validation process
    # still need to validate the login process (check)
    if not username.isalnum():
        print('Invalid username')
        return
    if not isinstance(password, str):
        print('Invalid password')
        return

    if len(username) > 20:
        print('Username too long.')
        return
    if len(password) > 20:
        print('Invalid password')
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
        # format output
        event_list = [{
            'event_id': str(row[0]),
            'event_name': row[1],
            'sport': row[2],
            'referee': row[3],
            'judge': row[4],
            'medal_giver': row[5]
        } for row in event_db]

    except Exception as e:      # need to check the connection while excute
        print('Execution Error')
    finally:   
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
    try:
        conn = openConnection()
        cursor = conn.cursor()
        # execute the stored procedure search_event in BOSSschema.sql
        cursor.execute('SELECT search_event(%(keyword)s)', {'keyword': '%'+searchString+'%'})
        result = cursor.fetchall()
        
        # format output
        for row in result:
            content = row[0].replace("(", "")
            content = content.replace(")", "")
            content = content.replace("\"", "")
            events.append(content.split(','))
        event_list = [{
            'event_id': str(row[0]),
            'event_name': row[1],
            'sport': row[2],
            'referee': row[3],
            'judge': row[4],
            'medal_giver': row[5]
        } for row in events]   
    except Exception as e:      # need to check the connection while excute
        print('Execution Error')
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
    if len(event_name) > 50 or len(event_name) == 0:
        print('Invalid event name')
        return False
    if len(sport) == 0 or len(sport) > 100:
        print('Invalid sport name')
        return False
    if len(referee) == 0 or len(referee) > 20:
        print('Invalid referee username')
        return False
    if len(judge) == 0 or len(judge) > 20:
        print('Invalid judge username')
        return False
    if len(medal_giver) == 0 or len(medal_giver) > 20:
        print('Invalid medal giver username')
        return False
    try:
        conn = openConnection()
        cursor = conn.cursor()

        # get all sport_id sportname
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
        if referee not in username_list or judge not in username_list or medal_giver not in username_list:
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

        # execute the insert query
        cursor.execute("INSERT INTO event(eventname, sportid, referee, judge, medalgiver)\r\n"+
                        "VALUES (%(ename)s, %(sid)s, %(rid)s, %(jid)s, %(mid)s)", 
                        {'ename': event_name, 'sid': int(sport_id),
                        'rid': int(referee_id), 'jid': int(judge_id), 'mid': int(medalGiver_id)})
        
        # commit the change to database
        conn.commit()
    except Exception as e:              # need to check the connection while excute
        print('Execution Error')        # if there is an error occurs during the execution 
        if conn != None:                # close the connection then return False
            cursor.close()
            conn.close()
            print('SQL connection closed.')
        return False
    finally:                            # success execute the queries 
        if conn != None:                # close the connection then return True
            cursor.close()
            conn.close()
            print('SQL connection closed.')
    return True


'''
Update an existing event
'''
def updateEvent(event_id, event_name, sport, referee, judge, medal_giver):
    
    conn = None

    # check the user input.
    if len(event_name) > 50 or len(event_name) == 0:
        print('Invalid event name')
        return False
    if len(sport) == 0 or len(sport) > 100:
        print('Invalid sport name')
        return False
    if len(referee) == 0 or len(referee) > 20:
        print('Invalid referee username')
        return False
    if len(judge) == 0 or len(judge) > 20:
        print('Invalid judge username')
        return False
    if len(medal_giver) == 0 or len(medal_giver) > 20:
        print('Invalid medal giver username')
        return False
    
    try:
        conn = openConnection()
        cursor = conn.cursor()

        # get all sport_id and sportname
        sname_list = []
        sport_stmt = ("SELECT * from sport;")
        cursor.execute(sport_stmt)
        sport_list = cursor.fetchall()
        for row in sport_list:
            sname_list.append(row[1])
        
        # check whether the input sportname are in the list
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
        if referee not in username_list or judge not in username_list or medal_giver not in username_list:
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

        # call stored procedure and get return value
        # the update_event function returns 0 if update success
        cursor.callproc('update_event', [int(event_id), event_name, int(sport_id), int(referee_id), int(judge_id), int(medalGiver_id)])
        result = cursor.fetchone()
        if result[0] != 0:
            print('Error with update')
            cursor.close()
            conn.close()
            return False
        
        # commit the change to database
        conn.commit()
    except Exception as e:              # need to do error checking while excute
        print('Execution Error')        # if there is an error occurs during the execution 
        if conn != None:                # close the connection then return False
            cursor.close()
            conn.close()
            print('SQL connection closed.')
        return False
    finally:                            # success execute the queries 
        if conn != None:                # close the connection then return True
            cursor.close()
            conn.close()
            print('SQL connection closed.')
    return True
