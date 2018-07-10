<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_COPE_Pledge_Static</fullName>
        <field>COPE_Pledge_Static__c</field>
        <formula>COPE_Pledge_Amount__c</formula>
        <name>Update COPE Pledge Static</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update COPE Pledge Static</fullName>
        <actions>
            <name>Update_COPE_Pledge_Static</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>COPE_SignUp__c.COPE_Pledge_Amount__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
