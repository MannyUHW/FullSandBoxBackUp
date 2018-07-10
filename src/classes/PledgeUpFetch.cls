public class PledgeUpFetch implements Queueable, Database.AllowsCallouts {

  public PledgeUpFetch(String p1) {
    System.debug('PledgeUpFetch constructor');
    System.debug(p1);
  }

  public void execute(QueueableContext context) {
    System.debug('PledgeUpFetch execute!');
    String tokenStr,jsonData,nextUrl;
    Integer calloutCount;
    PledgeUpData pledgeUpData;
    HTTPResponse tokenResp,mbrResp;

    PledgeUpSchedule__c pls = [SELECT Id,NextUrl__c,CalloutCount__c FROM PledgeUpSchedule__c];
    calloutCount = (Integer) pls.CalloutCount__c;
    nextUrl = pls.NextUrl__c;

    tokenResp = PledgeUpCalloutHelper.getToken();
    tokenStr  = tokenResp.getBody();
//  tokenStr = PledgeUpCalloutHelper.getToken();
    System.debug('Got token: ' + tokenStr);

    mbrResp      = PledgeUpCalloutHelper.getAllMembers(tokenStr,nextUrl);
    jsonData     = mbrResp.getBody();
//    jsonData     = PledgeUpCalloutHelper.getAllMembers(tokenStr,nextUrl);
    pledgeUpData = PledgeUpCalloutHelper.parseData(JSON.createParser(jsonData));  // Saves Leads
    nextUrl      = pledgeUpData.Next;
    
    if(String.isBlank(nextUrl)) {
      nextUrl = null;
    } else { 
      if(nextUrl == 'null') {
        nextUrl = null;
      }
    }

    if(nextUrl == null) {
      System.debug('nextUrl is null - must have all the data!');
    } else {
      System.debug('nextUrl: ' + nextUrl);
    }

    calloutCount++;
    pls.CalloutCount__c = calloutCount;
    pls.NextUrl__c = nextUrl;

    try {
      Update pls;
      System.debug('PledgeUpSchedule__c record updated. ');
      if(nextUrl != null && calloutCount < 50) {
        ID jobID = System.enqueueJob(new PledgeUpFetch('[2] Next job enqueued (callout: ' + calloutCount + ' )' ));
        System.debug('jobID:');
        System.debug(jobID);
      }
    } catch(Exception e) {
      System.debug('Error updating PledgeUpSchedule__c record. ' + e.getMessage());
    }

  }

}