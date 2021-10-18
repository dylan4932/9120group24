package Presentation;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JPanel;

/**
 * 
 * @author IwanB
 * AddEntitiesPanel is shown at the top of the event tracker window
 * - this is where all buttons used to add entities like Event/Project/User should be added
 * 
 */
public class AddEntitiesPanel extends JPanel {
	/**
	 * 
	 */
	private static final long serialVersionUID = 2256207501462485047L;
	

	private JButton addEventButton = new JButton("Add New Event");


	public AddEntitiesPanel()
	{
		setBorder(BorderFactory.createLineBorder(Color.black));
		add(addEventButton);
		updateLayout();
		addEventButton.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				AddEventDialog dialog = new AddEventDialog();
				dialog.setVisible(true);
			}
		});	
	}


	private void updateLayout() {
		BorderLayout layout = new BorderLayout();
		setLayout(layout);
		layout.addLayoutComponent(addEventButton, BorderLayout.CENTER);
	}
}
