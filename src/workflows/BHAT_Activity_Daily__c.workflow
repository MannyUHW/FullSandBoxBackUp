<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>BHATStatusUpdate_for_NoEntry</fullName>
        <field>Status__c</field>
        <literalValue>No Entry</literalValue>
        <name>BHATStatusUpdate_for_NoEntry</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BHATStatus_Complete_NonHourlyExempt</fullName>
        <field>Status__c</field>
        <literalValue>Complete</literalValue>
        <name>BHATStatus_Complete_NonHourlyExempt</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BHATStatus_Incomplete_NonHourlyExempt</fullName>
        <field>Status__c</field>
        <literalValue>Incomplete</literalValue>
        <name>BHATStatus_Incomplete_NonHourlyExempt</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BHAT_Status_Updation</fullName>
        <field>Status__c</field>
        <literalValue>Complete</literalValue>
        <name>BHAT_Status Updation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BHAT_Update_Status_to_Incomplete</fullName>
        <field>Status__c</field>
        <literalValue>Incomplete</literalValue>
        <name>BHAT Update Status to Incomplete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BHAT_Update_Status_to_Overtime</fullName>
        <field>Status__c</field>
        <literalValue>Overtime</literalValue>
        <name>BHAT Update Status to Overtime</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>BHAT Update Status to Incomplete</fullName>
        <actions>
            <name>BHAT_Update_Status_to_Incomplete</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Status Field is updated as &apos;Incomplete&apos; when WorkTimeDifference and Hours worked are not same.</description>
        <formula>AND ( Time_Difference__c != (Daily_Hours_Spent__c+ Time_Off_Total__c + Paid_Break_Total__c + Unpaid_Lunch_Total__c ), OR($User.Hourly_Employee__c, $User.Non_Exempt_Employee__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>BHATActivityStatusUpdate</fullName>
        <actions>
            <name>BHAT_Status_Updation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Status Field is updated as &apos;Complete&apos; when WorkTimeDifference and Hours worked are same.</description>
        <formula>AND ( Time_Difference__c = (Daily_Hours_Spent__c+ Time_Off_Total__c + Paid_Break_Total__c + Unpaid_Lunch_Total__c ), Daily_Hours_Total__c &lt;= 8 , OR($User.Hourly_Employee__c, $User.Non_Exempt_Employee__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>BHATActivityStatusUpdate_Overtime</fullName>
        <actions>
            <name>BHAT_Update_Status_to_Overtime</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( Time_Difference__c == (Daily_Hours_Spent__c+ Time_Off_Total__c + Paid_Break_Total__c + Unpaid_Lunch_Total__c ), OR($User.Hourly_Employee__c, $User.Non_Exempt_Employee__c), AND(Daily_Hours_Total__c !=0 , Daily_Hours_Total__c &gt; 8) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>BHATDailyStatus_Complete_NonHourly_NonExempt_Employees</fullName>
        <actions>
            <name>BHATStatus_Complete_NonHourlyExempt</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>status for non hourly exempt staff should show complete if there are any activities at all reported for a given day.</description>
        <formula>AND(  Daily_Hours_Total__c &gt; 0 , NOT($User.Hourly_Employee__c), NOT($User.Non_Exempt_Employee__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>BHATDailyStatus_Incomplete_NonHourly_NonExempt_Employees</fullName>
        <actions>
            <name>BHATStatus_Incomplete_NonHourlyExempt</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>status for non hourly exempt staff should show incomplete if there are no activities at all reported for a given day.</description>
        <formula>AND(  Daily_Hours_Total__c = 0,  NOT($User.Hourly_Employee__c),  NOT($User.Non_Exempt_Employee__c)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>BhatStatusUpdate_NoEntry_On_Daily</fullName>
        <actions>
            <name>BHATStatusUpdate_for_NoEntry</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update the status as no entry in daily record, if there are no child activities exists</description>
        <formula>AND( Daily_Hours_Spent__c = 0, Time_Off_Total__c = 0, Unpaid_Lunch_Total__c = 0, Paid_Break_Total__c = 0 )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
