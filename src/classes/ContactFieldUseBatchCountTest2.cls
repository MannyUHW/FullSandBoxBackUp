@isTest (seeAllData=true) private class ContactFieldUseBatchCountTest2 {
    @isTest public static void testBatch() {

        System.debug('testBatch start');

        ContactDescObj__c[] cdo = [SELECT Id,FieldAPIName__c FROM ContactDescObj__c WHERE  (FieldType__c Not IN ('TEXTAREA','LOCATION')) AND FieldAPIName__c LIKE '%__c' LIMIT 1];
        String fn = cdo[0].FieldAPIName__c;
        String id = cdo[0].Id;
        ContactFieldUseBatchCount2 testRun = new ContactFieldUseBatchCount2(fn,id,'All');

        Test.StartTest();
        ID batchprocessid = Database.executeBatch(testRun, 2000);
        Test.StopTest();

        System.debug('testBatch stop');
        String query = 'SELECT CountStop__c FROM ContactDescObj__c WHERE Id = \'' + id + '\'';
        System.AssertNotEquals(  database.query(query), null);  
    }
}