<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notify_Case_Owner_For_New_Case</fullName>
        <description>Notify Case Owner For New Case</description>
        <protected>false</protected>
        <recipients>
            <recipient>mdalmacio@seiu-uhw.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Support_Case_Email_Alert_For_New_Case</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_For_New_Case_Created</fullName>
        <description>Send Email To MD For New Case Created for HR Request and Salesforce Issues</description>
        <protected>false</protected>
        <recipients>
            <recipient>mdalmacio@seiu-uhw.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Support_Case_Email_Alert_For_New_Case</template>
    </alerts>
    <rules>
        <fullName>New Case</fullName>
        <actions>
            <name>Send_Email_For_New_Case_Created</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email</value>
        </criteriaItems>
        <description>New Case</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
