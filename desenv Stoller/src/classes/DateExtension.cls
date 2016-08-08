public class DateExtension {
    public static Date ParaSalesforceDate(Date dataref)
    {
    	if(dataref == null)
    		return dataref;
    		
    	if(dataref < Date.newInstance(1900, 1, 1))
    		return null;
    		
    	return dataref;
    }
    
    public static Datetime ParaSalesforceDateTime(Datetime dataref)
    {
    	if(dataref == null)
    		return dataref;
    		
    	if(dataref < Datetime.newInstance(1900, 1, 1))
    		return null;
    		
    	return dataref;
    }
}