public class QuestionsController extends COF_PageController {

    public COF_Form form {get;set;}
    public COF_Section section {get;set;} 
    public COF_QuestionSet questionSet {get; set;}
    public COF_Page currentPage {get; set;}
    public List<COF_Field> fields {get; set;}

    public SObject application {get;set;} 
    public SObject targetObject {get;set;}
    public List<SObject> targetObjects {get; set;}

    public String modifyChildIdentifier {get;set;}


    public QuestionsController() {

        COF_Config config = COF_Config.load();
        this.form = config.getForm(this.getFormIdentifierParam());
        this.section = form.getSection(this.getSectionIdentifierParam());
        if (this.section != null) {
            this.questionSet = this.section.getQuestionSet();
        } else {
            this.questionSet = COF_QuestionSet.load(this.getSectionIdentifierParam());
        }

        this.application = this.getApplication();
        this.currentPage = this.questionSet.getPage(this.getPageIdentifierParam());

        if (this.currentPage.questions != null) {
            this.prepareQuestions();
        }

        if (this.currentPage.children != null) {
            this.prepareChildren();
        }
    }

    public void prepareQuestions() {
        List<COF_Field> fields = new List<COF_Field>();
        List<String> fieldIdentifiers = new List<String>();
        for (COF_QuestionSet.COF_Question question : this.currentPage.questions) {
            fieldIdentifiers.add(question.target_field);
            COF_Field newField = new COF_Field(question.target_field, this.questionSet.target_object);
            newField.guidance = question.guidance;
            if (question.recommended_word_limit != null) {
                newField.recommendedWordLimit = question.recommended_word_limit;
            }
            fields.add(newField);
            // Use prepareFields on page instead
        }

        this.fields = fields;

        System.debug(this.questionSet.target_object);
        String targetIdentifier = this.getRecordIdentifierParam();
        if (targetIdentifier == null) {
            this.targetObject = Query.object(this.questionSet.target_object, fieldIdentifiers, 'where ' +  this.questionSet.parent_relationship + '.identifier__c = \'' + this.getApplicationIdentifierParam() + '\'');
        } else {
            this.targetObject = Query.object(this.questionSet.target_object, fieldIdentifiers, 'where ' +  'identifier__c = \'' + targetIdentifier + '\'');            
        }

        // Manually handle our custom date fields
        for (COF_Field field : this.fields) {
            if (field.isDateField == true) {
                Date currentDate = (Date) this.targetObject.get(field.identifier);
                if (currentDate != null) {
                    field.dateDay = String.valueOf(currentDate.day());
                    field.dateMonth = String.valueOf(currentDate.month());
                    field.dateYear = String.valueOf(currentDate.year());
                }
            }
        }

    }

    public void prepareChildren() {
        List<String> fields = new List<String>();
        fields.add(this.currentPage.children.target_field);
        fields.add('CreatedDate');
        fields.add('identifier__c');
        String appIdentifier = this.getApplicationIdentifierParam();
        this.targetObjects = Query.objects(this.currentPage.children.target_object, fields, 'where application__r.identifier__c = \'' + appIdentifier + '\'order by CreatedDate asc');
    }

    public void saveTargetObject() {
        // Manually handle our custom date fields
        for (COF_Field field : this.fields) {
            if (field.isDateField == true) {
                // Error - Should check all fields
                if (field.dateDay != null && field.dateDay != '') {
                    Date datevalue = date.parse(field.dateDay + '/' + field.dateMonth + '/' + field.dateYear);
                    this.targetObject.put(field.identifier, datevalue);
                }
            }
        }

        // Attempt to update the target object
        if (this.targetObject != null) { 
            update this.targetObject;
        }
    }

