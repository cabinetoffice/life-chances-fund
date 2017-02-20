public with sharing class SIB_ApplicationFormExtension {
	public Application__c currApp{get;set;}
	public Map<String, SectionWrapper> sectionWrappers{get;set;}
	public Integer questionNumber{get;set;}
	public Boolean hasNext{get;set;}
	public Boolean hasPrevious{get;set;}
	public String formSection{get;set;}
	public Contact commissionerToCreate{get;set;}
	public List<Contact> applicationCommissioners{get;set;}
	public Account organisationToCreate{get;set;}
	public String commissionerHeading {get;set;}
	public Boolean displayQuestionHelpText{get;set;}
	public String additionalSectionToShow{get;set;}
	public Outcome__c outcomeToCreate{get;set;}
	public List<Outcome__c> applicationOutcomes{get;set;}
	public Previous_Application__c prevAppToCreate{get;set;}
	public List<Previous_Application__c> prevApps{get;set;}
	public Map<Id, String> branchQuestionMap{get;set;}
	public Boolean disable{get;set;}
	public String statusField{get;set;}
	public Integer pageNumber{get;set;}
	public List<CheckboxWrapper> regionWrapper{get;set;}
    public String formDisplayName{get;set;}

	/*////////////////////////////////////////////////////////////////////////////////////

									Page Load Methods

	///////////////////////////////////////////////////////////////////////////////////*/

	public SIB_ApplicationFormExtension() {}

	public PageReference initialiseData(){
		commissionerHeading = '6. Commissioners';
		additionalSectionToShow = '';
		SIB_Utilities.checkLoggedInStatus();
		organisationToCreate = new Account();
		getApplicationCommissioners();
		hasPrevious = false;
		commissionerToCreate = null;
		outcomeToCreate = null;
		prevAppToCreate = null;
		displayQuestionHelpText = false;
		clearFormSection();
		questionNumber = null;
		hasNext = false;
		getCurrentApplication();
        
		String formType = getParam('formType');
        formDisplayName = (formType == 'Expression of Interest'?'Expression of interest application':'Development application');
		statusField = formType == 'Expression of Interest' ? 'Status__c' : 'Development_Form_Status__c';
		disable = currApp.get(statusField) != 'Draft' && currApp.get(statusField) != '' && currApp.get(statusField) != null; 
		setBranchingMap();
		applicationOutcomes = currApp.Outcomes__r;
		prevApps = currApp.Previous_Applications__r;
		List<Contact> contactRecords = Database.query('SELECT ' + SIB_Utilities.generateDefaultFields(currApp.Application_Window_Template__c) + ' FROM Contact WHERE Id = \'' + currApp.Contact__c + '\'');
		Contact contactToUse = contactRecords[0];
		Map<Id, Application_Answer__c> previouslyAnsweredQuestions = new Map<Id,Application_Answer__c>();
		previouslyAnsweredQuestions = getPreviousAnswers(currApp.Id);
		generateQuestionsAndSections(contactToUse);
		return null;
	}

	/*////////////////////////////////////////////////////////////////////////////////////

									Other Methods

	///////////////////////////////////////////////////////////////////////////////////*/

	public void setQuestionNumber(){
		if(ApexPages.getMessages().size() != 0){
			questionNumber = questionNumber;
			return;
		}
		setAdditionalSectionToShow('');
		questionNumber = Integer.valueOf(getParam('questionNumber'));
	}

	public ApplicationQuestionHolder getQW(){
		List<ApplicationQuestionHolder> qw = getqws();
		if(qw.size() == 0){
			hasNext = false;
			hasPrevious = false;
			return null;
		}
		hasNext = qw.size() > questionNumber + 1;
		hasPrevious = questionNumber > 0;
		return qw[questionNumber];
	}

	public List<ApplicationQuestionHolder> getqws(){
		return String.isBlank(formSection) ? new List<ApplicationQuestionHolder>() : 
		(sectionWrappers.containsKey(formSection) ? sectionWrappers.get(formSection).aqhMap.values() : new List<ApplicationQuestionHolder>());
	}

	public Integer getqwSize(){
		return getqws().size();
	}

	public void viewAllAnswers(){
		formSection = 'ALL_QUESTIONS';
		additionalSectionToShow = 'Section Summary';
		clearQuestionNumber();
	}

	public void next(){
		updateQuestionNumber(1);
	}

	public void toggleDisplayQuestionHelpText(){
		displayQuestionHelpText = !displayQuestionHelpText;
	}

	public PageReference previous(){
		displayQuestionHelpText = false;
		if(formSection == 'ALL_QUESTIONS'){
			setAdditionalSectionToShow('');
			clearFormSection();
			return null;
		}
		if(additionalSectionToShow == 'Section Summary'){
		// Is on summary page, should reset question number to last question on list.
			setAdditionalSectionToShow('');
			questionNumber = getqwSize();
			updateQuestionNumber(-1);
			return null;
		// If on the section help text page, should clear help text page.
		}
		if(pageNumber != null){
			if(pageNumber > 1){
				updatePageNumber(-1);
				return null;
			} else{
				String additionalSectionToShowStr =  commissionerToCreate != null ? 'Commissioner' : (outcomeToCreate != null ? 'Outcomes' : 'Previous Applications');
				if(additionalSectionToShow != additionalSectionToShowStr){
					setAdditionalSectionToShow(additionalSectionToShowStr);
				}
				commissionerToCreate = null;
				outcomeToCreate = null;
				prevAppToCreate = null;
				pageNumber = null;
				return null;
			}
		}
		if(formSection == commissionerHeading){
			if(commissionerToCreate != null){
				commissionerToCreate = null;
				return null;
			} else if(additionalSectionToShow == 'Commissioner'){
				setAdditionalSectionToShow('Commissioner');
				setAdditionalSectionToShow('');
				return null;
			} else if(questionNumber != null){
				if(hasPrevious){
					updateQuestionNumber(-1);
				} else{
					clearQuestionNumber();
					setAdditionalSectionToShow('Commissioner');
				}
			} else{
				clearFormSection();
				setAdditionalSectionToShow('');
			}
		} else if(formSection == '4. Outcomes'){
			if(outcomeToCreate != null){
				outcomeToCreate = null;
				return null;
			} else if(additionalSectionToShow == 'Outcomes'){
				setAdditionalSectionToShow('');
				return null;
			} else if(questionNumber != null){
				if(hasPrevious){
					updateQuestionNumber(-1);
				} else{
					clearQuestionNumber();
					setAdditionalSectionToShow('Outcomes');
				}
			} else{
				clearFormSection();
				setAdditionalSectionToShow('');
				return null;
			}
		} else if(formSection == '7. Previous Applications'){
			if(prevAppToCreate != null){
				prevAppToCreate = null;
				return null;
			} else if(additionalSectionToShow == 'Previous Applications'){
				setAdditionalSectionToShow('');
				return null;
			} else{
				clearFormSection();
				setAdditionalSectionToShow('');
				return null;
			}
		} else if(questionNumber == null){
			clearFormSection();
			setAdditionalSectionToShow('');
		//If on first question, should clear question number, so the help text page toggles again
		} else if(!hasPrevious){
			clearQuestionNumber();
		// Else it will just need to go to previous q.
		} else{
			updateQuestionNumber(-1);
		}
		return null;
	}

	/*////////////////////////////////////////////////////////////////////////////////////

									Wrapper & Assocciated Methods

	///////////////////////////////////////////////////////////////////////////////////*/


	public class SectionWrapper{
		public String helpText{get;set;}
		public String status{get;set;}
		public Map<Id, ApplicationQuestionHolder> aqhMap{get;set;}
		public SectionWrapper(String helpText, String status){
			this.helpText = helpText;
			this.status = status;
			this.aqhMap = new Map<Id, ApplicationQuestionHolder>();
		}

		public void generateStatus(Application_Answer__c appAnswer){
			status = appAnswer.Marked_as_Complete__c == true ? 'COMPLETED' : (String.isNotBlank(appAnswer.Id) ? 'IN PROGRESS' : status);
		}
	}

	public class ApplicationQuestionHolder{
		public Application_Question_Template__c aqt{get;private set;}
		public Application_Answer__c applicationAnswer{get;set;}
		public Application__c application{get; private set;}
		public String answerSubmitted{get;private set;}
		public Id applicationQuestionId{get;private set;}
		public List<SelectOption> selectOptions{get; private set;}
		public List<String> options{get;private set;}
		public List<CheckboxWrapper> cbws{get;set;}
		public ApplicationQuestionHolder(Application_Question_Template__c aqt, Application_Answer__c applicationAnswer, Application__c application){
			this.aqt = aqt;
			this.application = application;
			this.applicationAnswer = applicationAnswer;
			this.answerSubmitted = applicationAnswer.Response__c;
			this.applicationQuestionId = aqt.Application_Question__c;
			this.selectOptions = doSelectOptions();
			this.options = setUpOptions(this.selectOptions);
			this.cbws = populateCheckboxWrapper();
		}

		public List<SelectOption> doSelectOptions(){
			Map<String, SelectOption> selectOptionsMap = new Map<String, SelectOption>();
			// SIB-135
			if(String.isNotBlank(aqt.Application_Question__r.Picklist_Options__c)){
				for(String picklistOption : aqt.Application_Question__r.Picklist_Options__c.split(';')){
					if(!selectOptionsMap.containsKey(picklistOption)){
						selectOptionsMap.put(picklistOption, new SelectOption(picklistOption, picklistOption));
					}
				}
			}  
			
			if(applicationAnswer != null && String.isNotBlank(applicationAnswer.Picklist_Answer__c)){
				selectOptionsMap.put(applicationAnswer.Picklist_Answer__c, new SelectOption(applicationAnswer.Picklist_Answer__c, applicationAnswer.Picklist_Answer__c));
			}    
			return selectOptionsMap.values();
		}

		public List<String> setUpOptions(List<SelectOption> selectOptions){
			List<String> returnValue = new List<String>();
			for(SelectOption selectOption : selectOptions){
				if(selectOption.getLabel() != ''){
					returnValue.add(selectOption.getLabel());
				}
			}
			return returnValue;
		}

		public List<CheckBoxWrapper> populateCheckboxWrapper(){
			List<CheckBoxWrapper> checkboxWrappers = new List<CheckBoxWrapper>();
			if(String.isNotBlank(aqt.Application_Question__r.Checkboxes_Options__c)){
				for(String checkboxOption : aqt.Application_Question__r.Checkboxes_Options__c.split(';')){
					Boolean isPreviouslySelected = 
						applicationAnswer != null && 
						String.isNotBlank(applicationAnswer.Checkboxes_Answer__c) &&
						applicationAnswer.Checkboxes_Answer__c.contains(checkboxOption);
					checkboxWrappers.add(
						new CheckboxWrapper(checkboxOption,isPreviouslySelected)
					);
				}
			}
			return checkboxWrappers;
		}

		public void setAnswerSubmitted(){
			Set<String> answerFields = new Set<String>{
				'Radio_Answer__c', 
				'Checkbox_Answer__c',
				'Text_Answer__c',
				'Picklist_Answer__c',
				'Checkboxes_Answer__c',
				'Short_Text_Answer__c',
				'Multi_Picklist_Answers__c',
				'Date_Answer__c',
				'Email_Answer__c',
				'Percent_Answer__c',
				'Date_Day_Answer__c',
				'Date_Month_Answer__c',
				'Date_Year_Answer__c',
				'Currency_Answer__c'
			};
			answerSubmitted = '';
			for(String answerField : answerFields){
				if(String.valueOf(applicationAnswer.get(answerField)) == null || String.valueOf(applicationAnswer.get(answerField)) == '' || String.valueOf(applicationAnswer.get(answerField)) == 'false' || String.valueOf(applicationAnswer.get(answerField)) == 'null'){
					continue;
				}
				String answerToAdd = String.valueOf(applicationAnswer.get(answerField));
				answerToAdd = answerField == 'Currency_Answer__c' ? ('£' + answerToAdd) : (answerField == 'Date_Day_Answer__c' || answerField == 'Date_Month_Answer__c' ? (answerToAdd + '/') : answerToAdd);
				answerSubmitted += answerField == 'Text_Answer__c' ? '' : ' ' + answerToAdd;
			}
		}
	}

	public class CheckBoxWrapper{
		public String checkBoxName{get;set;}
		public Boolean isSelected{get;set;}

		public CheckBoxWrapper(String checkBoxName, Boolean isSelected){
			this.checkBoxName = checkBoxName;
			this.isSelected = isSelected;
		}
	}

	/*////////////////////////////////////////////////////////////////////////////////////

									Commissioner Methods

	///////////////////////////////////////////////////////////////////////////////////*/

	public void insertCommissioner(){
		if(String.isBlank(organisationToCreate.Name)){
			addMesssageToPage(ApexPages.Severity.Warning, 'Please enter organisation name');
		}
		if(String.isBlank(commissionerToCreate.LastName)){
			addMesssageToPage(ApexPages.Severity.Warning, 'Please enter commissioner last name');
		}
		if(!SIB_Utilities.isValidEmail(commissionerToCreate.Email)){
			addMesssageToPage(ApexPages.Severity.Warning, 'Please enter valid email address');
		}
		String regionSelected = '';
		for(CheckboxWrapper region : regionWrapper){
			regionSelected += region.isSelected ? (region.checkBoxName + ',') : '';
		}
		organisationToCreate.Organisation_Region__c = regionSelected.replace(',',';');
		try{
			upsert organisationToCreate;
		} catch(Exception e){
			return;
		}
		commissionerToCreate.AccountId = organisationToCreate.Id;
		upsert commissionerToCreate;
		Application_Commissioner__c applicationCommissionerToInsert = new Application_Commissioner__c(
			Commissioner__c = commissionerToCreate.Id,
			Application__c = currApp.Id,
			Name = commissionerToCreate.FirstName + ' ' + commissionerToCreate.LastName
		);
		upsert applicationCommissionerToInsert;
		commissionerToCreate = null;
		organisationToCreate = new Account();
		pageNumber = null;
		getApplicationCommissioners();
	}

	public void createCommissioner(){
		commissionerToCreate = new Contact(
			RecordTypeId = SIB_Utilities.getRecordTypeId('Contact', 'Commissioner')
		);
		organisationToCreate = new Account();
		pageNumber = 1;
		regionWrapper = generateRegionCBW();
	}

	public void setCommissioner(){
		commissionerToCreate = applicationCommissioners[Integer.valueOf(getParam('commissionerIndex'))];
		organisationToCreate = new Account(
			Id = commissionerToCreate.AccountId,
			Name = commissionerToCreate.Account.Name,
			Organisation_Region__c = commissionerToCreate.Account.Organisation_Region__c
		);
		pageNumber = Integer.valueOf(getParam('pageNumberToSet'));
	}

	public void deleteCommissioner(){
		delete applicationCommissioners[Integer.valueOf(getParam('commissionerIndex'))];
		getApplicationCommissioners();
	}

	/*////////////////////////////////////////////////////////////////////////////////////

									Outcome Methods

	///////////////////////////////////////////////////////////////////////////////////*/

	public void insertOutcome(){
		if(String.isBlank(outcomeToCreate.Id)){
			applicationOutcomes.add(outcomeToCreate);
		}
		upsert outcomeToCreate;
		outcomeToCreate = null;
	}

	public void createOutcome(){
		outcomeToCreate = new Outcome__c(
			Application__c = currApp.Id
		);
		pageNumber = 1;
	}

	public void setOutcome(){
		if(additionalSectionToShow != 'Outcomes'){
			setAdditionalSectionToShow('Outcomes');
		}
		outcomeToCreate = applicationOutcomes[Integer.valueOf(getParam('outcomeIndex'))];
		pageNumber = Integer.valueOf(getParam('pageNumberToSet'));
	}

	 public void deleteOutcome(){
		Integer outcomeIndex = Integer.valueOf(getParam('outcomeIndex'));
		delete applicationOutcomes[outcomeIndex];
		applicationOutcomes.remove(outcomeIndex);
	}

	/*////////////////////////////////////////////////////////////////////////////////////

									Prev Application Methods

	///////////////////////////////////////////////////////////////////////////////////*/

	public void insertPrevApp(){
		if(String.isBlank(prevAppToCreate.Id)){
			prevApps.add(prevAppToCreate);
		}
		upsert prevAppToCreate;
		prevAppToCreate = null;
	}

	public void createPrevApp(){
		prevAppToCreate = new Previous_Application__c(
			Application__c = currApp.Id
		);
	}

	public void setPrevApp(){
		prevAppToCreate = prevApps[Integer.valueOf(getParam('prevAppIndex'))];
	}

	 public void deletePrevApp(){
		Integer prevAppIndex = Integer.valueOf(getParam('prevAppIndex'));
		delete prevApps[prevAppIndex];
		prevApps.remove(prevAppIndex);
	}

	/*////////////////////////////////////////////////////////////////////////////////////

									Utility Methods

	///////////////////////////////////////////////////////////////////////////////////*/

	public String getParam(String paramName){
		String param = ApexPages.currentPage().getParameters().get(paramName);
		return String.isBlank(param) ? '' : EncodingUtil.urlDecode(param, 'UTF-8');
	}

	public void addMesssageToPage(ApexPages.Severity severity, String errorToAdd){
		ApexPages.addMessage(new ApexPages.Message(severity, errorToAdd));
	}

	public void setFormSection(){
		clearQuestionNumber();
		formSection = getParam('formSectionHeader');
		if(formSection == null || formSection == ''){
			setAdditionalSectionToShow('');
			commissionerToCreate = null;
			outcomeToCreate = null;
			prevAppToCreate = null;
		}
	}

	public void clearQuestionNumber(){
		questionNumber = null;
	}

	public void clearFormSection(){
		formSection = '';
	}

	private void updateQuestionNumber(Integer toAdd){
		toAdd = ApexPages.getMessages().size() != 0 ? 0 : toAdd;
		questionNumber = questionNumber + toAdd;
	}

	private void setBranchingMap(){
		branchQuestionMap = new Map<Id, String>();
		for(Application_Branching_Question__c abq : [
			SELECT Answer__c, Application_Question__c
			FROM Application_Branching_Question__c
			WHERE Template__c = : currApp.Application_Window_Template__c
		]){
			branchQuestionMap.put(abq.Application_Question__c, abq.Answer__c);
		}
	}

	private void generateQuestionsAndSections(Contact contactToUse){
		sectionWrappers = new Map<String, SectionWrapper>();
		Map<Id, Application_Answer__c> previouslyAnsweredQuestions = new Map<Id,Application_Answer__c>();
		previouslyAnsweredQuestions = getPreviousAnswers(currApp.Id);
		for(Application_Question_Template__c aqt : returnCurrentApplicationQuestionTemplate()){
			Application_Answer__c applicationAnswer;
			String sectionName = aqt.Application_Form_Section__r.Name;
			SectionWrapper sectionWrapper = generateSectionWrapper(sectionName, aqt.Application_Form_Section__r.Help_Text__c);
			
			if(previouslyAnsweredQuestions.containsKey(aqt.Application_Question__r.Id)){
				applicationAnswer = previouslyAnsweredQuestions.get(aqt.Application_Question__r.Id);
			}
			else{
				applicationAnswer = new Application_Answer__c(
					Application_Question__c = aqt.Application_Question__c,
					Application__c = currApp.Id
				);
			}
			if(contactToUse != null){
				if(String.isNotBlank(aqt.Application_Question__r.Field_From_Contact_Record__c) && 
					(applicationAnswer.get(aqt.Application_Question__r.Field_To_Set_On_Answer__c) == null)){
						String fieldName = aqt.Application_Question__r.Field_From_Contact_Record__c;
						applicationAnswer.put(aqt.Application_Question__r.Field_To_Set_On_Answer__c, contactToUse.get(fieldName));
					}
				}
			ApplicationQuestionHolder aqh = new ApplicationQuestionHolder(aqt, applicationAnswer, currApp);
			aqh.setAnswerSubmitted();
			sectionWrapper.aqhMap.put(aqt.Id, aqh);
			sectionWrapper.generateStatus(applicationAnswer);
			sectionWrappers.put(sectionName, sectionWrapper);
		}
		getQW();
	}   

	/*////////////////////////////////////////////////////////////////////////////////////

									Save Methods

	///////////////////////////////////////////////////////////////////////////////////*/

	public List<ApplicationQuestionHolder> saveCurrentSection(){
		return saveMethod(new Set<String>{formSection});
	}

	public List<ApplicationQuestionHolder> saveMethod(Set<String> formSectionsToSave){
		if(disable){
			addMesssageToPage(ApexPages.Severity.Warning, 'Your application has already been submitted, you cannot edit it now.');
			return new List<ApplicationQuestionHolder>();
		}
		List<ApplicationQuestionHolder> applicationQuestionHolderErrors = new List<ApplicationQuestionHolder>();
		List<Application_Answer__c> applicationAnswersToUpsert = new List<Application_Answer__c>();
		for(String formSectionToSave : formSectionsToSave){
			for(ApplicationQuestionHolder singleApplicationQuestionHolder : sectionWrappers.get(formSectionToSave).aqhMap.values()){
				applicationAnswersToUpsert.add(singleApplicationQuestionHolder.applicationAnswer);
				singleApplicationQuestionHolder.setAnswerSubmitted();
				if(
					singleApplicationQuestionHolder.aqt.Application_Question__r.Required__c == true && 
					(String.isBlank(singleApplicationQuestionHolder.answerSubmitted) && String.isBlank(singleApplicationQuestionHolder.applicationAnswer.Text_Answer__c))
				){
					applicationQuestionHolderErrors.add(singleApplicationQuestionHolder);
				}
			}
		}
		if(!applicationAnswersToUpsert.isEmpty()){
			upsert applicationAnswersToUpsert;
		}
		return applicationQuestionHolderErrors;
	}

	public PageReference saveAndSubmit(){
		List<ApplicationQuestionHolder> errorQuestions = saveMethod(sectionWrappers.keySet());
		if(!errorQuestions.isEmpty()){
			for(ApplicationQuestionHolder errorQuestion : errorQuestions){
				addMesssageToPage(ApexPages.Severity.Warning, Label.SIB_Mandatory_Questions_Not_Filled);
				
			}
		}
		if(ApexPages.getMessages().size() != 0){
			return null;
		}
		if(currApp.Application_Window_Template__r.Application_Window__r.End_Date__c < System.now()){
			addMesssageToPage(ApexPages.Severity.Warning, 'Application has been saved, but application window has now closed.');
			return null;
		}
		if(currApp.Application_Window_Template__r.Application_Window__r.Is_Live__c){
			currApp.put(statusField, 'Submitted');
			update currApp;
			String message = getParam('formType') == 'Expression of interest' ? 'Application' : 'Development Form';
			addMesssageToPage(ApexPages.Severity.Confirm, message + ' Has Been Submitted');
			disable = true;
			return new PageReference(Page.SIB_ApplicationConfirm.getUrl() + '?formType=' + getParam('formType'));
		} else if(!currApp.Application_Window_Template__r.Application_Window__r.Is_Live__c){
			addMesssageToPage(ApexPages.Severity.Warning, 'You cannot submit this application form yet because the theme to which you are applying has not gone live. Please come back after the theme has gone live and try submitting again.');
		} else if(currApp.Application_Window_Template__r.Application_Window__r.End_Date__c > System.now()){
			addMesssageToPage(ApexPages.Severity.Warning, 'Application has been saved, but cannot be submitted yet as the window is inactive');
		}
		return null;
	}

	public void markSectionAsComplete(){
		List<Application_Answer__c> applicationAnswersToUpsert = new List<Application_Answer__c>();
		List<ApplicationQuestionHolder> errorQuestions = saveCurrentSection();
		if(!errorQuestions.isEmpty()){
			for(ApplicationQuestionHolder errorQuestion : errorQuestions){
				addMesssageToPage(ApexPages.Severity.Warning, 'Please fill out answer for : ' + errorQuestion.aqt.Application_Form_Section__r.Name + ' - ' + errorQuestion.aqt.Application_Question__r.Question__c);        
			}
			return;
		}
		for(ApplicationQuestionHolder singleApplicationQuestionHolder : getqws()){
			Application_Answer__c appAnswer = singleApplicationQuestionHolder.applicationAnswer;
			appAnswer.Marked_as_Complete__c = true;
			applicationAnswersToUpsert.add(appAnswer);
		}
		upsert applicationAnswersToUpsert;
		sectionWrappers.get(formSection).status = 'COMPLETED';
		clearFormSection();
		clearQuestionNumber();
		setAdditionalSectionToShow('');
	}

	public void saveAndContinue(){
		if(!disable){
			upsertAnswer();
		}
		if(questionNumber == getqwSize() - 1){
			clearQuestionNumber();
			if(formSection == '7. Previous Applications'){
				if(sectionWrappers.get(formSection).aqhMap.get(getParam('questionId')).applicationAnswer.Radio_Answer__c == 'Yes'){
					setAdditionalSectionToShow('Previous Applications');
					return;
				}
			}
			hasNext = false;
			setAdditionalSectionToShow('Section Summary');
			clearQuestionNumber();
			return;
		}
		commissionerToCreate = null;
		prevAppToCreate = null;
		outcomeToCreate = null;
		setAdditionalSectionToShow('');

		next();
	}

	public void saveAndGoToSummarySection(){
		hasNext = false;
		setAdditionalSectionToShow('Section Summary');
		clearQuestionNumber();
		return;
	}

	public void saveAndContinueLater(){
		if(!disable){
			upsertAnswer();
		}
		clearQuestionNumber();
		commissionerToCreate = null;
		outcomeToCreate = null;
		prevAppToCreate = null;
		clearFormSection();
		setAdditionalSectionToShow('');
		pageNumber = null;
		questionNumber = null;
	}

	public void upsertAnswer(){
		if(disable){
			addMesssageToPage(ApexPages.Severity.Warning, 'Your application has already been submitted, you cannot edit it now.');
			return;
		}
		SectionWrapper sw = sectionWrappers.get(formSection);
		sw.status = 'IN PROGRESS';
		String aqtId = getParam('questionId');
		if(String.isBlank(aqtId)){
			return;
		}
		Map<Id, ApplicationQuestionHolder> questionHolderMap = sectionWrappers.get(formSection).aqhMap;
		ApplicationQuestionHolder aqh = questionHolderMap.get(aqtId);
		Application_Answer__c answerToUpsert = aqh.applicationAnswer;
		String checkBoxesAnswer = '';
		for(CheckBoxWrapper cbw : aqh.cbws){
			if(cbw.isSelected){
				checkBoxesAnswer += checkBoxesAnswer == '' ? cbw.checkBoxName : ',' + cbw.checkBoxName;
			}
		}

		answerToUpsert.Checkboxes_Answer__c = checkBoxesAnswer.replace(',',';');
		if(String.isNotBlank(answerToUpsert.Text_Answer__c) && answerToUpsert.Text_Answer__c.length() > 32768){
			addMesssageToPage(ApexPages.Severity.Warning, 'You have exceeded the maximum character limit (32,768 char) for this question. Please shorten your answer.');
			return;
		}

		if(String.isBlank(aqtId) || 
			!questionHolderMap.keySet().contains(aqtId) || 
			questionHolderMap.get(aqtId).applicationAnswer == null||
			ApexPages.getMessages().size()>0
		){
			return;
		}
		try{
			questionHolderMap.get(aqtId).setAnswerSubmitted();
			// Validating the email address prior to the upsert
			if(String.isNotBlank(questionHolderMap.get(aqtId).applicationAnswer.Email_Answer__c)&&!SIB_Utilities.isValidEmail(questionHolderMap.get(aqtId).applicationAnswer.Email_Answer__c)){
				addMesssageToPage(ApexPages.Severity.Warning, 'Please enter valid email address');
				return;
			}
			upsert questionHolderMap.get(aqtId).applicationAnswer;
		} catch(Exception ex){
			addMesssageToPage(ApexPages.Severity.Warning, ex.getMessage());
		}
		String aqId = questionHolderMap.get(aqtId).aqt.Application_Question__r.Id;
		if(branchQuestionMap.containsKey(aqId)){
			String currentBranchAnswer = branchQuestionMap.get(aqId);
			if(currentBranchAnswer.contains(questionHolderMap.get(aqtId).answerSubmitted)){
				return;
			}
		} else{
			return;
		}
		Id awtToUse = null;
		branchQuestionMap = new Map<Id, String>();
		Set<Id> awtsToExclude = new Set<Id>();
		for(Application_Window_Template__c awt : [
			SELECT Id, (
				SELECT Id, Answer__c, Application_Question__c
				FROM Application_Branching_Questions__r
			)
			FROM Application_Window_Template__c
			WHERE Application_Window__c = :currApp.Application_Window_Template__r.Application_Window__c
			AND Id != :currApp.Application_Window_Template__c
		]){
			if(awtToUse != null){
				break;
			}
			for (Application_Branching_Question__c abq : awt.Application_Branching_Questions__r){
				String answer = getAnswerFromAQId(abq.Application_Question__c);
				answer = answer.trim();
				if(!abq.Answer__c.contains(answer) || awtsToExclude.contains(awt.Id)){
					awtToUse = null;
					branchQuestionMap = new Map<Id, String>();
					awtsToExclude.add(awt.Id);
				} else{
					awtToUse = awt.Id;
					branchQuestionMap.put(abq.Application_Question__c, abq.Answer__c);
				}
			}
		}
		if(awtToUse == null){
			return;
		}
		currApp.Application_Window_Template__c = awtToUse;
		update currApp;
		generateQuestionsAndSections(null);
	}

	public SectionWrapper generateSectionWrapper(String sectionName, String helpText){
		SectionWrapper sectionWrapper = sectionWrappers.containsKey(sectionName) ? sectionWrappers.get(sectionName): new SectionWrapper(helpText,'');
		return sectionWrapper;
	}

	public String getAnswerFromAQId(Id aqId){
		String answerToReturn = '';
		for(ApplicationQuestionHolder aqh : sectionWrappers.get(formSection).aqhMap.values()){
			if(aqh.aqt.Application_Question__r.Id == aqId){
				answerToReturn = aqh.answerSubmitted;
			}
		}
		return answerToReturn;
	}
	

	/*////////////////////////////////////////////////////////////////////////////////////

									Query Methods

	///////////////////////////////////////////////////////////////////////////////////*/

	private void getCurrentApplication(){
		currApp = [
			SELECT Id, Application_Window_Template__c, Contact__c, Application_Window_Template__r.Application_Window__r.Is_Live__c, Is_Submitted__c,
			Last_Answered_Question__c, Application_Window_Template__r.Application_Window__r.Start_Date__c, Development_Form_Status__c,
			Application_Window_Template__r.Application_Window__c, Application_Window_Template__r.Application_Window__r.End_Date__c,
			Dev_Form_External_Status__c, EOI_External_Status__c, Status__c, (
				SELECT Measure__c, Outcome_Summary__c, Name, Key_Change__c
				FROM Outcomes__r
			), (
				SELECT Name, Was_It_Successful__c, Not_Successful_Reasons__c
				FROM Previous_Applications__r
			)
			FROM Application__c 
			WHERE Id = :getParam('Id')
		];
	}

	private Map<Id, Application_Answer__c> getPreviousAnswers(Id applicationId){
		Map<Id, Application_Answer__c> previouslyAnsweredQuestions = new Map<Id,Application_Answer__c>();
		for(Application_Answer__c singleApplicationAnswer : [
			SELECT Id, Checkbox_Answer__c, Text_Answer__c, Picklist_Answer__c, Application_Question__c, Checkboxes_Answer__c, Short_Text_Answer__c, Multi_Picklist_Answers__c,
			Date_Answer__c, Email_Answer__c, Percent_Answer__c, Response__c, Currency_Answer__c, Marked_as_Complete__c, 
			Date_Day_Answer__c, Date_Month_Answer__c, Date_Year_Answer__c, Radio_Answer__c
			FROM Application_Answer__c
			WHERE Application__c = :applicationId
			ORDER BY Application_Question__r.Question_Number__c ASC
		]){
			previouslyAnsweredQuestions.put(singleApplicationAnswer.Application_Question__c, singleApplicationAnswer);
		}
		return previouslyAnsweredQuestions;
	}

	private void getApplicationCommissioners(){
		applicationCommissioners = [
			SELECT Email, FirstName, LastName, Phone, Account.Organisation_Region__c, Account.Name
			FROM Contact
			WHERE Id IN (
				SELECT Commissioner__c FROM Application_Commissioner__c WHERE Application__c = :getParam('Id')
			)
		];
	}

	private List<Application_Question_Template__c> returnCurrentApplicationQuestionTemplate(){
		String queryString = 
			'SELECT Application_Question__r.Id, Application_Question__r.Question_Type__c, Application_Question__r.Required__c,' + 
			' Application_Question__r.Field_From_Contact_Record__c, Application_Question__r.Field_To_Set_On_Answer__c, Application_Question__r.Help_Text__c,' +
			' Application_Question__r.Question__c, Application_Question__r.Picklist_Options__c, Application_Question__r.Checkboxes_Options__c,' +
			' Application_Form_Section__r.Name, Application_Form_Section__r.Help_Text__c, Application_Question__r.Character_Word_Assistance__c,' + 
			' Application_Question__r.Is_Branching_Question__c, Application_Question__r.Field_to_Check_for_Rendering__c, ' +
			' Application_Question__r.Field_to_Conditionally_Render__c, Application_Question__r.Answer_To_Rerender_On__c, ' +
			' Application_Question__r.Subtext__c ' + 
			' FROM Application_Question_Template__c' + 
			' WHERE Application_Window_Template__r.Id = \'' + currApp.Application_Window_Template__c + '\'' + 
			' AND Application_Form_Section__r.Form_To_Use_In__c = \'' + getParam('formType') + '\'' +  
			' ORDER BY Application_Question__r.Question_Number__c ASC';
		return Database.query(queryString);
	}

	public PageReference returnHomePage(){
		return Page.SIB_ApplicationList;
	}

	public void nextPage(){
		if(ApexPages.getMessages().size() != 0){
			return;
		}
		else{
			if(pageNumber==2){
				if(!SIB_Utilities.isValidEmail(commissionerToCreate.Email)){
					addMesssageToPage(ApexPages.Severity.Warning, 'Please enter valid email address');
					return;
				}
			}
			updatePageNumber(1);
		}
	}

	public void previousPage(){
		updatePageNumber(-1);        
	}

	private void updatePageNumber(Integer toAdd){
		pageNumber = pageNumber + toAdd;
	}

	public void toggleSection(){
		setAdditionalSectionToShow(getParam('additionalSection'));
		commissionerToCreate = null;
		outcomeToCreate = null;
		prevAppToCreate = null;
	}

	private void setAdditionalSectionToShow(String additionalSection){
		additionalSectionToShow = additionalSectionToShow == additionalSection ? '' : additionalSection;
	}

	private List<CheckboxWrapper> generateRegionCBW(){
		List<CheckBoxWrapper> cbwList = new List<CheckBoxWrapper>();
		for(Schema.PicklistEntry picklistOption : Account.Organisation_Region__c.getDescribe().getPicklistValues()){
			cbwList.add(new CheckBoxWrapper(picklistOption.getLabel(), false));
		}
		return cbwList;
	}

	public Map<String, List<ApplicationQuestionHolder>> getSWAnswers(){
		Map<String, List<ApplicationQuestionHolder>> returnValue = new Map<String, List<ApplicationQuestionHolder>>();
		for(String sectionWrapperKey : sectionWrappers.keySet()){
			if(formSection == 'ALL_QUESTIONS' || formSection == sectionWrapperKey){
				returnValue.put(sectionWrapperKey, sectionWrappers.get(sectionWrapperKey).aqhMap.values());
			}
		}
		return returnValue;
	}

	public void setAnswer(){
		String answerType = getParam('answerType');
		String answerToSet = getParam('answerToSet');
		Id aqtId = getParam('aqtId');
		SectionWrapper sw = sectionWrappers.get(formSection);
		Map<Id, ApplicationQuestionHolder> aqhMap = sw.aqhMap;
		ApplicationQuestionHolder aqh = aqhMap.get(aqtId);
		aqh.applicationAnswer.put(answerType, answerToSet);
		aqh.setAnswerSubmitted();
	}
}