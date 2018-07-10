public class ContactFieldUseBatchCount2 implements Database.Batchable<sObject>, Database.Stateful {

    // https://force746.wordpress.com/2014/08/28/count-large-number-of-records-more-than-50000:
    // https://salesforce.stackexchange.com/questions/103223/passing-parameter-to-batch-apex/103224

    private String field;
    private String recId;
    private String jobId;
    private String division;
    Integer total = 0;

    public ContactFieldUseBatchCount2(String fieldParam,String idParam, String divisionParam) {
        field    = fieldParam;
        recId    = idParam;
        division = divisionParam;
        system.debug(' constructor ' + field + ' ' + idParam);  
    }

    public Database.QueryLocator start(Database.BatchableContext BC) {
        String query;

        AsyncApexJob      aaj = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id = :BC.getJobId()];
//        ContactDescObj__c cdo = new ContactDescObj__c();
//        cdo.Id                = recId;
//        cdo.CountStart__c     = System.Now();
//        cdo.JobId__c          = aaj.Id;
//        cdo.JobStatus__c      = aaj.Status;
//        try {
//            update cdo;
//        } catch(Exception e) {
//            System.debug('Error updating ContactDescObj__c (Id:' + recId + ')  ' + e.getMessage());
//        }

        jobId = aaj.Id;
        system.debug('Apex job Id: ' + aaj.Id + ' Status: ' + aaj.Status + ' TotalJobItems: ' + aaj.TotalJobItems + ' Errors:  ' + aaj.NumberOfErrors + ' ItemsProcessed: ' + aaj.JobItemsProcessed );

        integer recLimit;
        if(Test.isRunningTest())
            recLimit = 1;
        else
            recLimit = 9999999;

        if(division == 'All') {
            query = 'SELECT Id FROM Contact WHERE ' + field + ' != null LIMIT ' + recLimit;
        }
        else {
            query = 'SELECT Id FROM Contact WHERE Account.Account_Group__c = \'' + division + '\' And ' + field + ' != null LIMIT ' + recLimit;
        }
        system.debug(' start [' + query + ']');
        return Database.getQueryLocator(query);
    }
 
    public void execute(Database.BatchableContext BC, List<sObject> scope) {
        total += scope.size();
    }
 
    public void finish(Database.BatchableContext BC) {

        AsyncApexJob      aaj = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id = :jobId];

        System.debug('id: ' + recId + '  field: ' + field + '  total: ' + total);
        ContactDescObj__c cdo = new ContactDescObj__c();
        cdo.Id               = recId;
        cdo.CountStop__c     = System.Now();
        cdo.Count__c         = total;
        cdo.Division__c      = division;
        cdo.JobId__c         = aaj.Id;
        cdo.JobStatus__c     = aaj.Status;
        cdo.JobErrors__c     = aaj.NumberOfErrors;
        cdo.JobItems__c      = aaj.JobItemsProcessed;
        cdo.JobItemsTotal__c = aaj.TotalJobItems;
        try {
            update cdo;
        } catch(Exception e) {
            System.debug('Error updating ContactDescObj__c (Id:' + recId + ')  ' + e.getMessage());
        }
        system.debug('Apex job Id: ' + aaj.Id + ' Status: ' + aaj.Status + ' TotalJobItems: ' + aaj.TotalJobItems + ' Errors:  ' + aaj.NumberOfErrors + ' ItemsProcessed: ' + aaj.JobItemsProcessed );
    }
}