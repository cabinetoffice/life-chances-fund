public class SummaryController extends COF_PageController {

	public COF_Form form {get;set;}
    public COF_Section section {get;set;}
    public COF_QuestionSet questionSet {get;set;}
    public SObject application {get;set;}
    public SObject targetObject {get;set;}

    public List<COF_Page> validPages {get;set;}

    public SummaryController() {

        COF_Config config = COF_Config.load();
        this.form = config.getForm(this.getFormIdentifierParam());
        this.section = form.getSection(this.getSectionIdentifierParam());
        this.questionSet = this.section.getQuestionSet();
        this.application = this.getApplication();

        // Validate these mandatory variables are present and throw exception otherwise

        // Prepare and fetch target object
        this.fetchTargetObject();

        // Create holding array for pages to summarise
        this.validPages = new List<COF_Page>();

        // Create a new router object
        COF_Router router = new COF_Router();
        router.targetObject = targetObject;
        router.questionSet = questionSet;

        // Start on the first page
        COF_Page nextPage = this.questionSet.getPage('1');
        do {
            if (nextPage != null) {
                validPages.add(nextPage);
                System.debug(nextPage);
                nextPage.prepareFields(this.questionSet.target_object);
            }
            // Use the route to determine the next page
            nextPage = router.nextFromPage(nextPage);
        } while (nextPage != null);

    }

    /**
     * Fetches the target object
     */
    public void fetchTargetObject() {
        
        // Generate list of all possible fields we might require on the target object
        Set<String> requiredFieldIdentifiers = new Set<String>();
        for (COF_Page page : this.questionSet.pages) {
            // Loop through the questions
            if (page.questions != null) {
                for (COF_QuestionSet.COF_Question question : page.questions) {
                    requiredFieldIdentifiers.add(question.target_field);
                }
            }
            // Loop through the route constraints
            if (page.routes != null) {
                for (COF_QuestionSet.COF_Route route : page.routes) {
                    if (route.constraints != null) {
                        for (COF_QuestionSet.COF_Constraint constraint : route.constraints) {
                            requiredFieldIdentifiers.add(constraint.field);
                        }
                    }
                }
            }
        }

        // Fetch the target object
        List<String> requiredFieldIdentifiersArray = new List<String>(requiredFieldIdentifiers);
        this.targetObject = Query.object(this.questionSet.target_object, requiredFieldIdentifiersArray, 'where ' +  this.questionSet.parent_relationship + '.identifier__c = \'' + this.getApplicationIdentifierParam() + '\'');
    }

    public PageReference complete() {

        // Check mandatory fields are complete

        String completionPath = ApexPages.currentPage().getParameters().get('completion');
        if (completionPath != null) {
            PageReference nextPage = new PageReference(completionPath);
            return nextPage;
        }

    	// update ov_section_status__c

       	PageReference nextPage = Page.Sections;
        nextPage.getParameters().put('form', this.getFormIdentifierParam());
        nextPage.getParameters().put('app', this.getApplicationIdentifierParam());
        return nextPage;
    }

    public PageReference saveExit() {

        String completionPath = ApexPages.currentPage().getParameters().get('completion');
        if (completionPath != null) {
            PageReference nextPage = new PageReference(completionPath);
            return nextPage;
        }

        PageReference nextPage = Page.Sections;
        nextPage.getParameters().put('form', this.getFormIdentifierParam());
        nextPage.getParameters().put('app', this.getApplicationIdentifierParam());
        return nextPage;
    }

}