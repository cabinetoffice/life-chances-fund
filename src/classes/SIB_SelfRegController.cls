/**
* An apex page controller that supports self registration of users in communities that allow self registration
*/
public class SIB_SelfRegController {
	public String firstName {get; set;}
	public String lastName {get; set;}
	public String email {get; set;}
	public String organisationName{get; set;}
	public String orgTypeOther{get;set;}
	public String typeSelected{get;set;}
	public List<String> themesSelected{get;set;}
	public Integer pageNumber{get;set;}
	public List<CheckboxWrapper> regionsCBW{get;set;}
	public List<CheckboxWrapper> themesCBW{get;set;}

	public SIB_SelfRegController() {
		pageNumber = 1;
		regionsCBW = generateRegionCBW();
		themesCBW = generateThemeCBW();
	}

	public PageReference registerUser() {
		if(!isValidRegistrationForm()){
			return null;
		}

		String profileId = [SELECT Id FROM Profile WHERE Name = 'SIB Applicant'].Id;
		String ownerId = [SELECT Id FROM User WHERE Name = 'Westbrook Admin'].Id;
		String accountId = '';

		String regionSelected = '';
		for(CheckboxWrapper region : regionsCBW){
			regionSelected += region.isSelected ? (region.checkBoxName + ';') : '';
		}

		String userName = email;
		Account accountToCreate = new Account(
			Name = organisationName,
			Type = typeSelected,
			Organisation_Region__c = regionSelected,
			Organisation_Type_Details__c = orgTypeOther,
			OwnerId = ownerId
		);
		User u = new User(
			Username = userName,
			Email = email,
			FirstName = firstName,
			LastName = lastName,
			CommunityNickname = email,
			ProfileId = profileId
		);
		String userId;
		Savepoint rollBackPoint = Database.setSavepoint();
		try{
			insert accountToCreate;
			accountId = accountToCreate.Id;
		} catch(DmlException dmlException){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, dmlException.getMessage()));
			Database.rollback(rollBackPoint);
			return null;
		}
		List<Theme_Interest__c> themeInterestsToInsert = new List<Theme_Interest__c>();

		for(CheckBoxWrapper theme : themesCBW){
			if(theme.isSelected){
				themeInterestsToInsert.add(
					new Theme_Interest__c(
						Theme__c = theme.checkBoxId,
						Organisation__c = accountId
					)
				);
			}
		}
		if(!themeInterestsToInsert.isEmpty()){
			try {
				insert themeInterestsToInsert;
			} catch(DmlException insertException){
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error inserting theme interests'));
				Database.rollback(rollBackPoint);
				return null;
			}
		}
		try {
			userId = Site.createExternalUser(u, accountId);
		} catch(Site.ExternalUserCreateException ex) {
			List<String> errors = ex.getDisplayMessages();
			for (String error : errors)  {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
			}
			System.debug(ex.getMessage());
			Database.rollback(rollBackPoint);
		}

		if (userId != null) {
			PageReference page = System.Page.SIB_SelfRegConfirm;
			page.setRedirect(true);
			return page;
		}
		return null;
	}

	public List<SelectOption> regions{
		get{
			List<SelectOption> options = new List<SelectOption>();
			for(Schema.PicklistEntry picklistOption : Account.Organisation_Region__c.getDescribe().getPicklistValues()){
				options.add(new SelectOption(picklistOption.getLabel(), picklistOption.getValue()));
			}
			return options;
		}
	}

	public List<SelectOption> types{
		get{
			List<SelectOption> options = new List<SelectOption>();
			for(Schema.PicklistEntry picklistOption : Account.Type.getDescribe().getPicklistValues()){
				options.add(new SelectOption(picklistOption.getLabel(), picklistOption.getValue()));
			}
			return options;
		}
	}

	private static List<CheckboxWrapper> generateRegionCBW(){
		List<CheckBoxWrapper> cbwList = new List<CheckBoxWrapper>();
		for(Schema.PicklistEntry picklistOption : Account.Organisation_Region__c.getDescribe().getPicklistValues()){
			cbwList.add(new CheckBoxWrapper(picklistOption.getLabel(), null));
		}
		return cbwList;
	}

	private static List<CheckboxWrapper> generateThemeCBW(){
		List<CheckBoxWrapper> cbwList = new List<CheckBoxWrapper>();
		for(Theme__c theme : [
			SELECT Name, Id
			FROM Theme__c
		]){
			cbwList.add(new CheckBoxWrapper(theme.Name, theme.Id));
		}
		return cbwList;
	}

	public List<SelectOption> themes{
		get{
			List<SelectOption> options = new List<SelectOption>();
			for(Theme__c theme : [
				SELECT Name, Id
				FROM Theme__c
			]){
				options.add(new SelectOption(theme.Id, theme.Name));
			}
			return options;
		}
	}

	private Boolean isValidRegistrationForm(){
		Boolean isValidForm = true;
		if (String.isBlank(organisationName)) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please add Organisation Name'));
			isValidForm = false;
		}
		if (String.isBlank(email)) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please add email'));
			isValidForm = false;
		} else if (!SIB_Utilities.isValidEmail(email)) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter a valid email address'));
			isValidForm = false;
		} else if(usersWithNickname().size() != 0){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'This email has already been used to register on the community.'));
			isValidForm = false;
		}
		if(typeSelected == 'Other' && String.isBlank(orgTypeOther)){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please fill out \'If you chose other, please explain\' if you selected \'Other\' for organisation type'));
			isValidForm = false;
		}
		return isValidForm;
	}

	private List<User> usersWithNickname(){
		return [
			SELECT Id
			FROM User
			WHERE CommunityNickname = :email
		];
	}

	public void nextPage(){
		updatePageNumber(1);
	}

	public void previousPage(){
		updatePageNumber(-1);
	}

	private void updatePageNumber(Integer toUpdate){
		pageNumber = pageNumber + toUpdate;
	}

	public class CheckBoxWrapper{
        public String checkBoxName{get;set;}
        public Id checkBoxId{get;set;}
        public Boolean isSelected{get;set;}

        public CheckBoxWrapper(String checkBoxName, Id checkBoxId){
            this.checkBoxName = checkBoxName;
            this.checkBoxId = checkBoxId;
            this.isSelected = false;
        }
    }
}