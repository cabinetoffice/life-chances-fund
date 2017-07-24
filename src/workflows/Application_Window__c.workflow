<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Is_Live</fullName>
        <description>Update the Is Live checkbox to TRUE</description>
        <field>Is_Live__c</field>
        <literalValue>1</literalValue>
        <name>Is Live</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Not_Live</fullName>
        <description>Mark the Application Window as not Live after end date is passed</description>
        <field>Is_Live__c</field>
        <literalValue>0</literalValue>
        <name>Not Live</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Is Live</fullName>
        <actions>
            <name>Is_Live</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Application_Window__c.Start_Date__c</field>
            <operation>lessOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Application_Window__c.End_Date__c</field>
            <operation>greaterOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>Update Is Live field when the window is open</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Not_Live</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Application_Window__c.End_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
