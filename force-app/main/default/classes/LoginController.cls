public class LoginController extends COF_PageController {

		public PageReference login() {

        PageReference nextPage = Page.sections;
	        nextPage.getParameters().put('form', 'lcf_eoi_1');
	        nextPage.getParameters().put('id', 'a027E000004A5isQAC');
	        nextPage.setRedirect(true);
	        return nextPage;
    	}

}