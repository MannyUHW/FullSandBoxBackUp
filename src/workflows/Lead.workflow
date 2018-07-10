<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Notify_For_E_Signed_Card</fullName>
        <description>Email Notify For E-Signed Card</description>
        <protected>false</protected>
        <recipients>
            <field>Notify_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Email_Notify_For_E_Signed_Card</template>
    </alerts>
    <alerts>
        <fullName>Send_eCard_Email_Confirmation_Copy</fullName>
        <description>Send eCard Email Confirmation Copy</description>
        <protected>false</protected>
        <recipients>
            <recipient>organize@seiu-uhw.org</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>organize@seiu-uhw.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Email_Confirmation_eCard_Copy</template>
    </alerts>
    <alerts>
        <fullName>Send_eCard_Email_Confirmation_to_Worker</fullName>
        <description>Send eCard Email Confirmation to Worker</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>organize@seiu-uhw.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Email_Confirmation_For_UHW_Web_To_Lead</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Notify_Email_Addr</fullName>
        <field>Notify_Email_Address__c</field>
        <formula>Organizer_Email__c</formula>
        <name>Update Notify Email Addr</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>E-Card Leads</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>Web</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>E-Signed Card Leads</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>Web</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New eCard for Emanuel</fullName>
        <actions>
            <name>Send_eCard_Email_Confirmation_Copy</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>Web</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Company</field>
            <operation>equals</operation>
            <value>Emanuel Medical Center</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
