public with sharing class SIB_ChangePasswordController {
	public String oldPassword {get; set;}
	public String newPassword {get; set;}
	public String verifyNewPassword {get; set;}
	
	public PageReference changePassword() {
		return Site.changePassword(newPassword, verifyNewPassword, oldpassword);    
	}

	public PageReference checkLoggedInStatus(){
		return SIB_Utilities.checkLoggedInStatus();
	}
}