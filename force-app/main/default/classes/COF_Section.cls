/**
 * COF_Section
 * Cabinet Office Forms 1.0
 *
 * This class represents a section in a form.
 */
public class COF_Section {

	public String id {get;set;}
	public String title {get;set;}
	public String summary {get;set;}
	public String status_field {get; set;}
	public COF_QuestionSet questionSet;

	/**
	* Returns the question set for this section
	*/
	public COF_QuestionSet getQuestionSet() {
		if (this.questionSet == null) {
			return COF_QuestionSet.load(this.id);
		}
		return this.questionSet;
	}
}