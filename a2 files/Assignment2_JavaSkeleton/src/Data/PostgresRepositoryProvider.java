package Data;

import java.sql.Connection;
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
    private final String userid = "y21s1c9120_unikey";
    private final String passwd = "passwd";
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

		return 3;
	}
	
	/**
	 * Find associated events given a userId as per the assignment description
	 * @param userId is the official id
	 * @return
	 */
	@Override
	public Vector<Event> findEventsByOfficial(int userId) {		

		Vector<Event> results = new Vector<Event>();

		Event event1 = new Event();
		event1.setEventId(3);
		event1.setEventName("Men's Team Semifinal");
		event1.setSport("Archery");
		event1.setReferee("ChrisP");
		event1.setJudge("GuoZ");
		event1.setMedalGiver("JulieA");

		Event event2 = new Event();
		event2.setEventId(1);
		event2.setEventName("Men's Singles Semifinal");
		event2.setSport("Badminton");
		event2.setReferee("JohnW");
		event2.setJudge("ChrisP");
		event2.setMedalGiver("GuoZ");
		
		results.add(event1);
		results.add(event2);

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

		Event event1 = new Event();
		event1.setEventId(3);
		event1.setEventName("Men's Team Semifinal");
		event1.setSport("Archery");
		event1.setReferee("ChrisP");
		event1.setJudge("GuoZ");
		event1.setMedalGiver("JulieA");

		Event event2 = new Event();
		event2.setEventId(1);
		event2.setEventName("Men's Singles Semifinal");
		event2.setSport("Badminton");
		event2.setReferee("JohnW");
		event2.setJudge("ChrisP");
		event2.setMedalGiver("GuoZ");

		Event event3 = new Event();
		event3.setEventId(4);
		event3.setEventName("Men's Tournament Semifinal");
		event3.setSport("Basketball");
		event3.setReferee("-");
		event3.setJudge("JohnW");
		event3.setMedalGiver("MaksimS");

		results.add(event1);
		results.add(event2);
		results.add(event3);

		return results;
	}

	/**
	 * Add a new event into the Database
	 * @param event : the new event to add
	 */
	@Override
	public void addEvent(Event event) {
	    
	}

	/**
	 * Update the details of a given event
	 * @param event : the event for which to update details
	 */
	@Override
	public void updateEvent(Event event) {
		
	}
}
