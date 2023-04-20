package Data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import org.postgresql.ds.PGSimpleDataSource;
import Business.Event;
import Presentation.IRepositoryProvider;

/**
 * Encapsulates create/read/update/delete operations to PostgreSQL database
 * @author IwanB
 */
public class PostgresRepositoryProvider implements IRepositoryProvider {
	//DB connection parameters - ENTER YOUR LOGIN AND PASSWORD HERE
    private final String userid = "y21s2c9120_yuji0713";
    private final String passwd = "1997";
    private final String myHost = "soit-db-pro-2.ucc.usyd.edu.au";

	private Connection openConnection() throws SQLException
	{
		PGSimpleDataSource source = new PGSimpleDataSource();
		source.setServerName(myHost);
		source.setDatabaseName(userid);
		source.setUser(userid);
		source.setPassword(passwd);
		Connection conn = source.getConnection();
	    
	    return conn;
	}

	/**
	 * Validate a user login request
	 * @param userName: the user userName trying to login
	 * @param password: the user password used to login
	 * @return userId for user
	 */
	@Override
	public int checkUserCredentials(String userName, String password) {

		Connection conn = null;
		try
		{
			conn = openConnection();
		}
		catch(SQLException error)
		{
			System.out.println(error);
		}
		
		if(conn!=null) {
			try
			{
				PreparedStatement stmt=conn.prepareStatement("select officialid from official where username=? and password=?");
				stmt.setString(1, userName);
				stmt.setString(2, password);
				ResultSet resultSet=stmt.executeQuery();
				
				if(resultSet.next()) {
				System.out.println(resultSet.getInt("officialid"));  
				return resultSet.getInt("officialid");
				}
		    }
			catch (SQLException error)
			{
				System.out.println(error);
			}
			finally
			{
				try
				{
					conn.close();
			}
				
				catch (SQLException error)
				{
					System.out.println(error);
			}
			}
		}
		System.out.println("login failed");
		return 0;
	}
	
	/**
	 * Find associated events given a userId as per the assignment description
	 * @param userId is the official id
	 * @return
	 */
	@Override
	public Vector<Event> findEventsByOfficial(int userId) {		

		Vector<Event> results = new Vector<Event>();
		Connection conn = null;
		
		try {
			conn = openConnection();
		}
		catch(SQLException e)
		{
			System.out.print(e);
		}
		
		if(conn!=null) {
			try{
				PreparedStatement stmt = conn.prepareStatement(
						"select new_table.eventname, new_table.eventid,sportname, new_table.referee,new_table.judge, new_table.award from \r\n" +
				        "(select e.eventname, e.eventid, s.sportname, referee.officialid as r_id, referee.username as referee, \r\n" +
						"judge.officialid as j_id, judge.username as judge, award.officialid as a_id, award.username as award \r\n"	+	
					    "from event e join (select officialid, username from official)referee on e.referee = referee.officialid \r\n" +
						"join(select officialid, username from official)judge on e.judge = judge.officialid \r\n" +
					    "join(select officialid, username from official)award on e.medalgiver = award.officialid \r\n" +
					    "join sport s on s.sportid = e.sportid \r\n" +
						"order by s.sportname) as new_table \r\n" +
					    "where r_id = ? or j_id =? or a_id =?"
						) ;
				
				stmt.setInt(1, userId);
				stmt.setInt(2, userId);
				stmt.setInt(3, userId);
				
				ResultSet resultSet = stmt.executeQuery();
				
				while(resultSet.next()) {
					Event event =new Event();
					int id = resultSet.getInt("eventid");
					event.setEventId(id);
					
					String eventName = resultSet.getString("eventname");
					event.setEventName(eventName);
					
					String sportName = resultSet.getString("sportname");
					event.setSport(sportName); 
					
					String ref = resultSet.getString("referee");
					event.setReferee(ref);
					
					String judge = resultSet.getString("judge");
					event.setJudge(judge);
					
					String award = resultSet.getString("award");
					event.setMedalGiver(award);;
					results.add(event);
					System.out.println("--");
					
				}
				stmt.close();
			}
			catch (SQLException e)
			{
				System.out.println(e);
			}
			finally {
				try {
					conn.close();
				}catch (SQLException e)
				{
					System.out.println(e);
				}
			}
		}

		
		return results;
	}

