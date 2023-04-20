package Presentation;

import java.awt.BorderLayout;
import java.awt.EventQueue;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Vector;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.JPasswordField;

import Business.BusinessComponentFactory;
import Business.Event;

public class EventTrackerFrame extends JFrame {
	/**
	 * 
	 */
	private static final long serialVersionUID = 5532618722097754725L;
	
	private AddEntitiesPanel addEntitiesPanel = null;
	private EventDetailPanel detailPanel = null;
	private EventSidePanel sidePanel = null;
	
	
	private int loggedInUserId = -1;

	/**
	 * Main event tracker frame
	 * Logs on the user
	 * Initialize side panel + add entities panel + containing event list + detail panel
	 */
	public EventTrackerFrame()
	{
		setTitle(StringResources.getAppTitle());
	    setLocationRelativeTo(null);
	    
	    logOnUser();
	    initialise();
	    
	    setDefaultCloseOperation(EXIT_ON_CLOSE);  
	}
	
	/**
	 *  !!! 
	 *  Only used to simulate logon
	 *  This should really be implemented using proper salted hashing
	 *	and compare hash to that in DB
	 *  really should display an error message for bad login as well
	 *	!!!
	 */
	private void logOnUser() {
		boolean OK = false;
		while (!OK) {		
				String user = (String)JOptionPane.showInputDialog(
									this,
									null,
									StringResources.getEnterUserNameString(),
									JOptionPane.QUESTION_MESSAGE);
				
				JPasswordField jpf = new JPasswordField();
				int okCancel = JOptionPane.showConfirmDialog(
									null,
									jpf,
									StringResources.getEnterPasswordString(),
									JOptionPane.OK_CANCEL_OPTION,
									JOptionPane.QUESTION_MESSAGE);
				
				String password = null;
				if (okCancel == JOptionPane.OK_OPTION) {
					password = new String(jpf.getPassword());
				}

				if (user == null || password == null)
					System.exit(0);
				else
					if (!user.isEmpty() && !password.isEmpty()) {
						loggedInUserId = checkUserCredentials(user, password);
						if (loggedInUserId != 0)
							OK = true;
					}
		}
	}

	private void initialise()
	{
		addEntitiesPanel = new AddEntitiesPanel();	
	    detailPanel = new EventDetailPanel(true);	    
	    sidePanel = getSidePanel(new EventListPanel(getAllEvents()));
	    
	    BorderLayout borderLayout = new BorderLayout();
	    borderLayout.addLayoutComponent(addEntitiesPanel, BorderLayout.NORTH);
	    borderLayout.addLayoutComponent(sidePanel, BorderLayout.WEST);
	    borderLayout.addLayoutComponent(detailPanel, BorderLayout.CENTER);
	    
	    JButton  refreshButton = new JButton(StringResources.getRefreshButtonLabel());
	    final EventTrackerFrame frame = this;
	    refreshButton.addActionListener(new ActionListener() {			
			@Override
			public void actionPerformed(ActionEvent e) {
				frame.refresh(frame.getAllEvents());
			}
		});
	    
	    borderLayout.addLayoutComponent(refreshButton, BorderLayout.SOUTH);
	    
	    this.setLayout(borderLayout);
	    this.add(addEntitiesPanel);
	    this.add(refreshButton);
	    this.add(sidePanel);
	    this.add(detailPanel);
	    this.setSize(600, 300);
	}
	
	private EventSidePanel getSidePanel(EventListPanel listPanel)
	{
		final EventTrackerFrame frame = this;
		listPanel.registerEventSelectionNotifiableObject(detailPanel);
		return new EventSidePanel(new ISearchEventListener() {
			@Override
			public void searchClicked(String searchString) {
				frame.refresh(frame.findEventsByTitle(searchString));
			}
		},listPanel);
	}
	
	private int checkUserCredentials(String userName, String password)
	{
		return BusinessComponentFactory.getInstance().getEventProvider().checkUserCredentials(userName, password);
	}
	
	private Vector<Event> getAllEvents()
	{
		return BusinessComponentFactory.getInstance().getEventProvider().findEventsByOfficial(loggedInUserId);
	}
	
	private Vector<Event> findEventsByTitle(String pSearchString)
	{
		pSearchString = pSearchString.trim();
		if (!pSearchString.equals(""))
			return BusinessComponentFactory.getInstance().getEventProvider().findEventsByCriteria(pSearchString);
		else
			return BusinessComponentFactory.getInstance().getEventProvider().findEventsByOfficial(loggedInUserId);
	}
	
	private  void refresh(Vector<Event> events)
	{
		if(sidePanel != null && detailPanel!= null)
		{
			sidePanel.refresh(events);
			detailPanel.refresh();
			sidePanel.registerEventSelectionNotifiableObject(detailPanel);
		}
	}
	
	
	public static void main(String[] args)
	{
        EventQueue.invokeLater(new Runnable() {
            @Override
            public void run() {
            	EventTrackerFrame ex = new EventTrackerFrame();
                ex.setVisible(true);
            }
        });		
	}
}
