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
    userid = "y21s1c9120_yuji0713"
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
    except psycopg2.Error as sqle:
        print("psycopg2.Error : " + sqle.pgerror)
    
    # return the connection to use
    return conn

'''
Validate user login request based on username and password
'''
def checkUserCredentials(username, password):
    userInfo = []
    conn = None 
    try:
        conn = openConnection()
    except (Exception, psycopg2.DatabaseError) as error:
        print('connection error: ', error)
    if conn:
        try:
            cursor = conn.cursor()
            print('SQL server information')
            print(conn.get_dsn_parameters())
            cursor.excute("select officialid from official where username=? and password=?".format(username, password))
            userInfo = cursor.fetchall()
        except (Exception, psycopg2.DatabaseError) as error:
            print('Error in excute the SQL query:', error)
        finally:
                try:
                    cursor.close()
                    conn.close()
                except (Exception, Error):
                    print('Error in close')


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
    except (Exception, psycopg2.DatabaseError) as error:
        print('Error in connection')
    finally:
        if conn:
            try:
                cursor = conn.cursor()
                print('SQL server information')
                print(conn.get_dsn_parameters())
                cursor.excute("select new_table.eventname, new_table.eventid, sportname, new_table. referee, new_table. judge, new_table.award from \r\n" +
                            "(select e.eventname, e.eventid, s.sportname, referee.officialid as r_id, referee.username as referee, \r\n" +
                            "judge.officialid as j_id, judge.username as judge, award.officialid as a_id, award.username as award \r\n"	+	
                            "from event e join (select officialid, username from official)referee on e.referee = referee.officialid \r\n" +
                            "join(select officialid, username from official)judge on e.judge = judge.officialid \r\n" +
                            "join sport s on s.sportid = e.sportid \r\n" +
                            "order by e.eventname) as new_table \r\n" +
                            "where r_id = {} or j_id = {} or a_id = {}".format(official_id, official_id, official_id)
                            )

                event_list = cursor.fetchall()
            except (Exception, psycopg2.DatabaseError) as error:
                print('Error in excute the SQL query')
            finally:
                try:
                    cursor.close()
                    conn.close()
                except (Exception, psycopg2.DatabaseError) as error:
                    print('Error in close')
            

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