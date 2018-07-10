@isTest (seeAllData=true) private class ContactFieldUseBatchCountTest {
    @isTest public static void testBatch() {

        System.debug('testBatch start');

        ContactDescObj__c[] cdo = [SELECT Id,FieldAPIName__c FROM ContactDescObj__c WHERE  (FieldType__c Not IN ('TEXTAREA','LOCATION')) AND FieldAPIName__c LIKE '%__c' AND CountStop__c = null LIMIT 1];
        String fn = cdo[0].FieldAPIName__c;
        String id = cdo[0].Id;
        ContactFieldUseBatchCount testRun = new ContactFieldUseBatchCount(fn,id);

        Test.StartTest();
        ID batchprocessid = Database.executeBatch(testRun, 1);
        Test.StopTest();

        System.debug('testBatch stop');
        String query = 'SELECT CountStop__c FROM ContactDescObj__c WHERE Id = \'' + id + '\'';
        System.AssertNotEquals(  database.query(query), null);  
    }
}