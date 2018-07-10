<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>BHAT_Update_Unique_Id</fullName>
        <field>UniqueId__c</field>
        <formula>OwnerId &amp; TEXT(Activity_Date__c) &amp; BHAT_Activity_Code__c &amp; BHAT_Activity_Note__c &amp; BHAT_Activity_Note_Other__c &amp; TEXT(Hours_Spent__c)</formula>
        <name>BHAT Update Unique Id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update BHAT Activity Unique Id</fullName>
        <actions>
            <name>BHAT_Update_Unique_Id</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Concatenate the following fields:
OwnerID&amp;Activity_Date__c&amp;BHAT_Activity_Code__c&amp;BHAT_Activity_Note__c&amp;BHAT_ACTIVITY_NOTE_OTHER__C&amp;HOURS_SPENT__C</description>
        <formula>OwnerId  =  LastModifiedById</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
