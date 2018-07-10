@isTest(SeeAllData=true) 
private class SOS_UtilityTestClass {
    
     static testMethod void testSOSUtility(){
     //Set<Id> groupIds = new Set<Id>();
     GroupMember gm = [Select Id, UserOrGroupId From GroupMember LIMIT 1];
     //groupIds
     //SOS_Utility.getUserIdsFromGroup(groupIds);
     
     SOS_Utility.getUserEmailIdsFromGroup(gm.Id);
     
     SOS_Utility.isSrchStrPresent('f;t;g;', 'f');
    }
}