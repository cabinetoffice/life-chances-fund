public with sharing class SIB_ApplicationListController {
	public PageReference checkLoggedInStatus(){
        return SIB_Utilities.checkLoggedInStatus();
    }

    public List<Application__c> getApplications(){
    	return [
    		SELECT Id, Status__c, Theme__c, Application_Stage__c, EOI_External_Status__c, Dev_Form_External_Status__c, Name
    		FROM Application__c
            ORDER BY Theme__c
    	];
    }
}