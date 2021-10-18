package Presentation;


/**
 * 
 * @author IwanB
 *
 * Used to notify any interested object that implements this interface
 * and is used to construct PatientSearchComponents of a search that was issued
 * 
 */
public interface ISearchEventListener {
	public void searchClicked(String searchString);
}
