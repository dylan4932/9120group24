package Business;


public class Event {

	private int eventId = 0;
	private String eventName;
	private String sport;
	private String referee;
	private String judge;
	private String medalGiver;
	

	public int getEventId() {
		return eventId;
	}
	public void setEventId(int eventId) {
		this.eventId = eventId;
	}
	
	public String getEventName() {
		return eventName;
	}
	public void setEventName(String eventName) {
		this.eventName = eventName;
	}

	public String getSport() {
		return sport;
	}
	public void setSport(String sport) {
		this.sport = sport;
	}

	public String getReferee() {
		return referee;
	}
	public void setReferee(String referee) {
		this.referee = referee;
	}

	public String getJudge() {
		return judge;
	}
	public void setJudge(String judge) {
		this.judge = judge;
	}
	
	public String getMedalGiver() {
		return medalGiver;
	}
	public void setMedalGiver(String medalGiver) {
		this.medalGiver = medalGiver;
	}
	
	public String toString()
	{
		return getEventName();
	}
}
