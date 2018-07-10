<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>BHAT_Activity_Weekly_Rejected_Email_Template</fullName>
        <description>BHAT Activity Weekly Rejected Email Template</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HR/BHAT_Activity_Weekly_Rejected_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Email_Incomplete_BHAT</fullName>
        <ccEmails>mdalmacio@seiu-uhw.org</ccEmails>
        <description>Email Incomplete BHAT</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HR/BHAT_Incomplete_Week</template>
    </alerts>
    <fieldUpdates>
        <fullName>BHATStatusUpdate_for_NoEntry_Weekly</fullName>
        <field>Status__c</field>
        <literalValue>No Entry</literalValue>
        <name>BHATStatusUpdate_for_NoEntry_Weekly</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>BhatStatusUpdate_NoEntry_On_Weekly</fullName>
        <actions>
            <name>BHATStatusUpdate_for_NoEntry_Weekly</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update the status as no entry in weekly record, if there are no child activities exists</description>
        <formula>AND( WeeklyTotalHours__c = 0, Total_Time_Off_Hours__c = 0, WeeklyUnpaidLunchHours__c = 0, WeeklyPaidBreakHours__c = 0 )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Email Note on Review Status is Rejected</fullName>
        <actions>
            <name>BHAT_Activity_Weekly_Rejected_Email_Template</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>BHAT_Activity_Weekly__c.Review_Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <description>Send Email Note to the user on Review Status is Rejected</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
