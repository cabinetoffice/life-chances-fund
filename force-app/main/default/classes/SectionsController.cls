/**
 * Sections Controller
 */
public class SectionsController extends COF_PageController {

	public COF_Form form {get;set;}
    public SObject application {get;set;} 

    public SectionsController() {
    	COF_Config config = COF_Config.load();
		this.form = config.getForm(this.getFormIdentifierParam());
		// throw exception

        this.application = this.getApplication();
    }

    /**
     * Submit the application
     */
	public PageReference submit() {

        PageReference nextPage = Page.questions;
        nextPage.getParameters().put('template', 'lcf_eoi_org_1');
        nextPage.getParameters().put('id', 'a007E000006IpNOQA0');
        nextPage.getParameters().put('app', this.getApplicationIdentifierParam());
        nextPage.getParameters().put('page', '1');
        nextPage.setRedirect(true);
        return nextPage;
    }

    /**
     * Submit the application
     */
    public PageReference viewAll() {

        PageReference nextPage = Page.answers;
        nextPage.getParameters().put('app', this.getApplicationIdentifierParam());
        nextPage.getParameters().put('form', this.getFormIdentifierParam());
        nextPage.setRedirect(true);
        return nextPage;
    }

}