    public PageReference saveContinue() {

        if (this.targetObject != null) {
            this.saveTargetObject();
        }

        PageReference nextPage = Page.Questions;
        nextPage.getParameters().put('form', this.getFormIdentifierParam());
        nextPage.getParameters().put('id', this.getRecordIdentifierParam());
        nextPage.getParameters().put('app', this.getApplicationIdentifierParam());
        nextPage.getParameters().put('section', this.getSectionIdentifierParam());
        nextPage.setRedirect(true);

       // If we have a completion path, pass to the next page
        String completionPath = ApexPages.currentPage().getParameters().get('completion');
        if (completionPath != null) {
            nextPage.getParameters().put('completion', completionPath);
        }

        // switch to using the router class

        // Determine if we have routes
        if (this.currentPage.routes != null) {
            // Loop through the routes from this page
            for (COF_QuestionSet.COF_Route route : this.currentPage.routes) {
                // Determine if constraints apply
                if (route.constraints != null) {
                    for (COF_QuestionSet.COF_Constraint constraint : route.constraints) {
                        // Test constraint - extend to use operator
                        // Need to ensure we've included this value in the original SF object lookup 
                        if (this.targetObject.get(constraint.field) == constraint.value) {
                            // Valid constraint - redirect based on this route
                            nextPage.getParameters().put('page', String.valueOf(route.target_page));
                            return nextPage;
                        }
                    }
                } else {
                    // No constraints - redirect based on this route
                    nextPage.getParameters().put('page', String.valueOf(route.target_page));
                    return nextPage;
                }
            }
        }
        
        // No valid routes so redirect to summary
        nextPage = Page.Summary;
        nextPage.getParameters().put('form', this.getFormIdentifierParam());
        nextPage.getParameters().put('app', this.getApplicationIdentifierParam());
        nextPage.getParameters().put('section', this.getSectionIdentifierParam());

        // If we have a completion path, pass to the summary page
        if (completionPath != null) {
            nextPage.getParameters().put('completion', completionPath);
        }
        nextPage.setRedirect(true);
        
        return nextPage;
    }

    public PageReference saveExit() {

        if (this.targetObject != null) {
            this.saveTargetObject();
        }

        PageReference nextPage = Page.Sections;
        nextPage.getParameters().put('form', this.getFormIdentifierParam());
        nextPage.getParameters().put('app', this.getApplicationIdentifierParam());
        return nextPage;
    }

    public PageReference addAnother() {

        // Create a new child
        SObject newChild;
        if (this.currentPage.children.target_object == 'Form_LCF_Outcome_1__c') {
            newChild = new Form_LCF_Outcome_1__c();
        }

        // Set the parent application and save
        newChild.put('application__c', application.Id);
        Database.SaveResult result = Database.insert(newChild);
        if (result.isSuccess() == true) {
            System.Debug(result);
            List<String> fieldIdentifiers = new List<String>();
            fieldIdentifiers.add('identifier__c');
            SObject childFetched = Query.object(this.currentPage.children.target_object, fieldIdentifiers, 'where ' +  'id = \'' + result.getId() + '\'');

            PageReference nextPage = Page.questions;
            nextPage.getParameters().put('form', this.getFormIdentifierParam());
            nextPage.getParameters().put('app', this.getApplicationIdentifierParam());
            nextPage.getParameters().put('section', this.currentPage.children.section);
            nextPage.getParameters().put('id', (String)childFetched.get('identifier__c'));
            nextPage.getParameters().put('page', '1');
            String completion = '/apex/questions?app=' + this.getApplicationIdentifierParam();
            completion += '&form=' + this.getFormIdentifierParam();
            completion += '&section=' + this.getSectionIdentifierParam();
            completion += '&page=' + this.getPageIdentifierParam();
            nextPage.getParameters().put('completion', completion); 
            nextPage.setRedirect(true);
            return nextPage;
        }

        // Error
        return new PageReference('');

    }

    public PageReference changeChild() {

        PageReference nextPage = Page.questions;
        nextPage.getParameters().put('form', this.getFormIdentifierParam());
        nextPage.getParameters().put('app', this.getApplicationIdentifierParam());
        nextPage.getParameters().put('section', this.currentPage.children.section);
        nextPage.getParameters().put('id', this.modifyChildIdentifier);
        nextPage.getParameters().put('page', '1');
        String completion = '/apex/questions?app=' + this.getApplicationIdentifierParam();
        completion += '&form=' + this.getFormIdentifierParam();
        completion += '&section=' + this.getSectionIdentifierParam();
        completion += '&page=' + this.getPageIdentifierParam();
        nextPage.getParameters().put('completion', completion); 
        nextPage.setRedirect(true);
        return nextPage;

    }

    public PageReference removeChild() {
        return new PageReference('');

    }
}