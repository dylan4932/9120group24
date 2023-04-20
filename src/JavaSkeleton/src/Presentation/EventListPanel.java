package Presentation;

import java.awt.BorderLayout;
import java.awt.Color;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

import javax.swing.BorderFactory;
import javax.swing.JList;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.ListSelectionModel;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;

import Business.Event;

/**
 * Panel encapsulating event list
 * @author IwanB
 *
 */
public class EventListPanel extends JPanel {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1013855025757989473L;
	
	private List<IEventSelectionNotifiable> notifiables = new ArrayList<IEventSelectionNotifiable>();
	private Vector<Event> events;
	
	/**
	 * 
	 * @param events vector of events to display in the event list panel
	 */
	public EventListPanel(Vector<Event> events)
	{
		this.events = events;
		this.setBorder(BorderFactory.createLineBorder(Color.black));	
		initList(this.events);
	}

	private void initList(Vector<Event> events) {
		
		final JList<Event> list = new JList<Event>(events);
		list.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
		list.setLayoutOrientation(JList.VERTICAL);
		JScrollPane listScroller = new JScrollPane(list);
		this.add(listScroller);
		
		BorderLayout listLayout = new BorderLayout();
		listLayout.addLayoutComponent(listScroller, BorderLayout.CENTER);
		this.setLayout(listLayout);
		list.getSelectionModel().addListSelectionListener(new ListSelectionListener()
		{
			@Override
			public void valueChanged(ListSelectionEvent e) {
				for(IEventSelectionNotifiable notifiable : notifiables)
				{
					Event selectedEvent = list.getSelectedValue();
					if(selectedEvent != null)
					{
						notifiable.eventSelected(selectedEvent);
					}
				}
			}		
		});
	}
	
	/**
	 * Refresh event list to display vector of event objects
	 * @param events - vector of event objects to display
	 */
	public void refresh(Vector<Event> events)
	{
		this.removeAll();
		this.initList(events);
		this.updateUI();
		this.notifiables.clear();
	}
	
	/**
	 * Register an object to be notified of a event selection change
	 * @param notifiable object to invoke when a new event is selected
	 */
	public void registerEventSelectionNotifiableObject(IEventSelectionNotifiable notifiable)
	{
		notifiables.add(notifiable);
	}

}
