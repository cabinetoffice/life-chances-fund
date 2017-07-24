public with sharing class SIB_ApplicationListController {
    //As with all the pages where we require a user to be logged in, we check here if the user is logged in, else return the homepage
	public PageReference checkLoggedInStatus(){
        return SIB_Utilities.checkLoggedInStatus();
    }
    /*
        This method returns all applications. Because of how security is set up and the "with sharing" setting, 
        we dont need to worry about hiding other applications from other users.
    */
    public List<Application__c> getApplications(){
    	return [
    		SELECT Id, Status__c, Theme__c, Application_Stage__c, Name, 
            EOI_External_Status__c, Dev_Form_External_Status__c, Full_Application_External_Status__c, Identity_Check_External_Status__c
    		FROM Application__c
            ORDER BY Theme__c
    	];
    }
}