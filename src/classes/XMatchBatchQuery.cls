public class XMatchBatchQuery implements Database.Batchable<sObject>, Database.Stateful {

  private String queryString,xmatchId,accountId,matchTarget,matchCode;
  Integer total = 0;

  public XMatchBatchQuery(String pId,String pAccountId,String pQuery, String pMatchTarget) {
    xmatchId    = pId;
    accountId   = pAccountId;
    queryString = pQuery;
    matchTarget = pMatchTarget;
    matchCode   = matchTarget.left(1);
    System.debug(System.Now());
    System.debug('XMatchBatchQuery - (query params:)');
    System.debug(xmatchId);
    System.debug(pQuery);
  }

  public Database.QueryLocator start(Database.BatchableContext BC) {
    XMatch__c tmpXmatchRec;

    AsyncApexJob aaj = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id = :BC.getJobId()];

    tmpXmatchRec              = new XMatch__c();
    tmpXmatchRec.Id           = xmatchId;
    tmpXmatchRec.JobStart__c  = System.Now();
    tmpXmatchRec.JobId__c     = aaj.Id;
    tmpXmatchRec.JobStatus__c = aaj.Status;
    try {
        update tmpXmatchRec;
    } catch(Exception e) {
        System.debug('Error updating tmpXmatchRec (Id:' + xmatchId + ')  ' + e.getMessage());
    }
    system.debug('Apex job Id: ' + aaj.Id + ' Status: ' + aaj.Status + ' TotalJobItems: ' + aaj.TotalJobItems + ' Errors:  ' + aaj.NumberOfErrors + ' ItemsProcessed: ' + aaj.JobItemsProcessed );

    System.debug('XMatchBatchQuery start [' + queryString + ']');
    return Database.getQueryLocator(queryString);
  }
 
  public void execute(Database.BatchableContext BC, List<sObject> scope) {
    Integer i,l;
    List<XMatched__c> XMatchedArray = new List<XMatched__c>(); 
    XMatched__c tmpXMatchedRec;
    l = scope.size();
    total += l;
    for(i=0;i<l;i++) {
      tmpXMatchedRec = new XMatched__c();
      if(matchCode == 'C') {
        tmpXMatchedRec.ContactId__c       = scope[i].Id;
      } else {
        tmpXMatchedRec.LicensureId__c     = scope[i].Id;
      }
      tmpXMatchedRec.MatchingAccountId__c = accountId;
      tmpXMatchedRec.MatchCode__c         = matchCode;
      XMatchedArray.add(tmpXMatchedRec);
    }

    // ------------------------------------------------------------------------------------------- //
    // Save XMatched__c records
    // ------------------------------------------------------------------------------------------- //
    Database.SaveResult[] srList = Database.insert(XMatchedArray, false);
    for (Database.SaveResult sr : srList) {
      if(!sr.isSuccess()) {
        for(Database.Error err : sr.getErrors()) {
          System.debug('The following error has occurred inserting XMatched__c record.');                    
          System.debug(err.getStatusCode() + ': ' + err.getMessage());
        }
      }
    }
  }
 
  public void finish(Database.BatchableContext BC) {
    String jobItemId,jobId, jobQuery;
    XMatch__c tmpXmatchRec;
    
    AsyncApexJob aaj = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id = :BC.getJobId()];

    System.debug('--- Batch Query FINISH --- : ' + queryString);
    System.debug(aaj.Id);
    System.debug(aaj.Status);
    System.debug(aaj.NumberOfErrors);
    System.debug(aaj.JobItemsProcessed);
    System.debug(aaj.TotalJobItems); 

    System.debug(aaj.CreatedBy.Email); 

    tmpXmatchRec    = new XMatch__c();
    tmpXmatchRec.Id = xmatchId;
    tmpXmatchRec.JobStatus__c = aaj.Status;
    system.debug(' XMatchBatchQuery Finished - Apex job Item Id: ' + aaj.Id + ' Status: ' + aaj.Status + ' TotalJobItems: ' + aaj.TotalJobItems + ' Errors:  ' + aaj.NumberOfErrors + ' ItemsProcessed: ' + aaj.JobItemsProcessed );

    // ------------------------------------------------------------------------------------------- //
    // Update XMatch__c status
    // ------------------------------------------------------------------------------------------- //
    try {
      update tmpXmatchRec;
    } catch(Exception e) {
      System.debug('Error updating XMatch__c (Id:' + xmatchId + ')  ' + e.getMessage());
    }

    // ------------------------------------------------------------------------------------------- //
    // Check for queued items:
    // ------------------------------------------------------------------------------------------- //
    List<XMatch__c> jobItems = [SELECT Id,JobId__c,JobQuery__c FROM XMatch__c WHERE  AccountId__c = :accountId AND MatchTarget__c = :matchTarget  AND JobStatus__c = 'Queued' LIMIT 1];   
    if(jobItems.size() == 0) {
      List <Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
      List <String> addressArray = new List <String>();
      Messaging.SingleEmailMessage singleEmail;
      String emailMsg;

      System.debug('All data for ' + queryString + ' retrieved');
      emailMsg  = '<p>Your XMatch batch job has finished.</p>';
      emailMsg += '<p>Select the Account in GOTV CC, then view the ' + matchTarget + ' XMatches tab.</p>';
      addressArray.add(aaj.CreatedBy.Email);
      singleEmail = new Messaging.SingleEmailMessage();
      singleEmail.setReplyTo('noreply@seiu-uhw.org');            
      singleEmail.setSubject('Your XMatch batch job has finished');
      singleEmail.setToAddresses(addressArray); 
      singleEmail.setHtmlBody(emailMsg);
      emailList.add(singleEmail);
      Organization orgData = [SELECT ID,INSTANCENAME,ISSANDBOX FROM Organization];
      if(!orgData.ISSANDBOX) { // Only checking done here so above code isn't ignored for test (code coverage)
        Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList);
      } else {
        System.debug('Email would have been sent to ' + addressArray[0] + ' if running in production.');
      }
    }
    else {
      jobItemId = jobItems[0].Id;
      jobQuery  = jobItems[0].JobQuery__c;
      System.debug('XMatchBatchQuery: making recursive batch call.....');
      Database.executeBatch(new XMatchBatchQuery(jobItemId,accountId,jobQuery,matchTarget), 2000);
    }
  }
}