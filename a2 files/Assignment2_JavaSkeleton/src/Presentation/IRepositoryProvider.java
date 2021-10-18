package Presentation;

import java.util.Vector;

import Business.Event;

/**
 * Encapsulates create/read/update/delete operations to database
 * @author IwanB
 *
 */
public interface IRepositoryProvider {
	/**
	 * check credentials is in the database and return their agentId (or 0 if not known)
	 * @param userName : the userName of agent credentials
	 * @param password : the password of agent credentials
	 */
	public int checkUserCredentials(String userName, String password);
	
	/**
	 * Update the details for a given event
	 * @param event : the event for which to update details
	 */
	public void updateEvent(Event event);
	
	/**
	 * Find the associated events as per the assignment description
	 * @param id the agent id
	 * @return
	 */
	public Vector<Event>  findEventsByOfficial(int id);
	
	/**
	 * Find the associated events based on the searchString provided as the parameter
	 * @param searchString : see assignment description search specification
	 * @return
	 */
	public Vector<Event> findEventsByCriteria(String searchString);	
	
	/**
	 * Add the details for a new event to the database
	 * @param event : the new event to add
	 */
	public void addEvent(Event event);
}
