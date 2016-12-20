public with sharing class SIB_NewApplicationController {
	public Id selectedTheme{get;set;}
	public List<SelectOption> themes {get;set;}
	
	public SIB_NewApplicationController() {
		themes = new List<SelectOption>{};
		for(Theme__c theme : [
			SELECT Name, Id
			FROM Theme__c
		]){
			themes.add(new SelectOption(theme.Id, theme.Name));
		}
	}

	public PageReference startApplication(){
		Application_Window__c applicationWindow = null;
		List<Application_Window__c> appWindows = [
			SELECT Id, Is_Live__c, Start_Date__c
			FROM Application_Window__c
			WHERE Theme__c = :selectedTheme
			ORDER BY End_Date__c ASC
		];
		for(Application_Window__c applicationWindowToCheck : appWindows){
			if(applicationWindowToCheck.Is_Live__c){
				applicationWindow = applicationWindowToCheck;
				break;
			}
			if(applicationWindowToCheck.Start_Date__c > Date.today()){
				applicationWindow = applicationWindowToCheck;
				break;
			}
			applicationWindow = applicationWindowToCheck;
		}

		String queryString = 'SELECT Id';
			queryString += ' FROM Application_Window_Template__c';
			queryString += ' WHERE Application_Window__c = \'' + applicationWindow.Id + '\'';
		List<Application_Window_Template__c> templates = Database.query(queryString);
        String contactQuery = 'SELECT Id FROM Contact WHERE Email = \'' + UserInfo.getUserEmail() + '\'';
        List<Contact> contactRecords = Database.query(contactQuery);
        Contact contactToUse = contactRecords[0];
		Application__c applicationToCreate = new Application__c(
            Application_Window_Template__c = templates[0].Id,
            Status__c = 'Draft',
            Contact__c = contactToUse.Id
        );
        insert applicationToCreate;
		return new PageReference('/apex/SIB_ApplicationForm?id=' + applicationToCreate.Id + '&formType=Expression%20Of%20Interest');
	}

    public PageReference back(){
    	return Page.SIB_ApplicationList;
    }

    public PageReference checkLoggedInStatus(){
        return SIB_Utilities.checkLoggedInStatus();
    }
}