	/**
	 * Find a list of events based on the searchString provided as parameter
	 * @param searchString : see assignment description for search specification
	 * @return
	 */
	@Override
	public Vector<Event> findEventsByCriteria(String searchString) {		

		Vector<Event> results = new Vector<Event>();
		Connection conn = null;
		
		try {
			conn = openConnection();
		}
		catch(SQLException e)
		{
			System.out.print(e);
		}
		
		if(conn!=null) {
			try{
				PreparedStatement stmt = conn.prepareStatement(
						"select new_table.eventname, new_table.eventid,sportname, new_table.referee,new_table.judge, new_table.award from \r\n" +
				        "(select e.eventname, e.eventid, s.sportname, referee.officialid as r_id, referee.username as referee, \r\n" +
						"judge.officialid as j_id, judge.username as judge, award.officialid as a_id, award.username as award \r\n"	+	
					    "from event e join (select officialid, username from official)referee on e.referee = referee.officialid \r\n" +
						"join(select officialid, username from official)judge on e.judge = judge.officialid \r\n" +
					    "join(select officialid, username from official)award on e.medalgiver = award.officialid \r\n" +
					    "join sport s on s.sportid = e.sportid \r\n" +
						"order by s.sportname) as new_table \r\n" +
					    "where LOWER(sportname) LIKE LOWER(?) or LOWER(eventname) LIKE LOWER(?)" +
					    "LOWER(new_table.referee) LIKE LOWER(?) or LOWER(new_table.judge) LIKE LOWER(?)" +
					    "or LOWER(new_table.award) LIKE LOWER(?)" 
						) ;
				
				stmt.setString(1, "%"+searchString +"%");
				stmt.setString(2, "%"+searchString +"%");
				stmt.setString(3, "%"+searchString +"%");
				stmt.setString(4, "%"+searchString +"%");
				stmt.setString(5, "%"+searchString +"%");
				
				ResultSet resultSet = stmt.executeQuery();
				
				while(resultSet.next()) {
					Event event =new Event();
					int id = resultSet.getInt("eventid");
					event.setEventId(id);
					
					String eventName = resultSet.getString("eventname");
					event.setEventName(eventName);
					
					String sportName = resultSet.getString("sportname");
					event.setSport(sportName); 
					
					String ref = resultSet.getString("referee");
					event.setReferee(ref);
					
					String judge = resultSet.getString("judge");
					event.setJudge(judge);
					
					String award = resultSet.getString("award");
					event.setMedalGiver(award);;
					results.add(event);
					System.out.println("--");
					
				}
				stmt.close();
			}
			catch (SQLException e)
			{
				System.out.println(e);
			}
			finally {
				try {
					conn.close();
				}catch (SQLException e)
				{
					System.out.println(e);
				}
			}
		}

		
		return results;
	}

	/**
	 * Add a new event into the Database
	 * @param event : the new event to add
	 */
	@Override
	public void addEvent(Event event) {
		Connection conn = null;
		
		String referee = event.getReferee();
		String judge = event.getJudge();
		String award = event.getMedalGiver();
		String eventName = event.getEventName();
		String sportName = event.getSport();
		// int eventID = event.getEventId();
		
		try {
			conn = openConnection();
		}
		catch(SQLException e) {
			System.out.println(e);
		}
		
		if(conn!=null) {
			try {
				PreparedStatement st = conn.prepareStatement("select count(*) from event");
				ResultSet rs = st.executeQuery();
				rs.next();
				int count = rs.getInt(1);
				System.out.println("total row:" + count);
				PreparedStatement stmt = conn.prepareStatement("select * \r\n" +
				"from(event e join official o on o.officialid = e.referee)\r\n" +
				"where username = ?");
				stmt.setString(1, referee);
				
				 ResultSet resultSet = stmt.executeQuery();
				int refID = 0;
				if(resultSet.next()) {
					refID = resultSet.getInt("officialid");	
				}
				System.out.println(refID);
				
				
				
				PreparedStatement judgestm = conn.prepareStatement("select * \r\n"+ 
				"from(event e join official o on o.officialid = e.referee)\r\n" +
				"where username = ?" );
				judgestm.setString(1,judge);
				
				ResultSet judgeResultSet = judgestm.executeQuery();
				int judgeID = 0;
				if(judgeResultSet.next()) {
					judgeID = judgeResultSet.getInt("officialid");
					
				}
				System.out.println(judgeID);
				
				
				
		
				// PreparedStatement awardstm = conn.prepareStatement("select * \r\n"+ 
				// "from(event e join official o on o.officialid = e.referee)\r\n" +
				// "where username = ?" );
				judgestm.setString(1,award);
						
				ResultSet awardResultSet = judgestm.executeQuery();
				int awardID = 0;
				if(awardResultSet.next()) {
					judgeID = awardResultSet.getInt("officialid");
						
						}
						System.out.println(awardID);
						
			    PreparedStatement sportstm = conn.prepareStatement("select * \r\n"+ 
				"from(event e join sport s on s.sportid= e.sportid)\r\n" +
				"where sportname = ?" );
				sportstm.setString(1,sportName);
				
				ResultSet sportResultSet = sportstm.executeQuery();
				int sportID = 0;
				if(sportResultSet.next()) {
					sportID = sportResultSet.getInt("sportid");
					
				}
				System.out.println(sportID);
				
				PreparedStatement updatestmt = conn.prepareStatement(
						"INSERT INTO event (eventid, eventname, sportid, referee, judge,medalgiver)\r\n" +
				        "VALUES (?,?,?,?,?,?)");
				updatestmt.setInt(1, count+1);
				updatestmt.setString(2, eventName);
				updatestmt.setInt(3, sportID);
				updatestmt.setInt(4, refID);
				updatestmt.setInt(5, judgeID);
				updatestmt.setInt(6, awardID);
				updatestmt.executeQuery();
						
			}
			
			catch (SQLException e)
			{
				System.out.println(e);
			}
			finally {
				try {
					conn.close();
				}catch (SQLException e)
				{
					System.out.println(e);
				}
			}
		}			
				
	
	}

