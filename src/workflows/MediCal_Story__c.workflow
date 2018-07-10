<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Hospital_Goal_19</fullName>
        <field>New_Goal__c</field>
        <formula>19</formula>
        <name>Update Hospital Goal 19</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Hospital_Goal_21</fullName>
        <field>New_Goal__c</field>
        <formula>21</formula>
        <name>Update Hospital Goal 21</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_mali</fullName>
        <field>Hospital_Team__c</field>
        <literalValue>South - Mali&apos;s Team</literalValue>
        <name>update mali</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_salvador</fullName>
        <description>Medi-Cal Story</description>
        <field>Hospital_Team__c</field>
        <literalValue>North - Salvador&apos;s Team</literalValue>
        <name>update salvador</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_team_jackie</fullName>
        <field>Hospital_Team__c</field>
        <literalValue>North - Jackie&apos;s Team</literalValue>
        <name>update team jackie</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_team_john</fullName>
        <field>Hospital_Team__c</field>
        <literalValue>South - John&apos;s Team</literalValue>
        <name>update team john</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Update Hospital Goal Organizer - 2</fullName>
        <actions>
            <name>Update_Hospital_Goal_19</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND (2 OR 3 OR 4 OR 5)</booleanFilter>
        <criteriaItems>
            <field>MediCal_Story__c.Division__c</field>
            <operation>equals</operation>
            <value>HOSPITAL,Hospital</value>
        </criteriaItems>
        <criteriaItems>
            <field>MediCal_Story__c.Organizer__c</field>
            <operation>equals</operation>
            <value>Donna Mapp,Sharrion Marshall</value>
        </criteriaItems>
        <criteriaItems>
            <field>MediCal_Story__c.Organizer__c</field>
            <operation>equals</operation>
            <value>Andrea Hodges,Carlos Urrutia</value>
        </criteriaItems>
        <criteriaItems>
            <field>MediCal_Story__c.Organizer__c</field>
            <operation>equals</operation>
            <value>Jacqueline McElroy,Jesus Andrade</value>
        </criteriaItems>
        <criteriaItems>
            <field>MediCal_Story__c.Organizer__c</field>
            <operation>equals</operation>
            <value>Onyi Ibeabuchi</value>
        </criteriaItems>
        <description>This is for the new organizers. With 19 goals.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Hospital Team Jackie</fullName>
        <actions>
            <name>update_team_jackie</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND (2 OR 3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>MediCal_Story__c.Division__c</field>
            <operation>equals</operation>
            <value>HOSPITAL,Hospital</value>
        </criteriaItems>
        <criteriaItems>
            <field>MediCal_Story__c.Organizer__c</field>
            <operation>equals</operation>
            <value>Jacqueline McElroy,Andrea Hodges</value>
        </criteriaItems>
        <criteriaItems>
            <field>MediCal_Story__c.Organizer__c</field>
            <operation>equals</operation>
            <value>Onyi Ibeabuchi,Jesus Andrade</value>
        </criteriaItems>
        <criteriaItems>
            <field>MediCal_Story__c.Organizer__c</field>
            <operation>equals</operation>
            <value>Carlos Urrutia</value>
        </criteriaItems>
        <description>This is use for Medi-Cal Story - hospital team.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Hospital Team John</fullName>
        <actions>
            <name>update_team_john</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND (2 OR 3 OR 4 OR 5 OR 6)</booleanFilter>
        <criteriaItems>
            <field>MediCal_Story__c.Division__c</field>
            <operation>equals</operation>
            <value>HOSPITAL,Hospital</value>
        </criteriaItems>
        <criteriaItems>
            <field>MediCal_Story__c.Organizer__c</field>
            <operation>equals</operation>
            <value>John Aho,Bennie Tinson</value>
        </criteriaItems>
        <criteriaItems>
            <field>MediCal_Story__c.Organizer__c</field>
            <operation>equals</operation>
            <value>Jordan Thomas,Myriam Juarez Inzunza</value>
        </criteriaItems>
        <criteriaItems>
            <field>MediCal_Story__c.Organizer__c</field>
            <operation>equals</operation>
            <value>Jennifer Saldana,Myriam Juarez (Inzunza)</value>
        </criteriaItems>
        <criteriaItems>
            <field>MediCal_Story__c.Organizer__c</field>
            <operation>equals</operation>
            <value>Myriam Juarez,Myriam Inzunza</value>
        </criteriaItems>
        <criteriaItems>
            <field>MediCal_Story__c.Organizer__c</field>
            <operation>equals</operation>
            <value>Vladimir (Armando) Dominguez,Vladimir Dominguez</value>
        </criteriaItems>
        <description>This is use for Medi-Cal Story - hospital team.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Hospital Team Mali</fullName>
        <actions>
            <name>update_mali</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 AND (2 OR 3 OR 4))</booleanFilter>
        <criteriaItems>
            <field>MediCal_Story__c.Division__c</field>
            <operation>equals</operation>
            <value>HOSPITAL,Hospital</value>
        </criteriaItems>
        <criteriaItems>
            <field>MediCal_Story__c.Organizer__c</field>
            <operation>equals</operation>
            <value>Amalia Woods-Drake,Carlos Magdaleno,Italia Gracia</value>
        </criteriaItems>
        <criteriaItems>
            <field>MediCal_Story__c.Organizer__c</field>
            <operation>equals</operation>
            <value>Sotero Chandler Ramas,Italia Garcia</value>
        </criteriaItems>
        <criteriaItems>
            <field>MediCal_Story__c.Organizer__c</field>
            <operation>equals</operation>
            <value>Italia Garcia-Uribe,Sotero Chandler Ramas III</value>
        </criteriaItems>
        <description>This is use for Medi-Cal Story - hospital team.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Hospital Team Salvador</fullName>
        <actions>
            <name>update_salvador</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND (2 OR 3 OR 4 OR 5)</booleanFilter>
        <criteriaItems>
            <field>MediCal_Story__c.Division__c</field>
            <operation>equals</operation>
            <value>HOSPITAL,Hospital</value>
        </criteriaItems>
        <criteriaItems>
            <field>MediCal_Story__c.Organizer__c</field>
            <operation>equals</operation>
            <value>Deserae Tankson,LaMesha Merritt</value>
        </criteriaItems>
        <criteriaItems>
            <field>MediCal_Story__c.Organizer__c</field>
            <operation>equals</operation>
            <value>Luisa Padilla,Sabrina Struth</value>
        </criteriaItems>
        <criteriaItems>
            <field>MediCal_Story__c.Organizer__c</field>
            <operation>equals</operation>
            <value>Salvador Marroquin Garcia</value>
        </criteriaItems>
        <criteriaItems>
            <field>MediCal_Story__c.Organizer__c</field>
            <operation>equals</operation>
            <value>Donna Mapp,Sharrion Marshall</value>
        </criteriaItems>
        <description>This is use for Medi-Cal Story - hospital team.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
