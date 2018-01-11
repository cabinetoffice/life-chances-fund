/**
 * Applications Controller
 */
public class ApplicationsController extends COF_PageController {

		public COF_Form form {get;set;}
		public List<SObject> applications {get;set;} 

	    public ApplicationsController() {
	    	COF_Config config = COF_Config.load();
			this.form = config.getForm(this.getFormIdentifierParam());

			// Get the application
	        List<String> fields = new List<String>();
	        fields.add('identifier__c');
	        fields.add('theme__c');
	        this.applications = Query.objects('Application__c', fields, '');
	        // throw exception
	        System.debug(this.applications);
	    }

    public PageReference newApplication() {

        PageReference nextPage = Page.new;
        nextPage.setRedirect(true);
        return nextPage;
    }

}