package Data;

import Presentation.IRepositoryProvider;


public class RepositoryProviderFactory {
	private static  RepositoryProviderFactory sFactory = new RepositoryProviderFactory();
	
	public static RepositoryProviderFactory getInstance()
	{
		return sFactory;
	}
	
	public IRepositoryProvider getRepositoryProvider()
	{
		return new PostgresRepositoryProvider();
	}
}
