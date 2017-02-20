public with sharing class SIB_NewApplicationController {
    public String selectedTheme{get;set;}
    public List<String> themes {get;set;}
    public Map<String, Id> themeNameToIdMap{get;set;}
    
    public SIB_NewApplicationController() {
        themeNameToIdMap = new Map<String, Id>();
        themes = new List<String>();
        for(Theme__c theme : [
            SELECT Name, Id
            FROM Theme__c
        ]){
            themeNameToIdMap.put(theme.Name, theme.Id);
            themes.add(theme.Name);
        }
    }

    public void setValue(){
        selectedTheme = EncodingUtil.urlDecode(ApexPages.currentPage().getParameters().get('valueToSet'), 'UTF-8');
    }

    public PageReference startApplication(){
        Application_Window__c applicationWindow = null;
        List<Application_Window__c> appWindows = [
            SELECT Id, Is_Live__c, Start_Date__c, (
                SELECT Id
                FROM Application_Window_Templates__r
            )
            FROM Application_Window__c
            WHERE Theme__c = :selectedTheme
            ORDER BY End_Date__c ASC
        ];
        for(Application_Window__c applicationWindowToCheck : appWindows){
            applicationWindow = applicationWindowToCheck;
            if(applicationWindowToCheck.Is_Live__c || applicationWindowToCheck.Start_Date__c > Date.today()){
                break;
            }
        }
        List<Contact> contactRecords = Database.query('SELECT Id FROM Contact WHERE Email = \'' + UserInfo.getUserEmail() + '\'');
        Application__c applicationToCreate = new Application__c(
            Application_Window_Template__c = applicationWindow.Application_Window_Templates__r[0].Id,
            Status__c = 'Draft',
            Contact__c = contactRecords.isEmpty() ? null : contactRecords[0].Id
        );
        insert applicationToCreate;
        return new PageReference('/apex/SIB_ApplicationForm?id=' + applicationToCreate.Id + '&formType=Expression%20Of%20Interest');
    }

    public PageReference checkLoggedInStatus(){
        return SIB_Utilities.checkLoggedInStatus();
    }
}