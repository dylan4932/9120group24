package Business;

import java.util.Vector;

/**
 * Encapsulates any business logic to be executed on the app server; 
 * and uses the data layer for data queries/creates/updates/deletes
 * @author IwanB
 *
 */
public interface IEventProvider {

	/**
	 * check credentials is in the database and return their userId (or 0 if not known)
	 * @param userName : the userName of user credentials
	 * @param password : the password of user credentials
	 */
	public int checkUserCredentials(String userName, String password);
	
	/**
	 * Find the events associated in some way with a user
	 * Events which have the id parameter below should be included in the result
	 * @param id
	 * @return
	 */
	public Vector<Event> findEventsByOfficial(int id);
	
	/**
	 * Given an expression searchString like 'word' or 'this phrase', this method should return any events 
	 * that contains this phrase.
	 * @param searchString : the searchString to use for finding events in the database
	 * @return
	 */
	public Vector<Event> findEventsByCriteria(String searchString);	
	
	/**
	 * Add the details for a new event to the database
	 * @param event : the new event to add
	 */
	public void addEvent(Event event);

	/**
	 * Update the details for a given event
	 * @param event : the event for which to update details
	 */
	public void updateEvent(Event event);
}
