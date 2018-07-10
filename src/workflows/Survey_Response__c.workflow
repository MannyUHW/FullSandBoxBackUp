<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>Eboard Collected</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Survey_Response__c.Collected_By_Is_EBoard__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Phase 7 Did Something</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Survey_Response__c.Survey_Code__c</field>
            <operation>equals</operation>
            <value>NH1,EN2,EN3,EN5,PC1,PC2,PR1,PR3,PS1,PS3,P10,P11,P13,TN1,TN3,V02,V04</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
