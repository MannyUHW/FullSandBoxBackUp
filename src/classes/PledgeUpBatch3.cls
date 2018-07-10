public class PledgeUpBatch3 implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {

  public string nextUrl;
  private String queryString;
  String jsonData;
  List<String> data;
  JSONParser parser;
  Integer i, dataLength;
  List<Lead> leadData;
  String tokenStr;
  PledgeUpData pledgeUpData;
   
  public PledgeUpBatch3(string pTokenString, string pNextUrl) {

    if(String.IsBlank(pTokenString)) {
      tokenStr = PledgeUpCalloutHelper.getToken();
      System.debug('Got token: ' + tokenStr);
    } else {
      tokenStr = pTokenString;
      System.debug('Re-using token: ' + tokenStr);
    }

    if(String.IsBlank(pNextUrl)) {
      nextUrl = '';
      System.debug('nextUrl is null (initial state)');
    } else {
      nextUrl = pNextUrl;
      System.debug('nextUrl is: ' + nextUrl);
    }

    // This is just a convenience hack to get the batch to run once.
    queryString = 'SELECT Id FROM Contact LIMIT 1';
  } 
  
  public Database.QueryLocator start(Database.BatchableContext BC) {
    System.debug('start() of PledgeUpBatch3.');
    return Database.getQueryLocator(queryString);
  }

  public void execute(Database.BatchableContext BC, List<sObject> scope) {      
    
    System.debug('execute() of PledgeUpBatch3.');

//  tokenStr = PledgeUpCalloutHelper.getToken();
    jsonData = PledgeUpCalloutHelper.getAllMembers(tokenStr,nextUrl);
    System.debug('jsonData');
    System.debug(jsonData);

    pledgeUpData = PledgeUpCalloutHelper.parseData(JSON.createParser(jsonData));
    nextUrl = pledgeUpData.Next;
    
    System.debug('pledgeUpData (Leads to save)...');
    System.debug(pledgeUpData);

  }

  public void finish(Database.BatchableContext info){
    System.debug('finish() of PledgeUpBatch.');        
    // if(String.IsBlank(nextUrl)) {
    //   System.debug('All callouts made.');
    // } else {
    //   System.debug('PledgeUpBatch3: making recursive batch call.....');
    //   Database.executeBatch(new PledgeUpBatch3(tokenStr,nextUrl));
    // }
  }

}