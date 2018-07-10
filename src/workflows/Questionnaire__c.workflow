<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Staff_Eval_Form</fullName>
        <description>Email Staff Eval Form</description>
        <protected>false</protected>
        <recipients>
            <field>Survey_Taker_Email_Addr__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Survey_Taker_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@seiu-uhw.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Staff_Eval</template>
    </alerts>
    <alerts>
        <fullName>Email_Year_End_Form_Final</fullName>
        <description>Email Year End Form - Final</description>
        <protected>false</protected>
        <recipients>
            <field>Survey_Taker_Email_Addr__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Survey_Taker_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@seiu-uhw.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Year_End_Feeback_Final</template>
    </alerts>
    <alerts>
        <fullName>Email_Year_End_Form_Manager</fullName>
        <description>Email Year End Form - Manager</description>
        <protected>false</protected>
        <recipients>
            <field>Survey_Taker_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@seiu-uhw.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Year_End_Feeback_Manager</template>
    </alerts>
    <alerts>
        <fullName>Email_Year_End_Form_Myself</fullName>
        <description>Email Year End Form - Myself</description>
        <protected>false</protected>
        <recipients>
            <field>Survey_Taker_Email_Addr__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Survey_Taker_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@seiu-uhw.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Year_End_Feeback_Myself</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Manager_Email</fullName>
        <field>Survey_Taker_Manager_Email__c</field>
        <formula>Owner:User.Manager_Email__c</formula>
        <name>Update Manager Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_URL</fullName>
        <field>Record_URL__c</field>
        <formula>&quot;https://uhw.my.salesforce.com/&quot; &amp;  Id</formula>
        <name>Update Record URL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Staff_Email</fullName>
        <field>Survey_Taker_Email_Addr__c</field>
        <formula>Owner:User.Email</formula>
        <name>Update Staff Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Field Year End Eval - upd %26 email 1</fullName>
        <actions>
            <name>Email_Year_End_Form_Myself</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Manager_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Record_URL</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Staff_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Questionnaire__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Field Year End Eval</value>
        </criteriaItems>
        <criteriaItems>
            <field>Questionnaire__c.Feedback_from__c</field>
            <operation>equals</operation>
            <value>Myself</value>
        </criteriaItems>
        <description>Filled out by everyone - myself;</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Field Year End Eval - upd %26 email 2</fullName>
        <actions>
            <name>Email_Year_End_Form_Manager</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Manager_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Record_URL</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Staff_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Questionnaire__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Field Year End Eval</value>
        </criteriaItems>
        <criteriaItems>
            <field>Questionnaire__c.Feedback_from__c</field>
            <operation>equals</operation>
            <value>Manager</value>
        </criteriaItems>
        <description>Filled out by everyone - manager;</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Field Year End Eval - upd %26 email 3</fullName>
        <actions>
            <name>Email_Year_End_Form_Final</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Manager_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Record_URL</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Staff_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Questionnaire__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Field Year End Eval</value>
        </criteriaItems>
        <criteriaItems>
            <field>Questionnaire__c.Feedback_from__c</field>
            <operation>equals</operation>
            <value>Final</value>
        </criteriaItems>
        <description>Filled out by everyone - final;</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Staff Eval - upd %26 email</fullName>
        <actions>
            <name>Email_Staff_Eval_Form</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Manager_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Record_URL</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Staff_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Questionnaire__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Kaiser Picket Eval,Dignity Campaign Evalution 2018</value>
        </criteriaItems>
        <description>Staff Eval</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
