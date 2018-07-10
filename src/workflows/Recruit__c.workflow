<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Recruit_Credit</fullName>
        <field>Credit__c</field>
        <name>Recruit Credit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Attended_Volunteer</fullName>
        <description>This is for the recruit object.</description>
        <field>Attended__c</field>
        <literalValue>1</literalValue>
        <name>Update Attended Volunteer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Recruit_Unique_Id</fullName>
        <field>UniqueId__c</field>
        <formula>TEXT(Location__c) &amp; TEXT(Volunteer_Date__c) &amp;  TEXT(Shift__c ) &amp; Recruit_Name__c &amp; &quot;-&quot; &amp; Employer_Name__c &amp; Alt_Last_Name__c &amp; &quot;-&quot; &amp;  Alt_First_Name__c</formula>
        <name>Update Recruit Unique Id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Signed_Out_Datetime</fullName>
        <description>Use in Recruits Phone Banking</description>
        <field>Signed_Out_Time__c</field>
        <formula>NOW()</formula>
        <name>Update Signed Out Datetime</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Signed_in_Datetime</fullName>
        <description>Use in Recruits Phone Banking</description>
        <field>Signed_In_Time__c</field>
        <formula>NOW()</formula>
        <name>Update Signed in Datetime</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Update UniqueId For Recruit</fullName>
        <actions>
            <name>Update_Recruit_Unique_Id</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OwnerId &lt;&gt;   Recruit__c</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Volunteer Signed In</fullName>
        <actions>
            <name>Update_Attended_Volunteer</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Signed_in_Datetime</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Recruit__c.Signed_In__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>This is use in Recruit - Phone Banking.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Volunteer Signed Out</fullName>
        <actions>
            <name>Update_Signed_Out_Datetime</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Recruit__c.Signed_Out__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>This is use in Recruit - Phone Banking.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
