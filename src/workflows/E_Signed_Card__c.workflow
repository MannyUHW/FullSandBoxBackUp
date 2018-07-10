<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>E_Signed_Card_Confirmation</fullName>
        <ccEmails>organize@seiu-uhw.org</ccEmails>
        <description>E-Signed Card Confirmation</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>organize@seiu-uhw.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Email_Confirmation_For_UHW_Web_ECards</template>
    </alerts>
    <alerts>
        <fullName>E_Signed_Card_Notify</fullName>
        <description>E-Signed Card Notify</description>
        <protected>false</protected>
        <recipients>
            <recipient>mdalmacio@seiu-uhw.org</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>noreply@seiu-uhw.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/E_Signed_Card_Notify</template>
    </alerts>
    <rules>
        <fullName>A new e-signed card</fullName>
        <actions>
            <name>E_Signed_Card_Confirmation</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>E_Signed_Card__c.Getfeedback_Response_Link__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
