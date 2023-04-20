package Business;

import java.util.Vector;

import Data.RepositoryProviderFactory;

/**
 * Encapsulates any business logic to be executed on the app server; 
 * and uses the data layer for data queries/creates/updates/deletes
 * @author IwanB
 *
 */
public class EventProvider implements IEventProvider{

	/**
	 * check credentials is in the database and return their agentId (or 0 if not known)
	 * @param userName : the userName of agent credentials
	 * @param password : the password of agent credentials
	 */
	@Override
	public int checkUserCredentials(String userName, String password) {
		return RepositoryProviderFactory.getInstance().getRepositoryProvider().checkUserCredentials(userName, password);
	}

	/**
	 * Update the details for a given event
	 * @param event : the event for which to update details
	 */
	@Override
	public void updateEvent(Event event) {
		RepositoryProviderFactory.getInstance().getRepositoryProvider().updateEvent(event);
	}

	/**
	 * Find the events associated in some way with a sales agent
	 * events associated with the agent id parameter below should be included in the result
	 * @param id
	 * @return
	 */
	@Override
	public Vector<Event> findEventsByOfficial(int id) {		
		return RepositoryProviderFactory.getInstance().getRepositoryProvider().findEventsByOfficial(id);
	}
	
	/**
	 * Add the details for a new event to the database
	 * @param event : the new event to add
	 */
	@Override
	public void addEvent(Event event) {
		RepositoryProviderFactory.getInstance().getRepositoryProvider().addEvent(event);
	}

	/**
	 * Given an expression searchString like 'word' or 'this phrase', this method should return any events
	 * that contains this phrase.
	 * @param searchString: the searchString to use for finding events in the database
	 * @return
	 */
	@Override
	public Vector<Event> findEventsByCriteria(String searchString) {
		return RepositoryProviderFactory.getInstance().getRepositoryProvider().findEventsByCriteria(searchString);

	}

}
