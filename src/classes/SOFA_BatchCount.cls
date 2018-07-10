public class SOFA_BatchCount implements Database.Batchable<sObject>, Database.Stateful {

    // https://force746.wordpress.com/2014/08/28/count-large-number-of-records-more-than-50000:
    // https://salesforce.stackexchange.com/questions/103223/passing-parameter-to-batch-apex/103224

    private String objectAPIName,fieldAPIName,sofaJobId, sofaJobItemId;
    private Datetime jobItemStart; 
    Integer total = 0;

    public SOFA_BatchCount(String pSofaJobId, String pObjectAPIName, String pFieldAPIName, String pSofaJobItemId) {
        sofaJobId     = pSofaJobId;
        objectAPIName = pObjectAPIName;
        fieldAPIName  = pFieldAPIName;
        jobItemStart  = System.Now();
        sofaJobItemId = pSofaJobItemId;
        system.debug(' SOFA_BatchCount - (constructor) sofaJobId: ' + sofaJobId + ' objectAPIName: ' + objectAPIName + ' fieldAPIName: ' +  fieldAPIName + ' sofaJobItemId: ' + sofaJobItemId);  
    }

    public Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id FROM ' + objectAPIName + ' WHERE ' + fieldAPIName + ' = null' ;
        system.debug(' start [' + query + ']');
        return Database.getQueryLocator(query);
    }
 
    public void execute(Database.BatchableContext BC, List<sObject> scope) {
        total += scope.size();
    }
 
    public void finish(Database.BatchableContext BC) {
        List<SOFA_Job__c> currentJob;
        SOFA_Job__c sofaJob;         
        Database.SaveResult saveRes;

        AsyncApexJob aaj = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id = :BC.getJobId()];

        System.debug('--- BatchCount FINISH --- sofaJobItemId: ' + sofaJobItemId + ' object: ' + objectAPIName + '  field: ' + fieldAPIName + '  total: ' + total);
        SOFA_JobItem__c sofaJobItem  = new SOFA_JobItem__c();
        sofaJobItem.Id               = sofaJobItemId;
        sofaJobItem.CountStart__c    = jobItemStart;
        sofaJobItem.CountStop__c     = System.Now();
        sofaJobItem.Count__c         = total;
        sofaJobItem.JobId__c         = aaj.Id;
        sofaJobItem.JobStatus__c     = aaj.Status;
        sofaJobItem.JobErrors__c     = aaj.NumberOfErrors;
        sofaJobItem.JobItems__c      = aaj.JobItemsProcessed;
        sofaJobItem.JobItemsTotal__c = aaj.TotalJobItems; 
        sofaJobItem.SOFA_JobId__c    = sofaJobId;

        // ------------------------------------------------------------------------------------------- //
        // Update SOFA_JobItem__c record
        // ------------------------------------------------------------------------------------------- //
        try {
            update sofaJobItem;
        } catch(Exception e) {
            System.debug('Error updating SOFA_JobItem__c (Id:' + sofaJobItemId + ')  ' + e.getMessage());
        }
        system.debug(' SOFA_BatchCount Finished - Apex job Item Id: ' + aaj.Id + ' Status: ' + aaj.Status + ' TotalJobItems: ' + aaj.TotalJobItems + ' Errors:  ' + aaj.NumberOfErrors + ' ItemsProcessed: ' + aaj.JobItemsProcessed );

        // ------------------------------------------------------------------------------------------- //
        // Check for queued items:
        // ------------------------------------------------------------------------------------------- //
        List<SOFA_JobItem__c> jobItems = [SELECT Id, ObjectAPIName__c, FieldAPIName__c , SOFA_JobId__c
                                          FROM SOFA_JobItem__c 
                                          WHERE JobStatus__c = 'Queued' AND ObjectAPIName__c = :objectAPIName LIMIT 1];
        if(jobItems.size() == 0) {
            System.debug('All fields for ' + objectAPIName + ' counted');
            currentJob = [SELECT Id, Count__c, JobId__c, JobStatus__c, JobErrors__c, JobItems__c, JobItemsTotal__c FROM SOFA_Job__c WHERE ObjectAPIName__c = :objectAPIName];
            if(currentJob.size() > 0) {
                // ------------------------------------------------------------------------------------------- //
                // Nothing left to do, so mark job Completed.
                // ------------------------------------------------------------------------------------------- //
                sofaJob = new SOFA_Job__c();
                sofaJob.Id            = currentJob[0].Id;
                sofaJob.JobStatus__c  = 'Completed';
                sofaJob.CountStop__c  = System.Now();
                try {
                    // Update sofaJob;
                    saveRes = Database.update(sofaJob, false);
                    if (saveRes.isSuccess()) {
                        System.debug('*****************************************************************');
                        System.debug('        Batch Count finished - updating SOFA_Job__c record');
                        System.debug( sofaJob.Id + ' Should be marked as Completed');
                        System.debug('*****************************************************************');
                        SOFA_Job__c test = [SELECT Id, JobStatus__c, CountStop__c, Count__c FROM SOFA_Job__c WHERE Id = :sofaJob.Id];
                    }
                    else {
                        for(Database.Error err : saveRes.getErrors()) {
                            System.debug('The following error has occurred.');                   
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
//                          System.debug('Account fields that affected this error: ' + err.getFields());
                        }
                    }
                } catch(Exception e) {
                    System.debug('Batch Count finished - Error updating SOFA_Job__c record. ' + e.getMessage());
                }
//                return 'all done!';
            } else {
                System.debug('Fatal Error -  SOFA_Job__c record missing!.');
            }
            system.debug(' SOFA_BatchCount Finished - ' + objectAPIName + ' ' +  fieldAPIName + ' ' + sofaJobItemId); 
        }
        else {
            sofaJobItemId = jobItems[0].Id;
            sofaJobId     = jobItems[0].SOFA_JobId__c;
            objectAPIName = jobItems[0].ObjectAPIName__c;
            fieldAPIName  = jobItems[0].FieldAPIName__c;
            System.debug('SOFA_BatchCount: making recursive batch call.....');
            Database.executeBatch(new SOFA_BatchCount(sofaJobId,objectAPIName,fieldAPIName,sofaJobItemId), 2000); 
//            String cronID = System.scheduleBatch(new SOFA_BatchCount(sofaJobId,objectAPIName,fieldAPIName,sofaJobItemId), 'Sofa Batch Count', 1, 2000);
//            CronTrigger ct = [SELECT Id, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :cronID];
//            System.debug('Next fire time: ' + ct.NextFireTime); 
        }
    }
}