	/**
	 * Update the details of a given event
	 * @param event : the event for which to update details
	 */
	@Override
	public void updateEvent(Event event) {
		Connection conn = null;
		
		String referee = event.getReferee();
		String judge = event.getJudge();
		String award = event.getMedalGiver();
		String eventName = event.getEventName();
		String sportName = event.getSport();
		// int eventID = event.getEventId();
		
		try {
			conn = openConnection();
		}
		catch(SQLException e) {
			System.out.println(e);
		}
		
		if(conn!=null) {
			try {
				PreparedStatement st = conn.prepareStatement("select count(*) from event");
				ResultSet rs = st.executeQuery();
				rs.next();
				int count = rs.getInt(1);
				System.out.println("total row:" + count);

				PreparedStatement stmt = conn.prepareStatement("select * \r\n" +
				"from(event e join official o on o.officialid = e.referee)\r\n" +
				"where username = ?");
				stmt.setString(1, referee);
				
				 ResultSet resultSet = stmt.executeQuery();
				int refID = 0;
				if(resultSet.next()) {
					refID = resultSet.getInt("officialid");	
				}
				System.out.println(refID);
				
				PreparedStatement judgestm = conn.prepareStatement("select * \r\n"+ 
				"from(event e join official o on o.officialid = e.referee)\r\n" +
				"where username = ?" );
				judgestm.setString(1,judge);
				
				ResultSet judgeResultSet = judgestm.executeQuery();
				int judgeID = 0;
				if(judgeResultSet.next()) {
					judgeID = judgeResultSet.getInt("officialid");
					
				}
				System.out.println(judgeID);

				PreparedStatement awardstm = conn.prepareStatement("select * \r\n"+ 
				"from(event e join official o on o.officialid = e.referee)\r\n" +
				"where username = ?" );
				awardstm.setString(1,award);
						
				ResultSet awardResultSet = awardstm.executeQuery();
				int awardID = 0;
				if(awardResultSet.next()) {
					judgeID = awardResultSet.getInt("officialid");
						
				}
				System.out.println(awardID);
						
			    PreparedStatement sportstm = conn.prepareStatement("select * \r\n"+ 
				"from(event e join sport s on s.sportid= e.sportid)\r\n" +
				"where sportname = ?" );
				sportstm.setString(1,sportName);
				
				ResultSet sportResultSet = sportstm.executeQuery();
				int sportID = 0;
				if(sportResultSet.next()) {
					sportID = sportResultSet.getInt("sportid");
					
				}
				System.out.println(sportID);
				
				PreparedStatement updatestmt = conn.prepareStatement(
						"INSERT INTO event (eventid, eventname, sportid, referee, judge,medalgiver)\r\n" +
				        "VALUES (?,?,?,?,?,?)");
				updatestmt.setInt(1, count+1);
				updatestmt.setString(2, eventName);
				updatestmt.setInt(3, sportID);
				updatestmt.setInt(4, refID);
				updatestmt.setInt(5, judgeID);
				updatestmt.setInt(6, awardID);
				updatestmt.executeQuery();
						
			}
			
			catch (SQLException e)
			{
				System.out.println(e);
			}
			finally {
				try {
					conn.close();
				}catch (SQLException e)
				{
					System.out.println(e);
				}
			}
		}
	}			

}
