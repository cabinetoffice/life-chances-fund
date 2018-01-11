/**
 * COF_Field
 * Cabinet Office Forms 1.0
 *
 * This class represents a field.
 */
public class COF_Field {

	public String identifier {get; set;}
	public String targetObjectIdentifier {get; set;}
	public String label {get; set;}
	public String guidance {get; set;}
	public Integer recommendedWordLimit {get; set;}

	public Boolean isTextField {get; set;}
	public Boolean isRadioField {get; set;}
	public Boolean isSelectField {get; set;}
	public Boolean isDateField {get; set;}
	public Boolean isCheckBox {get; set;}
	public Boolean isCurrency {get; set;}

	public String dateDay {get; set;}
	public String dateMonth {get; set;}
	public String dateYear {get; set;}

	public List<SelectOption> values {get; set;}

	public COF_Field(String identifier, string targetObjectIdentifier) {
		this.identifier = identifier;
		this.targetObjectIdentifier = targetObjectIdentifier;

		Schema.SObjectType targetType = Schema.getGlobalDescribe().get(targetObjectIdentifier);
		Map<String, Schema.SobjectField> fieldmap = targetType.getDescribe().fields.getMap();
		this.label = fieldmap.get(identifier).getDescribe().getInlineHelpText();

		Schema.DisplayType fieldType = fieldmap.get(identifier).getDescribe().getType();
		if (fieldType == Schema.DisplayType.String || fieldType == Schema.DisplayType.TextArea || fieldType == Schema.DisplayType.Currency || fieldType == Schema.DisplayType.Double) {
			this.isTextField = true;
		}
		if (fieldType == Schema.DisplayType.Currency) {
			this.isCurrency = true;
		}
		if (fieldType == Schema.DisplayType.Boolean) {
			this.isCheckBox = true;
		}
		if (fieldType == Schema.DisplayType.Picklist) {
			this.isRadioField = true;
		}
		if (fieldType == Schema.DisplayType.MultiPicklist) {
			this.isSelectField = true;
		}
		if (fieldType == Schema.DisplayType.Date) {
			this.isDateField = true;
		}

		List<Schema.PicklistEntry> picklistValues = fieldmap.get(identifier).getDescribe().getPickListValues();
        this.values = new List<SelectOption>();
        for (Schema.PicklistEntry a : picklistValues) {
            this.values.add(new SelectOption(a.getValue(), a.getLabel()));
        }
	}
}