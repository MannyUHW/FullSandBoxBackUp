global class PledgeUpScheduleAt implements Schedulable {

  global void execute(SchedulableContext SC) {
    System.debug('execute() of PledgeUpScheduleAt.');
    Integer calloutCount;
    String nextUrl;
    PledgeUpSchedule__c pls = [SELECT Id,NextUrl__c,CalloutCount__c FROM PledgeUpSchedule__c];
    calloutCount = (Integer) pls.CalloutCount__c;
    nextUrl = pls.NextUrl__c;
    System.debug(pls.Id);
    System.debug(calloutCount);
    System.debug(pls.NextUrl__c);
    System.debug('***** If nextUrl != null && calloutCount < 100 ***** ');
    System.debug('ID jobID = System.enqueueJob(new PledgeUpFetch())');

    If(nextUrl != null && calloutCount < 50) {
      ID jobID = System.enqueueJob(new PledgeUpFetch('[1] Next job enqueued (callout: ' + calloutCount + ' )' ));
      System.debug('jobID:');
      System.debug(jobID);
    } else {
      // We have either got all the data, or an error has occurrec.
      // Abort
      System.debug('Schedulable Job Id: ');
      ID thisJobId = SC.getTriggerId();
      System.debug(thisJobId);
      System.debug('-- Schedulable Job Id --');
      System.abortJob(thisJobId);
      System.debug('JOB ABORTED - See you tomorrow');
    }

  }

}