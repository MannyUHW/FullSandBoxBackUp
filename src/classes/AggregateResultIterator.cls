global class AggregateResultIterator implements Iterator<AggregateResult> {

  AggregateResult [] results {get;set;}
  Integer index {get; set;} 
  String tokenStr;
  String jsonData;
  string nextUrl;

  global AggregateResultIterator(String query) {
    System.debug('AggregateResultIterator constructor');

    index   = 0;
    nextUrl = '';
    String myQuery = 'SELECT AccountId,Count(Id) cnt FROM Contact GROUP BY AccountId LIMIT 20';
    results = Database.query(myQuery);            

    tokenStr = PledgeUpCalloutHelper.getToken();
    System.debug('Got token: ' + tokenStr);

  } 

  global boolean hasNext(){ 
    PledgeUpData pledgeUpData;

  //  System.debug('hasNext:index');
  //  System.debug(index);

  //  System.debug('Still Got token: ' + tokenStr);
    jsonData = PledgeUpCalloutHelper.getAllMembers(tokenStr,nextUrl);
  //  System.debug('jsonData');
  //  System.debug(jsonData);

    pledgeUpData = PledgeUpCalloutHelper.parseData(JSON.createParser(jsonData));
    System.debug('pledgeUpData.size()');
    System.debug(pledgeUpData.LeadList.size());
    nextUrl = pledgeUpData.Next;
    if(String.IsBlank(nextUrl)) {
      System.debug('nextUrl is null (initial state)');
    } else {
      System.debug('nextUrl is: ' + nextUrl);
    }

 //   if(index < results.size()) {
 //     System.debug(results[index]);
 //   }
    if(String.IsBlank(nextUrl)) {
      System.debug('NextUrl is null, so must have all the data.');
      return false;
    }
    else {
      System.debug('More to get:  ' + nextUrl);
      return results != null && !results.isEmpty() && index < results.size(); 
    }
  }    

  global AggregateResult next(){ 
//    System.debug('next: ');
    return results[index++];            
  }       

}