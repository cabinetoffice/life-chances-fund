@isTest
private class SIB_ApplicationFormExtensionTest {
	
	@testSetup static void initData(){
		Theme__c theme = DataFactory.insertTheme('Test Theme');
		Application_Window__c aw = DataFactory.insertAW(theme.Id);
		Application_Window_Template__c awt = DataFactory.insertAWT(aw.Id);
		Application_Form_Section__c afs = DataFactory.insertAFS('Test Section', 'Expression of Interest');
		Application_Question__c aq = DataFactory.insertAQ('FirstName', 'Short_Text_Answer__c');
		Application_Question_Template__c aqt = DataFactory.insertAQT(awt.Id, aq.Id, afs.Id);
		Contact applicant = DataFactory.insertContact(UserInfo.getUserEmail());
		Application__c app = DataFactory.insertApplication(awt.Id, applicant.Id, 'Draft');
	}

	static testMethod void positiveTesting() {
		SIB_ApplicationFormExtension controller = new SIB_ApplicationFormExtension();
		Application__c appToUse = [
			SELECT Id
			FROM Application__c
			LIMIT 1
		];
		List<Application_Question_Template__c> aqt = [
			SELECT Id, Application_Question__c
			FROM Application_Question_Template__c
		];
		ApexPages.currentPage().getParameters().put('Id', appToUse.Id);
		controller.initialiseData();
		System.assertEquals('Development_Form_Status__c', controller.statusField);
		System.assertEquals(0, controller.applicationCommissioners.size());
		System.assertEquals(0, controller.prevApps.size());
		System.assertEquals(0, controller.applicationOutcomes.size());
		System.assertEquals(null, controller.questionNumber);
		ApexPages.currentPage().getParameters().put('formType', 'Expression of Interest');
		controller.initialiseData();
		System.assertEquals('Status__c', controller.statusField);
		ApexPages.currentPage().getParameters().put('questionNumber', '1');
		controller.setQuestionNumber();
		System.assertEquals(1, controller.questionNumber);
		controller.viewAllAnswers();
		System.assertEquals(null, controller.questionNumber);
		System.assertEquals('ALL_QUESTIONS', controller.formSection);
		System.assertEquals('Section Summary', controller.additionalSectionToShow);
		ApexPages.currentPage().getParameters().put('formSectionHeader', 'Test Section');
		controller.setFormSection();
		System.assertEquals('Test Section', controller.formSection);
		ApexPages.currentPage().getParameters().put('formSectionHeader', '');
		controller.setFormSection();
		System.assertEquals('', controller.formSection);
		System.assertEquals(null, controller.commissionerToCreate);
		System.assertEquals(null, controller.prevAppToCreate);
		System.assertEquals(null, controller.outcomeToCreate);
		controller.pageNumber = 1;
		controller.nextPage();
		System.assertEquals(2, controller.pageNumber);
		controller.previousPage();
		System.assertEquals(1, controller.pageNumber);
		controller.nextPage();
		System.assertEquals(2, controller.pageNumber);
		controller.commissionerToCreate = new Contact(
			Email = 'test'
		);
		controller.nextPage();
		System.assertEquals(1, ApexPages.getMessages().size());
		controller.organisationToCreate = new Account();
		controller.createCommissioner();
		controller.commissionerToCreate.Email = 'test@test.com';
		controller.commissionerToCreate.LastName = 'Test';
		controller.organisationToCreate.Name = 'Test Org Name';
		controller.insertCommissioner();
		ApexPages.currentPage().getParameters().put('commissionerIndex', '0');
		ApexPages.currentPage().getParameters().put('pageNumberToSet', '1');
		controller.setCommissioner();
		System.assertEquals(controller.commissionerToCreate.Email, 'test@test.com');
		controller.deleteCommissioner();
		System.assertEquals(0, controller.applicationCommissioners.size());
		controller.organisationToCreate = new Account();
		controller.createCommissioner();
		controller.commissionerToCreate.Email = 'test';
		controller.insertCommissioner();
		System.assertEquals(4, ApexPages.getMessages().size());
		System.assertEquals('Please enter organisation name', ApexPages.getMessages()[1].getDetail());
		System.assertEquals('Please enter commissioner last name', ApexPages.getMessages()[2].getDetail());
		System.assertEquals('Required fields are missing: [Name]', ApexPages.getMessages()[3].getDetail());
		System.assertEquals(null, controller.questionNumber);
		ApexPages.currentPage().getParameters().put('questionNumber', '1');
		controller.setQuestionNumber();
		System.assertEquals(null, controller.questionNumber);
		controller.createOutcome();
		System.assertNotEquals(null, controller.outcomeToCreate);
		System.assertEquals(1, controller.pageNumber);
		System.assertEquals(0, controller.applicationOutcomes.size());
		controller.insertOutcome();
		System.assertEquals(1, controller.applicationOutcomes.size());
		ApexPages.currentPage().getParameters().put('outcomeIndex', '0');
		ApexPages.currentPage().getParameters().put('pageNumberToSet', '1');
		controller.setOutcome();
		System.assertNotEquals(null, controller.outcomeToCreate);
		controller.deleteOutcome();
		System.assertEquals(0, controller.applicationOutcomes.size());

		controller.createPrevApp();
		System.assertNotEquals(null, controller.prevAppToCreate);

		System.assertEquals(0, controller.prevApps.size());
		controller.insertPrevApp();
		System.assertEquals(1, controller.prevApps.size());
		ApexPages.currentPage().getParameters().put('prevAppIndex', '0');
		controller.setPrevApp();
		System.assertNotEquals(null, controller.prevAppToCreate);
		controller.deletePrevApp();
		System.assertEquals(0, controller.prevApps.size());
		ApexPages.currentPage().getParameters().put('additionalSection', 'NOT Section Summary');
		controller.toggleSection();
		System.assertEquals('NOT Section Summary', controller.additionalSectionToShow);
		ApexPages.currentPage().getParameters().put('aqtId', aqt[0].Id);
		controller.formSection = 'Test Section';
		ApexPages.currentPage().getParameters().put('additionalSection', 'Section Summary');
		controller.questionNumber = 1;
		controller.saveAndContinue();
		//System.assertEquals(null, controller.questionNumber);
		ApexPages.currentPage().getParameters().put('formSectionHeader', 'Test Section');
		controller.setFormSection();
		System.assertEquals(1, controller.getqws().size());
		System.assertEquals(1, controller.getSWAnswers().keySet().size());
		ApexPages.currentPage().getParameters().put('formSectionHeader', 'ALL_QUESTIONS');
		controller.setFormSection();
		System.assertEquals(1, controller.getSWAnswers().keySet().size());
		controller.questionNumber = 0;
		System.assertEquals(Page.SIB_ApplicationList.getURL(), controller.returnHomePage().getURL());
		controller.toggleDisplayQuestionHelpText();
		System.assertEquals(true, controller.displayQuestionHelpText);
		controller.previous();
		System.assertEquals('', controller.formSection);
		controller.additionalSectionToShow = 'Section Summary';
		controller.previous();
		System.assertEquals('', controller.additionalSectionToShow);
		System.assertEquals(0, controller.questionNumber);
		controller.pageNumber = 2;
		controller.previous();
		System.assertEquals(1, controller.pageNumber);
		controller.previous();
		System.assertEquals(null, controller.commissionerToCreate);
		controller.pageNumber = null;
		controller.formSection = controller.commissionerHeading;
		controller.commissionerToCreate = new Contact();
		controller.previous();
		System.assertEquals(null, controller.commissionerToCreate);
		controller.additionalSectionToShow = 'Commissioner';
		controller.previous();
		System.assertEquals('', controller.additionalSectionToShow);
		controller.previous();
		//System.assertEquals('', controller.formSection);
		controller.questionNumber = null;
		controller.formSection = 'test';
		controller.previous();
		System.assertEquals('', controller.formSection);
		controller.questionNumber = 1;
		controller.previous();
		System.assertEquals(null, controller.questionNumber);

		ApexPages.currentPage().getParameters().put('answerType', 'Radio_Answer__c');
		ApexPages.currentPage().getParameters().put('answerToSet', 'Test');
		ApexPages.currentPage().getParameters().put('aqtId', aqt[0].Id);
		ApexPages.currentPage().getParameters().put('formSectionHeader', 'Test Section');
		controller.setFormSection();
		controller.setAnswer();
		System.assertEquals(' Test', controller.getAnswerFromAQId(aqt[0].Application_Question__c));
		controller.pageNumber = 1;
		controller.nextPage();
		System.assertEquals(1, controller.pageNumber);
		controller.questionNumber = 1;
		controller.saveAndContinueLater();
		System.assertEquals(null, controller.questionNumber);
		controller.formSection = 'Test Section';
		controller.questionNumber = 1;
		controller.saveAndContinue();
		controller.questionNumber = 2;
		controller.saveAndContinue();
		System.assertEquals(false, controller.hasNext);
		controller.disable = true;
		System.assertEquals(0, controller.saveCurrentSection().size());
		System.assertEquals('Your application has already been submitted, you cannot edit it now.', ApexPages.getMessages()[4].getDetail());
		System.assertEquals(5, ApexPages.getMessages().size());
		controller.upsertAnswer();
		controller.questionNumber = 1;
		controller.saveAndContinueLater();
		System.assertEquals(null, controller.questionNumber);
		System.assertEquals(null, controller.commissionerToCreate);
		System.assertEquals(null, controller.outcomeToCreate);
		controller.formSection = 'Test Section';
		controller.markSectionAsComplete();
		System.assertEquals(controller.sectionWrappers.get('Test Section').status,  'COMPLETED');
		controller.disable = false;
		controller.formSection = 'Test Section';
		System.assertEquals(0, controller.saveCurrentSection().size());
		controller.formSection = 'Test Section';
		ApexPages.currentPage().getParameters().put('questionId', aqt[0].Id);
		controller.upsertAnswer();
		String longAnswer = '';
		for(Integer i = 0; i < 35000; i++){
			longAnswer+='a';
		}

	}
}