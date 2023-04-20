package Presentation;

import java.awt.BorderLayout;
import java.util.Vector;

import javax.swing.JPanel;

import Business.Event;

/**
 * 
 * Represents event list panel of event tracker that includes
 * both the search box/button and text field; AND the event list
 * @author IwanB
 *
 */
public class EventSidePanel extends JPanel{

	/**
	 * 
	 */
	private static final long serialVersionUID = 2693528613703066603L;

	private EventListPanel mListPanel;
	
	/**
	 * Represents left panel of event tracker that includes
	 * both the search box/button and text field; AND the event list
	 * 
	 * @param searchEventListener : used to retrieve user search query in search box
	 * @param listPanel : event list panel
	 */
	public EventSidePanel(ISearchEventListener searchEventListener, EventListPanel listPanel)
	{
		mListPanel = listPanel;
		EventSearchComponents searchComponents = new EventSearchComponents(searchEventListener);
	
		add(searchComponents);
		add(listPanel);
		
		BorderLayout layout = new BorderLayout();
		layout.addLayoutComponent(searchComponents, BorderLayout.NORTH);
		layout.addLayoutComponent(listPanel, BorderLayout.CENTER);
		setLayout(layout);
	}
	
	public void refresh(Vector<Event> events)
	{
		mListPanel.refresh(events);
	}
	
	public void registerEventSelectionNotifiableObject(IEventSelectionNotifiable notifiable)
	{
		mListPanel.registerEventSelectionNotifiableObject(notifiable);
	}
}
