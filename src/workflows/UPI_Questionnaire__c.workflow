<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>UPI_New_Record_For_Review</fullName>
        <description>UPI New Record For Review</description>
        <protected>false</protected>
        <recipients>
            <recipient>amedina@seiu-uhw.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>crueda@seiu-uhw.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>krescate@seiu-uhw.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mdalmacio@seiu-uhw.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mlege@seiu-uhw.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>rradhakrishnan@seiu-uhw.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>tsundeen@seiu-uhw.org</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>noreply@seiu-uhw.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/UPI_Questionnaire_Review</template>
    </alerts>
    <rules>
        <fullName>UPI Record For Review</fullName>
        <actions>
            <name>UPI_New_Record_For_Review</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>UPI_Questionnaire__c.Ready_to_submit_for_review__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>UPI record is ready for review.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
