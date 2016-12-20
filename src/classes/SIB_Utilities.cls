public with sharing class SIB_Utilities {
	public static Map<String, Map<String, Id>> recordTypeIdCache = new Map<String, Map<String, Id>>();

	public static Boolean isValidEmail(String email) {
		String emailRegex = '^[a-zA-Z0-9\\.\\!\\#\\$\\%\\&\\*\\/\\=\\?\\^\\_\\+\\-\\`\\{\\|\\}\\~\'._%+-]+@[a-zA-Z0-9\\-.-]+\\.[a-zA-Z]+';
		Pattern myPattern = Pattern.compile(emailRegex);
		Matcher myMatcher = myPattern.matcher(email);
		return myMatcher.matches();
	}

	public static String generateDefaultFields(Id applicationWindowTemplateId){
		String fieldsToReturn = '';
		for(Application_Question_Template__c singleQuestionTemplate : [
			SELECT Application_Question__r.Field_From_Contact_Record__c, Application_Question__r.Field_To_Set_On_Answer__c
			FROM Application_Question_Template__c
			WHERE Application_Window_Template__r.Id = :applicationWindowTemplateId
			ORDER BY CreatedDate ASC
		]){
			if(String.isNotBlank(singleQuestionTemplate.Application_Question__r.Field_From_Contact_Record__c)){
				fieldsToReturn = fieldsToReturn + singleQuestionTemplate.Application_Question__r.Field_From_Contact_Record__c + ',';
			}
		}
		fieldsToReturn = fieldsToReturn + 'Id';
		return fieldsToReturn;
	}

	public static Id getRecordTypeId(String objName, String rtName) {
		if(!recordTypeIdCache.containsKey(objName)){
			Map<String, Id> valuesToPut = new Map<String, Id>();
			Map<String,Schema.RecordTypeInfo> recordTypeInfo = Schema.getGlobalDescribe().get(objName).getDescribe().getRecordTypeInfosByName();
			for(String recordTypeInfoName : recordTypeInfo.keySet()){
				valuesToPut.put(recordTypeInfoName, recordTypeInfo.get(recordTypeInfoName).getRecordTypeId());
			}
			recordTypeIdCache.put(objName, valuesToPut);
		}
		return recordTypeIdCache.get(objName).get(rtName);
	}

	public static PageReference checkLoggedInStatus(){
		if(UserInfo.getUserId() == null || UserInfo.getUserName() == 'social_impact_bonds@dev-sibs.cs80.force.com'){
            returnHomePage();
        }
        return null;
	}

	public static PageReference returnHomePage(){
		return new PageReference(Site.getBaseUrl());
	}

	public SIB_Utilities(SIB_ChangePasswordController controller){}
}