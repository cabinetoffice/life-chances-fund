/**
 * COF_DatabaseQuery
 * Cabinet Office Forms 1.0
 *
 * This class wraps the database query class adding convinence methods. 
 * Current not in use - Summary and Questions controllers use earlier Query class
 */
public class COF_DatabaseQuery {

	/**
	 * Returns the matching objects given a target object, list of required fields and any constraints
	 */
	public sObject getObject(String targetObject, String[] fields, String constraint) {
		String fieldsQueryComponent = this.getFieldsQueryComponent(fields);
        String query = 'Select ' + fieldsQueryComponent + ' from ' + targetObject + ' ' + constraint + ' limit 1';
        sObject result = Database.query(query);
       	if (result == null)
            return null;
       		// Throw exception
        return result;
	}

	/**
	 * Returns the matching objects given a target object, list of required fields and any constraints
	 */
	public List<sObject> getObjects(String targetObject, String[] fields, String constraint) {
		String fieldsQueryComponent = this.getFieldsQueryComponent(fields);
		String query = 'Select ' + fieldsQueryComponent + ' from ' + targetObject + ' ' + constraint + ' order by CreatedDate asc';
        List<sObject> result = Database.query(query);
       	if (result == null)
            return null;
       		// Throw exception
        return result;
	}

	/**
	 * Returns a fields query string component given an array of fields
	 */
	private String getFieldsQueryComponent(String[] fields) {
		String fieldsStr = '';
        if (fields != NULL) {
            if(fields.size() > 0) {
                for (Integer i=0; i < fields.size(); i++) {
                    if( i <= (fields.size() - 2))
                        fieldsStr = fieldsStr+fields[i]+',';
                    else
                        fieldsStr = fieldsStr+fields[i];    
                }
            }
        } 
        return fieldsStr;
	}
}