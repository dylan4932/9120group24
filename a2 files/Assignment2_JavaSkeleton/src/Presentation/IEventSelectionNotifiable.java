package Presentation;

import Business.Event;

/**
 * 
 * @author IwanB
 * 
 * Used to notify any interested object that implements this interface
 * and registers with EventListPanel of an EventSelection
 *
 */
public interface IEventSelectionNotifiable {
	public void eventSelected(Event event);
}
