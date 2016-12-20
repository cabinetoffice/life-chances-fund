public with sharing class SIB_LandingController {
	public SIB_LandingController() {
	}
	
	public PageReference goToApplicationList(){
		return Page.SIB_ApplicationList;
	}

	public PageReference checkLoggedInStatus(){
        return SIB_Utilities.checkLoggedInStatus();
    }
}