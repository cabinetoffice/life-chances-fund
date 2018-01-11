public class Query {

    // refactor to take a set of fields and remove duplication
    public static sObject object(String targetObject, Set<String> fields, String constraint) {
        return null;
    }

	public static sObject object(String targetObject, String[] fields, String constraint) {
		sObject queryresult;
        String fieldslist = '';
        // Generate the fieldslist from the string array
        if (fields != NULL)
        {
            if(fields.size() > 0)
            {
                for (Integer i=0; i < fields.size(); i++)
                {
                    if( i <= (fields.size() - 2))
                        fieldslist = fieldslist+fields[i]+',';
                    else
                        fieldslist = fieldslist+fields[i];    
                }
            }
        } 
        // Construct the query string
        String soqlquery = 'Select ' + fieldslist + ' from ' + targetObject + ' ' + constraint + ' limit 1';
        // Run the query
        System.debug(soqlquery);
        queryresult = Database.query(soqlquery);
        return queryresult; 
	}

    public static List<sObject> objects(String targetObject, String[] fields, String constraint)
    {
        List<sObject> queryresult;
        String fieldslist = '';
        // Generate the fieldslist from the string array
        if (fields != NULL)
        {
            if(fields.size() > 0)
            {
                for (Integer i=0; i < fields.size(); i++)
                {
                    if( i <= (fields.size() - 2))
                        fieldslist = fieldslist+fields[i]+',';
                    else
                        fieldslist = fieldslist+fields[i];    
                }
            }
        } 
        // Construct the query string
        String soqlquery = 'Select ' + fieldslist + ' from ' + targetObject + ' ' + constraint;
        // Run the query
        System.debug(soqlquery);
        queryresult = Database.query(soqlquery);
        return queryresult;               
    }
}