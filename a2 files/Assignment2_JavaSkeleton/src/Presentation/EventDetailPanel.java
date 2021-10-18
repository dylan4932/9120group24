package Presentation;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.Date;

import javax.swing.BorderFactory;
import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextArea;
import javax.swing.JTextField;

import Business.BusinessComponentFactory;
import Business.Event;


/**
 * 
 * @author IwanB
 * Panel used for creating and updating events
 */
public class EventDetailPanel extends JPanel implements IEventSelectionNotifiable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 2031054367491790942L;
	
	private Event currentEvent = null;
	private boolean isUpdatePanel = true;
	
	private JTextField eventIdField;
	private JTextField sportField;
	private JTextField refereeField;
	private JTextField judgeField;
	private JTextField medalGiverField;
	private JTextArea eventNameArea;
	
	/**
	 * Panel used for creating and updating events
	 * @param isUpdatePanel : describes whether panel will be used to either create or update event
	 */
	public EventDetailPanel(boolean isUpdatePanel)
	{
		this.setBorder(BorderFactory.createLineBorder(Color.black));
		this.isUpdatePanel = isUpdatePanel;
	}

	/**
	 * Re-populates panel details with given event object
	 * @param event new event object to populate panel details with
	 */
	public void initEventDetails(Event event) {
		removeAll();	
		if(event != null)
		{
			currentEvent = event;
			addAll();
		}
	}

	private void addAll() {
		JPanel lTextFieldPanel = new JPanel();
		BoxLayout lTextFieldLayout = new BoxLayout(lTextFieldPanel, BoxLayout.Y_AXIS);
		lTextFieldPanel.setLayout(lTextFieldLayout);

		BorderLayout lPanelLayout = new BorderLayout();	
		lPanelLayout.addLayoutComponent(lTextFieldPanel, BorderLayout.NORTH);

		//create event text fields
		//application convention is to map null to empty string (if db has null this will be shown as empty string)
		if(currentEvent.getEventId() > 0) {
			eventIdField = createLabelTextFieldPair(StringResources.getEventIdLabel(), ""+currentEvent.getEventId(), lTextFieldPanel);
			eventIdField.setEditable(false);
		}

		sportField = createLabelTextFieldPair(StringResources.getSportLabel(), currentEvent.getSport() == null ? "" : currentEvent.getSport(), lTextFieldPanel);
		refereeField = createLabelTextFieldPair(StringResources.getRefereeLabel(), currentEvent.getReferee() == null ? "" : ""+currentEvent.getReferee(), lTextFieldPanel);
		judgeField = createLabelTextFieldPair(StringResources.getJudgeLabel(),currentEvent.getJudge() == null ? "" : ""+ currentEvent.getJudge(), lTextFieldPanel);
		medalGiverField = createLabelTextFieldPair(StringResources.getMedalGiverLabel(), currentEvent.getMedalGiver() == null ? "" : ""+currentEvent.getMedalGiver(), lTextFieldPanel);
		add(lTextFieldPanel);

		//create event name text area
		eventNameArea = new JTextArea(currentEvent.getEventName() == null ? "" : currentEvent.getEventName());
		eventNameArea.setAutoscrolls(true);
		eventNameArea.setLineWrap(true);
		lPanelLayout.addLayoutComponent(eventNameArea, BorderLayout.CENTER);
		add(eventNameArea);
		
		//create event save (create or update button)
		JButton saveButton = createEventSaveButton();
		lPanelLayout.addLayoutComponent(saveButton, BorderLayout.SOUTH);
		this.add(saveButton);

		setLayout(lPanelLayout);
		updateUI();
	}

	private JButton createEventSaveButton() {
		JButton saveButton = new JButton(isUpdatePanel ? StringResources.getEventUpdateButtonLabel() : 
			StringResources.getEventAddButtonLabel());
		saveButton.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				//application convention is to map empty string to null (i.e. if app has empty string - this will be null in db)
				currentEvent.setSport(sportField.getText().equals("") ? null : sportField.getText());
				currentEvent.setReferee(refereeField.getText().equals("") ? null : refereeField.getText());
				currentEvent.setJudge(judgeField.getText().equals("") ? null : judgeField.getText());
				currentEvent.setMedalGiver(medalGiverField.getText().equals("")  ? null : medalGiverField.getText());
				currentEvent.setEventName(eventNameArea.getText().equals("")  ? null : eventNameArea.getText());

				if(isUpdatePanel) {
					BusinessComponentFactory.getInstance().getEventProvider().updateEvent(currentEvent);
				}
				else {
					BusinessComponentFactory.getInstance().getEventProvider().addEvent(currentEvent);
				}
			}
		});
		
		return saveButton;
	}

	private JTextField createLabelTextFieldPair(String label, String value, JPanel container) {
		
		JPanel pairPanel = new JPanel();
		JLabel jlabel = new JLabel(label);
		JTextField field = new JTextField(value);
		pairPanel.add(jlabel);
		pairPanel.add(field);

		container.add(pairPanel);

		BorderLayout lPairLayout = new BorderLayout();
		lPairLayout.addLayoutComponent(jlabel, BorderLayout.WEST);
		lPairLayout.addLayoutComponent(field, BorderLayout.CENTER);
		pairPanel.setLayout(lPairLayout);	
		
		return field;
	}

	/**
	 * Implementation of IEventSelectionNotifiable::eventSelected used to switch event
	 * displayed on EventDisplayPanel
	 */
	@Override
	public void eventSelected(Event event) {
		initEventDetails(event);
	}
	
	/**
	 * Clear event details panel
	 */
	public void refresh()
	{
		initEventDetails(null);
	}
}
