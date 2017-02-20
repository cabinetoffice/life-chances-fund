@isTest
public class DataFactory {
	public static Theme__c createTheme(String themeName){
		Theme__c themeToCreate = new Theme__c(
			Name = themeName
		);
		return themeToCreate;
	}

	public static Theme__c insertTheme(String themeName){
		Theme__c themeToInsert = createTheme(themeName);
		insert themeToInsert;
		return themeToInsert;
	}

	public static Application_Window__c createAW(Id themeId){
		Application_Window__c awToCreate = new Application_Window__c(
			Name = 'Test AW',
			Theme__c = themeId,
			Start_Date__c = Date.today().addDays(-10),
			End_Date__c = Date.today().addDays(10),
			Is_Live__c = true
		);
		return awToCreate;
	}

	public static Application_Window__c insertAW(Id themeId){
		Application_Window__c awToInsert = createAW(themeId);
		insert awToInsert;
		return awToInsert;
	}

	public static Application_Window_Template__c createAWT(Id awId){
		Application_Window_Template__c awtToCreate = new Application_Window_Template__c(
			Application_Window__c = awId
		);
		return awtToCreate;
	}

	public static Application_Window_Template__c insertAWT(Id awId){
		Application_Window_Template__c awtToInsert = createAWT(awId);
		insert awtToInsert;
		return awtToInsert;
	}

	public static Application_Form_Section__c createAFS(String name, String formToUseIn){
		Application_Form_Section__c afsToCreate = new Application_Form_Section__c(
			Name = name,
			Form_To_Use_In__c = formToUseIn
		);
		return afsToCreate;
	}

	public static Application_Form_Section__c insertAFS(String name, String formToUseIn){
		Application_Form_Section__c afsToInsert = createAFS(name, formToUseIn);
		insert afsToInsert;
		return afsToInsert;
	}

	public static Application_Question__c createAQ(String contactRecordField, String fieldToSetOnAnswer){
		Application_Question__c aq = new Application_Question__c(
			Name = 'First Name',
			Field_From_Contact_Record__c = contactRecordField,
			Field_To_Set_On_Answer__c = fieldToSetOnAnswer,
			Question__c = 'First Name',
			Question_Type__c = 'Short Text',
			Picklist_Options__c = 'Test;Test2;Test3;',
			Checkboxes_Options__c = 'Test;Test2;Test3;',
			Required__c = true
		);
		return aq;
	}

	public static Application_Question__c insertAQ(String contactRecordField, String fieldToSetOnAnswer){
		Application_Question__c aq = createAQ(contactRecordField, fieldToSetOnAnswer);
		insert aq;
		return aq;
	}

	public static Application_Question_Template__c createAQT(Id awId, Id aqId, Id afsId){
		Application_Question_Template__c aqtToCreate = new Application_Question_Template__c(
			Application_Question__c = aqId,
			Application_Window_Template__c = awId,
			Application_Form_Section__c = afsId
		);
		return aqtToCreate;
	}

	public static Application_Question_Template__c insertAQT(Id awId, Id aqId, Id afsId){
		Application_Question_Template__c aqtToInsert = createAQT(awId, aqId, afsId);
		insert aqtToInsert;
		return aqtToInsert;
	}

	public static Contact createContact(String contactEmail){
		Contact contactToCreate = new Contact(
			LastName = 'Test',
			Email = contactEmail
		);
		return contactToCreate;
	}

	public static Contact insertContact(String contactEmail){
		Contact contactToInsert = createContact(contactEmail);
		insert contactToInsert;
		return contactToInsert;
	}

	public static Application__c createApplication(Id awtId, Id contactId, String status){
		Application__c appToCreate = new Application__c(
			Application_Window_Template__c = awtId,
			Contact__c = contactId,
			Status__c = status
		);
		return appToCreate;
	}

	public static Application__c insertApplication(Id awtId, Id contactId, String status){
		Application__c appToInsert = createApplication(awtId, contactId, status);
		insert appToInsert;
		return appToInsert;
	}
}