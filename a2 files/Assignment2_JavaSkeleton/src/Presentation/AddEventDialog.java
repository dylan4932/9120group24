package Presentation;

import java.awt.BorderLayout;

import javax.swing.JDialog;

import Business.Event;

/**
 * 
 * @author IwanB
 *
 * AddEventDialog - used to add a new event
 * 
 */
public class AddEventDialog extends JDialog{

	/**
	 * 
	 */
	private static final long serialVersionUID = 173323780409671768L;
	
	/**
	 * detailPanel: reuse EventDetailPanel to add events
	 */
	private EventDetailPanel detailPanel = new EventDetailPanel(false);

	public AddEventDialog()
	{
		setTitle(StringResources.getAppTitle());
		detailPanel.initEventDetails(getBlankEvent());
		add(detailPanel);
		updateLayout();
		setSize(400, 400);
	}

	private void updateLayout() {
		BorderLayout layout = new BorderLayout();
		setLayout(layout);
		layout.addLayoutComponent(detailPanel, BorderLayout.CENTER);
	}

	private Event getBlankEvent() {
		Event event = new Event();
		return event;
	}
}
