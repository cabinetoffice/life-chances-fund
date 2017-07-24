<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Application_Submitted</fullName>
        <description>Application Submitted</description>
        <protected>false</protected>
        <recipients>
            <field>Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>lifechancesfund@biglotteryfund.org.uk</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Community_Templates/Application_Submitted</template>
    </alerts>
    <alerts>
        <fullName>EOI_Application_Submitted</fullName>
        <description>EOI Application Submitted</description>
        <protected>false</protected>
        <recipients>
            <field>Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>lifechancesfund@biglotteryfund.org.uk</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Community_Templates/EOI_Application_Submitted</template>
    </alerts>
    <alerts>
        <fullName>EOI_Unsuccessful_Application_Email_Alert</fullName>
        <description>EOI Unsuccessful Application Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>lifechancesfund@biglotteryfund.org.uk</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Community_Templates/EOI_Application_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Office_alert_when_Development_Grant_submitted</fullName>
        <ccEmails>lifechancesfund@biglotteryfund.org.uk</ccEmails>
        <description>Office alert when Development Grant submitted</description>
        <protected>false</protected>
        <senderAddress>lifechancesfund@biglotteryfund.org.uk</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Community_Templates/Office_alert_when_Development_Grant_application_submitted</template>
    </alerts>
    <alerts>
        <fullName>Office_alert_when_EOI_application_submitted</fullName>
        <ccEmails>lifechancesfund@biglotteryfund.org.uk</ccEmails>
        <description>Office alert when EOI application submitted</description>
        <protected>false</protected>
        <senderAddress>lifechancesfund@biglotteryfund.org.uk</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Community_Templates/Office_alert_when_EOI_application_submitted</template>
    </alerts>
    <alerts>
        <fullName>Office_alert_when_Financial_health_and_fraud_prevention_submitted</fullName>
        <ccEmails>lifechancesfund@biglotteryfund.org.uk</ccEmails>
        <description>Office alert when Financial health and fraud prevention submitted</description>
        <protected>false</protected>
        <senderAddress>lifechancesfund@biglotteryfund.org.uk</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Community_Templates/Office_alert_when_Financial_health_and_fraud_prevention_application_submitted</template>
    </alerts>
    <alerts>
        <fullName>Office_alert_when_Full_Application_submitted</fullName>
        <ccEmails>lifechancesfund@biglotteryfund.org.uk</ccEmails>
        <description>Office alert when Full Application submitted</description>
        <protected>false</protected>
        <senderAddress>lifechancesfund@biglotteryfund.org.uk</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Community_Templates/Office_alert_when_Full_Application_application_submitted</template>
    </alerts>
    <alerts>
        <fullName>Office_alert_when_application_submitted</fullName>
        <ccEmails>lifechancesfund@biglotteryfund.org.uk</ccEmails>
        <description>Office alert when application submitted</description>
        <protected>false</protected>
        <recipients>
            <recipient>eloise.sobczyk@culture.gov.uk.admin</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>smithvle@biglotteryfund.org.uk</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>lifechancesfund@biglotteryfund.org.uk</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Community_Templates/Office_Alert_Application_Submitted</template>
    </alerts>
    <alerts>
        <fullName>Send_Development_Grant_Submitted_Email</fullName>
        <description>Send Development Grant Submitted Email</description>
        <protected>false</protected>
        <recipients>
            <field>Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>lifechancesfund@biglotteryfund.org.uk</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Community_Templates/Development_Grant_Submitted</template>
    </alerts>
    <alerts>
        <fullName>Send_Financial_Health_And_Fraud_Prevention_Submitted_Email</fullName>
        <description>Send Financial Health And Fraud Prevention Submitted Email</description>
        <protected>false</protected>
        <recipients>
            <field>Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>lifechancesfund@biglotteryfund.org.uk</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Community_Templates/Financial_health_and_fraud_prevention_Submitted</template>
    </alerts>
    <alerts>
        <fullName>Send_Full_Application_Submitted_Email</fullName>
        <description>Send Full Application Submitted Email</description>
        <protected>false</protected>
        <recipients>
            <field>Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>lifechancesfund@biglotteryfund.org.uk</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Community_Templates/Full_Application_Submitted</template>
    </alerts>
    <alerts>
        <fullName>Send_Full_Application_Successful_Email</fullName>
        <description>Send Full Application Successful Email</description>
        <protected>false</protected>
        <recipients>
            <field>Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>lifechancesfund@biglotteryfund.org.uk</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Community_Templates/Full_Application_Approved</template>
    </alerts>
    <alerts>
        <fullName>Send_Full_Application_Unsuccessful_Email</fullName>
        <description>Send Full Application Unsuccessful Email</description>
        <protected>false</protected>
        <recipients>
            <field>Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>lifechancesfund@biglotteryfund.org.uk</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Community_Templates/Full_Application_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Successful_Application_Email_Alert</fullName>
        <description>Successful Application Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>lifechancesfund@biglotteryfund.org.uk</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Community_Templates/EOI_Application_Approved</template>
    </alerts>
    <alerts>
        <fullName>Unsuccessful_Application_Email_Alert</fullName>
        <description>Unsuccessful Application Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>lifechancesfund@biglotteryfund.org.uk</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Community_Templates/Application_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>Applicant_Email</fullName>
        <description>Update Applicant Email Field</description>
        <field>Contact_Email__c</field>
        <formula>Contact__r.Email</formula>
        <name>Applicant Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Submitted_Application_Field_Update</fullName>
        <field>Is_Submitted__c</field>
        <literalValue>1</literalValue>
        <name>Submitted Application Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Applicant Email</fullName>
        <actions>
            <name>Applicant_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update the Applicant Email field when a contact is associated</description>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Confirmation of Application</fullName>
        <actions>
            <name>Application_Submitted</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Application__c.Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <description>Send an email to applicant when their form is successfully submitted</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Development Grant  Submitted</fullName>
        <actions>
            <name>Send_Development_Grant_Submitted_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Application__c.Development_Form_Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <description>Send an email to applicant when their development grant is successfully submitted</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EOI Application Submitted</fullName>
        <actions>
            <name>EOI_Application_Submitted</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Submitted_Application_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Application__c.Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <description>Send an email to applicant when their EOI form is successfully submitted</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EOI Application Successful</fullName>
        <actions>
            <name>Successful_Application_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Application__c.Status__c</field>
            <operation>equals</operation>
            <value>Successful</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EOI Unsuccessful Application</fullName>
        <actions>
            <name>EOI_Unsuccessful_Application_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Application__c.Status__c</field>
            <operation>equals</operation>
            <value>Unsuccessful</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Financial Health And Fraud Prevention Submitted</fullName>
        <actions>
            <name>Send_Financial_Health_And_Fraud_Prevention_Submitted_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Application__c.Identity_Check_Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <description>Send an email to applicant when their Financial health and fraud prevention is successfully submitted</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Full Application Submitted</fullName>
        <actions>
            <name>Send_Full_Application_Submitted_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Application__c.Full_Application_Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <description>Send an email to applicant when their full application is successfully submitted</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Full Application Successful</fullName>
        <actions>
            <name>Send_Full_Application_Successful_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Application__c.Full_Application_Status__c</field>
            <operation>equals</operation>
            <value>Successful</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Full Application Unsuccessful</fullName>
        <actions>
            <name>Send_Full_Application_Unsuccessful_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Application__c.Full_Application_Status__c</field>
            <operation>equals</operation>
            <value>Unsuccessful</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Office alert when Development Grant submitted</fullName>
        <actions>
            <name>Office_alert_when_Development_Grant_submitted</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Application__c.Development_Form_Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <description>Sends an email to lifechancesfund@biglotteryfund.org.uk when a development grant is submitted.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Office alert when EOI application submitted</fullName>
        <actions>
            <name>Office_alert_when_EOI_application_submitted</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Application__c.Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <description>Sends an email to lifechancesfund@biglotteryfund.org.uk when an EOI application is submitted.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Office alert when Financial health and fraud prevention submitted</fullName>
        <actions>
            <name>Office_alert_when_Financial_health_and_fraud_prevention_submitted</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Application__c.Identity_Check_Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <description>Sends an email to lifechancesfund@biglotteryfund.org.uk when a  Financial health and fraud prevention is submitted.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Office alert when Full Application submitted</fullName>
        <actions>
            <name>Office_alert_when_Full_Application_submitted</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Application__c.Full_Application_Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <description>Sends an email to lifechancesfund@biglotteryfund.org.uk when a  Financial health and fraud prevention is submitted.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Office alert when application submitted</fullName>
        <actions>
            <name>Office_alert_when_application_submitted</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Application__c.Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <description>Sends an email to lifechancesfund@biglotteryfund.org.uk when an application is submitted.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Submitted Application</fullName>
        <actions>
            <name>Submitted_Application_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Application__c.Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Successful Application</fullName>
        <actions>
            <name>Successful_Application_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Application__c.Status__c</field>
            <operation>equals</operation>
            <value>Successful</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Unsuccessful Application</fullName>
        <actions>
            <name>Unsuccessful_Application_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Application__c.Status__c</field>
            <operation>equals</operation>
            <value>Unsuccessful</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
